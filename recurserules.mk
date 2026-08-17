.PHONY: all
all: $(SUBDIRS)

.PHONY: $(SUBDIRS)
$(SUBDIRS): %:
	$(MAKE) -C $@

SUBDIRS_CLEAN = $(addsuffix -clean, $(SUBDIRS))
.PHONY: clean
clean: $(SUBDIRS_CLEAN)

.PHONY: $(SUBDIRS_CLEAN)
$(SUBDIRS_CLEAN): %-clean:
	$(MAKE) -C $* clean