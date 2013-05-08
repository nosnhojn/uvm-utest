`ifndef __TEST_UVM_AGENT__
`define __TEST_UVM_AGENT__

import uvm_pkg::*;

`include "test_uvm_component.sv"

class test_uvm_agent extends uvm_agent;
  test_uvm_component test_comp;
  function new(string name, uvm_component parent = null);
    super.new(name, parent);

    test_comp = new("test_comp", this);
  endfunction
endclass

`endif
