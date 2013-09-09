import uvm_pkg::*;
`include "uvm_boat_anchor.sv"

module uvm_boat_anchor_demo;
  uvm_boat_anchor ba;
  initial begin
    ba = new();
    $display("Sail in");
    if (ba.weigh_anchor()) $display("Sail away");
    else                  $display("It's raining");
    $finish();
  end
endmodule
