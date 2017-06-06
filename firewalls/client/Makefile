SUBDIRS  = $(wildcard */.)
ALLTEST  = $(SUBDIRS:%=test-%)
ALLCLEAN = $(SUBDIRS:%=clean-%)

all:
	@echo 'Not supported, run `make test`, instead.'

.PHONY: test $(ALLTEST)
test: $(ALLTEST)
$(ALLTEST):
	$(MAKE) -C $(@:test-%=%) test clean

.PHONY: clean $(ALLCLEAN)
clean: $(ALLCLEAN)
$(ALLCLEAN):
	$(MAKE) -C $(@:clean-%=%) clean
