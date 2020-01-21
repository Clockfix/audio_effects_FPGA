// This file is Test Bench for clipping module
//  
// 
// 100MHz clock on Basys3 -> 10ns period
// 50% duty cycle 5ns HIGH and 5ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 1ns

//sub modules
`include "clipping.v"
`include "no_effect.v"

//top module
`include "effect_module.v"    

module effect_tb#( parameter
    data_width = 16          // data width 
)();

reg clk = 1'b0;
reg signed [data_width-1 : 0]  i_data = 'b0; 
reg i_read_done = 0;
reg i_data_ready = 0;
reg [1 : 0]  sw = 2'b01; 


// 50% duty cycle clock
always #0.5 clk <= ~clk;

//Effect module contains all individual effects  
effect_module #(
    .d_width(data_width)                        // data width
) effect_module (
    .clk(clk),
    .reset(1'b0),
    .sw(sw),                                    // effect control swiches
    .i_treshhold(14'h0ff),
    .i_data_ready(i_data_ready),                // data ready to read
    .i_read_done(i_read_done),                  // read done from effects controler
    .i_data(i_data),                            // data input form effect controler
    .o_read_enable(),                           // enable data reading
    .o_data_valid(),
    .o_data_sw0(),
    .o_data_sw1()

);

initial begin
    #030; 
    i_data  = 'haaa;
    #005;
    i_data_ready = 1;
    #005;
    i_data  = 'h0fa;
    i_data_ready = 0;
    #002;
    i_read_done = 1;
    #001;
    i_read_done = 0;
    #005;
    i_data  =  -16'd3000;
    #002;
    i_read_done = 1;
    #001;
    i_read_done = 0;
    #005;
    i_data  =  852;
    #002;
    i_read_done = 1;
    #001;
    i_read_done = 0;
end


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