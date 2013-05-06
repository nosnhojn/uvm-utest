`include "svunit_defines.svh"

import uvm_pkg::*;
import svunit_pkg::*;


module uvm_scope_stack_unit_test;

  string name = "uvm_scope_stack_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  uvm_scope_stack uut;


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

    uut = new();
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */
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

  `SVTEST(scope_arg_null_at_construction)
    string _NULL_STRING = "";

    `FAIL_IF(uut.get_arg() != _NULL_STRING);
  `SVTEST_END(scope_arg_null_at_construction)

  `SVTEST(stack_empty_at_construction)
    `FAIL_IF(uut.depth() != 0);
  `SVTEST_END(stack_empty_at_construction)

  `SVUNIT_TESTS_END

endmodule
