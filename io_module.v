module io_module #( parameter
    sclk_ws_ratio = 64,         // number of sclk periods per word select period
    mclk_sclk_ratio = 4,        // number of mclk periods per sclk period
    d_width = 24                // data width
)(
    output reset_n,                             //asynchronous active low reset
    input  mclk,                                //master clock
    output ad_sclk,                             //serial clock (or bit clock)
    output ad_ws,                               //word select (or left-right clock)
    output da_sclk,                             //serial clock (or bit clock)
    output da_ws,                               //word select (or left-right clock)
    output sd_tx,                               //serial data transmit
    input  sd_rx,                               //serial data receive

    input signed [d_width-1: 0] l_data_tx,      //left channel data to transmit
    input signed [d_width-1: 0] r_data_tx,      //right channel data to transmit

    output signed [d_width-1: 0] l_data_rx,            //left channel data received
    output signed [d_width-1: 0] r_data_rx,             //right channel data received   

    input btnC,
    
    // // inputs to logic analyzer
    // input           ch0,
    // input           ch1,
    // input           ch2,
    // input           ch3,
    // input           ch4,
    // input           ch5,
    // input           ch6,
    // input           ch7,

    output  [7: 0]  JXADC      // output for logic analizer

    );



i2s_sender  #(
    .mclk_sclk_ratio(mclk_sclk_ratio),      //number of mclk periods per sclk period
    .sclk_ws_ratio(sclk_ws_ratio),          //number of sclk periods per word select period
    .d_width(d_width)                       //data width
) i2s_sender (
    .reset_n(reset_n),      //asynchronous active high reset
    .mclk(mclk),            //master clock
    .sclk(da_sclk),         //serial clock (or bit clock)
    .ws(da_ws),             //word select (or left-right clock)
    .sd_tx(sd_tx),          //serial data transmit
    .l_data_tx(l_data_tx),  //left channel data to transmit
    .r_data_tx(r_data_tx)   //right channel data to transmit
);



i2s_receicer  #(
    .mclk_sclk_ratio(mclk_sclk_ratio),      //number of mclk periods per sclk period
    .sclk_ws_ratio(sclk_ws_ratio),          //number of sclk periods per word select period
    .d_width(d_width)                       //data width
) i2s_receicer (
    .reset_n(reset_n),          //asynchronous active high reset
    .mclk(mclk),                //master clock
    .sclk(ad_sclk),             //serial clock (or bit clock)
    .ws(ad_ws),                //word select (or left-right clock)
    .sd_rx(sd_rx),              //serial data receive
    .l_data_rx(l_data_rx),      //left channel data received
    .r_data_rx(r_data_rx)       //right channel data received
);


// connecting signals to JXADC PMOD to monitor them with signal analyzer
JXADC_controler JXADC_controler(
    .ch0(mclk),
    .ch1(ad_sclk),
    .ch2(ad_ws),
    .ch3(sd_rx),        // serial data in
    .ch4(mclk),
    .ch5(da_sclk),
    .ch6(da_ws),
    .ch7(sd_tx),        // serial data out
    .JXADC(JXADC)       // output for logic analizer   
);

// debounce reset button
debounce_switch debounce_switch_reset(
    .clk(mclk),
    .i_switch(btnC),
    .o_switch(reset_n)
);

endmodule