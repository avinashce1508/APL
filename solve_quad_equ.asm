;Write 80387 ALP to find the roots of the quadratic equation. All the possible cases must be considered in calculating the roots


section .data

formatpf : db "%lf" ,10 ,0
formatsf : db "%lf" , 0

msg1 db "+ i" 
len1 equ $-msg1

msg2 db "- i" 
len2 equ $-msg2

msg3 db " Real roots are : " 
len3 equ $-msg3

msg4 db " Imaginary roots are : "
len4 equ $-msg4

msg5 db " Enter the coefficient a , b , c for a*x^2 + b*x + c " , 10
len5 equ $-msg5

four : dw 4

two : dw 2

section .bss

a resb 8
b resb 8
c resb 8

bsquare resq 1
fourac resq 1

delta resq 1

twoa resq 1
squareroot resq 1

root1 resq 1
root2 resq 1

r1 resq 1
i1 resq 1

r2 resq 1
i2 resq 1

%macro write 2
 mov rax , 1
 mov rdi , 1
 mov rsi , %1
 mov rdx , %2
 syscall
%endmacro

%macro myprintf 1
 mov rdi , formatpf
 sub rsp , 8
 movsd xmm0 , [%1]
 call printf
mov rax , 1
 add rsp , 8
%endmacro

%macro myscanf 1
mov rdi , formatsf
mov rax,0
sub rsp,8
mov rsi,rsp
call scanf
mov r8,qword[rsp]
mov qword[%1],r8
add rsp,8
%endmacro

section .text


extern printf 
extern scanf

global main:
main:


write msg5 , len5   ; enter the coefficient of a , b and c 

myscanf a
myscanf b
myscanf c


finit  ; initialise 80387
 fldz ; loads 0 to st0

fadd qword[b]
fmul ST0
fstp qword[bsquare]  ; --- we store value of square of b to bsquare varible
;myprintf bsquare

fldz
fadd qword[a]
fimul word[four]
fmul qword[c]
fstp qword[fourac]
myprintf fourac
fldz
fld qword[bsquare]
fsub qword[fourac]
fstp qword[delta]
myprintf delta

fldz
fld qword[a]
fimul word[two]
fstp qword[twoa]
myprintf twoa

BT qword[delta] , 63
jc Imaginary
jmp Real


Real:

write msg3 , len3
fldz
fld qword[delta]
fsqrt
fstp qword[squareroot]

fldz
fsub qword[b]
fadd qword[squareroot]
fdiv qword[twoa]
fstp qword[root1]
myprintf root1
 
fldz
fsub qword[b]
fsub qword[squareroot]
fdiv qword[twoa]
fstp qword[root2]

myprintf root2

jmp exit

Imaginary:
 
;write msg4 , len4

fld qword[delta]
fabs
fsqrt
fstp qword[squareroot]
;myprintf squareroot

fldz
fsub qword[b]
fdiv qword[twoa]
fstp qword[r1]

myprintf r1
write msg1 , len1
fldz
fld qword[squareroot]
fdiv qword[twoa]
fstp qword[i1]
myprintf i1


fldz
fsub qword[b]
fdiv qword[twoa]
fstp qword[r2]

myprintf r2
write msg2 , len2

fldz
fld qword[squareroot]
fdiv qword[twoa]
fstp qword[i2]
myprintf i2

exit:
 mov rax , 60
 mov rdi , 0
 syscall

 
