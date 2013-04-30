`include "svunit_defines.svh"
`include "test_uvm_object.sv"

import uvm_pkg::*;
import svunit_pkg::*;

module uvm_misc_unit_test;

  string name = "uvm_misc_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================


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
  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();

    uvm_random_seed_table_lookup.delete();
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
  // uvm_instance_scope tests
  //-----------------------------
  //-----------------------------
  `SVTEST(top_uvm_instance_scope_is_uvm_pkg)
    string top_name = "uvm_pkg.";

    `FAIL_IF(uvm_instance_scope() != top_name);
  `SVTEST_END(top_uvm_instance_scope_is_uvm_pkg)


  //-----------------------------
  //-----------------------------
  // uvm_random_seed_table tests
  //-----------------------------
  //-----------------------------

  `SVTEST(seed_table_empty_at_init)
    `FAIL_IF(uvm_random_seed_table_lookup.num() > 0);
  `SVTEST_END(seed_table_empty_at_init)


  `SVTEST(add_global_seed_table_entry)
    uvm_seed_map sm;

    uvm_create_random_seed("tst_obj");
    sm = uvm_random_seed_table_lookup["__global__"];

    `FAIL_IF(sm == null);
    `FAIL_IF(uvm_random_seed_table_lookup.num() != 1);
  `SVTEST_END(add_global_seed_table_entry)


  `SVTEST(add_inst_seed_table_entry)
    uvm_seed_map sm;

    uvm_create_random_seed("tst_obj", "tst_inst");
    sm = uvm_random_seed_table_lookup["tst_inst"];

    `FAIL_IF(sm == null);
    `FAIL_IF(uvm_random_seed_table_lookup.num() != 1);
  `SVTEST_END(add_inst_seed_table_entry)


  `SVTEST(_1_entry_for_reseeded_seed_table_entry)
    uvm_create_random_seed("tst_obj", "tst_inst");
    uvm_create_random_seed("tst_obj", "tst_inst");

    `FAIL_IF(uvm_random_seed_table_lookup.num() != 1);
  `SVTEST_END(_1_entry_for_reseeded_seed_table_entry)


  `SVTEST(seed_table_hash_key_is_type_id)
    uvm_seed_map sm;
    string key_act, key_exp;

    uvm_create_random_seed("tst_obj", "tst_inst");
    sm = uvm_random_seed_table_lookup["tst_inst"];
    sm.seed_table.first(key_act);

    key_exp = "uvm_pkg.tst_obj";
    `FAIL_IF(key_act != key_exp);
    `FAIL_IF(sm.seed_table.num() != 1);
  `SVTEST_END(seed_table_hash_key_is_type_id)


  `SVTEST(count_hash_key_is_type_id)
    uvm_seed_map sm;
    string key_act, key_exp;

    uvm_create_random_seed("tst_obj", "tst_inst");
    sm = uvm_random_seed_table_lookup["tst_inst"];
    sm.count.first(key_act);

    key_exp = "uvm_pkg.tst_obj";
    `FAIL_IF(key_act != key_exp);
    `FAIL_IF(sm.count.num() != 1);
  `SVTEST_END(count_hash_key_is_type_id)


  `SVUNIT_TESTS_END

endmodule
