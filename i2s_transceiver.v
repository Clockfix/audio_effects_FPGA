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
    sclk_ws_ratio = 64,
    mclk_sclk_ratio = 4
)(
    output          sclk,
    input           mclk,
    output          ws,
    input           sd_rx,
    output          sd_tx    );



endmodule