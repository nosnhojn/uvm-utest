`include "svunit_defines.svh"

import uvm_pkg::*;
import svunit_pkg::*;

class test_uvm_object extends uvm_object;
endclass

module uvm_object_unit_test;

  string name = "uvm_object_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  test_uvm_object my_uvm_object;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    my_uvm_object = new(/* New arguments if needed */);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */
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



  `SVUNIT_TESTS_END

endmodule
