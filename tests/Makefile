NASM   = nasm
CC     = gcc
CFLAGS = -Wall -Wextra -g

all: test_ft_strlen

ft_strlen.o: ft_strlen.s
	$(NASM) -f elf64 -g -F dwarf ft_strlen.s -o ft_strlen.o

test_ft_strlen: test_ft_strlen.c ft_strlen.o
	$(CC) $(CFLAGS) -o test_ft_strlen test_ft_strlen.c ft_strlen.o

test: test_ft_strlen
	./test_ft_strlen

clean:
	rm -f ft_strlen.o test_ft_strlen

.PHONY: all test clean
