`ifndef __TEST_UVM_PRINTER_VIRTUALS__
`define __TEST_UVM_PRINTER_VIRTUALS__

import uvm_pkg::*;
`include "uvm_macros.svh"

class test_uvm_printer_virtuals extends uvm_printer;

  bit print_int_called = 0;
  bit print_field_called = 0;
  bit print_object_called = 0;
  bit print_object_header_called = 0;
  bit print_string_called = 0;
  bit print_time_called = 0;
  bit print_real_called = 0;
  bit print_generic_called = 0;
  bit emit_called = 0;
  bit format_row_called = 0;
  bit format_header_called = 0;

  function void print_int (string          name,
                           uvm_bitstream_t value,
                           int             size,
                           uvm_radix_enum  radix=UVM_NORADIX,
                           byte            scope_separator=".",
                           string          type_name="");
    print_int_called = 1;
  endfunction
 
  function void print_field (string          name,
                             uvm_bitstream_t value,
                             int             size,
                             uvm_radix_enum  radix=UVM_NORADIX,
                             byte            scope_separator=".",
                             string          type_name="");
    print_field_called = 1;
  endfunction
  
  function void print_object (string     name,
                              uvm_object value,
                              byte       scope_separator=".");
    print_object_called = 1;
  endfunction
  
  
  function void print_object_header (string name,
                                     uvm_object value,
                                     byte scope_separator=".");
    print_object_header_called = 1;
  endfunction
  
  function void print_string (string name,
                              string value,
                              byte   scope_separator=".");
    print_string_called = 1;
  endfunction

  function void print_time (string name,
                            time value,
                            byte   scope_separator=".");
    print_time_called = 1;
  endfunction

  function void print_real (string  name,
                            real    value,
                            byte    scope_separator=".");
    print_real_called = 1;
  endfunction

  function void print_generic (string  name,
                               string  type_name,
                               int     size,
                               string  value,
                               byte    scope_separator=".");
    print_generic_called = 1;
  endfunction

  function string emit ();
    emit_called = 1;
  endfunction

  function string format_row (uvm_printer_row_info row);
    format_row_called = 1;
  endfunction

  function string format_header();
    format_header_called = 1;
  endfunction

endclass

`endif
