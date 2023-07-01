# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: dacortes <dacortes@student.42barcelona.    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/06/09 17:39:21 by dacortes          #+#    #+#              #
#    Updated: 2023/07/01 12:07:43 by dacortes         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

################################################################################
#							 VARIABLES                                         #
################################################################################

NAME = minitalk
CC = gcc
RM = rm -rf
LIBC = ar -rcs
FLAGS = -Wall -Wextra -Werror #-fsanitize=address
N_CLIENT = client
N_SERVER = server
################################################################################
#	Bar									                                       #
################################################################################
CURRENT_FILE = 0
PROGRESS_BAR :=
################################################################################
#							 SOURCES                                           #
################################################################################

SRC = server.c client.c
LIBFT = ./libft/
L_SRC = ./src
L_LIB = ./libft/libft.a
INC			=	-I ./inc/\
				-I ./libft/\
				
################################################################################
#							 DIRECTORIES                                       #
################################################################################

D_OBJ = $(L_SRC)/obj
################################################################################
#	Server                                                                     #
################################################################################
OBJ_SERVER = $(addprefix $(D_OBJ)/, $(SRC:.c=.o))
DEP_SERVER = $(addprefix $(D_OBJ)/, $(SRC:.c=.d))
################################################################################
#	Client                                                                     #
################################################################################
OBJ_CLIENT = $(addprefix $(D_OBJ)/, $(SRC:.c=.o))
DEP_CLIENT = $(addprefix $(D_OBJ)/, $(SRC:.c=.d))
################################################################################
#							 BOLD COLORS                                       #
################################################################################

E = \033[m
R = \033[31m
G = \033[32m
Y = \033[33m
B = \033[34m
P = \033[35m
C = \033[36m
################################################################################
#	Font                                                                       #
################################################################################
ligth = \033[1m
dark = \033[2m
italic = \033[3m
################################################################################
#							 MAKE RULES                                        #
################################################################################
all: dir
	$(MAKE) $(N_SERVER) --no-print-directory
	$(MAKE) $(N_CLIENT) --no-print-directory

-include $(DEP_SERVER)
-include $(DEP_CLIENT)
dir:
	make -C $(LIBFT) --no-print-directory
	-mkdir  $(D_OBJ)

$(D_OBJ)/%.o:$(L_SRC)/%.c
	$(CC) -MMD $(FLAGS) -c $< -o $@ $(INC)
	$(eval CURRENT_FILE := $(shell echo $$(($(CURRENT_FILE) + 1)))) \
	$(eval PROGRESS_BAR := $(shell awk "BEGIN { printf \"%.0f\", $(CURRENT_FILE)*100/$(TOTAL_FILES) }")) \
	printf "\r$B$(ligth)⏳Compiling libft:$E $(ligth)%-30s [$(CURRENT_FILE)/$(TOTAL_FILES)] [%-50s] %3d%%\033[K" \
	"$<..." "$(shell printf '$(G)█%.0s$(E)$(ligth)' {1..$(shell echo "$(PROGRESS_BAR)/2" | bc)})" $(PROGRESS_BAR)
	
	@if [ $(PROGRESS_BAR) = 100 ]; then \
		echo "$(B) All done$(E)"; \
	fi

$(N_SERVER): $(OBJ_SERVER)
	$(CC) $(FLAGS) $(D_OBJ)/server.o $(L_LIB) -o $(N_SERVER) $(INC)
	
$(N_CLIENT): $(OBJ_CLIENT)
	$(CC) $(FLAGS) $(D_OBJ)/client.o $(L_LIB) -o $(N_CLIENT) $(INC)
################################################################################
#							 CLEAN                                        	   #
################################################################################

.PHONY: all clean fclean re
fclean: clean
	$(RM) $(NAME) $(N_CLIENT) $(N_SERVER)
	make fclean -C $(LIBFT) --no-print-directory
	echo "✅ ==== $(P)$(ligth)pipex executable files and name cleaned!$(E) ==== ✅\n"
clean:
	$(RM) $(D_OBJ)
	make clean -C $(LIBFT) --no-print-directory
	echo "✅ ==== $(P)$(ligth)pipex object files cleaned!$(E) ==== ✅"
re: fclean all
TOTAL_FILES := $(words $(SRC))
.SILENT: