`ifndef __TEST_UVM_PRINTER__
`define __TEST_UVM_PRINTER__

import uvm_pkg::*;

class test_uvm_printer extends uvm_printer();
  function string test_adjust_name(string id, byte scope_separator=".");
    return(adjust_name(id, scope_separator));
  endfunction

  function uvm_printer_row_info get_last_row();
    return m_rows[m_rows.size()-1];
  endfunction

  function uvm_printer_row_info get_first_row();
    return m_rows[0];
  endfunction
endclass

`endif
