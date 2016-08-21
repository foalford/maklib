ifndef __install_rbenv_included
__install_rbenv_included := $(true)

define get_rbenv_version
	$(shell rbenv version | sed -ne 's/^\([0-9\.]\+\).*/\1/p')
endef

rbenv_init_file := inventory/install/rbenv/rbenv-init.sh

define install_rbenv
	git clone --depth=1 https://github.com/rbenv/rbenv.git ~/.rbenv
	echo 'export PATH="$$HOME/.rbenv/bin:$$PATH"' >> ~/.bashrc
	echo 'export PATH="$$HOME/.rbenv/bin:$$PATH"' >> ~/.zshenv
	git clone --depth=1 https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
	cp $(rbenv_init_file)  ~/.deployrc
	if [ $$SHELL -eq '/bin/bash' ]; then cat 'source ~/.deployrc' >> ~/.bashrc; else cat 'source ~/.deployrc' >> ~/.zshrc; fi
endef

endif #__install_rbenv_included := $(true)
