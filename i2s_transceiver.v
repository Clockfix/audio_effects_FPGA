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
//
// As such, the word select (or left-right clock) frequency 
// is 44.1 kHz, the serial clock frequency is 44.1 kHz * 64 = 2.82 MHz, 
// and the master clock frequency is 2.82 MHz * 4 = 11.29 MHz.  
// Table 1, Section 4.1 of the CS4344 Datasheet confirms this 
// selection, listing 11.29 MHz as a common frequency 
// for the master clock when the LRCK is 44.1 kHz.
//
//  Module is created from sample provided by 
//  Digilent
//


module i2s_transceiver #( parameter
    sclk_ws_ratio = 64,         // number of sclk periods per word select period
    mclk_sclk_ratio = 4,        // number of mclk periods per sclk period
    d_width = 24                // data width
)(
    input  reset_n,                             //asynchronous active low reset
    input  mclk,                                //master clock
    output sclk,                                //serial clock (or bit clock)
    output ws,                                  //word select (or left-right clock)
    output sd_tx,                               //serial data transmit
    input  sd_rx,                               //serial data receive
    input signed [d_width-1: 0] l_data_tx,            //left channel data to transmit
    input signed [d_width-1: 0] r_data_tx,            //right channel data to transmit
    output signed [d_width-1: 0] l_data_rx,            //left channel data received
    output signed [d_width-1: 0] r_data_rx             //right channel data received   
    
    );

reg sclk_int = 0;                       //internal serial clock wire
reg ws_int = 0;                         //internal word select wire
reg signed [d_width-1: 0] l_data_rx_int = 0;   //internal left channel rx data buffer
reg signed [d_width-1: 0] r_data_rx_int = 0;   //internal right channel rx data buffer
reg signed [d_width-1: 0] l_data_tx_int = 0;   //internal left channel tx data buffer
reg signed [d_width-1: 0] r_data_tx_int = 0;   //internal right channel tx data buffer

reg r_sd_tx = 0;                        //internal register 
reg signed [d_width-1: 0] reg_r_data_rx = 0;
reg signed [d_width-1: 0] reg_l_data_rx = 0; 


reg [2: 0] sclk_cnt = 0;  //counter of master clocks during half period of serial clock
reg [7: 0] ws_cnt   = 0;  //counter of serial clock toggles during half period of word select



always@(posedge mclk, posedge reset_n) begin

    if (reset_n == 1) begin
        sclk_cnt <= 'b0;                  //clear mclk/sclk counter
        ws_cnt <= 'b0;                    //clear sclk/ws counter
        sclk_int <= 0;                  //clear serial clock signal
        ws_int <= 0;                    //clear word select signal
        l_data_rx_int <= 'b0;           //clear internal left channel rx data buffer
        r_data_rx_int <= 'b0;           //clear internal right channel rx data buffer
        l_data_tx_int <= 'b0;           //clear internal left channel tx data buffer
        r_data_tx_int <= 'b0;           //clear internal right channel tx data buffer
        r_sd_tx <= 0;                   //clear serial data transmit output
        reg_l_data_rx <= 'b0;           //clear left channel received data output
        reg_r_data_rx <= 'b0;           //clear right channel received data output
    end
    else begin                          //master clock rising edge
        if (sclk_cnt < mclk_sclk_ratio/2-1) begin   //less than half period of sclk
            sclk_cnt <= sclk_cnt + 1;               //increment mclk/sclk counter
        end
        else begin                                  //half period of sclk
            sclk_cnt <= 0;                          //reset mclk/sclk counter
            sclk_int <= ~sclk_int;                  //toggle serial clock
            if (ws_cnt < sclk_ws_ratio - 1) begin   //less than half period of ws
                ws_cnt <= ws_cnt + 1;               //increment sclk/ws counter
                if (sclk_int == 0 && ws_cnt > 1 && ws_cnt < d_width * 2 + 2) begin  //rising edge of sclk during data word
                    if (ws_int == 1) begin                                           //right channel
                        r_data_rx_int <= {r_data_rx_int[d_width-2 : 0] , sd_rx};      //shift data bit into right channel rx data buffer
                    end else begin                                                  //left channel
                        l_data_rx_int <= {l_data_rx_int[d_width-2 : 0] , sd_rx};      //shift data bit into left channel rx data buffer
                    end
                end   

                if (sclk_int == 1 && ws_cnt > 1 && ws_cnt < d_width*2+3) begin    //falling edge of sclk during data word
                    if (ws_int == 1) begin                                          //right channel
                        r_sd_tx <= r_data_tx_int[d_width-1];                          //transmit serial data bit
                        r_data_tx_int <= {r_data_tx_int[d_width-2 : 0] , 1'b0};          //shift data of right channel tx data buffer
                    end else begin                                                  //left channel
                        r_sd_tx <= l_data_tx_int[d_width-1];                          //ransmit serial data bit
                        l_data_tx_int <= {l_data_tx_int[d_width-2 : 0] , 1'b0};          //shift data of left channel tx data buffer
                    end
                end 
            end else begin                          //half period of ws
                ws_cnt <= 0;                        //reset sclk/ws counter
                ws_int <= ~ws_int;                  //toggle word select
//               reg_r_data_rx <= r_data_rx_int;     //output right channel received data
//               reg_l_data_rx <= l_data_rx_int;     //output left channel received data
                r_data_tx_int <= r_data_tx;         //latch in right channel data to transmit
                l_data_tx_int <= l_data_tx;         //latch in left channel data to transmit
            end
        end
    end
end

assign sclk = sclk_int;             //output serial clock
assign ws = ws_int;                 //output word select
assign sd_tx = r_sd_tx;             //assign sd_tx
//assign r_data_rx = reg_r_data_rx;
//assign l_data_rx = reg_l_data_rx;
assign r_data_rx = ~(ws_cnt < sclk_ws_ratio - 1)? r_data_rx_int: r_data_rx ;
assign l_data_rx = ~(ws_cnt < sclk_ws_ratio - 1)? l_data_rx_int: l_data_rx ;

endmodule