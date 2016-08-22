export ENVIRONMENT := staging

include maklib/libs/core/define.mk
include maklib/libs/gmsl
include utils/deploy-remote.mk

include $(call look_for_hosts_def,test/hosts/staging)

SOURCES := /tmp/Makefile
$(SOURCES): 
	echo "all: ; echo 'Hello World'" > $@

$(eval $(call run_remote_target,$(SOURCES),all))

all::
	echo $(__target_make_source_file)
	echo $(DEPLOYMENT_SOURCES)

