// Fifo code source:
// https://vlsicoding.blogspot.com/2013/11/verilog-code-for-synchronous-fifo.html
// 
module sync_fifo #(
//---------------parametre declaration
   parameter    data_width       = 4,
   parameter    address_width    = 4,
   parameter    ram_depth        = 16 
)(
//--------------input output port declaration
   output reg  [data_width-1:0]  data_out,
   output                        full,
   output                        empty,
   input       [data_width-1:0]  data_in,
   input                         clk,
   input                         rst_a,
   input                         wr_en,
   input                         rd_en);
 

//--------------internal register declaration
reg      [address_width-1:0]     wr_pointer;
reg      [address_width-1:0]     rd_pointer;
reg      [address_width :0]      status_count;
reg      [data_width-1:0]        data_out ;
wire     [data_width-1:0]        data_ram ;


 
//--------------wr_pointer pointing to write address
   always @ (posedge clk,posedge rst_a)
   begin
      if(rst_a)
         wr_pointer = 0;
      else if(wr_en)
         wr_pointer = wr_pointer+1;
   end
//-------------rd_pointer points to read address
   always @ (posedge clk,posedge rst_a)
   begin
      if(rst_a)
         rd_pointer = 0;
      else if(rd_en)
         rd_pointer = rd_pointer+1;
   end
//-------------read from FIFO
   always @ (posedge clk,posedge rst_a)
   begin
      if(rst_a)
         data_out=0;
      else if(rd_en)
         data_out=data_ram;
   end

//--------------Status pointer for full and empty checking
   always @ (posedge clk,posedge rst_a)
   begin
      if(rst_a)
         status_count = 0;
      else if(wr_en && !rd_en && (status_count != ram_depth))
         status_count = status_count + 1;
      else if(rd_en && !wr_en && (status_count != 0))
         status_count = status_count - 1;
   end // always @ (posedge clk,posedge rst_a)


assign full = (status_count == (ram_depth));
assign empty = (status_count == 0);
 
ram #( 
   .DEPTH(ram_depth),
   .ADDR_WIDTH(address_width),
   .DATA_WIDTH(data_width)
) memory1 (
   .addra(wr_pointer),
   .addrb(rd_pointer),
   .dia(data_in),
   .dib(),
   .doa(),
   .dob(data_ram),
   .wea(wr_en),
   .web(1'b0),
   .ena(1'b1),
   .enb(rd_en),
   .clka(clk),
   .clkb(clk)
);

endmodule // sync_fifo

