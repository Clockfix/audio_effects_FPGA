// This file is Test Bench for top_vga_mem module
//  
// 

// 100MHz clock on Basys3 -> 10ns period
// 50% duty cycle 5ns HIGH and 5ns LOW
//`timescale [time unit] / [time precision]
`timescale 10 ns / 1ns


//top module
`include "i2s_transceiver.v"

module i2s_transceiver_tb#( parameter
    sclk_ws_ratio = 48,         // number of sclk periods per word select period
    mclk_sclk_ratio = 4,        // number of mclk periods per sclk period
    d_width = 24                // data width
)();

reg clk = 1'b0;
reg reset_n = 0;
reg sd_rx = 0;
reg [d_width-1: 0] l_data_tx = 0;
reg [d_width-1: 0] r_data_tx = 0;

wire sclk;
wire ws;
wire sd_tx;
wire [d_width-1: 0] l_data_rx;
wire [d_width-1: 0] r_data_rx;

// 50% duty cycle clock
always #0.5 clk <= ~clk;

always #4 sd_rx <= ~sd_rx;

i2s_transceiver #(
    .mclk_sclk_ratio(mclk_sclk_ratio),      //number of mclk periods per sclk period
    .sclk_ws_ratio(sclk_ws_ratio),          //number of sclk periods per word select period
    .d_width(d_width)                       //data width
) UUT(
    .reset_n(reset_n),                             //asynchronous active low reset
    .mclk(clk),                                //master clock
    .sclk(sclk),                                //serial clock (or bit clock)
    .ws(ws),                                  //word select (or left-right clock)
    .sd_tx(sd_tx),                               //serial data transmit
    .sd_rx(sd_rx),                               //serial data receive
    .l_data_tx(l_data_tx),                      //left channel data to transmit
    .r_data_tx(r_data_tx),                      //right channel data to transmit
    .l_data_rx(l_data_rx),                    //left channel data received
    .r_data_rx(r_data_rx)                       //right channel data received   
);


initial begin
    #0 
       reset_n <= 0; 
//    #200
        l_data_tx = 'hbbbbbb;
        r_data_tx = 'haaaaaa;
//    #20 
//       sd_rx = 'h1;
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