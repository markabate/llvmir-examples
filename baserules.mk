$(LIB): $(OBJ_FILES) $(C_OBJ_FILES) | $(BUILD_DIR)
	$(AR) rsc $@ $(OBJ_FILES) $(C_OBJ_FILES)

$(EXEC_FILE): $(OBJ_FILES) $(C_OBJ_FILES) $(LINKED_OBJ_FILES) | $(BUILD_DIR)
	$(CC) $(LDFLAGS) $(LINKED_OBJ_FILES) $< -o $@
 
$(OBJ_FILES): $(BUILD_DIR)/%.o: %.ll | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(C_OBJ_FILES): $(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
