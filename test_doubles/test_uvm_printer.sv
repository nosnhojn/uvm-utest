`ifndef __TEST_UVM_OBJECT__
`define __TEST_UVM_OBJECT__

import uvm_pkg::*;

class test_uvm_printer extends uvm_printer();
  function uvm_printer_row_info get_last_row();
    return m_rows[m_rows.size()-1];
  endfunction
endclass

`endif
