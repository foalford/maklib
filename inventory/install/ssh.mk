ifndef __install_ssh_included
__install_ssh_included := $(true)

define get_ssh_version
	$(shell ssh -V 2>&1 | sed -ne 's/^OpenSSH_\([0-9\.]\+\).*/\1/p')
endef

define install_ssh
	apt-get install -y openssh-server
endef

endif #__install_ssh_included := $(true)
