///////////////////////////////////////////////////////////////// 
// Author - Imants Pulkstenis
// Date - 04.04.2020
// Project name - Audio FFT on FPGA
// Module name - clock divider
//
// Detailed module description:
// This module devide FPGA input clock 
// by DIVIDER. Result is 50% duty cicle 
// pulses.
//
// Revision:
// A - initial design
// B - 
// C - 
//
///////////////////////////////////////////////////////////////////

module clock_divider #(
    parameter WIDTH =2,
    parameter DIVIDER =(2**WIDTH)
) (
    input clk_in,
    output clk_out);

reg state=1'b0, next_state=1'b1;
reg [WIDTH-1:0] counter = DIVIDER-1 ; 

always@(posedge clk_in)begin
    state <= next_state;
    if ( counter == 0) begin
        next_state <= ~next_state;
        counter <= DIVIDER-1;
    end
    else if (counter >= 0 )
        counter <= counter - 1;
end

assign clk_out = state;

endmodule