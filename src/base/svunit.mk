ifeq ($(SIMULATOR),IUS)
	include $(SVUNIT_INSTALL)/bin/ius.mk
	SIM_ARGS += '-svseed $(shell echo $$RANDOM) -uvm'
  #SIM_ARGS += '-svseed $(shell echo $$RANDOM) -uvmhome $(UVM_HOME) -64'
else
	ifeq ($(SIMULATOR),VCS)
		include $(SVUNIT_INSTALL)/bin/vcs.mk
		SIM_ARGS += '-svseed $(shell echo $$RANDOM) -ntb_opts uvm'
	else
		include $(SVUNIT_INSTALL)/bin/questa.mk
		SIM_ARGS += -R -sv_seed $(shell echo $$RANDOM)
	endif
endif

CLEANFILES += .uvm_object.print

