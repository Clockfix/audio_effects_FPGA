// This file is Test Bench for top_vga_mem module
//  
// 

// 100MHz clock on Basys3 -> 10ns period
// 50% duty cycle 5ns HIGH and 5ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 1ns

//sub modules
`include "clock_divider_param.v"
`include "clock_enable_param.v"
`include "debounce_switch.v"


//top module
`include "top.v"

module top_vga_mem_tb#( parameter
    WAIT = 1,
    WAIT_WIDTH = 2,
    SPEED = 2,
     //memory parameters
    ADDR_WIDTH = 17, //19, // 
    DATA_WIDTH = 12, 
    DEPTH =  307_200//76_800, // 
)();

reg clk = 1'b0;

// 50% duty cycle clock
always #0.5 clk <= ~clk;


initial begin
    #030_000; 
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