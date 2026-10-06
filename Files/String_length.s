.intel_syntax noprefix
.global _start
.text
_start:

lea rdi, [s1] #print(s1)
call print

lea rdi, [s2]#print(s2)
call print

exit:
mov rax, 60
xor rdi, rdi
syscall


print:
push rdi #to preserve original rdi
call s_len
pop rdi

#write to terminal
lea rdx, [rax] #length
lea rsi, [rdi] #address
mov rax, 1 #write syscall
mov rdi, 1 #terminal
syscall
ret


#calc length of string
s_len:
mov rax, rdi
xor rcx, rcx #store length here

loop:
mov bl, [rax] #1 char at a time
cmp bl, 0
je s_exit
inc rax
inc rcx
jmp loop

s_exit:
mov rax, rcx
ret


.data
s1: .asciz  "Hello\n"
s2: .asciz "Guys\n"
#asciz add a escape sequence '\0' by itself
