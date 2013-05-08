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


  `SVTEST(printer_knobs_at_construction)
    string s_prefix = "";
    string s_separator = "{}";
    string s_dec_radix = "'d";
    string s_bin_radix = "'b";
    string s_oct_radix = "'o";
    string s_unsigned_radix = "'d";
    string s_hex_radix = "'h";

    `FAIL_IF(uut.knobs == null);
    `FAIL_IF(uut.knobs.header != 1);
    `FAIL_IF(uut.knobs.footer != 1);
    `FAIL_IF(uut.knobs.full_name != 0);
    `FAIL_IF(uut.knobs.identifier != 1);
    `FAIL_IF(uut.knobs.type_name != 1);
    `FAIL_IF(uut.knobs.size != 1);
    `FAIL_IF(uut.knobs.depth != -1);
    `FAIL_IF(uut.knobs.reference != 1);
    `FAIL_IF(uut.knobs.begin_elements != 5);
    `FAIL_IF(uut.knobs.end_elements != 5);
    `FAIL_IF(uut.knobs.prefix != s_prefix);
    `FAIL_IF(uut.knobs.indent != 2);
    `FAIL_IF(uut.knobs.show_root != 0);
    `FAIL_IF(uut.knobs.mcd != UVM_STDOUT);
    `FAIL_IF(uut.knobs.separator != s_separator);
    `FAIL_IF(uut.knobs.show_radix != 1);
    `FAIL_IF(uut.knobs.default_radix != UVM_HEX);
    `FAIL_IF(uut.knobs.dec_radix != s_dec_radix);
    `FAIL_IF(uut.knobs.bin_radix != s_bin_radix);
    `FAIL_IF(uut.knobs.oct_radix != s_oct_radix);
    `FAIL_IF(uut.knobs.unsigned_radix != s_unsigned_radix);
    `FAIL_IF(uut.knobs.hex_radix != s_hex_radix);
  `SVTEST_END(printer_knobs_at_construction)


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


  `SVTEST(print_object_header_name_with_scope)
    string obj_name = "scope.name";

    uut.m_scope.down("scope");
    uut.print_object_header("name", test_obj);
    info = uut.get_last_row();
$display("%s", uut.m_scope.get());

    `FAIL_IF(info.name != obj_name);
  `SVTEST_END(print_object_header_name_with_scope)


  `SVUNIT_TESTS_END

endmodule
