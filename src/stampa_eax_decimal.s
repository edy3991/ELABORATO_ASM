.section .data
dec_buf: .space 12   # spazio per 11 cifre max (32-bit int) + terminatore
                    # 2 miliardi = max 10 cifre

.section .text
.global stampa_eax_decimal
.type stampa_eax_decimal, @function

stampa_eax_decimal:
    pushl %ebp
    movl %esp, %ebp

    movl $dec_buf, %edi     # %edi → inizio buffer
    addl $11, %edi          # punta alla fine del buffer
    movb $0, (%edi)         # null-termina la stringa

    movl %eax, %ebx         # copia valore in %ebx da stampare
    cmp $0, %ebx
    jne converti            # se ≠ 0, salta
    # caso speciale: stampare 0
    movb $'0', -1(%edi)
    movl $1, %edx           # lunghezza
    lea -1(%edi), %ecx      # puntatore alla stringa
    jmp stampa

converti:
    xorl %ecx, %ecx         # counter cifre

converti_ciclo:
    xorl %edx, %edx         # pulisci edx per divisione
    movl $10, %eax
    movl %ebx, %ebx         # valore da stampare
    divl %eax               # edx = resto, eax = risultato

    addb $'0', %dl          # converti cifra in ASCII
    decl %edi               # muovi indietro nel buffer
    movb %dl, (%edi)        # salva la cifra

    movl %ebx, %eax         # nuovo valore = eax / 10
    movl %eax, %ebx

    testl %ebx, %ebx
    jnz converti_ciclo

    # calcola lunghezza stringa
    movl $dec_buf + 11, %eax
    subl %edi, %edx         # edx = lunghezza
    movl %edi, %ecx         # puntatore stringa

stampa:
    movl $4, %eax           # syscall write
    movl $1, %ebx           # stdout
    int $0x80

    movl %ebp, %esp
    popl %ebp
    ret
