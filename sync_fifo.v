// Fifo code source:
// https://vlsicoding.blogspot.com/2013/11/verilog-code-for-synchronous-fifo.html
// 
module sync_fifo #( parameter
//---------------parametre declaration
   data_width       = 4,
   address_width    = 4,
   ram_depth        = 16         // must be 2^n
)(
//--------------input output port declaration
   output reg signed [data_width-1:0]  data_out,
   output                        full,
   output                        empty,
   output  [address_width-1:0]     data_fill,
   input signed  [data_width-1:0]  data_in,
   input                         w_clk,      // write clock
   input                         r_clk,      // read clock
   input                         reset,
   input                         wr_en,
   input                         rd_en);
 

//--------------internal register declaration
reg      [address_width-1:0]     wr_pointer = 0;
reg      [address_width-1:0]     rd_pointer = 0;
// reg      [address_width :0]      status_count = 0;
wire  signed   [data_width-1:0]        data_ram ;

// reg addition = 0;
// reg subtractor = 0; 

// always@(posedge addition )
// begin
//    if (addition ^ subtractor)    // if XOR
//    begin  
//       if (status_count != 0) 
//                status_count = status_count + 1;  
//    end
//    addition = 0;        // reset addition 
// end

// always@(posedge subtractor)
// begin
//    if (addition ^ subtractor)    // if XOR
//    begin
//       if (status_count != 0) 
//                status_count = status_count - 1;  
//    end 
//    subtractor = 0;      // reset subtractor
// end
 
//--------------wr_pointer pointing to write address
   always @ (posedge w_clk,posedge reset)
   begin
      if(reset)
         wr_pointer = 0;
      else if(wr_en)
         wr_pointer = wr_pointer+1;
         //addition = 1;
   end
//-------------rd_pointer points to read address
   always @ (posedge r_clk,posedge reset)
   begin
      if(reset)
         rd_pointer = 0;
      else if(rd_en)
         rd_pointer = rd_pointer + 1;
         //subtractor = 1;
   end
//-------------read from FIFO
   always @ (posedge r_clk,posedge reset)
   begin
      if(reset)
         data_out=0;
      else if(rd_en)
         data_out=data_ram;
   end

// //--------------Status pointer for full and empty checking
//    always @ (posedge w_clk,posedge r_clk,posedge reset)
//    begin
//       if(reset)
//          status_count = 0;
//       else if(wr_en && !rd_en && (status_count != ram_depth))
//          status_count = status_count + 1;
//       else if(rd_en && !wr_en && (status_count != 0))
//          status_count = status_count - 1;
//    end // always @ (posedge clk,posedge reset)


// assign full = (status_count == (ram_depth));
// assign empty = (status_count == 0);
// assign data_fill = status_count;       // how full are FIFO

assign full = (wr_pointer - rd_pointer  == ram_depth) ? 1'b1 : 1'b0 ;
assign empty = (wr_pointer - rd_pointer == 0) ? 1'b1 : 1'b0 ;
assign data_fill = wr_pointer - rd_pointer ;       // how full are FIFO
 
rams_tdp_rf_rf #( 
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
   .clka(w_clk),
   .clkb(r_clk)
);

endmodule // sync_fifo

