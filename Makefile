
CC=gcc
CFLAGS= -g -Wall -Wextra -Werror
AS=nasm
ASFLAGS=-f elf64
AR=ar
ARFLAGS=rcs 
#r: tells the ar command to insert or replace the object file with new ones
#c: tells the ar command to create the library if it doesn't exist
#s: tells the ar command to 
SRCS=ft_strlen.s ft_strcpy.s
OBJS=$(SRCS:.s=.o)


LIB=libasm.a
NAME=mainc

all: $(NAME)


$(NAME) : $(LIB) main.c
	$(CC) main.c $(LIB) -o $@

$(LIB): $(OBJS)
	$(AR) $(ARFLAGS) $@ $^

%.o: %.s
	$(AS) $(ASFLAGS) $^ -o $@

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(NAME) $(LIB)

re: fclean all

.PHONY: all clean fclean re




