`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2024 08:53:15 AM
// Design Name: 
// Module Name: Scrambler_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module scarambler_top_tb();
    
    
    reg  clk_i;
    reg  rst_i;
    reg  [3:0] datak_i;
    reg [31:0] indata_i;
    reg [1:0] data_len_i;
    reg scramble_enable_i;
    reg [3:0] training_sequence_i;
    wire [31: 0] scrambled_data_o;
    
	localparam T=10;


    scrambler_top scrambler_dut(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .indata_i(indata_i),
        .datak_i(datak_i),
        .data_len_i(data_len_i),
        .scramble_enable_i(scramble_enable_i),
        .training_sequence_i(training_sequence_i),
        .pcie_gen(1'b1),
        .scrambled_data_o(scrambled_data_o));
    
    always 
    begin
    	clk_i = 1'b1;
    	#(T/2);
    	clk_i = 1'b0;
    	#(T/2);
    end
    
    initial begin  
    rst_i = 1;
    #(T/2);
    rst_i = 0;
    end
    
	initial begin
	//D D D COM, 32 Bit Inputs
//	indata_i = 32'h00_00_00_BC; 
//    datak_i = 4'b0_0_0_1;
//    data_len_i = 2'b10;
//    scramble_enable_i = 1'b1;
//    training_sequence_i = 1'b0;
//    @(negedge rst_i) // wait for reset
//	@(negedge clk_i)  //wait for one clock
//	//D SKP SKP SKP, 32 Bit inputs
//	indata_i = 32'h00_1C_1C_1C;
//    datak_i = 4'b0_1_1_1;
//    data_len_i = 2'b10;
//    scramble_enable_i = 1'b1;
//    training_sequence_i = 1'b0;
//    @(negedge clk_i)
//	//D, 8 Bit input
//    indata_i = 32'h00_00_00_00;
//    datak_i = 4'b0_0_0_0;
//    data_len_i = 2'b00;
//    scramble_enable_i = 1'b1;
//    training_sequence_i = 1'b0;
//    @(negedge clk_i)
//    //D D COM D, 32 bit inputs
//    indata_i = 32'h00_00_BC_00;
//    datak_i = 4'b0_0_1_0;
//    data_len_i = 2'b10;
//    scramble_enable_i = 1'b1;
//    training_sequence_i = 1'b0;
//    @(negedge clk_i)
//    // D D 16 bit input
//    indata_i = 32'h00_00_00_00;
//    datak_i = 4'b0_0_0_0;
//    data_len_i = 2'b01;
//    scramble_enable_i = 1'b1;
//    training_sequence_i = 1'b0;
    


//GEN3 
	indata_i = 32'h00_00_00_00; 
    datak_i = 4'b0_0_0_0;
    data_len_i = 2'b00;
    scramble_enable_i = 1'b1;
    training_sequence_i = 4'b0;
    @(negedge rst_i) // wait for reset
   
    #1200;


    end


endmodule
