`include "svunit_defines.svh"

import uvm_pkg::*;
import svunit_pkg::*;

`include "test_uvm_phase.sv"


module uvm_phase_unit_test;

  string name = "uvm_phase_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  uvm_phase default_uut;
  test_uvm_phase uut;
  test_uvm_phase a_run_phase;
  uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();
  bit expected_phase_trace = 0;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);
    begin
      string val;
      expected_phase_trace = clp.get_arg_value("+UVM_PHASE_TRACE", val);
    end
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();

    default_uut = new();
    uut = new("uut", UVM_PHASE_IMP, default_uut);
    a_run_phase = new("run");
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
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN


  //----------------------
  // constructor tests
  //----------------------

  `SVTEST(new_calls_super_with_default_name)
    `FAIL_UNLESS_STR_EQUAL(default_uut.get_name(), "uvm_phase");
  `SVTEST_END


  `SVTEST(new_calls_super_with_name)
    `FAIL_UNLESS_STR_EQUAL(uut.get_name(), "uut");
  `SVTEST_END


  `SVTEST(new_sets_default_phase_type)
    `FAIL_UNLESS(default_uut.get_phase_type() == UVM_PHASE_SCHEDULE);
  `SVTEST_END


  `SVTEST(new_sets_phase_done)
    `FAIL_UNLESS_STR_EQUAL(uut.phase_done.get_name(), "uut_objection");
  `SVTEST_END


  `SVTEST(new_sets_phase_done_for_run)
    `FAIL_UNLESS(a_run_phase.phase_done == uvm_test_done_objection::get());
  `SVTEST_END


  `SVTEST(new_initializes_state)
    `FAIL_UNLESS(uut.get_state() == UVM_PHASE_DORMANT);
  `SVTEST_END


  `SVTEST(new_initializes_run_count)
    `FAIL_UNLESS(uut.get_run_count() == 0);
  `SVTEST_END


  `SVTEST(new_initializes_parent)
    `FAIL_UNLESS(default_uut.get_parent() == null);
  `SVTEST_END


  //----------------------
  // get_phase_type
  //----------------------

  `SVTEST(get_phase_type)
    `FAIL_UNLESS(uut.get_phase_type() == UVM_PHASE_IMP);
  `SVTEST_END


  //----------------------
  // get_state tests
  //----------------------


  //----------------------
  // get_run_count tests
  //----------------------


  //----------------------
  // find_by_name tests
  //----------------------


  //----------------------
  // find tests
  //----------------------


  //----------------------
  // is tests
  //----------------------


  //----------------------
  // is_before tests
  //----------------------


  //----------------------
  // is_after tests
  //----------------------


  //----------------------
  // exec_func tests
  //----------------------


  //----------------------
  // exec_task tests
  //----------------------


  //----------------------
  // add tests
  //----------------------


  //----------------------
  // get_parent tests
  //----------------------

  `SVTEST(get_parent)
    `FAIL_UNLESS(uut.get_parent() == default_uut);
  `SVTEST_END


  //----------------------
  // get_full_name tests
  //----------------------


  //----------------------
  // get_schedule tests
  //----------------------


  //----------------------
  // get_schedule_name tests
  //----------------------


  //----------------------
  // get_domain tests
  //----------------------


  //----------------------
  // get_imp tests
  //----------------------


  //----------------------
  // get_domain_name tests
  //----------------------


  //----------------------
  // get_objection tests
  //----------------------


  //----------------------
  // raise_objection  tests
  //----------------------


  //----------------------
  // drop_objection tests
  //----------------------


  //----------------------
  // sync tests
  //----------------------


  //----------------------
  // unsync tests
  //----------------------


  //----------------------
  // wait_for_state tests
  //----------------------


  //----------------------
  // jump tests
  //----------------------


  //----------------------
  // jump_all tests
  //----------------------


  //----------------------
  // get_jump_target tests
  //----------------------


  //----------------------
  // m_find_predecessor tests
  //----------------------


  //----------------------
  // m_find_successor tests
  //----------------------


  //----------------------
  // m_find_predecessor_by_name tests
  //----------------------


  //----------------------
  // m_find_successor_by_name tests
  //----------------------


  //----------------------
  // m_print_successors tests
  //----------------------


  //----------------------
  // traverse tests
  //----------------------


  //----------------------
  // execute tests
  //----------------------


  //----------------------
  // get_begin_node tests
  //----------------------


  //----------------------
  // get_end_node tests
  //----------------------


  //----------------------
  // get_ready_to_end_count tests
  //----------------------


  //----------------------
  // get_predecessors_for_successors tests
  //----------------------


  //----------------------
  // m_wait_for_pred tests
  //----------------------


  //----------------------
  // clear tests
  //----------------------


  //----------------------
  // clear_successors tests
  //----------------------


  //----------------------
  // m_run_phases tests
  //----------------------


  //----------------------
  // execute_phase tests
  //----------------------


  //----------------------
  // m_terminate_phase tests
  //----------------------


  //----------------------
  // m_print_termination_state tests
  //----------------------


  //----------------------
  // wait_for_self_and_siblings_to_drop tests
  //----------------------


  //----------------------
  // kill tests
  //----------------------


  //----------------------
  // kill_successors tests
  //----------------------


  //----------------------
  // convert2string tests
  //----------------------


  //----------------------
  // m_aa2string tests
  //----------------------


  //----------------------
  // is_domain tests
  //----------------------


  //----------------------
  // m_get_transitive_children tests
  //----------------------


  `SVUNIT_TESTS_END

endmodule
