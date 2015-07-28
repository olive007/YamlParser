
CXX	=	g++

include		utils.mk

yamlParser_LD		=	$(CXX)
yamlParser_CFLAGS 	=	-I include
yamlParser_LDFLAGS 	=	
yamlParser_SRC		=	$(call rwildcard, src/, *.cpp)

$(eval $(call EXECUTABLE,yamlParser))
