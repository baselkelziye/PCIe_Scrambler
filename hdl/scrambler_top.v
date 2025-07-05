module scrambler_top(
    input         clk_i              ,
    input         rst_i              ,
    input         pcie_gen           ,
    input  [3: 0] datak_i            ,
    input  [3: 0] training_sequence_i,
    input  [1: 0] data_len_i         ,
    input  [31:0] indata_i           ,
    input         scramble_enable_i  ,
    output [1: 0] datak_o            ,
    output [1: 0] data_len_o         ,
    output [31:0] scrambled_data_o
  );

  `include "pcie_encodings.vh"
  
  wire [31:0] scrambled_data_gen1;
  wire [31:0] scrambled_data_gen3;

  gen1_scrambler gen1_scrambler_u(
    .clk_i              (clk_i              ),
    .rst_i              (rst_i              ),
    .datak_i            (datak_i            ),
    .training_sequence_i(training_sequence_i),
    .data_len_i         (data_len_i         ),
    .indata_i           (indata_i           ),
    .scramble_enable_i  (scramble_enable_i  ),
    .datak_o            (datak_o            ),
    .data_len_o         (data_len_o         ),
    .scrambled_data_o   (scrambled_data_gen1)
);

  gen3_scrambler gen3_scrambler_u(
    .clk_i              (clk_i              ),
    .rst_i              (rst_i              ),
    .datak_i            (datak_i            ),
    .training_sequence_i(training_sequence_i),
    .data_len_i         (data_len_i         ),
    .indata_i           (indata_i           ),
    .scramble_enable_i  (scramble_enable_i  ),
    .lane_number        (3'b000             ), //TODO: This should be input to top module
    .datak_o            (datak_o            ),
      .data_len_o        (data_len_o         ),
    .scrambled_data_o   (scrambled_data_gen3)
);


assign scrambled_data_o = (pcie_gen == `pcie_gen1) ? scrambled_data_gen1 : scrambled_data_gen3;

endmodule
