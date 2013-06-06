`include "svunit_defines.svh"
`include "test_defines.sv"
`include "test_uvm_object.sv"
`include "mock_uvm_printer.sv"
`include "mock_uvm_packer.svh"
`include "mock_uvm_comparer.svh"

import uvm_pkg::*;
import svunit_pkg::*;
import svunit_uvm_mock_pkg::*;

module uvm_object_unit_test;

  string name = "uvm_object_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  test_uvm_object   uut;
  test_uvm_object_wrapper uut_wrapper;

  mock_uvm_printer  mock_printer;
  mock_uvm_comparer comparer;
  mock_uvm_packer   packer;

  bit  unsigned     bitstream[];
  byte unsigned     bytestream[];
  int  unsigned     intstream[];
  uvm_bitstream_t   uvm_bitstream;
  test_uvm_object   dummy_object;
  string            dummy_str;

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

    mock_printer = new;
    comparer = new;
    packer = new;

    dummy_object = new("dummy");
    dummy_str = "dummy";

    uvm_report_mock::setup();
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    bitstream.delete();
    uvm_bitstream = '{default:'0};
    dummy_object = null;
    dummy_str = "";
    while (uvm_object::__m_uvm_status_container.scope.depth() > 0)
      void'(uvm_object::__m_uvm_status_container.scope.up());
    uvm_default_comparer.check_type = 0;
    uvm_default_comparer.compare_map.clear();
    uvm_default_comparer.result = 0;
    uvm_default_comparer.miscompares = "";
    uvm_default_comparer.scope = null;
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

  // FAILING TEST: BUT ONLY ON IUS. get_inst_id is way out to lunch.
  // relies on get_inst_count()
  // We have seen this test failing using IUS 12.1
  // with the installed uvm-1.1 and a local version
  // of uvm-1.1d
// `SVTEST(inst_id_initialized_to_inst_count)
//   test_uvm_object other;
//   int current_inst_count = uut.get_inst_count();
//
//   other = new("");
//
//   `FAIL_IF(other.get_inst_id() != current_inst_count);
// `SVTEST_END(inst_id_initialized_to_inst_count)

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


  `SVTEST(clone_asserts_warning_for_null_object)
    uvm_report_mock::expect_warning("CRFLD",
                                    { "The create method failed for " , uut.get_name() , ",  object cannot be cloned" }
                                   );
    void'(uut.clone());
 
    `FAIL_IF(!uvm_report_mock::verify_complete());
  `SVTEST_END(clone_asserts_warning_for_null_object)


  `SVTEST(clone_is_created_with_get_name)
    void'(uut.clone());
    `FAIL_IF(uut.create_name != uut.get_name());
  `SVTEST_END(clone_is_created_with_get_name)


  // copy isn't virtual so we're going to need to find a
  // different way here
  `SVTEST(clone_returns_a_new_copy)
    test_uvm_object o;
    uut.fake_create = 1;
    $cast(o, uut.clone());
    `FAIL_IF(o.get_name() != uut.fake_create_name())
    `FAIL_IF(o.do_copy_copy == null)
  `SVTEST_END(clone_returns_a_new_copy)


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
    string s_exp = { uut.get_name() , "::" , uut.get_inst_id };
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
    `FAIL_IF(!$cast(mock_printer, uut.__m_uvm_status_container.printer));
    `FAIL_IF(uut.__m_uvm_status_container.printer == null);
  `SVTEST_END(sprint_assigns_the_status_container_printer)


  `SVTEST(sprint_calls_field_automation)
    mock_printer.set_istop(0);
    void'(uut.sprint(mock_printer));
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(null, UVM_PRINT, _NULL_STRING));
  `SVTEST_END(sprint_calls_field_automation)


  `SVTEST(sprint_invokes_do_print_when_not_top)
    mock_printer.set_istop(0);
    void'(uut.sprint(mock_printer));
    `FAIL_IF(!$cast(mock_printer, uut.do_print_printer));
    `FAIL_IF(uut.do_print_printer == null);
  `SVTEST_END(sprint_invokes_do_print_when_not_top)


  `SVTEST(sprint_returns_null_string_when_not_top)
    mock_printer.set_istop(0);
    `FAIL_IF(uut.sprint(mock_printer) != _NULL_STRING);
  `SVTEST_END(sprint_returns_null_string_when_not_top)


  `SVTEST(sprint_assigns_default_printer_if_null)
    mock_printer.set_istop(0);
    uvm_default_printer = mock_printer;
    void'(uut.sprint());
    `FAIL_IF(!$cast(mock_printer, uut.__m_uvm_status_container.printer));
    `FAIL_IF(uut.__m_uvm_status_container.printer == null);
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
  `SVTEST(record_default_recorder_tr_handle_null)
    uvm_default_recorder.tr_handle = 0;
    uut.record();
    `FAIL_IF(uut.__m_uvm_status_container.recorder != null)
  `SVTEST_END(record_default_recorder_tr_handle_null)

  `SVTEST(record_recorder_tr_handle_null)
    uvm_recorder dummy_rec = new("rec");
    dummy_rec.tr_handle = 0;
    uut.record(dummy_rec);
    `FAIL_IF(uut.__m_uvm_status_container.recorder != null)
  `SVTEST_END(record_recorder_tr_handle_null)

  `SVTEST(record_recorder_tr_handle_not_null)
    uvm_recorder dummy_rec = new("rec");
    dummy_rec.tr_handle = 1;
    uut.record(dummy_rec);
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(null, UVM_RECORD, _NULL_STRING));
    `FAIL_IF(dummy_rec.tr_handle != 0);
  `SVTEST_END(record_recorder_tr_handle_not_null)

  `SVTEST(record_recorder_recording_depth_not_null)
    uvm_recorder dummy_rec = new("rec");
    dummy_rec.tr_handle = 1;
    dummy_rec.recording_depth++;
    uut.record(dummy_rec);
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(null, UVM_RECORD, _NULL_STRING));
    `FAIL_IF(dummy_rec.tr_handle != 1);
  `SVTEST_END(record_recorder_recording_depth_not_null)

  //-----------------------------
  //-----------------------------
  // do_record tests
  //-----------------------------
  //-----------------------------
  `SVTEST(do_record_is_empty)
    uvm_recorder dummy_rec = new("rec");
    uut.do_record(dummy_rec);
    `FAIL_IF(0)
  `SVTEST_END(do_record_is_empty)

  //-----------------------------
  //-----------------------------
  // copy tests
  //-----------------------------
  //-----------------------------
  `SVTEST(copy_rhs_null)
    uvm_object rhs=null;
    uvm_report_mock::expect_warning("NULLCP", "A null object was supplied to copy; copy is ignored");
    void'(uut.copy(rhs));
    `FAIL_IF(!uvm_report_mock::verify_complete());
  `SVTEST_END(copy_rhs_null)
  
  
  // WARNING
  // We decided to skip the cycle checking code as
  // this seems to refer to the time when functions
  // could consume time. Therefore we didn't test
  // the uvm_global_copy_map.

  `SVTEST(copy_rhs_not_null_field_automation)
    string s_exp = "name";
    test_uvm_object rhs=new("name");
    void'(uut.copy(rhs));
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(rhs, UVM_COPY, _NULL_STRING));
  `SVTEST_END(copy_rhs_not_null_field_automation)


  `SVTEST(copy_rhs_not_null_do_copy)
    uvm_callback rhs=new("name");
    void'(uut.copy(rhs));
    `FAIL_IF(!$cast(rhs, uut.do_copy_copy));
    `FAIL_IF(uut.do_copy_copy == null);
  `SVTEST_END(copy_rhs_not_null_do_copy)
  

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
  `SVTEST(compare_status_container_set_with_default_comparer)
    void'(uut.compare(dummy_object, null));

    `FAIL_IF(uut.__m_uvm_status_container.comparer != uvm_default_comparer)
  `SVTEST_END()


  `SVTEST(compare_status_container_set_with_custom_comparer)
    void'(uut.compare(dummy_object, comparer));

    `FAIL_IF(uut.__m_uvm_status_container.comparer != comparer)
  `SVTEST_END()


  `SVTEST(compare_calls_comparer_print_msg_object_when_rhs_eq_null)
    void'(uut.compare(null, null));

    `FAIL_UNLESS(uut.comparer_print_msg_object_was_called());
  `SVTEST_END()


  `SVTEST(compare_doesnt_call_comparer_print_msg_object_when_rhs_ne_null)
    void'(uut.compare(dummy_object, null));

    `FAIL_IF(uut.comparer_print_msg_object_was_called());
  `SVTEST_END()


  `SVTEST(compare_resets_comparer_state_when_empty_scope_stack)
    uut.latch_temp_comparer_state = 1;

    void'(uut.compare(null, null));

    `FAIL_UNLESS(uut.temp_comparer_state_latched_as(1, _NULL_STRING, uut.__m_uvm_status_container.scope, 0));
  `SVTEST_END()


  `SVTEST(compare_pushes_obj_name_to_scope_stack_when_empty_scope_stack)
    uut.latch_temp_scope_stack_get = 1;

    void'(uut.compare(null, null));

    `FAIL_UNLESS_STR_EQUAL(uut.latched_scope_stack_get, uut.get_name())
  `SVTEST_END()


  `SVTEST(compare_pushes_object_to_scope_stack_when_empty_scope_stack)
    uut.latch_temp_scope_stack_get = 1;
    uut.set_name("");

    void'(uut.compare(null, null));

    `FAIL_UNLESS_STR_EQUAL(uut.latched_scope_stack_get, "<object>")
  `SVTEST_END()


  `SVTEST(compare_doesnt_reset_comparer_state_when_scope_stack_not_empty)
    string miscompares = "bogus";
    uut.latch_temp_comparer_state = 1;
    uut.__m_uvm_status_container.scope.down("not empty");
    uvm_default_comparer.show_max = 2;
    uvm_default_comparer.result = 1;
    uvm_default_comparer.miscompares = miscompares;
    uvm_default_comparer.scope = null;
    uvm_default_comparer.compare_map.set(uut, uut);

    void'(uut.compare(null, null));

    `FAIL_UNLESS(uut.temp_comparer_state_latched_as(2, miscompares, null, 1));
  `SVTEST_END()


  `SVTEST(compare_leaves_scope_stack_alone_when_scope_stack_not_empty)
    uut.latch_temp_scope_stack_get = 1;
    uut.__m_uvm_status_container.scope.down("not empty");

    void'(uut.compare(null, null));

    `FAIL_UNLESS_STR_EQUAL(uut.latched_scope_stack_get, "not empty")
  `SVTEST_END()


  `SVTEST(compare_returns_false_for_true_cycle_check)
    inject_compare_map_cycle_check_failure();

    `FAIL_IF(uut.compare(dummy_object, null));
  `SVTEST_END()


  `SVTEST(compare_calls_print_msg_object_for_cycle_check_when_rhs_is_this)
    inject_compare_map_cycle_check_failure();

    void'(uut.compare(dummy_object, null));

    `FAIL_IF(uut.comparer_print_msg_object_was_called());
  `SVTEST_END()


  `SVTEST(compare_doesnt_call_print_msg_object_for_cycle_check_when_rhs_is_not_this)
    inject_compare_map_cycle_check_failure(dummy_object);

    void'(uut.compare(dummy_object, null));

    `FAIL_UNLESS(uut.comparer_print_msg_object_was_called());
  `SVTEST_END()


  `SVTEST(compare_checks_type_when_configured_to_check_type)
    uvm_default_comparer.check_type = 1;
    dummy_object.fake_test_type_name = 1;

    void'(uut.compare(dummy_object, null));

    `FAIL_UNLESS_STR_EQUAL(uvm_default_comparer.miscompares, comparer_print_msg(uut, dummy_object));
  `SVTEST_END()


  `SVTEST(compare_doesnt_check_type_when_cycle_check)
    inject_compare_map_cycle_check_failure();
    cause_type_mismatch_with_dummy();

    void'(uut.compare(dummy_object, null));

    `FAIL_UNLESS_STR_EQUAL(uvm_default_comparer.miscompares, _NULL_STRING);
  `SVTEST_END()


  `SVTEST(compare_calls_field_automation)
    void'(uut.compare(dummy_object, null));
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(dummy_object, UVM_COMPARE, _NULL_STRING));
  `SVTEST_END()


  `SVTEST(compare_doesnt_call_field_automation_when_cycle_check)
    inject_compare_map_cycle_check_failure();

    void'(uut.compare(dummy_object, null));

    `FAIL_IF(uut.__m_uvm_field_automation_called);
  `SVTEST_END()


  `SVTEST(compare_calls_do_compare)
    void'(uut.compare(dummy_object, comparer));

    `FAIL_UNLESS(uut.do_compare_was_called_with(dummy_object, comparer));
  `SVTEST_END()


  `SVTEST(compare_doesnt_call_do_compare_when_cycle_check)
    inject_compare_map_cycle_check_failure();

    void'(uut.compare(dummy_object, null));

    `FAIL_IF(uut.do_compare_called);
  `SVTEST_END()


  `SVTEST(compare_adds_rhs_to_compare_map)
    uvm_default_comparer.compare_map.clear();

    void'(uut.compare(dummy_object, null));

    `FAIL_IF(uvm_default_comparer.compare_map.get(dummy_object) == null);
  `SVTEST_END()


  `SVTEST(compare_doesnt_add_rhs_to_compare_map_when_cycle_check)
    inject_compare_map_cycle_check_failure();

    void'(uut.compare(dummy_object, null));

    `FAIL_IF(uvm_default_comparer.compare_map.get(dummy_object) == null);
  `SVTEST_END()


  `SVTEST(compare_exits_with_no_change_to_scope)
    void'(uut.compare(dummy_object, null));

    `FAIL_IF(uut.__m_uvm_status_container.scope.depth() != 0);
  `SVTEST_END()


  `SVTEST(compare_cleans_up_scope_stack_with_depth_1)
    uut.__m_uvm_status_container.scope.down("not empty");

    void'(uut.compare(dummy_object, null));

    `FAIL_IF(uut.__m_uvm_status_container.scope.depth() != 0);
  `SVTEST_END()


  `SVTEST(compare_ignores_scope_stack_with_depth_ge_2)
    uut.__m_uvm_status_container.scope.down("not empty");
    uut.__m_uvm_status_container.scope.down("really not empty");

    void'(uut.compare(dummy_object, null));

    `FAIL_IF(uut.__m_uvm_status_container.scope.depth() != 2);
  `SVTEST_END()


  `SVTEST(compare_calls_print_rollup_when_rhs_ne_null)
    uvm_default_comparer.sev = UVM_WARNING;
    cause_type_mismatch_with_dummy();

    void'(uut.compare(dummy_object, null));

    `FAIL_UNLESS(print_rollup_called());
  `SVTEST_END()


  `SVTEST(compare_doesnt_call_print_rollup_when_rhs_eq_null)
    uvm_default_comparer.sev = UVM_WARNING;
    cause_type_mismatch_with_dummy();

    void'(uut.compare(null, null));

    `FAIL_IF(print_rollup_called());
  `SVTEST_END()


  `SVTEST(compare_returns_true_for_match)
    `FAIL_UNLESS(uut.compare(dummy_object, null));
  `SVTEST_END()


  `SVTEST(compare_returns_false_for_null)
    `FAIL_IF(uut.compare(null, null));
  `SVTEST_END()


  `SVTEST(compare_returns_do_compare)
    uut.fake_do_compare = 1;
    `FAIL_IF(uut.compare(dummy_object, null));
  `SVTEST_END()


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

  `SVTEST(m_pack_use_default_packer)
    void'(uut.pack(bitstream, null));
    `FAIL_IF(uut.__m_uvm_status_container.packer != uvm_default_packer);
  `SVTEST_END(m_pack_use_default_packer)


  `SVTEST(m_pack_custom_packer)
    void'(uut.pack(bitstream, packer));
    `FAIL_IF(uut.__m_uvm_status_container.packer != packer)
  `SVTEST_END(m_pack_custom_packer)


  `SVTEST(m_pack_packer_is_initialized)
    void'(uut.pack(bitstream, null));
    `FAIL_IF(uvm_default_packer.count != 0);
    `FAIL_IF(uvm_default_packer.m_bits != 0);
    `FAIL_IF(uvm_default_packer.m_packed_size != 0);
  `SVTEST_END(m_pack_packer_is_initialized)


  `SVTEST(m_pack_field_automation)
    void'(uut.pack(bitstream, null));
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(null, UVM_PACK, _NULL_STRING));
  `SVTEST_END(m_pack_field_automation)


  `SVTEST(m_pack_do_pack)
    uvm_default_packer = packer;
    void'(uut.pack(bitstream, null));
    `FAIL_IF(packer != uut.do_pack_pack)
  `SVTEST_END(m_pack_do_pack)


  `SVTEST(m_pack_packer_scope)
    string myscope = "whatever";
    packer.scope.down(myscope);
    void'(uut.pack(bitstream, packer));
    `FAIL_IF(packer.scope.get() != myscope);
  `SVTEST_END(m_pack_packer_scope)


  // NOTE we are not interesting into testing the uvm_packer
  // functionality. So we won't be trying to send in a non-
  // empty bit stream
  `SVTEST(pack_bitstream)
    int rval = uut.pack(bitstream, packer);
    `FAIL_IF($size(bitstream) != 8);
    `FAIL_IF(bitstream != '{8{1'b1}});
  `SVTEST_END(pack_bitstream)


  `SVTEST(pack_returns_size_of_bitstream)
    packer.fake_packed_size = 1;
    begin
      int rval = uut.pack(bitstream, packer);
      `FAIL_IF(rval != 51);
    end
  `SVTEST_END(pack_returns_size_of_bitstream)


  //-----------------------------
  //-----------------------------
  // pack_bytes tests
  //-----------------------------
  //-----------------------------
  `SVTEST(pack_bytestream)
    int rval = uut.pack_bytes(bytestream, packer);
    `FAIL_IF($size(bytestream) != 8);
    `FAIL_IF(bytestream != '{8{8'hef}});
  `SVTEST_END(pack_bytestream)


  `SVTEST(pack_bytes_field_automation)
    void'(uut.pack_bytes(bytestream, null));
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(null, UVM_PACK, _NULL_STRING));
  `SVTEST_END()


  `SVTEST(pack_returns_size_of_bytestream)
    packer.fake_packed_size = 1;
    begin
      int rval = uut.pack_bytes(bytestream, packer);
      `FAIL_IF(rval != 51);
    end
  `SVTEST_END(pack_returns_size_of_bytestream)


  //-----------------------------
  //-----------------------------
  // pack_ints tests
  //-----------------------------
  //-----------------------------
  `SVTEST(pack_intstream)
    int rval = uut.pack_ints(intstream, packer);
    `FAIL_IF($size(intstream) != 8);
    `FAIL_IF(intstream != '{8{32'hdeadbeef}});
  `SVTEST_END(pack_intstream)


  `SVTEST(pack_ints_field_automation)
    void'(uut.pack_ints(intstream, null));
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(null, UVM_PACK, _NULL_STRING));
  `SVTEST_END()


  `SVTEST(pack_returns_size_of_intstream)
    packer.fake_packed_size = 1;
    begin
      int rval = uut.pack_ints(intstream, packer);
      `FAIL_IF(rval != 51);
    end
  `SVTEST_END(pack_returns_size_of_intstream)


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
  `SVTEST(m_unpack_pre_use_default_packer)
    void'(uut.unpack(bitstream, null));
    `FAIL_IF(uut.__m_uvm_status_container.packer != uvm_default_packer);
  `SVTEST_END()


  `SVTEST(m_unpack_pre_custom_packer)
    void'(uut.unpack(bitstream, packer));
    `FAIL_IF(uut.__m_uvm_status_container.packer != packer)
  `SVTEST_END()


  `SVTEST(m_unpack_pre_packer_is_initialized)
    packer.fake_put_bits = 1;
    void'(uut.unpack(bitstream, packer));
    `FAIL_IF(packer.count != 0);
    `FAIL_IF(packer.m_bits != 0);
    `FAIL_IF(packer.m_packed_size != 0);
  `SVTEST_END()


  `SVTEST(m_unpack_pre_packer_with_bitstream)
    bitstream = '{8{1'b1}};
    void'(uut.unpack(bitstream, packer));
    `FAIL_IF(packer.captured_m_packed_size != bitstream.size());
  `SVTEST_END()


  `SVTEST(m_unpack_post_get_packed_size_warning_check)
    uut.fake_do_unpack = 1;
    void'(uut.unpack(bitstream, packer));
    uvm_report_mock::expect_warning("BDUNPK", $sformatf("Unpack operation unsuccessful: unpacked %0d bits from a total of %0d bits",33,0));
    `FAIL_IF(!uvm_report_mock::verify_complete())
  `SVTEST_END()


  `SVTEST(m_unpack_post_packer_scope)
    string myscope = "whatever";
    packer.scope.down(myscope);
    void'(uut.unpack(bitstream, packer));
    `FAIL_IF(packer.scope.get() != myscope);
  `SVTEST_END()


  `SVTEST(m_unpack_post_field_automation)
    void'(uut.unpack(bitstream, null));
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(null, UVM_UNPACK, _NULL_STRING));
  `SVTEST_END()


  `SVTEST(m_unpack_do_unpack)
    uvm_default_packer = packer;
    void'(uut.unpack(bitstream, null));
    `FAIL_IF(packer != uut.do_unpack_unpack)
  `SVTEST_END()


  `SVTEST(unpack_returns_size_of_bitstream)
    packer.fake_packed_size = 1;
    begin
      int rval = uut.unpack(bitstream, packer);
      `FAIL_IF(rval != 51);
    end
  `SVTEST_END()


  //-----------------------------
  //-----------------------------
  // unpack_bytes tests
  //-----------------------------
  //-----------------------------
  `SVTEST(m_unpack_bytes_pre_use_default_packer)
    void'(uut.unpack_bytes(bytestream, null));
    `FAIL_IF(uut.__m_uvm_status_container.packer != uvm_default_packer);
  `SVTEST_END()


  `SVTEST(m_unpack_bytes_pre_packer_with_bytestream)
    bytestream = '{8{8'h7d}};
    void'(uut.unpack_bytes(bytestream, packer));
    `FAIL_IF(packer.captured_m_packed_size != bytestream.size()*8);
  `SVTEST_END()


  `SVTEST(m_unpack_bytes_post_field_automation)
    void'(uut.unpack_bytes(bytestream, null));
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(null, UVM_UNPACK, _NULL_STRING));
  `SVTEST_END()


  `SVTEST(unpack_bytes_returns_size_of_bytestream)
    packer.fake_packed_size = 1;
    begin
      int rval = uut.unpack_bytes(bytestream, packer);
      `FAIL_IF(rval != 51);
    end
  `SVTEST_END()


  //-----------------------------
  //-----------------------------
  // unpack_ints tests
  //-----------------------------
  //-----------------------------
  `SVTEST(m_unpack_ints_pre_use_default_packer)
    void'(uut.unpack_ints(intstream, null));
    `FAIL_IF(uut.__m_uvm_status_container.packer != uvm_default_packer);
  `SVTEST_END()


  `SVTEST(m_unpack_ints_pre_packer_with_intstream)
    intstream = '{8{32'hdeadbeef}};
    void'(uut.unpack_ints(intstream, packer));
    `FAIL_IF(packer.captured_m_packed_size != intstream.size()*32);
  `SVTEST_END()


  `SVTEST(m_unpack_ints_post_field_automation)
    void'(uut.unpack_ints(intstream, null));
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(null, UVM_UNPACK, _NULL_STRING));
  `SVTEST_END()


  `SVTEST(unpack_ints_returns_size_of_intstream)
    packer.fake_packed_size = 1;
    begin
      int rval = uut.unpack_ints(intstream, packer);
      `FAIL_IF(rval != 51);
    end
  `SVTEST_END()


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
  `SVTEST(set_int_local_status_container_warning_set)
    uut.__m_uvm_status_container.warning = 1;
    uvm_report_mock::expect_error("NOMTC", $sformatf("did not find a match for field %s", "dummy"));
    void'(uut.set_int_local("dummy",uvm_bitstream,0));
    `FAIL_IF(!uvm_report_mock::verify_complete())
  `SVTEST_END()


  `SVTEST(set_int_local_status_container_status_set)
    uut.__m_uvm_status_container.warning = 1;
    uut.fake_status = 1;
    void'(uut.set_int_local("dummy",uvm_bitstream,0));
    `FAIL_IF(!uvm_report_mock::verify_complete())
  `SVTEST_END()
  

  `SVTEST(set_int_local_status_container_status_properly_reset)
    uut.__m_uvm_status_container.status = 1;
    void'(uut.set_int_local("dummy",uvm_bitstream,0));
    `FAIL_IF(uut.__m_uvm_status_container.status != 0)
  `SVTEST_END()


  `SVTEST(set_int_local_status_container_bitstream_set_with_value)
    uvm_bitstream[7:0] = '{8{1'b1}};
    void'(uut.set_int_local("dummy",uvm_bitstream,0));
    `FAIL_IF(uut.__m_uvm_status_container.bitstream != uvm_bitstream)
  `SVTEST_END()


  `SVTEST(set_int_local_field_automation)
    string str = "dummy";
    void'(uut.set_int_local(str, uvm_bitstream, 0));
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(null, UVM_SETINT, str));
  `SVTEST_END()


  `SVTEST(set_int_local_cycle_check_empty_before_automation)
    uut.__m_uvm_status_container.cycle_check[dummy_object] = 1;
    void'(uut.set_int_local("dummy", uvm_bitstream, 0));
    `FAIL_IF(uut.was_cycle_check_empty != 1)
  `SVTEST_END()


  `SVTEST(set_int_local_m_uvm_cycle_scopes_empty)
    uut.__m_uvm_status_container.m_uvm_cycle_scopes.push_back(dummy_object);
    void'(uut.set_int_local("dummy", uvm_bitstream, 0));
    `FAIL_IF(uut.__m_uvm_status_container.m_uvm_cycle_scopes.size() != 0)
  `SVTEST_END()


  `SVTEST(set_int_local_cycle_check_empty)
    uut.fake_push_cycle_check = 1;
    void'(uut.set_int_local("dummy", uvm_bitstream, 0));
    `FAIL_IF(uut.__m_uvm_status_container.cycle_check.size() != 0)
  `SVTEST_END()


  //-----------------------------
  //-----------------------------
  // set_object_local tests
  //-----------------------------
  //-----------------------------
  `SVTEST(set_object_local_status_container_warning_set)
    uut.__m_uvm_status_container.warning = 1;
    uvm_report_mock::expect_error("NOMTC", $sformatf("did not find a match for field %s", "dummy"));
    dummy_object = null;
    void'(uut.set_object_local("dummy",dummy_object,0));
    `FAIL_IF(!uvm_report_mock::verify_complete())
  `SVTEST_END()


  `SVTEST(set_object_local_status_container_status_set)
    uut.__m_uvm_status_container.warning = 1;
    uut.fake_status = 1;
    void'(uut.set_object_local("dummy",dummy_object,0));
    `FAIL_IF(!uvm_report_mock::verify_complete())
  `SVTEST_END()


  `SVTEST(set_object_local_status_container_status_properly_reset)
    uut.__m_uvm_status_container.status = 1;
    void'(uut.set_object_local("dummy",dummy_object,0));
    `FAIL_IF(uut.__m_uvm_status_container.status != 0)
  `SVTEST_END()


  `SVTEST(set_object_local_status_container_object_set_with_value)
    void'(uut.set_object_local("dummy",dummy_object,0));
    `FAIL_IF(uut.__m_uvm_status_container.object != dummy_object)
  `SVTEST_END()


  `SVTEST(set_object_local_status_container_object_set_with_cloned_value)
    dummy_object.fake_create = 1;
    void'(uut.set_object_local("dummy",dummy_object,1));
    `FAIL_IF(uut.__m_uvm_status_container.object != dummy_object.created_object)
    `FAIL_IF(uut.__m_uvm_status_container.clone != 1)
    `FAIL_IF(uut.__m_uvm_status_container.object.get_name() != dummy_object.created_object.get_name())
  `SVTEST_END()


  `SVTEST(set_object_local_status_container_object_set_with_cloned_null_value)
    test_uvm_object null_object;
    void'(uut.set_object_local("dummy",null_object,1));
    `FAIL_IF(uut.__m_uvm_status_container.object != null)
  `SVTEST_END()


  `SVTEST(set_object_local_field_automation)
    string str = "dummy";
    void'(uut.set_object_local(str, dummy_object, 0));
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(null, UVM_SETOBJ, str));
  `SVTEST_END()


  `SVTEST(set_object_local_cycle_check_empty_before_automation)
    uut.__m_uvm_status_container.cycle_check[dummy_object] = 1;
    void'(uut.set_object_local("dummy", dummy_object, 0));
    `FAIL_IF(uut.was_cycle_check_empty != 1)
  `SVTEST_END()


  `SVTEST(set_object_local_m_uvm_cycle_scopes_empty)
    uut.__m_uvm_status_container.m_uvm_cycle_scopes.push_back(dummy_object);
    void'(uut.set_object_local("dummy", dummy_object, 0));
    `FAIL_IF(uut.__m_uvm_status_container.m_uvm_cycle_scopes.size() != 0)
  `SVTEST_END()


  `SVTEST(set_object_local_cycle_check_empty)
    uut.fake_push_cycle_check = 1;
    void'(uut.set_object_local("dummy", dummy_object, 0));
    `FAIL_IF(uut.__m_uvm_status_container.cycle_check.size() != 0)
  `SVTEST_END()


  //-----------------------------
  //-----------------------------
  // set_string_local tests
  //-----------------------------
  //-----------------------------
  `SVTEST(set_string_local_status_container_warning_set)
    uut.__m_uvm_status_container.warning = 1;
    uvm_report_mock::expect_error("NOMTC", $sformatf("did not find a match for field %s (@%0d)", dummy_str,uut.get_inst_id()));
    void'(uut.set_string_local("dummy",dummy_str,0));
    `FAIL_IF(!uvm_report_mock::verify_complete())
  `SVTEST_END()


  `SVTEST(set_string_local_status_container_status_set)
    uut.__m_uvm_status_container.warning = 1;
    uut.fake_status = 1;
    void'(uut.set_string_local("dummy",dummy_str,0));
    `FAIL_IF(!uvm_report_mock::verify_complete())
  `SVTEST_END()


  `SVTEST(set_string_local_status_container_status_properly_reset)
    uut.__m_uvm_status_container.status = 1;
    void'(uut.set_string_local("dummy",dummy_str,0));
    `FAIL_IF(uut.__m_uvm_status_container.status != 0)
  `SVTEST_END()


  `SVTEST(set_string_local_status_container_stringv_set_with_value)
    void'(uut.set_string_local("dummy",dummy_str,0));
    `FAIL_IF(uut.__m_uvm_status_container.stringv != dummy_str)
  `SVTEST_END()


  `SVTEST(set_string_local_field_automation)
    string str = "dummy";
    void'(uut.set_string_local(str, dummy_str, 0));
    `FAIL_UNLESS(uut.__m_uvm_field_automation_was_called_with(null, UVM_SETSTR, str));
  `SVTEST_END()


  `SVTEST(set_string_local_cycle_check_empty_before_automation)
    uut.__m_uvm_status_container.cycle_check[dummy_object] = 1;
    void'(uut.set_string_local("dummy", dummy_str, 0));
    `FAIL_IF(uut.was_cycle_check_empty != 1)
  `SVTEST_END()


  `SVTEST(set_string_local_m_uvm_cycle_scopes_empty)
    uut.__m_uvm_status_container.m_uvm_cycle_scopes.push_back(dummy_object);
    void'(uut.set_string_local("dummy", dummy_str, 0));
    `FAIL_IF(uut.__m_uvm_status_container.m_uvm_cycle_scopes.size() != 0)
  `SVTEST_END()


  `SVTEST(set_string_local_cycle_check_empty)
    uut.fake_push_cycle_check = 1;
    void'(uut.set_string_local("dummy", dummy_str, 0));
    `FAIL_IF(uut.__m_uvm_status_container.cycle_check.size() != 0)
  `SVTEST_END()


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
    int PRINT_FILE = $fopen(".uvm_object.print", "w+");
    string s_act;

    mock_printer.knobs.mcd = PRINT_FILE;
    mock_printer.set_istop(1);
    mock_printer.override_m_string(1);
    mock_printer.set_m_string("");

    my_uut.print(p);
    void'($rewind(PRINT_FILE));
    void'($fscanf(PRINT_FILE, "%s\n", print_test_simple_sprint_emit));
    $fclose(PRINT_FILE);
  endfunction

  // this is a duplicate'ish of the comparer.print_msg
  function string comparer_print_msg(uvm_object lhs, uvm_object rhs);
    return $sformatf("%s: Miscompare for %s: lhs type = \"%s\" : rhs type = \"%s\"\n", lhs.get_name(),
                                                                                       lhs.get_name(),
                                                                                       lhs.get_type_name(),
                                                                                       rhs.get_type_name());
  endfunction

  function void inject_compare_map_cycle_check_failure(uvm_object o = null);
    uvm_default_comparer.compare_map.clear();
    if (o != null) uvm_default_comparer.compare_map.set(dummy_object, o);
    else           uvm_default_comparer.compare_map.set(dummy_object, uut);
    uut.__m_uvm_status_container.scope.down("not empty");
  endfunction

  // this is bush league but the best I can do is make sure the print_rollup
  // logs a warning and then make sure the warning got logged.
  function bit print_rollup_called();
    uvm_report_mock::expect_warning();
    return uvm_report_mock::verify_complete();
  endfunction

  function void cause_type_mismatch_with_dummy();
    uvm_default_comparer.check_type = 1;
    dummy_object.fake_test_type_name = 1;
  endfunction

endmodule
