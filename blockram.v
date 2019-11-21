// Code from:
// Vivado Design Suite
// User Guide
// Synthesis
// UG901 (v2018.3) December 19, 2018
//
// Dual-Port Block RAM with Two Write Ports
// File: blobkram.v

module rams_tdp_rf_rf #( parameter
    DEPTH =  16,
    ADDR_WIDTH = 4, 
    DATA_WIDTH = 24 ) (clka,clkb,ena,enb,wea,web,addra,addrb,dia,dib,doa,dob);

input                       clka,clkb,ena,enb,wea,web;
input   [ADDR_WIDTH-1:0]    addra,addrb;
input   [DATA_WIDTH-1:0]    dia,dib;
output  [DATA_WIDTH-1:0]    doa,dob;
reg     [DATA_WIDTH-1:0]    ram     [ DEPTH - 1 :0];
reg     [DATA_WIDTH-1:0]    doa,dob;

always @(posedge clka)
begin
    if (ena)
    begin
        if (wea)
            ram[addra] <= dia;
            doa <= ram[addra];
        end
    end
always @(posedge clkb)
begin
    if (enb)
    begin
        if (web)
            ram[addrb] <= dib;
            dob <= ram[addrb];
    end
end
endmodule