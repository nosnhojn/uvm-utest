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


  `SVTEST(_4635_returns_wildcard)
    string malformed_array_select = "bozo[>]";
    `FAIL_UNLESS(boat_anchor._4635(malformed_array_select));
  `SVTEST_END


  `SVTEST(_4636_returns_illegal_character)
    string s_in = "double_trouble[:]";
    `FAIL_UNLESS_STR_EQUAL(boat_anchor._4636(s_in), ":");
  `SVTEST_END


  `SVTEST(_4609_cant_handle_DOT_DOT_DOT)
    `FAIL_IF_STR_EQUAL(boat_anchor._4609("..."), "...");
  `SVTEST_END


  `SVTEST(_4637_returns_wildcard)
    string malformed_array = "[]";
    `FAIL_UNLESS(boat_anchor._4637(malformed_array) === 1);
  `SVTEST_END


  `SVTEST(_4638_returns_true_bad_array)
    string s_in = "]";
    `FAIL_UNLESS(boat_anchor._4638(s_in) === 1);
  `SVTEST_END


  `SVTEST(_4640_plus_is_wildcard)
    string s_in = "+";
    `FAIL_UNLESS(boat_anchor._4640(s_in) === 1);
  `SVTEST_END


  `SVTEST(_4602_scope_separator_incompatible)
    string name_in = "my_name";
    string name_out = "scope.my_name";

    `FAIL_UNLESS(boat_anchor._4602(name_in) == name_out);
  `SVTEST_END


  `SVTEST(weigh_anchor_failed)
    boat_anchor.set_fake_failure();
    `FAIL_UNLESS(boat_anchor.weigh_anchor() == 0);
  `SVTEST_END


  `SVTEST(weigh_anchor)
    `FAIL_UNLESS(boat_anchor.weigh_anchor() == 1);
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule
