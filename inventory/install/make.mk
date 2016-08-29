# vim: set filetype=make:

ifndef __install_make_included
__install_make_included := $(true)

define get_make_version
$(shell make -v | sed -ne "s/^GNU Make //p")
endef

make_version ?= 4.2

define install_make
cd /tmp/ && curl https://ftp.gnu.org/gnu/make/make-$(make_version).tar.gz | tar xz 
cd make-$(make_version) && ./configure --prefix=/usr && make && make install && 
endef

endif #__install_make_included := $(true)
