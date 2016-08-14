ifndef __install_xidel_included
__install_xidel_included := $(true)

define get_xidel_version
$(shell xidel --version | sed -ne "s/^Xidel //p")
endef

define install_xidel
wget "http://downloads.sourceforge.net/project/videlibri/Xidel/Xidel%200.9.4/xidel_0.9.4-1_amd64.deb?r=http%3A%2F%2Fwww.videlibri.de%2Fxidel.html&ts=1471090340&use_mirror=internode" -O /tmp/xidel.amd64.deb
dpkg -i /tmp/xidel.amd64.deb
endef


endif #__install_xidel_included := $(true)
