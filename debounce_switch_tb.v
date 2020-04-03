///////////////////////////////////////////////////////////////// 
// Author - Imants Pulkstenis
// Date - 04.04.2020
// Project name - Audio FFT on FPGA
// Module name - Test Bench for debounce switch
//
// Detailed module description:
// This file is Test Bench for debounce switch module
// 
//
// Revision:
// A - initial design
// B - 
// C - 
//
///////////////////////////////////////////////////////////////////

// 100MHz clock on Basys3 -> 10ns period
// 50% duty cycle 5ns HIGH and 5ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 1ns


//top module
`include "debounce_switch.v"

module debounce_switch_tb();

reg clk = 1'b0;
reg btnC = 0;
wire reset;

// 50% duty cycle clock
always #0.5 clk <= ~clk;

debounce_switch UUT(
    .clk(clk),
    .i_switch(btnC),
    .o_switch(reset)
);

initial begin
    #20 btnC <= 1;
    #40 btnC <= 0;
    
    #40 btnC <= 1;
    #1_000_100 btnC <= 0;
end


initial begin
    #3_000_000; 
    $display("*");

    $display(" ");
    $display("Use this command to open timing diagram:");
    $display("gtkwave -f wave.vcd");
    $display("----------------------------------------------");
    $finish();
end

initial 
  begin 
    $display(" ");
    $display("----------------------------------------------");
    $display("          Starting Testbench...");
    $dumpfile("wave.vcd");
    $dumpvars(0);
end

endmodule