`include "svunit_defines.svh"
`include "test_uvm_object.sv"
`include "test_defines.sv"

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
  // setname tests
  //-----------------------------
  //-----------------------------

  `SVTEST(override_with_setname)
    string n = "other_name";
    uut.set_name(n);
    `FAIL_IF(uut.get_name() != n); 
  `SVTEST_END(override_with_setname)


  //-----------------------------
  //-----------------------------
  // getname tests
  //-----------------------------
  //-----------------------------

  `SVTEST(getname_set_by_constructor)
    string n = "object_name";
    `FAIL_IF(uut.get_name() != n); 
  `SVTEST_END(getname_set_by_constructor)


  //-----------------------------
  //-----------------------------
  // get full name tests
  //-----------------------------
  //-----------------------------

  `SVTEST(get_full_name_returns_get_name)
    `FAIL_IF(uut.get_name() != uut.get_full_name()); 
  `SVTEST_END(get_full_name_returns_get_name)

  //-----------------------------
  //-----------------------------
  // get inst id tests
  //-----------------------------
  //-----------------------------

  // relies on get_inst_count()
  `SVTEST(inst_id_initialized_to_inst_count)
    test_uvm_object other;
    int current_inst_count = uut.get_inst_count();

    other = new("");

    `FAIL_IF(other.get_inst_id() != current_inst_count);
  `SVTEST_END(inst_id_initialized_to_inst_count)

  //-----------------------------
  //-----------------------------
  // get inst count tests
  //-----------------------------
  //-----------------------------

  `SVTEST(inst_count_incremented_in_constructer)
    test_uvm_object other;
    uut.set_inst_count(99);

    other = new("");

    `FAIL_IF(other.get_inst_count() != 100);
  `SVTEST_END(inst_count_incremented_in_constructer)

  //-----------------------------
  //-----------------------------
  // get type tests
  //-----------------------------
  //-----------------------------

// Can't do anything here unless the UVM_ERROR
// macro is used instead of the uvm_report_error
// `SVTEST(get_type_is_an_error)
// `SVTEST_END(get_type_is_an_error)

  //-----------------------------
  //-----------------------------
  // get object type tests
  //-----------------------------
  //-----------------------------

  `SVTEST(get_object_type_returns_null)
    `FAIL_IF(uut.get_object_type() != null); 
  `SVTEST_END(get_object_type_returns_null)

  // relies on correct implementation of factory (not verified as of here/now)
  `SVTEST(get_object_type_returns_type)
    uut.fake_test_type_name = 1;
    `FAIL_IF(uut.get_object_type() != uut_wrapper); 
  `SVTEST_END(get_object_type_returns_type)

  //-----------------------------
  //-----------------------------
  // get type name tests
  //-----------------------------
  //-----------------------------

  `SVTEST(get_type_name_returns_unknown)
    string type_name = "<unknown>";
    `FAIL_IF(uut.get_type_name() != type_name); 
  `SVTEST_END(get_type_name_returns_unknown)

  //-----------------------------
  //-----------------------------
  // create tests
  //-----------------------------
  //-----------------------------

  `SVTEST(create_returns_null)
    `FAIL_IF(uut.create() != null);
  `SVTEST_END(create_returns_null)

  //-----------------------------
  //-----------------------------
  // clone tests
  //-----------------------------
  //-----------------------------

  `SVTEST(clone_returns_null)
    `FAIL_IF(uut.clone() != null);
  `SVTEST_END(clone_returns_null)

  // relies on the copy
  //`SVTEST(clone_returns_null)
  //  `FAIL_IF(uut.clone() != null);
  //`SVTEST_END(clone_returns_null)

  //-----------------------------
  //-----------------------------
  // print tests
  //-----------------------------
  //-----------------------------
  // TBD based on sprint

  //-----------------------------
  //-----------------------------
  // sprint tests
  //-----------------------------
  //-----------------------------
  // TBD based on uvm_printer

  //-----------------------------
  //-----------------------------
  // do_print tests
  //-----------------------------
  //-----------------------------
  `SVTEST(do_print_is_empty)
    uvm_printer p;
    uut.do_print(p);
    `FAIL_IF(0);
  `SVTEST_END(do_print_is_empty)

  //-----------------------------
  //-----------------------------
  // convert2string tests
  //-----------------------------
  //-----------------------------
  `SVTEST(convert2string_returns_empty_string)
    `FAIL_IF(uut.convert2string() != _NULL_STRING);
  `SVTEST_END(convert2string_returns_empty_string)

  //-----------------------------
  //-----------------------------
  // record tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // do_record tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // copy tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // do_copy tests
  //-----------------------------
  //-----------------------------
  `SVTEST(do_copy_is_empty)
    test_uvm_object o;
    uut.do_copy(o);
    `FAIL_IF(0);
  `SVTEST_END(do_copy_is_empty)

  //-----------------------------
  //-----------------------------
  // compare tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // do_compare tests
  //-----------------------------
  //-----------------------------
  `SVTEST(do_compare_returns_true)
    `FAIL_IF(uut.do_compare(null, null) != 1);
  `SVTEST_END(do_compare_returns_true)

  //-----------------------------
  //-----------------------------
  // pack tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // pack_bytes tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // pack_ints tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // do_pack tests
  //-----------------------------
  //-----------------------------
  `SVTEST(do_pack_is_empty)
    uvm_packer p;
    uut.do_pack(p);
    `FAIL_IF(0);
  `SVTEST_END(do_pack_is_empty)

  //-----------------------------
  //-----------------------------
  // unpack tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // unpack_bytes tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // unpack_ints tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // do_unpack tests
  //-----------------------------
  //-----------------------------
  `SVTEST(do_unpack_is_empty)
    uvm_packer p;
    uut.do_unpack(p);
    `FAIL_IF(0);
  `SVTEST_END(do_unpack_is_empty)

  //-----------------------------
  //-----------------------------
  // set_int_local tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // set_string_local tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // set_object_local tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-------------------------------
  //-------------------------------
  // __m_uvm_field_automation tests
  //-------------------------------
  //-------------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // m_get_report_object tests
  //-----------------------------
  //-----------------------------
  `SVTEST(get_report_object_returns_null)
    `FAIL_IF(uut.test_get_report_object() != null);
  `SVTEST_END(get_report_object_returns_null)

  `SVUNIT_TESTS_END

endmodule
