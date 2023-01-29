# This example demonstrates an implementation of  matrix chain multiplication
# Please find the minimum number of multiplication needed to multiply a chain of matrix
# We provided one string in global for simplify.
# The ouput of test pattern 1 should be => Minimum number of multiplications is: 30
# The ouput of test pattern 2 should be => Minimum number of multiplications is: 240
# Reference link : https://www.geeksforgeeks.org/matrix-chain-multiplication-dp-8/?ref=gcse

.data
.align 4
# test pattern 1
Matrix_array: .word 1, 2, 3, 4, 3
Number_of_matrix: .word 5
# test pattern 2
#Matrix_array: .word 5, 7, 3, 4, 5
#Number_of_matrix: .word 5
str1: .string "Minimum number of multiplications is "

.text
.global _start

# Start your coding below, don't change anything upper.
# i in x5
# j in x6
# k in x7
# L in x8
# q in x9
# Matrix_array address in x10
# size,n in x11
# m[][] base address in x12

# temp after x20

#cmd:& $env:RV64_GCC_PATH\riscv64-unknown-elf-gcc.exe -march=rv64im -mabi=lp64 -s -static -nostdlib -o matrix.elf Matrix_template.S

_start:
    la x10, Matrix_array        #load Matrix_array address to x10
    lw x11, Number_of_matrix    #load Number_of_matrix to size

    jal x1, MatrixChainOrder    #call the function

MatrixChainOrder:
    mul x20, x11, x11   #need to allocate x20 = n*n elements
    slli x20, x20, 2    #each element is 4 bytes
    addi x21, x0, -1    #x21 = -1
    mul x20, x20, x21   #x20 *= -1

    add x12, x2, x0     #record the base address of m[][]
    add x2, x2, x20     #allocate m[n][n]

    addi x5, x0, 1      #set i = 1
init:
    bge x5, x11, init_exit  #if i >= n, exit loop

    # m[i][i] = m[i*n + i]
    add x21, x0, x0     #set x21 = 0 before use
    mul x21, x5, x11    #x21 = i*n
    add x21, x21, x5    #x21 = i*n + i
    slli x21, x21, 2    #each element is 4 bytes
    add x21, x12, x21   #x21 = address of m[i][i]
    sw x0, 0(x21)       #m[i][i] = 0

    addi x5, x5, 1      #i += 1
    jal x0, init        #repeat init loop

init_exit:
    addi x8, x0, 2      #L = 2
loop1:
    bge x8, x11, loop1_exit     #if L >= n, exit loop1
    
    addi x5, x0, 1      #set i = 1 before entering loop2
loop2:
    sub x20,x11,x8      #x20 = n - L
    addi x20, x20, 1    #x20 = n - L + 1
    bge x5, x20, loop2_exit     #if i>= n-L+1, exit loop2

    add x6, x5, x8      #j = i + L
    addi x6, x6, -1     #j = i+L-1

    #m[i][j] = m[i*n+j]
    add x21, x0, x0     #set x21 = 0 before use
    mul x21, x5, x11    #x21 = i*n
    add x21, x21, x6    #x21 = i*n+j
    slli x21, x21, 2    #each element is 4 bytes
    add x21, x21, x12   #address of m[i*n+j] = m[i][j]
    addi x22, x0, 999   #x22 = 999
    sw x22, 0(x21)      #m[i][j] = INT_MAX

    add x7, x5, x0      #set k = i before entering loop3

loop3:
    addi x21, x0, -1    #x21 = -1
    add x21, x21, x6    #x21 = j-1
    bgt x7, x21, loop3_exit     #if k > j-1, exit loop

    #m[i][k] = m[i*n + k] => value in x22
    add x21, x0, x0     #set x21 = 0 before use
    mul x21, x5, x11    #x21 = i*n
    add x21, x21, x7    #x21 = i*n+k
    slli x21, x21, 2    #each element is 4 bytes
    add x21, x21, x12   #address of m[i*n+k] = m[i][k]
    lw x22, 0(x21)      #x22 = m[i][k]

    #m[k + 1][j] = m[(k+1)*n + j] => value in x23
    addi x21, x7, 1     #set x21 = k+1 before use
    mul x21, x21, x11   #x21 = (k+1)*n
    add x21, x21, x6    #x21 = (k+1)*n + j
    slli x21, x21, 2    #each element is 4 bytes
    add x21, x21, x12   #address of m[(k+1)*n + j] = m[k+1][j]
    lw x23, 0(x21)      #x23 = m[k+1][j]
    
    #Matrix_array[i - 1] => value in x24
    addi x21, x5, -1     #set x21 = i-1 before use
    slli x21, x21, 2    #each element is 4 bytes
    add x21, x21, x10    #x21 = address of Matrix_array[i - 1]
    lw x24, 0(x21)       #x24 = Matrix_array[i - 1]

    #Matrix_array[k] => value in x25
    add x21, x7, x0      #set x21 = k before use
    slli x21, x21, 2     #each element is 4 bytes
    add x21, x21, x10    #x21 = address of Matrix_array[k]
    lw x25, 0(x21)       #x25 = Matrix_array[k]

    #Matrix_array[j] => value in x26 (note:p=Matrix_array)
    add x21, x6, x0      #set x21 = j before use
    slli x21, x21, 2     #each element is 4 bytes
    add x21, x21, x10    #x21 = address of Matrix_array[j]
    lw x26, 0(x21)       #x25 = Matrix_array[j]


    #p[i - 1] * p[k] * p[j] value in x24
    mul x24,x24,x25     #x24 = p[i - 1] * p[k]
    mul x24,x24,x26     #x24 = p[i - 1] * p[k] * p[j]

    #m[i][k] + m[k + 1][j] + p[i - 1] * p[k] * p[j] value in x22
    add x22, x22, x23   #x22 = m[i][k] + m[k + 1][j]
    add x22, x22, x24   #x22 = m[i][k] + m[k + 1][j] + p[i - 1] * p[k] * p[j]

    add x9, x22, x0     #q = m[i][k] + m[k + 1][j] + p[i - 1] * p[k] * p[j]
check:
    #m[i][j] = m[i*n+j]
    add x21, x0, x0     #set x21 = 0 before use
    mul x21, x5, x11    #x21 = i*n
    add x21, x21, x6    #x21 = i*n+j
    slli x21, x21, 2    #each element is 4 bytes
    add x21, x21, x12   #address of m[i*n+j] = m[i][j]
    lw x25, 0(x21)      #x25 = m[i][j]
    bge x9, x25, check_exit     #if q >= m[i][j], exit check
    sw x9, 0(x21)       #m[i][j] = q


check_exit:
    addi x7, x7, 1      #k += 1
    jal x0, loop3       #repeat loop3
loop3_exit:
    addi x5, x5, 1      #i += 1
    jal x0, loop2       #repeat loop2
loop2_exit:
    addi x8, x8, 1      #L += 1
    jal x0, loop1       #repeat loop1
loop1_exit:
    #return m[1][n - 1] = m[1*n + n-1] = m[2*n - 1]
    add x21, x0, x0     #set x21 = 0 before use
    slli x21, x11, 1    #x21 = 2*n
    addi x21, x21, -1   #x21 = 2*n - 1
    slli x21, x21, 2    #each element is 4 bytes
    add x21, x21, x12   #x21 = address of m[2*n - 1] = m[1][n-1]
    lw x31, 0(x21)      #final answer at x31

    la a0, str1     # print the string
    li a7, 4
    ecall
    mv a0, x31      # Move final ans to a0
    li a7, 1
    ecall