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
// `include "clock_divider_param.v"
// `include "clock_enable_param.v"
// `include "debounce_switch.v"


module top #( parameter
    //enable signal parameters
    WAIT = 1,
    WAIT_WIDTH = 2
)(
    input           clk   
    );

//------internal wires and registers--------
// wire w_enable;
wire clk48k;    
wire clk25M; 

//-----sub modules--------------------------
// clock_enable_param #(
//     .WAIT(WAIT),
//     .WIDTH(WAIT_WIDTH)
//   ) clock_enable1 (
//     .clk(clk),
//     .enable(w_enable)
// );

clock_divider #(
    .DIVIDER(1042),
    .WIDTH(11)
) clk48k_gen (
    .clk(clk),
    .clk_out(clk48k) // 48kHz clock 
);

clock_divider #(
    .DIVIDER(2),
    .WIDTH(2)
) clk25M_gen (
    .clk(clk),
    .clk_out(clk25M) // 25MHz clock 
);

// debounce_switch debounce_switch_reset(
//     .clk(clk),
//     .i_switch(),
//     .o_switch()
// );

endmodule