ifeq ($(SIMULATOR),IUS)
	include $(SVUNIT_INSTALL)/bin/ius.mk
	SIM_ARGS += '-uvm'
  #SIM_ARGS += '-uvmhome $(UVM_HOME) -64'
else
	ifeq ($(SIMULATOR),VCS)
		include $(SVUNIT_INSTALL)/bin/vcs.mk
		SIM_ARGS += '-ntb_opts uvm'
	else
		include $(SVUNIT_INSTALL)/bin/questa.mk
	endif
endif

CLEANFILES += .uvm_object.print

