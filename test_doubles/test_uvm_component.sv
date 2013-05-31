`ifndef __TEST_UVM_COMPONENT__
`define __TEST_UVM_COMPONENT__

import uvm_pkg::*;

class test_uvm_component extends uvm_component;
  uvm_printer do_print_printer;

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void add_pretend_child(test_uvm_component o);
    m_children[o.get_name()] = o;
  endfunction

  function void do_print(uvm_printer printer);
    $cast(do_print_printer, printer);

    super.do_print(printer);
  endfunction

  function bit sprint_was_called_with(uvm_printer p);
    return p == do_print_printer;
  endfunction
endclass

`endif
