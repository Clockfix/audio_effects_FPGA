// Sample code from https://www.fpga4student.com/2017/01/verilog-code-for-fifo-memory.html
// with some modifications
module fifo_mem(
    output  [7:0]   data_out,
    output          fifo_full, 
    output          fifo_empty, 
    output          fifo_threshold, 
    output          fifo_overflow, 
    output          fifo_underflow,
    input           clk, 
    input           rst_n, 
    input           wr, 
    input           rd, 
    input   [7:0]   data_in
);  
    wire    [4:0]   wptr,
                    rptr;  
    wire            fifo_we,
                    fifo_rd;   

// sub modules
    write_pointer write_pointer(
        .wptr(wptr),
        .fifo_we(fifo_we),
        .wr(wr),
        .fifo_full(fifo_full),
        .clk(clk),
        .rst_n(rst_n)
    );  

    read_pointer read_pointer(
        .rptr(rptr),
        .fifo_rd(fifo_rd),
        .rd(rd),
        .fifo_empty(fifo_empty),
        .clk(clk),
        .rst_n(rst_n)
    );  

    memory_array memory_array(
        .data_out(data_out), 
        .data_in(data_in), 
        .clk(clk),
        .fifo_we(fifo_we), 
        .wptr(wptr),
        .rptr(rptr)
    );  


    status_signal status_signal(
        .fifo_full(fifo_full), 
        .fifo_empty(fifo_empty), 
        .fifo_threshold(), 
        .fifo_overflow(fifo_overflow), 
        .fifo_underflow(fifo_underflow), 
        .wr(wr), 
        .rd(rd), 
        .fifo_we(fifo_we), 
        .fifo_rd(fifo_rd), 
        .wptr(wptr),
        .rptr(rptr),
        .clk(clk),
        .rst_n(rst_n)
    );  
endmodule 