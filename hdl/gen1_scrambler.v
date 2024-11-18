module gen1_scrambler(
    input clk_i, input rst_i,

    input [3:0] datak_i,training_sequence_i,
    input [1:0] data_len_i,
    input [31:0] indata_i,
    input scramble_enable_i,

    output [1:0] datak_o, data_len_o,
    output [31:0] scrambled_data_o
  );



  reg [31:0] scrambled_data_reg, scrambled_data_tmp;
  wire [31:0] scrambled_data_next;


  //Gen1/2 Variables
  reg [15:0] g1_lfsr_reg, g1_lfsr_next;
  wire [15:0] g1_lfsr1_out, g1_lfsr2_out, g1_lfsr3_out, g1_lfsr4_out;
  wire [7:0] lfsr1_scramble_value, lfsr2_scramble_value, lfsr3_scramble_value, lfsr4_scramble_value;

  //Gen3 Variables

  always @(posedge clk_i, posedge rst_i)
  begin
    if(rst_i)
    begin
      g1_lfsr_reg <= 16'hFFFF;
      scrambled_data_reg <= 32'hFFFF;
    end
    else
    begin
      g1_lfsr_reg <= g1_lfsr_next;
      scrambled_data_reg <= scrambled_data_next;
    end
  end

  gen1_lfsr8 lfsr_1st_byte(
          .data_in(indata_i[7:0]),
          .lfsr8_reg(g1_lfsr_reg),
          .scramble_enable_i(scramble_enable_i),
          .lfsr8_next(g1_lfsr1_out),
          .scramble_value(lfsr1_scramble_value)
        );

  gen1_lfsr8 lfsr_2nd_byte(
          .data_in(indata_i[15:8]),
          .lfsr8_reg(g1_lfsr1_out),
          .scramble_enable_i(scramble_enable_i),
          .lfsr8_next(g1_lfsr2_out),
          .scramble_value(lfsr2_scramble_value));

  gen1_lfsr8 lfsr_3rd_byte(
          .data_in(indata_i[23:16]),
          .lfsr8_reg(g1_lfsr2_out),
          .scramble_enable_i(scramble_enable_i),
          .lfsr8_next(g1_lfsr3_out),
          .scramble_value(lfsr3_scramble_value));

  gen1_lfsr8 lfsr_4th_byte(
          .data_in(indata_i[31:24]),
          .lfsr8_reg(g1_lfsr3_out),
          .scramble_enable_i(scramble_enable_i),
          .lfsr8_next(g1_lfsr4_out),
          .scramble_value(lfsr4_scramble_value));


  gen1_scramble_data gen1_scramble_data_u(
                  .data_in(indata_i),
                  .lfsr1_scramble_value(lfsr1_scramble_value),
                  .lfsr2_scramble_value(lfsr2_scramble_value),
                  .lfsr3_scramble_value(lfsr3_scramble_value),
                  .lfsr4_scramble_value(lfsr4_scramble_value),
                  .datak_i(datak_i),
                  .scramble_enable_i(scramble_enable_i),
                  .training_sequence_i(training_sequence_i),
                  .scrambled_data_o(scrambled_data_next));

  //Next state logic and assemble scrambled data
  // The next state Logic may be faulti, the tmp and next variables might need to be swapped
  always @*
  begin
    if(data_len_i == 2'b00)
    begin
      scrambled_data_tmp =  {24'b0, scrambled_data_reg[7:0]};
      g1_lfsr_next = g1_lfsr1_out;
    end
    else if(data_len_i == 2'b01)
    begin
      scrambled_data_tmp =  {16'b0, scrambled_data_reg[15:0]};
      g1_lfsr_next = g1_lfsr2_out;
    end
    else if(data_len_i == 2'b10)
    begin
      scrambled_data_tmp = scrambled_data_reg;
      g1_lfsr_next = g1_lfsr4_out;
    end
    else
    begin // should never be reached
      scrambled_data_tmp = 32'hDEADC0DE;
      g1_lfsr_next = 16'hFFFF;
    end
  end

  assign datak_o = datak_i;
  assign data_len_o = data_len_i;
  assign scrambled_data_o = scrambled_data_tmp;


endmodule
