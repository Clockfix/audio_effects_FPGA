// This I2S Playback design uses the common 44.1 kHz 
// sampling frequency.  
// From Figure 2 in Section 4.1.1 of the CS5343 
// Datasheet, it is appropriate to use an SCLK/LRCK 
// ratio of 64 and a MCLK/LRCK ratio of 256.  
// Therefore, the I2S Transceiver’s generic 
// parameter sclk_ws_ratio is set to 64.  
// (LRCK, e.g. left-right clock, and ws, 
// e.g. word select, are synonymous.)  
// The generic parameter mclk_sclk_ratio is set to 4, 
// since MCLK/SCLK = (MCLK/LRCK) / (SCLK/LRCK) = 256/64 = 4.



module i2c_transceiver #( parameter
    d_width = 24            // data width
    mclk_sclk_ratio => 4, 
    sclk_ws_ratio => 64
)(
    input       clock,      // system clock (100 MHz on Basys board)
    input       reset_n,    // active low asynchronous reset
    output      mclk,       // master clock
    output      sclk,       // serial clock (or bit clock)
    output      ws,         // word select (or left-right clock)
    input       sd_rx,      // serial data in
    output      sd_tx       // serial data out
    );

    wire master_clk;                    //internal master clock signal
    reg serial_clk = 0;                 //internal serial clock signal
    reg word_select  = 0;               //internal word select signal
    wire l_data_rx[d_width-1 : 0];      //left channel data received from I2S Transceiver component
    wire r_data_rx[d_width-1 : 0];      //right channel data received from I2S Transceiver component
    wire l_data_tx[d_width-1 : 0];      //left channel data to transmit using I2S Transceiver component
    wire r_data_tx[d_width-1 : 0];      //right channel data to transmit using I2S Transceiver component


//declare PLL to create 11.29 MHz master clock from 100 MHz system clock
clk_wiz_0 clk_wiz_0(
    .clk_in1(clock),
    .clk_out1(master_clk)
    );




endmodule