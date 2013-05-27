`ifndef __TEST_UVM_PRINTER__
`define __TEST_UVM_PRINTER__

import uvm_pkg::*;


typedef struct {
  string          name;
  uvm_bitstream_t value;
  int             size;
  uvm_radix_enum  radix;
  byte            scope_separator;
  string          type_name;
} print_args_t;

typedef struct {
  string name;
  uvm_object value;
  byte scope_separator;
} print_object_header_args_t;

class test_uvm_printer extends uvm_printer();
  print_args_t p_args;
  print_object_header_args_t poh_args;

  function string test_adjust_name(string id, byte scope_separator=".");
    return(adjust_name(id, scope_separator));
  endfunction

  function uvm_printer_row_info get_last_row();
    return m_rows[m_rows.size()-1];
  endfunction

  function uvm_printer_row_info get_first_row();
    return m_rows[0];
  endfunction

  virtual function void print_int (string          name,
                                   uvm_bitstream_t value,
                                   int             size,
                                   uvm_radix_enum  radix=UVM_NORADIX,
                                   byte            scope_separator=".",
                                   string          type_name="");
    p_args = '{ name, value, size, radix, scope_separator, type_name };
    super.print_int(name, value, size, radix, scope_separator, type_name);
  endfunction

  virtual function void print_object_header(string name,
                                            uvm_object value,
                                            byte scope_separator=".");
    poh_args = '{ name, value, scope_separator };
    super.print_object_header(name, value, scope_separator);
  endfunction

  function bit print_int_was_called_with(string          name,
                                         uvm_bitstream_t value,
                                         int             size,
                                         uvm_radix_enum  radix,
                                         byte            scope_separator,
                                         string          type_name);
    return name == p_args.name &&
           value == p_args.value &&
           size == p_args.size &&
           radix == p_args.radix &&
           scope_separator == p_args.scope_separator &&
           type_name == p_args.type_name;
  endfunction
  
  function bit print_object_header_was_called_with(string name,
                                                   uvm_object value,
                                                   byte scope_separator);
    return name == poh_args.name &&
           value == poh_args.value &&
           scope_separator == poh_args.scope_separator;
  endfunction
endclass

`endif
