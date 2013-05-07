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
    uut.set_arg(s_exp);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(get_from_empty_stack_returns_set_arg)


  `SVTEST(get_with_1_element_in_stack_and_no_set_arg)
    string s_exp = "element0";
    uut.set(s_exp);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(get_with_1_element_in_stack_and_no_set_arg)


  `SVTEST(get_with_1_element_in_stack_and_set_arg)
    string s_exp = "element0.set_arg";
    uut.set("element0");
    uut.set_arg("set_arg");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(get_with_1_element_in_stack_and_set_arg)


  `SVTEST(down_appends_to_stack)
    string s_exp = "element0";
    uut.down("element0");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(down_appends_to_stack)


  `SVTEST(multiple_elements_on_stack_are_concatenated)
    string s_exp = "element0.element1.element2";
    uut.down("element0");
    uut.down("element1");
    uut.down("element2");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(multiple_elements_on_stack_are_concatenated)


  `SVTEST(down_elements_are_concatenated_to_elements)
    string s_exp = "element0[1].element1[0].element2[55]";
    uut.down("element0");
    uut.down_element(1);
    uut.down("element1");
    uut.down_element(0);
    uut.down("element2");
    uut.down_element(55);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(down_elements_are_concatenated_to_elements)


  `SVTEST(WARNING_set_can_start_with_a_bracket)
    string s_exp = "[element0";
    uut.down("[element0");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(WARNING_set_can_start_with_a_bracket)


  `SVTEST(WARNING_down_can_start_with_any_bracket)
    string s_exp = "[element0[55](element1[33]{element2[44]";
    uut.down("[element0");
    uut.down_element(55);
    uut.down("(element1");
    uut.down_element(33);
    uut.down("{element2");
    uut.down_element(44);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(WARNING_down_can_start_with_any_bracket)


  `SVTEST(WARNING_elements_can_be_empty_strings)
    string s_exp = "..";
    uut.down("");
    uut.down("");
    uut.down("");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(WARNING_elements_can_be_empty_strings)


  `SVTEST(set_initialized_the_stack)
    string s_exp = "element1";
    uut.set("element0");
    uut.set("element1");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(set_initialized_the_stack)


  `SVTEST(up_element_removes_a_down_element)
    string s_exp = "element0";
    uut.down("element0");
    uut.down_element(8);
    uut.up_element();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(up_element_removes_a_down_element)


  `SVTEST(up_element_doesnt_remove_a_down)
    string s_exp = "element0";
    uut.down("element0");
    uut.up_element();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(up_element_doesnt_remove_a_down)


  `SVTEST(WARNING_up_element_removes_a_down_that_starts_with_a_bracket)
    string s_exp = "";
    uut.down("[element0");
    uut.up_element();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(WARNING_up_element_removes_a_down_that_starts_with_a_bracket)


  `SVTEST(up_element_has_no_effect_on_empty_stack)
    string s_exp = "element0";
    uut.up_element();
    uut.down("element0");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(up_element_has_no_effect_on_empty_stack)


  `SVTEST(up_removes_a_down)
    string s_exp = "element0";
    uut.down("element0");
    uut.down("element1");
    uut.up();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(up_removes_a_down)


  `SVTEST(WARNING_up_removes_a_down_and_down_element)
    string s_exp = "";
    uut.down("element1");
    uut.down_element("20");
    uut.up();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(WARNING_up_removes_a_down_and_down_element)


  `SVTEST(up_removes_empty_strings)
    string s_exp = "element0.element1";
    uut.down("element0");
    uut.down("element1");
    uut.down("");
    uut.up();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(up_removes_empty_strings)


  `SVTEST(WARNING_up_treats_elements_starting_with_any_bracket_as_down_elements)
    string s_exp = "";
    uut.down("element0");
    uut.down("[element1");
    uut.down("(element2");
    uut.down("{element3");
    uut.down_element("20");
    uut.up();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(WARNING_up_treats_elements_starting_with_any_bracket_as_down_elements)


  `SVTEST(WARNING_up_removes_multiple_down_elements)
    string s_exp = "";
    uut.down_element("20");
    uut.down_element("30");
    uut.down_element("40");
    uut.down_element("50");
    uut.down_element("60");
    uut.down_element("70");
    uut.up();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(WARNING_up_removes_multiple_down_elements)


  `SVTEST(WARNING_a_separator_other_than_period_makes_no_sense)
    string s_exp = "";
    uut.down("/element0");
    uut.down("element1");
    uut.up("/");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END(WARNING_a_separator_other_than_period_makes_no_sense)


  `SVUNIT_TESTS_END

endmodule
