AS_FLAGS = --32 
DEBUG = -gstabs
LD_FLAGS = -m elf_i386

all: bin/main

bin/main: obj/main.o obj/carica_file_reg.o
	ld $(LD_FLAGS)  obj/main.o obj/carica_file_reg.o -o bin/main

obj/main.o: src/main.s
	as $(AS_FLAGS) $(DEBUG) src/main.s -o obj/main.o
	
obj/carica_file_reg.o: src/carica_file_reg.s
	as $(AS_FLAGS) $(DEBUG) src/carica_file_reg.s -o obj/carica_file_reg.o

clean:
	rm -f obj/*.o bin/main
