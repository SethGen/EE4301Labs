`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


module lfsr (
  output reg [7:0] q,
  input [7:0] seed,
  input clock,
  input rst
);

  reg [7:0] q_temp;

  always @(negedge clock or posedge rst) begin
    if (rst)
      q_temp <= seed;
    else
      q_temp <= {q_temp[6:0], q_temp[1] ^ q_temp[2] ^ q_temp[3] ^ q_temp[7]};
      
      
      q = q_temp;
  end

endmodule
