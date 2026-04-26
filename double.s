# double.s - Reads a number, doubles it, and prints the result
.section .data
    prompt:     .ascii "Enter a number: "
    prompt_len = . - prompt
    result_msg: .ascii "The double is: "
    res_msg_len = . - result_msg
    newline:    .ascii "\n"

.section .bss
    .lcomm buffer, 32      
    .lcomm out_buf, 32    

.section .text
    .global _start

_start:
    movq $1, %rax          
    movq $1, %rdi           
    movq $prompt, %rsi      
    movq $prompt_len, %rdx  
    syscall

    movq $0, %rax           
    movq $0, %rdi           
    movq $buffer, %rsi      
    movq $32, %rdx          
    syscall


    xorq %rax, %rax         
    movq $buffer, %rbx      
parse_loop:
    movzbq (%rbx), %rcx     
    cmpb $10, %cl           
    je done_parse
    subq $48, %rcx          
    imulq $10, %rax         
    addq %rcx, %rax         
    incq %rbx               
    jmp parse_loop

done_parse:
    shlq $1, %rax           

    movq $out_buf + 31, %rbx 
    movb $0, (%rbx)         
    movq $10, %rcx          
convert_loop:
    decq %rbx
    xorq %rdx, %rdx         
    divq %rcx               
    addb $48, %dl           
    movb %dl, (%rbx)       
    testq %rax, %rax       
    jnz convert_loop

    movq $1, %rax
    movq $1, %rdi
    movq $result_msg, %rsi
    movq $res_msg_len, %rdx
    syscall

    movq $out_buf + 31, %rdx
    subq %rbx, %rdx
    movq $1, %rax
    movq $1, %rdi
    movq %rbx, %rsi    
    syscall

    movq $1, %rax
    movq $1, %rdi
    movq $newline, %rsi
    movq $1, %rdx
    syscall

    movq $60, %rax         
    xorq %rdi, %rdi         
    syscall