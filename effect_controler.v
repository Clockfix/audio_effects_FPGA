module effect_controler #( parameter
    d_width = 24,                // data width
    address_width = 4,           // 
    ram_depth = 16,              //
    memory_d_width = 16          // 
)(
    input                               clk,
    input                               reset,
    input   signed      [d_width-1: 0]  i_l_data,
    input   signed      [d_width-1: 0]  i_r_data,   // not used
    output  signed      [d_width-1: 0]  o_l_data,
    output  signed      [d_width-1: 0]  o_r_data
);

wire signed [memory_d_width: 0]  w_o_data;

wire w_empty, w_full;
wire  [address_width:0]     w_data_fill;

assign o_l_data [ d_width-1 : d_width - memory_d_width ] = w_o_data;         // only left chanal are used in controler
assign o_r_data [ d_width-1 : d_width - memory_d_width ] = w_o_data;         // same as left

sync_fifo #( 
   .ram_depth(ram_depth),               // ram memory depth
   .address_width(address_width),       // ram memory address width
   //.data_width(d_width)               // data width
   .data_width(memory_d_width)          // memory data width
) fifo_l (
   .data_out(w_o_data),
   .full(w_full),
   .empty(w_empty),
   .data_fill(w_data_fill),
   .data_in(i_l_data[ d_width-1 : d_width-memory_d_width ]),       
   .clk(clk),
   .rst_a(reset),
   .wr_en( w_full ? 1'b0 : 1'b1 ),
   .rd_en((w_empty & (w_data_fill > 1 )) ? 1'b0 : 1'b1)
);

// sync_fifo #( 
//    .ram_depth(ram_depth),               // ram memory depth
//    .address_width(address_width),       // ram memory address width
//    .data_width(d_width)                 // data width
// ) fifo_r (
//    .data_out(o_r_data),
//    .full(),
//    .empty(),
//    .data_in(i_r_data),
//    .clk(clk),
//    .rst_a(reset),
//    .wr_en(1'b1),
//    .rd_en(1'b1)
// );


// always@* begin
//     o_l_data <= i_l_data;
//     o_r_data <= i_r_data;
// end

//assign o_l_data = i_l_data;
//assign o_r_data = i_r_data;


//assign o_l_data = 24'h000000;
//assign o_r_data = 24'h400008;

endmodule