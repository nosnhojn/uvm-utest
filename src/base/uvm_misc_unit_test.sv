`include "svunit_defines.svh"
`include "test_uvm_object.sv"
`include "test_defines.sv"

import uvm_pkg::*;
import svunit_pkg::*;

//------------------------------------------------------------
//------------------------------------------------------------
// Test macros for repetitive tests further down in this file
//------------------------------------------------------------
//------------------------------------------------------------

`define UVM_VECTOR_TO_STRING(TESTNAME,EXP,VECTOR,SIZE,RADIX,RADIXSTR) \
`SVTEST(TESTNAME) \
  string s_exp = `"EXP`"; \
  string s_act = uvm_vector_to_string (VECTOR, SIZE, RADIX, `"RADIXSTR`"); \
  `FAIL_IF(s_act != s_exp); \
`SVTEST_END(TESTNAME)

`define UVM_LEAF_SCOPE_WITH_BRACKET_SEPARATOR(TYPE,OPEN,CLOSED) \
`SVTEST(uvm_leaf_scope_can_have_``TYPE``_bracket_separator) \
  string name_in = { OPEN , "branch" , CLOSED , OPEN , "leaf" , CLOSED }; \
  string name_out = { OPEN , "leaf" , CLOSED }; \
  byte separator = OPEN; \
  `FAIL_IF(uvm_leaf_scope(name_in,separator) != name_out); \
`SVTEST_END(uvm_leaf_scope_can_have_``TYPE``_bracket_separator) \

`define UVM_LEAF_SCOPE_WITH_BRACKET_SEPARATOR_AND_ARRAY(TYPE,OPEN,CLOSED) \
`SVTEST(uvm_leaf_scope_can_have_``TYPE``_bracket_separator_and_array) \
  string name_in = { OPEN , "branch" , CLOSED , OPEN , "leaf" , OPEN , 55 , CLOSED , CLOSED }; \
  string name_out = { OPEN , "leaf" , OPEN , 55 , CLOSED , CLOSED }; \
  byte separator = OPEN; \
  `FAIL_IF(uvm_leaf_scope(name_in,separator) != name_out); \
`SVTEST_END(uvm_leaf_scope_can_have_``TYPE``_bracket_separator_and_array) \

`define UVM_LEAF_SCOPE_IGNORES_BRACKET_SEPARATOR_IF_NOT_MSBYTE(TYPE,OPEN,CLOSED) \
`SVTEST(uvm_leaf_scope_ignores_``TYPE``_bracket_separator_if_not_msbyte) \
  string name_in = { OPEN , "branch" , CLOSED , OPEN , "leaf" }; \
  string name_out = { "leaf" }; \
  byte separator = OPEN; \
  `FAIL_IF(uvm_leaf_scope(name_in,separator) != name_out); \
`SVTEST_END(uvm_leaf_scope_ignores_``TYPE``_bracket_separator_if_not_msbyte)

`define UVM_GET_ARRAY_INDEX_WITH_RADIX_TEST(RADIX,IDX) \
`SVTEST(get_array_index_handles_index_with_``RADIX``_radix) \
  string s_in = `"double_trouble[IDX]`"; \
  int i_exp = IDX; \
  `FAIL_IF(uvm_get_array_index_int(s_in, get_array_index_is_wildcard) != i_exp); \
`SVTEST_END(get_array_index_handles_index_with_``RADIX``_radix)

`define UVM_GET_ARRAY_INDEX_STRING_WITH_RADIX_TEST(RADIX,IDX) \
`SVTEST(get_array_index_string_handles_index_with_``RADIX``_radix) \
  string s_in = `"double_trouble[IDX]`"; \
  string s_exp = `"IDX`"; \
  `FAIL_IF(uvm_get_array_index_string(s_in, get_array_index_is_wildcard) != s_exp); \
`SVTEST_END(get_array_index_string_handles_index_with_``RADIX``_radix)

`define UVM_GET_ARRAY_INDEX_FOR_WILD(TYPE,NAME,STRING_IN,EXP_WILD) \
`SVTEST(get_array_index_``TYPE``_``NAME) \
  string s_in = `"STRING_IN`"; \
  void'(uvm_get_array_index_``TYPE(s_in, get_array_index_is_wildcard)); \
  `FAIL_IF(get_array_index_is_wildcard != EXP_WILD); \
`SVTEST_END(get_array_index_``TYPE``_``NAME)

`define UVM_GET_ARRAY_INDEX_INT(NAME,STRING_IN,EXP) \
`SVTEST(get_array_index_int_``NAME) \
  string s_in = `"STRING_IN`"; \
  `FAIL_IF(uvm_get_array_index_int(s_in, get_array_index_is_wildcard) != EXP); \
`SVTEST_END(get_array_index_int_``NAME)

`define UVM_GET_ARRAY_INDEX_STRING(NAME,STRING_IN,EXP) \
`SVTEST(get_array_index_string_``NAME) \
  string s_in = `"STRING_IN`"; \
  string s_exp = `"EXP`"; \
  `FAIL_IF(uvm_get_array_index_string(s_in, get_array_index_is_wildcard) != s_exp); \
`SVTEST_END(get_array_index_string_``NAME)

`define UVM_GET_ARRAY_INDEX_STRING_NULL_IDX(NAME,STRING_IN) \
`SVTEST(get_array_index_string_``NAME) \
  string s_in = `"STRING_IN`"; \
  string s_exp = _NULL_STRING; \
  `FAIL_IF(uvm_get_array_index_string(s_in, get_array_index_is_wildcard) != s_exp); \
`SVTEST_END(get_array_index_string_``NAME)

`define HAS_WILDCARD_RETURNS(NAME,STRING_IN,EXP) \
`SVTEST(has_wildcard_returns_``NAME) \
  string s_in = `"STRING_IN`"; \
  `FAIL_IF(uvm_has_wildcard(s_in) != EXP); \
`SVTEST_END(has_wildcard_returns_``NAME)


module uvm_misc_unit_test;

  string name = "uvm_misc_ut";
  svunit_testcase svunit_ut;
  bit get_array_index_is_wildcard;

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
  const bit [31:0] crc_polynomial = 'h04c11db6;

  `SVUNIT_TESTS_BEGIN

  //-----------------------------
  //-----------------------------
  // uvm_instance_scope tests
  //-----------------------------
  //-----------------------------

  // this test is not entirely accurate b/c technically,
  // the global seed could randomize to 0. slim chance of
  // that happening though which is why I've chosen to
  // verify it gets some value >0 (for unsigned).
  `SVTEST(global_random_seed_is_randomized)
// LOSER do this twice to make sure we don't have a contstant
    `FAIL_IF(uvm_global_random_seed <= 0);
  `SVTEST_END(global_random_seed_is_randomized)


  //-----------------------------
  //-----------------------------
  // uvm_instance_scope tests
  //-----------------------------
  //-----------------------------

// LOSER... missed lots of tests here... basically the entire method
  `SVTEST(top_uvm_instance_scope_is_uvm_pkg)
    bit uvm_instance_scope_match = !uvm_re_match("uvm_pkg[.:]*", uvm_instance_scope());
    `FAIL_IF(!uvm_instance_scope_match);
  `SVTEST_END(top_uvm_instance_scope_is_uvm_pkg)


  //-----------------------------
  //-----------------------------
  // uvm_oneway_hash tests
  //-----------------------------
  //-----------------------------
  `SVTEST(crc_polynomial_is_const)
    `FAIL_IF(UVM_STR_CRC_POLYNOMIAL != crc_polynomial);
  `SVTEST_END(crc_polynomial_is_const)


  `SVTEST(default_calc_crc_out)
    string s = "tst_obj::tst_inst";

    `FAIL_IF(uvm_oneway_hash(s) - uvm_global_random_seed != crc32('hffff_ffff, crc_polynomial, s));
  `SVTEST_END(default_calc_crc_out)


  `SVTEST(calc_crc_out_w_seed)
    string s = "tst_obj::tst_inst";

    `FAIL_IF(uvm_oneway_hash(s, 10) - 10 != crc32('hffff_ffff, crc_polynomial, s));
  `SVTEST_END(calc_crc_out_w_seed)


  //-----------------------------
  //-----------------------------
  // uvm_create_random_seed tests
  //-----------------------------
  //-----------------------------

  `SVTEST(seed_table_empty_at_init)
    `FAIL_IF(uvm_random_seed_table_lookup.num() > 0);
  `SVTEST_END(seed_table_empty_at_init)


  `SVTEST(add_global_seed_table_entry)
    uvm_seed_map sm;

    void'(uvm_create_random_seed("tst_obj"));
    sm = uvm_random_seed_table_lookup["__global__"];

    `FAIL_IF(sm == null);
    `FAIL_IF(uvm_random_seed_table_lookup.num() != 1);
  `SVTEST_END(add_global_seed_table_entry)


  `SVTEST(add_inst_seed_table_entry)
    uvm_seed_map sm;

    void'(uvm_create_random_seed("tst_obj", "tst_inst"));
    sm = uvm_random_seed_table_lookup["tst_inst"];

    `FAIL_IF(sm == null);
    `FAIL_IF(uvm_random_seed_table_lookup.num() != 1);
  `SVTEST_END(add_inst_seed_table_entry)


  `SVTEST(_1_entry_for_reseeded_seed_table_entry)
    void'(uvm_create_random_seed("tst_obj", "tst_inst"));
    void'(uvm_create_random_seed("tst_obj", "tst_inst"));

    `FAIL_IF(uvm_random_seed_table_lookup.num() != 1);
  `SVTEST_END(_1_entry_for_reseeded_seed_table_entry)


  `SVTEST(seed_table_hash_key_is_type_id)
    uvm_seed_map sm;
    string key_act;

    void'(uvm_create_random_seed("tst_obj", "tst_inst"));
    sm = uvm_random_seed_table_lookup["tst_inst"];
    void'(sm.seed_table.first(key_act));

    `FAIL_UNLESS_STR_EQUAL({uvm_instance_scope(),"tst_obj"}, key_act)
    `FAIL_IF(sm.seed_table.num() != 1);
  `SVTEST_END(seed_table_hash_key_is_type_id)


  `SVTEST(count_hash_key_is_type_id)
    uvm_seed_map sm;
    string key_act;

    void'(uvm_create_random_seed("tst_obj", "tst_inst"));
    sm = uvm_random_seed_table_lookup["tst_inst"];
    void'(sm.count.first(key_act));

    `FAIL_UNLESS_STR_EQUAL({uvm_instance_scope(),"tst_obj"}, key_act);
    `FAIL_IF(sm.count.num() != 1);
  `SVTEST_END(count_hash_key_is_type_id)


  `SVTEST(count_incremented_for_each_reseed)
    uvm_seed_map sm;
    int unsigned cnt;

    repeat (4) void'(uvm_create_random_seed("tst_obj", "tst_inst"));
    sm = uvm_random_seed_table_lookup["tst_inst"];
    cnt = sm.count[{uvm_instance_scope(),"tst_obj"}];

    `FAIL_IF(cnt != 4);
  `SVTEST_END(count_incremented_for_each_reseed)


  `SVTEST(seed_table_init_to_oneway_hash)
    uvm_seed_map sm;
    int unsigned exp, act;

    exp = uvm_oneway_hash({uvm_instance_scope(),"tst_obj::tst_inst"});

    void'(uvm_create_random_seed("tst_obj", "tst_inst"));
    sm = uvm_random_seed_table_lookup["tst_inst"];
    act = sm.seed_table[{uvm_instance_scope(),"tst_obj"}];

    `FAIL_IF(act != exp);
  `SVTEST_END(seed_table_init_to_oneway_hash)


  `SVTEST(table_init_to_oneway_hash_plus1_for_reseed)
    uvm_seed_map sm;
    int unsigned exp, act;

    exp = uvm_oneway_hash({uvm_instance_scope(),"tst_obj::tst_inst"}) + 1;

    repeat (2) void'(uvm_create_random_seed("tst_obj", "tst_inst"));

    sm = uvm_random_seed_table_lookup["tst_inst"];
    act = sm.seed_table[{uvm_instance_scope(),"tst_obj"}];

    `FAIL_IF(act != exp);
  `SVTEST_END(table_init_to_oneway_hash_plus1_for_reseed)


  `SVTEST(count_incremented_for_each_reseed_with_multiple_tables)
    uvm_seed_map sm0, sm1;
    int unsigned cnt0, cnt1;

    repeat (3) void'(uvm_create_random_seed("tst_obj0"));
    repeat (5) void'(uvm_create_random_seed("tst_obj1", "tst_inst"));

    sm0 = uvm_random_seed_table_lookup["__global__"];
    sm1 = uvm_random_seed_table_lookup["tst_inst"];
    cnt0 = sm0.count[{uvm_instance_scope(),"tst_obj0"}];
    cnt1 = sm1.count[{uvm_instance_scope(),"tst_obj1"}];

    `FAIL_IF(cnt0 != 3);
    `FAIL_IF(cnt1 != 5);
  `SVTEST_END(count_incremented_for_each_reseed_with_multiple_tables)


  `SVTEST(table_init_to_oneway_hash_plus1_for_each_reseed_with_multiple_tables)
    uvm_seed_map sm0, sm1;
    int unsigned exp0, act0;
    int unsigned exp1, act1;

    exp0 = uvm_oneway_hash({uvm_instance_scope(),"tst_obj0::tst_inst"}) + 1;
    exp1 = uvm_oneway_hash({uvm_instance_scope(),"tst_obj1::__global__"}) + 1;

    repeat (2) void'(uvm_create_random_seed("tst_obj0", "tst_inst"));
    repeat (2) void'(uvm_create_random_seed("tst_obj1"));

    sm0 = uvm_random_seed_table_lookup["tst_inst"];
    sm1 = uvm_random_seed_table_lookup["__global__"];
    act0 = sm0.seed_table[{uvm_instance_scope(),"tst_obj0"}];
    act1 = sm1.seed_table[{uvm_instance_scope(),"tst_obj1"}];

    `FAIL_IF(act0 != exp0);
    `FAIL_IF(act1 != exp1);
  `SVTEST_END(table_init_to_oneway_hash_plus1_for_each_reseed_with_multiple_tables)

  //-----------------------------
  //-----------------------------
  // uvm_object_value_str tests
  //-----------------------------
  //-----------------------------

  `SVTEST(uvm_object_value_str_is_null_when_null)
    string s_exp = "<null>";
    test_uvm_object obj;
    `FAIL_IF(uvm_object_value_str(obj) != s_exp);
  `SVTEST_END(uvm_object_value_str_is_null_when_null)


  // FAILING TEST: BUT ONLY ON IUS. get_inst_id is way out to lunch.
// `SVTEST(uvm_object_value_str_returns_at_inst_id)
//   string s_exp = "@99";
//   test_uvm_object obj;
//
//   test_uvm_object::set_inst_count(99);
//   obj = new("");
//
//   `FAIL_IF(uvm_object_value_str(obj) != s_exp);
// `SVTEST_END(uvm_object_value_str_returns_at_inst_id)

  //---------------------------------------------------------------
  //---------------------------------------------------------------
  // uvm_leaf_scope tests
  //---------------------------------------------------------------
  //---------------------------------------------------------------
  // WARNING: seems uvm_leaf_scope is meant to be compatible with
  //          the scope stack. I don't think that's the case. plus
  //          b/c all the functionality seems to be covered by the
  //          scope stack up*, this seems be supplying redundant
  //          functionality
  //---------------------------------------------------------------

  `SVTEST(uvm_leaf_scope_with_leaf)
    string name = "leaf";
    `FAIL_IF(uvm_leaf_scope(name) != name);
  `SVTEST_END(uvm_leaf_scope_with_leaf)


  `SVTEST(uvm_leaf_scope_with_branch_n_leaf)
    string name_in = "branch.leaf";
    string name_out = "leaf";
    `FAIL_IF(uvm_leaf_scope(name_in) != name_out);
  `SVTEST_END(uvm_leaf_scope_with_branch_n_leaf)


  `UVM_LEAF_SCOPE_WITH_BRACKET_SEPARATOR(curly,"{","}")
  `UVM_LEAF_SCOPE_WITH_BRACKET_SEPARATOR(square,"[","]")
  `UVM_LEAF_SCOPE_WITH_BRACKET_SEPARATOR(round,"(",")")
  `UVM_LEAF_SCOPE_WITH_BRACKET_SEPARATOR(angle,"<",">")
  `UVM_LEAF_SCOPE_WITH_BRACKET_SEPARATOR_AND_ARRAY(curly,"{","}")
  `UVM_LEAF_SCOPE_WITH_BRACKET_SEPARATOR_AND_ARRAY(square,"[","]")
  `UVM_LEAF_SCOPE_WITH_BRACKET_SEPARATOR_AND_ARRAY(round,"(",")")
  `UVM_LEAF_SCOPE_WITH_BRACKET_SEPARATOR_AND_ARRAY(angle,"<",">")

  // FAILING TESTS
  // these get fixed when the bug on uvm_misc.svh:line 491 is fixed (see below)
// `UVM_LEAF_SCOPE_IGNORES_BRACKET_SEPARATOR_IF_NOT_MSBYTE(curly,"{","}")
// `UVM_LEAF_SCOPE_IGNORES_BRACKET_SEPARATOR_IF_NOT_MSBYTE(square,"[","]")
// `UVM_LEAF_SCOPE_IGNORES_BRACKET_SEPARATOR_IF_NOT_MSBYTE(round,"(",")")
// `UVM_LEAF_SCOPE_IGNORES_BRACKET_SEPARATOR_IF_NOT_MSBYTE(angle,"<",">")


  `SVTEST(uvm_leaf_scope_ignores_other_possible_separators_with_default)
    string name_in = "branch[{<(]}>).leaf[{<(]}>)";
    string name_out = "leaf[{<(]}>)";
    `FAIL_IF(uvm_leaf_scope(name_in) != name_out);
  `SVTEST_END(uvm_leaf_scope_ignores_other_possible_separators_with_default)


  `SVTEST(uvm_leaf_scope_ignores_default_with_other_possible_separators)
    string name_in = "(.b.ranc.h.)(.lea.f.(.l)(.e).)";
    string name_out = "(.lea.f.(.l)(.e).)";
    byte separator = "(";
    `FAIL_IF(uvm_leaf_scope(name_in, separator) != name_out);
  `SVTEST_END(uvm_leaf_scope_ignores_default_with_other_possible_separators)


  // FAILING TEST - REPORTED
  // uvm_misc.svh:line 491
  // works for bracket separators but not others
// `SVTEST(uvm_leaf_scope_can_use_any_separator)
//   string name_in = "branch&leaf";
//   string name_out = "leaf";
//   byte separator = "&";
//   `FAIL_IF(uvm_leaf_scope(name_in, separator) != name_out);
// `SVTEST_END(uvm_leaf_scope_can_use_any_separator)


  // FAILING TEST - REPORTED
  // uvm_misc.svh:483
  // null string results in 'for (pos=-1; p!=0; --pos) begin'
// `SVTEST(uvm_leaf_scope_can_handle_empty_full_name)
//   `FAIL_IF(uvm_leaf_scope(_NULL_STRING) != _NULL_STRING);
// `SVTEST_END(uvm_leaf_scope_can_handle_empty_full_name)


  `SVTEST(uvm_leaf_scope_can_return_null_leaf)
    string name_in = "branch.";
    string name_out = "";
    `FAIL_IF(uvm_leaf_scope(name_in) != name_out);
  `SVTEST_END(uvm_leaf_scope_can_return_null_leaf)


  // FAILING TEST - REPORTED
  // uvm_misc.svh:490
  // it's assumed leaf and parent aren't named with a _NULL_STRING
  // which would mean the for loop on 483 starts at 0 so the 'if(pos)'
  // can never be true
// `SVTEST(uvm_leaf_scope_can_return_null_leaf_without_branch)
//   string name_in = ".";
//   string name_out = "";
//   `FAIL_IF(uvm_leaf_scope(name_in) != name_out);
// `SVTEST_END(uvm_leaf_scope_can_return_null_leaf_without_branch)


  //-----------------------------
  //-----------------------------
  // uvm_vector_to_string tests
  //
  // (all are overflowed to test
  // the size arg properly)
  //-----------------------------
  //-----------------------------

  // FAILING TEST - REPORTED
  // uvm_misc.svh:line 509
  // $sformatf should use signed'(value) so the string includes the sign. the
  // output in this case is 15 instead of -1
// `SVTEST(signed_vector_to_string)
//   string s_exp = "-1";
//   string s_act = uvm_vector_to_string ('hf, 4, UVM_DEC, "j");
//   `FAIL_IF(s_act != s_exp);
// `SVTEST_END(signed_vector_to_string)

  `UVM_VECTOR_TO_STRING(bin_vector_to_string,b11001,121,5,UVM_BIN,b);
  `UVM_VECTOR_TO_STRING(oct_vector_to_string,o1037,1567,10,UVM_OCT,o);
  `UVM_VECTOR_TO_STRING(unsigned_vector_to_string,d15,31,4,UVM_UNSIGNED,d);
  `UVM_VECTOR_TO_STRING(string_vector_to_string,s<Z,'h3c5a,16,UVM_STRING,s);
  `UVM_VECTOR_TO_STRING(time_vector_to_string,t58,58,16,UVM_TIME,t);
  `UVM_VECTOR_TO_STRING(dec_vector_to_string,d7,7,4,UVM_DEC,d);
  `UVM_VECTOR_TO_STRING(hex_vector_to_string,h7e,254,7,UVM_HEX,h);

  //------------------------------
  //------------------------------
  // uvm_get_array_index_int tests
  //------------------------------
  //------------------------------

  // a more appropriate return value would be -1 since 0 makes
  // no array indistigunishable from <array_name>[0]
  `UVM_GET_ARRAY_INDEX_INT(returns_0_for_no_array_WARNING,double_trouble,0)
  `UVM_GET_ARRAY_INDEX_INT(returns_0_for_nothing_in_brackets_WARNING,double_trouble[],0)
  `UVM_GET_ARRAY_INDEX_INT(returns_N_for_idx_with_single_digit,double_trouble[5],5)
  `UVM_GET_ARRAY_INDEX_INT(returns_N_for_idx_with_multi_digit,double_trouble[9988],9988)
  `UVM_GET_ARRAY_INDEX_INT(returns_lower_boundary_zero,double_trouble[0],0)
  `UVM_GET_ARRAY_INDEX_INT(returns_upper_boundary_nine,double_trouble[9],9)

  `SVTEST(get_array_index_int_returns_minus1_for_char_lt_0)
    string s_in = "double_trouble[/]";
    `FAIL_IF(uvm_get_array_index_int(s_in, get_array_index_is_wildcard) != -1);
  `SVTEST_END(get_array_index_int_returns_minus1_for_char_lt_0)

  `UVM_GET_ARRAY_INDEX_INT(returns_minus1_for_char_gt_9,double_trouble[:],-1)

  `SVTEST(WARNING_get_array_index_int_returns_0_for_incomplete_array_string)
    string s_in = "99]";
    `FAIL_IF(uvm_get_array_index_int(s_in, get_array_index_is_wildcard) != 0);
  `SVTEST_END(WARNING_get_array_index_int_returns_0_for_incomplete_array_string)

  `UVM_GET_ARRAY_INDEX_INT(returns_returns_0_for_wildcard_index_WARNING,double_trouble[?],0)


  // FAILING TEST
  // uvm_misc.sv:line 539
  // radix ('h/'o/'d/'b) are treated as illegal characters
// `UVM_GET_ARRAY_INDEX_WITH_RADIX_TEST(bin,'b1);
// `UVM_GET_ARRAY_INDEX_WITH_RADIX_TEST(oct,'o7);
// `UVM_GET_ARRAY_INDEX_WITH_RADIX_TEST(dec,'d8);
// `UVM_GET_ARRAY_INDEX_WITH_RADIX_TEST(hex,'h8);


  `UVM_GET_ARRAY_INDEX_FOR_WILD(int,is_not_wild_for_no_array,double_trouble,0);
  `UVM_GET_ARRAY_INDEX_FOR_WILD(int,is_not_wild_for_array,double_trouble[99],0);
  `UVM_GET_ARRAY_INDEX_FOR_WILD(int,star_is_wild,double_trouble[*],1);
  `UVM_GET_ARRAY_INDEX_FOR_WILD(int,question_mark_is_wild,double_trouble[?],1);
  `UVM_GET_ARRAY_INDEX_FOR_WILD(int,plus_sign_is_wild,double_trouble[+],1);


  // FAILING TEST
  // uvm_misc.sv:line 539
  // default of wildcard not valid for illegal indecies strings
// `UVM_GET_ARRAY_INDEX_FOR_WILD(int,illegal_index_is_not_wild,double_trouble[>],0);

  `UVM_GET_ARRAY_INDEX_FOR_WILD(int,nothing_in_brackets_is_not_wildcart,double_trouble[],0);


  // FAILING TEST
  // uvm_misc.sv:line 533
  // default of wildcard not valid for non-happy-path strings
// `SVTEST(get_array_index_no_string_nothing_in_brackets_is_not_wildcart)
//   string s_in = "[]";
//   uvm_get_array_index_int(s_in, get_array_index_is_wildcard);
//   `FAIL_IF(get_array_index_is_wildcard != 0);
// `SVTEST_END(get_array_index_no_string_nothing_in_brackets_is_not_wildcart)


  // FAILING TEST
  // uvm_misc.sv:line 536
  // going through the while loop with a string that includes no "["
  // means the is_wildcard is left in an erroneous state
// `SVTEST(incomplete_strings_are_not_wild)
//   string s_in = "double_trouble]";
//   uvm_get_array_index_int(s_in, get_array_index_is_wildcard);
//   `FAIL_IF(get_array_index_is_wildcard != 0);
// `SVTEST_END(incomplete_strings_are_not_wild)

  //---------------------------------
  //---------------------------------
  // uvm_get_array_index_string tests
  //---------------------------------
  //---------------------------------

  `UVM_GET_ARRAY_INDEX_STRING_NULL_IDX(returns_null_string_for_no_array,double_trouble)
  `UVM_GET_ARRAY_INDEX_STRING_NULL_IDX(returns_null_for_nothing_in_brackets,double_trouble[])
  `UVM_GET_ARRAY_INDEX_STRING(returns_N_for_idx_with_single_digit,double_trouble[5],5)
  `UVM_GET_ARRAY_INDEX_STRING(returns_N_for_idx_with_multi_digit,double_trouble[9998],9998)
  `UVM_GET_ARRAY_INDEX_STRING(returns_lower_boundary_zero,double_trouble[0],0)
  `UVM_GET_ARRAY_INDEX_STRING(returns_upper_boundary_nine,double_trouble[9],9)
 
 
  // FAILING TEST
  // uvm_misc.svh:line 567
  // there's no effort here to limit to numeric indecies like is done in the
  // uvm_get_array_index_int (this test would limit the lower bound i.e. 0)
// `SVTEST(get_array_index_string_returns_null_string_for_char_lt_0)
//   string s_in = "double_trouble[/]";
//   string s_exp = "";
//   `FAIL_IF(uvm_get_array_index_string(s_in, get_array_index_is_wildcard) != s_exp);
// `SVTEST_END(get_array_index_string_returns_null_string_for_char_lt_0)
 
 
  // FAILING TEST
  // uvm_misc.svh:line 567
  // there's no effort here to limit to numeric indecies like is done in the
  // uvm_get_array_index_int (this test would limit the upper bound i.e. 0)
// `SVTEST(get_array_index_string_returns_null_string_for_char_gt_9)
//   string s_in = "double_trouble[:]";
//   string s_exp = "";
//   `FAIL_IF(uvm_get_array_index_string(s_in, get_array_index_is_wildcard) != s_exp);
// `SVTEST_END(get_array_index_string_returns_null_string_for_char_gt_9)

  `SVTEST(get_array_index_string_returns_null_string_for_incomplete_array_string)
    string s_in = "99]";
    `FAIL_IF(uvm_get_array_index_string(s_in, get_array_index_is_wildcard) != _NULL_STRING);
  `SVTEST_END(get_array_index_string_returns_null_string_for_incomplete_array_string)

  `UVM_GET_ARRAY_INDEX_STRING_NULL_IDX(returns_null_string_for_wildcard_index,double_trouble[?])


  `UVM_GET_ARRAY_INDEX_STRING_WITH_RADIX_TEST(bin,'b1);
  `UVM_GET_ARRAY_INDEX_STRING_WITH_RADIX_TEST(oct,'o7);
  `UVM_GET_ARRAY_INDEX_STRING_WITH_RADIX_TEST(dec,'d8);
  `UVM_GET_ARRAY_INDEX_STRING_WITH_RADIX_TEST(hex,'h8);

  `UVM_GET_ARRAY_INDEX_FOR_WILD(string,is_not_wild_for_no_array,double_trouble,0);
  `UVM_GET_ARRAY_INDEX_FOR_WILD(string,is_not_wild_for_array,double_trouble[99],0);
  `UVM_GET_ARRAY_INDEX_FOR_WILD(string,star_is_wild,double_trouble[*],1);
  `UVM_GET_ARRAY_INDEX_FOR_WILD(string,question_mark_is_wild,double_trouble[?],1);

  // FAILING TEST
  // uvm_misc.svh:line 567
  // the '+' sign is considered a wildcard in uvm_is_wildcard but not
  // here making the 2 functions incompatible.
// `UVM_GET_ARRAY_INDEX_FOR_WILD(string,plus_sign_is_wild,double_trouble[+],1);

  `UVM_GET_ARRAY_INDEX_FOR_WILD(string,illegal_index_is_not_wild,double_trouble[>],0);
  `UVM_GET_ARRAY_INDEX_FOR_WILD(string,nothing_in_brackets_is_not_wildcart,double_trouble[],0);


  // FAILING TEST
  // uvm_misc.sv:line 563
  // default of wildcard not valid for non-happy-path strings
// `SVTEST(get_array_index_string_no_string_nothing_in_brackets_is_not_wildcart)
//   string s_in = "[]";
//   uvm_get_array_index_string(s_in, get_array_index_is_wildcard);
//   `FAIL_IF(get_array_index_is_wildcard != 0);
// `SVTEST_END(get_array_index_string_no_string_nothing_in_brackets_is_not_wildcart)


  // FAILING TEST
  // uvm_misc.sv:line 566
  // going through the while loop with a string that includes no "["
  // means the is_wildcard is left in an erroneous state
// `SVTEST(get_array_index_string_incomplete_strings_are_not_wild)
//   string s_in = "double_trouble]";
//   uvm_get_array_index_string(s_in, get_array_index_is_wildcard);
//   `FAIL_IF(get_array_index_is_wildcard != 0);
// `SVTEST_END(get_array_index_string_incomplete_strings_are_not_wild)

  //-----------------------------
  //-----------------------------
  // uvm_is_array tests
  //-----------------------------
  //-----------------------------

  `SVTEST(is_array_returns_true_for_array_select)
    string s_in = "a[o]";
    `FAIL_IF(uvm_is_array(s_in) != 1);
  `SVTEST_END(is_array_returns_true_for_array_select)


  `SVTEST(is_array_returns_false_for_no_array)
    string s_in = "x";
    `FAIL_IF(uvm_is_array(s_in) != 0);
  `SVTEST_END(is_array_returns_false_for_no_array)


  `SVTEST(is_array_returns_false_for_null_string)
    string s_in = "";
    `FAIL_IF(uvm_is_array(s_in) != 0);
  `SVTEST_END(is_array_returns_false_for_null_string)


  // FAILING TEST
  // uvm_misc.sv:line 581
  // malformed array string is interpretted as an array
// `SVTEST(is_array_square_bracket_is_not_array)
//   string s_in = "]";
//   `FAIL_IF(uvm_is_array(s_in) != 0);
// `SVTEST_END(is_array_square_bracket_is_not_array)


  // FAILING TEST
  // uvm_misc.sv:line 581
  // malformed array string is interpretted as an array
// `SVTEST(is_array_only_brackets_is_not_array)
//   string s_in = "[]";
//   `FAIL_IF(uvm_is_array(s_in) != 0);
// `SVTEST_END(is_array_only_brackets_is_not_array)


  // FAILING TEST
  // uvm_misc.sv:line 581
  // malformed array string is interpretted as an array
// `SVTEST(is_array_only_index_is_not_array)
//   string s_in = "[x]";
//   `FAIL_IF(uvm_is_array(s_in) != 0);
// `SVTEST_END(is_array_only_index_is_not_array)

  //-----------------------------
  //-----------------------------
  // uvm_has_wildcard tests
  //-----------------------------
  //-----------------------------

  `SVTEST(WARNING_has_wildcard_returns_true_for_any_regex)
    string s_in = "/silly billy/";
    `FAIL_IF(uvm_has_wildcard(s_in) != 1);
  `SVTEST_END(WARNING_has_wildcard_returns_true_for_any_regex)


  `SVTEST(WARNING_has_wildcard_returns_true_for_empty_regex)
    string s_in = "//";
    `FAIL_IF(uvm_has_wildcard(s_in) != 1);
  `SVTEST_END(WARNING_has_wildcard_returns_true_for_empty_regex)


  `HAS_WILDCARD_RETURNS(true_for_star_at_end_of_string,*junk,1);
  `HAS_WILDCARD_RETURNS(true_for_star_at_beginning_of_string,junk*,1);
  `HAS_WILDCARD_RETURNS(true_for_star_in_middle_of_string,ju*nk,1);

  `HAS_WILDCARD_RETURNS(true_for_question_mark_at_end_of_string,?junk,1);
  `HAS_WILDCARD_RETURNS(true_for_question_mark_at_beginning_of_string,junk?,1);
  `HAS_WILDCARD_RETURNS(true_for_question_mark_in_middle_of_string,ju?nk,1);

  `HAS_WILDCARD_RETURNS(true_for_plus_sign_at_end_of_string,+junk,1);
  `HAS_WILDCARD_RETURNS(true_for_plus_sign_at_beginning_of_string,junk+,1);
  `HAS_WILDCARD_RETURNS(true_for_plus_sign_in_middle_of_string,ju+nk,1);


  `SVTEST(has_wildcard_returns_false_for_all_other_puncuation)
    string s_in = "`~!@#$%^&()-_=[]{}\|;:'\",<.>//";
    `FAIL_IF(uvm_has_wildcard(s_in) != 0);
  `SVTEST_END(has_wildcard_returns_false_for_all_other_puncuation)


  `SVTEST(has_wildcard_returns_false_for_alpha_numeric)
    string s_in = "1234567890qwertyuioplkjhgfdsazxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNM";
    `FAIL_IF(uvm_has_wildcard(s_in) != 0);
  `SVTEST_END(has_wildcard_returns_false_for_alpha_numeric)


  `SVTEST(has_wildcard_returns_false_for_null_string)
    string s_in = "";
    `FAIL_IF(uvm_has_wildcard(s_in) != 0);
  `SVTEST_END(has_wildcard_returns_false_for_null_string)

  `SVUNIT_TESTS_END


  //------------------
  //------------------
  // HELPER METHODS
  //------------------
  //------------------

  function bit[31:0] crc32(bit[31:0] init,
                           bit[31:0] polynomial,
                           string string_in);
    bit          msb;
    bit [7:0]    current_byte;

    crc32 = init;
    for (int _byte=0; _byte < string_in.len(); _byte++) begin
       current_byte = string_in[_byte];
       if (current_byte == 0) break;
       for (int _bit=0; _bit < 8; _bit++) begin
          msb = crc32[31];
          crc32 <<= 1;
          if (msb ^ current_byte[_bit]) begin
             crc32 ^=  polynomial;
             crc32[0] = 1;
          end
       end
    end
    crc32 = ~{crc32[7:0], crc32[15:8], crc32[23:16], crc32[31:24]};
  endfunction

endmodule
