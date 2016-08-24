
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
# The sub makefile template works on remote server
# Structure stick to capistrano's 
#
# 1. Place the code into position
# 2. Link up all necessary local configuration files
# 3. Remove the obsoleted dirs

define __tpl_create_symlink
$$(deploy_path)/$$F: $$(dir_s)/$$F 
	ln -s  $$$$< $$$$@

$$(dir_s)/$$F:
	if [ "$$(basename $$F)"=="$$F" ]; then\
		mkdir -p $$$$@; \
	else \
		mkdir -p $$$$(dir $$$$@); touch $$$$@; \
	fi

endef



define capistrano

release_file = $1
installdir = $2
symlink_objs = $3
restart_func = $4

ifeq ($(strip $(restart_func)),)
	restart_func := echo 'done'
endif 

dir_r := $$(installdir)/releases
dir_s := $$(installdir)/shared
NUM_PRESERVE_RLS := 10

$$(shell if [ ! -d $$(dir_s) ];then mkdir -p $$(dir_s); fi)
$$(shell if [ ! -d $$(dir_r) ];then mkdir -p $$(dir_r); fi)
new_dirname := $$(shell expr $$$$(ls -1 $$(dir_r) | sed -n '/[0-9]\+/p' | sort  -n |tail -1) + 1)
latest_obsoleted_dirname := $$(if $$(call int_gt,$$(new_dirname),$$(NUM_PRESERVE_RLS)),\
		$$(shell ls -1 $$(dir_r) | sed -n '/[0-9]\+/p' | sort  -n |tail -$$(NUM_PRESERVE_RLS) |head -1))

deploy_path = $$(dir_r)/$$(new_dirname)

# Create symlink rules
$$(foreach F, $$(symlink_objs), $$(eval $$(__tpl_create_symlink)))

__u = $(call alloc,capistrano)
deploy_phases := __codefile$$(__u) __init$$(__u) __restart$$(__u)

abs_symlinks = $$(addprefix $$(deploy_path)/,$$(symlink_objs)) 
$$(abs_symlinks): __codefile$$(__u)

deploy: $$(deploy_phases) | __cleanup$$(__u)

__codefile$$(__u): $$(deploy_path) $$(release_file)
	tar xzf $$(release_file) -C $$<

$$(deploy_path): $$(dir_r)
	mkdir $$@

__init$$(__u): $$(abs_symlinks) 
	composer install -d $$(deploy_path) --no-dev -o
	ln -snf $$(deploy_path) $$(dir_r)/current

__restart$$(__u): __init$$(__u)
	$$(call restart_func)

$$(dir_r):
	mkdir -p $$@

__cleanup$$(__u):
	if [ -n "$$(latest_obsoleted_dirname)" ]; then \
		cd $$(dir_r) && for i in $$$$(seq $$(latest_obsoleted_dirname) -1 1); do if [ -d $$$$i ]; then rm -rf $$$$i; else break; fi; done \
	fi

.PHONY: $$(deploy_phases) __cleanup$$(__u)

endef


$(call def_exclude,__tpl_%)
$(call def_exclude,capistrano)
$#


endif 
