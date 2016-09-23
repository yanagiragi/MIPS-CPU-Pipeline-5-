`timescale 1ns/1ps

module EXECUTION(
	clk,
	rst,
	A,
	B,
	DX_RD,
	ALUctr,
	DX_RDF,
	DX_RDF2,
	

	ALUout,
	XM_RD,
	XM_RDF,
	XM_RDF2
	
);

input clk,rst,ALUop, DX_RDF,DX_RDF2;
input [31:0] A,B,PC2;
input [4:0]DX_RD;
input [2:0] ALUctr;

output reg [31:0]ALUout;
output reg [4:0]XM_RD;
output reg XM_RDF,XM_RDF2;

//set pipeline register
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  XM_RD	<= 5'd0;
	  XM_RDF <= DX_RDF;
	  XM_RDF2 <= DX_RDF2;
	end 
  else 
	begin
	  XM_RD <= DX_RD;
	end
end

// calculating ALUout
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  ALUout	<= 32'd0;
	end 
  else 
	begin

	  case(ALUctr)
	    3'd0: //add //lw //sw
		  begin
		    XM_RDF <= 0;
	        
	        if(DX_RDF) begin
	        	XM_RDF <= 1;		       		
	        	if(DX_RDF2 == 0) begin // sw
	        			XM_RD <= A;
	        			ALUout <= B;
	        			XM_RDF2 <= 0;
	        		end
	        	else begin// lw
	        		ALUout = A+B;
	        		XM_RDF2 <= 1;
	        	end
	        end
	        else begin ALUout = A+B; end	 		
		  end
		3'd1: //sub
		  begin
            ALUout <= A-B;
            XM_RDF <= 0;
		  end
        3'd4: //slt
            begin
                if(A < B) begin
                    ALUout <= 32'd1;
                end
                else begin
                    ALUout <= 32'd0;
                end
                XM_RDF <= 0;
            end
		3'd2: //beq
		  begin
            
		  end
		3'd3: //j
		  begin
            XM_RDF <= 0;
		  end
		
		3'd7: begin // being bubble to handle j
		 	ALUout <= 0;
            XM_RD <= 0;
            XM_RDF <= 0;
            XM_RDF2 <= 0;
		 end

	  endcase
	end
end
endmodule
	
