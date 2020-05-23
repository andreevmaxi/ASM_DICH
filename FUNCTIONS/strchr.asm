.model tiny
.data

str1 db 'GOOD_DAY'

.code
org 100h

START:
    lea di, str1
    mov al, 'A'
    
    call STRCHR
    
    mov ax, 4c00h
    int 21h
    
;===================================================
; Finding first entering of Ah in Di
; ENTRY:    di - string pointer
;           al - char
; EXIT:     di - pointer at first entering
;           cx - length of string
; DESTR:    -  
;===================================================
STRCHR:
    cld
    push di
    mov ah, al
    call STRLEN
    pop di
    
    call MEMCHR
    ret

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
       
;==================================================================================================
;   Counts chars in string
;
;   ENTRY:  di - adress of string
;   EXIT:   cx - length of string
;   DESTR:  ah, di
;==================================================================================================
STRLEN:
    cld               
    xor cx, cx        
    xor al, al                                     
    not cx           
    repne scasb      
    not cx            
    dec cx           
    ret    
    
end START