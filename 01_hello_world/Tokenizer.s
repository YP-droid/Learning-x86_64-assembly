.intel_syntax noprefix
.global _start
.text
_start:

lea rdi, [buf]
lea rsi, [buflen]

call readline


mov rsi, rax ;#as rax has the length of string read
lea rdi, [buf]
;#null terminate the i/p string
mov byte ptr [rdi+rsi], 0


lea rdi, [buf]
lea rsi, [tokens]
call tokenize

lea rdi, [buf]
call print

call exit


;#convert all spaces to null terminator
tokenize:
        mov r15, rsi
        tokenize.loop:
            mov [r15], rdi
            add r15, 8 ;#store next char in seperate byte
            call memview
            
            call findend
            mov byte ptr [rdi], 0
            inc rdi
            
            call memview
            jmp tokenize.loop
            ret 
        
;#find the spaces b/w words 
findend:
        cmp byte ptr [rdi], ' '
        je findend.exit
        inc rdi
        jmp findend
        
        findend.exit:
                ret


exit:
        xor rdi, rdi
        mov rax, 60
        syscall

print:
        push rdi
        call slen
        pop rsi
        mov rdx, rax
        mov rax, 1
        mov rdi, 1
        syscall
        ret
      
        
slen:
    xor rcx, rcx

    slen.loop:
        mov al, [rdi + rcx]
        cmp al, 0
        je slen.ret
        inc rcx
        jmp slen.loop

      slen.ret:
        mov rax, rcx
        ret
readline:
        mov rdx, rsi
        mov rsi, rdi
        mov rax, 0
        mov rdi, 0
        syscall
        ret

memview:
        mov r11, rsp
        lea rsp, [buf]
        int 3
        lea rsp, [r11]
        ret
        
        
.data
buf: .skip 128, 0xff
buflen= . - buf
tokens: .skip 128 ;#token array        
    
