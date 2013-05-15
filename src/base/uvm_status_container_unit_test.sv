`include "svunit_defines.svh"
`include "test_defines.sv"

import uvm_pkg::*;
import svunit_pkg::*;


module uvm_status_container_unit_test;

  string name = "uvm_status_container_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  uvm_status_container uut;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();

    if (uut != null) begin
      uut.field_array.delete();
      uut.print_matches = 0;
    end
    uut = new();
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END(_NAME_)
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END(mytest)
  //===================================
  `SVUNIT_TESTS_BEGIN

  //-----------------------------
  //-----------------------------
  // constructor tests
  //-----------------------------
  //-----------------------------

  `SVTEST(defaults_at_construction)
    `FAIL_IF(uut.clone !== 1);
    `FAIL_IF(uut.warning !== 0);
    `FAIL_IF(uut.status !== 0);
    `FAIL_IF(uut.bitstream !== 'hx);
    `FAIL_IF(uut.intv !== 0);
    `FAIL_IF(uut.element !== 0);
    `FAIL_IF(uut.stringv != _NULL_STRING);
    `FAIL_IF(uut.scratch1 != _NULL_STRING);
    `FAIL_IF(uut.scratch2 != _NULL_STRING);
    `FAIL_IF(uut.key != _NULL_STRING);
    `FAIL_IF(uut.object != null);
    `FAIL_IF(uut.array_warning_done !== 0);
    `FAIL_IF(uut.scope.depth() !== 0);
    `FAIL_IF(uut.cycle_check.num() !== 0);
    `FAIL_IF(uut.comparer != null);
    `FAIL_IF(uut.packer != null);
    `FAIL_IF(uut.recorder != null);
    `FAIL_IF(uut.printer != null);
    `FAIL_IF(uut.m_uvm_cycle_scopes.size() != 0);
    `FAIL_IF(uut.field_array.num() != 0);
    `FAIL_IF(uut.print_matches !== 0);
  `SVTEST_END(defaults_at_construction)

  
  `SVTEST(statics_are_static)
    uvm_status_container other = new();
    uut.field_array["junk"] = 1;
    uut.print_matches = 1;

    `FAIL_IF(other.field_array.num() != 1);
    `FAIL_IF(other.print_matches != 1);
  `SVTEST_END(statics_are_static)

  `SVUNIT_TESTS_END

endmodule
