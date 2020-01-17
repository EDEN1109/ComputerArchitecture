.globl main
.data
  msgprompt: .word msgprompt_data
  msgres: .word msgres_data

  msgprompt_data: .asciiz "Enter the Positive integer >> "
  msgres_data: .asciiz "Answer is "

.text
main:
  la      $t0, msgprompt    # load address of msgprompt to $t0
  lw      $a0, 0($t0)       # load word $t0 to $a0
  li      $v0, 4            # code for print string
  syscall                   # print string

  # reading the input int
  li      $v0, 5            # code for read input
  syscall                   # read input

  move    $t0, $v0          # move input to $t0
  li	  $t1, 1			# $t1 = 1, mean int i
  li	  $t3, 1			# $t3 = 1, mean Answer

loop:
  mul     $t3, $t3, $t1			# $t3 = $t3*$t1, answer = answer*i

  beq	  $t0, 0, returnOne		# if input is 0, answer is 1
  beq	  $t1, $t0, result		# if $t1(i) equal $t0(input), return answer and exit program

  addi	  $t1, $t1, 1			# i++

  j		  loop

result:
  # print answer to user
  la      $t1, msgres       # load msgres to $t1
  lw      $a0, 0($t1)       # load msgres_data to $a0
  li      $v0, 4            # code for print string
  syscall                   # print msgres_data

  move    $a0, $t3          # move answer $t3 to $a0
  li      $v0, 1            # code for print int
  syscall                   # print answer

  addi    $sp, $sp, 12      # move stackpointer 12

  # end program
  li      $v0, 10           # code for exit
  syscall                   # exit

returnOne:
  li      $t1, 1            # load 1 to $t0
  j       result            # return answer and exit program