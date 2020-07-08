.global _start

.data

dividend:
	.long 7

divisor:
	.long 3

quotient:
	.long 0

remainder:
	.long 0

arg1_countNumBits:
	.long 0

countNumBits_ret:
	.long 0

countNumBits_EAX:
	.long 0

countNumBits_ECX:
	.long 0

hold:
	.long 0

.text

#FUNCTION 
countNumBits:

#Before using the registers, we need to make sure to recover its original values
	movl %eax, countNumBits_EAX
	movl %ecx, countNumBits_ECX

#Let ECX be the count
	movl $0, %ecx #    unsigned int numBits = 0

#Let EAX be the argument arg1_countNumBits
	movl   arg1_countNumBits, %eax

 #while (value != 0) == while (value == 0)
	countNumBits_while_start:
		cmpl $0, %eax
		je countNumBits_while_end
		shr $1, %eax #eax = eax >> 1
		incl %ecx #++count
		jmp countNumBits_while_start
	countNumBits_while_end:
	#move the count to the return address
	movl %ecx, countNumBits_ret #return count
	#restore the registers
	movl countNumBits_EAX, %eax
	movl  countNumBits_ECX, %ecx
	ret


_start:

#Call our function for dividend, first pass parameters
	movl dividend, %eax
	movl %eax, remainder
	movl %eax, arg1_countNumBits
	call countNumBits
	movl countNumBits_ret, %edi

#Call our function again for divisor
	movl divisor, %eax
	movl %eax, arg1_countNumBits
	call countNumBits
	movl countNumBits_ret, %esi

#Let EDI represent the number of bits for the dividend
#Let ESI represent the number of bits for the divisor
	

#for (unsigned int i = numBitsDivisor; i <= numBitsDividend  ; ++i) {

#i = NumBitsDivisor 	== ESI = NumBitsDivisor

for_start:
	#numBitsDivisor <= numBitsDividend == ESI - EDI <=0
	cmpl %edi, %esi #ESI -EDI > 0
	jg for_end
	#I pass the requirement for the loop
	
	#if (den > num >> (numBitsDividend-i))
	#if (divisor > dividend >> (EDI - ESi))
	if: 
		#(EDI - ESI)
		#Let EAX be the difference bettwen EDI and ESI
		movl %edi, %eax
		subl  %esi, %eax

		#dividend >> (EDI - ESI)
		#Need %cl to shift
		movl %eax, %ecx
		#Let EAX be the dividend
		movl dividend, %eax
		shr %cl, %eax
		#if {divisor > dividend >> (EDI - ESi)}
		#if {divisor - [dividend >> (EAX)] <= 0
		#Let EBX be the divisor
		movl divisor, %ebx
		cmpl  %eax, %ebx
		jle else
		#ans = ans << 1
		#quotient = quotient << 1
		#Let EAX be the quotient
		movl quotient, %eax
		shl $1, %eax		
		movl %eax, quotient
		incl %esi
		jmp for_start


else:
		#ans = ans << 1
		#quotient = quotient << 1
		#Let EAX be the quotient
		movl quotient, %eax
		shl $1, %eax		
		 #ans |= 1
		or $1, %eax
		movl %eax, quotient

		#temp = (num >> (numBitsDividend-i)) - den;
		#(numBitsDividend-i)) == EDI - ESI
		#Let EAX be the difference for EDI and ESI
		movl %edi, %eax
		subl  %esi, %eax

		#num >> (numBitsDividend-i)
		#dividend >> (EDI - ESi)
		#Need %cl to shift
		movl %eax, %ecx
		#Let EAX be the dividend
		movl dividend, %eax
		shr %cl, %eax
		#(num >> (numBitsDividend-i)) - den
		#Let EBX be the divisor
		#Let eax be the difference between  shifted dividend and den
		movl divisor, %ebx
		subl %ebx, %eax

		#temp  = temp << (numBitsDividend-i);
		#EAX = EAX << cl
		shl %cl, %eax
		
		 #temp |= num & (((uint32_t) pow(2,numBitsDividend-i))-1)
		#temp |= dividend & (2^(cl)-1)
		#EAX |= dividend & (2^(cl) -1)
		
		#(2^(cl) -1) == for (int k = 0; k < cl; ++k)
		#Let EBX hold the place of CL
		#Let CL hold the place for K
		movl %ecx, %ebx
		movl $0, %ecx
		#Let  ESI (numBitsDivisor) to memory to hold
		movl %esi, hold
		movl $1, %esi
		bit_for_start:
			#K < CL == K - CL < 0 == K - CL >= 0 == ECX - EBX >=0
			cmpl %ebx, %ecx			
			jg bit_for_end

			movl $1, %esi
			 #z = z | (1<<k) == EAX = EAX | 1 << K
			shl %cl, %esi
			incl %ecx 
			jmp bit_for_start
		bit_for_end:
		
		subl $1, %esi

		#ESI now holds the bit pattern 0b11.... or 2^n-1
		#Let EBX be the dividend
		
		#num & (((uint32_t) pow(2,numBitsDividend-i))-1)
		movl dividend, %ebx
		and %esi, %ebx
		#temp |= num & (((uint32_t) pow(2,numBitsDividend-i))-1);
		or %ebx, %eax

		#restore the register and update dividend
		movl %eax, dividend
		movl hold, %ebx
		#ESI now has the value of numBitsDivisor
		movl %ebx, %esi 
		
	incl %esi #++i
	jmp for_start

for_end:
	special_if:
		#if divdend == 0 { remainder =0}
		movl dividend, %edx
		cmpl $0, %edx
		jne special_else
		movl  $0, %edx
		movl quotient, %eax
	special_else:
		movl dividend, %edx
		movl quotient, %eax
		

done:
	nop

