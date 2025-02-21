module CPU(clk, memoryData, memoryAddress, dataOut, readSignal, writeSignal, AC);

input clk;
input [15:0] memoryData;
reg [3:0] state;
reg [5:0] PC;
reg [10:0] MAR;
reg signed [15:0] MBR;
reg [3:0] opcode;
reg M;
reg [15:0] IR;
reg zeroFlag, overflowFlag, carryFlag, negativeFlag;
output reg readSignal = 1;
output reg writeSignal = 0;
output reg signed [15:0] AC;
output reg [15:0] dataOut; 
output reg [10:0] memoryAddress;
reg signed [15:0] result;

parameter Load = 4'd1, Store = 4'd2, Add = 4'd3, Sub = 4'd4, Mul = 4'd5, Div = 4'd6 , Branch = 4'd7, BRZ = 4'd8;

/*
 ==============Instrucion Format===============
					"16-bit"
	[15:12]	 [11]  			[10:0]
 _________ ___________________________________
|         |       |                           |
|	4-bit |	1-bit |		11-bit                |
|	 Op	  |   M	  |1-Memory Address/0-Constant|
|_________|_______|___________________________|

*/

initial begin
	PC = 0;
	state = 0;
	AC = 0;
	dataOut = 0;
	zeroFlag = 0;
	overflowFlag = 0;
	carryFlag = 0;
	negativeFlag = 0;
end

always @ (posedge clk) begin
	case (state)
		0: begin // intial state 
			MAR <= PC;
			state = 1;
		end
/******************************************************************************/
		1: begin // fetching from memory
			writeSignal = 0;
			readSignal = 1;
			memoryAddress <= MAR;
			PC <= PC + 1;
			state = 2;
		end
/******************************************************************************/
		2:state = 3; // waiting for next clock
/******************************************************************************/
		3: begin
			MBR <= memoryData;
			state = 4;
		end
/******************************************************************************/
		4: begin
			IR <= MBR;
			state = 5;
		end
/******************************************************************************/
		5: begin // decoding
			opcode <= IR[15:12];
			M <= IR[11];
			MAR <= IR[10:0];
			state = 6;
		end
/******************************************************************************/
		6: begin
				if (opcode == Branch) begin // Branch operation
					PC <= MAR; 
					state = 0;
				end
				else if (opcode == BRZ) begin // BRZ operation if zero flag == 1
					if(zeroFlag == 1 && M == 1) begin
						PC <= MAR;
						state = 0;
					end
					else begin
						state = 0;
					end
				end
				else begin
					state = 7;
				end
		end
/******************************************************************************/
		7: begin
			if (opcode == Store) begin
				memoryAddress <= MAR;
			end
			state = 8;
		end
/******************************************************************************/
		8: begin
			if (opcode == Store) begin //store operation
				writeSignal = 1;
				readSignal = 0;
				dataOut <= AC;
				state = 0;
			end
			else begin
				state = 9;
			end
		end
/******************************************************************************/
		9: begin
			writeSignal = 0;
			readSignal = 1;
			if(M == 1) begin
				memoryAddress <= MAR;
			end
			state = 10;
			end
/******************************************************************************/
		10: begin
			state = 11;
		end
/******************************************************************************/
		11: begin
			if (M == 1) begin
				MBR <= memoryData;
			end
			else if (M == 0) begin
				MBR <= $signed(IR[10:0]);
			end
			state = 12;
		end
/******************************************************************************/
		12: begin // executing 
			if (opcode == Load) begin //load operation
				AC <= MBR;
				state = 0;
			end
			else begin
				case(opcode)
				Add : // Add operation
					begin
					{carryFlag, result} = AC + MBR;
					zeroFlag = (result==0)? 1:0;
					if(AC[15]==MBR[15]) begin
					  if(MBR[15]==result[15])begin
					  overflowFlag = 0;
					  end
					  else begin
					  overflowFlag = 1;
					  end
					end
					else begin
					overflowFlag = 0;
					end						
					negativeFlag =(result[15]==1)? 1:0;	
					end

				Sub : // Sub operation
					begin
					{carryFlag, result} = AC - MBR;
					zeroFlag = (result==0)? 1:0;
					if(AC[15]==MBR[15]) begin
					  if(MBR[15]==result[15])begin
					  overflowFlag = 0;
					  end
					  else begin
					  overflowFlag = 1;
					  end
					end
					else begin
					overflowFlag = 0;
					end
					
					negativeFlag =(result[15]==1)? 1:0;
					end

				Mul : // Mul operation
					begin
					result = AC * MBR;
					
					zeroFlag = (result==0)? 1:0;
					
					if(result > 16'h0FFF || result < 16'hF000) begin
					overflowFlag = 1;
					end
					
					else begin
						overflowFlag = 0;
					end
					
					negativeFlag =(result[15]==1)? 1:0;
					end	
					
				Div : // Div operation
					begin
					result = AC / MBR;
					zeroFlag = (result==0)? 1:0;
					negativeFlag =(result[15]==1)? 1:0;
					end						
					
			endcase //end of arithmetic
			AC <= result;
			state = 0;
			end
		end
	endcase
end
endmodule
