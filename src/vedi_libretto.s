.section .data
    buffer: .space 32               # spazio per la stringa inserita
    prompt: .asciz "Inserisci matricola: "

.section .text
    .global leggi_input_matricola   # funzione da chiamare dall'esterno
    .type leggi_input_matricola, @function # Imposto un'etichetta per agevolare il debugging


leggi_input_matricola:
    # Apro la zona di lavoro della funzione, dedico una parte dello stack alla funzione
    pushl %ebp
    movl %esp, %ebp

    # stampa del prompt
    movl $4, %eax        # syscall write
    movl $1, %ebx        # stdout
    movl $prompt, %ecx   # puntatore alla stringa da stampare
    movl $23, %edx       # lunghezza del messaggio
    int $0x80

    # leggi da tastiera
    movl $3, %eax        # syscall read
    movl $0, %ebx        # file descriptor 0 = stdin
    movl $buffer, %ecx   # dove salvare l'input
    movl $32, %edx       # massimo 32 byte
    int $0x80

    # ritorna il puntatore al buffer in %eax
    movl $buffer, %eax

    # Ripristino lo Base pointer al suo valore originale
    popl %ebp
    ret
