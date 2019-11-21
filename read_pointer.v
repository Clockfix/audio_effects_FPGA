module read_pointer(
    output  [4:0]   rptr,
    output          fifo_rd,
    input           rd,
    input           fifo_empty,
    input           clk,
    input           rst_n);  
   
    reg     [4:0]   rptr;  
    
    assign fifo_rd = (~fifo_empty) & rd;  

    always @(posedge clk or negedge rst_n)  
    begin  
        if(~rst_n) rptr <= 'b0;  
        else if(fifo_rd)  
            rptr <= rptr + 'b1;  
        else  
            rptr <= rptr;  
    end  
endmodule 