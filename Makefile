
#
# This Makefile can replicate itself and install on remote
# hosts

release_name := maklib.tgz
installdir := /usr/local/include/$(basename $(release_name))

all: install

install: 
	mkdir -p $(installdir)
	if [ -f $(release_name) ] ; then \
		tar xzf $(release_name) -C $(installdir) ; \
	fi;

-include maklib/utils/check
-include maklib/inventory/install/make.mk
deps: $(call require,make,4.2)
	echo 'requires make 4.2'

uninstall:
	rm -r $(installdir)

clean:
	rm $(release_name)

# ####################
# Conditionally include build target in case 
# It's a deployment only task
# ####################
ifeq ($(shell if [ -d inventory ];then echo 1;fi),1)

build: $(release_name)

$(release_name):  Makefile $(shell find inventory utils libs -type f)
	@echo "making tarball..."
	@tar czf $(release_name) $(wordlist 2,$(words $^), $^)


install : build deps

.PHONY: build make4.2
endif
# #################### 


ifdef REMOTE_HOST

-include maklib/utils/deploy-remote.mk
-include $(call look_for_hosts_def)

SOURCES := Makefile $(release_name) 
install_remote : $(call install_remote,$(SOURCES),install)
	@echo 'Install remotely'

endif

.PHONY: deps all install clean

