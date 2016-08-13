
ifndef __install_supervisor_included
__install_supervisor_included := $(true)

define get_supervisor_version
$(shell supervisord -v | sed -ne "s/[a-z]//p")
endef

define install_supervisor
apt-get install -y supervisor
endef


endif #__install_supervisor_included := $(true)
