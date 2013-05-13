`include "svunit_defines.svh"
`include "test_uvm_object.sv"
`include "mock_uvm_printer.sv"
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
  mock_uvm_printer mock_printer;


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

    mock_printer = new();
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

  // we can't automate checking of stdout so we're
  // changing the destination to somewhere else via
  // mcd
  `SVTEST(print_destination_is_knobs_mcd)
    string s_act = print_test_simple_sprint_emit(uut, mock_printer);
    `FAIL_IF(s_act != mock_printer.emit());
  `SVTEST_END(print_destination_is_knobs_mcd)


  `SVTEST(print_assign_default_printer_if_null)
    string s_act;

    uvm_default_printer = mock_printer;
    s_act = print_test_simple_sprint_emit(uut, null);

    `FAIL_IF(s_act != mock_printer.emit());
  `SVTEST_END(print_assign_default_printer_if_null)


  // can't check the null printer error b/c the fwrite
  // is called regardless of null (i.e. we can check the message
  // but we die with a null object access right after)
  // `SVTEST(print_with_default_null_printer_is_error)
  // `SVTEST_END(print_with_default_null_printer_is_error)

  //-----------------------------
  //-----------------------------
  // sprint tests
  //-----------------------------
  //-----------------------------

  // s_exp is faked in mock_printer.print_object(...)
  `SVTEST(sprint_returns_m_string)
    string s_exp = { uut.get_name() , "::" , uut.get_inst_id };;
    mock_printer.set_istop(1);
    `FAIL_IF(uut.sprint(mock_printer) != s_exp);
  `SVTEST_END(sprint_returns_m_string)


  `SVTEST(sprint_uses_default_scope_separator)
    string _DOT = ".";
    mock_printer.set_istop(1);
    void'(uut.sprint(mock_printer));
    `FAIL_IF(mock_printer.get_scope_separator() != _DOT);
  `SVTEST_END(sprint_uses_default_scope_separator)


  `SVTEST(sprint_returns_emit_if_printer_returns_empty_string)
    mock_printer.set_istop(1);
    mock_printer.override_m_string(1);
    mock_printer.set_m_string("");
    `FAIL_IF(uut.sprint(mock_printer) != mock_printer.emit());
  `SVTEST_END(sprint_returns_emit_if_printer_returns_empty_string)


  `SVTEST(sprint_assigns_the_status_container_printer)
    mock_printer.set_istop(0);
    uut.__m_uvm_status_container.printer = null;
    void'(uut.sprint(mock_printer));
    `FAIL_IF(!$cast(mock_printer, uut.__m_uvm_status_container.printer) ||
             uut.__m_uvm_status_container.printer == null);
  `SVTEST_END(sprint_assigns_the_status_container_printer)


  `SVTEST(sprint_calls_field_automation)
    mock_printer.set_istop(0);
    uut.fake_field_automation = 1;
    void'(uut.sprint(mock_printer));
    `FAIL_IF(uut.tmp_data__ != null);
    `FAIL_IF(uut.what__ != UVM_PRINT);
    `FAIL_IF(uut.str__ != _NULL_STRING);
  `SVTEST_END(sprint_calls_field_automation)


  `SVTEST(sprint_invokes_do_print_when_not_top)
    mock_printer.set_istop(0);
    uut.fake_field_automation = 1;
    void'(uut.sprint(mock_printer));
    `FAIL_IF(!$cast(mock_printer, uut.do_print_printer) ||
             uut.do_print_printer == null);
  `SVTEST_END(sprint_invokes_do_print_when_not_top)


  `SVTEST(sprint_returns_null_string_when_not_top)
    mock_printer.set_istop(0);
    uut.fake_field_automation = 1;
    `FAIL_IF(uut.sprint(mock_printer) != _NULL_STRING);
  `SVTEST_END(sprint_returns_null_string_when_not_top)


  `SVTEST(sprint_assigns_default_printer_if_null)
    mock_printer.set_istop(0);
    uvm_default_printer = mock_printer;
    void'(uut.sprint());
    `FAIL_IF(!$cast(mock_printer, uut.__m_uvm_status_container.printer) ||
             uut.__m_uvm_status_container.printer == null);
  `SVTEST_END(sprint_assigns_default_printer_if_null)

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

  `SVTEST(__m_uvm_field_automation_is_empty)
    const test_uvm_object tmp_data__ = new("");
    const int what__ = 99;
    const string str__ = "66";
    uut.__m_uvm_field_automation(tmp_data__, what__, str__);
    `FAIL_IF(0);
  `SVTEST_END(__m_uvm_field_automation_is_empty)

  //-----------------------------
  //-----------------------------
  // m_get_report_object tests
  //-----------------------------
  //-----------------------------
  `SVTEST(get_report_object_returns_null)
    `FAIL_IF(uut.test_get_report_object() != null);
  `SVTEST_END(get_report_object_returns_null)

  `SVUNIT_TESTS_END



  function automatic string print_test_simple_sprint_emit(uvm_object my_uut,
                                                          uvm_printer p);
    int PRINT_FILE = $fopen("/tmp/.uvm_object.print", "w+");
    string s_act;

    mock_printer.knobs.mcd = PRINT_FILE;
    mock_printer.set_istop(1);
    mock_printer.override_m_string(1);
    mock_printer.set_m_string("");

    my_uut.print(p);
    void'($rewind(PRINT_FILE));
    void'($fscanf(PRINT_FILE, "%s\n", print_test_simple_sprint_emit));
    void'($fclose(PRINT_FILE));
  endfunction

endmodule
