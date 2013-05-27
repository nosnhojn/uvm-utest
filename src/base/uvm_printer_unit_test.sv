`include "svunit_defines.svh"
`include "test_uvm_printer.sv"
`include "test_uvm_object.sv"
`include "test_uvm_component.sv"
`include "test_uvm_agent.sv"
`include "test_defines.sv"

import svunit_pkg::*;

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

  string s_exp;
  string adjusted_name;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);
    test_obj = new("obj_name");
    test_comp = new("comp_name");
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
    given_i_set_my_expected_result_to("");
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

  // FAILING TEST because of the uvm_leaf_scope infinite loop
// `SVTEST(print_int_can_return_the_row_name_as_empty_string)
//   given_i_have_a_new_uvm_printer();
//
//   when_i_call_print_int_with(_NULL_STRING);
//
//   then_the_row_name_is_assigned_to(_NULL_STRING);
// `SVTEST_END()


  `SVTEST(print_int_can_return_the_row_name_as_full_scope)
    given_i_have_a_new_uvm_printer();
      and_i_turn_the_full_name_knob_to(1);
      and_i_push_this_level_to_the_scope_stack("branch");

    when_i_call_print_int_with(the_name("leaf"));

    then_the_row_name_is_assigned_to("branch.leaf");
  `SVTEST_END()


  `SVTEST(print_int_can_return_the_row_name_as_leaf_scope)
    given_i_have_a_new_uvm_printer();
      and_i_push_this_level_to_the_scope_stack("branch");

    when_i_call_print_int_with(the_name("leaf"));

    then_the_row_name_is_assigned_to("leaf");
  `SVTEST_END()


  `SVTEST(print_int_returns_row_level_as_scope_depth)
    given_i_have_a_new_uvm_printer();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");

    when_i_call_print_int_with();

    then_the_row_level_is_assigned_to(2);
  `SVTEST_END()


  `SVTEST(print_int_returns_row_type_name_if_specified)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_int_with(.type_name("my_type_name"));

    then_the_row_type_name_is_assigned_to("my_type_name");
  `SVTEST_END()


  `SVTEST(print_int_can_return_the_row_type_name_as_time)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_int_with(.radix(UVM_TIME));

    then_the_row_type_name_is_assigned_to("time");
  `SVTEST_END()


  `SVTEST(print_int_can_return_the_row_type_name_as_string)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_int_with(.radix(UVM_STRING));

    then_the_row_type_name_is_assigned_to("string");
  `SVTEST_END()


  `SVTEST(print_int_returns_row_type_name_as_integral_by_default)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_int_with();

    then_the_row_type_name_is_assigned_to("integral");
  `SVTEST_END()


  `SVTEST(print_int_returns_row_numeric_size_as_string)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_int_with(.size(-1));

    then_the_row_size_is_assigned_to("-1");
  `SVTEST_END()


  // borrowed these values from the uvm_misc::uvm_vector_to_string test
  `SVTEST(print_int_returns_val_as_uvm_vector_to_string)
    given_i_have_a_new_uvm_printer();
      and_i_turn_the_bin_radix_knob_to("B");

    when_i_call_print_int_with(.value(121), .size(5), .radix(UVM_BIN));

    then_the_row_val_is_assigned_to("B11001");
  `SVTEST_END()


  // borrowed these values from the uvm_misc::uvm_vector_to_string test
  `SVTEST(print_int_uses_default_radix_when_noradix_specified)
    given_i_have_a_new_uvm_printer();
      and_i_turn_the_default_radix_knob_to(UVM_OCT);

    when_i_call_print_int_with(.value(1567), .size(10));

    then_the_row_val_is_assigned_to("'o1037");
  `SVTEST_END()


  `SVTEST(print_int_pushes_back_new_rows)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_int_with(some_name());
     and_i_call_print_int_with(some_other_name());

    then_the_new_row_name_is_assigned_to(some_other_name());
     and_the_old_row_name_is_assigned_to(some_name());
  `SVTEST_END()


  //-----------------------------
  //-----------------------------
  // print_field tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_field_is_an_alies_for_print_int)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_field_with(some_name(), 99, 66);

    then_print_int_is_called_with(some_name(), 99, 66, UVM_NORADIX, _DOT, _NULL_STRING);
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_object_header tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_object_header_sets_row_name_to_what_is_passed_in)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_object_header_with(some_name());
    
    then_the_row_name_is_assigned_to(some_name());
  `SVTEST_END()


  `SVTEST(print_object_header_derives_name_from_value_when_null)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_object_header_with(.name(_NULL_STRING), .value(test_obj));

    then_the_row_name_is_assigned_to(test_obj.get_name());
  `SVTEST_END()


  `SVTEST(print_object_header_derives_name_from_component_when_null)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_object_header_with(.name(_NULL_STRING), .value(test_comp));

    then_the_row_name_is_assigned_to(test_comp.get_name());
  `SVTEST_END()


  `SVTEST(print_object_header_name_is_unnamed_for_object_with_no_name)
    given_i_have_a_new_uvm_printer();
      and_i_set_my_test_obj_name_to(_NULL_STRING);

    when_i_call_print_object_header_with(.name(_NULL_STRING), .value(test_obj));

    then_the_row_name_is_assigned_to("<unnamed>");
  `SVTEST_END()


  `SVTEST(print_object_header_name_is_overridden_with_show_root)
    given_i_have_a_new_uvm_printer();
      and_i_turn_the_show_root_knob_to(1);

    when_i_call_print_object_header_with(some_name(), .value(test_obj));

    then_the_row_name_is_assigned_to(test_obj.get_name());
  `SVTEST_END()


  `SVTEST(print_object_header_name_from_scope)
    given_i_have_a_new_uvm_printer();
      and_i_push_this_level_to_the_scope_stack("my_scope");
      and_i_turn_the_full_name_knob_to(1);
    
    when_i_call_print_object_header_with(some_name());

    then_the_row_name_is_assigned_to({ "my_scope." , some_name() });
  `SVTEST_END()


  // FAILING TEST - REPORTED
  // uvm_printer.svh:line 138
  // scope_separator can't be specified by user b/c scope_stack can
  // only handle a '.' as separator. last_row.name in this case is set to
  // "my_scope.my_name" instead of "my_name" as I expect.
// `SVTEST(print_object_header_name_from_scope_with_different_scope_separator)
//   given_i_have_a_new_uvm_printer();
//     and_i_push_this_level_to_the_scope_stack("my_scope");
//
//   when_i_call_print_object_header_with(some_name(), null, "J");
//
//   then_the_row_name_is_assigned_to(some_name());
// `SVTEST_END()


  `SVTEST(print_object_header_sets_row_level_to_depth0)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_object_header_with();

    then_the_row_level_is_assigned_to(0);
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_level_to_depthN)
    given_i_have_a_new_uvm_printer();
      and_i_push_this_level_to_the_scope_stack("scope0");
      and_i_push_this_level_to_the_scope_stack("scope1");
      and_i_push_this_level_to_the_scope_stack("scope2");

    when_i_call_print_object_header_with();

    then_the_row_level_is_assigned_to(3);
  `SVTEST_END()

  `SVTEST(print_object_header_sets_row_val_to_hyphen_without_reference)
    given_i_have_a_new_uvm_printer();
      and_i_turn_the_reference_knob_to(0);

    when_i_call_print_object_header_with();

    then_the_row_val_is_assigned_to("-");
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_val_to_object_value_str_with_reference)
    given_i_have_a_new_uvm_printer();
      and_i_turn_the_reference_knob_to(1);
      and_i_set_the_inst_count_to(99);

    when_i_call_print_object_header_with(.value(test_obj));

    then_the_row_val_is_assigned_to("@99");
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_size_to_hyphen)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_object_header_with();

    then_the_row_size_is_assigned_to("-");
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_type_name_to_object_if_null)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_object_header_with();

    then_the_row_type_name_is_assigned_to("object");
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_type_name_to_type_name_otherwise)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_object_header_with(.value(test_obj));

    then_the_row_type_name_is_assigned_to(test_obj.get_type_name());
  `SVTEST_END()


  `SVTEST(print_object_header_pushes_back_new_rows)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_object_header_with(some_name(), null);
     and_i_call_print_object_header_with(some_other_name(), null);

    then_the_new_row_name_is_assigned_to(some_other_name());
     and_the_old_row_name_is_assigned_to(some_name());
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_object tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_object_calls_print_object_header)
    given_i_have_a_new_uvm_printer();
 
    when_i_call_print_object_with(some_name(), test_obj, "J");
 
    then_the_print_object_header_is_called_with(some_name(), test_obj, "J");
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_string tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_string_sets_row_level_to_depthN)
    given_i_have_a_new_uvm_printer();
      and_i_push_this_level_to_the_scope_stack("branch0");
      and_i_push_this_level_to_the_scope_stack("branch1");

    when_i_call_print_string_with();

    then_the_row_level_is_assigned_to(2);
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_time tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_time_is_an_alies_for_print_int)
    given_i_have_a_new_uvm_printer();

    when_i_call_print_time_with(some_name(), 99, "F");

    then_print_int_is_called_with(some_name(), 99, 64, UVM_TIME, "F", "");
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_real tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // print_generic tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // emit tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // format_row tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // format_header tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // format_footer tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // adjust_name tests
  //-----------------------------
  //-----------------------------

  `SVTEST(adjust_name_returns_id_if_full_name_specified)
    given_i_have_a_new_uvm_printer();
      and_i_turn_the_full_name_knob_to(1);

    when_i_call_adjust_name_with("no.change.expected");

    then_the_adjusted_name_is("no.change.expected");
  `SVTEST_END()


  `SVTEST(adjust_name_returns_id_if_id_is_dot_dot_dot)
    given_i_have_a_new_uvm_printer();

    when_i_call_adjust_name_with("...");

    then_the_adjusted_name_is("...");
  `SVTEST_END()


  `SVTEST(adjust_name_returns_id_if_scope_depth_eq_0_and_show_root)
    given_i_have_a_new_uvm_printer();
      and_i_turn_the_show_root_knob_to(1);

    when_i_call_adjust_name_with("my.id");

    then_the_adjusted_name_is("my.id");
  `SVTEST_END()


  `SVTEST(adjust_name_returns_leaf_scope_otherwise_with_default_scope_separator)
    given_i_have_a_new_uvm_printer();

    when_i_call_adjust_name_with("expect.only.this");

    then_the_adjusted_name_is("this");
  `SVTEST_END()


  // FAILING TEST - COVERD BY MANTIS 4600
// `SVTEST(adjust_name_returns_leaf_scope_otherwise_with_user_scope_separator)
//   given_i_have_a_new_uvm_printer();
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
  // TBD

  //-----------------------------
  //-----------------------------
  // print_array_range tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // print_array_footer tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // istop tests
  //-----------------------------
  //-----------------------------

  `SVTEST(istop_is_true_when_the_depth_of_the_scope_stack_is_0)
    given_i_have_a_new_uvm_printer();

    when_i_call_istop();

    then_the_printer_is_the_top();
  `SVTEST_END()


  `SVTEST(istop_is_false_when_the_depth_of_the_scope_stack_is_gt_0)
    given_i_have_a_new_uvm_printer();
      and_i_push_this_level_to_the_scope_stack("scope0");

    when_i_call_istop();

    then_the_printer_is_not_the_top();
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // index_string tests
  //-----------------------------
  //-----------------------------
  // TBD

  `SVUNIT_TESTS_END


  //-----------------------------
  //-----------------------------
  // Helper Methods
  //-----------------------------
  //-----------------------------

  function void given_i_have_a_new_uvm_printer();
    test_obj = new("obj_name"); 
  endfunction

  function void given_i_set_my_expected_result_to(string s);
    s_exp = s;
  endfunction

  function string my_expected_result();
    return s_exp;
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

  function void and_i_turn_the_full_name_knob_to(bit k);
    uut.knobs.full_name = k;
  endfunction

  function void and_i_turn_the_bin_radix_knob_to(string k);
    uut.knobs.bin_radix = k;
  endfunction

  function void and_i_turn_the_default_radix_knob_to(uvm_radix_enum r);
    uut.knobs.default_radix = r;
  endfunction

  function void and_i_turn_the_show_root_knob_to(bit k);
    uut.knobs.show_root = k;
  endfunction

  function void and_i_turn_the_reference_knob_to(bit k);
    uut.knobs.reference = k;
  endfunction

  function void and_i_set_my_test_obj_name_to(string s);
    test_obj.set_name(s);
  endfunction

  function string some_name();
    return "some_name";
  endfunction

  function string some_other_name();
    return "some_other_name";
  endfunction

  function string the_name(string s);
    return s;
  endfunction

  function int some_value();
    return 0;
  endfunction

  function int some_size();
    return 0;
  endfunction

  function void and_i_set_the_inst_count_to(int i);
    test_uvm_object::set_inst_count(i);
    test_obj = new("obj_name");
  endfunction

  //----------
  // WHENS...
  //----------

  function void when_i_call_print_int_with(string name = some_name(),
                                    uvm_bitstream_t value = some_value(),
                                    int size = some_size(),
                                    uvm_radix_enum radix=UVM_NORADIX,
                                    byte scope_separator=".",
                                    string type_name="");
    and_i_call_print_int_with(name, value, size, radix, scope_separator, type_name);
  endfunction

  function void and_i_call_print_int_with(string name = some_name(),
                                    uvm_bitstream_t value = some_value(),
                                    int size = some_size(),
                                    uvm_radix_enum radix=UVM_NORADIX,
                                    byte scope_separator=".",
                                    string type_name="");
    uut.print_int(name, value, size, radix, scope_separator, type_name);
    update_first_row();
    update_last_row();
  endfunction

  function void when_i_call_print_object_header_with (string name = some_name(),
                                                      uvm_object value = null,
                                                      byte scope_separator=".");
    uut.print_object_header(name, value, scope_separator);
    update_first_row();
    update_last_row();
  endfunction

  function void and_i_call_print_object_header_with (string name = some_name(),
                                                     uvm_object value = null,
                                                     byte scope_separator=".");
    when_i_call_print_object_header_with (name, test_obj, scope_separator);
  endfunction

  function void when_i_call_print_field_with(string name,
                                             uvm_bitstream_t value,
                                             int size);
    uut.print_field(name, value, size);
  endfunction

  function void when_i_call_print_time_with(string name,
                                            uvm_bitstream_t value,
                                            byte scope_separator=".");
    uut.print_time(name, value, scope_separator);
  endfunction

  function void when_i_call_adjust_name_with(string s, byte scope_separator = ".");
    adjusted_name = uut.test_adjust_name(s, scope_separator);
  endfunction

  function void when_i_call_print_object_with(string name = some_name(),
                                              uvm_object value = null,
                                              byte scope_separator=".");
    uut.print_object(name, value, scope_separator);
  endfunction

  function void when_i_call_print_string_with(string name = some_name(),
                                              string value = "",
                                              byte scope_separator=".");
    uut.print_string(name, value, scope_separator);
    update_first_row();
    update_last_row();
  endfunction

  int istop;
  function void when_i_call_istop();
    istop = uut.istop();
  endfunction


  //----------
  // THENS...
  //----------

  task then_the_row_name_is_assigned_to(string s);
    then_the_new_row_name_is_assigned_to(s);
  endtask

  task then_the_new_row_name_is_assigned_to(string s);
    `FAIL_IF(last_row.name != s);
  endtask

  task and_the_old_row_name_is_assigned_to(string s);
    `FAIL_IF(first_row.name != s);
  endtask

  task then_the_row_level_is_assigned_to(int i);
    `FAIL_IF(last_row.level != i);
  endtask

  task then_the_row_type_name_is_assigned_to(string s);
    `FAIL_IF(last_row.type_name != s);
  endtask

  task then_the_row_size_is_assigned_to(string s);
    `FAIL_IF(last_row.size != s);
  endtask

  task then_the_row_val_is_assigned_to(string s);
    `FAIL_IF(last_row.val != s);
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
    `FAIL_IF(adjusted_name != s);
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
    
endmodule
