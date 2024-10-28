module lfsr16(
    input clk_i,    
    input scrambler_reset,
    input system_reset,
    input [1:0] advance,
    output [15:0] lfsr16_value
);

reg [15:0] lfsr_q, lfsr_c;
reg [15:0] data_c;


always @(*) begin

    if(scrambler_reset) begin
        lfsr_q <= 16'hFFFF;
    end 

    lfsr_c[0] = lfsr_q[ 0] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13];
    lfsr_c[1] = lfsr_q[ 1] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14];
    lfsr_c[2] = lfsr_q[ 2] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15];
    lfsr_c[3] = lfsr_q[ 0] ^ lfsr_q[ 3] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15];
    lfsr_c[4] = lfsr_q[ 0] ^ lfsr_q[ 1] ^ lfsr_q[ 4] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[15];
    lfsr_c[5] = lfsr_q[ 0] ^ lfsr_q[ 1] ^ lfsr_q[ 2] ^ lfsr_q[ 5] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15];
    lfsr_c[6] = lfsr_q[ 1] ^ lfsr_q[ 2] ^ lfsr_q[ 3] ^ lfsr_q[ 6] ^ lfsr_q[12] ^ lfsr_q[14];
    lfsr_c[7] = lfsr_q[ 2] ^ lfsr_q[ 3] ^ lfsr_q[ 4] ^ lfsr_q[ 7] ^ lfsr_q[13] ^ lfsr_q[15];
    lfsr_c[8] = lfsr_q[ 3] ^ lfsr_q[ 4] ^ lfsr_q[ 5] ^ lfsr_q[ 8] ^ lfsr_q[14];
    lfsr_c[9] = lfsr_q[ 4] ^ lfsr_q[ 5] ^ lfsr_q[ 6] ^ lfsr_q[ 9] ^ lfsr_q[15];
    lfsr_c[10] = lfsr_q[5] ^ lfsr_q[ 6] ^ lfsr_q[ 7] ^ lfsr_q[10];
    lfsr_c[11] = lfsr_q[6] ^ lfsr_q[ 7] ^ lfsr_q[ 8] ^ lfsr_q[11];
    lfsr_c[12] = lfsr_q[7] ^ lfsr_q[ 8] ^ lfsr_q[ 9] ^ lfsr_q[12];
    lfsr_c[13] = lfsr_q[8] ^ lfsr_q[ 9] ^ lfsr_q[10] ^ lfsr_q[13];
    lfsr_c[14] = lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14];
    lfsr_c[15] = lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15];


    data_c[0] = lfsr_q[15];
    data_c[1] = lfsr_q[14];
    data_c[2] = lfsr_q[13];
    data_c[3] = lfsr_q[12];
    data_c[4] = lfsr_q[11];
    data_c[5] = lfsr_q[10];
    data_c[6] = lfsr_q[9];
    data_c[7] = lfsr_q[8];
    data_c[8] = lfsr_q[7];
    data_c[9] = lfsr_q[6];
    data_c[10] = lfsr_q[5];
    data_c[11] = lfsr_q[4] ^ lfsr_q[15];
    data_c[12] = lfsr_q[3] ^ lfsr_q[14] ^ lfsr_q[15];
    data_c[13] = lfsr_q[2] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15];
    data_c[14] = lfsr_q[1] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14];
    data_c[15] = lfsr_q[0] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13];
    
    
end


always @(posedge clk_i or negedge system_reset) begin
    if(!system_reset) begin
        lfsr_q <= 16'hFFFF;
    end else begin
        lfsr_q <= lfsr_c;
        end
end



assign lfsr16_value = data_c;



endmodule