.model tiny
.data
ConstGraf 	equ 0B800h

ConstCube 	equ 219d

ConstColor	equ 9eh		

ConstPhraseClr	equ 0fh
.code
org 100h

Start:		mov cx, ConstGraf
		mov es, cx
		mov cx, 0
		mov ax, 80d*3d*2d+20d
		jmp UpperSide
					
UpperSide:	mov bx, ax
		mov byte ptr es:[bx], ConstCube
		inc bx
		mov byte ptr es:[bx], ConstColor
		inc cx
		cmp cx, 40d
		je  PreLeftSide
		add ax, 2d	
		jmp UpperSide

PreLeftSide:	mov cx, 0d
		mov ax, 80d*3d*2d+20d
		jmp LeftSide


LeftSide: 	add ax, 160d
		mov bx, ax
		mov byte ptr es:[bx], ConstCube
		inc bx
		mov byte ptr es:[bx], ConstColor					
		inc cx
		cmp cx, 10d
		je  PreRightSide
		jmp LeftSide

PreRightSide:	mov cx, 0d
		mov ax, 80d*3d*2d+20d+78d
		jmp RightSide

RightSide:	add ax, 160d
		mov bx, ax
		mov byte ptr es:[bx], ConstCube
		inc bx
		mov byte ptr es:[bx], ConstColor
		inc cx
		cmp cx, 10d
		je  PreLowerSide
		jmp RightSide

PreLowerSide:	mov cx, 0d
		mov ax, 80d*14d*2d + 20d
		jmp LowerSide

LowerSide:	mov bx, ax
		mov byte ptr es:[bx], ConstCube
		inc bx
		mov byte ptr es:[bx], ConstColor
		inc cx
		cmp cx, 40d
		je  PreKorobCom
		add ax, 2d
		jmp LowerSide
		
Phrase:		db "KorobCom is the best",0

PreKorobCom:	mov cx, 0d
		mov dx, 80d*7d*2 + 25d
		ret
;		jmp KorobCom

;KorobCom:	mov bx, dx
;		mov si, offset Phrase
;		add si, cx
;		mov ax, [si]
;		mov byte ptr es:[bx], ax
;		inc bx
;		mov byte ptr es:[bx], ConstPhraseClr
;		inc cx
;		cmp cx,20d
;		je TheEnd
;		inc dx
;		inc dx
;		jmp KorobCom


TheEnd:		ret

end Start