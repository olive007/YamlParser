# utils.mk
# Makefile epitech
# Auteur SECRET Olivier

CC		?=	gcc
CXX		?=	g++
AR		?=	ar
RANLIB		?=	ranlib

DEBUG		?=	0
VERBOSE		?=	0
OPTI		?=	3

CFLAGS		?=	-W -Wall -Wextra

BIN_DIR		?=	bin
BUILD_DIR	?=	.build

ifeq ($(DEBUG),0)
ifneq ($(OPTI),0)
CFLAGS		+=	-O$(OPTI)
endif
else
CFLAGS		+=	-ggdb3
endif

ifeq ($(VERBOSE),0)
V		=	@
PRETTY		=	@printf " %-8s %s\n" "$(1)" "$(2)"
ifdef TERM
BLACK_COL	=	@tput setaf 0
RED_COL		=	@tput setaf 1
GREEN_COL	=	@tput setaf 2
YELLOW_COL	=	@tput setaf 3
BLUE_COL	=	@tput setaf 4
MAGENTA_COL	=	@tput setaf 5
CYAN_COL	=	@tput setaf 6
WHITE_COL	=	@tput setaf 9
endif
else
V		=
PRETTY		=
endif

DEP		=  $(BUILD_DIR)/$(1).mk
DEPS		=  $(foreach SRC,$(1),$(call DEP,$(SRC)))

# Default Rules
all:
clean:
fclean:	clean
	$(RED_COL)
	$(call PRETTY,RM,build directory)
	$(V)rm -rf $(BUILD_DIR)
	$(WHITE_COL)
re:		fclean all
.PHONY:		all clean fclean re

$(BUILD_DIR)/%.c.o: %.c
	$(GREEN_COL)
	$(V)mkdir -p $(dir $@)
	$(call PRETTY,CC,$<)
	$(RED_COL)
	$(V)$(CC) -MMD -MF $(call DEP,$<) -c -o $@ $< $(CFLAGS)
	$(WHITE_COL)

$(BUILD_DIR)/%.cpp.o: %.cpp
	$(GREEN_COL)
	$(V)mkdir -p $(dir $@)
	$(call PRETTY,CXX,$<)
	$(RED_COL)
	$(V)$(CXX) -MMD -MF $(call DEP,$<) -c -o $@ $< $(CFLAGS)
	$(WHITE_COL)

## Recursive wildcard

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

## Common rules
define COMMON_RULES

$1_OBJ	=	$(foreach SRC,$($1_SRC),$(BUILD_DIR)/$(SRC).o)
$1_DEPS	=	$$(call DEPS,$$($1_SRC))

### clean rule
clean_$1:
	$(RED_COL)
	$$(call PRETTY,"RM",$1 objects)
	$(V)rm -f $$($1_OBJ)
	$(V)rm -f $$($1_DEPS)
	$(WHITE_COL)

clean:		clean_$1

### fclean rule
fclean_$1:
	$(RED_COL)
	$$(call PRETTY,"RM",$1)
	$(V)rm -f $(BIN_DIR)/$1
	$(WHITE_COL)

fclean:		fclean_$1

.PHONY:		clean_$1 fclean_$1
endef

define EXECUTABLE
$$(eval $$(call COMMON_RULES,$(1)))

-include	$$($1_DEPS)

### executable build rule
$(BIN_DIR)/$1:		CFLAGS += $$($1_CFLAGS)
$(BIN_DIR)/$1:		$$($1_BUILD_DEPS)
$(BIN_DIR)/$1:		$$($1_OBJ)
		$(GREEN_COL)
		$(call PRETTY,"LD",$1)
		$(RED_COL)
		$(V)$($1_LD) -o $(BIN_DIR)/$1 $$($1_OBJ) $(CFLAGS) $($1_LDFLAGS)
		$(WHITE_COL)

all:		$(BIN_DIR)/$1
endef
