//#include <cstdio>
.data
//int sum=0, input, count=0;
sum: .word 0
input: .word 0
count: .word 0

prompt: .asciz "Enter a positive integer and I'll add it to a running total (negative value entered to stop): "
response: .asciz "The sum is %d and average is %d\n"

pattern: .asciz "%d"

.global main
.text
main:
//int main()
        push {lr}
input_lp:
 	//printf(prompt);
        ldr r0, =prompt
        bl printf

	//scanf("%d", &input);
        ldr r0, =pattern
        ldr r1, =input
        bl scanf
	
	ldr r2, =input
	ldr r2, [r2]
	
if_r1_ge_0:
	cmp r2, #0
	//if (input < 0) break;
	blt end_loop
	//R5=sum; R4=count;
	ldr r5, =sum
	ldr r5, [r5]
	ldr r4, =count
	ldr r4, [r4]
	//sum = sum + input;
	//count++;
	add r5, r5, r2
	add r4, #1
	b input_lp
	
end_loop:
	//Initialize the working registers with the data
    	//R0=R5;R1=0;R2=1;R3=R4;
    	mov r0, r5
    	mov r1, #0
    	mov r2, #1
    	mov r3, r4

next:
        ldr r0, =response       /*r0 contains pointer to response message*/
        mov r1, r4      /*r1 contains pointer to value_read1*/
        ldr r1, [r1]    /*r1 contains value dereferenced from r1 in previous instruction*/
        mov r2, r5
        ldr r2, [r2]
        mov r3, r6
        ldr r3, [r3]

        ldr r7, =sum    /*r7 contains pointer to sum*/
        ldr r8, [r7]    /*r8 contains value dereferenced from r7 in previous instruction*/
        add r8, r1, r2  /*addition*/
        add r8, r3
        push {r8}       /*push r8 onto the stack*/
        bl printf       /*call printf to output response message*/
        add sp, #4      /*adjust sp because of push {r8}*/

        mov r0, #0      /*exit code 0 = program terminates normally*/
	pop {pc}        /*exit the main function*/
