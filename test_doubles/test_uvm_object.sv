`ifndef __TEST_UVM_OBJECT__
`define __TEST_UVM_OBJECT__

import uvm_pkg::*;

class test_uvm_object extends uvm_object;
  function new(string name);
    super.new(name);
  endfunction
endclass

`endif
