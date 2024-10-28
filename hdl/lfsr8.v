`timescale 1ns / 1ps

module lfsr8(
    input [7:0] data_in,
    input [15:0] lfsr8_reg,
    output reg [15:0] lfsr8_next,
    output [7:0] scramble_value);
	
`include "pcie_encodings.vh"


always @(*)
begin
    if(data_in == `COM) begin
      lfsr8_next = 16'hFFFF;
    end else if(data_in == `SKP) begin 
      lfsr8_next = lfsr8_reg;
    end else begin
      lfsr8_next[0 ] = lfsr8_reg[ 8];
      lfsr8_next[1 ] = lfsr8_reg[ 9];
      lfsr8_next[2 ] = lfsr8_reg[10];
      lfsr8_next[3 ] = lfsr8_reg[ 8] ^ lfsr8_reg[11];
      lfsr8_next[4 ] = lfsr8_reg[ 8] ^ lfsr8_reg[ 9] ^ lfsr8_reg[12];
      lfsr8_next[5 ] = lfsr8_reg[ 8] ^ lfsr8_reg[ 9] ^ lfsr8_reg[10] ^ lfsr8_reg[13];
      lfsr8_next[6 ] = lfsr8_reg[ 9] ^ lfsr8_reg[10] ^ lfsr8_reg[11] ^ lfsr8_reg[14];
      lfsr8_next[7 ] = lfsr8_reg[10] ^ lfsr8_reg[11] ^ lfsr8_reg[12] ^ lfsr8_reg[15];
      lfsr8_next[8 ] = lfsr8_reg[ 0] ^ lfsr8_reg[11] ^ lfsr8_reg[12] ^ lfsr8_reg[13];
      lfsr8_next[9 ] = lfsr8_reg[ 1] ^ lfsr8_reg[12] ^ lfsr8_reg[13] ^ lfsr8_reg[14];
      lfsr8_next[10] = lfsr8_reg[2] ^ lfsr8_reg[13] ^ lfsr8_reg[14] ^ lfsr8_reg[15];
      lfsr8_next[11] = lfsr8_reg[3] ^ lfsr8_reg[14] ^ lfsr8_reg[15];
      lfsr8_next[12] = lfsr8_reg[4] ^ lfsr8_reg[15];
      lfsr8_next[13] = lfsr8_reg[5];
      lfsr8_next[14] = lfsr8_reg[6];
      lfsr8_next[15] = lfsr8_reg[7];
    end
end


	assign scramble_value = lfsr8_reg[15:8];

endmodule