ifeq ($(SIMULATOR),IUS)
	include $(SVUNIT_INSTALL)/bin/ius.mk
else
	ifeq ($(SIMULATOR),VCS)
		include $(SVUNIT_INSTALL)/bin/vcs.mk
	else
		include $(SVUNIT_INSTALL)/bin/questa.mk
		SIM_EXE=qverilog
	endif
endif

