# Mac settings
LLVM_VERSION_MAJOR ?= 22
LLVM_DIR ?= /opt/homebrew/opt/llvm@$(LLVM_VERSION_MAJOR)

CC = $(LLVM_DIR)/bin/clang
CXX = $(LLVM_DIR)/bin/clang++
LD = $(LLVM_DIR)/bin/lld.ld64
AR = $(LLVM_DIR)/bin/llvm-ar

SRC_ROOT = llvmir_examples
TEST_ROOT = test
BUILD_ROOT = build
TEST_BUILD_ROOT = build_test
BIN_ROOT = bin

ifdef LIB_NAME
LIB = $(BUILD_DIR)/lib$(LIB_NAME).a
endif

ifdef EXEC
EXEC_FILE = $(addprefix $(BUILD_DIR)/, $(EXEC))
endif

ifdef OBJS
OBJ_FILES = $(addprefix $(BUILD_DIR)/, $(addsuffix .o, $(OBJS)))
endif

ifdef C_OBJS
C_OBJ_FILES = $(addprefix $(BUILD_DIR)/, $(addsuffix .o, $(C_OBJS)))
endif

.PHONY: print-%
print-%:
	@echo '$*=$($*)'
