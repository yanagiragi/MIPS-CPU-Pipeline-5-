`timescale 1ns/1ps

module INSTRUCTION_DECODE(
	clk,
	rst,
	IR,
	PC,
	MW_RD,
	MW_ALUout,

	
	A,
	B,
	RD,
	ALUctr,
	DX_RDF,
	DX_RDF2,
	PC2
);

input clk,rst;
input [31:0]IR, PC, MW_ALUout;
input [4:0] MW_RD;

output reg [31:0] A, B,PC2;
output reg [4:0] RD;
output reg [2:0] ALUctr;
output reg DX_RDF,DX_RDF2;

//register file
reg [31:0] REG [0:31];

//Write back
always @(posedge clk) begin//add new Dst REG source here
	if(MW_RD) begin
		REG[MW_RD] <= MW_ALUout;
		$display("Write %d into REG[%d]",MW_ALUout,MW_RD);
	end
	else
	  REG[MW_RD] <= REG[MW_RD];//keep REG[0] always equal zero
end
//set A, and other register content(j/beq flag and address)	

always @(posedge clk ) begin
	if (rst)
		DX_RDF <= 0;
	else 
		DX_RDF <= DX_RDF;
end

//set control signal, choose Dst REG, and set B	
always @(posedge clk or posedge rst)
begin
	if(rst) 
	  begin
		B 		<=32'b0;
		RD 		<=5'b0; // DX_RD in EXECUTION.v
		ALUctr 	<=3'b0;
		DX_RDF <= 0;
		DX_RDF2 <= 0;
		PC2 <= 0;
	  end 
	else 
	  begin
	 	case(IR[31:26])
		  6'd0://R-Type
		    begin
		      DX_RDF <= 0;
			  case(IR[5:0])//funct & setting ALUctr
				6'd32://add
				  begin
				  	if(IR[25:21]|IR[20:16]|IR[15:11] == 0) begin PC2 <= 0; end
				  	A <= REG[IR[25:21]];
		            B <= REG[IR[20:16]];
		            RD <= IR[15:11];
		            
		            ALUctr <= 3'd0; //self define ALUctr value
				  end
				6'd34://sub
				  begin
					A <= REG[IR[25:21]];
		            B <= REG[IR[20:16]];
		            RD <= IR[15:11];
					ALUctr <= 3'd1; //self define ALUctr value
				  end
				6'd42://slt
				  begin
				  	A <= REG[IR[25:21]];
		            B <= REG[IR[20:16]];
		            RD <= IR[15:11];
                    ALUctr <= 3'd4;
				  end
			  endcase
			end
	      
	      6'd35: begin  //lw
				A	<=  { 16'd0,IR[15:0] };
				B	<=	REG[IR[25:21]];
				RD  <=  IR[20:16];
				ALUctr <= 3'd0;
				DX_RDF <= 1;
				DX_RDF2 <= 1;
			end
	      
	      6'd43://sw
			begin
				A  <=  {REG[IR[25:21]]+{16'b0,IR[15:0]}};
				B  <=  REG[IR[20:16]];
				DX_RDF <= 1;
				DX_RDF2 <= 0;
				ALUctr <= 3'd0;
			end

	      6'd4://beq
			begin
			
			  if( { REG[IR[25:21]] - REG[IR[20:16]] } != 32'b00000_00000_00000_00000_00000_00000_00) begin // not equal
			  		PC2 <= 0;
			  end
			  else begin
			  		if(PC2 == 0) begin
			  			PC2 <= (IR[15])?{ PC - (IR[14:0] << 2 )}:{ PC + (IR[14:0] << 2 )};
			  		end
			  end
			  	
              A <= 0;     
			  DX_RDF <= 0;
			  DX_RDF2 <= 0;
			  B <= 0;
              RD <= 0;
			  ALUctr = 3'd7;	
			end
	      
	      6'd2://j
			begin
			  	PC2 <= {PC + (IR[26:0] << 2 )};// + PC[31:28]};
            	A <= 0;
            	DX_RDF <= 0;
				DX_RDF2 <= 0;
				B <= 0;
            	RD <= 0;
            	ALUctr = 3'd7;	
                
			end
		endcase
	  end
end

always @(posedge clk) begin
	if (PC2) begin
		ALUctr = 3'd7;		
	end
	else 
		PC2 <= PC2;

end
endmodule
