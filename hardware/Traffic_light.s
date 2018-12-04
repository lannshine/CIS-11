.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ WALK_GRN_PIN, 22	// wiringPi 22
.equ DRIVE_RED_PIN, 23	// wiringPi 23
.equ DRIVE_GRN_PIN, 24	// wiringPi 24, also connected to WALK_RED_PIN
.equ YLW_PIN, 25	// wiringPi 25 - only drive has YELLOW PIN

.equ STP_PIN, 29	// wiringPi 29 - STOP PIN
.equ PAUSE_S, 1		// pause in seconds

.section .rodata
out_s: .asciz "%d, r4=%d, r5=%d\n"

.text
.global main
main:
	push {lr}
	bl wiringPiSetup // wiringPiSetup() - initialize the wiringPi library

	mov r0, #STP_PIN
	bl setPinInput

	mov r0, #WALK_GRN_PIN
	bl setPinOutput

	mov r0, #DRIVE_RED_PIN
	bl setPinOutput

	mov r0, #DRIVE_GRN_PIN
	bl setPinOutput
  
  	mov r0, #YLW_PIN
	bl setPinOutput
  
	mov r0, #DRIVE_GRN_PIN
	bl pinOn
lp:
	//mov r2, #PAUSE_S
	bl action

	cmp r0, #1
	beq end_lp

	bal lp
end_lp:
	mov r0, #WALK_GRN_PIN
	bl pinOff

	mov r0, #DRIVE_RED_PIN
	bl pinOff

	mov r0, #DRIVE_GRN_PIN
	bl pinOff

	mov r0, #YLW_PIN
	bl pinOff

	mov r0, #0
	pop {pc}

setPinInput:
	push {lr}
	mov r1, #INPUT
	bl pinMode
	pop {pc}

setPinOutput:
	push {lr}
	mov r1, #OUTPUT
	bl pinMode
	pop {pc}

pinOn:
	push {lr}
	mov r1, #HIGH
	bl digitalWrite
	pop {pc}

pinOff:
	push {lr}
	mov r1, #LOW
	bl digitalWrite
	pop {pc}

readStopButton:
	push {lr}
	mov r0, #STP_PIN
	bl digitalRead
	pop {pc}

ped_passing:
	mov r0,	#DRIVE_RED_PIN
	bl pinOn

	mov r0, #DRIVE_GRN_PIN
	bl pinOff

	mov r0, #WALK_GRN_PIN
	bl pinOn

	ldr r0, =#3000 //delay(3000); // delay for 3000 milliseconds or 3 seconds
	bl delay
 	
	mov r0,	#DRIVE_GRN_PIN
	bl pinOn

	mov r0, #DRIVE_RED_PIN
	bl pinOff

	mov r0, #WALK_GRN_PIN
	bl pinOff

	b action

action: // r0 holds pin to turn off, r1 holds pin to turn on
	// r2 holds the number of seconds to delay
	// return value: r0=0, no user interation; r0=1 user pressed stop button
	push {r4,r5,lr}

	//move r5, r2

	//mov r0, #0
	//bl time
	//mov r4, r0
do_whl:
	bl readStopButton
	cmp r0, #HIGH
	beq ped_passing 
	//b action_done
	//mov r0, #0
	//bl time

	//sub r0, r0, r4

	//cmp r0, r5
	b do_whl
	mov r0, #0
action_done:
	pop {r4,r5,pc}
