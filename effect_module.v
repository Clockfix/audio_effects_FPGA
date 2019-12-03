module effect_module #( parameter
    d_width = 16                // data width
)(
    input                               clk,
    input                               reset,
    input               [1:0]           sw,             // effect control switches
    input               [13:0]          i_treshhold,      // treshhold from switches
    input                               i_data_ready,   // data ready to read
    input   signed      [d_width-1: 0]  i_data,         // data input form effect controler
    input                               i_read_done,    // read done from effects controler

    output                              o_data_valid,
    output                              o_read_enable,
    // SW0 no effect
    output  signed      [d_width-1: 0]  o_data_sw0,         // data output form effect controler
    // SW1 clipping effect
    output  signed      [d_width-1: 0]  o_data_sw1          // data output form effect controler


    );

// Wires for cliping effect
wire  signed      [d_width-1: 0]        w_data_sw0;
wire                                    w_read_enable_sw0;
wire                                    w_data_valid_sw0;

wire  signed      [d_width-1: 0]        w_data_sw1;
wire                                    w_read_enable_sw1;
wire                                    w_data_valid_sw1;

// asynchronous logic ---------------------------------------

assign o_data_sw0 = w_data_sw0;
assign o_data_sw1 = w_data_sw1;

assign o_read_enable = w_read_enable_sw0 & w_read_enable_sw1;
assign o_data_valid = w_data_valid_sw0 & w_data_valid_sw1;

// Individual effect modules -----------------------------

// no effect    SW0
no_effect #(
    .data_width(d_width)               // data width
) no_effect (
    .clk(clk),
    .reset(reset),
    .i_data(i_data),
    .i_read_done(i_read_done),         // read done from effects controler
    .i_data_ready(i_data_ready),
    .o_data(w_data_sw0),
    .o_read_enable(w_read_enable_sw0),
    .o_data_valid(w_data_valid_sw0)    
);



// clipping effect    SW1
clipping_effect #(
    .data_width(d_width)               // data width
) clipping_effect (
    .clk(clk),
    .reset(reset),
    .i_treshhold( {i_treshhold, 2'b00} ),
    .i_data(i_data),
    .i_read_done(i_read_done),         // read done from effects controler
    .i_data_ready(i_data_ready),
    .o_data(w_data_sw1),
    .o_read_enable(w_read_enable_sw1),
    .o_data_valid(w_data_valid_sw1)   
);


endmodule