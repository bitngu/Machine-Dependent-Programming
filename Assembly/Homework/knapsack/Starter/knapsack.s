
.global knapsack
.equ ws, 4


.text

max: #unsigned int max(unsigned int a, unsigned int b)
	max_prologue:
		push %ebp
		movl %esp, %ebp
	#No local variables
	#Stack
	#b + 3
	#a + 2
	#return address (knapsack's)  +1
	#ebp + 0 
	
	.equ a, (ws*2)
	.equ b, (ws*3)
	
	#Let ECX be a
	movl a(%ebp), %ecx
	#Let EDX be b
	movl b(%ebp), %edx
	
	max_if:
		#if (a > b) == if (a - b) >0
		#Negation: if (a-b) <= 0
		cmpl %edx, %ecx
		jbe max_else
		movl %ecx, %eax
		jmp max_epilogue
		
	max_else:
		movl %edx, %eax
		jmp max_epilogue

	max_epilogue:
		movl %ebp, %esp
		pop %ebp
		ret
		
	
	

knapsack:
#unsigned int knapsack(int* weights, unsigned int* values, unsigned int num_items, 							int capacity, unsigned int cur_value)
	knapsack_prologue:
		push %ebp
		movl %esp, %ebp
		subl $ws*2, %esp
		#If i need to make space for registers
		push %ebx
		
		#Stack
		#unsigned int cur_value +6
		#int capacity +5
		#int num_items +4
		#unsigend int* values +3
		#int* weights +2
		#return address (main's) + 1 
		#ebp + 0
		#i - 1
		#best_value - 2
		#old_ebx - 3

		
		.equ cur_value, (ws*6)
		.equ capacity, (ws*5)
		.equ num_items, (ws*4)
		.equ values, (ws*3)
		.equ weights, (ws*2)
		.equ i, (ws*-1)
		.equ best_value, (ws*-2)
		.equ old_ebx, (ws*-3)
		
		#unsigned int best_value = cur_value;
		
		#Let EAX be best_value
		movl cur_value(%ebp), %eax
		
		#Let ECX be i
		movl $0, %ecx
		for_start:
			#for(i = 0; i < num_items; i++){
			#Negation: i - num_items >= 0
			cmpl num_items(%ebp), %ecx
			jae for_end #if my for loop condition is not met, I exit
			knapsack_if:
				#if(capacity - weights[i] >= 0 ){
				
				#Let EDX be weight
				movl weights(%ebp), %edx
				movl (%edx, %ecx, ws), %edx #edx = weights[i]
				#Negation: capacity - weights[i] < 0
				cmpl %edx, capacity(%ebp)
				jb knapsack_else #If my condition is not met I go back to my for loop
				
#best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1, capacity - weights[i], cur_value + values[i]))

#knapsack(weights + i + 1, values + i + 1, num_items - i - 1, capacity - weights[i], cur_value + values[i])
				
				#cur_value + values[i]
				#Let EBX be values
				movl values(%ebp), %ebx #ebx = values
				movl (%ebx, %ecx, ws), %ebx #ebx = values[i]
				addl cur_value(%ebp), %ebx #ebx = cur_value + values[i]
				push %ebx #ebx is now on the stack
				
				#EBX = cur_value + values[i] on the STACK, and the register is no longer needed
				#capacity - weights[i]
				
				#I don't want to mess with edx even though it contains weight. Actually, I don't need EDX 					anymore
				#Let EBX be capacity
				movl capacity(%ebp), %ebx #ebx = capacity
				subl  %edx, %ebx #ebx = capacity - weights[i]
				push %ebx
				
				#EBX = capacity - weights[i] on the STACK, and the register is no longer needed
				
				#num_items - i - 1 
				#Let EBX be num_items
				movl num_items(%ebp), %ebx #ebx = num_items 
				subl %ecx, %ebx # ebx = num_items - i
				subl $1, %ebx #ebx = num_items - i - 1
				push %ebx
				
				#EBX = num_items - i on the stack, and the register is no longer needed
				
				#values + i + 1; values is a pointer so i need to do pointer arithmetic
				#I
				#Let EBX be values
				#I think I did took the definition of leal too literal
				#It should be &values[i+1] == 1*ws(
				movl values(%ebp), %ebx #ebx = values
				leal 1*ws(%ebx, %ecx, ws), %ebx # ebx = &values[i+1]
				push %ebx
				
				#EBX = &values[ i + 1 ] on the stack and the register wsis no longer needed

				
				#weights + i + 1 == &weights[i+1]
				#Let EBX be weights
				movl weights(%ebp), %ebx #ebx  = weights
				leal 1*ws(%ebx, %ecx, ws), %ebx #ebx = &weights[i+1]
				push %ebx
				
				#EBX = &weights [i + 1] on the stack and the register is no longer needed
				
				#So I have pushed all the arguments for knapsack on to the stack, so I need to call but
				#before I call the function I need to save my local variables before they get updated
		
				#Since I care about EAX=best_value, ECX= i, I will save them. I don't need to save EDX
				
				#EAX
				movl %eax, best_value(%ebp)
				
				#ECX
				movl %ecx, i(%ebp) 
				
				#Call knapsack
				call knapsack #knapsack's return value is in eax
				
				#Clean up the stack for the knapsack FUNCTION, there were 5 args so 5*ws
				addl $ws*5, %esp

#max(best_value, 
	#knapsack(weights + i + 1, values + i + 1, num_items - i - 1, capacity - weights[i], cur_value + values[i]))	
				
				push %eax #knapsack arg for function max
				#EAX is no longer needed
				movl best_value(%ebp), %eax #best_value arg for function max
				push %eax
				
				call max
				#max's return is in eax
				
				#Clean up the stack for the FUNCTION max
				addl $ws*2, %esp 	
				
				movl %eax, best_value(%ebp)
				#Since best_value is EAX in the begining, I don't think I need to put it into best_value.
				#Actually, I do, because the next time, I call best_value, it'll be the updated best_value
				
				#Move i back
				movl i(%ebp), %ecx
				
				incl %ecx #++i
				jmp for_start 
				
			knapsack_else:
				incl %ecx
				jmp for_start
	for_end:
	
	knapsack_epilogue:
		movl old_ebx(%ebp), %ebx
		movl %ebp, %esp
		pop %ebp
		ret
			
#Summary
	#The issue that i ran into while translating this homework is:
		#1. I don't really understand the problem or how the C program is implemented
		#2. I was being too literal with the translation, ie I thought; int* values
			#values + i + 1 was actually how it is in translation but it's actually
			#&values[i+1]; this is an example of pointer representation which can be accomplished by
			#1*ws(%eax, %ecx, ws) 
		#3. I forgot my else statement just for the purpose of incrementing because in the C code there was 				no else statement
			

