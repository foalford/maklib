
ifndef __install_python_included
__install_python_included := $(true)

define get_python_version
$(shell python -V 2>&1| sed -ne "s/^Python \([0-9\.]\+\).*/\1/p")
endef

python_version ?= 2.7

define install_python
apt-get install -y python$(python_version) python-pip
endef


endif #__install_python_included := $(true)
