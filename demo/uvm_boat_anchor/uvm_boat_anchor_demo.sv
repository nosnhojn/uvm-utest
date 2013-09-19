import uvm_pkg::*;
`include "uvm_boat_anchor.sv"

module uvm_boat_anchor_demo;
  uvm_boat_anchor ba;
  initial begin
    ba = new();

    $display("$cmd> Sail in");
    if (ba.weigh_anchor()) $display("$cmd> Sail away");
    else                   $display("$cmd> Start raining");

    $display("$cmd> All done");

    $finish();
  end
endmodule
