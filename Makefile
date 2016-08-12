
release_name := maklib.tgz
download_url := http://static.bitcoingroup.com.au/$(release_name)
installdir := /usr/local/include/$(basename $(release_name))

all: tempdir := $(shell mktemp -ud)

all: install

install:
	sudo mkdir -p $(installdir)
	curl -0 $(download_url) | sudo tar -xz -C $(installdir)

uninstall:
	sudo rm -r $(installdir)

build:
	tar czf makelib.tgz $(shell ls -d */)

release: build
	aws s3 cp makelib.tgz s3://static.bitcoingroup.com.au/$(release_name)

.PHONY: release build all install

