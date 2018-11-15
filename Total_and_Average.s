.global main
.section .rodata // contast data
/*Prompt message*/
prompt: .asciz "Enter a positive integer and I'll add it to a running total (negative value entered to stop): "

/*Response message*/
response: .asciz "The sum is %d and average is %d\n"

/*Format pattern for scanf*/
pattern: .asciz "%d"

.data //non constant data
/*The numbers read, the sum, the counter*/
sum: .long 0
input: .word 0
count: .word 0

.text // program instruction code

main:
        push {lr}       //save return address

        ldr r0, =prompt //r0 contains pointer to the prompt message
        bl printf       //call printf to output the prompt message


        ldr r0, =pattern //r0 contains pointer to format string for the scan pattern
        ldr r1, =input   //r1 contains pointer to variable label where the first number is stored
        bl scanf         //call to scanf

	/*load value into register r1*/
	ldr r1, =value
	ldr r1, [r1]
if_r1_ge_0:
	cmp r1, #0
	blt end_loop
	ldr r5, =sum
	ldr r4, =count
	add r5, r5, r1
	add r4, #1
end_loop:
	
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
