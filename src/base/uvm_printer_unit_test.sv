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
    when_i_set_my_expected_result_to("");
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
  // and_call_print_int_with tests
  //-----------------------------
  //-----------------------------

  // FAILING TEST because of the uvm_leaf_scope infinite loop
// `SVTEST(print_int_can_reand_turn_the_row_name_as_empty_string)
//   and_call_print_int_with("", 0, 0);
//   get_last_row();
//   `FAIL_IF(last_row.name != _NULL_STRING);
// `SVTEST_END()


  `SVTEST(print_int_can_return_the_row_name_as_full_scope)
    when_i_set_my_expected_result_to("branch.leaf");
    and_turn_the_full_name_knob_to(1);
    and_push_this_level_to_the_scope_stack("branch");

    and_call_print_int_with("leaf", 0, 0);

    then_the_last_row_name_should_equal(my_expected_result());
  `SVTEST_END()


  `SVTEST(print_int_can_reand_turn_the_row_name_as_leaf_scope)
    when_i_set_my_expected_result_to("leaf");
    and_push_this_level_to_the_scope_stack("branch");

    and_call_print_int_with(my_expected_result(), 0, 0);

    then_the_last_row_name_should_equal(my_expected_result());
  `SVTEST_END()


  `SVTEST(print_int_returns_row_level_as_scope_depth)
    and_push_this_level_to_the_scope_stack("branch0");
    and_push_this_level_to_the_scope_stack("branch1");

    and_call_print_int_with(arbitrary_name(), 0, 0);

    `FAIL_IF(last_row.level != 2);
  `SVTEST_END()


  `SVTEST(print_int_returns_row_type_name_if_specified)
    when_i_set_my_expected_result_to("silly_billy");

    and_call_print_int_with(arbitrary_name(), 0, 0, UVM_NORADIX, ".", my_expected_result());

    `FAIL_IF(last_row.type_name != my_expected_result());
  `SVTEST_END()


  `SVTEST(print_int_can_reand_turn_the_row_type_name_as_time)
    when_i_set_my_expected_result_to("time");

    and_call_print_int_with(arbitrary_name(), 0, 0, UVM_TIME);

    `FAIL_IF(last_row.type_name != my_expected_result());
  `SVTEST_END()


  `SVTEST(print_int_can_reand_turn_the_row_type_name_as_string)
    when_i_set_my_expected_result_to("string");

    and_call_print_int_with(arbitrary_name(), 0, 0, UVM_STRING);

    `FAIL_IF(last_row.type_name != my_expected_result());
  `SVTEST_END()


  `SVTEST(print_int_returns_row_type_name_as_integral_by_default)
    when_i_set_my_expected_result_to("integral");

    and_call_print_int_with(arbitrary_name(), 0, 0);

    `FAIL_IF(last_row.type_name != my_expected_result());
  `SVTEST_END()


  `SVTEST(print_int_returns_row_size_as_string)
    when_i_set_my_expected_result_to("-1");

    and_call_print_int_with(arbitrary_name(), 0, -1);

    `FAIL_IF(last_row.size != my_expected_result());
  `SVTEST_END()


  // borrowed these values from the uvm_misc::uvm_vector_to_string test
  `SVTEST(print_int_returns_val_as_uvm_vector_to_string)
    when_i_set_my_expected_result_to("B11001");
    and_turn_the_bin_radix_knob_to("B");

    and_call_print_int_with(arbitrary_name(), 121, 5, UVM_BIN);

    `FAIL_IF(last_row.val != my_expected_result());
  `SVTEST_END()


  // borrowed these values from the uvm_misc::uvm_vector_to_string test
  `SVTEST(print_int_uses_default_radix_when_noradix_specified)
    when_i_set_my_expected_result_to("'o1037");
    and_turn_the_default_radix_knob_to(UVM_OCT);

    and_call_print_int_with(arbitrary_name(), 1567, 10);

    `FAIL_IF(last_row.val != my_expected_result());
  `SVTEST_END()


  `SVTEST(print_int_pushes_back_new_rows)
    and_call_print_int_with(arbitrary_name(), 1567, 10);
    and_call_print_int_with(a_different_arbitrary_name(), 1567, 10);

    `FAIL_IF(first_row.name != arbitrary_name() || last_row.name != a_different_arbitrary_name());
  `SVTEST_END()


  //-----------------------------
  //-----------------------------
  // print_field tests
  //-----------------------------
  //-----------------------------
  `SVTEST(print_field_is_an_alies_for_print_int)
    when_i_set_my_expected_result_to("my_name");

    uut.print_field(my_expected_result(), 99, 66);

    `FAIL_UNLESS(uut.print_int_was_called_with(my_expected_result(), 99, 66, UVM_NORADIX, _DOT, _NULL_STRING));
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_object_header tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_object_header_sets_row_name_to_what_is_passed_in)
    when_i_set_my_expected_result_to("name");

    call_print_object_header_with(my_expected_result(), test_obj);

    `FAIL_IF(last_row.name != my_expected_result());
  `SVTEST_END()


  `SVTEST(print_object_header_derives_name_from_value)
    call_print_object_header_with("", test_obj);

    `FAIL_IF(last_row.name != test_obj.get_name());
  `SVTEST_END()


  `SVTEST(print_object_header_derives_name_from_component)
    call_print_object_header_with("", test_comp);

    `FAIL_IF(last_row.name != test_comp.get_name());
  `SVTEST_END()


  `SVTEST(print_object_header_name_can_be_unnamed_for_object_with_no_name)
    when_i_set_my_expected_result_to("<unnamed>");
    test_obj = new("");

    call_print_object_header_with("", test_obj);

    `FAIL_IF(last_row.name != my_expected_result());
  `SVTEST_END()


  `SVTEST(print_object_header_name_is_overridden_with_show_root)
    and_turn_the_show_root_knob_to(1);

    call_print_object_header_with(arbitrary_name(), test_obj);

    `FAIL_IF(last_row.name != test_obj.get_name());
  `SVTEST_END()


  `SVTEST(print_object_header_name_from_scope)
    when_i_set_my_expected_result_to("my_name");
    and_push_this_level_to_the_scope_stack("my_scope");
    
    call_print_object_header_with(my_expected_result(), null);

    `FAIL_IF(last_row.name != my_expected_result());
  `SVTEST_END()


  // FAILING TEST - REPORTED
  // uvm_printer.svh:line 138
  // scope_separator can't be specified by user b/c scope_stack can
  // only handle a '.' as separator. last_row.name in this case is set to
  // "my_scope.my_name" instead of "my_name" as I expect.
// `SVTEST(print_object_header_name_from_scope_with_different_scope_separator)
//   when_i_set_my_expected_result_to("my_name");
//   and_push_this_level_to_the_scope_stack("my_scope");
//
//   call_print_object_header_with(my_expected_result(), null, "J");
//
//   `FAIL_IF(last_row.name != my_expected_result());
// `SVTEST_END()


  `SVTEST(print_object_header_sets_row_level_to_depth0)
    call_print_object_header_with("", null);

    `FAIL_IF(last_row.level != 0);
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_level_to_depthN)
    and_push_this_level_to_the_scope_stack(_NULL_STRING);
    and_push_this_level_to_the_scope_stack(_NULL_STRING);
    and_push_this_level_to_the_scope_stack(_NULL_STRING);

    call_print_object_header_with("", null);

    `FAIL_IF(last_row.level != 3);
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_val_to_hyphen_without_reference)
    when_i_set_my_expected_result_to("-");
    and_turn_the_reference_knob_to(0);

    call_print_object_header_with("", null);

    `FAIL_IF(last_row.val != my_expected_result());
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_val_to_object_value_str_with_reference)
    when_i_set_my_expected_result_to("@99");
    and_turn_the_reference_knob_to(1);
    test_uvm_object::set_inst_count(99);
    test_obj = new("");

    call_print_object_header_with("", test_obj);

    `FAIL_IF(last_row.val != my_expected_result());
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_size_to_hyphen)
    when_i_set_my_expected_result_to("-");

    call_print_object_header_with("", null);

    `FAIL_IF(last_row.size != my_expected_result());
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_type_name_to_object_if_null)
    when_i_set_my_expected_result_to("object");

    call_print_object_header_with("", null);

    `FAIL_IF(last_row.type_name != my_expected_result());
  `SVTEST_END()


  `SVTEST(print_object_header_sets_row_type_name_to_type_name_otherwise)
    call_print_object_header_with("", test_obj);

    `FAIL_IF(last_row.type_name != test_obj.get_type_name());
  `SVTEST_END()


  `SVTEST(print_object_header_pushes_back_new_rows)
    string first_name = "leaf";
    string last_name = "grief";

    call_print_object_header_with(first_name, null);
    call_print_object_header_with(last_name, null);

    `FAIL_IF(first_row.name != first_name || last_row.name != last_name);
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_object tests
  //-----------------------------
  //-----------------------------

// `SVTEST(print_object_prints_an_object_header)
//   string my_name = "my_name";
//   byte ss = "J";
//
//   uut.print_object(my_name, test_obj, ss);
//
//   `FAIL_UNLESS(uut.print_object_header_was_called_with(my_name, test_obj, ss));
// `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_string tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // print_time tests
  //-----------------------------
  //-----------------------------
  // TBD

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
    when_i_set_my_expected_result_to("no.change.expected");
    and_turn_the_full_name_knob_to(1);

    `FAIL_IF(uut.test_adjust_name(my_expected_result()) != my_expected_result());
  `SVTEST_END()


  `SVTEST(adjust_name_returns_id_if_id_is_dot_dot_dot)
    when_i_set_my_expected_result_to("...");

    `FAIL_IF(uut.test_adjust_name(my_expected_result()) != my_expected_result());
  `SVTEST_END()


  `SVTEST(adjust_name_returns_id_if_scope_depth_eq_0_and_show_root)
    when_i_set_my_expected_result_to("id");
    and_turn_the_show_root_knob_to(1);

    `FAIL_IF(uut.test_adjust_name(my_expected_result()) != my_expected_result());
  `SVTEST_END()


  `SVTEST(adjust_name_returns_leaf_scope_otherwise)
    string id_in = "no.change.expected";
    string id_out = "expected";

    `FAIL_IF(uut.test_adjust_name(id_in) != id_out);
  `SVTEST_END()

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
  // TBD

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

  function void when_i_set_my_expected_result_to(string s);
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

  function void and_call_print_int_with(string name,
                                    uvm_bitstream_t value,
                                    int size,
                                    uvm_radix_enum radix=UVM_NORADIX,
                                    byte scope_separator=".",
                                    string type_name="");
    uut.print_int(name, value, size, radix, scope_separator, type_name);
    update_first_row();
    update_last_row();
  endfunction

  function void call_print_object_header_with (string name,
                                     uvm_object value,
                                     byte scope_separator=".");
    uut.print_object_header(name, value, scope_separator);
    update_first_row();
    update_last_row();
  endfunction

  function void and_push_this_level_to_the_scope_stack(string b);
    uut.m_scope.down(b);
  endfunction

  function void and_turn_the_full_name_knob_to(bit k);
    uut.knobs.full_name = k;
  endfunction

  function void and_turn_the_bin_radix_knob_to(string k);
    uut.knobs.bin_radix = k;
  endfunction

  function void and_turn_the_default_radix_knob_to(uvm_radix_enum r);
    uut.knobs.default_radix = r;
  endfunction

  function void and_turn_the_show_root_knob_to(bit k);
    uut.knobs.show_root = k;
  endfunction

  function void and_turn_the_reference_knob_to(bit k);
    uut.knobs.reference = k;
  endfunction

  function string arbitrary_name();
    return "arbitrary_name";
  endfunction

  function string a_different_arbitrary_name();
    return "arbitrary_name";
  endfunction

  task then_the_last_row_name_should_equal(string s);
    `FAIL_IF(last_row.name != s);
  endtask
endmodule
