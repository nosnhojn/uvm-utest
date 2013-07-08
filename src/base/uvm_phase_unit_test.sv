`include "svunit_defines.svh"

import uvm_pkg::*;
import svunit_pkg::*;


module uvm_phase_unit_test;

  string name = "uvm_phase_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  uvm_phase uut;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    uut = new(/* New arguments if needed */);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */
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
  `SVTEST(new_calls_super)
    `FAIL_UNLESS_STR_EQUAL(uut.get_name(), "uvm_phase");
  `SVTEST_END


  //----------------------
  // get_phase_type
  //----------------------


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
