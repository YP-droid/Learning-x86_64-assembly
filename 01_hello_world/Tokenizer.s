 .intel_syntax noprefix
.global _start
.text
_start:

lea rdi, [buf]
lea rsi, [buflen-1]


call readline

;#if no data entered
cmp rax, 0
je nodata


lea rdi, [buf]
mov rsi, rax

;#null terminate the i/p string
mov byte ptr [rdi+rsi], 0
call memview

lea rdi, [buf]
lea rsi, [tokens]
call tokenize

int3

;#print tokens
call pt


call exit


pt:
        lea r15, [tokens]
        pt.loop:
              mov rdi, [r15]
              cmp rdi, 0
              je pt.end
              
              call println
              add r15, 8
              jmp pt.loop
        pt.end:
              ret


;#convert all spaces to null terminator
tokenize:
        mov r15, rsi
        tokenize.loop:
            call skipspace
            cmp byte ptr [rdi], 0
            je nodata
            
            
            mov [r15], rdi
            add r15, 8 ;#store next char in seperate byte
            call memview
            
            call findend
            cmp byte ptr [rdi], 0
            je tokenize.end
            
            mov byte ptr [rdi], 0
            inc rdi
            
            call memview
            jmp tokenize.loop
            tokenize.end:
                    ret 
        
;#find the spaces b/w words 
findend:
        cmp byte ptr [rdi], 0
        je findend.exit
        cmp byte ptr [rdi], ' '
        je findend.exit
        inc rdi
        jmp findend
        
        findend.exit:
                ret


skipspace:
        cmp byte ptr [rdi], ' '
        jne skipspacereturn
        inc rdi
        jmp skipspace
        
        skipspacereturn:
               call memview
               ret

nodata:
      lea rdi, [s_nodata]
      call print
      call exit


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
      

println:
        push rdi
        call slen
        pop rsi
        mov rdx, rax
        mov rax, 1
        mov rdi, 1
        syscall
        
        mov rax, 1
        mov rdi, 1
        lea rsi, [newline]
        mov rdx, 1
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
buf: .skip 128
buflen= . - buf
tokens: .skip 128 ;#token array        
newline: .byte '\n'
s_nodata: .asciz "\n No data entered\n"
          
