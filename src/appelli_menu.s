.section .data
prompt_menu:
    .ascii "\n===== MENU =====\n1. Esci\n2. Vedi libretto studente\n3. Vedi esiti esame\n4. Vedi graduatoria\n"

prompt_scelta:
    .ascii "Scelta: "

invalid_msg:
    .ascii "Scelta non valida. Riprova.\n"

.section .bss
    scelta: .skip 4          # spazio per memorizzare l'input (int)

.section .text
.globl _start

_start:
menu:
    # Stampa il menu
    movl $4, %eax            # syscall: write
    movl $1, %ebx            # stdout
    movl $prompt_menu, %ecx     # messaggio
    movl $92, %edx           # lunghezza reale del messaggio
    int $0x80

    # Stampa il prompt "Scelta: "
    movl $4, %eax
    movl $1, %ebx
    movl $prompt_scelta, %ecx
    movl $8, %edx            # "Scelta: " = 8 caratteri
    int $0x80

    # Leggi l'input utente (una cifra)
    movl $3, %eax            # syscall: read
    movl $0, %ebx            # stdin
    movl $scelta, %ecx       # buffer
    movl $4, %edx            # leggi massimo 4 byte
    int $0x80

    # Converti da ASCII a intero (solo primo byte)
    movzbl scelta, %eax      # carica il primo byte
    sub $48, %eax            # ASCII '0' = 48

    # Controlla la scelta  CASE: 
    cmpl $1, %eax
    je esci

    cmpl $2, %eax
    je vedi_libretto

    cmpl $3, %eax
    je vedi_esiti

    cmpl $4, %eax
    je vedi_graduatoria

    # Altrimenti scelta non valida
    movl $4, %eax
    movl $1, %ebx
    movl $invalid_msg, %ecx
    movl $29, %edx
    int $0x80
    jmp menu



#  Scelte
esci:
    movl $1, %eax        # syscall: exit
    xorl %ebx, %ebx      # exit code 0
    int $0x80

vedi_libretto:
    # Qui va la logica per leggere la matricola,
    # verificare in anagrafica.txt, leggere libretti.txt,
    # calcolare media aritmetica e ponderata, e stampare.

    # Dopo elaborazione torna al menu
    jmp menu

vedi_esiti:
    # Qui va la logica per leggere il codice esame,
    # cercare nei libretti e calcolare la media dei voti.

    # Dopo elaborazione torna al menu
    jmp menu

vedi_graduatoria:
    # Logica per gestire graduatoria 
    jmp menu
