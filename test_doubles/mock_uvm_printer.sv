`ifndef __MOCK_UVM_PRINTER__
`define __MOCK_UVM_PRINTER__

import uvm_pkg::*;

class mock_uvm_printer extends uvm_printer();
  local bit m_istop = 0;
  local byte m_scope_separator;
  local bit m_string_override = 0;

  function byte get_scope_separator();
    return m_scope_separator;
  endfunction

  function void set_m_string(string s);
    m_string = s;
  endfunction

  function void set_istop(bit i);
    m_istop = i;
  endfunction

  function string emit();
    return "emit";
  endfunction

  function bit istop();
    return m_istop;
  endfunction

  function void override_m_string(bit o);
    m_string_override = o;
  endfunction

  function void print_object(string name, uvm_object value, byte scope_separator = ".");
    m_scope_separator = scope_separator;
    if (!m_string_override) set_m_string({ name , "::" , value.get_inst_id() });
  endfunction
endclass

`endif
