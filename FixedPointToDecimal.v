`timescale 1ns / 1ps

module FixedPointToDecimal(input clock,
  input signed [15:0] fixedPointInput,
  output reg [15:0] decimalOutput
);

  reg [31:0] temp;
  initial begin
    temp = 0;
    end
  always @(posedge clock)begin
  temp = (fixedPointInput*1000) >> 15;          //Equation for pulling first 3 decimal points out of fractional & adjusting for vals 0-1
  decimalOutput[15:12] <= (temp/1000) % 10;
  decimalOutput[11:8] <= (temp/100) % 10;
  decimalOutput[7:4] <= (temp/10) % 10;
  decimalOutput[3:0] <= (temp) % 10; 
  end
  
endmodule
