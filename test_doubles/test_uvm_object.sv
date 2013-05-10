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
  bit fake_field_automation = 0;
  bit called_do_print = 0;

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
    if (fake_field_automation) begin
      this.tmp_data__ = tmp_data__;
      this.what__ = what__;
      this.str__ = str__;
    end
    else super.__m_uvm_field_automation(tmp_data__, what__, str__);
  endfunction

  function void do_print(uvm_printer printer);
    super.do_print(printer);
    called_do_print = 1;
  endfunction

  function string sprint(uvm_printer printer=null);
    called_do_print = 0;
    return super.sprint(printer);
  endfunction
    
endclass

`endif
