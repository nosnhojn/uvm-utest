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
  uvm_printer_row_info info;
  test_uvm_object test_obj;
  test_uvm_component test_comp;


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

  `SVTEST(printer_knobs_at_construction)
    `FAIL_IF(uut.knobs == null);
  `SVTEST_END(printer_knobs_at_construction)

  //-----------------------------
  //-----------------------------
  // print_int tests
  //-----------------------------
  //-----------------------------

  // FAILING TEST because of the uvm_leaf_scope infinite loop
// `SVTEST(print_int_can_return_row_name_as_empty_string)
//   uut.print_int("", 0, 0);
//   info = uut.get_last_row();
//   `FAIL_IF(info.name != _NULL_STRING);
// `SVTEST_END(print_int_can_return_row_name_as_empty_string)

  `SVTEST(print_int_can_return_row_name_as_full_scope)
    string s_exp = "branch.leaf";

    uut.knobs.full_name = 1;
    uut.m_scope.down("branch");

    uut.print_int("leaf", 0, 0);
    info = uut.get_last_row();

    `FAIL_IF(info.name != s_exp);
  `SVTEST_END(print_int_can_return_row_name_as_full_scope)


  `SVTEST(print_int_can_return_row_name_as_leaf_scope)
    string s_exp = "leaf";

    uut.m_scope.down("branch");

    uut.print_int("leaf", 0, 0);
    info = uut.get_last_row();

    `FAIL_IF(info.name != s_exp);
  `SVTEST_END(print_int_can_return_row_name_as_leaf_scope)


  `SVTEST(print_int_returns_row_level_as_scope_depth)
    uut.m_scope.down("branch0");
    uut.m_scope.down("branch1");

    uut.print_int("leaf", 0, 0);
    info = uut.get_last_row();

    `FAIL_IF(info.level != 2);
  `SVTEST_END(print_int_returns_row_level_as_scope_depth)


  `SVTEST(print_int_returns_row_type_name_if_specified)
    string s_exp = "silly_billy";
    uut.print_int("leaf", 0, 0, UVM_NORADIX, ".", s_exp);
    info = uut.get_last_row();

    `FAIL_IF(info.type_name != s_exp);
  `SVTEST_END(print_int_returns_row_type_name_if_specified)


  `SVTEST(print_int_can_return_row_type_name_as_time)
    string s_exp = "time";
    uut.print_int("leaf", 0, 0, UVM_TIME);
    info = uut.get_last_row();

    `FAIL_IF(info.type_name != s_exp);
  `SVTEST_END(print_int_can_return_row_type_name_as_time)


  `SVTEST(print_int_can_return_row_type_name_as_string)
    string s_exp = "string";
    uut.print_int("leaf", 0, 0, UVM_STRING);
    info = uut.get_last_row();

    `FAIL_IF(info.type_name != s_exp);
  `SVTEST_END(print_int_can_return_row_type_name_as_string)


  `SVTEST(print_int_returns_row_type_name_as_integral_by_default)
    string s_exp = "integral";
    uut.print_int("leaf", 0, 0);
    info = uut.get_last_row();

    `FAIL_IF(info.type_name != s_exp);
  `SVTEST_END(print_int_returns_row_type_name_as_integral_by_default)


  `SVTEST(print_int_returns_row_size_as_string)
    string s_exp = "-1";
    uut.print_int("leaf", 0, -1);
    info = uut.get_last_row();

    `FAIL_IF(info.size != s_exp);
  `SVTEST_END(print_int_returns_row_size_as_string)


  // borrowed these values from the uvm_misc::uvm_vector_to_string test
  `SVTEST(print_int_returns_val_as_uvm_vector_to_string)
    string s_exp = "B11001";
    uut.knobs.bin_radix = "B";
    uut.print_int("leaf", 121, 5, UVM_BIN);
    info = uut.get_last_row();

    `FAIL_IF(info.val != s_exp);
  `SVTEST_END(print_int_returns_val_as_uvm_vector_to_string)


  // borrowed these values from the uvm_misc::uvm_vector_to_string test
  `SVTEST(print_int_uses_default_radix_when_noradix_specified)
    string s_exp = "'o1037";
    uut.knobs.default_radix = UVM_OCT;
    uut.print_int("leaf", 1567, 10);
    info = uut.get_last_row();

    `FAIL_IF(info.val != s_exp);
  `SVTEST_END(print_int_uses_default_radix_when_noradix_specified)


  `SVTEST(print_int_pushes_back_new_rows)
    uvm_printer_row_info first_row, last_row;
    string first_name = "leaf";
    string last_name = "grief";

    uut.print_int(first_name, 1567, 10);
    uut.print_int(last_name, 1567, 10);

    first_row = uut.get_first_row();
    last_row = uut.get_last_row();

    `FAIL_IF(first_row.name != first_name || last_row.name != last_name);
  `SVTEST_END(print_int_pushes_back_new_rows)


  //-----------------------------
  //-----------------------------
  // print_field tests
  //-----------------------------
  //-----------------------------
  `SVTEST(print_field_is_an_alies_for_print_int)
    string my_name = "my_name";
    uut.print_field(my_name, 99, 66);
    `FAIL_UNLESS(uut.print_int_was_called_with(my_name, 99, 66, UVM_NORADIX, _DOT, _NULL_STRING));
  `SVTEST_END()

  //-----------------------------
  //-----------------------------
  // print_object_header tests
  //-----------------------------
  //-----------------------------

  `SVTEST(print_object_header_sets_row_name)
    string obj_name = "name";

    uut.print_object_header(obj_name, test_obj);
    info = uut.get_last_row();

    `FAIL_IF(info.name != obj_name);
  `SVTEST_END(print_object_header_sets_row_name)


  `SVTEST(print_object_header_derives_name_from_value)
    uut.print_object_header("", test_obj);
    info = uut.get_last_row();

    `FAIL_IF(info.name != test_obj.get_name());
  `SVTEST_END(print_object_header_derives_name_from_value)


  `SVTEST(print_object_header_derives_name_from_component)
    uut.print_object_header("", test_comp);
    info = uut.get_last_row();

    `FAIL_IF(info.name != test_comp.get_name());
  `SVTEST_END(print_object_header_derives_name_from_component)


  `SVTEST(print_object_header_name_can_be_unnamed)
    string obj_name = "<unnamed>";
    test_obj = new("");

    uut.print_object_header("", test_obj);
    info = uut.get_last_row();

    `FAIL_IF(info.name != obj_name);
  `SVTEST_END(print_object_header_name_can_be_unnamed)


  `SVTEST(print_object_header_name_override_with_show_root)
    uut.knobs.show_root = 1;
    uut.print_object_header("name", test_obj);
    info = uut.get_last_row();

    `FAIL_IF(info.name != test_obj.get_name());
  `SVTEST_END(print_object_header_name_override_with_show_root)


  `SVTEST(print_object_header_name_from_scope)
    string name_in = "my_name";

    uut.m_scope.down("my_scope");
    uut.print_object_header(name_in, null);
    info = uut.get_last_row();

    `FAIL_IF(info.name != name_in);
  `SVTEST_END(print_object_header_name_from_scope)


  // FAILING TEST - REPORTED
  // uvm_printer.svh:line 138
  // scope_separator can't be specified by user b/c scope_stack can
  // only handle a '.' as separator. info.name in this case is set to
  // "my_scope.my_name" instead of "my_name" as I expect.
// `SVTEST(print_object_header_name_from_scope_with_different_scope_separator)
//   string name_in = "my_name";
//
//   uut.m_scope.down("my_scope");
//   uut.print_object_header(name_in, null, "J");
//   info = uut.get_last_row();
//
//   `FAIL_IF(info.name != name_in);
// `SVTEST_END(print_object_header_name_from_scope_with_different_scope_separator)


  `SVTEST(print_object_header_sets_row_level_to_depth0)
    uut.print_object_header("", null);
    info = uut.get_last_row();

    `FAIL_IF(info.level != 0);
  `SVTEST_END(print_object_header_sets_row_level_to_depth0)


  `SVTEST(print_object_header_sets_row_level_to_depthN)
    uut.m_scope.down("");
    uut.m_scope.down("");
    uut.m_scope.down("");
    uut.print_object_header("", null);
    info = uut.get_last_row();

    `FAIL_IF(info.level != 3);
  `SVTEST_END(print_object_header_sets_row_level_to_depthN)


  `SVTEST(print_object_header_sets_row_val_to_hyphen_without_reference)
    string s_val = "-";

    uut.knobs.reference = 0;
    uut.print_object_header("", null);
    info = uut.get_last_row();

    `FAIL_IF(info.val != s_val);
  `SVTEST_END(print_object_header_sets_row_val_to_hyphen_without_reference)


  `SVTEST(print_object_header_sets_row_val_to_object_value_str_with_reference)
    string s_val = "@99";
    test_uvm_object obj;

    uut.knobs.reference = 1;
    test_uvm_object::set_inst_count(99);
    obj = new("");
    uut.print_object_header("", obj);
    info = uut.get_last_row();

    `FAIL_IF(info.val != s_val);
  `SVTEST_END(print_object_header_sets_row_val_to_object_value_str_with_reference)


  `SVTEST(print_object_header_sets_row_size_to_hyphen)
    string s_size = "-";

    uut.print_object_header("", null);
    info = uut.get_last_row();

    `FAIL_IF(info.size != s_size);
  `SVTEST_END(print_object_header_sets_row_size_to_hyphen)


  `SVTEST(print_object_header_sets_row_type_name_to_object_if_null)
    string s_type_name = "object";

    uut.print_object_header("", null);
    info = uut.get_last_row();

    `FAIL_IF(info.type_name != s_type_name);
  `SVTEST_END(print_object_header_sets_row_type_name_to_object_if_null)


  `SVTEST(print_object_header_sets_row_type_name_to_type_name_otherwise)
    test_uvm_object obj = new("");

    uut.print_object_header("", obj);
    info = uut.get_last_row();

    `FAIL_IF(info.type_name != obj.get_type_name());
  `SVTEST_END(print_object_header_sets_row_type_name_to_type_name_otherwise)


  `SVTEST(print_object_header_pushes_back_new_rows)
    uvm_printer_row_info first_row, last_row;
    string first_name = "leaf";
    string last_name = "grief";

    uut.print_object_header(first_name, null);
    uut.print_object_header(last_name, null);

    first_row = uut.get_first_row();
    last_row = uut.get_last_row();

    `FAIL_IF(first_row.name != first_name || last_row.name != last_name);
  `SVTEST_END(print_object_header_pushes_back_new_rows)

  //-----------------------------
  //-----------------------------
  // print_object tests
  //-----------------------------
  //-----------------------------
  // TBD

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
    string id = "no.change.expected";
    uut.knobs.full_name = 1;
    `FAIL_IF(uut.test_adjust_name(id) != id);
  `SVTEST_END(adjust_name_returns_id_if_full_name_specified)


  `SVTEST(adjust_name_returns_id_if_id_is_dot_dot_dot)
    string id = "...";
    `FAIL_IF(uut.test_adjust_name(id) != id);
  `SVTEST_END(adjust_name_returns_id_if_id_is_dot_dot_dot)


  `SVTEST(adjust_name_returns_id_if_scope_depth_eq_0_and_show_root)
    string id = "id";
    while (uut.m_scope.depth() > 0) uut.m_scope.up();
    uut.knobs.show_root = 1;
    `FAIL_IF(uut.test_adjust_name(id) != id);
  `SVTEST_END(adjust_name_returns_id_if_scope_depth_eq_0_and_show_root)


  `SVTEST(adjust_name_returns_leaf_scope_otherwise)
    string id_in = "no.change.expected";
    string id_out = "expected";
    `FAIL_IF(uut.test_adjust_name(id_in) != id_out);
  `SVTEST_END(adjust_name_returns_leaf_scope_otherwise)

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

endmodule
