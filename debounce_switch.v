///////////////////////////////////////////////////////////////// 
// Author - Imants Pulkstenis
// Date - 04.04.2020
// Project name - Audio FFT on FPGA
// Module name - Debounce switch
//
// Detailed module description:
// This is Debounce switch module.
// It toggles output only when input is in 
// HIGH or LOW state atleast for 10ms 
//
// Revision:
// A - initial design
// B - 
// C - 
//
///////////////////////////////////////////////////////////////////module debounce_switch(
    input clk,
    input i_switch,
    output o_switch);

//    parameter c_debounce_limit=250000;// 2.5ms at 25MHz
//        parameter c_debounce_limit=1_000_000;// 10ms at 100MHz
        parameter c_debounce_limit=100_000; // 10ms at 10MHz

reg r_state=1'b0;
reg [19:0] r_count = 0;

    always@(posedge clk)begin
        if (i_switch != r_state && r_count < c_debounce_limit)
            r_count <= r_count +1; //counter
        else if (r_count == c_debounce_limit)begin
            r_count <=0;
            r_state <= i_switch;
        end
        else
            r_count<=0;
    end

assign o_switch=r_state;

endmodule