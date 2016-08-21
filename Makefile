
#
# This Makefile can replicate itself and install on remote
# hosts

release_name := maklib.tgz
download_url := http://static.bitcoingroup.com.au/$(release_name)
installdir := /usr/local/include/$(basename $(release_name))

all: install

install:
	sudo mkdir -p $(installdir)
	if [ -f $(release_name) ] ; then \
		sudo tar xzf $(release_name) -C $(installdir) ; \
	else \
		curl -0 $(download_url) | sudo tar -xz -C $(installdir); \
	fi;

uninstall:
	sudo rm -r $(installdir)

clean:
	rm $(release_name)

build: $(release_name)

$(release_name): $(find inventory utils libs -type f) Makefile
	tar czf $(release_name) $(shell ls -d */)

release: build
	aws s3 cp $(release_name) s3://static.bitcoingroup.com.au/$(release_name)

-include utils/deploy-remote.mk
-include $(call look_for_hosts_def,test/hosts/staging)
ifdef REMOTE_HOST

SOURCES := Makefile $(release_name) 
$(eval $(call run_remote_target,$(SOURCES),install))

endif

.PHONY: release build all install clean

