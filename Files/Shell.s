
.intel_syntax noprefix
.global _start
.text
_start:


lea rdi, [buf]
lea rsi, [bufsize]
call readline
call memview


lea rdi, [buf]
lea rsi, [tokens]
call tokenize

call memview


call exit



strcmp: ;# args: rdi s1, rsi s2

        mov al, [rdi]
        mov dl, [rsi]
        cmp al, dl
        jne     sc.done
        cmp al, 0
        je sc.done

        inc rdi
        inc rsi
        jmp strcmp

        sc.done:
                sub al, dl
                ret

strncmp: ;# args: rdi s1, rsi s2, rdx len
        mov rcx, rdx
        snc.loop:
                dec rcx
                mov al, [rdi]
                mov dl, [rsi]
                cmp al, dl
                jne snc.done
                cmp al, 0
                je snc.done
                cmp rcx, 0
                je snc.done

                inc rdi
                inc rsi
                jmp snc.loop

        snc.done:
                sub al, dl
                ret

nodata:
        lea rdi, [s_nodata]
        call print
        call exit

print_tokens:
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

tokenize: ;# arg1: rdi (string), arg2: rsi (arr)
        mov r15, rsi

        tokenize.loop:
                call skipwhite
                cmp byte ptr [rdi], 0x0
                je tokenize.end

                mov [r15], rdi
                add r15, 8
                call findend
                cmp byte ptr [rdi], 0
                je tokenize.end

                mov byte ptr [rdi], 0
                inc rdi
                jmp tokenize.loop

                tokenize.end:
                        mov qword ptr [r15], 0
                        ret

findend:
        cmp byte ptr [rdi], ' '
        je findend.ret

        cmp byte ptr [rdi], 0
        je findend.ret

        inc rdi
        jmp findend

        findend.ret:
                ret

skipwhite:
        cmp byte ptr [rdi], ' '
        je skipwhite.advance

        ret


        skipwhite.advance:
                inc rdi
                jmp skipwhite

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
        lea rdx, [rsi - 1]
        mov rsi, rdi
        mov rax, 0
        mov rdi, 0
        syscall
        
        mov byte ptr [rsi + rax], 0
        ret

memview:
        mov r14, rsp
        lea rsp, [buf]
        int3
        mov rsp, r14
        ret

.data
buf: .skip 128, 0xaa
bufsize = . - buf
tokens: .skip 128, 0xbb
newline: .asciz "\n"
space: .asciz " "
s_nodata: .asciz "\nNo data entered!\n"
