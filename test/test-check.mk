include maklib/utils/check
include maklib/libs/gmsl
include maklib/inventory/install/php.mk
include maklib/inventory/install/php-libev.mk


#$(info 'incom'=$(call incompatible,$(get_php-libev_version),2))
#$(info $(origin install_php-libev))
target += $(call require,php-libev,2)
$(info target=$(target))

all: $(target)
	echo 'done'
