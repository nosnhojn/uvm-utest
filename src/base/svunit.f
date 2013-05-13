# ------------------------------------
# QUESTA USERS UNCOMMENT THE FOLLOWING
# ------------------------------------
$SVUNIT_INSTALL/svunit_base/uvm-mock/svunit_uvm_mock_pkg.sv
+incdir+$SVUNIT_INSTALL/svunit_base/uvm-mock
+incdir+../../test_doubles
+define+UVM_NO_RELNOTES
+define+RUN_SVUNIT_WITH_UVM
+define+RUN_SVUNIT_WITH_UVM_REPORT_MOCK

# --------------------------------------
# INSISIVE USERS UNCOMMENT THE FOLLOWING
# --------------------------------------
# $SVUNIT_INSTALL/svunit_base/uvm-mock/svunit_uvm_mock_pkg.sv
# +incdir+$SVUNIT_INSTALL/svunit_base/uvm-mock
# +define+RUN_SVUNIT_WITH_UVM
# +define+UVM_NO_RELNOTES
# -uvm
# -coverage a

# ---------------------------------
# VCS USERS UNCOMMENT THE FOLLOWING
# ---------------------------------
# -ntb_opts uvm
# +incdir+$SVUNIT_INSTALL/svunit_base/uvm-mock
# $SVUNIT_INSTALL/svunit_base/uvm-mock/svunit_uvm_mock_pkg.sv
# +define+UVM_NO_RELNOTES
# +define+RUN_SVUNIT_WITH_UVM
