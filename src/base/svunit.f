# ------------------------------------
# QUESTA USERS UNCOMMENT THE FOLLOWING
# ------------------------------------
$SVUNIT_INSTALL/svunit_base/uvm-mock/svunit_uvm_mock_pkg.sv
+incdir+$SVUNIT_INSTALL/svunit_base/uvm-mock
+incdir+../../test_doubles
#+define+RUN_SVUNIT_WITH_UVM

# --------------------------------------
# INSISIVE USERS UNCOMMENT THE FOLLOWING
# --------------------------------------
# $SVUNIT_INSTALL/svunit_base/uvm-mock/svunit_uvm_mock_pkg.sv
# +incdir+$SVUNIT_INSTALL/svunit_base/uvm-mock
# +define+RUN_SVUNIT_WITH_UVM
# -uvm
# -coverage a

# ---------------------------------
# VCS USERS UNCOMMENT THE FOLLOWING
# ---------------------------------
# -ntb_opts uvm
# +incdir+$SVUNIT_INSTALL/svunit_base/uvm-mock
# $SVUNIT_INSTALL/svunit_base/uvm-mock/svunit_uvm_mock_pkg.sv
# +define+RUN_SVUNIT_WITH_UVM
