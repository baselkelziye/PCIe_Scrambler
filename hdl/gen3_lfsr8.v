module gen3_lfsr8(
    input [7:0] data_in,
    input [22:0] lfsr_reg, lfsr_seed,
    input scramble_enable_i,
    output reg [22:0] lfsr_next,
    output [7:0] scramble_value
);


reg [7:0] scramble_tmp;

always @(*) begin
    if(data_in == `COM) begin
        lfsr_next    = lfsr_seed;
        scramble_tmp = 8'h00;
      end else if(data_in == `SKP || (~scramble_enable_i)) begin 
        lfsr_next    = lfsr_reg;
        scramble_tmp = 8'h00;
      end else begin
        lfsr_next[0 ] = lfsr_reg[15] ^ lfsr_reg[17] ^ lfsr_reg[19] ^ lfsr_reg[21] ^ lfsr_reg[22];
        lfsr_next[1 ] = lfsr_reg[16] ^ lfsr_reg[18] ^ lfsr_reg[20] ^ lfsr_reg[22];
        lfsr_next[2 ] = lfsr_reg[15] ^ lfsr_reg[22];
        lfsr_next[3 ] = lfsr_reg[16];
        lfsr_next[4 ] = lfsr_reg[17];
        lfsr_next[5 ] = lfsr_reg[15] ^ lfsr_reg[17] ^ lfsr_reg[18] ^ lfsr_reg[19] ^ lfsr_reg[21] ^ lfsr_reg[22];
        lfsr_next[6 ] = lfsr_reg[16] ^ lfsr_reg[18] ^ lfsr_reg[19] ^ lfsr_reg[20] ^ lfsr_reg[22];
        lfsr_next[7 ] = lfsr_reg[17] ^ lfsr_reg[19] ^ lfsr_reg[20] ^ lfsr_reg[21];
        lfsr_next[8 ] = lfsr_reg[0 ] ^ lfsr_reg[15] ^ lfsr_reg[17] ^ lfsr_reg[18] ^ lfsr_reg[19] ^ lfsr_reg[20];
        lfsr_next[9 ] = lfsr_reg[1 ] ^ lfsr_reg[16] ^ lfsr_reg[18] ^ lfsr_reg[19] ^ lfsr_reg[20] ^ lfsr_reg[21];
        lfsr_next[10] = lfsr_reg[2 ] ^ lfsr_reg[17] ^ lfsr_reg[19] ^ lfsr_reg[20] ^ lfsr_reg[21] ^ lfsr_reg[22];
        lfsr_next[11] = lfsr_reg[3 ] ^ lfsr_reg[18] ^ lfsr_reg[20] ^ lfsr_reg[21] ^ lfsr_reg[22];
        lfsr_next[12] = lfsr_reg[4 ] ^ lfsr_reg[19] ^ lfsr_reg[21] ^ lfsr_reg[22];
        lfsr_next[13] = lfsr_reg[5 ] ^ lfsr_reg[20] ^ lfsr_reg[22];
        lfsr_next[14] = lfsr_reg[6 ] ^ lfsr_reg[21];
        lfsr_next[15] = lfsr_reg[7 ] ^ lfsr_reg[22];
        lfsr_next[16] = lfsr_reg[8 ] ^ lfsr_reg[15] ^ lfsr_reg[17] ^ lfsr_reg[19] ^ lfsr_reg[21] ^ lfsr_reg[22];
        lfsr_next[17] = lfsr_reg[9 ] ^ lfsr_reg[16] ^ lfsr_reg[18] ^ lfsr_reg[20] ^ lfsr_reg[22];
        lfsr_next[18] = lfsr_reg[10] ^ lfsr_reg[17] ^ lfsr_reg[19] ^ lfsr_reg[21];
        lfsr_next[19] = lfsr_reg[11] ^ lfsr_reg[18] ^ lfsr_reg[20] ^ lfsr_reg[22];
        lfsr_next[20] = lfsr_reg[12] ^ lfsr_reg[19] ^ lfsr_reg[21];
        lfsr_next[21] = lfsr_reg[13] ^ lfsr_reg[15] ^ lfsr_reg[17] ^ lfsr_reg[19] ^ lfsr_reg[20] ^ lfsr_reg[21];
        lfsr_next[22] = lfsr_reg[14] ^ lfsr_reg[16] ^ lfsr_reg[18] ^ lfsr_reg[20] ^ lfsr_reg[21] ^ lfsr_reg[22];
    
        scramble_tmp[0] = lfsr_reg[22];
        scramble_tmp[1] = lfsr_reg[21];
        scramble_tmp[2] = lfsr_reg[20] ^ lfsr_reg[22];
        scramble_tmp[3] = lfsr_reg[19] ^ lfsr_reg[21];
        scramble_tmp[4] = lfsr_reg[18] ^ lfsr_reg[20] ^ lfsr_reg[22];
        scramble_tmp[5] = lfsr_reg[17] ^ lfsr_reg[19] ^ lfsr_reg[21];
        scramble_tmp[6] = lfsr_reg[16] ^ lfsr_reg[18] ^ lfsr_reg[20] ^ lfsr_reg[22];
        scramble_tmp[7] = lfsr_reg[15] ^ lfsr_reg[17] ^ lfsr_reg[19] ^ lfsr_reg[21] ^ lfsr_reg[22];
    end  
end 

assign scramble_value = scramble_tmp;

endmodule