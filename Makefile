
release_name := maklib.tgz
download_url := http://static.bitcoingroup.com.au/$(release_name)
installdir := /usr/local/include/$(basename $(release_name))

all: tempdir := $(shell mktemp -ud)

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

build:
	tar czf $(release_name) $(shell ls -d */)

release: build
	aws s3 cp makelib.tgz s3://static.bitcoingroup.com.au/$(release_name)

.PHONY: release build all install

