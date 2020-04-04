///////////////////////////////////////////////////////////////// 
// Author - Imants Pulkstenis
// Date - 04.04.2020
// Project name - Audio FFT on FPGA
// Module name - Top module
//
// Detailed module description:
//
// 
//
// Revision:
// A - initial design
// B - 
// C - 
//
///////////////////////////////////////////////////////////////////
module top #( parameter
    sclk_ws_ratio = 64,         // number of sclk periods per word select period
    mclk_sclk_ratio = 4,        // number of mclk periods per sclk period
    d_width = 24,               // data width for I2S
    memory_d_width = 16         // data width for memory (and effects). lower bits are ignored
)(
    input           clk,
    input           btnC,
    output  [15:0]  led, 
    // 7 segment display
    output  [6:0]   seg,
    output          dp,
    output  [3:0]   an, 
    //VGA  inputs outputs
    output [3:0]    vgaRed,
    output [3:0]    vgaBlue,
    output [3:0]    vgaGreen,
    output          Hsync,
    output          Vsync,

    input   [15:0]  sw,         // swiches on board to control effects
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

//assign output from effect controler to leds
assign led = sw;

assign da_mclk = master_clk;    //output master clock to ADC
assign ad_mclk = master_clk;    //output master clock to DAC
// assign da_sdin = w_sd_tx;      //assign received data to transmit (to playback out received data)


//------internal wires and registers--------
wire master_clk;            // 11.29 MHz master clock
wire clk_50MHz;             // 50 MHz clock 
wire clk_25MHz;             // 25 MHz clock 

wire                w_reset; 
wire                w_internal_reset;

// wire signed [d_width-1: 0] r_data_tx;
// wire signed [d_width-1: 0] l_data_tx;
wire signed [d_width-1: 0] r_data_rx;
wire signed [d_width-1: 0] l_data_rx;


wire [d_width-1: 0] w_data_to_eff;
wire                w_dv_to_eff;  

wire                w_dv_from_eff; 
wire                w_rd_en_from_eff;

wire                w_read_done_eff;        // read done from effects module to mixer 
wire                w_read_ready_eff;       // ready to read from effects module   

// Data wires from effects module to effect controler
wire [d_width-1: 0] w_data_from_eff_sw0;
wire [d_width-1: 0] w_data_from_eff_sw1;



//-----sub modules--------------------------

// declare PLL to create 11.29 MHz master clock from 100 MHz system clock for I2S
//
// Common clocking errors with 7-Series FPGAs
// http://www.markharvey.info/art/7clk_19.10.2015/7clk_19.10.2015.html
clk_wiz_0 m_clk(
    .clk_in1(clk),
    .clk_out1(master_clk),  // 11.29 MHz master clock for I2S
    .clk_out2(clk_50MHz),   // 50MHz main clock
    .clk_out3(clk_25MHz),   // 25MHz main clock
    .locked(w_internal_reset),
    .reset(btnC)
);

// Flip-flop for reset
d_flipflop_sync_rst D_flipflop1 (
    .D(1'b0),
    .Q(w_reset),
    .clk(master_clk),
    .reset(~w_internal_reset));


io_module  #(
    .mclk_sclk_ratio(mclk_sclk_ratio),      //number of mclk periods per sclk period
    .sclk_ws_ratio(sclk_ws_ratio),          //number of sclk periods per word select period
    .d_width(d_width)                       //data width
) io_module (
    .reset(reset_n),                    //asynchronous active high reset
    .mclk(master_clk),                  //master clock
    .da_sclk(da_sclk),                  //serial clock (or bit clock)
    .da_ws(da_lrck),                    //word select (or left-right clock)
    .ad_sclk(ad_sclk),                  //serial clock (or bit clock)
    .ad_ws(ad_lrck),                    //word select (or left-right clock)
    .sd_tx(da_sdin),                    //serial data transmit
    .sd_rx(ad_sdout),                   //serial data receive
    .l_data_tx(l_data_rx),              //left channel data to transmit
    .r_data_tx(r_data_rx),              //right channel data to transmit

    .reset(w_reset),           //reset 

    .l_data_rx(l_data_rx),              //left channel data received
    .r_data_rx(r_data_rx),              //right channel data received


    // inputs to logic analyzer
    .ch0(Hsync),
    .ch1(Vsync),
    .ch2(),
    .ch3(),
    .ch4(),
    .ch5(),
    .ch6(),
    .ch7(),

    .JXADC(JXADC)                       // output for logic analizer
);

segment4x7 segment4x7(
    .clk(clk10k),       // 10kHz clock
    .in(sw),            // input
    .seg(seg),          // individual segments of number
    .an(an),            // anode to select character
    .dp(dp)             // dot on 7segment display
    );

clock_divider #(.WIDTH(11)) 
clock_divider7seg (
    .clk_in(clk_50MHz),
    .clk_out(clk10k)
);

vga_module #(  
        // .ADDR_WIDTH(ADDR_WIDTH),
        // .DATA_WIDTH(DATA_WIDTH),
        // .DEPTH(DEPTH),
        // .HSYNC_CLKS(HSYNC_CLKS),
        // .HSYNC_DISPLAY(HSYNC_DISPLAY),
        // .HSYNC_PULSE(HSYNC_PULSE),
        // .HSYNC_FRONT_PORCH(HSYNC_FRONT_PORCH),
        // .HSYNC_BACK_PORCH(HSYNC_BACK_PORCH),
        // .VSYNC_LINES(VSYNC_LINES) ,
        // .VSYNC_DISPLAY(VSYNC_DISPLAY) ,
        // .VSYNC_PULSE(VSYNC_PULSE) ,
        // .VSYNC_FRONT_PORCH(VSYNC_FRONT_PORCH) ,
        // .VSYNC_BACK_PORCH(VSYNC_BACK_PORCH) 
) vga_module1 (
    .clk(clk_25MHz),
    .o_vgaRed(vgaRed),
    .o_vgaBlue(vgaBlue),
    .o_vgaGreen(vgaGreen),
    .o_Hsync(Hsync),
    .o_Vsync(Vsync),
    .o_display(),
    .o_addr_rd(),
    .i_data_rd()
   );

endmodule