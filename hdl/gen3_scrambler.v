module gen3_scrambler(
    input         clk_i              ,
    input         rst_i              ,
    input  [3: 0] datak_i            ,
    input  [3: 0] training_sequence_i,
    input  [1: 0] data_len_i         ,
    input  [31:0] indata_i           ,
    input         scramble_enable_i  ,
    input  [2:0 ] lane_number        ,
    output [1:0 ] datak_o            ,
    output [1:0 ] data_len_o         ,
    output [31:0] scrambled_data_o
  );

  localparam LFSR_LENGTH = 23;
  localparam BYTE        = 8;
  localparam CHUNK_SIZE  = 4;
  localparam [1:0] ADVANCE_ONE  = 2'b00,
  ADVANCE_TWO  = 2'b01,
  ADVANCE_FOUR = 2'b10;

  wire [LFSR_LENGTH-1:0]            scrambler_seed;
  reg  [LFSR_LENGTH-1:0]            global_lfsr_reg;
  reg  [LFSR_LENGTH-1:0]            global_lfsr_next;
  wire [LFSR_LENGTH*CHUNK_SIZE-1:0] lfsr_state_reg;
  wire [LFSR_LENGTH*CHUNK_SIZE-1:0] g3_lfsr_out;
  wire [BYTE*CHUNK_SIZE-1:0]        lfsr_scramble_value;
  reg  [31:0]                       scrambled_data_tmp;
  reg  [31:0]                       scrambled_data_reg;
  wire [31:0]                       scrambled_data_next;

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
          global_lfsr_reg    <= 23'h1DBFBC;
          scrambled_data_reg <= 32'hDEADC0DE;
      end else begin
          global_lfsr_reg    <= global_lfsr_next;
          scrambled_data_reg <= scrambled_data_next;
      end
  end

  assign lfsr_state_reg = {g3_lfsr_out[3*LFSR_LENGTH-1:0*LFSR_LENGTH],global_lfsr_reg};

  for(genvar i = 0; i < CHUNK_SIZE; i = i + 1) begin : g3_lfsr_blocks
    gen3_lfsr8 g3_lfsr_u
    (
      .data_in          (indata_i[BYTE*(i+1)-1:BYTE*i]                    ), //1 Byte of Data 
      .lfsr_reg         (lfsr_state_reg[LFSR_LENGTH*(i+1)-1:LFSR_LENGTH*i]),
      .lfsr_seed        (scrambler_seed                                   ),
      .scramble_enable_i(scramble_enable_i                                ),
      .lfsr_next        (g3_lfsr_out[LFSR_LENGTH*(i+1)-1:LFSR_LENGTH*i]   ),
      .scramble_value   (lfsr_scramble_value[BYTE*(i+1)-1:BYTE*i]         )
    );
  end

  gen3_scramble_data gen3_scramble_data_u(
      .data_in            (indata_i           ),
      .lfsr_scramble_value(lfsr_scramble_value),
      .datak_i            (datak_i            ),
      .training_sequence_i(training_sequence_i),
      .scramble_enable_i  (scramble_enable_i  ),
      .scrambled_data_o   (scrambled_data_next)
      );

  //Next state logic and assemble scrambled data
    always @* begin
      case(data_len_i)
      ADVANCE_ONE: begin
        scrambled_data_tmp =  {24'b0, scrambled_data_reg[7:0]}             ;
        global_lfsr_next   = g3_lfsr_out[LFSR_LENGTH*(0+1)-1:LFSR_LENGTH*0]; 
      end
      ADVANCE_TWO: begin
        scrambled_data_tmp =  {16'b0, scrambled_data_reg[15:0]}            ;
        global_lfsr_next   = g3_lfsr_out[LFSR_LENGTH*(1+1)-1:LFSR_LENGTH*1];
      end
      ADVANCE_FOUR: begin
        scrambled_data_tmp = scrambled_data_reg                            ;
        global_lfsr_next   = g3_lfsr_out[LFSR_LENGTH*(3+1)-1:LFSR_LENGTH*3];
      end
      default: begin
        scrambled_data_tmp = 32'hDEADC0DE                                  ;
        global_lfsr_next   = scrambler_seed                                ;
      end
      endcase   
  end

assign datak_o          = datak_i           ;
assign data_len_o       = data_len_i        ;
assign scrambled_data_o = scrambled_data_tmp;

endmodule