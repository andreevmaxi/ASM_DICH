.model tiny
.data

str1 db 'TEST'

.code
org 100h

START:
    lea di, str1
    mov cx, 4
    mov al, 'S'
    
    call MEMCHR
    
    mov ax, 4c00h
    int 21h
    
;===================================================
; Searches within the first num bytes of the mem
; ENTRY:    di - pointer to our string
;           cx - str length
;           al - finding char 
; EXIT:     si - pointer on founded char
; DESTR:    -  
;===================================================
MEMCHR:
    cld
    xor si, si
    repne scasb
    jnz EXIT
    
    mov si, di
    dec si
    
    EXIT:
        ret
    
end START