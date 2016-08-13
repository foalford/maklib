# vim: set filetype=make:

ifndef __install_node_included
__install_node_included := $(true)

define get_node_version
$(shell nodejs -v | sed -ne "s/^v//p")
endef


define install_node
apt-get install -y nodejs npm
ln -s /usr/bin/nodejs /usr/bin/node
endef

endif #__install_node_included := $(true)
