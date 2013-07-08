`include "svunit_defines.svh"
`include "test_defines.sv"
`include "test_uvm_object.sv"

import uvm_pkg::*;
import svunit_pkg::*;
import svunit_uvm_mock_pkg::*;


`define GET_FUNCTION_TYPE_RETURNS(RET,TYPE) \
`SVTEST(get_function_type_returns_``RET) \
  string s_exp = `"RET`"; \
  `FAIL_IF(uut.get_function_type(TYPE) != s_exp); \
`SVTEST_END


module uvm_status_container_unit_test;

  string name = "uvm_status_container_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  uvm_status_container uut;


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

    if (uut != null) begin
      uut.field_array.delete();
      uut.print_matches = 0;
    end
    uut = new();
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();

    uut.m_uvm_cycle_scopes.delete();
  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN

  //-----------------------------
  //-----------------------------
  // constructor tests
  //-----------------------------
  //-----------------------------

  `SVTEST(defaults_at_construction)
    `FAIL_IF(uut.clone !== 1);
    `FAIL_IF(uut.warning !== 0);
    `FAIL_IF(uut.status !== 0);
    `FAIL_IF(uut.bitstream !== 'hx);
    `FAIL_IF(uut.intv !== 0);
    `FAIL_IF(uut.element !== 0);
    `FAIL_IF(uut.stringv != _NULL_STRING);
    `FAIL_IF(uut.scratch1 != _NULL_STRING);
    `FAIL_IF(uut.scratch2 != _NULL_STRING);
    `FAIL_IF(uut.key != _NULL_STRING);
    `FAIL_IF(uut.object != null);
    `FAIL_IF(uut.array_warning_done !== 0);
    `FAIL_IF(uut.scope.depth() !== 0);
    `FAIL_IF(uut.cycle_check.num() !== 0);
    `FAIL_IF(uut.comparer != null);
    `FAIL_IF(uut.packer != null);
    `FAIL_IF(uut.recorder != null);
    `FAIL_IF(uut.printer != null);
    `FAIL_IF(uut.m_uvm_cycle_scopes.size() != 0);
    `FAIL_IF(uut.field_array.num() != 0);
    `FAIL_IF(uut.print_matches !== 0);
  `SVTEST_END

  
  `SVTEST(statics_are_static)
    uvm_status_container other = new();
    uut.field_array["junk"] = 1;
    uut.print_matches = 1;

    `FAIL_IF(other.field_array.num() != 1);
    `FAIL_IF(other.print_matches != 1);
  `SVTEST_END

  //-----------------------------
  //-----------------------------
  // do_field_check tests
  //-----------------------------
  //-----------------------------

  // Issue here with pre-compiled questa version. can't spec UVM_ENABLE_FIELD_CHECKS
  // so while the test is valid, we can't run it.
// `SVTEST(do_field_check_asserts_error_for_existing_field)
//   test_uvm_object o = new("test_do_field_check_object");
//   uvm_report_mock::expect_error
//         (
//          "MLTFLD",
//          { "Field done_field_check is defined multiple times in type ", o.get_type_name() }
//         );
//   uut.do_field_check("done_field_check", o);
//   uut.do_field_check("done_field_check", o);
//   `FAIL_IF(!uvm_report_mock::verify_complete());
// `SVTEST_END


  `SVTEST(do_field_check_loads_field_array)
    test_uvm_object o = new("test_do_field_check_object");
    uut.do_field_check("done_field_check", o);
    `FAIL_IF(uut.field_array.num() != 1);
  `SVTEST_END


  `SVTEST(do_field_check_ignores_duplicate_entries)
    test_uvm_object o = new("test_do_field_check_object");
    uut.do_field_check("done_field_check", o);
    uut.do_field_check("done_field_check", o);
    uut.do_field_check("another_done_field_check", o);
    `FAIL_IF(uut.field_array.num() != 2);
  `SVTEST_END

  //-----------------------------
  //-----------------------------
  // get_function_type tests
  //-----------------------------
  //-----------------------------

  `GET_FUNCTION_TYPE_RETURNS(copy, UVM_COPY);
  `GET_FUNCTION_TYPE_RETURNS(compare, UVM_COMPARE);
  `GET_FUNCTION_TYPE_RETURNS(print, UVM_PRINT);
  `GET_FUNCTION_TYPE_RETURNS(record, UVM_RECORD);
  `GET_FUNCTION_TYPE_RETURNS(pack, UVM_PACK);
  `GET_FUNCTION_TYPE_RETURNS(unpack, UVM_UNPACK);
  `GET_FUNCTION_TYPE_RETURNS(get_flags, UVM_FLAGS);
  `GET_FUNCTION_TYPE_RETURNS(set, UVM_SETINT);
  `GET_FUNCTION_TYPE_RETURNS(set_object, UVM_SETOBJ);
  `GET_FUNCTION_TYPE_RETURNS(set_string, UVM_SETSTR);
  `GET_FUNCTION_TYPE_RETURNS(unknown, UVM_DEFAULT);


  //-----------------------------
  //-----------------------------
  // get_full_scope_arg tests
  //-----------------------------
  //-----------------------------

  `SVTEST(get_full_scope_returns_scope_stack_get)
    string s_exp = "just_joking.still_friends";
    uut.scope.down("just_joking");
    uut.scope.down("still_friends");
    `FAIL_IF(uut.get_full_scope_arg() != s_exp);
  `SVTEST_END

  //-----------------------------
  //-----------------------------
  // m_uvm_cycle_scopes tests
  //-----------------------------
  //-----------------------------

  `SVTEST(cycle_check_append_same_scope)
    repeat (3) push_new_cycle_scope();

    void'(uut.m_do_cycle_check(uut.m_uvm_cycle_scopes[$]));

    `FAIL_IF(uut.m_uvm_cycle_scopes[3] != uut.m_uvm_cycle_scopes[2]);
  `SVTEST_END


  `SVTEST(cycle_check_same_scope_is_not_cycle_check)
    repeat (3) push_new_cycle_scope();

    `FAIL_IF(uut.m_do_cycle_check(uut.m_uvm_cycle_scopes[$]) !== 0);
  `SVTEST_END


  `SVTEST(cycle_check_same_scope_bumps_size_by_1)
    repeat (99) push_new_cycle_scope();

    void'(uut.m_do_cycle_check(uut.m_uvm_cycle_scopes[$]));

    `FAIL_IF(uut.m_uvm_cycle_scopes.size() != 100);
  `SVTEST_END


  `SVTEST(cycle_check_append_new_scope)
    test_uvm_object d;

    repeat (3) push_new_cycle_scope();

    d = new("d");
    void'(uut.m_do_cycle_check(d));

    `FAIL_IF(uut.m_uvm_cycle_scopes[3] != d);
  `SVTEST_END


  `SVTEST(cycle_check_new_scope_is_not_cycle_check)
    test_uvm_object d;

    repeat (3) push_new_cycle_scope();

    d = new("d");
    `FAIL_IF(uut.m_do_cycle_check(d) !== 0);
  `SVTEST_END


  `SVTEST(cycle_check_new_scope_bumps_size_by_1)
    test_uvm_object d;

    repeat (51) push_new_cycle_scope();

    d = new("d");
    void'(uut.m_do_cycle_check(d));

    `FAIL_IF(uut.m_uvm_cycle_scopes.size() != 52);
  `SVTEST_END


  `SVTEST(cycle_check_old_scope_doesnt_change_cycle_scopes)
    repeat (21) push_new_cycle_scope();

    void'(uut.m_do_cycle_check(uut.m_uvm_cycle_scopes[0]));

    `FAIL_IF(uut.m_uvm_cycle_scopes.size() != 21);
  `SVTEST_END


  `SVTEST(cycle_check_old_scope_is_cycle_check)
    repeat (21) push_new_cycle_scope();

    `FAIL_UNLESS(uut.m_do_cycle_check(uut.m_uvm_cycle_scopes[19]));
  `SVTEST_END


  `SVUNIT_TESTS_END

  function void push_new_cycle_scope();
    automatic test_uvm_object new_scope = new("new");
    uut.m_uvm_cycle_scopes.push_back(new_scope);
  endfunction

endmodule
