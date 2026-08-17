include basedefs.mk

BUILD_DIRS = $(BUILD_ROOT) $(TEST_BUILD_ROOT) $(BIN_ROOT) 

.PHONY: all
all: | $(BUILD_ROOT) $(BIN)
	$(MAKE) -C $(SRC_ROOT)

.PHONY: test
test: | $(TEST_BUILD_ROOT)
	$(MAKE) -C $(TEST_ROOT)

.PHONY:  $(BUILD_DIRS)
$(BUILD_DIRS): %:
	mkdir -p $*

.PHONY: clean
clean:
	rm -rf $(BUILD_DIRS) 

.PHONY: clean-test
clean-test:
	rm -rf $(TEST_BUILD_ROOT)
