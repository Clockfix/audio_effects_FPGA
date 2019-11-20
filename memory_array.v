module memory_array(
    output  [7:0]   data_out, 
    input   [7:0]   data_in, 
    input           clk,
    input           fifo_we, 
    input   [4:0]   wptr,
    input   [4:0]   rptr
);  
     
    reg     [7:0]   data_out2   [15:0];  
    wire    [7:0]   data_out;

    always @(posedge clk)  
    begin  
        if(fifo_we)   
            data_out2[wptr[3:0]] <=data_in ;  
    end  

    assign data_out = data_out2[rptr[3:0]];  
endmodule  