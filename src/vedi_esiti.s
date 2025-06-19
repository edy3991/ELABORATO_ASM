.section .data
prompt:     .asciz "Inserisci codice esame:\n"
# codice_buf: .space 16      # spazio per codice (max 15 + terminatore)
libretti_path: .asciz "data/libretti.txt"
buffer:     .space 1024
newline:    .byte 0x0A
.globl codice_buf     # forse questa e la riga sotto e' da rimuovere 
codice_buf: .space 16

.section .text
.global vedi_esiti
.type vedi_esiti, @function

vedi_esiti:
    # print Inserisci codice esame 
    movl $4, %eax          # syscall write
    movl $1, %ebx          # stdout
    movl $prompt, %ecx
    movl $23, %edx         # lunghezza "Inserisci codice esame:\n"
    int $0x80

    # leggo in input l'esame
    movl $3, %eax          # syscall read
    movl $0, %ebx          # stdin
    movl $codice_buf, %ecx
    movl $16, %edx
    int $0x80

    # rimuovo il \n alla fine dell'input
    movl $codice_buf, %esi   # carico indirizzo "1' carattere"
pulizia_input:               # funzione ricorsiva che trova \n 
    cmpb $0x0A, (%esi)       # verifico se esi == \n
    je zero_term
    cmpb $0, (%esi)
    je fine_pulizia
    incl %esi
    jmp pulizia_input
zero_term:                   # imposta \n a \0
    movb $0, (%esi)
fine_pulizia:

    # apro il file libretti.txt
    movl $5, %eax          # syscall open
    movl $libretti_path, %ebx
    movl $0, %ecx          # O_RDONLY
    int $0x80
    movl %eax, %edi        # salva file descriptor

    # leggo il file a blocchi di 1024 Byte, funzione ricorsiva 
    read_loop:
    movl $3, %eax              # syscall read
    movl %edi, %ebx            # fd = libretti.txt
    movl $buffer, %ecx
    movl $1024, %edx
    int $0x80
    cmp $0, %eax               # EOF? confronto eax(byte letti) con 0 
    je fine_file
    movl %eax, %esi            # byte letti

    # ora %esi = quanti byte sono stati letti
    # %ecx = buffer → parse riga per riga

    # chiama routine per elaborare buffer
    pushl %esi                 # dimensione buffer
    pushl $buffer              # indirizzo buffer
    call processa_buffer
    add $8, %esp               # ripulisce lo stack (4 per dim. buffer e 4 per ind. buffer)
    jmp read_loop

fine_file:
    # chiusura file
    movl $6, %eax
    movl %edi, %ebx
    int $0x80

    ret
