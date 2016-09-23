`timescale 1ns/1ps

`include "INSTRUCTION_FETCH.v"
`include "INSTRUCTION_DECODE.v"
`include "EXECUTION.v"
`include "MEMORY.v"

module CPU(
	clk,
	rst
);
input clk, rst;
/*============================== Wire  ==============================*/
// INSTRUCTION_FETCH wires
wire [31:0] FD_PC, FD_IR, FD_PC2, PCout;
// INSTRUCTION_DECODE wires
wire [31:0] A, B;
wire [4:0] DX_RD;
wire [2:0] ALUctr;
wire DX_RDF,DX_RDF2;
// EXECUTION wires
wire [31:0] XM_ALUout;
wire [4:0] XM_RD;
wire XM_RDF,XM_RDF2;
// DATA_MEMORY wires
wire [31:0] MW_ALUout;
wire [4:0]	MW_RD;

/*============================== INSTRUCTION_FETCH  ==============================*/

INSTRUCTION_FETCH IF(
	.clk(clk),
	.rst(rst),
	.PCout(PCout),

	.PC(FD_PC),
	.IR(FD_IR)
);

/*============================== INSTRUCTION_DECODE ==============================*/

INSTRUCTION_DECODE ID(
	.clk(clk),
	.rst(rst),
	.PC(FD_PC),
	.IR(FD_IR),
	.MW_RD(MW_RD),
	.MW_ALUout(MW_ALUout),
	

	.A(A),
	.B(B),
	.RD(DX_RD),
	.ALUctr(ALUctr),
	.DX_RDF(DX_RDF),
	.DX_RDF2(DX_RDF2),
	.PC2(PCout)
);

/*==============================     EXECUTION  	==============================*/

EXECUTION EXE(
	.clk(clk),
	.rst(rst),
	.A(A),
	.B(B),
	.DX_RD(DX_RD),
	.ALUctr(ALUctr),
	.DX_RDF(DX_RDF),
	.DX_RDF2(DX_RDF2),
	

	.ALUout(XM_ALUout),
	.XM_RD(XM_RD),
	.XM_RDF(XM_RDF),
	.XM_RDF2(XM_RDF2)
);

/*==============================     DATA_MEMORY	==============================*/

MEMORY MEM(
	.clk(clk),
	.rst(rst),
	.ALUout(XM_ALUout),
	.XM_RD(XM_RD),
	.XM_RDF(XM_RDF),
	.XM_RDF2(XM_RDF2),

	.MW_ALUout(MW_ALUout),
	.MW_RD(MW_RD)
);

endmodule
