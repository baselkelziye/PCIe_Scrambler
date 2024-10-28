module scrambler_top(
    input clk_i, input rst_i,

    input [3:0] datak_i,
    input [1:0] data_len_i,
    input [31:0] indata_i,

    output [1:0] datak_o, data_len_o,
    output [31:0] scrambled_data_o
);



reg [31:0] scrambled_data_reg;
wire [31:0] scrambled_data_next;
reg [31:0] scrambled_data_tmp;

reg [15:0] lfsr_reg;
reg [15:0] lfsr_next;

wire [15:0] lfsr1_out, lfsr2_out, lfsr3_out, lfsr4_out;


wire [7:0] lfsr1_scramble_value, lfsr2_scramble_value, lfsr3_scramble_value, lfsr4_scramble_value;

always @(posedge clk_i, posedge rst_i) begin
    if(rst_i) begin
        lfsr_reg <= 16'hFFFF;
        scrambled_data_reg <= 32'hFFFF;
    end else begin
        lfsr_reg <= lfsr_next;
        scrambled_data_reg <= scrambled_data_next;
    end
end

   lfsr8 lfsr_1st_byte(
        .data_in(indata_i[7:0]),
        .lfsr8_reg(lfsr_reg),
        .lfsr8_next(lfsr1_out),
        .scramble_value(lfsr1_scramble_value)
    );

    lfsr8 lfsr_2nd_byte(
        .data_in(indata_i[15:8]),
        .lfsr8_reg(lfsr1_out),
        .lfsr8_next(lfsr2_out),
        .scramble_value(lfsr2_scramble_value)); 

    lfsr8 lfsr_3rd_byte(
        .data_in(indata_i[23:16]),
        .lfsr8_reg(lfsr2_out),
        .lfsr8_next(lfsr3_out),
        .scramble_value(lfsr3_scramble_value));

    lfsr8 lfsr_4th_byte(
        .data_in(indata_i[31:24]),
        .lfsr8_reg(lfsr3_out),
        .lfsr8_next(lfsr4_out),
        .scramble_value(lfsr4_scramble_value));
//Later to be selected from 4x1 depending on data len.
// assign lfsr_next = lfsr1_out;



scramble_data scramble_data_u(
    .data_in(indata_i),
    .lfsr1_scramble_value(lfsr1_scramble_value),
    .lfsr2_scramble_value(lfsr2_scramble_value),
    .lfsr3_scramble_value(lfsr3_scramble_value),
    .lfsr4_scramble_value(lfsr4_scramble_value),
    .datak_i(datak_i),
    .scrambled_data_o(scrambled_data_next));

//Assemble the Output depending on the data_len
always @* begin
    if(data_len_i == 2'b00) begin
        scrambled_data_tmp =  {24'b0, scrambled_data_reg[7:0]}; 
        lfsr_next = lfsr1_out;
    end
    else if(data_len_i == 2'b01) begin
        scrambled_data_tmp =  {16'b0, scrambled_data_reg[15:0]}; 
        lfsr_next = lfsr2_out;
    end
    else if(data_len_i == 2'b10) begin
        scrambled_data_tmp = scrambled_data_reg;
        lfsr_next = lfsr4_out;
    end
    else begin // should never be reached
        scrambled_data_tmp = 32'hDEADC0DE; 
        lfsr_next = 16'hFFFF;
    end
end

assign datak_o = datak_i;
assign data_len_o = data_len_i;
assign scrambled_data_o = scrambled_data_tmp;


endmodule