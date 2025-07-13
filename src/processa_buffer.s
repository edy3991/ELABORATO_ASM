# La sua funzione e' quella di prendere la riga che gli e' stata passata e suddividere gli esami per matricola per poi 
# fare una call per ogni "riga creata" cioe ogni esame sostenuto da una matricola
.section .data
# somma_voti: .long 0
# conteggio:  .long 0
no_voti_msg: .asciz "Nessuno studente ha sostenuto l'esame.\n"
media_msg: .asciz "Media voti: "
.globl somma_voti     # rimuovere da qui fino le 4 righe sotto 
.globl conteggio      
somma_voti: .long 0
conteggio:  .long 0

.bss
.lcomm buffer_out, 16



.section .text 
.global processa_buffer
.type processa_buffer, @function
processa_buffer:
    pushl %ebp             # salvo il vecchio base pointer
    movl %esp, %ebp        # imposto il nuovo frame

    movl $0, somma_voti
    movl $0, conteggio
 

    # Argomenti: [ebp+8] = indirizzo(buffer), [ebp+12] = dimensione

    # inizializza puntatore buffer
    movl 8(%ebp), %esi      # %esi <- puntatore inizio buffer
    movl 12(%ebp), %ecx     # %ecx = dimensione buffer
    xorl %ebx, %ebx         # offset nel buffer = 0
    
loop_righe:                 # se l'offset ha superato il numero di byte del buffer, siamo alla fine del file
    cmp %ecx, %ebx          # controllo se ebx (partito da 0) ha raggiunto %exc 
    
    jge fine_buffer

  #  lea 0(%esi,%ebx), %edi   # %edi punta alla riga corrente, mi calcola edi = (esi + ebx * 1) + 0  il *1 e' sottointeso
 # MODIFICATO LA RIGA PRECEDENTE E SPOSTATA SOTTO CON EAX AL POSTO DI EBX 
    # cerca newline e sostituisce con \0
    movl %ebx, %eax          # salviamo posizione inizio riga in eax, eax viene usato per scorrere

cerca_fine_riga:             # vado quindi a esaminare carattere per carattere, scorro ebx    
    cmp %ecx, %ebx           # confronto posizione_attuale = dim_buffer per vedere se sono alla fine e evitare overflow
    
    jge fine_buffer          # se la codizione prima e' vera, allora salto 
    cmpb $0x0A, (%esi,%ebx)  # verifica se il carattere (%esi + %ebx) e' uguale a \n = 0x0A
    je fine_riga_trovata
    incl %ebx                # passo al prossimo carattere
    jmp cerca_fine_riga

fine_riga_trovata:
    # trasformo la riga nello stile riga C con \0 alla fine
    movb $0, (%esi,%ebx)     # sostituisci \n con \0 per isolare la riga
    incl %ebx                # sposta alla prossima riga

    # ora %edi punta alla riga corrente NULL-terminata
    lea 0(%esi,%eax), %edi
    pushl %ebx 
    pushl %ecx 
    pushl %edi               # passo il puntatore alla riga corrente alla funz cerca_codice 
    int3
    call cerca_codice
    int3
    add $4, %esp             # ripristino lo stack 
    popl %ecx
    popl %ebx
    movl %ebx, %eax 
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
    movl %eax, %esi                      # (infatti edx == 0, perche segno positivo)
    
    # stampa "Media voti: "
    movl $4, %eax
    movl $1, %ebx
    movl $media_msg, %ecx
    movl $13, %edx
    int $0x80

    # stampa valore media
    
        # Converti il numero in ASCII (da EAX a una stringa in reverse)
    movl %esi, %eax 
    movl $buffer_out + 10, %edi   # %edi punta alla fine del buffer (10 cifre max)
    movb $0, -1(%edi)             # null-terminator
    decl %edi

converti_ciclo:
    xorl %edx, %edx               # azzera edx prima di div
    movl $10, %ebx
    divl %ebx                     # eax = eax / 10, edx = resto
    addb $'0', %dl                # da cifra numerica a ASCII
    movb %dl, (%edi)              # salva nel buffer
    decl %edi
    testl %eax, %eax
    jnz converti_ciclo

    incl %edi                     # ora EDI punta all'inizio stringa

    # Scrivi su stdout con syscall write
    movl $4, %eax                 # syscall number: sys_write
    movl $1, %ebx                 # fd: stdout
    movl %edi, %ecx               # pointer al buffer
    movl $buffer_out + 10, %edx   # fine del buffer
    subl %edi, %edx               # calcola lunghezza stringa
    int $0x80                     # esegui syscall



    # call stampa_eax_decimal
    leave
    ret

stampa_nessun_esame:
    movl $4, %eax
    movl $1, %ebx
    movl $no_voti_msg, %ecx
    movl $39, %edx
    int $0x80

    movl %ebp, %esp  # 21
    popl %ebp        # 21
    ret
