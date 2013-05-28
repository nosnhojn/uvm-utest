`ifndef __TEST_UVM_OBJECT__
`define __TEST_UVM_OBJECT__

import uvm_pkg::*;

class test_uvm_object_wrapper extends uvm_object_wrapper;
  function string get_type_name();
    return "test_uvm_object";
  endfunction
endclass

typedef struct {
  uvm_object tmp_data__;
  int what__;
  string str__;
} __m_uvm_field_automation_t;

class test_uvm_object extends uvm_object;
  rand int rand_property;

  __m_uvm_field_automation_t fa_args;
  bit fake_test_type_name = 0;
  bit fake_create = 0;
  bit fake_do_unpack = 0;
  bit fake_status = 0;
  bit fake_push_cycle_check = 0;
  bit was_cycle_check_empty = 0;

  uvm_printer do_print_printer;
  uvm_object do_copy_copy;
  uvm_recorder do_record_record;
  uvm_packer do_pack_pack;
  uvm_packer do_unpack_unpack;
  string create_name;
  test_uvm_object created_object;

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

  function void do_print(uvm_printer printer);
    $cast(do_print_printer, printer);
    super.do_print(printer);
  endfunction

  function void do_copy(uvm_object rhs);
    $cast(do_copy_copy, rhs);
    super.do_copy(rhs);
  endfunction

  function string sprint(uvm_printer printer=null);
    do_print_printer = null;
    return super.sprint(printer);
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
endclass

`endif
