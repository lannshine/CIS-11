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
        push {lr}	//{
user_input:
 	//printf("Enter a positive integer and I'll add it to a running total (negative value entered to stop): ");
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
	blt end_user_input
	//R5=sum; R4=count;
	ldr r5, =sum
	ldr r5, [r5]
	ldr r4, =count
	ldr r4, [r4]
	//sum = sum + input;
	//count++;
	add r5, r5, r2
	add r4, #1
	b user_input
	
end_user_input:
	//Initialize the working registers with the data
    	//R0=R5;R1=0;R2=1;R3=R4;
    	mov r0, r5
    	mov r1, #0
    	mov r2, #1
    	mov r3, r4

//Shift the denominator left until greater than numerator, then shift back
shift_left:
        //R3<<=1; //Denominator shift left
	mov r3, r3, asl #1
        //R2<<=1; //Division shift left
	mov r2, r2, asl #1
	//while (R0>R3);//Shift Left until Decrement/Division Greater than Numerator
	cmp r0, r3
	bgt shift_left //repeat shift_left if r0>r3
	//R3>>=1; //Shift Denominator right
	mov r3, r3, asr #1
	//R2>>=1; //Shift Division right
	mov r2, r2, asr #1
	//Loop and keep subtracting off the shifted Denominator

subtract:
	//if(R0<R3)goto _output;
	cmp r0, r3
	blt output //skip to output if r0<r3
	
	//R1+=R2; //Increment division by the increment
	add r1, r1, r2
	//R0-=R3; //Subtract shifted Denominator with remainder of Numerator
	sub r0, r0, r3
	
	//Shift right until denominator is less than numerator
	shift_right:
	//if(R2==1) goto _subtract;
	cmp r2, #1
	beq subtract //repeat subtract if r2=1
	//if(R3<=R0)goto _subtract;
	cmp r3, r0
	ble subtract //repeat subtract if r3<=0
		//R2>>=1; //Shift Increment Right
		mov r2, r2, asr #1
		//R3>>=1; //Shift Denominator Right
		mov r3, r3, asr #1
	//goto _shift_right; //Shift Denominator until less than Numerator
	b shift_right
	
	//goto _subtract; //Keep Looping until the division is complete
	b subtract
//Output the results
output:
	push {r0-r5} //Save the contents of r0-r5 on the stack
	//printf("The sum is %d and average is %d\n",sum, R1); //sum is r5
	ldr r0, response
	ldr r1, [sp,#20] //add (# of values pushed) * 4 (4 is .word size)
	ldr r2, [sp,#4]
	bl printf
	
	add sp, #24 // clear stack

	pop {pc}	//}
