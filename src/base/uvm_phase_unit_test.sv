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

  `SVTEST(new_initializes_phase_trace)
    `FAIL_UNLESS(uut.get_phase_trace() == 0);
  `SVTEST_END

  // WARNING: Can't verify uvm_use_ovm_run_semantic directly from constructor

  `SVTEST(new_end_node_is_null_if_parent_is_specified)
    uut = new("uut", UVM_PHASE_SCHEDULE, default_uut);
    `FAIL_UNLESS(uut.get_end_node() == null);
  `SVTEST_END

  `SVTEST(new_end_node_is_null_if_phase_type_is_neither_schedule_or_domain)
    uut = new("uut", UVM_PHASE_IMP);
    `FAIL_UNLESS(uut.get_end_node() == null);
  `SVTEST_END

// START

  `SVTEST(new_end_node_set_with_null_parent_and_phase_type_of_schedule)
    uut = new("uut", UVM_PHASE_SCHEDULE);
    `FAIL_UNLESS(uut.get_end_node() != null);
  `SVTEST_END

  `SVTEST(new_end_node_set_with_name_end_as_name)
    uvm_phase en;
    uut = new("uut", UVM_PHASE_SCHEDULE);
    en = uut.get_end_node();
    `FAIL_UNLESS_STR_EQUAL(en.get_name(), "uut_end");
  `SVTEST_END

  `SVTEST(new_end_node_set_with_terminal_as_type)
    uvm_phase en;
    uut = new("uut", UVM_PHASE_SCHEDULE);
    en = uut.get_end_node();
    `FAIL_UNLESS(en.get_phase_type() == UVM_PHASE_TERMINAL);
  `SVTEST_END

  `SVTEST(new_end_node_set_with_this_as_parent)
    uvm_phase en;
    uut = new("uut", UVM_PHASE_SCHEDULE);
    en = uut.get_end_node();
    `FAIL_UNLESS(en.get_parent() == uut);
  `SVTEST_END

  `SVTEST(new_this_has_1_successor)
    uut = new();
    `FAIL_UNLESS(uut.get_num_successors() == 1);
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

  `SVTEST(get_schedule_returns_this_for_schedule)
    uut = new("uut", UVM_PHASE_SCHEDULE, default_uut);
    `FAIL_UNLESS(uut.get_schedule() == uut);
  `SVTEST_END

  `SVTEST(get_schedule_returns_null_for_node_with_no_parent)
    uut = new("uut", UVM_PHASE_NODE);
    `FAIL_UNLESS(uut.get_schedule() == null);
  `SVTEST_END

  `SVTEST(get_schedule_returns_this_for_hierarchy_with_no_parent)
    uut = new("uut", UVM_PHASE_SCHEDULE);
    `FAIL_UNLESS(uut.get_schedule(1) == uut);
  `SVTEST_END

  `SVTEST(get_schedule_returns_parent_for_single_hierarchy_when_parent_is_schedule)
    uvm_phase parent_phase = new("parent_phase", UVM_PHASE_SCHEDULE);
    uut = new("uut", UVM_PHASE_NODE, parent_phase);
    `FAIL_UNLESS(uut.get_schedule(1) == parent_phase);
  `SVTEST_END

  `SVTEST(get_schedule_returns_parents_parent_for_double_hierarchy_when_parents_parent_is_schedule)
    uvm_phase parent0_phase = new("parent0_phase", UVM_PHASE_SCHEDULE);
    uvm_phase parent1_phase = new("parent1_phase", UVM_PHASE_SCHEDULE, parent0_phase);
    uut = new("uut", UVM_PHASE_NODE, parent1_phase);
    `FAIL_UNLESS(uut.get_schedule(1) == parent0_phase);
  `SVTEST_END

  `SVTEST(get_schedule_returns_null_for_node_with_domain_parent)
    uvm_phase parent_phase = new("parent_phase", UVM_PHASE_DOMAIN);
    uut = new("uut", UVM_PHASE_NODE, parent_phase);
    `FAIL_UNLESS(uut.get_schedule() == null);
  `SVTEST_END

  `SVTEST(get_schedule_returns_parent_for_node_without_domain_parent)
    uvm_phase parent_phase = new("parent_phase", UVM_PHASE_NODE);
    uut = new("uut", UVM_PHASE_NODE, parent_phase);
    `FAIL_UNLESS(uut.get_schedule() == parent_phase);
  `SVTEST_END


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

  `SVTEST(find_successor_returns_null)
    `FAIL_UNLESS(uut.m_find_successor(null) == null);
  `SVTEST_END

  `SVTEST(find_successor_returns_this)
    `FAIL_UNLESS(uut.m_find_successor(uut) == uut);
  `SVTEST_END

  `SVTEST(find_successor_returns_m_imp)
    uut.m_imp = default_uut;
    `FAIL_UNLESS(uut.m_find_successor(default_uut) == uut);
  `SVTEST_END


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

  `SVTEST(get_end_node)
    uvm_phase some_phase = new("");
    uut.set_end_node(some_phase);
    `FAIL_IF(uut.get_end_node() !== some_phase);
  `SVTEST_END


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
