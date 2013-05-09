`include "svunit_defines.svh"
`include "test_defines.sv"

import svunit_pkg::*;
import uvm_pkg::*;

`define GET_RADIX_TEST(RADIX,OUTPUT) \
`SVTEST(get_``RADIX``_radix) \
  `FAIL_IF(uut.get_radix_str(RADIX) != OUTPUT); \
`SVTEST_END(get_``RADIX``_radix)

module uvm_printer_knobs_unit_test;

  string name = "uvm_printer_knobs_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  uvm_printer_knobs uut;


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


  `SVTEST(defaults_at_construction)
    string s_prefix = "";
    string s_separator = "{}";
    string s_dec_radix = "'d";
    string s_bin_radix = "'b";
    string s_oct_radix = "'o";
    string s_unsigned_radix = "'d";
    string s_hex_radix = "'h";

    `FAIL_IF(uut.header != 1);
    `FAIL_IF(uut.footer != 1);
    `FAIL_IF(uut.full_name != 0);
    `FAIL_IF(uut.identifier != 1);
    `FAIL_IF(uut.type_name != 1);
    `FAIL_IF(uut.size != 1);
    `FAIL_IF(uut.depth != -1);
    `FAIL_IF(uut.reference != 1);
    `FAIL_IF(uut.begin_elements != 5);
    `FAIL_IF(uut.end_elements != 5);
    `FAIL_IF(uut.prefix != s_prefix);
    `FAIL_IF(uut.indent != 2);
    `FAIL_IF(uut.show_root != 0);
    `FAIL_IF(uut.mcd != UVM_STDOUT);
    `FAIL_IF(uut.separator != s_separator);
    `FAIL_IF(uut.show_radix != 1);
    `FAIL_IF(uut.default_radix != UVM_HEX);
    `FAIL_IF(uut.dec_radix != s_dec_radix);
    `FAIL_IF(uut.bin_radix != s_bin_radix);
    `FAIL_IF(uut.oct_radix != s_oct_radix);
    `FAIL_IF(uut.unsigned_radix != s_unsigned_radix);
    `FAIL_IF(uut.hex_radix != s_hex_radix);
  `SVTEST_END(defaults_at_construction)


  `SVTEST(deprecated_defaults)
    string s_trunc = "+";

    `FAIL_IF(uut.max_width != 999);
    `FAIL_IF(uut.truncation != s_trunc);
    `FAIL_IF(uut.name_width != -1);
    `FAIL_IF(uut.type_width != -1);
    `FAIL_IF(uut.size_width != -1);
    `FAIL_IF(uut.value_width != -1);
    `FAIL_IF(uut.sprint != 1);
  `SVTEST_END(deprecated_defaults)


  `GET_RADIX_TEST(UVM_BIN,uut.bin_radix)
  `GET_RADIX_TEST(UVM_OCT,uut.oct_radix)
  `GET_RADIX_TEST(UVM_DEC,uut.dec_radix)
  `GET_RADIX_TEST(UVM_HEX,uut.hex_radix)
  `GET_RADIX_TEST(UVM_UNSIGNED,uut.unsigned_radix)
  `GET_RADIX_TEST(UVM_NORADIX,uut.default_radix)

  `GET_RADIX_TEST(UVM_UNFORMAT2,_NULL_STRING);
  `GET_RADIX_TEST(UVM_UNFORMAT4,_NULL_STRING);
  `GET_RADIX_TEST(UVM_STRING,_NULL_STRING);
  `GET_RADIX_TEST(UVM_TIME,_NULL_STRING);
  `GET_RADIX_TEST(UVM_ENUM,_NULL_STRING);
  `GET_RADIX_TEST(UVM_REAL,_NULL_STRING);
  `GET_RADIX_TEST(UVM_REAL_DEC ,_NULL_STRING);


  `SVTEST(dont_show_radix)
    uut.show_radix = 0;
    `FAIL_IF(uut.get_radix_str(UVM_HEX) != _NULL_STRING);
  `SVTEST_END(dont_show_radix)


  `SVTEST(undefined_enum_returns_null_string)
    int invalid_enum = 99;
    `FAIL_IF(uut.get_radix_str(uvm_radix_enum'(invalid_enum)) != _NULL_STRING);
  `SVTEST_END(undefined_enum_returns_null_string)


  `SVTEST(table_printer_knob_typedefed_to_printer_knob)
    uvm_table_printer_knobs tdef;
    `FAIL_IF($cast(tdef, uut) != 1);
  `SVTEST_END(table_printer_knob_typedefed_to_printer_knob)


  `SVTEST(tree_printer_knob_typedefed_to_printer_knob)
    uvm_tree_printer_knobs tdef;
    `FAIL_IF($cast(tdef, uut) != 1);
  `SVTEST_END(tree_printer_knob_typedefed_to_printer_knob)


  `SVUNIT_TESTS_END

endmodule
