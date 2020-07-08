#Translating C Code to Assembly


#This programs  sums the values in a list using a for loop

#-----------------------In C--------------------------
#for (int i = 0, sum = 0; i < len; ++i)
#	sum += x[i]



#---------------Translating to Assembly---------------

.global _start #_start is where the instruction begins
.equ ws, 4 #Similar to #DEFINE WS 4
.equ x_len, 10
.equ sum, %ecx

.data
x:
	.rept x_len
		.long 5*2+2
	.endr

.text

_start:
#ecx is i, eax is sum

	movl $0,  %ecx #i = 0
	movl $0, %eax #sum = 0
	start_for:
		#At the begining of the for loop we check the condition, 
#i < x_len == i - x_len < 0 == (negation of this) i - x_len >= 0
		cmpl $x_len, %ecx
#if the last condition is true meaning the loop is reach is end because we did the negation
		jge end_for
#otherwise we add the sum of each element
#our array x is constant in memory so is our displacement
		addl x(, %ecx, ws), %eax #sum += x[i]
#after we add the element, increment i and then go back to the begining of the loop 
		incl %ecx
 		jmp start_for
end_for:

done:
	nop











