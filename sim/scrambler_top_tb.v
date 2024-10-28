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
    wire [31: 0] scrambled_data_o;
	


    scrambler_top scrambler_dut(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .indata_i(indata_i),
        .datak_i(datak_i),
        .data_len_i(data_len_i),
        .scrambled_data_o(scrambled_data_o));
    
    initial begin
        clk_i = 0;
        forever begin
            #5 clk_i = ~clk_i;
        end
    end

    initial begin
    
    rst_i = 1;
    #22;
    rst_i = 0;
    
    @(negedge clk_i)
    indata_i = 32'h0;
    datak_i = 4'b0;
    data_len_i = 2'b00;
	
	@(negedge clk_i)
    indata_i = 32'h00_00_00_BC;
    datak_i = 4'b0_0_0_1;
    data_len_i = 2'b10;
    
    @(negedge clk_i)
    indata_i = 32'h00_1C_00_00;
    datak_i = 4'b0_1_0_0;
    data_len_i = 2'b10;
    
    @(negedge clk_i)
    indata_i = 32'h00_00_00_00;
    datak_i = 4'b0_0_0_0;
    data_len_i = 2'b01;
 //GEN1/2, TESTBENCH   
//   @(posedge clk_i);
//   turnOff = 0;
//   PIPEWIDTH = 8'd8;
//   indata_i = 32'h000000BC;
//   datak_i = 4'b0001;
//   GEN = 3'd1;

//   @(posedge clk_i);
//   turnOff = 0;
//   PIPEWIDTH = 8'd8;
//   indata_i = 32'h00000000;
//   datak_i = 4'd0;
//   GEN = 3'd1;
    
//   @(posedge clk_i);
//   turnOff = 0;
//   PIPEWIDTH = 8'd8;
//   indata_i = 32'h00000000;
//   datak_i = 4'd0;
//   GEN = 3'd1;
    
//   @(posedge clk_i);
//   turnOff = 0;
//   PIPEWIDTH = 8'd8;
//   indata_i = 32'h000000BC;
//   datak_i = 4'b0001;
//   GEN = 3'd1;

//   @(posedge clk_i);
//   turnOff = 0;
//   PIPEWIDTH = 8'd8;
//   indata_i = 32'h00000000;
//   datak_i = 4'd0;
//   GEN = 3'd1;

//************* 16BIT********************


//    @(posedge clk_i);
//     // #5
//     indata_i = 16'h00BC;
//     datak_i = 4'b0001;

//     @(posedge clk_i);
//      indata_i = 16'h0000;
//      datak_i = 4'd0;
    
//     @(posedge clk_i);
//     // #5
//     indata_i = 16'hBC00;
//     datak_i = 4'b0010;

//     @(posedge clk_i);
//     //  #5
//     indata_i = 16'h0000;
//     datak_i = 4'b0000;


//    @(posedge clk_i);
//     // #5
//     indata_i = 16'h00BC;
//     datak_i = 4'b0001;
    
//     @(posedge clk_i);
//     //  #5
//      indata_i = 16'h0000;
//      datak_i = 4'b0000;


//     @(posedge clk_i);
//     //  #5
//     indata_i = 16'h0000;
//     datak_i = 4'd0;
    

//**********************32BIT************************
//      @(posedge clk_i);
//    turnOff = 0;
//    PIPEWIDTH = 8'd32;
//    indata_i = 32'hBC0000BC;
//    datak_i = 4'b0001;
//    GEN = 3'd1;

    // @(posedge clk_i);
    // turnOff = 0;
    // PIPEWIDTH = 8'd8;
    // indata_i = 32'h00000000;
    // datak_i = 4'd0;
    // GEN = 3'd1;
    
//    @(posedge clk_i);
//    turnOff = 0;
//    PIPEWIDTH = 8'd32;
//    indata_i = 32'h0000BC00;
//    datak_i = 4'b0010;
//    GEN = 3'd1;

//    @(posedge clk_i);
//    turnOff = 0;
//    PIPEWIDTH = 8'd16;
//    indata_i = 32'h00000000;
//    datak_i = 4'b0000;
//    GEN = 3'd1;
    
    // @(posedge clk_i);
    // turnOff = 0;
    // PIPEWIDTH = 8'd8;
    // indata_i = 32'h000000BC;
    // datak_i = 4'b0001;
    // GEN = 3'd1;

//    @(posedge clk_i);
//    turnOff = 0;
//    PIPEWIDTH = 8'd32;
//    indata_i = 32'h00000000;
//    datak_i = 4'd0;
//    GEN = 3'd1;


   
    #1200;


    end


endmodule