`timescale 1ns / 1ps

module gen1_lfsr8(
    input      [7:0 ] data_in          ,
    input      [15:0] lfsr8_reg        ,
    input             scramble_enable_i,
    output reg [15:0] lfsr8_next       ,
    output     [7:0 ] scramble_value);
	
  `include "pcie_encodings.vh"
    reg [7:0] scramble_tmp;

  always @(*)
  begin
    scramble_tmp = 8'h00; //Default value
      if(data_in == `COM) begin
        lfsr8_next = 16'hFFFF;
      end else if(data_in == `SKP || (~scramble_enable_i)) begin 
        lfsr8_next = lfsr8_reg;
      end else begin
        lfsr8_next[0 ]  = lfsr8_reg[ 8];
        lfsr8_next[1 ]  = lfsr8_reg[ 9];
        lfsr8_next[2 ]  = lfsr8_reg[10];
        lfsr8_next[3 ]  = lfsr8_reg[ 8] ^ lfsr8_reg[11];
        lfsr8_next[4 ]  = lfsr8_reg[ 8] ^ lfsr8_reg[ 9] ^ lfsr8_reg[12];
        lfsr8_next[5 ]  = lfsr8_reg[ 8] ^ lfsr8_reg[ 9] ^ lfsr8_reg[10] ^ lfsr8_reg[13];
        lfsr8_next[6 ]  = lfsr8_reg[ 9] ^ lfsr8_reg[10] ^ lfsr8_reg[11] ^ lfsr8_reg[14];
        lfsr8_next[7 ]  = lfsr8_reg[10] ^ lfsr8_reg[11] ^ lfsr8_reg[12] ^ lfsr8_reg[15];
        lfsr8_next[8 ]  = lfsr8_reg[ 0] ^ lfsr8_reg[11] ^ lfsr8_reg[12] ^ lfsr8_reg[13];
        lfsr8_next[9 ]  = lfsr8_reg[ 1] ^ lfsr8_reg[12] ^ lfsr8_reg[13] ^ lfsr8_reg[14];
        lfsr8_next[10]  = lfsr8_reg[2] ^ lfsr8_reg[13] ^ lfsr8_reg[14] ^ lfsr8_reg[15];
        lfsr8_next[11]  = lfsr8_reg[3] ^ lfsr8_reg[14] ^ lfsr8_reg[15];
        lfsr8_next[12]  = lfsr8_reg[4] ^ lfsr8_reg[15];
        lfsr8_next[13]  = lfsr8_reg[5];
        lfsr8_next[14]  = lfsr8_reg[6];
        lfsr8_next[15]  = lfsr8_reg[7];
        scramble_tmp[0] = lfsr8_reg[ 15]; //Reverse The Scramble Byte here.
        scramble_tmp[1] = lfsr8_reg[ 14];
        scramble_tmp[2] = lfsr8_reg[ 13];
        scramble_tmp[3] = lfsr8_reg[ 12];
        scramble_tmp[4] = lfsr8_reg[ 11];
        scramble_tmp[5] = lfsr8_reg[ 10];
        scramble_tmp[6] = lfsr8_reg[ 9];
        scramble_tmp[7] = lfsr8_reg[ 8];
      end
  end

	assign scramble_value = scramble_tmp;
endmodule