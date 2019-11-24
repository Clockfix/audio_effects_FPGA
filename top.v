//      TOP module 
//       
//
//
//
module top #( parameter
    sclk_ws_ratio = 64,         // number of sclk periods per word select period
    mclk_sclk_ratio = 4,        // number of mclk periods per sclk period
    d_width = 24,               // data width for I2S
    memory_d_width = 16         // data width for memory (and effects). lower bits are ignored
)(
    input           clk,
    input           btnC,
    input   [1:0]   sw,         // swiches on board to control effects
    output          da_mclk,
    output          ad_mclk,
    output          da_sclk,
    output          ad_sclk,
    output          da_lrck,
    output          ad_lrck,
    input           ad_sdout,
    output          da_sdin,
    output  [7: 0]  JXADC       // output for logic analizer
    );

assign da_mclk = master_clk;    //output master clock to ADC
assign ad_mclk = master_clk;    //output master clock to DAC
// assign da_sdin = w_sd_tx;      //assign received data to transmit (to playback out received data)


//------internal wires and registers--------
wire master_clk;            // 11.29 MHz master clock

wire clk_25MHz;             // 

wire                w_reset, w_reset1, w_reset2, w_reset3, 
                    w_reset4, w_reset5;

wire [d_width-1: 0] r_data_tx;
wire [d_width-1: 0] l_data_tx;
wire [d_width-1: 0] r_data_rx;
wire [d_width-1: 0] l_data_rx;

wire [d_width-1: 0] w_data_to_eff;
wire                w_dv_to_eff;  

wire [d_width-1: 0] w_data_from_eff;
wire                w_dv_from_eff; 

wire                w_rd_en_from_eff;

wire                w_internal_reset;

//-----sub modules--------------------------

// declare PLL to create 11.29 MHz master clock from 100 MHz system clock for I2S
//
// Common clocking errors with 7-Series FPGAs
// http://www.markharvey.info/art/7clk_19.10.2015/7clk_19.10.2015.html
clk_wiz_0 m_clk(
    .clk_in1(clk),
    .clk_out1(master_clk),  // 11.29 MHz master clock for I2S
    .clk_out2(clk_25MHz),   // 25MHz main clock
    .locked(w_internal_reset),
    .reset(btnC)
);

// Flip-flops for reset
d_flipflop_sync_rst D_flipflop1 (
    .D(1'b0),
    .Q(w_reset1),
    .clk(master_clk),
    .reset(~w_internal_reset));

d_flipflop_sync_rst D_flipflop2 (
    .D(w_reset1),
    .Q(w_reset2),
    .clk(master_clk),
    .reset(~w_internal_reset));

d_flipflop_sync_rst D_flipflop3 (
    .D(w_reset2),
    .Q(w_reset),
    .clk(master_clk),
    .reset(~w_internal_reset));



io_module  #(
    .mclk_sclk_ratio(mclk_sclk_ratio),      //number of mclk periods per sclk period
    .sclk_ws_ratio(sclk_ws_ratio),          //number of sclk periods per word select period
    .d_width(d_width)                       //data width
) io_module (
    //.reset_n(reset_n),                  //asynchronous active high reset
    .mclk(master_clk),                  //master clock
    .da_sclk(da_sclk),                  //serial clock (or bit clock)
    .da_ws(da_lrck),                    //word select (or left-right clock)
    .ad_sclk(ad_sclk),                  //serial clock (or bit clock)
    .ad_ws(ad_lrck),                    //word select (or left-right clock)
    .sd_tx(da_sdin),                    //serial data transmit
    .sd_rx(ad_sdout),                   //serial data receive
    .l_data_tx(l_data_tx),              //left channel data to transmit
    .r_data_tx(r_data_tx),              //right channel data to transmit

    .reset(w_reset),           //reset 

    .l_data_rx(l_data_rx),              //left channel data received
    .r_data_rx(r_data_rx),              //right channel data received


    // // inputs to logic analyzer
    // .ch0(),
    // .ch1(),
    // .ch2(),
    // .ch3(),
    // .ch4(),
    // .ch5(),
    // .ch6(),
    // .ch7(),

    .JXADC(JXADC)                       // output for logic analizer
);


//Effect controler controls effects and perfoms multiplexing and data marging
effect_controler #(
    .d_width(d_width),                  // data width
    .memory_d_width(memory_d_width)
) effect_controler (
    .reset(w_reset),                    // asynchronous active high reset
    .mclk(master_clk),
    .clk(clk_25MHz),
    .i_l_data(l_data_rx),               // left channel data received         
    .i_r_data(r_data_rx),               // right channel data received
    .o_l_data(l_data_tx),               // left channel data to transmit
    .o_r_data(r_data_tx),               // right channel data to transmit

    .o_data_to_eff(w_data_to_eff),      // Data output to effects module
    .o_data_valid(w_dv_to_eff),         // data valid to read (FIFO not empty). data valid signal to effect module
    
    .i_read_enable(w_rd_en_from_eff),   // read enable from Effect module
    .i_data_from_eff(w_data_from_eff),  // Data input from effects module
    .i_dv_from_eff(w_dv_from_eff)       // data valid write (FIFO not full). data valid signal from effect module
);


//Effect module contains all individual effects  
effect_module #(
    .d_width(memory_d_width)                    // data width
) effect_module (
    .clk(clk_25MHz),
    .reset(w_reset),
    .sw(sw),                                    // effect control swiches
    .i_data_ready(w_dv_to_eff),                 // data ready to read
    .i_data(w_data_to_eff),                     // data input form effect controler
    .o_read_enable(w_rd_en_from_eff),           // enable data reading
    .o_data(w_data_from_eff),
    .o_data_valid(w_dv_from_eff)

);


endmodule