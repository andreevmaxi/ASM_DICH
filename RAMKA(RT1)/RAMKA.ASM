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
		mov DI, 38d*2d + 80d*2d*11d
		push DI
		mov AL, ConstCube
		mov AH, ConstColor
		mov BX, AX
		mov CX, 1d
		mov DL, 1d
		mov DH, 80d
		call BoxReamer
		call UKRflag
		pop DI
		mov BL, 1Ch
		call KeyExit      
		ret
		
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
		mov BX, 0d
		push CX
		mov CL, DL
		mov CH, 0d
		@@NextLine:	push CX
				mov CX, 0d
				mov CL, DH
				add DI, CX ; DH
				add DI, CX
				pop CX
				mov DL, CL
				pop CX
				sub DI, CX
				sub DI, 4d
				sub DI, CX
				call PrintLine
				push CX
				mov CH, 0d
				mov CL, DL; DL
		LOOP @@NextLine
		mov CX, 0d
		mov CL, DH
		add DI, CX
		add DI, CX
		pop CX
		pop BX
		pop AX
		pop DX
		sub DI, CX
		sub DI, CX
		sub DI, 4d
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
		@@HereWeGoAgain:	push DI ; to save the line number 
		cmp CX, 78d ; check CX to not to went out from the line
		jae @@MaxWidth ; if CX is went out
		cmp DL, 23d ; check DL to not to went out from the cmd
		jae @@MaxHeight ; if DL went out
		jmp @@PrintIfOK ; if Checks were good               

		@@MaxWidth:	mov CX, 78d ; If cx, > 78, then we need to write, but only 1    
				cmp DL, 23d ; here we check DL
				ja @@MaxHeight ; if DL > 23
				jmp @@PrintIfOK ; If Checks were good
		
		@@MaxHeight:	mov DL, 23d   ; if DL, > 23, like 24, then we need to write
				jmp @@PrintIfOK ; JUST PRINT!
		                   	
		@@PrintIfOK:	call BoxPrint  ; here we write, when everything is done
				pop DI
				inc CX ; ----------
				inc CX ; Expandes box in 2 ways (here in width)
				inc DL ; ----------
				inc DL ; Expandes box in 2 ways(here in height)
			
				call NewPosOfBox ; Changes DI to position we need

				cmp DL, 24d
				jbe @@SkipEnd ; If < then we didn't wrote the last box
				cmp CX, 79d
				jbe @@SkipEnd ; if <= then we didn't wrote the last box
				jmp @@EndReamer ; We ended writing
		
				@@SkipEnd:	call LittleSleep   ; We wait to see a progress
						jmp @@HereWeGoAgain; we start writing again
		
		@@EndReamer:	ret
BoxReamer	endp

;=============================================================
; JUST AN INTERAPTION IN A HALF OF SEC
;=============================================================        	

LittleSleep     proc

		push AX 
		push DX
		push CX    
		mov ah, 86h
		mov CX, 0002H
		mov DX, 9090H
		int 15h
		pop CX 
		pop DX
		pop AX

		ret
LittleSleep 	endp

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

;========================================================
; ENTRY:	ES - block of videomemory	
;
; JUST writes a typical ukrain flag
;======================================
UKRflag		proc
                push ax
		push bx
		push cx
		push dx
		push di

		mov DI, 0h
		mov DL, 78d
		mov CX, 13d ; all 23d  
		mov DH, 80d
		mov AL, ConstCube
		mov AH, 09h
		mov BX, AX
		@@TopFlag:	push CX
				mov CX, 0
				mov CL, DL
				call PrintLine
				pop CX
		loop @@TopFlag

		mov AH, 0Eh
		mov BH, AH
		mov CX, 12d
		@@BottomFlag:	push CX
				mov CX, 0
				mov CL, DL
				call PrintLine
				pop CX
		loop @@BottomFlag

		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		ret
UKRflag		endp

;===============================================
; ENTER:	BL - Key what is waited to exit
;===============================================
KeyExit		proc
		push AX
		@@NotThisKey:	in AL, 60h     

		cmp AL, BL
		jne @@NotThisKey
		pop AX            

		ret
KeyExit		endp	
                        
end Start