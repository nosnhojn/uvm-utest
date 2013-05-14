`include "svunit_defines.svh"
`include "test_uvm_object.sv"

import uvm_pkg::*;
import svunit_pkg::*;

`define UVM_VECTOR_TO_STRING(TESTNAME,EXP,VECTOR,SIZE,RADIX,RADIXSTR) \
`SVTEST(TESTNAME) \
  string s_exp = `"EXP`"; \
  string s_act = uvm_vector_to_string (VECTOR, SIZE, RADIX, `"RADIXSTR`"); \
/*$display("%s %s", s_act, s_exp);*/ \
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
  `SVTEST(top_uvm_instance_scope_is_uvm_pkg)
    string top_name = "uvm_pkg.";

    `FAIL_IF(uvm_instance_scope() != top_name);
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
    string key_act, key_exp;

    void'(uvm_create_random_seed("tst_obj", "tst_inst"));
    sm = uvm_random_seed_table_lookup["tst_inst"];
    void'(sm.seed_table.first(key_act));

    key_exp = "uvm_pkg.tst_obj";
    `FAIL_IF(key_act != key_exp);
    `FAIL_IF(sm.seed_table.num() != 1);
  `SVTEST_END(seed_table_hash_key_is_type_id)


  `SVTEST(count_hash_key_is_type_id)
    uvm_seed_map sm;
    string key_act, key_exp;

    void'(uvm_create_random_seed("tst_obj", "tst_inst"));
    sm = uvm_random_seed_table_lookup["tst_inst"];
    void'(sm.count.first(key_act));

    key_exp = "uvm_pkg.tst_obj";
    `FAIL_IF(key_act != key_exp);
    `FAIL_IF(sm.count.num() != 1);
  `SVTEST_END(count_hash_key_is_type_id)


  `SVTEST(count_incremented_for_each_reseed)
    uvm_seed_map sm;
    int unsigned cnt;

    repeat (4) void'(uvm_create_random_seed("tst_obj", "tst_inst"));
    sm = uvm_random_seed_table_lookup["tst_inst"];
    cnt = sm.count["uvm_pkg.tst_obj"];

    `FAIL_IF(cnt != 4);
  `SVTEST_END(count_incremented_for_each_reseed)


  `SVTEST(seed_table_init_to_oneway_hash)
    uvm_seed_map sm;
    int unsigned exp, act;

    exp = uvm_oneway_hash("uvm_pkg.tst_obj::tst_inst");

    void'(uvm_create_random_seed("tst_obj", "tst_inst"));
    sm = uvm_random_seed_table_lookup["tst_inst"];
    act = sm.seed_table["uvm_pkg.tst_obj"];

    `FAIL_IF(act != exp);
  `SVTEST_END(seed_table_init_to_oneway_hash)


  `SVTEST(table_init_to_oneway_hash_plus1_for_reseed)
    uvm_seed_map sm;
    int unsigned exp, act;

    exp = uvm_oneway_hash("uvm_pkg.tst_obj::tst_inst") + 1;

    repeat (2) void'(uvm_create_random_seed("tst_obj", "tst_inst"));

    sm = uvm_random_seed_table_lookup["tst_inst"];
    act = sm.seed_table["uvm_pkg.tst_obj"];

    `FAIL_IF(act != exp);
  `SVTEST_END(table_init_to_oneway_hash_plus1_for_reseed)


  `SVTEST(count_incremented_for_each_reseed_with_multiple_tables)
    uvm_seed_map sm0, sm1;
    int unsigned cnt0, cnt1;

    repeat (3) void'(uvm_create_random_seed("tst_obj0"));
    repeat (5) void'(uvm_create_random_seed("tst_obj1", "tst_inst"));

    sm0 = uvm_random_seed_table_lookup["__global__"];
    sm1 = uvm_random_seed_table_lookup["tst_inst"];
    cnt0 = sm0.count["uvm_pkg.tst_obj0"];
    cnt1 = sm1.count["uvm_pkg.tst_obj1"];

    `FAIL_IF(cnt0 != 3);
    `FAIL_IF(cnt1 != 5);
  `SVTEST_END(count_incremented_for_each_reseed_with_multiple_tables)


  `SVTEST(table_init_to_oneway_hash_plus1_for_each_reseed_with_multiple_tables)
    uvm_seed_map sm0, sm1;
    int unsigned exp0, act0;
    int unsigned exp1, act1;

    exp0 = uvm_oneway_hash("uvm_pkg.tst_obj0::tst_inst") + 1;
    exp1 = uvm_oneway_hash("uvm_pkg.tst_obj1::__global__") + 1;

    repeat (2) void'(uvm_create_random_seed("tst_obj0", "tst_inst"));
    repeat (2) void'(uvm_create_random_seed("tst_obj1"));

    sm0 = uvm_random_seed_table_lookup["tst_inst"];
    sm1 = uvm_random_seed_table_lookup["__global__"];
    act0 = sm0.seed_table["uvm_pkg.tst_obj0"];
    act1 = sm1.seed_table["uvm_pkg.tst_obj1"];

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


  `SVTEST(uvm_object_value_str_returns_at_inst_id)
    string s_exp = "@99";
    test_uvm_object obj;

    test_uvm_object::set_inst_count(99);
    obj = new("");

    `FAIL_IF(uvm_object_value_str(obj) != s_exp);
  `SVTEST_END(uvm_object_value_str_returns_at_inst_id)

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


  // FAILING TEST
  // uvm_misc.svh:line 491
  // works for bracket separators but not others
// `SVTEST(uvm_leaf_scope_can_use_any_separator)
//   string name_in = "branch&leaf";
//   string name_out = "leaf";
//   byte separator = "&";
//   `FAIL_IF(uvm_leaf_scope(name_in, separator) != name_out);
// `SVTEST_END(uvm_leaf_scope_can_use_any_separator)


  // FAILING TEST
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


  // FAILING TEST
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

  // FAILING TEST
  // uvm_misc.svh:line 509
  // $sformatf should use signed'(value) so the string includes the sign
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
  `SVTEST(WARNING_get_array_index_returns_0_for_no_array)
    string s_in = "double_trouble";
    `FAIL_IF(uvm_get_array_index_int(s_in, get_array_index_is_wildcard) != 0);
  `SVTEST_END(WARNING_get_array_index_returns_0_for_no_array)


  `SVTEST(get_array_index_returns_N_for_idx_with_single_digit)
    string s_in = "double_trouble[9]";
    `FAIL_IF(uvm_get_array_index_int(s_in, get_array_index_is_wildcard) != 9);
  `SVTEST_END(get_array_index_returns_N_for_idx_with_single_digit)


  `SVTEST(get_array_index_returns_N_for_idx_with_multi_digit)
    string s_in = "double_trouble[9988]";
    `FAIL_IF(uvm_get_array_index_int(s_in, get_array_index_is_wildcard) != 9988);
  `SVTEST_END(get_array_index_returns_N_for_idx_with_multi_digit)


  `SVTEST(get_array_index_returns_minus1_for_non_numeric_idx)
    string s_in = "double_trouble[a]";
    `FAIL_IF(uvm_get_array_index_int(s_in, get_array_index_is_wildcard) != -1);
  `SVTEST_END(get_array_index_returns_minus1_for_non_numeric_idx)


  // FAILING TEST
  // uvm_misc.sv:line 539
  // radix ('h/'o/'d/'b) are treated as illegal characters
// `UVM_GET_ARRAY_INDEX_WITH_RADIX_TEST(bin,'b1);
// `UVM_GET_ARRAY_INDEX_WITH_RADIX_TEST(oct,'o7);
// `UVM_GET_ARRAY_INDEX_WITH_RADIX_TEST(dec,'d8);
// `UVM_GET_ARRAY_INDEX_WITH_RADIX_TEST(hex,'h8);


  `SVTEST(WARNING_get_array_index_returns_0_for_incomplete_array_string)
    string s_in = "99]";
    `FAIL_IF(uvm_get_array_index_int(s_in, get_array_index_is_wildcard) != 0);
  `SVTEST_END(WARNING_get_array_index_returns_0_for_incomplete_array_string)


  `SVTEST(WARNING_get_array_index_is_not_wild_for_no_array)
    string s_in = "double_trouble";
    uvm_get_array_index_int(s_in, get_array_index_is_wildcard);
    `FAIL_IF(get_array_index_is_wildcard != 0);
  `SVTEST_END(WARNING_get_array_index_is_not_wild_for_no_array)


  `SVTEST(WARNING_get_array_index_is_not_wild_for_array)
    string s_in = "double_trouble[99]";
    uvm_get_array_index_int(s_in, get_array_index_is_wildcard);
    `FAIL_IF(get_array_index_is_wildcard != 0);
  `SVTEST_END(WARNING_get_array_index_is_not_wild_for_array)


  `SVTEST(get_array_index_star_is_wild)
    string s_in = "double_trouble[*]";
    uvm_get_array_index_int(s_in, get_array_index_is_wildcard);
    `FAIL_IF(get_array_index_is_wildcard != 1);
  `SVTEST_END(get_array_index_star_is_wild)


  `SVTEST(get_array_index_question_mark_is_wild)
    string s_in = "double_trouble[?]";
    uvm_get_array_index_int(s_in, get_array_index_is_wildcard);
    `FAIL_IF(get_array_index_is_wildcard != 1);
  `SVTEST_END(get_array_index_question_mark_is_wild)


  // FAILING TEST
  // uvm_misc.sv:line 536
  // going through the while loop with a string that includes no "["
  // means the is_wildcard is left in an erroneous state
// `SVTEST(WARNING_incomplete_strings_are_not_wild)
//   string s_in = "double_trouble]";
//   uvm_get_array_index_int(s_in, get_array_index_is_wildcard);
//   `FAIL_IF(get_array_index_is_wildcard != 0);
// `SVTEST_END(WARNING_incomplete_strings_are_not_wild)

  //---------------------------------
  //---------------------------------
  // uvm_get_array_index_string tests
  //---------------------------------
  //---------------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // uvm_is_array tests
  //-----------------------------
  //-----------------------------
  // TBD

  //-----------------------------
  //-----------------------------
  // uvm_has_wildcard tests
  //-----------------------------
  //-----------------------------
  // TBD


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
