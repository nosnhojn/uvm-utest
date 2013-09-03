`include "svunit_defines.svh"
`include "uvm_boat_anchor.sv"

import svunit_pkg::*;


module uvm_boat_anchor_unit_test;

  string name = "uvm_boat_anchor_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  uvm_boat_anchor boat_anchor;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    boat_anchor = new(/* New arguments if needed */);
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
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN

  `SVTEST(_4601_returns_positive_number)
    `FAIL_UNLESS_STR_EQUAL(boat_anchor._4601('hf, 4), "15");
  `SVTEST_END


  `SVTEST(_4634_returns_illegal_radix)
    string array_with_index = "array['h77]";
    `FAIL_UNLESS(boat_anchor._4634(array_with_index) == -1);
  `SVTEST_END


  `SVTEST(_4635_returns_wildcar)
    string malformed_array_select = "bozo[>]";
    `FAIL_UNLESS(boat_anchor._4635(malformed_array_select));
  `SVTEST_END

  `SVTEST(weigh_anchor)
    `FAIL_UNLESS(boat_anchor.weight_anchor() == 1);
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule
