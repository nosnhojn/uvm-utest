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

  string _NULL_STRING = "";


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
    `FAIL_IF(uut.get_arg() != _NULL_STRING);
  `SVTEST_END(scope_arg_null_at_construction)


  `SVTEST(stack_empty_at_construction)
    `FAIL_IF(uut.depth() != 0);
  `SVTEST_END(stack_empty_at_construction)


  `SVTEST(set_arg)
    string s_exp = "jokes";
    uut.set_arg(s_exp);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(set_arg)


  `SVTEST(cannot_set_arg_to_null)
    string s_exp = "jokes";
    uut.set_arg(s_exp);
    uut.set_arg(_NULL_STRING);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(cannot_set_arg_to_null)


  `SVTEST(unset_if_arg_matches)
    string s_exp = "jokes";
    uut.set_arg(s_exp);
    uut.unset_arg(s_exp);
    `FAIL_IF(uut.get() != _NULL_STRING);
  `SVTEST_END(unset_if_arg_matches)


  `SVTEST(dont_unset_if_arg_doesnt_match)
    string s_exp = "jokes";
    uut.set_arg(s_exp);
    uut.unset_arg("hazard");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(dont_unset_if_arg_doesnt_match)


  `SVTEST(set_arg_element)
    string s_exp = "jokes[50]";
    uut.set_arg_element("jokes", 50);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(set_arg_element)


  `SVTEST(WARNING_can_set_arg_element_without_arg)
    string s_exp = "[50]";
    uut.set_arg_element("", 50);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(WARNING_can_set_arg_element_without_arg)


  `SVTEST(get_from_empty_stack_and_no_arg_returns_null)
    `FAIL_IF(uut.get() != _NULL_STRING);
  `SVTEST_END(get_from_empty_stack_and_no_arg_returns_null)


  `SVTEST(get_from_empty_stack_returns_set_arg)
    string s_exp = "set_arg";
    uut.set(s_exp);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(get_from_empty_stack_returns_set_arg)


  `SVTEST(get_with_1_element_in_stack)
    string s_exp = "element0";
    uut.set(s_exp);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(get_with_1_element_in_stack)


  `SVTEST(get_with_1_element_in_stack_and_set_arg)
    string s_exp = "element0.set_arg";
    uut.set("element0");
    uut.set_arg("set_arg");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(get_with_1_element_in_stack_and_set_arg)

  `SVUNIT_TESTS_END

endmodule
