include maklib/utils/check
include maklib/libs/gmsl
include maklib/inventory/install/php.mk
include maklib/inventory/install/php-libev.mk
include maklib/inventory/install/make.mk


#$(info 'incom'=$(call incompatible,$(get_php-libev_version),2))
#$(info $(origin install_php-libev))
#target += $(call require,php-libev,2)
target += $(call require,make,4.4)
$(info target=$(target))

all: $(target)
	echo 'done'
