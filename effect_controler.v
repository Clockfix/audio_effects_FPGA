module effect_controler #( parameter
    d_width = 24,                // data width
    address_width = 4,           // 
    ram_depth = 16                // 
)(
    input                               clk,
    input                               reset,
    input   signed      [d_width-1: 0]  i_l_data,
    input   signed      [d_width-1: 0]  i_r_data,
    output  signed      [d_width-1: 0]  o_l_data,
    output  signed      [d_width-1: 0]  o_r_data
);



sync_fifo #( 
   .ram_depth(ram_depth),               // ram memory depth
   .address_width(address_width),       // ram memory address width
   .data_width(d_width)                 // data width
) fifo_l (
   .data_out(o_l_data),
   .full(),
   .empty(),
   .data_in(i_l_data),
   .clk(clk),
   .rst_a(reset),
   .wr_en(1'b1),
   .rd_en(1'b1)
);

sync_fifo #( 
   .ram_depth(ram_depth),               // ram memory depth
   .address_width(address_width),       // ram memory address width
   .data_width(d_width)                 // data width
) fifo_r (
   .data_out(o_r_data),
   .full(),
   .empty(),
   .data_in(i_r_data),
   .clk(clk),
   .rst_a(reset),
   .wr_en(1'b1),
   .rd_en(1'b1)
);


// always@* begin
//     o_l_data <= i_l_data;
//     o_r_data <= i_r_data;
// end

//assign o_l_data = i_l_data;
//assign o_r_data = i_r_data;


//assign o_l_data = 24'h000000;
//assign o_r_data = 24'h400008;

endmodule