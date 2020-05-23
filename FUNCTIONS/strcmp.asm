.model tiny
.data

str1 db 'TEST'

str2 db 'TEST2'

.code
org 100h

START:
    lea si, str1
    lea di, str2
    
    call STRCMP
    
    mov ax, 4c00h
    int 21h
  
;===================================================
; Comparing strings
; ENTRY:    si - pointer to 1st string
;           di - pointer to 2nd string
; EXIT:     ah - 1 -> 1st bigger
;                0 -> equal
;                -1-> 2st bigger
; DESTR:    -  
;===================================================
STRCMP: 
    cld
    push di
    call STRLEN
    pop di
    
    call MEMCMP
    
    ret  
        
;===================================================
; Comparing first CX numbers of strings
; ENTRY:    si - pointer to 1st string
;           di - pointer to 2nd string
;           cx - str comparing length
; EXIT:     ah - 1 -> 1st bigger
;                0 -> equal
;                -1-> 2st bigger
; DESTR:    -  
;===================================================
MEMCMP:
    cld

    repe cmpsb
    jl  FIRST
    jg  SECOND
    jmp EQUAL
    
    FIRST:
        mov al, -1
        jmp EXIT
   
    SECOND:    
        mov al, 1
        jmp EXIT
    
    EQUAL:
        mov al, 0 
        
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