module write_pointer(
    output  [4:0]   wptr,
    output          fifo_we,
    input           wr,
    input           fifo_full,
    input           clk,
    input           rst_n);  

    assign fifo_we = (~fifo_full)   &  wr;  

    always @(posedge clk or negedge rst_n)  
    begin  
        if(~rst_n) wptr <= 'b0;  
        else if(fifo_we)  
            wptr <= wptr + 'b1;  
        else  
            wptr <= wptr;  
    end  
endmodule