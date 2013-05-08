`ifndef __TEST_UVM_COMPONENT__
`define __TEST_UVM_COMPONENT__

import uvm_pkg::*;

class test_uvm_component extends uvm_component;
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass

`endif
