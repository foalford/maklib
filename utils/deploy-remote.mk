# vim: set filetype=make:
#
# Run the makefile task in remote machine
#
# DEPLOYMENT_SOURCES := All source files
#

ifndef __install_deploy-agent_included
__install_deploy-agent_included := 1

include maklib/libs/core/alloc.mk

ENVIRONMENT ?= staging
ifndef ENVIRONMENT
$(error Need to have ENVIRONMENT variable defined.)
endif

# Searching for the config for remote host
#
# The searching paths are:
#    $(ENVIRONMENT)/hosts
#    hosts/$(ENVIRONMENT)
# Usage
#    $(call look_for_hosts_def,staging)
#
look_for_hosts_def = $(firstword $(wildcard $(and $1,$1) $(ENVIRONMENT)/hosts hosts/$(ENVIRONMENT)))


# Create dependencies for running a package remotely
#
# Params:
#   1. variable referring to files need to be included for remote run
#      The first file will be the Makefile
#   2. target for run
# Return:
#   A separator (if any), or empty.
define __tpl_run_remote_target
SSH_OPTIONS ?=

__unique_id := $(call alloc,__tpl_run_remote_target)
__target_make_source_file := __deploy_source-$$(__unique_id)

$$(__target_make_source_file) = $(shell mktemp -u).tgz

__target_deploy_remote := __deploy_remote-$$(__unique_id)

ifdef DEBUG
$$(info $$(REMOTE_USER)@$$(REMOTE_HOST):$$(REMOTE_PORT))
endif

$$(__target_deploy_remote): SSH_LOGIN_OPTIONS = -p $$(REMOTE_PORT) $$(SSH_OPTIONS) $$(REMOTE_USER)@$$(REMOTE_HOST) 
$$(__target_deploy_remote): SCP_LOGIN_OPTIONS = -P $$(REMOTE_PORT) $$(SSH_OPTIONS) 

$$($$(__target_make_source_file)): DEST = $$(basename $$($$(__target_make_source_file)))

$$($$(__target_make_source_file)): $1
	@if [ -n $$DEBUG ]; then echo "$1";fi
	mkdir -p $$(DEST) && cp $$< $$(DEST)/Makefile 
	if [ $$(words $$^) -gt 1 ];then cp -R $$(filter-out $$(firstword $$^),$$^) $$(DEST);fi  
	tar czf $$@ -C $$(DEST) .  &&  cd .. && rm -r $$(DEST)

$$(__target_deploy_remote): $$($$(__target_make_source_file))
	scp $$(SCP_LOGIN_OPTIONS) $$? $$(REMOTE_USER)@$$(REMOTE_HOST):$$?
	ssh $$(SSH_LOGIN_OPTIONS) "workdir=\$$$$(mktemp -d); tar xzf $$? -C \$$$$workdir && make -C \$$$$workdir $2 && \
		if [ -z $$(DEBUG) ]; then rm -r \$$$$workdir; fi"

install_remote-$(__unique_id) := $$(__target_deploy_remote)

.PHONY: $$(__target_deploy_remote) 
endef

$(call def_exclude,__tpl_run_remote_target)

ifdef DEBUG
$(info $(call __tpl_run_remote_target,$1,$2))
endif

install_remote = $(eval $(call __tpl_run_remote_target,$1,$2))$(__target_deploy_remote)

$#

endif #__install_deploy-agent_included 
