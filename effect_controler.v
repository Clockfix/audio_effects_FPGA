module effect_controler #( parameter
    d_width = 24                // data width
)(
//    input clk,
    input signed [d_width-1: 0] i_l_data,
    input signed  [d_width-1: 0] i_r_data,
    output reg signed [d_width-1: 0] o_l_data,
    output  reg signed [d_width-1: 0] o_r_data
);

always@* begin
    o_l_data <= i_l_data;
    o_r_data <= i_r_data;
end

//assign o_l_data = i_l_data;
//assign o_r_data = i_r_data;


//assign o_l_data = 24'h000000;
//assign o_r_data = 24'h400008;

endmodule