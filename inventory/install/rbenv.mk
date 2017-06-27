ifndef __install_rbenv_included
__install_rbenv_included := $(true)

define get_rbenv_version
	$(shell rbenv version | sed -ne 's/^\([0-9\.]\+\).*/\1/p')
endef

rbenv_init_file := $(firstword \
	$(foreach d,$(.INCLUDE_DIRS),$(wildcard $d/maklib/inventory/install/rbenv/rbenv-init.sh)))

define install_rbenv
	if [ ! -d rbenv ]; then \
		git clone --depth=1 https://github.com/rbenv/rbenv.git rbenv; \
	fi
	if [ ! -d rbenv/plugins/ruby-build ]; then \
		git clone --depth=1 https://github.com/rbenv/ruby-build.git rbenv/plugins/ruby-build; \
	fi
	cp $(rbenv_init_file)  deployrc
endef

endif #__install_rbenv_included := $(true)
