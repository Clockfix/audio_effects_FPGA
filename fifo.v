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
    wire    [4:0]   w_wptr,
                    w_rptr;  
    wire            w_fifo_we,
                    w_fifo_rd;   

// sub modules
    write_pointer write_pointer(
        .wptr(w_wptr),
        .fifo_we(w_fifo_we),
        .wr(wr),
        .fifo_full(fifo_full),
        .clk(clk),
        .rst_n(rst_n)
    );  

    read_pointer read_pointer(
        .rptr(w_rptr),
        .fifo_rd(w_fifo_rd),
        .rd(rd),
        .fifo_empty(fifo_empty),
        .clk(clk),
        .rst_n(rst_n)
    );  

    memory_array memory_array(
        .data_out(w_data_out), 
        .data_in(w_data_in), 
        .clk(clk),
        .fifo_we(w_fifo_we), 
        .wptr(wptr),
        .rptr(rptr)
    );  


    status_signal status_signal(
        .fifo_full(fifo_full), 
        .fifo_empty(fifo_empty), 
        .fifo_threshold(fifo_threshold), 
        .fifo_overflow(fifo_overflow), 
        .fifo_underflow(fifo_underflow), 
        .wr(wr), 
        .rd(rd), 
        .fifo_we(w_fifo_we), 
        .fifo_rd(w_fifo_rd), 
        .wptr(w_wptr),
        .rptr(w_rptr),
        .clk(clk),
        .rst_n(rst_n)
    );  
endmodule 