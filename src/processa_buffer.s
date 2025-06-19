# La sua funzione e' quella di prendere la riga che gli e' stata passata e suddividere gli esami per matricola per poi 
# fare una call per ogni "riga creata" cioe ogni esame sostenuto da una matricola
.section .data
# somma_voti: .long 0
# conteggio:  .long 0
no_voti_msg: .asciz "Nessuno studente ha sostenuto l’esame.\n"
media_msg: .asciz "Media voti: "
.globl somma_voti     # rimuovere da qui fino le 4 righe sotto 
.globl conteggio      
somma_voti: .long 0
conteggio:  .long 0

.section .text 
.global processa_buffer
.type processa_buffer, @function
processa_buffer:
    pushl %ebp             # salvo il vecchio base pointer
    movl %esp, %ebp        # imposto il nuovo frame 

    # Argomenti: [ebp+8] = indirizzo(buffer), [ebp+12] = dimensione

    # inizializza puntatore buffer
    movl 8(%ebp), %esi      # %esi <- puntatore inizio buffer
    movl 12(%ebp), %ecx     # %ecx = dimensione buffer
    xorl %ebx, %ebx         # offset nel buffer = 0

loop_righe:                 # se l'offset ha superato il numero di byte del buffer, siamo alla fine del file
    cmp %ebx, %ecx
    jge fine_buffer

    lea 0(%esi,%ebx), %edi   # %edi punta alla riga corrente, mi calcola edi = (esi + ebx * 1) + 0  il *1 e' sottointeso

    # cerca newline e sostituisce con \0
    movl %ebx, %eax          # salviamo posizione inizio riga
cerca_fine_riga:             # vado quindi a esaminare carattere per carattere, scorro ebx
    cmp %ebx, %ecx           
    jge fine_buffer         # questo perche ecx e' la dim(buffer)
    cmpb $0x0A, (%esi,%ebx)   # verifica se il carattere e' uguale a \n = 0x0A
    je fine_riga_trovata
    incl %ebx           
    jmp cerca_fine_riga

fine_riga_trovata:
    movb $0, (%esi,%ebx)     # sostituisci \n con \0 per isolare la riga
    incl %ebx                # sposta alla prossima riga

    # ora %edi punta alla riga corrente NULL-terminata

    pushl %edi               # passo il puntatore alla riga corrente alla funz cerca_codice 
    call cerca_codice
    add $4, %esp             # ripristino lo stack 

    jmp loop_righe

fine_buffer:
    # controlla se conteggio > 0 (per la divisione)
    movl conteggio, %eax
    cmp $0, %eax
    je stampa_nessun_esame

    # calcola media = somma / conteggio
    movl somma_voti, %eax
    xorl %edx, %edx          # azzera EDX per divisione senza segno
    movl conteggio, %ecx     # ECX = conteggio
    div %ecx                 # EAX = somma / conteggi, qui viene fatto edx:eax / ecx  (che lavora su 64 bit)
                             # (infatti edx == 0, perche segno positivo)

    # stampa "Media voti: "
    movl $4, %eax
    movl $1, %ebx
    movl $media_msg, %ecx
    movl $13, %edx
    int $0x80

    # stampa valore media
    call stampa_eax_decimal

    ret

stampa_nessun_esame:
    movl $4, %eax
    movl $1, %ebx
    movl $no_voti_msg, %ecx
    movl $35, %edx
    int $0x80
    ret
