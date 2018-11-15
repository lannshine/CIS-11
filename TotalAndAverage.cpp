/*
 * This program prompts the user to enter positive integers that will be totaled up.
 * When the user enters a negative value, the program stops prompting for input values 
 * and computes the average by using a division algorithm.
 *
 * Your task is to take this program and convert it to an ARM Assembly Language program
 * with techniques you have learned thus far in the course.
*/

#include <cstdio>

int main()
{
	int sum=0, input, count=0;
	
	do
	{
		printf("Enter a positive integer and I'll add it to a running total (negative value entered to stop): ");
		scanf("%d", &input);
		
		if (input < 0) break;
		
		sum = sum + input;
		count++;
	}
	while (true);

	unsigned int R0, R1, R2, R3, R4, R5;
		
	R5=sum; R4=count;
    
    //Initialize the working registers with the data
    R0=R5;R1=0;R2=1;R3=R4;
    //Shift the denominator left until greater than numerator, then shift back
    do {
        R3<<=1; //Denominator shift left
        R2<<=1; //Division shift left
    } while (R0>R3);//Shift Left until Decrement/Division Greater than Numerator
    R3>>=1; //Shift Denominator right
    R2>>=1; //Shift Division right
	//Loop and keep subtracting off the shifted Denominator
    _subtract:
    if(R0<R3)goto _output;
        R1+=R2; //Increment division by the increment
        R0-=R3; //Subtract shifted Denominator with remainder of Numerator
        //Shift right until denominator is less than numerator
        _shift_right:
        if(R2==1) goto _subtract;
        if(R3<=R0)goto _subtract;
            R2>>=1; //Shift Increment left
            R3>>=1; //Shift Denominator left
        goto _shift_right; //Shift Denominator until less than Numerator
    goto _subtract; //Keep Looping until the division is complete
    //Output the results
_output:
	
	printf("The sum is %d and average is %d\n",sum, R1);
}
