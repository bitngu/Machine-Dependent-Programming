
.global matMult
.equ ws, 4

.text

#int** matMult(int **a, int num_rows_a, int num_cols_a, int** b, int num_rows_b, int num_cols_b)

matMult:
	prolouge:
		push %ebp
		movl %esp, %ebp
		subl  $ws * (4+3), %esp #The 0 might change depending if i need to save the registers	
		#Can't i just push ebx, edi, esi? instead using movl?
		push %ebx
		push %edi
		push %esi

	#Stack
	#num_cols_b: + 7
	#num_rows_b: +6
	#int **b: +5
	#num_cols_a: +4
	#num_rows_a: +3
	#int **a: +2
	#return & of main: +1
	#old_ebp <- ebp AND esp
	#c: -1
	#i: -2
	#k: -3
	#j; -4
	#old_ebx: -5
	#old_edi: -6
	#old_esi: -7
	
	.equ num_cols_b, (ws*7)
	.equ num_rows_b, (ws*6)
	.equ b, (ws*5)
	.equ num_cols_a, (ws*4)
	.equ num_rows_a, (ws*3)
	.equ a, (ws*2)
	.equ c, (ws*-1)
	.equ i, (ws*-2)
	.equ k, (ws*-3)
	.equ j, (ws*-4)
	.equ old_ebx, (ws*-5)
	.equ old_edi, (ws*-6)
	.equ old_esi, (ws*-7)
	
	 # int** c = (int**)malloc(num_rows_a* sizeof(int*));
	 #Let EAX be num_rows_a
	 movl num_rows_a(%ebp), %eax
	
	 shll $2, %eax #EAX = num_rows_a * sizeof(int*))
	 #Because I don't really care what EAX will be so, I won't put save it
	 push %eax #push argument to malloc
	 call malloc
	 #eax has the return value of eax
	 
	 #Not sure why I clean up the stack?  Because if I wan't to borrow more register later, I need to add onto 
	 #stack. So if I don't remove it, i will need to keep track of the stack
	 addl $1*ws, %esp
	 movl %eax, c(%ebp) # c =  (int**) malloc(num_rows_a * sizeof(int*)))
	
	 #for (int i = 0; i < num_rows_a ; ++i) {
	 #Let EAX be i
	 movl $0, %eax
	 first_outer_for_start:
	 	#neg: i - num_rows_a >= 0
	 	cmpl num_rows_a(%ebp), %eax
	 	jge first_outer_for_end
	 	
	 	 #c[i] = (int*)malloc(num_cols_a* sizeof(int));
	 	#Let ECX be a holder for the num_cols_b
	 	movl num_cols_b(%ebp), %ecx
	 	shll $2, %ecx
	 	
	 	#Need to save EAX
	 	movl %eax, i(%ebp)
	 	push %ecx
	 	call malloc
	 	#Malloc's return is in EAX
	 	addl $1*ws, %esp #remove the arg from the stack
	 	#Let EDX be C
	 	movl c(%ebp), %edx # edx = C
	 	#Let ECX be the return value of malloc
	 	movl %eax, %ecx
	 	movl i(%ebp), %eax #eax = i #Bring back i
	 	movl %ecx, (%edx, %eax, ws) # c[i] = malloc's return
	
	 	incl %eax
	 	jmp first_outer_for_start
	 first_outer_for_end:
	 #After I'm done, I don't need ECX, EBX, EDX anymore so I can reuse them
	 
	 #Let EAX be i
	 movl $0, %eax
	 #for (int i = 0; i <  num_rows_a; ++i) {
	 second_outer_for_start:
		 #Negation: i - num_rows_a >=0
	 	cmpl num_rows_a(%ebp) ,%eax
	 	jge second_outer_for_end
	 	
        	#for (int k = 0; k < num_cols_b; ++k) {
        	#Let ECX be k
        	movl $0, %ecx
        	first_inner_for_start:
        		#negation: k  - num_cols_b >= 0
        		cmpl  num_cols_b(%ebp),%ecx
        		jge first_inner_for_end
        		 #c[i][k] = 0
        		 #*(*(c+i)+k)
        		 #Let EDX be c
        		 movl c(%ebp), %edx #edx = c
        		 movl (%edx,%eax,ws), %edx #edx = c[i]
        		 movl $0, (%edx, %ecx, ws) #c[i][k] = 0
        		 #Does this automatically change c[i][k] or do i have to update it myself? I think it automatically
        		 #change c[i][k]
        		 
        		 #Since I don't need edx anymore now, I can reuse edx
        		 #Let EDX be j
        		 #for (int j = 0; j < num_cols_a; ++j) {
        		 movl $0, %edx
        		 second_inner_for_start:
        		 	#negation: j - num_cols_a >= 0	
        		 	cmpl  num_cols_a(%ebp),%edx
        		 	jge second_inner_for_end
        		 	
        		 	#c[i][k] = c[i][k] + a[i][j] * b[j][k]
        		 	#Let EBX be c
        		 	#Let ESI be a
        		 	#Let EDI be b
        		 	
        		 	#a[i][j]
        		 	movl a(%ebp), %esi #esi = a
        		 	movl (%esi,%eax, ws), %esi #esi = a[i]
        		 	movl (%esi, %edx, ws), %esi #esi = a[i][j]
        		 	
        		 	#b[j][k]
        		 	movl b(%ebp), %edi #edi = b
        		 	movl (%edi, %edx, ws), %edi #edi = b[j]
        		 	movl (%edi, %ecx, ws), %edi
        		 	 
        		 	 #c[i][k]
        		 	 movl c(%ebp), %ebx #ebx = c
        		 	 movl (%ebx, %eax, ws), %ebx #ebx = c[i]
        		 	 movl (%ebx, %ecx, ws), %ebx #ebx = c[i][k]
        		 	 
        		 	 #Need to place EAX into memory to multiply
        		 	 movl %eax, i(%ebp)
        		 	 
        		 	 movl %esi, %eax #eax = a[i][j]
        		 	 imull %edi #eax = a[i][j] * b[j][k]
        		 	 addl  %eax, %ebx #ebx = c[i][k] + a[i][j] * b[j][k]
        		 	 
        		 	 #After I need to place the result in C[i][k]
        		 	 #I no longer need edi or esi in this loop cause i've done the multiplication
        			movl i(%ebp), %eax  #Return i; so eax = i
         			
         			#Let esi be C
        			movl  c(%ebp), %esi #esi = c
        			movl (%esi, %eax, ws), %esi #esi = c[i]
        			movl %ebx, (%esi, %ecx, ws) #c[i][k = c[i][k] + a[i][j] * b[j][k]
        		 
        		 	incl %edx
        		 	jmp second_inner_for_start
        		 second_inner_for_end:      		         		 
        		 incl %ecx
        		 jmp first_inner_for_start
        	first_inner_for_end:
        	incl %eax
	 	jmp second_outer_for_start
	 second_outer_for_end:
	 	movl c(%ebp), %eax #set return value
	 	
        epilouge:
        	movl old_ebx(%ebp), %ebx
        	movl old_edi(%ebp), %edi
        	movl old_esi(%ebp), %esi
        	movl %ebp, %esp
        	pop %ebp
        	ret
