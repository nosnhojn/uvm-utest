module uvm_boat_anchor_demo;
// import "DPI-C" context function void c_setup ();
// import "DPI-C" context function void c_sailIn();
// import "DPI-C" function void c_build();
// import "DPI-C" function void c_startRaining();
// import "DPI-C" function void c_sailOut();
// import "DPI-C" context function void c_teardown();

// export "DPI-C" function SVAck;

  event ack;
  function SVAck;
    -> ack;
  endfunction


  initial begin
    $display("Go");
    $display("Stop");
    $finish();
  end
endmodule
