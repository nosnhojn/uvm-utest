`include "svunit_defines.svh"
`include "test_uvm_object.sv"

import uvm_pkg::*;
import svunit_pkg::*;

module uvm_object_unit_test;

  string name = "uvm_object_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  test_uvm_object uut;
  test_uvm_object_wrapper uut_wrapper;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    uut_wrapper = new();
    factory.register(uut_wrapper);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();

    uut = new("object_name");
    uut.use_uvm_seeding = 1;

    uut.fake_test_type_name = 0;
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
  // constructor related tests
  //-----------------------------
  //-----------------------------
  `SVTEST(inst_cnt_is_static)
    test_uvm_object other;
    int new_test_objs = 50;
    int current_inst_count = uut.get_inst_count();

    repeat (new_test_objs) other = new("");

    `FAIL_IF(uut.get_inst_count() != current_inst_count + new_test_objs);
  `SVTEST_END(inst_cnt_is_static)


  `SVTEST(get_inst_id)
    test_uvm_object other;
    int current_inst_count = uut.get_inst_count();

    other = new("");

    `FAIL_IF(other.get_inst_id() != current_inst_count);
  `SVTEST_END(get_inst_id)


  `SVTEST(getname_set_by_constructor)
    string n = "object_name";
    `FAIL_IF(uut.get_name() != n); 
  `SVTEST_END(getname_set_by_constructor)


  `SVTEST(override_with_setname)
    string n = "other_name";
    uut.set_name(n);
    `FAIL_IF(uut.get_name() != n); 
  `SVTEST_END(override_with_setname)


  `SVTEST(get_full_name_returns_get_name)
    `FAIL_IF(uut.get_name() != uut.get_full_name()); 
  `SVTEST_END(get_full_name_returns_get_name)


  `SVTEST(get_type_name_returns_unknown)
    string type_name = "<unknown>";
    `FAIL_IF(uut.get_type_name() != type_name); 
  `SVTEST_END(get_type_name_returns_unknown)


  `SVTEST(fake_get_type_name_returns_name)
    string type_name = "test_uvm_object";
    uut.fake_test_type_name = 1;
    `FAIL_IF(uut.get_type_name() != type_name); 
  `SVTEST_END(fake_get_type_name_returns_name)


  `SVTEST(get_object_type_returns_null)
    `FAIL_IF(uut.get_object_type() != null); 
  `SVTEST_END(get_object_type_returns_null)


  `SVTEST(get_object_type_returns_type)
    uut.fake_test_type_name = 1;
    `FAIL_IF(uut.get_object_type() != uut_wrapper); 
  `SVTEST_END(get_object_type_returns_type)


// Can't do anything here unless the UVM_ERROR
// macro is used instead of the uvm_report_error
// `SVTEST(get_type_is_an_error)
// `SVTEST_END(get_type_is_an_error)

  `SVTEST(create_returns_null)
    `FAIL_IF(uut.create() != null);
  `SVTEST_END(create_returns_null)


  //-----------------------------
  //-----------------------------
  // reseed tests
  //-----------------------------
  //-----------------------------
  `SVTEST(enabled_obj_is_reseeded)
    test_uvm_object other = new("other");

    uut.srandom(0);
    other.srandom(0);
    uut.reseed();
    void'(uut.randomize());
    void'(other.randomize());

    `FAIL_IF(uut.rand_property == other.rand_property);
  `SVTEST_END(enabled_obj_is_reseeded)


  `SVTEST(disabled_obj_is_not_reseeded)
    test_uvm_object other = new("other");

    uut.srandom(0);
    other.srandom(0);
    uut.use_uvm_seeding = 0;
    uut.reseed();
    void'(uut.randomize());
    void'(other.randomize());

    `FAIL_IF(uut.rand_property != other.rand_property);
  `SVTEST_END(disabled_obj_is_not_reseeded)


  //-----------------------------
  //-----------------------------
  // sprint tests
  //-----------------------------
  //-----------------------------
  // TBD based on uvm_printer

  `SVUNIT_TESTS_END

endmodule
