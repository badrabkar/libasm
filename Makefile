
OBJDIR=objs
SRCDIR=srcs

CC=gcc
CFLAGS= -Wall -Wextra -Werror -g  
AS=nasm
ASFLAGS=-f elf64
AR=ar
ARFLAGS=rs

SRCS:=$(wildcard $(SRCDIR)/*.s)
OBJECTS:=$(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(SRCS))

LIBRARY=libasm.a
BINARY=mainc

all: $(BINARY)

lib: $(LIBRARY)

test: all
	$(MAKE) -C libasmTester/ $(filter-out test,$(MAKECMDGOALS))

$(BINARY) : $(LIBRARY) main.c
	$(CC) main.c -L. -lasm -o $@

$(LIBRARY): $(OBJECTS)
	$(AR) $(ARFLAGS) $@ $^

$(OBJDIR)/%.o: $(SRCDIR)/%.s libasm.h
	@mkdir -p $(OBJDIR)
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -rf $(OBJDIR)

fclean: clean
	rm -f $(BINARY) $(LIBRARY)

re: fclean all

.PHONY: all clean fclean re


