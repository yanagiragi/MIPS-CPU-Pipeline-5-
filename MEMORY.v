`timescale 1ns/1ps

module MEMORY(
	clk,
	rst,
	ALUout, 	// ALU result from EXECUTION.v address or value to write to XM_RD
	XM_RD,  	// RD From INSTRUCTION_DECODE.v(ID)  address to write back
	XM_RDF,    	// one bit flag controling read DM or not
	XM_RDF2,
	
	
	MW_ALUout, 	// Final ALUout to write back to INSTRUCTION_DECODE.v(WB)
	MW_RD 		// Final RD to write back to INSTRUCTION_DECODE.v(WB)
);
input clk, rst, XM_RDF,XM_RDF2;
input [31:0] ALUout;
input [4:0] XM_RD;


output reg [31:0] MW_ALUout;
output reg [4:0] MW_RD;
reg MW_RDF,MW_RDF2;

//data memory
reg [31:0] DM [0:127];
//reg MW_RDFlagReg; // reg stores flag controling read_DM or not

//send to Dst REG: "load word from data memory" or  "ALUout"
always @(posedge clk)
begin
  if(rst)
    begin
	  MW_ALUout	<=	32'b0;
	  MW_RD		<=	5'b0;

	  MW_RDF    <=  XM_RDF;
	  MW_RDF2    <=  XM_RDF2;
	 
	end
  else
    begin
      MW_RDF    <=  XM_RDF;      	
    	if(XM_RDF) begin // lw & sw    		
    		if(XM_RDF2) begin // lw
    			MW_ALUout <= DM[ALUout[31:0]];
    			MW_RD <= XM_RD;   				
    		end
    		else begin // sw
    			DM[XM_RD] <= ALUout[31:0];
    			MW_RD <= 0;   				
    		end
    	end
    	else begin
    		MW_ALUout	<=	ALUout;
	  		MW_RD		<=	XM_RD;
		end		
    end
end

endmodule
