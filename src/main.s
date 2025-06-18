.section .data
new_line_char:
	.byte 10
error_open_msg: .ascii "Errore: Impossibile aprire il file.\n"
error_open_msg_len: .int . - error_open_msg
due_punti: .byte ':'

filename_ptr_fd_anagrafica: .ascii "../data/anagrafica.txt"         # Puntatore al nome del file (da argv[1]) 

filename_ptr_fd_libretti: .ascii "../data/libretti.txt"

.section .bss
	.lcomm matricola_fd_reg, 1

.section .text
.align 4
	.global _start

_start:
	popl %ecx                   # argc in %ecx
    	popl %ebx                   # argv[0] (nome del programma) in %ebx - lo scartiamo per ora

	cmpl $2, %ecx				# verifica che il numero di argomenti sia 2
	jl stampa_menu

	popl %ebx					# argv[2] (parametro passato) in %ebx
	pushl %ebx
	call carica_file_reg
	# movl %ebx, filename_ptr_fd_reg
	
ancora:
	addl $8, %esp # all'inizio punterà all'elemento dello stack che contiene l'indirizzo della locazione di memoria che contiene, potenzialmente, un parametro 
				  
	movl (%esp), %eax # copia in eax il contenuto della locazione di memoria puntata da esp, ovvero il parametro che c'è nella riga di comando
	
	testl %eax, %eax # controlla se eax contiene NULL
	
	jz stampa_menu # esce dal ciclo se non ci sono altri parametri da recuperare # JUMP CHE GESTISCE LA MODALITA' CON O SENZA PARAMETRO
	pushl %eax	 # prima di fare la call, pushamo il parametro sullo stack
	call carica_file_reg # funzione che 'gestisce' il parametro

_error_open:

    movl $4, %eax               # syscall write
    movl $2, %ebx               # stderr
    movl $error_open_msg, %ecx	
    movl error_open_msg_len, %edx
    int $0x80
    jmp _exit_failure

_exit_failure:

    movl $1, %eax               # syscall exit
    movl $1, %ebx               # Codice di uscita 1 (errore)
    int $0x80

stampa_menu:			 # provvisorio, giusto per farlo compilare
    movl $4, %eax
    movl $1, %ebx
    leal due_punti, %ecx
    movl $1, %edx
    int $0x80