
.intel_syntax noprefix
.global _start
.text
_start:


#syscall(write,terminal,address,length)
#write(terminal,address,length)
#function code = rax
#terminal code (1st arg) = rdi
#address (2nd arg) = rsi
#length (3rd arg) = rdx


  # sys_write
  mov rax, 1 
  mov rdi, 1 
  lea rsi, [hellostring]
  mov rdx, offset hellolen
  syscall

  # sys_exit(arg)
  mov rax, 60
  xor rdi, rdi #rdi was 1,after write syscall, we set it to 0
  syscall

.data
hellostring: .ascii  "Hello, world\n" #create a string
hellolen = . - hellostring #get length

