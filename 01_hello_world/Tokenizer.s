.intel_syntax noprefix
.global _start
.text
_start:

lea rdi, [buf]
lea rsi, [bufsize-1] ;#to make space for the null terminator
call readline

lea rdi, [buf] 

call memview

lea rdi, [buf] 
mov byte ptr [rdi + rax], 0 ;#null terminate the string    

call memview

lea rdi, [buf]
call print;

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
;#read from terminal
mov rdx,rsi ;#len
mov rsi,rdi ;#where we wanna write
mov rax, 0
mov rdi, 0 ;#print to terminal
syscall
ret        

;#to see live change in memory stack
memview:
mov r14, rsp
lea rsp, [rdi]
int 3
mov rsp, r14
ret
        
.data
buf : .skip 50, 0xff
bufsize = . - buf


