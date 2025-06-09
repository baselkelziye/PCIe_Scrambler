module gen1_scramble_data(
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
  wire [31:0] reversed_scramble;


  genvar x;
  genvar y;
  //Reverse the order of Scramble Value for each Block
  for(y = 0; y < CHUNK; y = y + 1) begin: reverse_scramble_chunks
    for(x = 0; x < BYTE; x = x +1) begin : reverse_scramble_values
      assign reversed_scramble[y*BYTE+x] = lfsr_scramble_value[(y+1)*BYTE-1-x];
    end
  end

  genvar i;
  wire [3:0] do_scramble;
  for(i = 0; i < CHUNK; i = i+1) begin :gen_scramble_block
    assign do_scramble[i] = ~(datak_i[i] | training_sequence_i[i] | ~(scramble_enable_i)); //Do Scramble
    //Bit manipulation to Enable Scrambling
    assign scrambled_data_reg[BYTE*(i+1)-1:i*BYTE] = data_in[BYTE*(i+1)-1:i*BYTE] ^ (reversed_scramble[BYTE*(i+1)-1:i*BYTE] & {BYTE{do_scramble[i]}});
  end

  assign scrambled_data_o = scrambled_data_reg;
endmodule
