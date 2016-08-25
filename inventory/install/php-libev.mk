# vim: set filetype=make:

ifndef __install_php-libev_included
__install_php-libev_included := 1

get_php-libev_version := 1


define install_php-libev
if [ -d /tmp/php-libev ]; then \
	cd /tmp/php-libev; git pull; \
else \
	git clone --depth=1 https://github.com/m4rw3r/php-libev.git /tmp/php-libev; \
fi
cd /tmp/php-libev && phpize && ./configure --with-libev && make && make install
echo "extension=libev.so" > /etc/php/5.6/cli/conf.d/20-phplibev.ini
endef

endif #__install_php-libev_included
