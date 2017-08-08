SUBDIRS  = $(wildcard */.)
TESTALL  = $(SUBDIRS:%=test-%)
CLEANALL = $(SUBDIRS:%=clean-%)

all:
	@echo 'Not supported, run `make test`, instead.'

.PHONY: test $(TESTALL)
test: $(TESTALL)
$(TESTALL):
	$(MAKE) -C $(@:test-%=%) test clean

.PHONY: clean clean-all $(CLEANALL)
clean clean-all: $(CLEANALL)
$(CLEANALL):
	$(MAKE) -C $(@:clean-%=%) clean
