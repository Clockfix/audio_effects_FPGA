module clipping_effect #( parameter
    data_width = 16          // data width 
)(
    input                                   clk,
    input                                   reset,
    input   signed      [data_width-1: 0]   i_data,
    output  signed      [data_width-1: 0]   o_data,
    input   signed      [data_width-1: 0]   i_treshhold,
    input                                   i_read_done,
    output                                  o_read_enable,
    output                                  o_data_valid,
    input                                   i_data_ready
);

//-------------Internal Constants---------------------------
localparam [1:0]        IDLE         = 'd0,
                        CLIP         = 'd1,
                        OUTPUT       = 'd2,
                        CLEAR        = 'd3;

reg [1:0] r_state=IDLE, r_next=IDLE;

reg   signed      [data_width-1: 0]     r_data = 'b0;
reg         [data_width-1: 0]     r_treshhold_p = 'b0;
reg         [data_width-1: 0]     r_treshhold_n = 'b0;
reg                                     r_read_enable = 0;
reg                                     r_data_valid = 0;

assign  o_read_enable   = r_read_enable;
assign  o_data_valid    = r_data_valid;
assign  o_data          = r_data;


//---------state register sequential always block-----------
always @(posedge clk ) begin
    if (~reset) begin
        r_state <= r_next;
    end 
end

//----next state & outputs, combinational always block------

always @(posedge clk ) begin
    if (reset) begin
        r_next <= IDLE;
        r_read_enable <= 0;     // redy to read data
        r_data_valid <= 0;
    end   
    else begin  
    case(r_state)
        IDLE    :   begin
                        if (i_data_ready == 1) begin
                            r_next <= CLIP;
                            r_data <= i_data;
                            r_treshhold_p <= i_treshhold;
                            r_treshhold_n <= (~i_treshhold) + 1; // two compliment
                            r_read_enable <= 0;
                            r_data_valid <= 0;
                        end
                        else begin
                            r_next <= IDLE;
                            r_read_enable <= 1;     // redy to read data
                            r_data_valid <= 0;
                        end                     
                    end
        CLIP    :   begin
                        case (r_data[data_width-1]) 
                            0   :   begin           // positive number
                                        if (r_data > r_treshhold_p) begin
                                            r_data <= r_treshhold_p; end
                                    end
                            1   :   begin           // negative number               
                                        if (r_data < r_treshhold_n) begin
                                            r_data <= r_treshhold_n; end
                                    end                  
                        endcase
                        r_next <= OUTPUT;
                        r_data_valid <= 0;
                        r_read_enable <= 0;     // read disable
                    end
        OUTPUT  :   begin
                        if (i_read_done == 1) begin
                            r_next <= CLEAR;
                            r_data_valid <= 0;
                            r_read_enable <= 0;
                        end
                        else begin
                            r_next <= OUTPUT;
                            r_data_valid <= 1;
                            r_read_enable <= 0;     // read disable
                        end
                    end
        CLEAR   :   begin
                        r_next <= IDLE;
                        r_data_valid  <= 0;
                        r_read_enable <= 1;
                    end
        default:    begin
                        r_next <= IDLE;          // on error
                    end
    endcase 
    end
end



endmodule