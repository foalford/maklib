
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

release: build
	aws s3 cp $(release_name) s3://static.bitcoingroup.com.au/$(release_name)

install : build

.PHONY: build
endif
# #################### 

-include utils/deploy-remote.mk
-include $(call look_for_hosts_def)

ifdef REMOTE_HOST

-include inventory/install/make.mk
install_remote: $(call require,make,4.2)


SOURCES := Makefile $(release_name) 
install_remote : $(call install_remote,$(SOURCES),install)
	@echo 'Install remotely'

endif

.PHONY: release all install clean

