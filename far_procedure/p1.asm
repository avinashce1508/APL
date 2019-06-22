
section .data

msg db "file open successfully" , 10
lmsg equ $-msg

msg1 db "Error in opening file" , 10
lmsg1 equ $-msg1

fname db 'file.txt' , 0

section .bss

global buffer
buffer resb 100
fd resq 1
global length
length resq 1

%macro print 2
 mov rax , 1
 mov rdi , 1
 mov rsi , %1
 mov rdx , %2
 syscall
%endmacro

section .text
global _start:
_start:

mov rax , 2
mov rdi , fname
mov rsi , 2
mov rdx , 777
syscall

mov qword[fd] , rax

bt rax , 63
jc tag
print msg , lmsg
jmp skip
tag: print msg1 ,lmsg1

skip:
    extern SPACE
    extern LINE
    extern CHAR

    
    mov rax , 0    ; read system call
    mov rdi , [fd]  ; --- file pointer or file descriptor
    mov rsi , buffer  ; ---- buffer which we want to read
    mov rdx , 100    ; ---- length of data we want to read
    syscall    ; ---- invoking the kernel to execute the above instruction

    mov qword[length] , rax

    print buffer , [length]
    
    call SPACE
    call LINE
    call CHAR

exit:
   mov rax , 60
   mov rdi , 0
   syscall
  
;What is the File Descripter??
;File descriptor is integer that uniquely identifies an open file of the process.

;File Descriptor table: File descriptor table is the collection of integer array indices that are file descriptors in which elements are pointers to file table entries. One unique file descriptors table is provided in operating system for each process.

;File Table Entry: File table entries is a structure In-memory surrogate for an open file, which is created when process request to opens file and these entries maintains file position. 
