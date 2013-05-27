`ifndef __MOCK_UVM_PACKER__
`define __MOCK_UVM_PACKER__

import uvm_pkg::*;

class mock_uvm_packer extends uvm_packer;
  bit fake_packed_size=0;
  bit fake_put_bits=0;
  bit fake_put_bytes=0;
  bit fake_put_ints=0;
  int captured_m_packed_size;

  function void set_packed_size();
    if(fake_packed_size)
      m_packed_size = 51;
    else
      super.set_packed_size();
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

  function void put_bits (ref bit unsigned bitstream[]);
    if(!fake_put_bits) begin
      super.put_bits(bitstream);
      captured_m_packed_size = m_packed_size;
    end
  endfunction

  function void put_bytes (ref byte unsigned bytestream[]);
    if(!fake_put_bytes) begin
      super.put_bytes(bytestream);
      captured_m_packed_size = m_packed_size;
    end
  endfunction

  function void put_ints (ref int unsigned intstream[]);
    if(!fake_put_ints) begin
      super.put_ints(intstream);
      captured_m_packed_size = m_packed_size;
    end
  endfunction
endclass

`endif
