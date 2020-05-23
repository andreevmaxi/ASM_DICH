locals @@

.model tiny
.data
         
ConstGraph	equ 0B800h

ConstCube	equ 219d

ConstColor	equ 1eh   

ConstPhraseClr	equ 0fh

.code                  

org 100h
                          
Start:              
        call HangInt
 	call Resident     
	ret

;=========================================================
; This procedure making our program resident sleeper
; ENTRY:
; DESTR:	ax, cx, dx                                                        
;=========================================================
Resident	proc
		mov cx, 0
		mov ax, 3100h
                mov dx, offset EndInt
		shr dx, 4
		inc dx
		int 21h
		
		ret
Resident 	endp

;=========================================================
; Procedure, which will steal keys and print them
; in video memory                                                             
;=========================================================
KeyLogInt       proc
		push ax bx cx dx di es
                
		call Print 
		in al, 60h 
		mov bx, ConstGraph
		mov es, bx
		mov ah, ConstColor
		mov di, (2d*80d + 4d + 80d - 10d)*2d  
		cld                 
		call ScanPrint 
		
		pop es di dx cx bx ax
			
			db 0eah             	
	BackupInt 	dw 0
		 	dw 0	
	iret
KeyLogInt	endp

;=========================================================
; Hanging our procedure to 9's interraption
; ENTRY:
; DESTR:	ax, es                                                        
;=========================================================
HangInt		proc
      		xor ax, ax
		mov es, ax
	        
		cli
		mov bx, 36				; 9's int
		mov ax, word ptr es:[bx]		; =
		mov BackupInt, ax			; =
		mov ax, word ptr es:[bx+2]      	; =
		mov BackupInt+2, ax			; saving previous interraption

		mov word ptr es:[bx], offset KeyLogInt	; =
		mov ax, cs                              ; =
		mov word ptr es:[bx+2], ax		; loading our interraption in 9's int
		sti
		ret 
HangInt		endp		
    

;=========================================================
; Printing frame for our interraption                                                        
;=========================================================
Print 		proc
                push ax bx cx dx di es
		
		mov al, ConstCube
		mov ah, ConstColor
		mov bx, ax     
		mov cx, ConstGraph
		mov es, cx
		mov di, (80d-10d)*2d	
		mov cx, 8d
		mov dh, 80d
		mov dl, 3d        
		call BoxPrint	

                pop es di dx cx bx ax
		ret
Print 		endp
  
;=========================================================
; Printing scan code in video memory
; ENTRY:	ES:DI - begining adress to write
;		al    - our scan to write in hex
;		ah    - color to write
; DESTR:	bx, ax, DI 
;=========================================================
ScanPrint	proc
		
		mov bl, al
		shr al, 4
		and al, 0Fh
		call HexToChar  
		stosw

		mov al, bl
		and al, 0Fh
		call HexToChar
		stosw	

ScanPrint 	endp

;=========================================================
; Convetring hexcode to char
; ENTRY:	al    - our hex to write in char       
; EXIT:		al    - our char
;=========================================================
HexToChar	proc
		cmp al, 0Ah
		jae @@Char
		jmp @@IntChar
@@Char:		add al, 37h
		jmp @@Exit
@@IntChar:	add al, 30h
		jmp @@Exit  
@@Exit:		ret
HexToChar	endp
     		
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
;		DH - hieght of box without conture
; 		DL - number of newline
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
                
EndInt:
end Start
