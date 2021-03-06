; Lab 9 - Assembly Language Rotation with Input and Output
; @author Eddie Gurnee
; @version 11/20/2013

.orig x3000
	;R0 = used to read in characters from the CONSOLE with GETC and to print from the address with PUTS
	;R7 = used with the RET aspect of subroutines
LD R3, ORIGINAL		;load data at ORIGINAL to R2 (data edit)

LEA R0, PROMPT	;
PUTS			;

GETC			;
OUT				;
ADD R1, R0, 0	;
JSR TIMES_TEN	;
GETC			;
OUT				;
ADD R1, R0, 0	;
AND R1, R1, xF	;
ADD R2, R2, R1	;

AND R0, R0, 0		;clears R0
ADD R0, R0, xA		;adds 10 to R7 (the decimal value for new line)
OUT					;prints a new line

JSR ROTATELEFT	;


LEA R0, OUT_orig	;
PUTS				;
LD R1, ORIGINAL	;
LEA R2, BITPATTERN	;
JSR STORE_BITS	;
LEA R0, BITPATTERN	;
PUTS			;

AND R0, R0, 0		;clears R0
ADD R0, R0, xA		;adds 10 to R7 (the decimal value for new line)
OUT					;prints a new line

JSR STORE_BITS	;

LEA R0, OUT_rotated	;
PUTS				;
LD R1, ROTATED		;
LEA R2, BITPATTERN	;
JSR STORE_BITS		;

LEA R0, BITPATTERN	;
PUTS			;

HALT

; Subroutine ROTATELEFT
; Used to rotate the bits of a 16 bit pattern to the left a certain number of times
; Pre-condition: R2 contains the number of times the bits will be rotated
; 				 R3 contains the 16-bit pattern to rotate
; Post-condition: address ROTATED contains the rotated 16-bit pattern, registers remain unchanged
ROTATELEFT
	; R1 = holds the rotated 16-bit pattern
	; R2 = count
	; R3 = temp rotated amount
	; R4 = MSB holder
	; R5 = leading one to AND with the 16-bit pattern
			ST R7, ROT_saveR7	;
			ST R1, ROT_saveR1	;
			ST R2, ROT_saveR2	;
			ST R3, ROT_saveR3	;
			ST R4, ROT_saveR4	;
			ST R5, ROT_saveR5	;
		
			LD R5, ROT_msb1		;
			AND R1, R1, 0		;
						
	ROT_Start	ADD R1, R3, R3	;		
				AND R4, R3, R5	;
				BRz ROT_Zero	;
				ADD R1, R1, 1	;
								
	ROT_Zero	ADD R3, R3, R3	;
				ADD R3, R1, 0	;
				
				ADD R2, R2, -1	;
				BRp ROT_Start	;
				
			ST R1, ROTATED		;
			
			LD R1, ROT_saveR1	;
			LD R2, ROT_saveR2	;
			LD R3, ROT_saveR3	;
			LD R4, ROT_saveR4	;
			LD R5, ROT_saveR5	;
			LD R7, ROT_saveR7	;
				
				RET				;
				
	ROT_msb1 .fill x8000	;
	
	ROT_saveR7 .blkw 1	;
	ROT_saveR1 .blkw 1	;
	ROT_saveR2 .blkw 1	;
	ROT_saveR3 .blkw 1	;
	ROT_saveR4 .blkw 1	;
	ROT_saveR5 .blkw 1	;
	
; Subroutine STORE_BITS
; Used to store the individual bits of a 16-bit pattern at addresses in memory
; Pre-condition: R1 contains the 16-bit pattern to store in memory
;				 R2 contains the first address of where the pattern is to be stored
; Post-condition: The address (and the 15 sequential addresses) will contain the ASCII values for each bit
STORE_BITS
	; R1 = the changing 16-bit pattern
	; R2 = the target address for each bit
	; R3 = holds the ASCII value for the number 0 or 1
	; R4 = msb holder 
	; R5 = the leading 1
	; R6 = count
	
		ST R7, BTST_saveR7	;
		ST R1, BTST_saveR1	;
		ST R2, BTST_saveR2	;
		ST R3, BTST_saveR3	;
		ST R4, BTST_saveR4	;
		ST R5, BTST_saveR5	;
		ST R6, BTST_saveR6	;
		
		LD R5, BTST_msb1	;
		
		AND R6, R6, 0		; clear R6
		ADD R6, R6, 15		; sets the count to 16
		
		BTST_Start
				AND R4, R5, R1			;
				BRn BTST_Lead1			;
					LD R3, BTST_zero	;
				BRnzp BTST_Print		;
				
			BTST_Lead1
					LD R3, BTST_one		;
					
			BTST_Print
					STR R3, R2, 0		;
					ADD R2, R2, 1		;
					ADD R1, R1, R1		;
					ADD R6, R6, -1		;
				BRzp BTST_Start			;
				
		LD R1, BTST_saveR1	;
		LD R2, BTST_saveR2	;
		LD R3, BTST_saveR3	;
		LD R4, BTST_saveR4	;
		LD R5, BTST_saveR5	;
		LD R6, BTST_saveR6	;
		LD R7, BTST_saveR7	;
		
					RET					;		
		
	BTST_zero .fill x30		;
	BTST_one .fill x31		;
	BTST_msb1 .fill x8000	;
	
	BTST_saveR7 .blkw 1	;
	BTST_saveR1 .blkw 1	;
	BTST_saveR2 .blkw 1	;
	BTST_saveR3 .blkw 1	;
	BTST_saveR4 .blkw 1	;
	BTST_saveR5 .blkw 1	;
	BTST_saveR6 .blkw 1 ;
	
; Subroutine TIMES_TEN
; Used to multiply a decimal number by ten
; Pre-condition: R1 contains the ASCII value of the number to multiply by ten
; Post-condition: R2 will contain the number times ten in base two
TIMES_TEN
	; R1 = the ASCII number to multiply
	; R2 = the multiplied number
	; R3 = count
		ST R7, TIM_saveR7	;
		ST R1, TIM_saveR1	;
		ST R3, TIM_saveR3	;
		
		AND R1, R1, xF		;
		AND R2, R2, 0		;
		AND R3, R3, 0		;
		ADD R3, R3, 10		;
		
		TIM_Start
			ADD R2, R1, R2	;
			ADD R3, R3, -1	;
			BRp TIM_Start	;
			
		LD R1, TIM_saveR1	;
		LD R3, TIM_saveR3	;
		LD R7, TIM_saveR7	;
		
			RET				;
		
	TIM_saveR7 .blkw 1	;
	TIM_saveR1 .blkw 1	;
	TIM_saveR3 .blkw 1	;		


ORIGINAL .fill xD10B 	;the initial 16-bit pattern to rotate
PROMPT .stringz "AMOUNT [00 - 16]: " ; prints the prompt to enter a rotate number
OUT_orig .stringz "ORIGINAL: "
OUT_rotated .stringz "ROTATED:  "
ROTATED .blkw 1			;space set aside to hold the rotated 16 bit pattern
BITPATTERN .blkw 17		;space set aside in memory to print the original and rotated number

.end