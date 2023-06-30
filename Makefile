# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: dacortes <dacortes@student.42barcelona.    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/06/09 17:39:21 by dacortes          #+#    #+#              #
#    Updated: 2023/06/15 18:02:21 by dacortes         ###   ########.fr        #
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
C_FILE_CLIENT = 0
P_BAR_CLIENT :=
C_FILE_SERVER = 0
P_BAR_SERVER :=
CURRENT_FILE = 0
PROGRESS_BAR :=
################################################################################
#							 SOURCES                                           #
################################################################################

SRC_SERVER = server.c
SRC_CLIENT = client.c
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
OBJ_SERVER = $(addprefix $(D_OBJ)/, $(SRC_SERVER:.c=.o))
DEP_SERVER = $(addprefix $(D_OBJ)/, $(SRC_SERVER:.c=.d))
################################################################################
#	Client                                                                     #
################################################################################
OBJ_CLIENT = $(addprefix $(D_OBJ)/, $(SRC_CLIENT:.c=.o))
DEP_CLIENT = $(addprefix $(D_OBJ)/, $(SRC_CLIENT:.c=.d))
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
all: dir $(NAME)
-include $(DEP_SERVER)
-include $(DEP_CLIENT)
dir:
	make bonus -C $(LIBFT)
	-mkdir  $(D_OBJ)
$(D_OBJ)/%.o:$(L_SRC)/%.c
	$(CC) -MMD $(FLAGS) -c $< -o $@ $(INC)
#$(eval CURRENT_FILE := $(shell echo $$(($(CURRENT_FILE) + 1)))) \
#$(eval PROGRESS_BAR := $(shell awk "BEGIN { printf \"%.0f\", $(CURRENT_FILE)*100/$(TOTAL_FILES) }")) \
#printf "$B$(ligth)⏳Compiling pipex:$E $(ligth)%-30s [%-50s] %d%%\r" "$<..." "$(shell printf '=%.0s' {1..$(shell echo "$(PROGRESS_BAR)/2" | bc)})" $(PROGRESS_BAR)

$(N_SERVER): $(OBJ_SERVER)
	$(CC) $(FLAGS) $(OBJ_SERVER) $(L_LIB) -o $(N_SERVER) $(INC)
	$(eval C_FILE_SERVER := $(shell echo $$(($(C_FILE_SERVER) + 1)))) \
	$(eval PROGRESS_BAR := $(shell awk "BEGIN { printf \"%.0f\", $(C_FILE_SERVER)*100/$(TOTAL_SERVER) }")) \
	printf "$B$(ligth)⏳Compiling server:$E $(ligth)%-30s [%-50s] %d%%\r" "$<..." "$(shell printf '=%.0s' {1..$(shell echo "$(P_BAR_SERVER)/2" | bc)})" $(P_BAR_SERVER)

$(N_CLIENT): $(OBJ_CLIENT)
	$(CC) $(FLAGS) $(OBJ_CLIENT) $(L_LIB) -o $(N_CLIENT) $(INC)

$(NAME): $(OBJ_SERVER) $(OBJ_CLIENT)
	$(MAKE) $(N_SERVER)
	$(MAKE) $(N_CLIENT)
	echo "\n\n✅ ==== $(B)$(ligth)Project minitalk compiled!$(E) ==== ✅"

################################################################################
#							 CLEAN                                        	   #
################################################################################

.PHONY: all clean fclean re
fclean: clean
	$(RM) $(NAME)
	make fclean -C $(LIBFT)
	echo "✅ ==== $(P)$(ligth)pipex executable files and name cleaned!$(E) ==== ✅\n"
clean:
	$(RM) $(D_OBJ)
	make clean -C $(LIBFT)
	echo "✅ ==== $(P)$(ligth)pipex object files cleaned!$(E) ==== ✅"
re: fclean all
TOTAL_CLIENT := $(words $(SRC_CLIENT))
TOTAL_SERVER := $(words $(SRC_SERVER))
TOTAL_FILES := $(words $(SRC))
.SILENT: