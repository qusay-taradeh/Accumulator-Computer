module RAM(input clk, input [10:0] address, input [15:0] data_in, input rd, input wr, output reg[15:0] data_out);

 reg[15:0] Memory[0:63];
 
 initial begin
  Memory[0] = 16'h180A;
  Memory[1] = 16'h580B; 
  Memory[2] = 16'h3005; 
  Memory[3] = 16'h280C; 
  
  Memory[10] = 16'h0009;
  Memory[11] = 16'hFFFC;
  Memory[12] = 16'h0000;
 end
 
 always @(posedge clk) begin
  if (rd) begin
   data_out <= Memory[address];
  end
  
  else if (wr) begin
   Memory[address] <= data_in;
  end
 end
 
 
endmodule
