section .text

global _start

extern PRINTF

_start: 
;-----------------------------------------------------------------------------------
; TEST_1:
    mov rbp, rsp                            
    mov rsi, TEST_1                  
    push 256                         ; 100h
    push 1                           ; 1d 
    push TEST_1.1_ARG                 
    call PRINTF                       
    add rsp, 24 
    mov rsi, ANS_1
    call RAW_PRINT

;-----------------------------------------------------------------------------------
; TEST_2:
    mov rbp, rsp                            
    mov rsi, TEST_2                
    push 53  
    push 6                         
    push 7                          
    push TEST_2.2_ARG
    push TEST_2.1_ARG                 
    call PRINTF                       
    add rsp, 40 
    mov rsi, ANS_2
    call RAW_PRINT                  

;-----------------------------------------------------------------------------------
; TEST_3:
    mov rbp, rsp                            
    mov rsi, TEST_3  
    push TEST_3.1_ARG              
    push 158                            ; 9eH                         
    call PRINTF                       
    add rsp, 16  
    mov rsi, ANS_3
    call RAW_PRINT

;-----------------------------------------------------------------------------------
; TEST_4:
    mov rbp, rsp                            
    mov rsi, TEST_4             
    push 1802                            ; 3412                         
    call PRINTF                       
    add rsp, 8
    mov rsi, ANS_4
    call RAW_PRINT
    
;-----------------------------------------------------------------------------------
; TEST_5:
    mov rbp, rsp                            
    mov rsi, TEST_5             
    push 't'                                                   
    call PRINTF                       
    add rsp, 8
    mov rsi, ANS_5
    call RAW_PRINT

;-----------------------------------------------------------------------------------
; TESTS ENDED:

    mov rax, 60d                        ; exit system call
    xor rdi, rdi                        ; 0 exit code
    syscall                             ; shutting down the program


;==================================================================================================
;   Writes full buffer symbol to cmd
;
;   ENTRY:  rsi - adress of buffer
;   EXIT:   -
;   DESTR:  rax, rcx, rdx, rsi, rdi
;==================================================================================================
RAW_PRINT:
    mov rdi, rsi                    ; rdi = rsi for scasb
    call RAW_STRLEN                 ; counting chars in buffer
    mov rax, 1                      ; system call for write in cmd
    mov rdi, 1                      ; system decriptor
    mov rdx, rcx                    ; length of string
    syscall
    ret

;==================================================================================================
;   Counts chars in string
;
;   ENTRY:  rdi - adress of string
;   EXIT:   rcx - length of string
;   DESTR:  rax, rdi
;==================================================================================================
RAW_STRLEN:
    cld                 ; to go in a positive direction
    xor rcx, rcx        ; rcx = 0
    xor rax, rax        ; rax = 0                                
    not rcx             ; rcx = maximum
    repne scasb         ; rcx = maximum - strlen - 1
    not rcx             ; rcx = strlen + 1
    dec rcx             ; rcx = ans 
    ret


section .data

OK_STR            db "Test#%d - passed", 10d, 13d, 10d, 13d, 0h

TEST_1            db "Korob.%s is the %dst of the coolest domens in %x%% counties!", 10d, 13d, 0h      
TEST_1.1_ARG      db "com", 0h
ANS_1             db "Korob.com is the 1st of the coolest domens in 100% counties!", 10d, 13d, 10d, 13d, 0h
TEST_2            db "%s%s %d o'clock, %d:%d, if we want to be more concrete", 10d, 13d, 0h      
TEST_2.1_ARG      db "I just want to sleep", 0h
TEST_2.2_ARG      db ", no, really, it's", 0h
ANS_2             db "I just want to sleep, no, really, it's 7 o'clock, 6:53, if we want to be more concrete", 10d, 13d, 10d, 13d, 0h
TEST_3            db "%b - is the best%sin Linux", 10d, 13d, 0h
TEST_3.1_ARG      db " color ", 0h
ANS_3             db "10011110 - is the best color in Linux", 10d, 13d, 10d, 13d, 0h
TEST_4            db "Just good test for %%o: %o", 10d, 13d,0h
ANS_4             db "Just good test for %o: 3412", 10d, 13d, 10d, 13d, 0h
TEST_5            db "Just %cest for error %j", 10d, 13d, 0h
ANS_5             db "Just test for error !ERR!", 10d, 13d, 10d, 13d, 0h