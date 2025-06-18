.section .data
due_punti:     .byte ':'     
newline:       .byte 10
filename_ptr_fd_reg: .int 0
# fd_reg: .int 4

.section .bss
# .lcomm filename_ptr_fd_reg, 4
.lcomm fd_reg, 4
.lcomm buffer_lettura, 1
.lcomm matricola_buffer, 256
.lcomm esiti_buffer, 256

.section .text
.globl carica_file_reg
.type carica_file_reg, @function

carica_file_reg:
    # prologo
    pushl %ebp			# per prassi si pusha ebp sullo stack così che poi venga recuperato
    movl %esp, %ebp		# ciò a cui punta esp, ora punta anche ebp 
    

    # eax contiene il parametro (filename)
    movl 8(%ebp), %eax	# aggiungendo 8 si ottiene il parametro che abbiamo pushato prima della call. Se avessimo fatto 4, anziche 8, avrebbe recuperato il RETURN ADDRESS
    movl %eax, filename_ptr_fd_reg # spostiamo il nome del file in questa variabile

    # open(filename, O_RDONLY)
    movl $5, %eax
    movl filename_ptr_fd_reg, %ebx
    movl $0, %ecx
    int $0x80

    cmpl $0, %eax
    jl _error_open

    movl %eax, fd_reg	# quando si apre un file, ad eax viene assegnato un intero che rappresenta il file descriptor, assegnamolo alla variabile fd_reg

next_line:
    xorl %esi, %esi           	# indice matricola
    xorl %edi, %edi           	# indice contenuto
    xorl %ecx, %ecx            

skip_read_loop:			# funzione che legge skippando la prima riga
    movl $3, %eax             	# syscall read
    movl fd_reg, %ebx
    leal buffer_lettura, %ecx
    movl $1, %edx
    int $0x80

    cmpl $0, %eax
    jle close_and_exit		# errore se non riesce a leggere il file

    movzbl buffer_lettura, %eax
    cmpb $10, %al		# 10 = \n
    je matricola_read_loop	# appena trova '10' vai leggere la matricola
    jmp skip_read_loop
    
    # OK

matricola_read_loop:		# funzione che legge la matricola

    movl $3, %eax             # syscall read
    movl fd_reg, %ebx
    leal matricola_buffer(,%esi,1), %ecx
    movl $1, %edx
    int $0x80

    cmpl $0, %eax
    jle close_and_exit

    movzbl (%ecx), %eax       # carica il byte letto in %al
    cmpl $':', %eax
    je esiti_read_loop

    incl %esi
    jmp matricola_read_loop

esiti_read_loop:

    movl $3, %eax             # syscall read
    movl fd_reg, %ebx
    leal esiti_buffer, %ecx
    movl $1, %edx
    int $0x80
    
    movl $matricola_buffer, %ebx
    movb %al, (%ebx, %edi, 1)
    incl %edi
   
    
    cmpb $10, %al
    je funz_anagrafica
    jmp esiti_read_loop
    
funz_anagrafica:		# momentaneo
    int $0x80   

close_and_exit:
    movl $6, %eax
    movl fd_reg, %ebx
    int $0x80

    popl %ebp
    popl %ebx
    ret

_error_open:
    movl $1, %eax
    movl $1, %ebx
    int $0x80
    

