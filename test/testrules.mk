# Default Make rules for test

.PHONY: all 
all: $(SRC_DIR) $(EXEC_FILES) $(LIB)

# For tests, each object turns into an executable
$(EXEC_FILES): $(BUILD_DIR)/%: $(BUILD_DIR)/%.o | $(BUILD_DIR)
	$(CC) $(LDFLAGS) $(LINKED_OBJ_FILES) $< -o $@

.PHONY: $(SRC_DIR)
$(SRC_DIR):
	$(MAKE) -C $(SRC_DIR)
