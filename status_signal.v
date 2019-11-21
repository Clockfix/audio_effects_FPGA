module status_signal(
    output          fifo_full, 
    output          fifo_empty, 
    output          fifo_threshold, 
    output          fifo_overflow, 
    output          fifo_underflow, 
    input           wr, 
    input           rd, 
    input           fifo_we, 
    input           fifo_rd, 
    input   [4:0]   wptr,
    input   [4:0]   rptr,
    input           clk,
    input           rst_n);  
 
    wire    fbit_comp, 
            overflow_set, 
            underflow_set;  
    wire    pointer_equal;  
    wire    [4:0]   pointer_result;  
    reg     fifo_full, 
            fifo_empty, 
            fifo_threshold, 
            fifo_overflow, 
            fifo_underflow;  

    assign fbit_comp = wptr[4] ^ rptr[4];  
    assign pointer_equal = (wptr[3:0] - rptr[3:0]) ? 0 : 1;  
    assign pointer_result = wptr[4:0] - rptr[4:0];  
    assign overflow_set = fifo_full & wr;  
    assign underflow_set = fifo_empty & rd; 

    always @(*)  
    begin  
        fifo_full = fbit_comp & pointer_equal;  
        fifo_empty = (~fbit_comp) & pointer_equal;  
        fifo_threshold = (pointer_result[4]||pointer_result[3]) ? 1:0;  
    end  

    always @(posedge clk or negedge rst_n)  
    begin  
        if(~rst_n) fifo_overflow <=0;  
        else if((overflow_set==1)&&(fifo_rd==0))  
            fifo_overflow <=1;  
        else if(fifo_rd)  
            fifo_overflow <=0;  
        else  
            fifo_overflow <= fifo_overflow;  
    end 

    always @(posedge clk or negedge rst_n)  
    begin  
        if(~rst_n) fifo_underflow <=0;  
        else if((underflow_set==1)&&(fifo_we==0))  
            fifo_underflow <=1;  
        else if(fifo_we)  
            fifo_underflow <=0;  
        else  
            fifo_underflow <= fifo_underflow;  
    end  
endmodule  