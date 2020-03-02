.model tiny
.code
org 100h

Start: 		mov ax, 0
   		jmp AsciiPrint

AsciiPrint:	mov ah, 0aH
		int 10h
		mov ah, 03h
		int 10h
		inc dl
		mov ah, 02h
		int 10h
		inc al
		cmp al, 255d
		je PreEnd
		cmp dl, 18h
		je NewRow
		jmp AsciiPrint

PreEnd:		mov al, 0
		mov ah, 0aH
		int 10h
		ret		

NewRow:		mov bl, al
		mov al, 0
		mov ah, 0aH
		int 10h
		mov dl, 0
		mov al, 10
		mov ah, 0eH
		int 10h
		mov al, 13
		int 10h
		mov al, bl
		jmp AsciiPrint

end Start