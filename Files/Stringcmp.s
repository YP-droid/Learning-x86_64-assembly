
.intel_syntax noprefix
.global _start
.text
_start: 

;#s1 in r14
;#s2 in r15
lea r14, [s1]
lea r15, [s2]
call strcmp

;#check only 3 letters
mov rdx, 7
call strncmp

print:
    mov rax, 1;
    mov rdi, 1
    syscall
    call exit


exit:
    mov rax, 60
    xor rdi, rdi
    syscall


;#compare complete string
strcmp:
    strcmp.loop:
        mov al, [r14]
        mov bl, [r15]
        cmp al, bl 
        jne strcmp.notequal

        ;#check if both are at null
        cmp al, 0
        je cmpend
        
        ;#if equal, move both ptr forward
        
        inc r14
        inc r15
        jmp strcmp.loop
    
    
    ;# s1 will be at 0    
    cmpend:
        sub al,bl
        call decide


    strcmp.notequal:     
            lea rsi, [notequal]
            lea rdx, [notlen]
            call print
    
;#compare upto n letters         
strncmp:
    ;#store n
    mov rcx, rdx
    strncmp.loop:
        mov al, [r14]
        mov bl, [r15]
        cmp al, bl 
        jne snc.notequal
        
        ;#decrease length
        dec rcx; 
        
        cmp al, 0
        je snc.end
        
        inc r14
        inc r15
        
        jmp strncmp.loop
    
    
    snc.end:
        sub al,bl
        call decide


    snc.notequal:     
            lea rsi, [notequal]
            lea rdx, [notlen]
            call print

decide:
    cmp al, 0
    jne s_notequal
    lea rsi, [equal]
    lea rdx, [equallen]
    call print

s_notequal:
          lea rdi, [notequal]
          lea rdx, [notlen]
          call print


.data
s1 : .asciz "hell0"
s2 : .asciz "hell0"
notequal : .asciz "\nstrings are not equal\n"
notlen = . - notequal
equal : .asciz "\nstrings are equal\n"
equallen = . - equal  

