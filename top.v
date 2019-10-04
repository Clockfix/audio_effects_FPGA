//      TOP module 
//       
//      
// `include "clock_divider_param.v"
// `include "clock_enable_param.v"


module top #( parameter
    //pattern generator paremater
    SPEED = 300,
    //enable signal parameters
    WAIT = 1,
    WAIT_WIDTH = 2,
)(
    input           clk   
    );

//------internal wires and registers--------
wire w_enable;

wire clk50;    

//-----sub modules--------------------------
clock_enable_param #(
    .WAIT(WAIT),
    .WIDTH(WAIT_WIDTH)
  ) clock_enable1 (
    .clk(clk),
    .enable(w_enable)
);

clock_divider #(
    .DIVIDER(1),
    .WIDTH(3)
) clk50mhz_gen (
    .clk(clk),
    .clk_out(clk50)
);

debounce_switch debounce_switch_reset(
    .clk(clk),
    .i_switch(),
    .o_switch()
);

endmodule