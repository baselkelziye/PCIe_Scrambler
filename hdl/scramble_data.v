module scramble_data(
    input [31:0] data_in,
    input [7:0] lfsr1_scramble_value, lfsr2_scramble_value, lfsr3_scramble_value, lfsr4_scramble_value,
    input [3:0] datak_i,
    input [3:0] training_sequence_i,
    output [31:0] scrambled_data_o
  );

  reg [31:0] scrambled_data_reg;

  //Ordered Sets Control Logic To be Added
  always @*
  begin
    if(datak_i[0] | training_sequence_i[0])
    begin //Control Word Don't Scramble
      scrambled_data_reg[7:0] = data_in[7:0];
    end
    else
    begin //Since the lfsr1_scramble_value[7] is the oldest, its XORed with the first bit of the data (data_in[0])
      scrambled_data_reg[0] = data_in[0] ^ lfsr1_scramble_value[7];
      scrambled_data_reg[1] = data_in[1] ^ lfsr1_scramble_value[6];
      scrambled_data_reg[2] = data_in[2] ^ lfsr1_scramble_value[5];
      scrambled_data_reg[3] = data_in[3] ^ lfsr1_scramble_value[4];
      scrambled_data_reg[4] = data_in[4] ^ lfsr1_scramble_value[3];
      scrambled_data_reg[5] = data_in[5] ^ lfsr1_scramble_value[2];
      scrambled_data_reg[6] = data_in[6] ^ lfsr1_scramble_value[1];
      scrambled_data_reg[7] = data_in[7] ^ lfsr1_scramble_value[0];
    end

    if(datak_i[1] | training_sequence_i[1])
    begin //Control Word  & TS not scrambled Don't Scramble
      scrambled_data_reg[15:8] = data_in[15:8];
    end
    else
    begin
      scrambled_data_reg[8] = data_in[8] ^ lfsr2_scramble_value[7];
      scrambled_data_reg[9] = data_in[9] ^ lfsr2_scramble_value[6];
      scrambled_data_reg[10] = data_in[10] ^ lfsr2_scramble_value[5];
      scrambled_data_reg[11] = data_in[11] ^ lfsr2_scramble_value[4];
      scrambled_data_reg[12] = data_in[12] ^ lfsr2_scramble_value[3];
      scrambled_data_reg[13] = data_in[13] ^ lfsr2_scramble_value[2];
      scrambled_data_reg[14] = data_in[14] ^ lfsr2_scramble_value[1];
      scrambled_data_reg[15] = data_in[15] ^ lfsr2_scramble_value[0];
    end

    if(datak_i[2] | training_sequence_i[2])
    begin //Control Word Don't Scramble
      scrambled_data_reg[23:16] = data_in[23:16];
    end
    else
    begin
      scrambled_data_reg[16] = data_in[16] ^ lfsr3_scramble_value[7];
      scrambled_data_reg[17] = data_in[17] ^ lfsr3_scramble_value[6];
      scrambled_data_reg[18] = data_in[18] ^ lfsr3_scramble_value[5];
      scrambled_data_reg[19] = data_in[19] ^ lfsr3_scramble_value[4];
      scrambled_data_reg[20] = data_in[20] ^ lfsr3_scramble_value[3];
      scrambled_data_reg[21] = data_in[21] ^ lfsr3_scramble_value[2];
      scrambled_data_reg[22] = data_in[22] ^ lfsr3_scramble_value[1];
      scrambled_data_reg[23] = data_in[23] ^ lfsr3_scramble_value[0];
    end

    if(datak_i[3] | training_sequence_i[3])
    begin //Control Word Don't Scramble
      scrambled_data_reg[31:24] = data_in[31:24];
    end
    else
    begin
      scrambled_data_reg[24] = data_in[24] ^ lfsr4_scramble_value[7];
      scrambled_data_reg[25] = data_in[25] ^ lfsr4_scramble_value[6];
      scrambled_data_reg[26] = data_in[26] ^ lfsr4_scramble_value[5];
      scrambled_data_reg[27] = data_in[27] ^ lfsr4_scramble_value[4];
      scrambled_data_reg[28] = data_in[28] ^ lfsr4_scramble_value[3];
      scrambled_data_reg[29] = data_in[29] ^ lfsr4_scramble_value[2];
      scrambled_data_reg[30] = data_in[30] ^ lfsr4_scramble_value[1];
      scrambled_data_reg[31] = data_in[31] ^ lfsr4_scramble_value[0];

    end
  end

  assign scrambled_data_o = scrambled_data_reg;

endmodule
