; Lab 11 - The Stack
; @author Eddie Gurnee
; @version 12/04/2013

.orig x3000

; R6 = the pointer of the Stack
	LD R6, LAB_base	;

	LEA R0, LAB_out1	;
	PUTS				;
	
	GETC				;
	OUT					;
	
	JSR PUSH			;
	
	LD R0, LAB_ln		; new line
	OUT					;	
	
	LEA R0, LAB_out2	;
	PUTS				;
	
	GETC				; get first value
	OUT					;
	ADD R2, R0, 0		;
	
	GETC				; get second value
	OUT					;	
	
	ADD R1, R0, 0		;
	ADD R0, R2, 0		;
	
	JSR DPUSH			;
	
	LD R0, LAB_ln		; new line
	OUT					;
	
	LEA R0, LAB_out1	;
	PUTS				;
	
	GETC				;
	OUT					;
	
	JSR PUSH			;
	
	LD R0, LAB_ln		; new line
	OUT					;
	
	LEA R0, LAB_out3	;
	PUTS				;	
	JSR PEEK			;
	OUT					;
	
	LD R0, LAB_ln		; new line
	OUT					;
	
	LEA R0, LAB_out4	;
	PUTS				;
	JSR DPOP			;
	OUT					;
	LD R0, LAB_sp		; space
	OUT					;
	ADD R0, R1, 0		;
	OUT					;
	
	LD R0, LAB_ln		; new line
	OUT					;
	
	LEA R0, LAB_out4	;
	PUTS				;
	JSR DPOP			;
	OUT					;
	LD R0, LAB_sp		; space
	OUT					;
	ADD R0, R1, 0		;
	OUT					;
	
HALT

	LAB_base .fill x4000					;
	LAB_ln .fill xA							; new line char
	LAB_sp .fill x20						; space char
	
	LAB_out1 .stringz "Enter element: "		;
	LAB_out2 .stringz "Enter 2 elements: " 	;
	LAB_out3 .stringz "Top element: "		;
	LAB_out4 .stringz "Pop'd values: "		;
; Subroutine PEEK
; Looks at the first element in the stack
; Pre-condition: R6 is the stack pointer
; Post-condition: 	R0 contains the first element on the stack.
;					R5 = 0 if there is no underflow, R5 = 1 if the stack is empty.
;					R6 is unchanged.
PEEK		
	ST R7, PEEK_saveR7
	ST R3, PEEK_saveR3
	
		AND R5, R5, 0	;	
	
		LD R3, PEEK_base	;
		NOT R3, R3			;
		ADD R3, R3, 1		;
		ADD R3, R3, R6		;
		BRz PEEK_Fail		; z if the stack is empty
	
		ADD R6, R6, 1	;
		LDR R0, R6, 0	; PEEK
		ADD R6, R6, -1	;
		BR PEEK_Exit
		
	PEEK_Fail
		ADD R5, R5, 1
		
	PEEK_Exit
		LD R3, PEEK_saveR3
		LD R7, PEEK_saveR7
			RET
	
	PEEK_saveR3 .blkw 1	;
	PEEK_saveR7 .blkw 1	;
	
	PEEK_base .fill xC001	;
	
; Subroutine DPUSH
; Pushes two new element on top of the stack
; Pre-condition: 	R0 contains the first element to be pushed into the stack.
;					R1 contains the second element to be pushed into the stack.
;					R6 is the stack pointer.
; Post-condition: 	The stack contains the value of R1 as the first element and the value of R0 as the second element on the stack.
;					R5 = 0 if the operation was successful, R5 = 1 if there is overflow.
;					R6 contains the updated top of the stack address.
DPUSH
	ST R7, DPUSH_saveR7
	ST R2, DPUSH_saveR2
	ST R3, DPUSH_saveR3
	
		AND R5, R5, 0	;	
	
		LD R3, DPUSH_max	;
		NOT R3, R3			;
		ADD R3, R3, 1		;
		ADD R3, R3, R6		;
		ADD R3, R3, 2		;
		BRn DPUSH_Fail		; n if there is overflow
	
	
		STR R0, R6, 0	; PUSH 1
		ADD R6, R6, -1	;
		STR R1, R6, 0	; PUSH 2
		ADD R6, R6, -1	;
		BR DPUSH_Exit
		
	DPUSH_Fail
		ADD R5, R5, 1
		
	DPUSH_Exit
		LD R2, DPUSH_saveR2
		LD R3, DPUSH_saveR3
		LD R7, DPUSH_saveR7
			RET
	
	DPUSH_saveR2 .blkw 1	;
	DPUSH_saveR3 .blkw 1	;
	DPUSH_saveR7 .blkw 1	;
	
	DPUSH_max .fill xC100	;

; Subroutine DPOP
; "Removes" and returns two elements from the top of the stack
; Pre-condition: R6 is the stack pointer.
; Post-condition: 	R0 contains the first element on the stack.
;					R1 contains the second element on the stack.
;					R5 = 0 if there is no underflow, R5 = 1 if the stack is empty.
;					R6 contains the updated top of the stack address.
DPOP
	ST R7, DPOP_saveR7
	ST R2, DPOP_saveR2
	ST R3, DPOP_saveR3
	
		AND R5, R5, 0	;	
	
		LD R3, DPOP_base	;
		NOT R3, R3			;
		ADD R3, R3, 1		;
		ADD R3, R3, R6		;
		ADD R3, R3, -2		;
		BRn DPOP_Fail		; z if the stack will now be empty
	
		ADD R6, R6, 1	;
		LDR R0, R6, 0	; POP 1
		ADD R6, R6, 1	;
		LDR R1, R6, 0	; POP 2
		BR DPOP_Exit
		
	DPOP_Fail
		ADD R5, R5, 1
		
	DPOP_Exit
		LD R2, DPOP_saveR2
		LD R3, DPOP_saveR3
		LD R7, DPOP_saveR7
			RET
	
	DPOP_saveR2 .blkw 1	;
	DPOP_saveR3 .blkw 1	;
	DPOP_saveR7 .blkw 1	;
	
	DPOP_base .fill xC001	;
	
;from the book:
;
; PUSH, POP Routines
;
; Subroutines for carrying out the PUSH and POP functions.  This 
; program works with a stack consisting of memory locations x3FFF
; (BASE) through x3FFB (MAX).  R6 is the stack pointer.
;
POP            ST      R2,Save2       ; are needed by POP.
               ST      R1,Save1
               LD      R1,BASE        ; BASE contains -x3FFF.
               ADD     R1,R1,#-1      ; R1 contains -x4000.
               ADD     R2,R6,R1       ; Compare stack pointer to x4000
               BRz     fail_exit      ; Branch if stack is empty.
               LDR     R0,R6,#0       ; The actual "pop."
               ADD     R6,R6,#1       ; Adjust stack pointer
               BRnzp   success_exit
PUSH           ST      R2,Save2       ; Save registers that 
               ST      R1,Save1       ; are needed by PUSH.
               LD      R1,MAX         ; MAX contains -x3FFB
               ADD     R2,R6,R1       ; Compare stack pointer to -x3FFB
               BRz     fail_exit      ; Branch if stack is full.
               STR     R0,R6,#0       ; The actual "push"
               ADD     R6,R6,#-1      ; Adjust stack pointer
success_exit   LD      R1,Save1       ; Restore original 
               LD      R2,Save2       ; register values.
               AND     R5,R5,#0       ; R5 <-- success.
               RET
fail_exit      LD      R1,Save1       ; Restore original
               LD      R2,Save2       ; register values.
               AND     R5,R5,#0      
               ADD     R5,R5,#1       ; R5 <-- failure. 
               RET
BASE           .FILL   xC001          ; BASE contains -x3FFF.
MAX            .FILL   xC100
Save1          .FILL   x0000
Save2          .FILL   x0000

.end