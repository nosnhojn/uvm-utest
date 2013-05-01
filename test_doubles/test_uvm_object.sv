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

  function new(string name);
    super.new(name);
  endfunction

  function string get_type_name ();
    if (fake_test_type_name)
      return "test_uvm_object";
    else
      return super.get_type_name();
  endfunction
endclass

`endif
