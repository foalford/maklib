# vim: set filetype=make:

ifndef __install_php_included
__install_php_included := $(true)


php_version ?= 5.6

define get_php_version
$(shell php -v | sed -ne "s/^PHP \([1-9].[0-9]\+.[0-9]\+\).*/\1/p")
endef

define install_php
if [ ! -f /etc/apt/sources.list.d/ondrej-php-trusty.list ]; then \
	sudo add-apt-repository --yes ppa:ondrej/php; \
	sudo apt-get update; \
fi;
	sudo apt-get install -y php$(php_version) php$(php_version)-common \
		php$(php_version)-cli php$(php_version)-curl
endef

endif #__install_php_included
