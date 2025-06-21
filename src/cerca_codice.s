.section .text
.globl cerca_codice
cerca_codice:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %esi      # puntatore alla riga

# scorre la riga fino al primo spazio
ciclo_spazio:
    cmpb $0, (%esi)        # verifica se nelle posizione esi c'e \0
    je fine
    cmpb $' ', (%esi)      # verifica se c'e uno spazio (arriva a AAA:6:28)
    je trovato_spazio
    incl %esi
    jmp ciclo_spazio

trovato_spazio:
    incl %esi              # si posiziona sul primo carattere del primo codice

# ciclo per ogni codice
ciclo_codici:
    cmpb $0, (%esi)
    je fine

    pushl %esi             # salva l’indirizzo di inizio del codice
    movl 12(%ebp), %edi    # carica il parametro 'codice' (2° argomento)

    movl $3, %ecx          # confronta esattamente 3 caratteri
confronta_3_caratteri:
    movb (%esi), %al
    cmpb (%edi), %al
    jne codici_diversi
    incl %esi
    incl %edi
    loop confronta_3_caratteri

    popl %esi

# salta fino al primo ':'
salta_duepunti1:
    cmpb $':', (%esi)
    je trovato_duepunti1
    incl %esi
    jmp salta_duepunti1

trovato_duepunti1:
    incl %esi

# salta fino al secondo ':'
salta_duepunti2:
    cmpb $':', (%esi)
    je trovato_duepunti2
    incl %esi
    jmp salta_duepunti2

trovato_duepunti2:
    incl %esi

# legge il voto
    xor %eax, %eax
leggi_voto:
    movb (%esi), %bl
    cmpb $0, %bl
    je salva
    cmpb $';', %bl
    je salva
    subb $'0', %bl
    imul $10, %eax
    addl %ebx, %eax
    incl %esi
    jmp leggi_voto

salva:
    movl somma_voti, %ebx
    addl %eax, %ebx
    movl %ebx, somma_voti

    movl conteggio, %ebx
    incl %ebx
    movl %ebx, conteggio

    jmp salta_codice

codici_diversi:
    popl %esi

salta_codice:
    cmpb $0, (%esi)
    je fine
    cmpb $';', (%esi)
    je fine_codice
    incl %esi
    jmp salta_codice

fine_codice:
    incl %esi
    jmp ciclo_codici

fine:
    movl %ebp, %esp
    popl %ebp
    ret
