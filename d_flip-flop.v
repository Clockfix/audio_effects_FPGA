module d_flipflop_sync_rst(
    input       D,
    output  reg Q,
    input       clk,
    input       reset);

always@(posedge clk, posedge reset)
begin
    if(reset)
        Q <= 1'd0;
    else
        Q <= D;     
end
endmodule