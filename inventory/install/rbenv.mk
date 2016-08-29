ifndef __install_rbenv_included
__install_rbenv_included := $(true)

define get_rbenv_version
	$(shell rbenv version | sed -ne 's/^\([0-9\.]\+\).*/\1/p')
endef

rbenv_init_file := $(firstword \
	$(foreach d,$(.INCLUDE_DIRS),$(wildcard $d/maklib/inventory/install/rbenv/rbenv-init.sh)))

define install_rbenv
	if [ ! -d ~$(USERNAME)/.rbenv ]; then \
		$(SUDO) git clone --depth=1 https://github.com/rbenv/rbenv.git ~$(USERNAME)/.rbenv; \
		$(SUDO) echo 'export PATH="$$HOME/.rbenv/bin:$$PATH"' >> ~$(USERNAME)/.bashrc; \
		$(SUDO) echo 'export PATH="$$HOME/.rbenv/bin:$$PATH"' >> ~$(USERNAME)/.zshenv; \
	fi
	if [ ! -d ~$(USERNAME)/.rbenv/plugins/ruby-build ]; then \
		$(SUDO) git clone --depth=1 https://github.com/rbenv/ruby-build.git ~$(USERNAME)/.rbenv/plugins/ruby-build; \
	fi
	$(SUDO) cp $(rbenv_init_file)  ~$(USERNAME)/.deployrc
	if [ "$$SHELL" = '/bin/bash' ]; then \
		$(SUDO) echo 'source ~/.deployrc' >> ~$(USERNAME)/.bashrc; \
	else  									\
		$(SUDO) echo 'source ~/.deployrc' >> ~$(USERNAME)/.zshrc; \
	fi
endef

endif #__install_rbenv_included := $(true)
