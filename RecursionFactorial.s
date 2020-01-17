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
  move    $a0, $t0          # move input to $a0
  addi    $sp, $sp, -12     # move stackpointer -12
  sw      $t0, 0($sp)       # store word input in first of stack
  sw      $ra, 8($sp)       # store word $ra to 8 of stack
  jal     factorial         # call factorial

  # answer in 4($sp)
  lw      $s0, 4($sp)       # load answer to $s0

  # print answer to user
  la      $t1, msgres       # load msgres to $t1
  lw      $a0, 0($t1)       # load msgres_data to $a0
  li      $v0, 4            # code for print string
  syscall                   # print msgres_data

  move    $a0, $s0          # move answer $s0 to $a0
  li      $v0, 1            # code for print int
  syscall                   # print answer

  addi    $sp, $sp, 12      # move stackpointer 12

  # end program
  li      $v0, 10           # code for exit
  syscall                   # exit

.text
factorial:
  lw      $t0, 0($sp)       # load input first of stack to $t0
  
  beq     $t0, 0, returnOne # if $t0 is 0, call returnOne
  addi    $t0, $t0, -1      # if $t0 is not 0, $t0 is -1

  # recursive
  addi    $sp, $sp, -12     # move stackpointer -12
  sw      $t0, 0($sp)       # store word current number $t0 to first of the stack
  sw      $ra, 8($sp)       # store $ra to 8 of stack

  jal     factorial         # recursive call factorial

  # child method return in 4($sp)
  lw      $ra, 8($sp)       # load 8 of stack to $ra
  lw      $t1, 4($sp)       # load 4 of stack to $t0, 4($sp) is child's return
  lw      $t2, 12($sp)      # load 12 of stack to $t2, 12($sp) is parent's start value

  mul     $t3, $t1, $t2     # $t3 = $t1*$t2
  sw      $t3, 16($sp)      # store $t3 to 16 of stack, 16($sp) is parent's return value.
  addi    $sp, $sp, 12      # move stackpointer 12

  jr      $ra               # return

.text
returnOne:
  li      $t0, 1            # load 1 to $t0
  sw      $t0, 4($sp)       # store 1 to 4 of stack, 4($sp) is parent's return
  jr      $ra               # return