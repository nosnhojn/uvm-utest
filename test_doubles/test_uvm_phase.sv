`ifndef __TEST_UVM_PHASE__
`define __TEST_UVM_PHASE__

import uvm_pkg::*;


class test_uvm_phase extends uvm_phase();
  function new(string name="uvm_phase",
               uvm_phase_type phase_type=UVM_PHASE_SCHEDULE,
               uvm_phase parent=null);
    super.new(name, phase_type, parent);
  endfunction

  function bit get_phase_trace();
    return m_phase_trace;
  endfunction
endclass

`endif
