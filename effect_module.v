module effect_module #( parameter
    d_width = 16                // data width
)(
    input                               clk,
    input                               reset,
    input               [1:0]           sw,             // effect control swiches
    input                               i_data_ready,   // data ready to read
    input   signed      [d_width-1: 0]  i_data,         // data input form effect controler
    output                              o_read_enable,  // enable data reading
    input                               i_read_done,    // read done from effects controler
    output  signed      [d_width-1: 0]  o_data,         // data output form effect controler
    output                              o_data_valid

    );

// Wires for cliping effect
wire  signed      [d_width-1: 0]        w_data_ce;
wire                                    w_read_enable_ce;
wire                                    w_data_valid_ce;


assign o_data = w_data_ce;// ? w_data_ce : 'b0 ;
assign o_read_enable = w_read_enable_ce;//(i_data_ready & w_data_valid_ce )  ? w_read_enable_ce : 0 ;
assign o_data_valid = w_data_valid_ce;//(i_data_ready & w_data_valid_ce ) ? w_data_valid_ce : 0 ;


// clipping effect
clipping_effect #(
   .data_width(d_width)               // data width
) clipping_effect (
   .clk(clk),
   .reset(reset),
   .i_treshhold(16'h00f0),
   .i_data(i_data),
   .i_read_done(i_data_ready),
   .o_data(w_data_ce),
   .o_read_enable(w_read_enable_ce),
   .o_data_valid(w_data_valid_ce),
   .i_data_ready(i_data_ready)
);


endmodule