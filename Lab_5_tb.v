`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2025 03:00:31 PM
// Design Name: 
// Module Name: Lab_5_tb
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

module dot_product_tb;
    parameter CLK_PERIOD = 10;
    reg clk;
    reg btnc;
    reg [15:0] sw;
    wire [15:0] led;
    wire [6:0] seg;
    wire [3:0] an;
    wire dp;
    dot_product uut (
        .clk(clk),
        .btnc(btnc),
        .sw(sw),
        .led(led),
        .seg(seg),
        .an(an),
        .dp(dp)
    );
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end
    
    initial begin
        $dumpfile("dot_product.vcd");
        $dumpvars(0, dot_product_tb);
        btnc = 0;
        #10
        btnc = 1;
        #5000
        btnc = 0;
        #100
        sw = 16'h0000;
        #10;
        sw = {4'b0000, 2'b00, 2'b00, 8'd2};
        #100;
        sw = {4'b0001, 2'b00,2'b00, 8'd2};
        #20;
        sw = {4'b0000, 2'b00,2'b00, 8'd2};
        #100;
        sw = {4'b0010, 2'b00,2'b00, 8'd2};
        #20;
        sw = {4'b0000, 2'b00,2'b00, 8'd2};
        #100;
        sw = {4'b0001, 2'b00,2'b01, 8'd2};
        #20;
        sw = {4'b0000, 2'b00,2'b01, 8'd2};
        #100;
        sw = {4'b0010, 2'b00,2'b01, 8'd2};
        #20;
        sw = {4'b0000, 2'b00,2'b01, 8'd2};
        #100;
        sw = {4'b0001, 2'b00,2'b10, 8'd2};
        #20;
        sw = {4'b0000, 2'b00,2'b10, 8'd2};
        #100;
        sw = {4'b0010, 2'b00,2'b10, 8'd2};
        #20;
        sw = {4'b0000, 2'b00,2'b10, 8'd2};
        #100;
        sw = {4'b0001, 2'b00,2'b11, 8'd2};
        #20;
        sw = {4'b0000, 2'b00,2'b11, 8'd2};
        #100;
        sw = {4'b0010, 2'b00,2'b11, 8'd2};
        #100;
        sw = {4'b1100, 2'b00,2'b00, 8'h00};
        #1000;
        sw = {4'b0001, 2'b00,2'b00, 8'hFF}; #20;
        sw = {4'b0000, 2'b00,2'b00, 8'hFF};
        sw = {4'b0010, 2'b00,2'b00, 8'hFF}; #20;
        sw = {4'b0000, 2'b00,2'b00, 8'hFF};
        sw = {4'b0001, 2'b00,2'b01, 8'hFF}; #20;
        sw = {4'b0000, 2'b00,2'b01, 8'hFF};
        sw = {4'b0010, 2'b00,2'b01, 8'hFF}; #20;
        sw = {4'b0000, 2'b00,2'b01, 8'hFF};
        sw = {4'b0001, 2'b00,2'b10, 8'hFF}; #20;
        sw = {4'b0000, 2'b00,2'b10, 8'hFF};
        sw = {4'b0010, 2'b00,2'b10, 8'hFF}; #20;
        sw = {4'b0000, 2'b00,2'b10, 8'hFF};
        sw = {4'b0001, 2'b00,2'b11, 8'hFF}; #20;
        sw = {4'b0000, 2'b00,2'b11, 8'hFF};
        sw = {4'b0010, 2'b00,2'b11, 8'hFF}; #20;
        sw = {4'b0000, 2'b00,2'b11, 8'hFF};
        #100;
        sw = {4'b1100, 2'b00,2'b00, 8'h00};
        #5000;
    end
endmodule
