locals @@
.model tiny
.data

ConstGraph	equ 0B800h

ConstCube	equ 219d

ConstColor	equ 9eh

ConstPhraseClr	equ 0fh

.code
org 100h

Start:		mov DI, ConstGraph
		mov ES, DI
		mov DI, 37d*2d + 80d*2d*11d
		push DI
		mov AL, ConstCube
		mov AH, ConstColor
		mov BX, AX
		mov CX, 1
		mov DL, 1
		mov DH, 80d
		call BoxReamer

;=========================================================
; ENTRY:	AL - char of first and last symbol of line 
;		AH - color of first symbol
;		CX - number of line
;               ES:DI - adress of first symbol in line
;		BL - char of middle symbol of line
;               BH - color of middle symbol of line
; DESTR:	
; EXIT:		ES:DI - first adress after a line
;		CX - number of line
;=========================================================

PrintLine	proc	
                      	
		cld
		stosw
		push CX
		
		push AX
		mov AX, BX

		@@Next:	stosw
		LOOP @@Next
		pop AX
		stosw
                pop CX
		ret
PrintLine	endp

;========================================================
; ENTRY:	ES:DI - begining adress of box	
;               AL - char of corner of box
;               AH - color of corner 
;               CX - width of box
;		BL - char of ramka symbol of box
;		BH - color of ramka symbol of box
;		DL - hieght of box without conture
; 		DH - number of newline
;========================================================
BoxPrint	proc

                call PrintLine
		push DX
                push AX
		push BX
		mov AX, BX
		mov BX, 0
		push CX
		mov CL, DL
		mov CH, 0
		@@NextLine:	push CX
				mov CX, 0
				mov CL, DH
				add DI, CX ; DH
				add DI, CX
				pop CX
				mov DL, CL
				pop CX
				sub DI, CX
				sub DI, 4
				sub DI, CX
				call PrintLine
				push CX
				mov CH, 0
				mov CL, DL; DL
		LOOP @@NextLine
		mov CX, 0
		mov CL, DH
		add DI, CX
		add DI, CX
		pop CX
		pop BX
		pop AX
		pop DX
		sub DI, CX
		sub DI, CX
		sub DI, 4
		call PrintLine	
		ret
BoxPrint	endp

;========================================================
; ENTRY:	ES:DI - begining adress of first box	
;               AL - char of corner of box
;               AH - color of corner 
;               CX - width of first box
;		BL - char of ramka symbol of box
;		BH - color of ramka symbol of box
;		DL - hieght of first box without conture
; 		DH - number of newline
;
; DESTR:	CX, DX
;========================================================
BoxReamer	proc
		push DI ; to save the line number 
		cmp CX, 78 ; check CX to not to went out from the line
		jae @@MaxWidth ; if CX is went out
		cmp DL, 24 ; check DL to not to went out from the cmd
		jae @@MaxHeight ; if DL went out
		jmp @@PrintIfOK ; if Checks were good               

		@@MaxWidth:	mov CX, 78 ; If cx, > 79, then we need to write, but only 1    
				cmp DL, 24 ; here we check DL
				jae @@MaxHeight ; if DL > 24
				jmp PrintIFOK ; If Checks were good
		
		@@MaxHeight:	mov DL, 24   ; if DL, > 24, like 25, then we need to write
				jmp PrintIfOK ; JUST PRINT!
		                   	
		@@PrintIfOK:	call BoxPrint  ; here we write, when everything is done
				pop DI
				inc CX ; ----------
				inc CX ; Expandes box in 2 ways (here in width)
				inc DL ; ----------
				inc DL ; Expandes box in 2 ways(here in height)
			
				call NewPosOfBox ; Changes DI to position we need

				cmp DL, 25
				jae @@SkipEnd ; If < then we didn't wrote the last box
				cmp CX, 79
				jae @@SkipEnd ; if <= then we didn't wrote the last box
				jmp @@EndReamer ; We ended writing
		
				@@SkipEnd:	call SleepHalfSec  ; We wait to see a progress
						jmp BoxReamer ; we start writing again
		
		@@EndReamer:	ret
BoxReamer	endp

;=============================================================
; JUST AN INTERAPTION IN A HALF OF SEC
;=============================================================        	

SleepHalfSec    proc

		push AX
		push BX 
		push DX    
		mov ah, 86h
		mov CX, 0007H
		mov DX, 9090H
		int 15h 
		pop DX
		pop BX
		pop AX

SleepSec	endp

;===============================================================
; ENTRY: DI - position of prev box
; EXIT:	 DI - position of next box
;===============================================================

NewPosOfBox	proc 
		cmp DI, 80d*2d + 1d
		jbe @@LittleDI   ; If prev box was too close to the edge of console
		sub DI, 80d*2d
		sub DI, 2d       ; One line back and one symbol to expansion of box 
		jmp @@EndMark

		@@LittleDI:     cmp DI, 1d
				jbe @@EndMark ; if we are in the begin of cmd 
				sub DI, 2d
		@@EndMark: 	ret		
NewPosOfBox	endp

end Start