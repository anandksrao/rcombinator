.DEFAULT_GOAL := all

# Options for valgrind on/off in strings
mem_check = "on"

# Library files exposed to C++ and R
SRC_DIR = src/
# Functions exposed only to C++
CPP_DIR  = cpp/
# Object files generated by compilation
OBJ_DIR = obj/
# Test source files
TEST_DIR = test_cpp/
# Test object files generated by compilation
TEST_OBJ_DIR = test_obj/

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(TEST_OBJ_DIR):
	mkdir -p $(TEST_OBJ_DIR)

CC = g++
CCFLAGS = -I./$(SRC_DIR) -I./$(CPP_DIR) -Wall -Wextra
CCTESTFLAGS = -I./$(TEST_DIR)

ifeq ($(mem_check), "on")
	CCFLAGS += -g -O0
endif


_HEADERS = exception.h					\
		   constants.h					\
		   utilities.h					\
		   rand_maths.h					\
		   sequence.h					\
		   family.h						\
		   point_mutation_models.h		\
		   point_mutator.h				\
		   output.h						\
		   evolution.h					\
		   evolution_without_flags.h	\
		   evolution_with_flags.h		\
		   simulation.h
HEADERS := $(addprefix $(SRC_DIR), $(_HEADERS))

_SRCS = rand_maths.o				\
		utilities.o					\
		sequence.o					\
		family.o					\
		point_mutation_models.o		\
		point_mutator.o				\
		output.o					\
		evolution.o					\
		evolution_without_flags.o	\
		evolution_with_flags.o		\
		simulation.o
SRCS := $(addprefix $(OBJ_DIR), $(_SRCS))

_OBJS = main.o
OBJS := $(addprefix $(OBJ_DIR), $(_OBJS))

TEST_HEADERS = test_header.h					\
			   test_sequence.h					\
			   test_utilities.h					\
			   test_family.h					\
			   test_point_mutation_models.h     \
			   test_point_mutator.h             \
			   test_output.h					\
			   test_evolution_without_flags.h	\
			   test_evolution_with_flags.h		\
			   test_simulation.h
TEST_HEADERS := $(addprefix $(TEST_DIR), $(TEST_HEADERS))

_TESTS = test.o
TESTS := $(addprefix $(TEST_OBJ_DIR), $(_TESTS))

TARGET = rcombinator
TEST_TARGET = test_rcombinator

$(OBJ_DIR)%.o: $(CPP_DIR)%.cpp $(HEADERS) | $(OBJ_DIR)
	$(CC) -c $(CPP_DIR)$*.cpp -o $(OBJ_DIR)$*.o $(CCFLAGS)

$(OBJ_DIR)%.o: $(SRC_DIR)%.cpp $(HEADERS) | $(OBJ_DIR)
	$(CC) -c $(SRC_DIR)$*.cpp -o $(OBJ_DIR)$*.o $(CCFLAGS)

$(TEST_OBJ_DIR)%.o: $(TEST_DIR)%.cpp $(HEADERS) $(TEST_HEADERS) | $(TEST_OBJ_DIR)
	$(CC) -c $(TEST_DIR)$*.cpp -o $(TEST_OBJ_DIR)$*.o $(CCFLAGS) $(CCTESTFLAGS)

$(TARGET): $(OBJS) $(SRCS)
	$(CC) -o $@ $^ $(CCFLAGS)

$(TEST_TARGET): $(TESTS) $(SRCS)
	$(CC) -o $@ $^ $(CCFLAGS) $(CCTESTFLAGS)

.PHONY: target
target: $(TARGET)

.PHONY: test
test: $(TEST_TARGET)

.PHONY: all
all: target test

.PHONY: clean
clean:
	rm -f $(OBJ_DIR)*.o $(TARGET)
	rm -d -f $(OBJ_DIR)
	rm -f $(TEST_OBJ_DIR)*.o $(TEST_OBJ_DIR)*.out $(TEST_TARGET)
	rm -d -f $(TEST_OBJ_DIR)
