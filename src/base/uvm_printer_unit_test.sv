`include "svunit_defines.svh"
`include "test_uvm_printer.sv"
`include "test_uvm_object.sv"
`include "test_uvm_component.sv"
`include "test_uvm_agent.sv"
`include "test_defines.sv"

`define and_i_call_print_string_with when_i_call_print_string_with
`define and_i_call_print_int_with when_i_call_print_int_with
`define and_i_call_print_real_with when_i_call_print_real_with
`define and_i_call_print_generic_with when_i_call_print_generic_with
`define and_i_call_print_object_header_with when_i_call_print_object_header_with
`define and_i_call_print_array_header_with when_i_call_print_array_header_with
`define and_the_m_array_stack_size_is then_the_m_array_stack_size_is

`define OUTPUT_IS_NULL_STRING_FOR_FORMAT(NAME) \
`SVTEST(format_``NAME``_returns_null_string) \
  given_i_have_a_new_uvm_printer_in_its_default_state(); \
  when_i_call_format_``NAME; \
  then_the_formatted_output_is(_NULL_STRING); \
`SVTEST_END()

`define PRINT_ARRAY_RANGE_CALLS_PRINT_GENERIC_FOR(NAME,MIN,MAX) \
`SVTEST(print_array_range_calls_print_generic_for_``NAME) \
  given_i_have_a_new_uvm_printer_in_its_default_state(); \
  when_i_call_print_array_range_with(.min(MIN), .max(MAX)); \
  then_print_generic_is_called_with("...", "...", -2, "...", "."); \
`SVTEST_END()

`define PRINT_ARRAY_RANGE_DOES_NOTHING_FOR(NAME,MIN,MAX) \
`SVTEST(print_array_range_does_nothing_for_``NAME) \
  given_i_have_a_new_uvm_printer_in_its_default_state(); \
  when_i_call_print_array_range_with(.min(MIN), .max(MAX)); \
  then_no_row_is_added; \
`SVTEST_END()


import svunit_pkg::*;
import svunit_uvm_mock_pkg::*;

module uvm_printer_unit_test;

  string name = "uvm_printer_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  test_uvm_printer uut;
  uvm_printer_row_info first_row;
  uvm_printer_row_info last_row;
  test_uvm_object test_obj;
  test_uvm_component test_comp;

  string adjusted_name;
  string string_index;
  string emitted_string;
  string formatted_output;


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
    test_obj = new("obj_name");
    test_comp = new("comp_name");

    uvm_report_mock::setup();
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    adjusted_name = "";
    string_index = "";
  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END()
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END()
  //===================================
  `SVUNIT_TESTS_BEGIN


  //-----------------------------
  //-----------------------------
  // constructor tests
  //-----------------------------
  //-----------------------------

  `SVTEST(printer_knobs_at_construction)
    `FAIL_IF(uut.knobs == null);
    `FAIL_IF(uut.m_scope.depth() > 0);
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_int tests
  //-----------------------------
  //-----------------------------

  // FAILING TEST - REPORTED IN MANTIS 4602
// `SVTEST(print_int_can_return_the_row_name_as_empty_string)
//   given_i_have_a_new_uvm_printer_in_its_default_state();
//
//   when_i_call_print_int_with(_NULL_STRING);
//
//   then_the_row_name_is_assigned_to(_NULL_STRING);
// `SVTEST_END()


  `SVTEST(print_int_can_return_the_row_name_as_full_scope)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_turn_the_full_name_knob_to(1);
      and_i_push_this_level_to_the_scope_stack("branch");

    when_i_call_print_int_with(.name("leaf"));

    then_the_row_name_is_assigned_to("branch.leaf");
  `SVTEST_END()


  `SVTEST(print_int_can_return_the_row_name_as_leaf_scope)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch");

    when_i_call_print_int_with(.name("leaf"));

    then_the_row_name_is_assigned_to("leaf");
  `SVTEST_END()


  `SVTEST(print_int_returns_row_level_as_scope_depth)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");

    when_i_call_print_int_with();

    then_the_row_level_is_assigned_to(2);
  `SVTEST_END()


  `SVTEST(print_int_returns_row_type_name_if_specified)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_int_with(.type_name("my_type_name"));

    then_the_row_type_name_is_assigned_to("my_type_name");
  `SVTEST_END()


  `SVTEST(print_int_can_return_the_row_type_name_as_time)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_int_with(.radix(UVM_TIME));

    then_the_row_type_name_is_assigned_to("time");
  `SVTEST_END()


  `SVTEST(print_int_can_return_the_row_type_name_as_string)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_int_with(.radix(UVM_STRING));

    then_the_row_type_name_is_assigned_to("string");
  `SVTEST_END()


  `SVTEST(print_int_returns_row_type_name_as_integral_by_default)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_int_with();

    then_the_row_type_name_is_assigned_to("integral");
  `SVTEST_END()


  `SVTEST(print_int_returns_row_numeric_size_as_string)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_int_with(.size(-1));

    then_the_row_size_is_assigned_to("-1");
  `SVTEST_END()


  // borrowed these values from the uvm_misc::uvm_vector_to_string test
  `SVTEST(print_int_returns_val_as_uvm_vector_to_string)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_turn_the_bin_radix_knob_to("B");

    when_i_call_print_int_with(.value(121), .size(5), .radix(UVM_BIN));

    then_the_row_val_is_assigned_to("B11001");
  `SVTEST_END()


  // borrowed these values from the uvm_misc::uvm_vector_to_string test
  `SVTEST(print_int_uses_default_radix_when_noradix_specified)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_turn_the_default_radix_knob_to(UVM_OCT);

    when_i_call_print_int_with(.value(1567), .size(10));

    then_the_row_val_is_assigned_to("'o1037");
  `SVTEST_END()


  `SVTEST(print_int_pushes_back_new_rows)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_int_with(some_name());
    `and_i_call_print_int_with(some_other_name());

    then_the_row_name_is_assigned_to(some_other_name());
     and_the_old_row_name_is_assigned_to(some_name());
  `SVTEST_END()


  //-----------------------------
  //-----------------------------
  // print_field tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_field_is_an_alies_for_print_int)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_field_with(some_name(), 99, 66);

    then_print_int_is_called_with(some_name(), 99, 66, UVM_NORADIX, _DOT, _NULL_STRING);
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_object_header tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_object_header_sets_row_name_to_what_is_passed_in)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_object_header_with(some_name());
    
    then_the_row_name_is_assigned_to(some_name());
  `SVTEST_END()


  `SVTEST(print_object_header_derives_name_from_value_when_null)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_object_header_with(.name(_NULL_STRING), .value(test_obj));

    then_the_row_name_is_assigned_to(test_obj.get_name());
  `SVTEST_END()


  `SVTEST(print_object_header_derives_name_from_component_when_null)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_object_header_with(.name(_NULL_STRING), .value(test_comp));

    then_the_row_name_is_assigned_to(test_comp.get_name());
  `SVTEST_END()


  `SVTEST(print_object_header_name_is_unnamed_for_object_with_no_name)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_set_my_test_obj_name_to(_NULL_STRING);

    when_i_call_print_object_header_with(.name(_NULL_STRING), .value(test_obj));

    then_the_row_name_is_assigned_to("<unnamed>");
  `SVTEST_END()


  `SVTEST(print_object_header_name_is_overridden_with_show_root)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_turn_the_show_root_knob_to(1);

    when_i_call_print_object_header_with(some_name(), .value(test_obj));

    then_the_row_name_is_assigned_to(test_obj.get_name());
  `SVTEST_END()


  `SVTEST(print_object_header_name_from_scope)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("my_scope");
      and_i_turn_the_full_name_knob_to(1);
    
    when_i_call_print_object_header_with(some_name());

    then_the_row_name_is_assigned_to({ "my_scope." , some_name() });
  `SVTEST_END()


  // FAILING TEST - REPORTED IN MANTIS 4602
  // uvm_printer.svh:line 138
  // scope_separator can't be specified by user b/c scope_stack can
  // only handle a '.' as separator. last_row.name in this case is set to
  // "my_scope.my_name" instead of "my_name" as I expect.
// `SVTEST(print_object_header_name_from_scope_with_different_scope_separator)
//   given_i_have_a_new_uvm_printer_in_its_default_state();
//     and_i_push_this_level_to_the_scope_stack("my_scope");
//
//   when_i_call_print_object_header_with(some_name(), null, "J");
//
//   then_the_row_name_is_assigned_to(some_name());
// `SVTEST_END()


  `SVTEST(print_object_header_sets_row_level_to_depth0)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_object_header_with();

    then_the_row_level_is_assigned_to(0);
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_level_to_depthN)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("scope0");
      and_i_push_this_level_to_the_scope_stack("scope1");
      and_i_push_this_level_to_the_scope_stack("scope2");

    when_i_call_print_object_header_with();

    then_the_row_level_is_assigned_to(3);
  `SVTEST_END()

  `SVTEST(print_object_header_sets_row_val_to_hyphen_without_reference)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_turn_the_reference_knob_to(0);

    when_i_call_print_object_header_with();

    then_the_row_val_is_assigned_to("-");
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_val_to_object_value_str_with_reference)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_turn_the_reference_knob_to(1);
      and_i_set_the_inst_count_to(99);

    when_i_call_print_object_header_with(.value(test_obj));

    then_the_row_val_is_assigned_to("@99");
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_size_to_hyphen)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_object_header_with();

    then_the_row_size_is_assigned_to("-");
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_type_name_to_object_if_null)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_object_header_with();

    then_the_row_type_name_is_assigned_to("object");
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_type_name_to_type_name_otherwise)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_object_header_with(.value(test_obj));

    then_the_row_type_name_is_assigned_to(test_obj.get_type_name());
  `SVTEST_END()


  `SVTEST(print_object_header_pushes_back_new_rows)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_object_header_with(some_name(), null);
    `and_i_call_print_object_header_with(some_other_name(), null);

    then_the_row_name_is_assigned_to(some_other_name());
     and_the_old_row_name_is_assigned_to(some_name());
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_object tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_object_calls_print_object_header)
    given_i_have_a_new_uvm_printer_in_its_default_state();
 
    when_i_call_print_object_with(some_name(), test_obj, "J");
 
    then_the_print_object_header_is_called_with(some_name(), test_obj, "J");
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_string tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_string_sets_row_level_to_depthN)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");

    when_i_call_print_string_with(some_name());

    then_the_row_level_is_assigned_to(2);
  `SVTEST_END()


  `SVTEST(print_string_gets_name_from_the_scope_stack)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");
      and_i_turn_the_full_name_knob_to(1);

    when_i_call_print_string_with(some_name());

    then_the_row_name_is_assigned_to({ "branch0.branch1." , some_name() });
  `SVTEST_END()


  // FAILING TEST - COVERD BY MANTIS 4600
// `SVTEST(print_string_sets_name_to_null_string)
//   given_i_have_a_new_uvm_printer_in_its_default_state();
//
//   when_i_call_print_string_with(.name(_NULL_STRING));
//
//   then_the_row_name_is_assigned_to(_NULL_STRING);
// `SVTEST_END()


  // FAILING TEST - COVERED BY MANTIS 4602
// `SVTEST(print_string_name_from_scope_with_different_scope_separator)
//   given_i_have_a_new_uvm_printer_in_its_default_state();
//     and_i_push_this_level_to_the_scope_stack("my_scope");
//
//   when_i_call_print_string_with(some_name(), .scope_separator("R"));
//
//   then_the_row_name_is_assigned_to(some_name());
// `SVTEST_END()

  `SVTEST(print_string_type_name_set_to_string)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_string_with();
  
    then_the_row_type_name_is_assigned_to("string");
  `SVTEST_END()


  `SVTEST(print_string_size_set_to_string_length)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_string_with(.name(some_name()), .value(some_other_name()));
  
    then_the_row_size_is_assigned_to(the_size_of(some_other_name()));
  `SVTEST_END()


  `SVTEST(print_string_sets_val_to_value)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_string_with(.value(some_other_name()));

    then_the_row_val_is_assigned_to(some_other_name());
  `SVTEST_END()


  `SVTEST(print_string_sets_val_to_quotes_for_null_string)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_string_with(.value(_NULL_STRING));

    then_the_row_val_is_assigned_to("\"\"");
  `SVTEST_END()


  `SVTEST(print_string_treats_quotes_in_the_value_field_as_any_other_character)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_string_with(.value("\""));

    then_the_row_val_is_assigned_to("\"");
  `SVTEST_END()


  `SVTEST(print_string_pushes_back_new_rows)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_string_with(some_name());
    `and_i_call_print_string_with(some_other_name());

    then_the_row_name_is_assigned_to(some_other_name());
     and_the_old_row_name_is_assigned_to(some_name());
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_time tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_time_is_an_alies_for_print_int)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_time_with(some_name(), 99, "F");

    then_print_int_is_called_with(some_name(), 99, 64, UVM_TIME, "F", "");
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_real tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_real_sets_row_level_to_depthN)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");

    when_i_call_print_real_with(some_name());

    then_the_row_level_is_assigned_to(2);
  `SVTEST_END()


  `SVTEST(print_real_gets_name_from_the_scope_stack)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");
      and_i_turn_the_full_name_knob_to(1);

    when_i_call_print_real_with(some_name());

    then_the_row_name_is_assigned_to({ "branch0.branch1." , some_name() });
  `SVTEST_END()


  // FAILING TEST - COVERD BY MANTIS 4600
// `SVTEST(print_real_sets_name_to_null_string)
//   given_i_have_a_new_uvm_printer_in_its_default_state();
//
//   when_i_call_print_real_with(.name(_NULL_STRING));
//
//   then_the_row_name_is_assigned_to(_NULL_STRING);
// `SVTEST_END()


  // FAILING TEST - COVERED BY MANTIS 4602
// `SVTEST(print_real_name_from_scope_with_different_scope_separator)
//   given_i_have_a_new_uvm_printer_in_its_default_state();
//     and_i_push_this_level_to_the_scope_stack("my_scope");
//
//   when_i_call_print_real_with(some_name(), .scope_separator("R"));
//
//   then_the_row_name_is_assigned_to(some_name());
// `SVTEST_END()


  // FAILING TEST - REPORTED AS MANTIS 4609
  // uvm_printer.svh:line 909
  // for some reason "..." is treated as a special name. however, the name is never actually
  // assigned in the the case of "..." which means an empty scope stack gets passed to
  // adjust_name. I think want to have the name passed into adjust_name on line 915 instead of
  // m_scope.get() since it's done on 911. I think this is a copy paste bug b/c the right
  // functionality appears to be part of print_generic where on line 811, name is passed to
  // adjust_name
// `SVTEST(WARNING_print_real_trys_to_treat_the_name_of_DOT_DOT_DOT_as_special_for_some_reason)
//   given_i_have_a_new_uvm_printer_in_its_default_state();
//
//   when_i_call_print_real_with(.name("..."));
//
//   then_the_row_name_is_assigned_to("...");
// `SVTEST_END()


  `SVTEST(print_real_type_name_set_to_real)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_real_with();
  
    then_the_row_type_name_is_assigned_to("real");
  `SVTEST_END()


  `SVTEST(print_real_size_set_to_64)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_real_with();
  
    then_the_row_size_is_assigned_to("64");
  `SVTEST_END()


  `SVTEST(print_real_sets_val_to_value)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_real_with(.value(500.1234567));

    then_the_row_val_is_assigned_to("500.123457");
  `SVTEST_END()


  `SVTEST(print_real_pushes_back_new_rows)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_real_with(some_name());
    `and_i_call_print_real_with(some_other_name());

    then_the_row_name_is_assigned_to(some_other_name());
     and_the_old_row_name_is_assigned_to(some_name());
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_generic tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_generic_sets_row_level_to_depthN)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");

    when_i_call_print_generic_with(some_name());

    then_the_row_level_is_assigned_to(2);
  `SVTEST_END()


  `SVTEST(print_generic_gets_name_from_the_scope_stack)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");
      and_i_turn_the_full_name_knob_to(1);

    when_i_call_print_generic_with(some_name());

    then_the_row_name_is_assigned_to({ "branch0.branch1." , some_name() });
  `SVTEST_END()


  // FAILING TEST - COVERD BY MANTIS 4600
// `SVTEST(print_generic_sets_name_to_null_string)
//   given_i_have_a_new_uvm_printer_in_its_default_state();
//
//   when_i_call_print_generic_with(.name(_NULL_STRING));
//
//   then_the_row_name_is_assigned_to(_NULL_STRING);
// `SVTEST_END()


  // FAILING TEST - COVERED BY MANTIS 4602
// `SVTEST(print_generic_name_from_scope_with_different_scope_separator)
//   given_i_have_a_new_uvm_printer_in_its_default_state();
//     and_i_push_this_level_to_the_scope_stack("my_scope");
//
//   when_i_call_print_generic_with(some_name(), .scope_separator("R"));
//
//   then_the_row_name_is_assigned_to(some_name());
// `SVTEST_END()


  `SVTEST(WARNING_print_generic_treats_the_name_of_DOT_DOT_DOT_as_special_for_some_reason)
    given_i_have_a_new_uvm_printer_in_its_default_state();
  
    when_i_call_print_generic_with(.name("..."));
  
    then_the_row_name_is_assigned_to("...");
  `SVTEST_END()


  `SVTEST(print_generic_type_name_set_to_typename)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_generic_with(.type_name("gopher"));
  
    then_the_row_type_name_is_assigned_to("gopher");
  `SVTEST_END()


  `SVTEST(WARNING_print_generic_size_set_to_DOT_DOT_DOT_when_minus2)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_generic_with(.size(-2));
  
    then_the_row_size_is_assigned_to("...");
  `SVTEST_END()


  `SVTEST(print_generic_size_set_to_size_when_lt_minus2)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_generic_with(.size(-3));
  
    then_the_row_size_is_assigned_to("-3");
  `SVTEST_END()


  `SVTEST(print_generic_size_set_to_size_when_gt_minus2)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_generic_with(.size(-1));
  
    then_the_row_size_is_assigned_to("-1");
  `SVTEST_END()


  `SVTEST(print_generic_sets_val_to_value)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_generic_with(.value(some_other_name()));

    then_the_row_val_is_assigned_to(some_other_name());
  `SVTEST_END()


  `SVTEST(print_generic_sets_val_to_quotes_for_null_string)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_generic_with(.value(_NULL_STRING));

    then_the_row_val_is_assigned_to("\"\"");
  `SVTEST_END()


  `SVTEST(print_generic_treats_quotes_in_the_value_field_as_any_other_character)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_generic_with(.value("\""));

    then_the_row_val_is_assigned_to("\"");
  `SVTEST_END()


  `SVTEST(print_generic_pushes_back_new_rows)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_generic_with(some_name());
    `and_i_call_print_generic_with(some_other_name());

    then_the_row_name_is_assigned_to(some_other_name());
     and_the_old_row_name_is_assigned_to(some_name());
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // emit tests
  //-----------------------------
  //-----------------------------

  `SVTEST(emit_asserts_an_error)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_emit;

    then_an_error_is_asserted_by_the_printer;
  `SVTEST_END()


  `SVTEST(emit_returns_null_string)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_emit;

    then_the_emitted_string_is(_NULL_STRING);
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // format_row tests
  //-----------------------------
  //-----------------------------

  `OUTPUT_IS_NULL_STRING_FOR_FORMAT(row)

  //-----------------------------
  //-----------------------------
  // format_header tests
  //-----------------------------
  //-----------------------------

  `OUTPUT_IS_NULL_STRING_FOR_FORMAT(header)

  //-----------------------------
  //-----------------------------
  // format_footer tests
  //-----------------------------
  //-----------------------------

  `OUTPUT_IS_NULL_STRING_FOR_FORMAT(footer)

  //-----------------------------
  //-----------------------------
  // adjust_name tests
  //-----------------------------
  //-----------------------------

  `SVTEST(adjust_name_returns_id_if_full_name_specified)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_turn_the_full_name_knob_to(1);

    when_i_call_adjust_name_with("no.change.expected");

    then_the_adjusted_name_is("no.change.expected");
  `SVTEST_END()


  `SVTEST(adjust_name_returns_id_if_id_is_dot_dot_dot)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_adjust_name_with("...");

    then_the_adjusted_name_is("...");
  `SVTEST_END()


  `SVTEST(adjust_name_returns_id_if_scope_depth_eq_0_and_show_root)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_turn_the_show_root_knob_to(1);

    when_i_call_adjust_name_with("my.id");

    then_the_adjusted_name_is("my.id");
  `SVTEST_END()


  `SVTEST(adjust_name_returns_leaf_scope_otherwise_with_default_scope_separator)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_adjust_name_with("expect.only.this");

    then_the_adjusted_name_is("this");
  `SVTEST_END()


  // FAILING TEST - COVERD BY MANTIS 4600
// `SVTEST(adjust_name_returns_leaf_scope_otherwise_with_user_scope_separator)
//   given_i_have_a_new_uvm_printer_in_its_default_state();
//
//   when_i_call_adjust_name_with("expectJonlyJthis", .scope_separator("J"));
//
//   then_the_adjusted_name_is("this");
// `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_array_header tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_array_header_sets_row_level_to_depthN)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");

    when_i_call_print_array_header_with(some_name());

    then_the_row_level_is_assigned_to(2);
  `SVTEST_END()


  `SVTEST(print_array_header_gets_name_from_the_scope_stack)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");
      and_i_turn_the_full_name_knob_to(1);

    when_i_call_print_array_header_with(some_name());

    then_the_row_name_is_assigned_to({ "branch0.branch1." , some_name() });
  `SVTEST_END()


  // FAILING TEST - COVERD BY MANTIS 4600
// `SVTEST(print_array_header_sets_name_to_null_string)
//   given_i_have_a_new_uvm_printer_in_its_default_state();
//
//   when_i_call_print_array_header_with(.name(_NULL_STRING));
//
//   then_the_row_name_is_assigned_to(_NULL_STRING);
// `SVTEST_END()


  // FAILING TEST - COVERED BY MANTIS 4602
// `SVTEST(print_array_header_name_from_scope_with_different_scope_separator)
//   given_i_have_a_new_uvm_printer_in_its_default_state();
//     and_i_push_this_level_to_the_scope_stack("my_scope");
//
//   when_i_call_print_array_header_with(some_name(), .scope_separator("R"));
//
//   then_the_row_name_is_assigned_to(some_name());
// `SVTEST_END()


  `SVTEST(print_array_header_type_name_set_to_arraytype)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_array_header_with(.arraytype("goof-ball"));
  
    then_the_row_type_name_is_assigned_to("goof-ball");
  `SVTEST_END()


  `SVTEST(print_array_header_size_set_to_size)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_array_header_with(.size(99));
  
    then_the_row_size_is_assigned_to("99");
  `SVTEST_END()


  `SVTEST(print_array_header_sets_val_to_value)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_array_header_with();

    then_the_row_val_is_assigned_to("-");
  `SVTEST_END()


  `SVTEST(print_array_header_pushes_back_new_rows)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_array_header_with(some_name());
    `and_i_call_print_array_header_with(some_other_name());

    then_the_row_name_is_assigned_to(some_other_name());
     and_the_old_row_name_is_assigned_to(some_name());
  `SVTEST_END()


  `SVTEST(print_array_header_appends_name_to_scope)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");

    when_i_call_print_array_header_with(some_name());

    then_the_scope_stack_contains({ "branch0.branch1." , some_name() });
  `SVTEST_END()


  `SVTEST(print_array_header_increases_array_stack_size)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_print_array_header_with(some_name());

    then_the_m_array_stack_size_is(1);
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_array_range tests
  //-----------------------------
  //-----------------------------

  `PRINT_ARRAY_RANGE_CALLS_PRINT_GENERIC_FOR(max_gt_min,0,1)
  `PRINT_ARRAY_RANGE_CALLS_PRINT_GENERIC_FOR(min_eq_minus1,-1,-2)
  `PRINT_ARRAY_RANGE_CALLS_PRINT_GENERIC_FOR(max_eq_minus1,43,-1)
  `PRINT_ARRAY_RANGE_CALLS_PRINT_GENERIC_FOR(min_eq_max,43,43)

  `PRINT_ARRAY_RANGE_DOES_NOTHING_FOR(max_lt_min,1,0)
  `PRINT_ARRAY_RANGE_DOES_NOTHING_FOR(max_and_min_eq_minus1,-1,-1)

  //-----------------------------
  //-----------------------------
  // print_array_footer tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_array_footer_chomps_scope_and_array_stack)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");
      and_i_increase_the_size_of_the_m_array_stack_by(4);

    when_i_call_print_array_footer;

    then_the_scope_stack_contains("branch0");
     `and_the_m_array_stack_size_is(3);
  `SVTEST_END()


  `SVTEST(print_array_footer_ignores_scope_and_array_stack_if_no_array_stack)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");

    when_i_call_print_array_footer;

    then_the_scope_stack_contains("branch0.branch1");
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // istop tests
  //-----------------------------
  //-----------------------------

  `SVTEST(istop_is_true_when_the_depth_of_the_scope_stack_is_0)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_istop();

    then_the_printer_is_the_top();
  `SVTEST_END()


  `SVTEST(istop_is_false_when_the_depth_of_the_scope_stack_is_gt_0)
    given_i_have_a_new_uvm_printer_in_its_default_state();
      and_i_push_this_level_to_the_scope_stack("scope0");

    when_i_call_istop();

    then_the_printer_is_not_the_top();
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // index_string tests
  //-----------------------------
  //-----------------------------

  `SVTEST(index_string_turns_name_and_index_into_an_array_select_string)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_index_string_with(.name("some_array"), .index(99));

    then_the_return_string_is("some_array[99]");
  `SVTEST_END()


  `SVTEST(index_string_always_prints_radix_as_decimal)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_index_string_with(.name("some_array"), .index('hf));

    then_the_return_string_is("some_array[15]");
  `SVTEST_END()


  `SVTEST(WARNING_index_string_accepts_default_name_of_null_string)
    given_i_have_a_new_uvm_printer_in_its_default_state();

    when_i_call_index_string_with(.name(_NULL_STRING), .index('hf));

    then_the_return_string_is("[15]");
  `SVTEST_END()

  `SVUNIT_TESTS_END


  //-----------------------------
  //-----------------------------
  // Helper Methods
  //-----------------------------
  //-----------------------------

  function void given_i_have_a_new_uvm_printer_in_its_default_state();
    test_obj = new("obj_name"); 
  endfunction

  function automatic void update_last_row();
    last_row = uut.get_last_row();
  endfunction

  function automatic void update_first_row();
    first_row = uut.get_first_row();
  endfunction


  //-----------
  // GIVENS...
  //-----------

  function void and_i_push_this_level_to_the_scope_stack(string b);
    uut.m_scope.down(b);
  endfunction

  `define AND_I_TURN_THE_(KNOB,TYPE) \
  function void and_i_turn_the_``KNOB``_knob_to(TYPE k); \
    uut.knobs.KNOB = k; \
  endfunction

  `AND_I_TURN_THE_(full_name,bit)
  `AND_I_TURN_THE_(bin_radix,string)
  `AND_I_TURN_THE_(default_radix,uvm_radix_enum)
  `AND_I_TURN_THE_(show_root,bit)
  `AND_I_TURN_THE_(reference,bit)

  function void and_i_set_my_test_obj_name_to(string s);
    test_obj.set_name(s);
  endfunction

  `define SOME_(NAME,TYPE,VALUE) function TYPE some_``NAME(); return VALUE; endfunction

  `SOME_(value,int,0)
  `SOME_(size,int,0)
  `SOME_(name,string,"some_name")
  `SOME_(other_name,string,"some_other_name")

  function void and_i_set_the_inst_count_to(int i);
    test_uvm_object::set_inst_count(i);
    test_obj = new("obj_name");
  endfunction

  function void and_i_increase_the_size_of_the_m_array_stack_by(int i);
    repeat (i) uut.m_array_stack_push_back();
  endfunction

  //----------
  // WHENS...
  //----------
  `define PRINT_INT_ARGS string name = some_name(), \
                         uvm_bitstream_t value = some_value(), \
                         int size = some_size(), \
                         uvm_radix_enum radix=UVM_NORADIX, \
                         byte scope_separator=".", \
                         string type_name=""

  `define PRINT_OBJ_ARGS string name = some_name(), \
                         uvm_object value = null, \
                         byte scope_separator="."

  function void when_i_call_print_int_with(`PRINT_INT_ARGS);
    uut.print_int(name, value, size, radix, scope_separator, type_name);
    update_first_row();
    update_last_row();
  endfunction

  function void when_i_call_print_object_header_with (`PRINT_OBJ_ARGS);
    uut.print_object_header(name, value, scope_separator);
    update_first_row();
    update_last_row();
  endfunction

  function void when_i_call_print_object_with(`PRINT_OBJ_ARGS);
    uut.print_object(name, value, scope_separator);
  endfunction

  function void when_i_call_print_field_with(string name = some_name(),
                                             uvm_bitstream_t value = 0,
                                             int size);
    uut.print_field(name, value, size);
  endfunction

  function void when_i_call_print_time_with(string name = some_name(),
                                            uvm_bitstream_t value = 0,
                                            byte scope_separator=".");
    uut.print_time(name, value, scope_separator);
  endfunction

  function void when_i_call_print_string_with(string name = some_name(),
                                              string value = "",
                                              byte scope_separator=".");
    uut.print_string(name, value, scope_separator);
    update_first_row();
    update_last_row();
  endfunction

  function void when_i_call_print_real_with(string name = some_name(),
                                            real value = 0,
                                            byte scope_separator=".");
    uut.print_real(name, value, scope_separator);
    update_first_row();
    update_last_row();
  endfunction

  function void when_i_call_print_generic_with(string name = some_name(),
                                               string type_name = "",
                                               int size = 0,
                                               string value = "",
                                               byte scope_separator=".");
    uut.print_generic(name, type_name, size, value, scope_separator);
    update_first_row();
    update_last_row();
  endfunction

  function void when_i_call_print_array_header_with(string name = some_name(),
                                                    int size = 0,
                                                    string arraytype = "",
                                                    byte scope_separator=".");
    uut.print_array_header(name, size, arraytype, scope_separator);
    update_first_row();
    update_last_row();
  endfunction

  function void when_i_call_print_array_footer;
    uut.print_array_footer();
    update_first_row();
    update_last_row();
  endfunction


  function void when_i_call_adjust_name_with(string s,
                                             byte scope_separator = ".");
    adjusted_name = uut.test_adjust_name(s, scope_separator);
  endfunction

  int istop;
  function void when_i_call_istop();
    istop = uut.istop();
  endfunction

  function void when_i_call_index_string_with(string name, int index);
    string_index = uut.index_string(index, name);
  endfunction

  function void when_i_call_emit;
    emitted_string = uut.emit();
  endfunction

  function void when_i_call_format_row;
    uvm_printer_row_info row;
    formatted_output = uut.format_row(row);
  endfunction

  function void when_i_call_format_header;
    formatted_output = uut.format_header();
  endfunction

  function void when_i_call_format_footer;
    formatted_output = uut.format_footer();
  endfunction

  function void when_i_call_print_array_range_with(int min, int max);
    uut.print_array_range(min, max);
  endfunction

  //----------
  // THENS...
  //----------

  `define THEN_THE_ROW_IS_ASSIGNED_TO(NAME,TYPE) \
  task then_the_row_``NAME``_is_assigned_to(TYPE s); \
    `FAIL_IF(last_row.NAME != s); \
  endtask

  `THEN_THE_ROW_IS_ASSIGNED_TO(name,string)
  `THEN_THE_ROW_IS_ASSIGNED_TO(level,int)
  `THEN_THE_ROW_IS_ASSIGNED_TO(type_name,string)
  `THEN_THE_ROW_IS_ASSIGNED_TO(size,string)
  `THEN_THE_ROW_IS_ASSIGNED_TO(val,string)

  task and_the_old_row_name_is_assigned_to(string s);
    `FAIL_IF(first_row.name != s);
  endtask

  task then_print_int_is_called_with(string name,
                                     uvm_bitstream_t value,
                                     int size,
                                     uvm_radix_enum radix,
                                     byte scope_separator,
                                     string type_name);
    `FAIL_UNLESS(uut.print_int_was_called_with(name, value, size, radix, scope_separator, type_name));
  endtask

  task then_the_adjusted_name_is(string s);
    `FAIL_UNLESS(adjusted_name == s);
  endtask
 
  task then_the_print_object_header_is_called_with(string name,
                                                   uvm_object value,
                                                   byte scope_separator);
    `FAIL_UNLESS(uut.print_object_header_was_called_with(name, value, scope_separator));
  endtask

  task then_the_printer_is_the_top();
    `FAIL_IF(istop == 0);
  endtask

  task then_the_printer_is_not_the_top();
    `FAIL_IF(istop != 0);
  endtask

  function string the_size_of(string s);
    return $sformatf("%0d", s.len());
  endfunction

  task  then_the_return_string_is(string s);
    `FAIL_UNLESS(string_index == s);
  endtask

  task then_an_error_is_asserted_by_the_printer;
    uvm_report_mock::expect_error("NO_OVERRIDE", "emit() method not overridden in printer subtype");
    `FAIL_IF(!uvm_report_mock::verify_complete());
  endtask

  task then_the_emitted_string_is(string s);
    `FAIL_IF(emitted_string != s);
  endtask

  task then_the_formatted_output_is(string s);
    `FAIL_IF(formatted_output != s);
  endtask

  task then_the_scope_stack_contains(string s);
    `FAIL_IF(uut.m_scope.get() != s);
  endtask

  task then_the_m_array_stack_size_is(int i);
    `FAIL_IF(uut.get_array_stack_size() != i);
  endtask

  task then_print_generic_is_called_with(string a, string b, int i, string c, byte d);
    `FAIL_UNLESS(uut.print_generic_was_called_with(a, b, i, c, d));
  endtask

  task then_no_row_is_added;
    `FAIL_UNLESS(uut.get_num_rows == 0);
  endtask

endmodule
