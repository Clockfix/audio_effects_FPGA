module effect_controler #( parameter
    d_width = 24                // data width
)(
//    input clk,
    input [d_width-1: 0] i_l_data,
    input [d_width-1: 0] i_r_data,
    output [d_width-1: 0] o_l_data,
    output [d_width-1: 0] o_r_data
);

assign o_l_data = i_l_data;
assign o_r_data = i_r_data;

endmodule