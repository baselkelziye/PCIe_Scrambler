module gen3_scrambler(
    input clk_i, input rst_i,
    
    input [3:0] datak_i,training_sequence_i,
    input [1:0] data_len_i,
    input [31:0] indata_i,
    input scramble_enable_i,

    input [2:0] lane_number,
    output [1:0] datak_o, data_len_o,
    output [31:0] scrambled_data_o
  );


wire [22:0] scrambler_seed;
reg  [22:0] g3_lfsr_reg, g3_lfsr_next;
wire [22:0] g3_lfsr1_out, g3_lfsr2_out, g3_lfsr3_out, g3_lfsr4_out;
wire [7:0]  g3_lfsr1_scramble_value, g3_lfsr2_scramble_value, g3_lfsr3_scramble_value, g3_lfsr4_scramble_value;
reg [31:0] scrambled_data_tmp, scrambled_data_reg;
wire [31:0] scrambled_data_next;
assign scrambler_seed = (lane_number == 3'b000) ? 23'h1DBFBC :
                        (lane_number == 3'b001) ? 23'h0607BB :
                        (lane_number == 3'b010) ? 23'h1EC760 :
                        (lane_number == 3'b011) ? 23'h18C0DB :
                        (lane_number == 3'b100) ? 23'h010F12 :
                        (lane_number == 3'b101) ? 23'h19CFC9 :
                        (lane_number == 3'b110) ? 23'h0277CE :
                        (lane_number == 3'b111) ? 23'h1BB807 : 23'h1DBFBC;



always @(posedge clk_i, posedge rst_i) begin
    if(rst_i) begin
        g3_lfsr_reg <= scrambler_seed;
        scrambled_data_reg <= 32'hDEADC0DE;
    end else begin
        g3_lfsr_reg <= g3_lfsr_next;
        scrambled_data_reg <= scrambled_data_next;
    end
end



gen3_lfsr8 lfsr_1st_byte(
        .data_in(indata_i[7:0]),
        .lfsr_reg(g3_lfsr_reg),
        .lfsr_seed(scrambler_seed),
        .scramble_enable_i(scramble_enable_i),
        .lfsr_next(g3_lfsr1_out),
        .scramble_value(g3_lfsr1_scramble_value)
    );

gen3_lfsr8 lfsr_2nd_byte(
        .data_in(indata_i[15:8]),
        .lfsr_reg(g3_lfsr1_out),
        .lfsr_seed(scrambler_seed),
        .scramble_enable_i(scramble_enable_i),
        .lfsr_next(g3_lfsr2_out),
        .scramble_value(g3_lfsr2_scramble_value)
    );

gen3_lfsr8 lfsr_3rd_byte(
        .data_in(indata_i[23:16]),
        .lfsr_reg(g3_lfsr2_out),
        .lfsr_seed(scrambler_seed),
        .scramble_enable_i(scramble_enable_i),
        .lfsr_next(g3_lfsr3_out),
        .scramble_value(g3_lfsr3_scramble_value)
    );

gen3_lfsr8 lfsr_4th_byte(
        .data_in(indata_i[31:24]),
        .lfsr_reg(g3_lfsr3_out),
        .lfsr_seed(scrambler_seed),
        .scramble_enable_i(scramble_enable_i),
        .lfsr_next(g3_lfsr4_out),
        .scramble_value(g3_lfsr4_scramble_value)
    );

gen3_scramble_data gen3_scramble_data_u(
        .data_in(indata_i),
        .lfsr1_scramble_value(g3_lfsr1_scramble_value),
        .lfsr2_scramble_value(g3_lfsr2_scramble_value),
        .lfsr3_scramble_value(g3_lfsr3_scramble_value),
        .lfsr4_scramble_value(g3_lfsr4_scramble_value),
        .datak_i(datak_i),
        .training_sequence_i(training_sequence_i),
        .scramble_enable_i(scramble_enable_i),
        .scrambled_data_o(scrambled_data_next)
    );

    always @*
    begin
      if(data_len_i == 2'b00)
      begin
        scrambled_data_tmp =  {24'b0, scrambled_data_reg[7:0]};
        g3_lfsr_next = g3_lfsr1_out;
      end
      else if(data_len_i == 2'b01)
      begin
        scrambled_data_tmp =  {16'b0, scrambled_data_reg[15:0]};
        g3_lfsr_next = g3_lfsr2_out;
      end
      else if(data_len_i == 2'b10)
      begin
        scrambled_data_tmp = scrambled_data_reg;
        g3_lfsr_next = g3_lfsr4_out;
      end
      else
      begin // should never be reached
        scrambled_data_tmp = 32'hDEADC0DE;
        g3_lfsr_next = 16'hFFFF;
      end
    end

assign datak_o = datak_i;
assign data_len_o = data_len_i;
assign scrambled_data_o = scrambled_data_tmp;

endmodule