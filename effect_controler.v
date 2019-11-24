module effect_controler #( parameter
    d_width = 24,                // data width
    address_width = 4,           // 
    ram_depth = 16,              //
    memory_d_width = 16          // 
)(
    input                               mclk,   // io_module clock
    input                               clk,    // main clock   
    input                               reset,
    input   signed      [d_width-1: 0]  i_l_data,
    input   signed      [d_width-1: 0]  i_r_data,   // not used
    output  signed      [d_width-1: 0]  o_l_data,
    output  signed      [d_width-1: 0]  o_r_data,

    output                                      o_read_done,    // read done from effects module
    output                                      o_read_ready,   // ready read from reefects module


    input               [1:0]           sw,             // effect control swiches

    output  signed      [memory_d_width-1: 0]   o_data_to_eff,     // Data output to effects module
    output                                      o_data_valid,         // data valid to read (FIFO not empty). data valid signal to effect module
    input                                       i_read_enable,          // enable read from input fifo 
    input  signed      [memory_d_width-1: 0]    i_data_from_eff_sw0,     // Data output to effects module
    input  signed      [memory_d_width-1: 0]    i_data_from_eff_sw1,     // Data output to effects module

    input                                       i_dv_from_eff         // data valid to read (FIFO not empty). data valid signal to effect module
     
);

wire signed [memory_d_width-1: 0]  w_o_data;        //output data to io_module 

//wire signed [memory_d_width-1: 0]  w_o_data_eff;    //output data to effects module 

wire                            w_empty_in, w_full_in;
wire                            w_empty_out, w_full_out;

wire  [memory_d_width-1:0]       w_data_to_fifo;         // wire connets mixer to output fifo

wire  [address_width-1:0]       w_data_fill_input;      // shows how full are in FIFO memmory for intput
wire  [address_width-1:0]       w_data_fill_output;     // shows how full are in FIFO memmory for output

wire                            w_data_valid_to_fifo;   // data valid to write output FIFO from mixer           

assign o_l_data [ d_width-1 : d_width - memory_d_width ] = w_o_data;         // only left chanal are used in controler
assign o_r_data [ d_width-1 : d_width - memory_d_width ] = w_o_data;         // same as left

assign o_data_valid = ~w_empty_in;

// Input FIFO
sync_fifo #( 
   .ram_depth(ram_depth),               // ram memory depth
   .address_width(address_width),       // ram memory address width
   .data_width(memory_d_width)          // memory data width
) fifo_input (
   .data_out(o_data_to_eff),
   .full(w_full_in),
   .empty(w_empty_in),
   .data_fill(w_data_fill_input),
   .data_in(i_l_data[ d_width-1 : d_width - memory_d_width ]),       
   .w_clk(mclk),
   .r_clk(clk),
   .reset(reset),
   .wr_en( w_full_in  ? 1'b0 : 1'b1 ),          // checking is FIFO full
   .rd_en( w_empty_in ? 1'b0 : i_read_enable )           // checking is FIFO empty
);

// Output FIFO
sync_fifo #( 
   .ram_depth(ram_depth),               // ram memory depth
   .address_width(address_width),       // ram memory address width
   .data_width(memory_d_width)          // memory data width
) fifo_output (
   .data_out(w_o_data),
   .full(w_full_out),
   .empty(w_empty_out),
   .data_fill(w_data_fill),
   .data_in(w_data_to_fifo),       
   .w_clk(clk),
   .r_clk(mclk),
   .reset(reset),
   .wr_en( w_data_valid_to_fifo ),     // checking of FIFO full are performing mixer module
   .rd_en( w_empty_out ? 1'b0 : 1'b1 )                  // checking is FIFO empty
);



// Effect mixer, performs audio data  merging 
effect_mixer #( 
    .data_width(memory_d_width)             // memory data width
) effect_mixer (
    .sw(sw),
    .clk(clk),
    .reset(reset),
    .i_fifo_full(w_full_out),
    .o_read_done(o_read_done),              // read from effect module done
    .o_read_ready(o_read_ready),            // ready to read from effect module
    .o_data(w_data_to_fifo),                // data to output FIFO memory
    .o_data_valid(w_data_valid_to_fifo),
    .i_dv_from_eff(i_dv_from_eff),
    .i_data_from_eff_sw0(i_data_from_eff_sw0),     // Data output to effects module
    .i_data_from_eff_sw1(i_data_from_eff_sw1) 
);




endmodule