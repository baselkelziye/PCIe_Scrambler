module gen3_scramble_data(
    input [31:0] data_in,
    input [7:0] lfsr1_scramble_value, lfsr2_scramble_value, lfsr3_scramble_value, lfsr4_scramble_value,
    input [3:0] datak_i,
    input scramble_enable_i,
    input [3:0] training_sequence_i,
    output [31:0] scrambled_data_o
  );

  reg [31:0] scrambled_data_reg;

  //Ordered Sets Control Logic To be Added
  always @*
  begin
    if(datak_i[0] | training_sequence_i[0] | (~scramble_enable_i))
    begin //Control Word Don't Scramble
      scrambled_data_reg[7:0] = data_in[7:0];
    end
    else
    begin 
      scrambled_data_reg[7:0] = data_in[7:0] ^ lfsr1_scramble_value;
    end

    if(datak_i[1] | training_sequence_i[1] | (~scramble_enable_i))
    begin //Control Word  & TS not scrambled Don't Scramble
      scrambled_data_reg[15:8] = data_in[15:8];
    end
    else
    begin
      scrambled_data_reg[15:8] = data_in[15:8] ^ lfsr2_scramble_value;
    end

    if(datak_i[2] | training_sequence_i[2] | (~scramble_enable_i))
    begin //Control Word Don't Scramble
      scrambled_data_reg[23:16] = data_in[23:16];
    end
    else
    begin
      scrambled_data_reg[23:16] = data_in[23:16] ^ lfsr3_scramble_value;
    end

    if(datak_i[3] | training_sequence_i[3] | (~scramble_enable_i))
    begin //Control Word Don't Scramble
      scrambled_data_reg[31:24] = data_in[31:24];
    end
    else
    begin
      scrambled_data_reg[31:24] = data_in[31:24] ^ lfsr4_scramble_value;
    end
  end

  assign scrambled_data_o = scrambled_data_reg;

endmodule
