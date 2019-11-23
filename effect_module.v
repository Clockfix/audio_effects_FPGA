module effect_module #( parameter
    d_width = 16                // data width
)(
    input                               clk,
    input                               reset,
    input                               i_data_ready,     // data ready to read
    input   signed      [d_width-1: 0]  i_data,         // data input form effect controler
    output                              read_enable,    // enable data reading
    output  signed      [d_width-1: 0]  o_data,         // data output form effect controler

    output                              data_valid

    );

assign o_data = i_data_ready ? i_data : 'b0 ;
assign read_enable = i_data_ready ? 1 : 0 ;
assign data_valid = i_data_ready ? 1 : 0 ;

// // cliping effect
// eclipping_effect #(
//    .data_width(d_width)               // data width
// ) eclipping_effect (
//    .clk(clk),
//    .reset(reset),
//    .i_data(i_data),
//    .o_data(o_data)
// );


endmodule