`ifndef __TEST_UVM_OBJECT__
`define __TEST_UVM_OBJECT__

import uvm_pkg::*;

class test_uvm_object_wrapper extends uvm_object_wrapper;
  function string get_type_name();
    return "test_uvm_object";
  endfunction
endclass

class test_uvm_object extends uvm_object;
  rand int rand_property;

  bit fake_test_type_name = 0;
  bit fake_create = 0;
  uvm_printer do_print_printer;
  uvm_object do_copy_copy;
  string create_name;

  uvm_object tmp_data__;
  int what__;
  string str__;

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
    this.tmp_data__ = tmp_data__;
    this.what__ = what__;
    this.str__ = str__;

    super.__m_uvm_field_automation(tmp_data__, what__, str__);
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
      test_uvm_object o = new(fake_create_name());
      return o;
    end
    else
      return super.create(name);
  endfunction

  function string fake_create_name();
    return { get_name() , "::create" };
  endfunction
endclass

`endif
