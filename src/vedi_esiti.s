.section .data
prompt:     .asciz "Inserisci codice esame:\n"
# codice_buf: .space 16      # spazio per codice (max 15 + terminatore)
libretti_path: .asciz "data/libretti.txt"
buffer:     .space 1024       # buffer lettura da file 
newline:    .byte 0x0A        # carattere \n
.globl codice_buf             # serve per rendere codice_buf globale 
codice_buf: .space 16         # buffer per input utente max 15 caratteri + \0

.section .text
.global vedi_esiti
.type vedi_esiti, @function

vedi_esiti:

    pushl %ebp             # salvo il vecchio base pointer
    movl %esp, %ebp        # imposto il nuovo frame 

    # print Inserisci codice esame 
    movl $4, %eax          # syscall write
    movl $1, %ebx          # stdout
    movl $prompt, %ecx     # puntatore al messaggio
    movl $23, %edx         # lunghezza "Inserisci codice esame:\n"
    int $0x80

    # leggo in input l'esame
    movl $3, %eax            # syscall read
    movl $0, %ebx            # stdin
    movl $codice_buf, %ecx   # buffer di destinazione, cioe' inndirizzo da dove inizia a scrivere
    movl $16, %edx           # 16 Byte
    int $0x80
    
    # obiettivo: rimuovo il \n alla fine dell'input
    movl $codice_buf, %esi   # carico indirizzo "1' carattere", lo metto in esi per scorrerlo 
pulizia_input:               # funzione ricorsiva che trova \n 
    cmpb $0x0A, (%esi)       # verifico se esi == \n
    je zero_term         
    cmpb $0, (%esi)          # verifico se esi e' gia' \0
    je fine_pulizia
    incl %esi                # altrimenti vado avanti
    jmp pulizia_input
zero_term:                   # imposta \n a \0
    movb $0, (%esi)
fine_pulizia:
    # apro il file libretti.txt
    movl $5, %eax                 # syscall open
    movl $libretti_path, %ebx     # nome del file
    movl $0, %ecx                 # modalita' solo lettura
    int $0x80                     # opcode 0xCC
    movl %eax, %edi               # salva file descriptor
    
    # leggo il file a blocchi di 1024 Byte, funzione ricorsiva 
    read_loop:
    movl $3, %eax              # syscall read
    movl %edi, %ebx            # file descriptor di libretti.txt
    movl $buffer, %ecx         # buffer dove salvare cio letto
    movl $1024, %edx           # numero max di byte da leggere
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
    # jmp read_loop

fine_file:
    # chiusura file
    movl $6, %eax
    movl %edi, %ebx
    int $0x80

   # movl %ebp, %esp
    popl %ebp
    ret            
