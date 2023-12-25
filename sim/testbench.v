`timescale 1ns / 1ps

module washing_machine_tb;
  // Inputs
  reg clk;
  reg lid;
  reg coin;
  reg cancel;
  reg [1:0] mode;
 
  
  // Outputs
  wire soak_done, wash_done, rinse_done, spin_done;
  wire idle_op, ready_op, soak_op, wash_op, rinse_op, spin_op;
  wire coin_rtn, water_inlet;
  
  // Instantiate the design under test (DUT)
  washing_machine_ctrl uut (
            .clk(clk),
            .lid(lid),
            .coin(coin),
            .cancel(cancel),
            .soak_done(soak_done),
            .wash_done(wash_done),
            .rinse_done(rinse_done),
            .spin_done(spin_done),
            .mode(mode),
            .idle_op(idle_op),
            .ready_op(ready_op),
            .soak_op(soak_op),
            .wash_op(wash_op),
            .rinse_op(rinse_op),
            .spin_op(spin_op),
            .coin_rtn(coin_rtn),
            .water_inlet(water_inlet)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    // Initialize inputs
    lid = 1;
    coin = 0;
    cancel = 0;

    // Apply stimulus

    // You can add more stimulus here as needed

    #100 $finish; // Finish simulation after a while
  end
endmodule