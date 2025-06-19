.section .text
.global cerca_codice
.type cerca_codice, @function

cerca_codice:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %esi      # %esi ← puntatore alla riga

    # Trova primo spazio (separa matricola da esami)
trova_spazio:
    cmpb $0, (%esi)
    je fine_cerca           # fine riga, nessun esame
    cmpb $' ', (%esi)
    je inizio_esami
    incl %esi
    jmp trova_spazio

inizio_esami:
    incl %esi               # salta lo spazio, ora %esi punta al primo codice esame

loop_esami:
    # confronta codice corrente con codice_buf
    pushl %esi              # salva inizio codice su stack

    movl $codice_buf, %edi  # %edi ← codice da confrontare
confronta_codice:
    movb (%esi), %al
    cmpb $':', %al
    je fine_confronto
    cmpb $0, %al
    je fine_confronto
    cmpb (%edi), %al
    jne salta_esame         # codice non corrisponde
    incl %esi
    incl %edi
    jmp confronta_codice

fine_confronto:
    # I codici sono uguali
    popl %ebx              # ripristina inizio codice
    movl %ebx, %esi        # %esi torna a inizio del codice trovato

    # salta codice + ':' → vai a leggere i crediti
    cerca_primo_duepunti:
        cmpb $':', (%esi)
        je salta_duepunti1
        incl %esi
        jmp cerca_primo_duepunti
salta_duepunti1:
    incl %esi  # salta ':'

    # salta crediti + ':' → vai a leggere il voto
    cerca_secondo_duepunti:
        cmpb $':', (%esi)
        je salta_duepunti2
        incl %esi
        jmp cerca_secondo_duepunti
salta_duepunti2:
    incl %esi  # ora %esi punta al voto (in ASCII)

    # converte voto ASCII in intero
    xorl %eax, %eax
    leggi_cifra:
        movb (%esi), %bl
        cmpb $0, %bl
        je somma_voto
        cmpb $';', %bl
        je somma_voto
        subb $'0', %bl
        imull $10, %eax
        addl %ebx, %eax
        incl %esi
        jmp leggi_cifra

somma_voto:
    # somma voto a somma_voti
    movl somma_voti, %ebx
    addl %eax, %ebx
    movl %ebx, somma_voti

    # incrementa conteggio
    movl conteggio, %ebx
    incl %ebx
    movl %ebx, conteggio

    jmp fine_cerca

salta_esame:
    popl %esi     # ripristina posizione corrente

    # salta fino a prossimo esame (salta fino a ';' o fine riga)
    cerca_punto_e_virgola:
        cmpb $0, (%esi)
        je fine_cerca
        cmpb $';', (%esi)
        je prossimo_esame
        incl %esi
        jmp cerca_punto_e_virgola

prossimo_esame:
    incl %esi
    jmp loop_esami

fine_cerca:
    movl %ebp, %esp
    popl %ebp
    ret
