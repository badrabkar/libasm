
OBJDIR=objs
SRCDIR=srcs

CC=gcc
CFLAGS= -Wall -Wextra -Werror -g  
AS=nasm
ASFLAGS=-f elf64
AR=ar
ARFLAGS=r 
# r: insert/update file into an archive
# c: create the file silently without  printing a warning message
#

# := (Simply Expaned variable assignment) is used instead of = (RecursivelyEVA) 
# 	because will execute any function in the variable
# 	every the variable is expanded making make run slower
SRCS:=$(wildcard $(SRCDIR)/*.s)
# we can't use this $(SRCDIR)/*.s because wildcard expansion
# 	does not happend when you define a variable
OBJECTS:=$(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(SRCS))
# find the pattern srcs/%.s in $(SRCS) and replace \
	# it with objs/%.o
# we can also use Substitution Reference \
	# $(var:pattern=replacement)  $(SRCS:$(SRCDIR)/%.s=$(OBJDIR)/%.o)
# they do the same thing

LIBRARY=libasm.a
BINARY=mainc

all: $(BINARY)

test: $(LIBRARY)
	make -C tests/

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




