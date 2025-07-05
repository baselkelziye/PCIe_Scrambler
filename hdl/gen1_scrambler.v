module gen1_scrambler(
    input         clk_i,
    input         rst_i,
    input [3:0 ]  datak_i,
    input [3:0 ]  training_sequence_i,
    input [1:0 ]  data_len_i,
    input [31:0]  indata_i,
    input         scramble_enable_i,
    output [1:0 ] datak_o,
    output [1:0 ] data_len_o,
    output [31:0] scrambled_data_o
  );

  localparam       BYTE         = 8;
  localparam       CHUNK_SIZE   = 4;
  localparam       LFSR_LENGTH  = 16;
  localparam [1:0] ADVANCE_ONE  = 2'b00,
                   ADVANCE_TWO  = 2'b01,
                   ADVANCE_FOUR = 2'b10;


  reg [31:0] scrambled_data_reg, scrambled_data_tmp;
  wire [31:0] scrambled_data_next;

  //Use flatter arrays instead of multidimensional.
  reg  [LFSR_LENGTH-1:0] global_lfsr_reg, global_lfsr_next; //LFSR Next, Reg States
  wire [LFSR_LENGTH*CHUNK_SIZE-1:0] lfsr_reg; //4x LFSR Size, for each LFSR
  wire [LFSR_LENGTH*CHUNK_SIZE-1:0] g1_lfsr_out; // The LFSR, Holds 4X LFSR Outputs
  wire [BYTE*CHUNK_SIZE-1:0] lfsr_scramble_value; //The Byte value to scramble data with

  always @(posedge clk_i, posedge rst_i) begin
    if(rst_i) begin
      global_lfsr_reg    <= 16'hFFFF    ;
      scrambled_data_reg <= 32'hDEADC0DE;
    end else begin
      global_lfsr_reg    <= global_lfsr_next   ;
      scrambled_data_reg <= scrambled_data_next;
    end
  end

  assign lfsr_reg = {g1_lfsr_out[3*LFSR_LENGTH-1:0*LFSR_LENGTH], global_lfsr_reg}; //LFSR state INPUTS for each LFSR, First LFSR gets its value from Global LFSR Reg 
 
  //Generate 4 LFSR
  genvar i; 
  for(i = 0; i < CHUNK_SIZE; i = i + 1) begin : gen1_lfsr1_blocks
      gen1_lfsr8 gen1_lfsr_u
      (
        .data_in(indata_i[BYTE*(i+1) - 1: BYTE*i]                  ), //1 Byte of Data
        .lfsr8_reg(lfsr_reg[LFSR_LENGTH*(i+1)-1:LFSR_LENGTH*i]     ), //LFSR Input State
        .scramble_enable_i(scramble_enable_i                       ), 
        .lfsr8_next(g1_lfsr_out[LFSR_LENGTH*(i+1)-1:LFSR_LENGTH*i] ), //LFSR Output State
        .scramble_value(lfsr_scramble_value[BYTE*(i+1) - 1: BYTE*i]) //Byte to Scrambler Data Width
      );
  end


  gen1_scramble_data gen1_scramble_data_u
  (
    .data_in(indata_i                       ),
    .lfsr_scramble_value(lfsr_scramble_value), //4 X Byte Data to scramble Each CHUNK
    .datak_i(datak_i                        ), //Data Control Encoding
    .scramble_enable_i(scramble_enable_i    ), 
    .training_sequence_i(training_sequence_i),
    .scrambled_data_o(scrambled_data_next   )  //The Scrambled Data
    );

  //Next state logic and assemble scrambled data
  always @* begin
    case(data_len_i)
    ADVANCE_ONE: begin
      scrambled_data_tmp =  {24'b0, scrambled_data_reg[7:0]}             ;
      global_lfsr_next   = g1_lfsr_out[LFSR_LENGTH*(0+1)-1:LFSR_LENGTH*0]; 
    end
    ADVANCE_TWO: begin
      scrambled_data_tmp =  {16'b0, scrambled_data_reg[15:0]}            ;
      global_lfsr_next   = g1_lfsr_out[LFSR_LENGTH*(1+1)-1:LFSR_LENGTH*1];
    end
    ADVANCE_FOUR: begin
      scrambled_data_tmp = scrambled_data_reg                            ;
      global_lfsr_next   = g1_lfsr_out[LFSR_LENGTH*(3+1)-1:LFSR_LENGTH*3];
    end
    default: begin
      scrambled_data_tmp = 32'hDEADC0DE;
      global_lfsr_next   = 16'hFFFF    ;
    end
    endcase   
end

  assign datak_o = datak_i;
  assign data_len_o = data_len_i;
  assign scrambled_data_o = scrambled_data_tmp;


endmodule
