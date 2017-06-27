
ifndef __capistrano_included
__capistrano_included := 1

include maklib/libs/core/alloc.mk
include maklib/libs/gmsl
#
# Same deployment as capistrano
#
# Variable
#
# symlink_objs  Symlink should be relative to deploy path
# project_name
# installdir
# 
# $(call capistrano name,installdir,symlink_objs,callback)
#

# Generating a makefile that will be run remotely
# This makefile will deploy the package file in 
# capistrano way
# 
# For example
# __remote_makefile := $(shell mktemp -ud)
# 
# # Create a remote makefile for installation
# $(__remote_makefile):
# 	$(file >$@,$(call capistrano,$(PACKAGE_FILE),$(installdir),$(shared_objs)))

define capistrano

release_file = $(notdir $1)
installdir = $2
symlink_objs = $3
restart_func = $4
preservation_count := 10

ifeq ($$(strip $$(restart_func)),)
	restart_func := echo 'done'
endif 

dir_s := $$(installdir)/shared

ifndef NEW_DEPLOYMENT_DIR

dir_r := $$(installdir)/releases
deploy: $$(dir_s) $$(dir_r)
	@echo 'Initialize the dirs'
	export newid=$$$$(expr $$$$(ls -1 $$(dir_r) | sed -n '/[0-9]\+/p' | sort  -n |tail -1) + 1) ; \
		echo "New release $$$$newid"; $(MAKE) -e NEW_DEPLOYMENT_DIR=$$$$newid deploy cleanup
else

dir_r := $$(installdir)/releases/$$(NEW_DEPLOYMENT_DIR)

deploy : update-code initialize activate 

update-code: $$(dir_r) $$(release_file)
	tar xzf $$(release_file) -C $$<

initialize : update-code $$(addprefix $$(dir_r)/,$$(symlink_objs)) 
	if [ -f $$(dir_r)/composer.lock ]; then \
		composer install -d $$(dir_r) --no-dev -o;\
	elif [ -f $$(dir_r)/Gemfile.lock ]; then  \
		cd $$(dir_r) && bundle install --with=production --without=development test --path=vendor/bundle; \
	elif [ -f $$(dir_r)/package.json ]; then \
		cd $$(dir_r) && npm install ;\
	else  \
		echo 'Cannot find a project definition file.' \
	fi

activate : initialize 
	cd $$(dir_r) && $$(call restart_func,$$(dir_r))
	cd $$(dir_r) && ln -snf $$(dir_r) ../current 

cleanup: deploy
	if [ $$(NEW_DEPLOYMENT_DIR) -gt $$(preservation_count) ]; then \
		cd $$(dir_r)/.. && \
		for i in $$$$(seq $$$$(ls -1 . | \
				sed -n '/[0-9]\+/p' | sort  -n | \
				tail -$$(preservation_count) |head -1) -1 1); do \
			if [ -d $$$$i ];then rm -rf $$$$i; else break; fi \
		done \
	fi

$$(dir_r)/%: $$(dir_s)/%
	ln -s $$< $$@

$$(dir_s)/%:
	mkdir -p $$(@D)
	v=$$@; if [ $$@ = "$$$${v%%.*}" ]; then mkdir -p $$@; else touch $$@; fi

.SECONDARY: $$(subst $$(dir_r),$$(dir_s),$$(symlink_objs))
.PHONY: initialize activate cleanup


endif


initdirs = $$(dir_r) $$(dir_s)

$$(initdirs):
	mkdir -p $$@

endef

# End capistrano
$(call def_exclude,capistrano)

$#
endif 
