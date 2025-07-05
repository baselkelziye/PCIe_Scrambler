module gen3_scramble_data(
    input  [31:0] data_in            ,
    input  [31:0] lfsr_scramble_value,
    input  [3:0 ] datak_i            ,
    input         scramble_enable_i  ,
    input  [3:0 ] training_sequence_i,
    output [31:0] scrambled_data_o
  );

  localparam CHUNK = 4;
  localparam BYTE  = 8;

  wire [31:0] scrambled_data_reg;
  wire [31:0] reversed_scramble ;
  wire [3:0 ] do_scramble       ;

  for(genvar i = 0; i < CHUNK; i = i+1) begin :gen3_scramble_block
    assign do_scramble[i] = ~(datak_i[i] | training_sequence_i[i] | ~(scramble_enable_i)); //Do Scramble
    //Bit manipulation to Enable Scrambling
    assign scrambled_data_reg[BYTE*(i+1)-1:i*BYTE] = data_in[BYTE*(i+1)-1:i*BYTE] ^ (lfsr_scramble_value[BYTE*(i+1)-1:i*BYTE] & {BYTE{do_scramble[i]}});
  end

  assign scrambled_data_o = scrambled_data_reg;
endmodule
