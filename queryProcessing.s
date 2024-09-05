.data
array : .space 40000
newline : .asciiz "\n"
          .align 2
minusone : .word 0
    
.text
.globl main
main:
# reading N
# la $a0,array
li $v0,5
syscall
move $s0,$v0                                        # s0 = n
mul $s0,$s0,4                                       # s0 = total memory of array

# reading array elements
li $t1,0 # indexing
j for1

for1:
beq $t1,$s0,heap_sort
li $v0,5
syscall
sw $v0,array($t1)
addi $t1,$t1,4
j for1





####################### HEAP SORT ######################

heap_sort:
move $t0,$s0                                       # t0 = i
srl $t1, $t0, 3
sll $t0, $t1, 2
addi $t0,$t0,-4                                    # t0 = n/2 - 1
j firstfor

firstfor:
blt $t0,$zero,second
move $t1,$t0 # heapify(arr,$t3,$t1)                 # t1 = i
move $t3,$s0                                        # t3 = n
addi $t0,$t0,-4
j heapify



################ HEAPIFY ######################

heapify:
move $s2,$t1                                            # s2 = largest = i
sll $t2,$t1,1
addi $t2,$t2,4                                          # t2 = l = 2*i+1
addi $s3,$t2,4                                          # s3 = r = 2*i+2
blt $t2,$t3,Acond_for_firstif
j condfor_secondif


Acond_for_firstif:
lw $s4,array($t2)                                       # arr[left]
lw $s5,array($s2)                                       # arr[largest]
bgt $s4,$s5,execute_firstif
j condfor_secondif


execute_firstif:
move $s2,$t2
j condfor_secondif


condfor_secondif:
blt $s3,$t3,Acond_for_secondif
j condfor_thirdif

Acond_for_secondif:
lw $s6,array($s3)                                      # arr[right]
lw $s7,array($s2)                                      # arr[largest]
bgt $s6,$s7,execute_secondif
j condfor_thirdif


execute_secondif:
move $s2,$s3
j condfor_thirdif

condfor_thirdif:
bne $s2,$t1,execute_thirdif #if largest != i 
j firstfor


execute_thirdif:
lw $t4,array($t1)
lw $t5,array($s2)
sw $t5,array($t1)
sw $t4,array($s2)
move $t1,$s2
j heapify

########################### second for loop #############################



second:
move $t0,$s0                      # t0 = i
addi $t0,$t0,-4                   # t0 = i = n - 1
li $t8, 0
j secondfor

secondfor:
blt $t0,$zero,q_input
lw $a0,array($zero)
lw $a1,array($t0)
sw $a1,array($zero)
sw $a0,array($t0)                # swapping array[0] and array[i]
move $t3,$t0                      # for heapify
move $t1,$zero 
addi $t0,$t0,-4
j heapify2





########################### heapify2 ######################################

heapify2:
move $s2,$t1                                            # s2 = largest = i
sll $t2,$t1,1
addi $t2,$t2,4                                          # t2 = l = 2*i+1
addi $s3,$t2,4                                          # s3 = r = 2*i+2
blt $t2,$t3,Acond_for_firstif2
j condfor_secondif2


Acond_for_firstif2:
lw $s4,array($t2)                                       # arr[left]
lw $s5,array($s2)                                       # arr[largest]
bgt $s4,$s5,execute_firstif2
j condfor_secondif2


execute_firstif2:
move $s2,$t2
j condfor_secondif2


condfor_secondif2:
blt $s3,$t3,Acond_for_secondif2
j condfor_thirdif2

Acond_for_secondif2:
lw $s6,array($s3)                                      # arr[right]
lw $s7,array($s2)                                      # arr[largest]
bgt $s6,$s7,execute_secondif2
j condfor_thirdif2


execute_secondif2:
move $s2,$s3
j condfor_thirdif2

condfor_thirdif2:
bne $s2,$t1,execute_thirdif2                           #if largest != i 
j secondfor


execute_thirdif2:
lw $t4,array($t1)
lw $t5,array($s2)
sw $t5,array($t1)
sw $t4,array($s2)
move $t1,$s2
j heapify2



############################# Q_input ##################################
q_input:
#reading q
li $v0,5
syscall
move $s1,$v0                                         # s1 = q
sll $s1,$s1,2                                        # s1 is the total memory of the query array
# reading q_array
li $t1,0                                             # indexing in q_arr
j for2

for2:
beq $t1,$s1,exit2
li $v0,5
syscall
move $t6,$v0                                         # input stored in $t6
j binary_search
# addi $t1,$t1,4


################################ Binary search ########################

binary_search:
li $s3,-1
move $t2,$s0  
addi $t2,$t2,-4                                     # high = n-1 ( or say 4n-4 here)
move $t3,$zero                                      # low = 0
j bs_while
bs_while:
bgt $t3,$t2,print_nos                                # low <= high
add $t4,$t3,$t2                                      # low + high
srl $a0,$t4,3                                        # mid = (low + high)/2
sll $t4,$a0,2
lw $t5,array($t4)
beq $t5,$t6,return_bs1
blt $t5,$t6,return_bs2
bgt $t5,$t6,return_bs3

return_bs1:
move $s3,$t4                                          # storing mid in $s3
srl $s3,$s3,2
j print_nos
return_bs2:
addi $t4,$t4,4
move $t3,$t4                                          # low = mid+1
j bs_while
return_bs3:
addi $t4,$t4,-4                                       # high = mid-1
move $t2,$t4
j bs_while





################################## print no.s less than that query  #################################3


print_nos:
move $a0,$s3
li $v0,1
syscall
la $a0,newline
li $v0,4
syscall
add $t1,$t1,4
j for2



exit2:
li $v0,10
syscall
