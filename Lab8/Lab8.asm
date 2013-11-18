.orig x3000
	;R0 = original data
	;R1 = count
	;R2 = final rotated amount
	;R3 = temp rotated amount
	;R4 = holder for MSB
	;R5 = leading one to AND with
LD R0, ORIGINAL		; 1.load data at ORIGINAL to R0 (data copy)
LD R2, ORIGINAL		; 2.load data at ORIGINAL to R2 (data edit)
LD R1, AMOUNT		; 3.load data at AMOUNT to R1
LD R5, LEADINGONE	; 4.load data at LEADINGONE to R5

ROTATELEFT	; for (int i = R1; i > 0; i--) { 
	ADD R3, R2, R2	;	5. R3 = R2 + R2
	AND R4, R2, R5	;	6. R4 = R2 AND R5
	BRz MSBZERO
		ADD R3, R3, 1	;	7. R3 = R3 + 1
MSBZERO	ADD R2, R3, 0	;	8.

	ADD R1, R1, xFFFF	;9. R1--
	BRp ROTATELEFT	;A. 10. branch to start of loop

	ST R2, ROTATED	;B.11. Store R2 in ROTATED

HALT	 

ORIGINAL .fill xD10B 	;the initial 16-bit pattern to rotate
AMOUNT .fill x0005 		;the amount of which to rotate to the left (from 0 - 16 inclusive)
ROTATED .blkw 1;
LEADINGONE .fill x8000 	;discovers the MSB

.end