.global _start
.equ ws, 4
.data

num1:
	.long -1
	.long -1
 
num2:
	.long -1
	.long -1

.text
_start:
#upper 32 bits sum is EDX, lower 32 bit sum is EAX
	movl num1, %edx #upper 32 bit of num1
	addl num2, %edx #upper 32 bit of num2

	movl num1+ws, %eax #this will give me lower 32bit of num1
	addl num2+ws, %eax #add lower bits of num1 and num2
	jc if_carry
	if_carry:
		#if lower bit are negative
		cmpl $0, %eax #sum_low < 0 == sum_low >= 0 
		jge done
		incl %edx
done:
	nop


