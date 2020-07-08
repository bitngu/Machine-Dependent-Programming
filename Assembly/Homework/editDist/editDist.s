.global _start

.equ ws, 4


.data

#Remember to change the .string to make space for 101 bytes
#ie .space 101
string1:
	.space 101

string2:
	.space 101

oldDist:
	.space ws*101 #i think i could just do .long 101

curDist:
	.space ws*101

temp1:
	.space ws*101

#ARG1 for the min Function
min_a:
	.long 0

#ARG2 for the min Function
min_b:
	.long 0

min_eax:
	.long 0

min_ebx:
	.long 0

#Return address for min Function
min_EAX_ret:
	.long 0


#Argument for strlen Function
strlen_str:
	.long 0

strlen_EAX:
	.long 0

strlen_ECX:
	.long 0

strlen_ret:
	.long 0

#Arguments for swap FUNCTION

swap_EAX:
	.long 0

swap_EBX:
	.long 0

swap_ECX:
	.long 0

.text

#Min Function
min: #min(int a, int b)
	#Let the function be responsible for keeping track of the registers
	#Caller must pass arguments through memory

	#Let EAX be a
	#Let EBX be b
	#Let min_ret be the return value

	#Store values of eax and ebx to memory
	movl %eax,  min_eax
	movl %ebx, min_ebx

	#Move arguments to registers
	movl min_a, %eax
	movl min_b, %ebx

	#if (a<b) == if (a - b < 0) == if (a-b >=0)
	min_if:
		cmpl %ebx, %eax
		jge min_else
		jmp min_ret 
	min_else:
		movl %ebx, %eax
	
	min_ret:
		#Place the return value to return address	
		movl %eax, min_EAX_ret

		#Restoring registers
		movl min_eax, %eax
		movl min_ebx, %ebx	
		ret

#strlen FUNCTION
strlen: #strlen(char* str)
	#Let the function be responsible for keeping track of the registers
	#Caller must pass arguments through memory
	
	movl %eax, strlen_EAX
	movl %ecx, strlen_ECX
	
	#Let EAX be str
	#Let ECX be len
	movl strlen_str, %eax
	movl $0, %ecx
	
	#for (len = 0; str[len] != '\0'; ++len);

	strlen_for_start:
		cmpb $0, (%eax, %ecx) #str[len] != '\0'
		je strlen_for_end
		incl %ecx
		jmp strlen_for_start

	strlen_for_end:
		#Place my len into my return address, strlen_ret
		movl %ecx, strlen_ret
		
		#Restore EAX and ECX
		movl strlen_EAX, %eax
		movl strlen_ECX, %ecx

		#return to where I'm called, 
		ret



#Swap FUNCTION
swap: #swap(int **a, int **b)

	#Let the function be responsible for keeping track of the registers
	#Caller must pass arguments through memory
	
	movl %ebx, swap_EBX
	movl %ecx, swap_ECX

	#Don't like swapping, too much overhead, and i like to keep my registers the same
	
	#Copying values from oldDist to curDist

/*
temp1 = oldDist
for (i = 0; i <= word2_len; ++i){
	oldDist[i] = curDist[i]
	curDist[i] = temp1[i]
*/
	#Let ECX be i
	#Let EAX be temp1 = oldDist
	#Let EBX be the temp value stored

	movl $0, %ebx #not neccesarry but i like to be consistent
	movl $0, %ecx
	#Making a copy of oldDist that is stored in memory of temp1
	temp1_for_start:
		cmpl %esi, %ecx
		jg temp1_for_end
		movl oldDist(, %ecx, ws), %ebx
		movl %ebx, temp1(, %ecx,ws)
		incl %ecx
		jmp temp1_for_start
	temp1_for_end:
	
	movl $0, %ebx 
	movl $0, %ecx

	
	swap_for_start:
	# i <= word2_len == i - word2_len <= 0 == 
	#negation  i - word2_len > 0
		cmp %esi, %ecx
		jg swap_for_end
		#oldDist[i] = curDist[i]
		movl curDist(, %ecx, ws), %ebx
		movl %ebx, oldDist(, %ecx, ws)
		#curDist[i] = temp1[i]
		movl temp1 (, %ecx, ws), %ebx
		movl %ebx, curDist(, %ecx,ws)
		incl %ecx #++i
		jmp swap_for_start
	swap_for_end:
	movl swap_EBX, %ebx
	movl swap_ECX, %ecx
	ret 
	
_start:
	#int word1_len = strlen(word1);
	#Let EDI be word1_len
	movl $string1, strlen_str
	call strlen
	movl strlen_ret, %edi
	
  	#int word2_len = strlen(word2)
	#Let ESI be word2_len
	movl $string2, strlen_str
	call strlen
	movl strlen_ret, %esi

	#for(i = 0; i < word2_len + 1; i++){
	#    oldDist[i] = i;
	#   curDist[i] = i;
	#}
	
	#Let ECX be i
	movl $0, %ecx
	substring_init_for_start:
		# i < word2_len + 1 ==   i <= word2_len == i > word2_len
		# i - word2_len > 0
		cmpl %esi, %ecx
		jg substring_init_for_end
		movl %ecx, oldDist(, %ecx, ws) #oldDist[i] = i;
		movl %ecx, curDist(, %ecx, ws) #curDist[i] = i;

		incl %ecx
		jmp substring_init_for_start
	substring_init_for_end:
	
	#for(i = 1; i < word1_len + 1; i++){
		#Let ECX be i
		#EDI is word1_len
	movl $1, %ecx # i = 1
	outer_for_start:
	#i < word1_len+1 == i <= word1_len == i - word1_len <= 0 
	#negation: i - word1_len > 0 
		cmpl  %edi, %ecx
		jg outer_for_end
		#curDist[0] = i;
		movl %ecx, curDist #i think curDist == curDist[0] because
				#if i wanted curDist[i] == curDist(, %ecx,ws)
				#or if i wnated curDist[i+1] == curDist+1*ws(, %ecx, ws)
	
		#for(j = 1; j < word2_len + 1; j++)	
			#Let EDX be j
			#ESI is word2_len
		movl $1, %edx
		inner_for_start:
			#j < word2_len + 1 == j <= word2_len == j - word2_len <=0
			#negation: j - word2_len > 0
			cmpl %esi, %edx
			jg  inner_for_end

			#if(word1[i-1] == word2[j-1])
			main_if:
				#word1[i-1] == string1[i-1] == string1-1*ws(, %ecx, ws)
				#IS THIS CORRECT OR string-1(, %ecx) because we're accesing bytes
				#word2[j-1] = string2[j-2] == string2-1*ws(, %edx, ws)
		
				#Let EAX be the place holder for string1 - string2

#---------------------------------------------------
				movb string1-1 (, %ecx), %al #EAX = word1[i-1]
				subb string2-1(,%edx), %al  #EAX = word2[j-1]
	
				cmpb $0, %al #word[i-1] - word2[j-1] == '\0'
				#negation: #word[i-1] - word2[j-1] != '\0' 
				jne main_else
				#curDist[j] = oldDist[j - 1]
				#Let EBX be oldDist[j-1]
				movl oldDist-1*ws(, %edx, ws) , %ebx #ebx = oldDist[j-1]
				movl %ebx, curDist(, %edx, ws)#curDist[j] = ebx
				incl %edx
				jmp inner_for_start

			main_else:
				#curDist[j] = min( min(oldDist[j], curDist[j-1]), oldDist[j-1]) + 1
				#min(oldDist[j], curDist[j-1])
				#Let EAX be oldDist[j]
				#Let EBX be curDist[j-1]
				movl oldDist(, %edx, ws), %eax
				movl curDist-1*ws(, %edx, ws), %ebx
				movl %eax, min_a
				movl %ebx, min_b
				call min
				movl min_EAX_ret, %eax #Let EAX be the return value for
									# min(oldDist[j], curDist[j-1])
				#Let EBX be oldDist[j-1] + 1
				movl oldDist-1*ws(,%edx, ws) , %ebx #EBX = oldDist[j-1]
				movl %eax, min_a
				movl %ebx, min_b
				call min
				movl min_EAX_ret, %eax #Let EAX be the return value for
				#min( min(oldDist[j], curDist[j-1]), oldDist[j-1])

				addl $1, %eax #EAX = min( min(oldDist[j], curDist[j-1]), oldDist[j-1]) + 1
				
				movl %eax, curDist(, %edx, 4)	#curDist[j] = EAX		 
				incl %edx
				jmp inner_for_start

		inner_for_end:	
		#swap(&oldDist, &curDist)

#Below lines of code are not neccssary since oldDist and curDist are in memory, we don't have to pass it through
#		movl $oldDist, %eax #this seems to not pass the entire array
#		movl $curDist, %ebx
#		movl %eax, swap_arg1
#		movl %ebx, swap_arg2
		call swap
		
		incl %ecx #++i
		jmp outer_for_start
	outer_for_end:
	#dist = oldDist[word2_len]
	movl oldDist(, %esi, ws), %eax

done:
	nop





