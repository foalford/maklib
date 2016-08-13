# vim: set filetype=make:
ifndef __install_composer_included
__install_composer_included := $(true)


define get_composer_version
$(shell composer -V | sed -ne "s/^.*version \([0-9\.]\+\).*/\1/p")
endef

# hardcode dependency on php
#
__composer_installdir := /usr/local/bin

define install_composer 
	curl https://getcomposer.org/installer > composer-setup.php
	php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
	php composer-setup.php --install-dir=$(__composer_installdir) --filename=composer
	php -r "unlink('composer-setup.php');"
endef

endif #__install_composer_included
