//      TOP module 
//       
// Fs = audio sample frequency
// I2S bitrate = (#bits/channel) x (#channels) x Fs
//         Ex: 24-bit stereo (2 channels)
//         I2S bitrate = 24 x 2 x Fs
//
// I2SxCLK source = PLLI2S output or ext. input (I2S_CKIN)
// Fs = 48kHz, 96kHz or 192kHz
// Fs = I2SxCLK / [(CF*2) * (2*I2SDIV+ODD)*8)]
//         CF = channel frame (24 bits)
//      


module top #( parameter
    sclk_ws_ratio = 64,         // number of sclk periods per word select period
    mclk_sclk_ratio = 4,        // number of mclk periods per sclk period
    d_width = 24                // data width
)(
    input           clk,
    input           btnC,
    output          da_mclk,
    output          ad_mclk,
    output          da_sclk,
    output          ad_sclk,
    output          da_lrck,
    output          ad_lrck,
    input           ad_sdout,
    output          da_sdin
    );

//------internal wires and registers--------
wire master_clk;            // 11.29 MHz master clock
wire serial_clk;
wire word_select;
wire reset_n;
wire [d_width-1: 0] r_data_tx;
wire [d_width-1: 0] l_data_tx;
wire [d_width-1: 0] r_data_rx;
wire [d_width-1: 0] l_data_rx;

wire w_sd_tx;               //internal wire

//-----sub modules--------------------------

//declare PLL to create 11.29 MHz master clock from 100 MHz system clock
clk_wiz_0 m_clk(
    .clk_in1(clk),
    .clk_out1(master_clk)
);

//instantiate I2S Transceiver component
i2s_transceiver  #(
    .mclk_sclk_ratio(mclk_sclk_ratio),      //number of mclk periods per sclk period
    .sclk_ws_ratio(sclk_ws_ratio),          //number of sclk periods per word select period
    .d_width(d_width)                       //data width
) i2s_transceiver (
    .reset_n(reset_n),      //asynchronous active low reset
    .mclk(master_clk),      //master clock
    .sclk(serial_clk),      //serial clock (or bit clock)
    .ws(word_select),       //word select (or left-right clock)
    .sd_rx(ad_sdout),       //serial data transmit
    .sd_tx(w_sd_tx),        //serial data receive
    .l_data_tx(l_data_tx),  //left channel data to transmit
    .r_data_tx(r_data_tx),  //right channel data to transmit
    .l_data_rx(l_data_rx),  //left channel data received
    .r_data_rx(r_data_rx)   //right channel data received
);

//passing data to effect controler
effect_controler #(
    .d_width(d_width)                       //data width
) effect_conroler (
//  .clk(clk),
    .i_l_data(l_data_rx),               //left channel data received         
    .i_r_data(r_data_rx),               //right channel data received
    .o_l_data(l_data_tx),               //left channel data to transmit
    .o_r_data(r_data_tx)                //right channel data to transmit
);

//debounce reset button
debounce_switch debounce_switch_reset(
    .clk(clk),
    .i_switch(btnC),
    .o_switch(reset_n)
);

assign da_mclk = master_clk;    //output master clock to ADC
assign ad_mclk = master_clk;    //output master clock to DAC
assign da_sclk = serial_clk;    //output serial clock (from I2S Transceiver) to ADC
assign ad_sclk = serial_clk;    //output serial clock (from I2S Transceiver) to DAC
assign da_lrck = word_select;   //output word select (from I2S Transceiver) to ADC
assign ad_lrck = word_select;   //output word select (from I2S Transceiver) to DAC

assign da_sdin = w_sd_tx;      //assign right channel received data to transmit (to playback out received data)


endmodule