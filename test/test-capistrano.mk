include maklib/utils/capistrano.mk

shared_objs := config/autoload/local.php vendor

/tmp/Makefile:
	$(file > /tmp/Makefile,$(call capistrano,engine.tgz,~/test,$(shared_objs)))

include maklib/utils/deploy-remote.mk
include $(call look_for_hosts_def)

SOURCES := /tmp/Makefile engine.tgz 

$(eval $(call run_remote_target,$(SOURCES),deploy))

deploy:
	@echo 'deploy'
