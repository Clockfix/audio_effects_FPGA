module effect_mixer #( parameter
    data_width = 16          // data width
)(
    input                                       clk,
    input   [1:0]                               sw,
    input                                       reset,
    input                                       i_fifo_full,
    output  signed      [data_width-1: 0]       o_data,
    output                                      o_read_done,            // read from effect module done
    output                                      o_read_ready,           // ready to read from effect module                    
    output                                      o_data_valid,           // data valit to write in FIFO memory
    input                                       i_dv_from_eff,
    input  signed      [data_width-1: 0]    i_data_from_eff_sw0,     // Data output to effects module
    input  signed      [data_width-1: 0]    i_data_from_eff_sw1 
);

//-------------Internal Constants---------------------------
localparam [2:0]        IDLE         = 'd0,
                        ADD          = 'd1,
                        NORM         = 'd2,
                        OUTPUT       = 'd3;

reg [2:0] r_state=IDLE, r_next=IDLE;

reg   signed      [data_width-1: 0]     r_data_sw0 = 'b0;
reg   signed      [data_width-1: 0]     r_data_sw1 = 'b0;

reg   signed      [data_width: 0]       r_data_add = 'b0;

reg   signed      [data_width-1: 0]     r_data_norm = 'b0;

reg     r_read_done = 0;
reg     r_read_ready = 0;
reg     r_data_valid = 0;

assign o_read_done = r_read_done;
assign o_data_valid = r_data_valid;
assign o_data = r_data_norm;


//---------state register sequential always block-----------
always @(posedge clk ) begin
    if (reset == 1) begin
        // clear state
        r_state <= IDLE;
        r_next <= IDLE;
    end
    else begin
        r_state <= r_next;
    end 
end

//----next state & outputs, combinational always block------

always @(posedge clk ) begin
    
    case(r_state)
        IDLE    :   begin
                        if (i_dv_from_eff == 1) begin
                            r_next <= ADD;
                            r_data_sw0 <= i_data_from_eff_sw0;
                            r_data_sw1 <= i_data_from_eff_sw1;

                            r_read_done <= 1;
                            r_read_ready <= 0;
                            r_data_valid <= 0;
                        end
                        else begin
                            r_next <= IDLE;
                            r_read_ready <= 1;     // redy to read data
                            r_data_valid <= 0;
                        end                         
                    end
        ADD     :   begin
                        case ( sw ) 
                            0   :   begin           // off all sound
                                        r_data_add <= 0;    
                                    end
                            1   :   begin           // no effect only             
                                        r_data_add <= r_data_sw0;    
                                    end
                            2   :   begin           // clipping effect only               
                                        r_data_add <= r_data_sw1;
                                    end
                            3   :   begin           // no effect and clipping effect               
                                        r_data_add <= r_data_sw0 + r_data_sw1;
                                    end                
                        endcase
                        r_next <= NORM;
                        r_read_done <= 0; 
                    end
        NORM    :   begin
                        case ( sw ) 
                            0   :   begin           // off all sound
                                        r_data_norm <= 0;    
                                    end
                            1   :   begin           // no effect only             
                                        r_data_norm <= r_data_add[data_width-1: 0];    
                                    end
                            2   :   begin           // clipping effect only               
                                        r_data_norm <= r_data_add[data_width-1: 0];
                                    end
                            3   :   begin           // no effect and clipping effect               
                                        r_data_norm <= r_data_add[data_width  : 1] ;     // Shift Right
                                    end                
                        endcase
                        r_next <= OUTPUT;
                    end
        OUTPUT  :   begin
                        if ((i_fifo_full == 1) & (i_dv_from_eff == 1)) begin     // wait for FIFO memory and data valid in effect module 
                            r_next          <= OUTPUT;
                            r_read_done     <= 0;
                            r_read_ready    <= 0;
                            r_data_valid    <= 0;
                        end
                        else begin
                            r_next          <= IDLE;
                            r_read_ready    <= 0;     // redy to read data
                            r_data_valid    <= 1;       // data valid to write in FIFO
                        end  
                    end
        default: r_next <= IDLE;          // on error
    endcase 
end




endmodule