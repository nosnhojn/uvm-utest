`ifndef __TEST_UVM_PRINTER__
`define __TEST_UVM_PRINTER__

import uvm_pkg::*;


class print_args_t;
  string          name;
  uvm_bitstream_t value;
  int             size;
  uvm_radix_enum  radix;
  byte            scope_separator;
  string          type_name;

  function void set_all(
    string          name,
    uvm_bitstream_t value,
    int             size,
    uvm_radix_enum  radix,
    byte            scope_separator,
    string          type_name);
    this.name   = name;
    this.value  = value;
    this.size   = size;
    this.radix  = radix;
    this.scope_separator = scope_separator;
    this.type_name = type_name;
  endfunction
endclass

class print_object_header_args_t;
  string name;
  uvm_object value;
  byte scope_separator;

  function void set_all(
    string          name,
    uvm_object      value,
    byte            scope_separator); 
    this.name   = name;
    this.value  = value;
    this.scope_separator = scope_separator;
  endfunction
endclass

class print_generic_args_t;
  string name;
  string type_name;
  int size;
  string value;
  byte scope_separator;

  function void set_all(
    string          name,
    string          type_name,
    int             size,
    string          value,
    byte            scope_separator);
    this.name   = name;
    this.type_name = type_name;
    this.size   = size;
    this.value  = value;
    this.scope_separator = scope_separator;
  endfunction
endclass

class test_uvm_printer extends uvm_printer();
  print_args_t p_args = new;
  print_object_header_args_t poh_args = new;
  print_generic_args_t pg_args = new;

  function int get_array_stack_size();
    return m_array_stack.size();
  endfunction

  function void m_array_stack_push_back();
    m_array_stack.push_back($random);
  endfunction

  function string test_adjust_name(string id, byte scope_separator=".");
    return(adjust_name(id, scope_separator));
  endfunction

  function uvm_printer_row_info get_last_row();
    return m_rows[m_rows.size()-1];
  endfunction

  function uvm_printer_row_info get_first_row();
    return m_rows[0];
  endfunction
  
  function int get_num_rows();
    return m_rows.size();
  endfunction

  virtual function void print_int (string          name,
                                   uvm_bitstream_t value,
                                   int             size,
                                   uvm_radix_enum  radix=UVM_NORADIX,
                                   byte            scope_separator=".",
                                   string          type_name="");
    p_args.set_all(name, value, size, radix, scope_separator, type_name);
    super.print_int(name, value, size, radix, scope_separator, type_name);
  endfunction

  virtual function void print_object_header(string name,
                                            uvm_object value,
                                            byte scope_separator=".");
    poh_args.set_all(name, value, scope_separator);
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

  function void print_generic(string name,
                              string type_name,
                              int size,
                              string value,
                              byte scope_separator=".");
    pg_args.set_all(name, type_name, size, value, scope_separator);
    super.print_generic(name, type_name, size, value, scope_separator);
  endfunction

  function bit print_generic_was_called_with(string name,
                                             string type_name,
                                             int size,
                                             string value,
                                             byte scope_separator);
    return name == pg_args.name &&
           type_name == pg_args.type_name &&
           size == pg_args.size &&
           value == pg_args.value &&
           scope_separator == pg_args.scope_separator;
  endfunction
endclass

`endif
