`include "svunit_defines.svh"
`include "test_uvm_printer.sv"
`include "test_uvm_object.sv"
`include "test_uvm_component.sv"
`include "test_uvm_agent.sv"

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
  // TBD

  //-----------------------------
  //-----------------------------
  // print_field tests
  //-----------------------------
  //-----------------------------
  // TBD

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
    string obj_name = "name";

    uut.m_scope.down("scope");
    uut.print_object_header("name", test_obj);
    info = uut.get_last_row();

    `FAIL_IF(info.name != obj_name);
  `SVTEST_END(print_object_header_name_from_scope)


  // FAILING TEST
  // uvm_printer.svh:line 138
  // scope_separator can't be specified by user b/c scope_stack can
  // only handle a '.' as separator
// `SVTEST(print_object_header_name_from_scope_with_scope_separator)
//   string obj_name = "scopeJname";
//   string adjusted_name = "name";
//
//   uut.print_object_header("name", test_obj, "J");
//   info = uut.get_last_row();
//
//   `FAIL_IF(info.name != obj_name);
// `SVTEST_END(print_object_header_name_from_scope_with_scope_separator)

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
