.model tiny
.code
org 100h

start:		mov ah, 09h
		mov dx, offset KorobCom
		int 21h
		mov ax, 4c00h
		int 21h
CR		equ 13
LF		equ 10
CRLF		equ CR, LF

KorobCom 	db CRLF,"Korob&Co will be the best company of this word,"
		db " belive me!",CRLF,"$"
end Start