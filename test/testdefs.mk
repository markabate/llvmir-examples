ifdef EXECS
EXEC_FILES = $(addprefix $(BUILD_DIR)/, $(EXECS))
endif

ifdef SRC_OBJS
SRC_OBJ_FILES = $(addprefix $(SRC_BUILD_DIR)/, $(addsuffix .o, $(SRC_OBJS)))
endif

LDFLAGS += -L$(TEST_BUILD_ROOT_PATH)/test_utils -ltest_utils
LINKED_OBJ_FILES += $(SRC_OBJ_FILES)
