///////////////////////////////////////////////////////////////// 
// Author - Imants Pulkstenis
// Date - 04.04.2020
// Project name - Audio FFT on FPGA
// Module name - Flip-Flop
//
// Detailed module description:
// Simple Flip-Flop
//
// Revision:
// A - initial design
// B - 
// C - 
//
///////////////////////////////////////////////////////////////////
module d_flipflop_sync_rst(
    input       D,
    output  reg Q,
    input       clk,
    input       reset);

always@(posedge clk, posedge reset)
begin
    if(reset)
        Q <= 1'd0;
    else
        Q <= D;     
end
endmodule