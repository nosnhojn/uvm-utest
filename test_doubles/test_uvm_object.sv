`ifndef __TEST_UVM_OBJECT__
`define __TEST_UVM_OBJECT__

import uvm_pkg::*;
`include "uvm_macros.svh"


class test_uvm_object_wrapper extends uvm_object_wrapper;
  function string get_type_name();
    return "test_uvm_object";
  endfunction
endclass

class __m_uvm_field_automation_t;
  uvm_object tmp_data__;
  int what__;
  string str__;
endclass

class comparer_state;
  int result = 0;
  string miscompares = "";
  uvm_scope_stack scope = null;
  bit is_this_in_compare_map;
endclass

class test_uvm_object extends uvm_object;
  rand int rand_property;

  __m_uvm_field_automation_t fa_args = new;
  comparer_state comp_st = new;
  bit fake_test_type_name = 0;
  bit fake_create = 0;
  bit fake_do_unpack = 0;
  bit fake_do_compare = 0;
  bit fake_status = 0;
  bit fake_push_cycle_check = 0;
  bit was_cycle_check_empty = 0;
  bit m_cycle_check_was_started;
  bit __m_uvm_field_automation_called = 0;
  bit do_compare_called = 0;

  bit latch_temp_comparer_state = 0;
  bit latch_temp_scope_stack_get = 0;
  bit comparer_cleaned_up_ok = 0;
  string latched_scope_stack_get;

  uvm_printer do_print_printer;
  uvm_object do_copy_copy;
  uvm_recorder do_record_record;
  uvm_packer do_pack_pack;
  uvm_packer do_unpack_unpack;
  string create_name;
  test_uvm_object created_object;
  string do_print_printer_m_scope_got;
  uvm_object do_compare_rhs;
  uvm_comparer do_compare_comparer;

  function new(string name);
    super.new(name);
  endfunction

  function string get_type_name ();
    if (fake_test_type_name)
      return "test_uvm_object";
    else
      return super.get_type_name();
  endfunction

  static function void set_inst_count(int cnt);
    m_inst_count = cnt;
  endfunction

  function uvm_report_object test_get_report_object();
    return m_get_report_object();
  endfunction

  function void __m_uvm_field_automation(uvm_object tmp_data__,
                                         int what__,
                                         string str__);
    __m_uvm_field_automation_called = 1;
    fa_args.tmp_data__ = tmp_data__;
    fa_args.what__ = what__;
    fa_args.str__ = str__;
    if(fake_status)
      __m_uvm_status_container.status = 1;
    if(fake_push_cycle_check) begin
      test_uvm_object dummy=new("dummy");
      __m_uvm_status_container.cycle_check[dummy] = 1;
    end
    was_cycle_check_empty = __m_uvm_status_container.cycle_check.size() == 0;

    super.__m_uvm_field_automation(tmp_data__, what__, str__);
  endfunction

  function bit __m_uvm_field_automation_was_called_with(uvm_object tmp_data__,
                                                        int what__,
                                                        string str__);
    return fa_args.tmp_data__ == tmp_data__ &&
           fa_args.what__ == what__ &&
           fa_args.str__ == str__;
  endfunction

  function bit temp_comparer_state_latched_as(int result,
                                              string miscompares,
                                              uvm_scope_stack scope,
                                              bit in_compare_map);
    return comp_st.result == result &&
           comp_st.miscompares == miscompares &&
           comp_st.scope == scope &&
           comp_st.is_this_in_compare_map == in_compare_map;
  endfunction

  function void do_print(uvm_printer printer);
    $cast(do_print_printer, printer);

    if (do_print_printer != null) do_print_printer_m_scope_got = do_print_printer.m_scope.get();

    if (__m_uvm_status_container.cycle_check.exists(this))
      m_cycle_check_was_started = __m_uvm_status_container.cycle_check[this];
    else
      m_cycle_check_was_started = 0;

    super.do_print(printer);
  endfunction

  function void do_copy(uvm_object rhs);
    $cast(do_copy_copy, rhs);
    super.do_copy(rhs);
  endfunction

  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    do_compare_called = 1;
    $cast(do_compare_rhs, rhs);
    $cast(do_compare_comparer, comparer);
    if (fake_do_compare) return 0;
    else return super.do_compare(rhs, comparer);
  endfunction

  function uvm_object create (string name="");
    create_name = name;
    if (fake_create) begin
      created_object = new(fake_create_name());
      return created_object;
    end
    else
      return super.create(name);
  endfunction

  function string fake_create_name();
    return { get_name() , "::create" };
  endfunction

  function void do_record (uvm_recorder recorder);
    $cast(do_record_record, recorder);
    super.do_record(recorder);
  endfunction

  function void do_pack (uvm_packer packer );
    $cast(do_pack_pack, packer);
    super.do_pack(packer);
  endfunction

  function void do_unpack (uvm_packer packer);
    $cast(do_unpack_unpack, packer);
    super.do_unpack(packer);
    if(fake_do_unpack) begin
      packer.m_packed_size = 33;
    end
  endfunction

  function bit sprint_was_called_with(uvm_printer p);
    return p == do_print_printer;
  endfunction

  function bit do_compare_was_called_with(uvm_object o, uvm_comparer c);
    return do_compare_rhs == o &&
           do_compare_comparer == c;
  endfunction

  function bit cycle_check_was_started();
    return m_cycle_check_was_started;
  endfunction

  function int get_inst_id ();
    if(latch_temp_comparer_state) begin
      comp_st.is_this_in_compare_map = __m_uvm_status_container.comparer.compare_map.get(this) != null;
      comp_st.result = __m_uvm_status_container.comparer.result;
      comp_st.miscompares = __m_uvm_status_container.comparer.miscompares;
      comp_st.scope = __m_uvm_status_container.comparer.scope;
      latch_temp_comparer_state = 0;
    end
    if(latch_temp_scope_stack_get) begin
      latched_scope_stack_get =
        __m_uvm_status_container.scope.get();
      latch_temp_scope_stack_get = 0;
    end
    return super.get_inst_id();
  endfunction

  function bit comparer_print_msg_object_was_called();
    return __m_uvm_status_container.comparer.result != 0;
  endfunction
endclass

`endif
