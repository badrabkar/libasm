
OBJDIR=objs
SRCDIR=srcs

CC=gcc
CFLAGS= -g  
AS=nasm
ASFLAGS=-f elf64
AR=ar
ARFLAGS=rcs

SRCS:= ft_strlen.s ft_strcpy.s ft_strcmp.s ft_write.s ft_read.s ft_strdup.s
SRCS := $(addprefix $(SRCDIR)/, $(SRCS))
OBJS:=$(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(SRCS))

SRCS_BONUS:= ft_atoi_base_bonus.s
SRCS_BONUS := $(addprefix $(SRCDIR)/, $(SRCS_BONUS)) # srcs/ft_atoi_base_bonus.s
OBJS_BONUS:=$(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(SRCS_BONUS))
#			srcs/%.s, srcs/%.o, [.s, .s, .s]

NAME=libasm.a
BINARY=mainc

all: $(BINARY) 

$(BINARY) : $(NAME) main.c
	$(CC) $(CFLAGS) main.c -L. -lasm -o $@

$(NAME): $(OBJS)
	$(AR) $(ARFLAGS) $@ $^

$(OBJDIR)/%.o: $(SRCDIR)/%.s libasm.h
	@mkdir -p $(OBJDIR)
	$(AS) $(ASFLAGS) $< -o $@

bonus: $(NAME) $(OBJS_BONUS) 
	$(AR) $(ARFLAGS) $(NAME) $(OBJS_BONUS)

test: $(NAME) 
	$(MAKE) -C libasmTester/ $(filter-out test,$(MAKECMDGOALS))

clean:
	rm -rf $(OBJDIR)

fclean: clean
	rm -f $(BINARY) $(NAME)

re: fclean all

.PHONY: all clean fclean re bonus
