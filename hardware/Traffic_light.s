.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ WALK_GRN_PIN, 22	// wiringPi 22 - green light for walk
.equ DRIVE_RED_PIN, 23	// wiringPi 23 - red light for drive
.equ DRIVE_GRN_PIN, 24	// wiringPi 24, also connected to red walking light
.equ YLW_PIN, 25	// wiringPi 25 - yellow light for drive

.equ PED_PASS_PIN, 29	// wiringPi 29 - pedestrian passing pin
.equ STP_PIN, 28	// wiringPi 29 - program stop pin
.equ STOP_TRAFFIC_S, 5		// pause in seconds

.section .rodata
message: .asciz "Press the middle button to walk.\n"

.text
.global main
main:
	push {lr}
	bl wiringPiSetup // wiringPiSetup() - initialize the wiringPi library

	mov r0, #PED_PASS_PIN
	bl setPinInput
	
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
  
	mov r0, #DRIVE_GRN_PIN // default with green light for cars on
	bl pinOn

	mov r0, #WALK_GRN_PIN
	bl pinOff

	mov r0, #DRIVE_RED_PIN
	bl pinOff

	mov r0, #YLW_PIN
	bl pinOff
lp:
	mov r2, #STOP_TRAFFIC_S
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
	
readWalkBotton:
	push {lr}
	mov r0, #PED_PASS_PIN
	bl digitalRead
	pop {pc}

ped_passing:
	push {lr}
	
	mov r0,	#DRIVE_RED_PIN
	bl pinOn

	mov r0, #DRIVE_GRN_PIN
	bl pinOff

	mov r0, #WALK_GRN_PIN
	bl pinOn

	ldr r0, =#5000 //delay(x); // delay for x milliseconds or x/1000 seconds
	bl delay

	mov r4, #6
light_flash:
	mov r0, #YLW_PIN
	bl pinOn

	mov r0, #WALK_GRN_PIN
	bl pinOn

	ldr r0, =#500
	bl delay

	mov r0, #YLW_PIN
	bl pinOff

	mov r0, #WALK_GRN_PIN
	bl pinOff

	ldr r0, =#500
	bl delay

	subs r4, #1
	bgt light_flash
stop_walk:
	mov r0,	#DRIVE_GRN_PIN
	bl pinOn

	mov r0, #DRIVE_RED_PIN
	bl pinOff

	mov r0, #WALK_GRN_PIN
	bl pinOff
	
	pop {pc}

action: // r2 holds the number of seconds for drive red light
	// return value: r0=0, nothing happened; r0=1 user pressed stop button
	push {lr}
	mov r5, r2
do_whl:
	bl readStopButton
	cmp r0, #HIGH
	beq action_done
	
	bl readWalkBotton
	cmp r0, #HIGH
	beq ped_passing
	
	b do_whl
	mov r0, #0
action_done:
	pop {pc}
