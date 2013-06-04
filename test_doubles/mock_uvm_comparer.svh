`ifndef __MOCK_UVM_COMPARER__
`define __MOCK_UVM_COMPARER__

import uvm_pkg::*;

class mock_uvm_comparer extends uvm_comparer;
//  bit             expect_comparer_cleaned_up = 0;
//  bit             comparer_cleaned_up_ok = 0;
//  uvm_scope_stack status_container_scope;
//
//  function void print_msg_object(uvm_object lhs, uvm_object rhs);
//    if(expect_comparer_cleaned_up) begin
//      if(!comparer.compare_map.size() &&
//         !comparer.result &&
//         comparer.miscompares == "" &&
//         comparer.scope == status_container_scope) begin
//        comparer_cleaned_up_ok = 1;
//      end
//    end
//  endfunction
endclass

`endif
