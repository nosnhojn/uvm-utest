$SVUNIT_INSTALL/svunit_base/uvm-mock/svunit_uvm_mock_pkg.sv
+incdir+$SVUNIT_INSTALL/svunit_base/uvm-mock
+incdir+../../test_doubles
#+incdir+$UVM_HOME/src
#+define+UVM_NO_DPI
+define+UVM_NO_RELNOTES
+define+RUN_SVUNIT_WITH_UVM
+define+RUN_SVUNIT_WITH_UVM_REPORT_MOCK
+define+UVM_ENABLE_FIELD_CHECKS
#$UVM_HOME/src/uvm.sv

# --------------------------------------
# INSISIVE USERS UNCOMMENT THE FOLLOWING
# --------------------------------------
#-uvm

# ---------------------------------
# VCS USERS UNCOMMENT THE FOLLOWING
# ---------------------------------
# -ntb_opts uvm
