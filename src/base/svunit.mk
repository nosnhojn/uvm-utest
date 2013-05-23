# --------------------------------
# QUESTA USERS UNCOMMENT questa.mk
# --------------------------------
include $(SVUNIT_INSTALL)/bin/questa.mk

# -------------------------------
# INSISIVE USERS UNCOMMENT ius.mk
# -------------------------------
#include $(SVUNIT_INSTALL)/bin/ius.mk

# --------------------------
# VCS USERS UNCOMMENT vcs.mk
# --------------------------
# include $(SVUNIT_INSTALL)/bin/vcs.mk
#
CLEANFILES += .uvm_object.print
