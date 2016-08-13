# vim: set filetype=make:

ifndef __install_php-libev_included
__install_php-libev_included := $(true)

define get_php-libev_version
1
endef


define install_php-libev
git clone --depth=1 https://github.com/m4rw3r/php-libev.git /tmp/php-libev
cd /tmp/php-libev && phpize && ./configure --with-libev && make && make install
echo "extension=libev.so" > /etc/php/5.6/cli/conf.d/20-phplibev.ini
endef

endif #__install_php-libev_included
