`ifndef __MOCK_UVM_PACKER__
`define __MOCK_UVM_PACKER__

import uvm_pkg::*;

class mock_uvm_packer extends uvm_packer;
  function void set_packed_size();
    m_packed_size = 51;
  endfunction

  function int get_packed_size();
    return m_packed_size;
  endfunction

  function void get_bits(ref bit unsigned bits[]);
    bits = '{8{1'b1}};
  endfunction
  
  function void get_bytes(ref byte unsigned bytes[]);
    bytes = '{8{8'hef}};
  endfunction

  function void get_ints(ref int unsigned ints[]);
    ints = '{8{32'hdeadbeef}};
  endfunction
endclass

`endif
