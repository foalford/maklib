# vim: set filetype=make:

ifndef __install_php_included
__install_php_included := $(true)


php_version ?= 5.6

define get_php_version
$(shell php -v | sed -ne "s/^PHP \([1-9].[0-9]\+.[0-9]\+\).*/\1/p")
endef

define install_php
	sudo add-apt-repository --yes ppa:ondrej/php
	sudo apt-get update
	sudo apt-get install php$(php_version)
endef

endif #__install_php_included
