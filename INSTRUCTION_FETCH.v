`timescale 1ns/1ps

module INSTRUCTION_FETCH(
	clk,
	rst,
	PCout,

	PC,
	IR
);

input clk, rst;
input [31:0] PCout;
output reg 	[31:0] PC, IR;

//instruction memory
reg [31:0] instruction [127:0];

//output instruction
always @(posedge clk or posedge rst)
begin
	if(rst)
		IR <= 32'd0;
	else
		IR <= instruction[PC[10:2]];
end

// output program counter
always @(posedge clk or posedge rst)
begin
	if(rst)
		PC <= 32'd0;
	else//add new PC address here, ex: branch, jump...
		PC <= PC+4;
end

always @(posedge clk) begin
	if (PCout) begin
		$display("Start jumping...");
		PC = PCout;
		
		IR <= 0;
	end
	else begin
		PC <= PC;
	end
end
endmodule