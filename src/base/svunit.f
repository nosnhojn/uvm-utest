# for questa user defined library
$UVM_HOME/src/uvm.sv
+incdir+$UVM_HOME/src
-R -sv_lib $UVM_HOME/lib/uvm_dpi64 -

+incdir+$SVUNIT_INSTALL/svunit_base/uvm-mock
+incdir+../../test_doubles
+define+UVM_NO_RELNOTES
+define+RUN_SVUNIT_WITH_UVM
+define+RUN_SVUNIT_WITH_UVM_REPORT_MOCK
+define+UVM_ENABLE_FIELD_CHECKS
$SVUNIT_INSTALL/svunit_base/uvm-mock/svunit_uvm_mock_pkg.sv
