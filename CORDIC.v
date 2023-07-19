`timescale 1ns / 1ps
//CORDIC implementation for sine and cosine
module CORDIC(clock, sine, cosine, x_start, y_start, angle);

  parameter width = 16;

  // Inputs
  input clock;
  input signed [width-1:0] x_start,y_start; 
  input signed [31:0] angle;
//  input calcButton;

  // Outputs
  output signed [width-1:0] sine, cosine;

  // Generate table of atan values
  wire signed [31:0] atan_table [0:15];
                          
  assign atan_table[00] = 'b00100000000000000000000000000000; // 45.000 degrees -> atan(2^0)
  assign atan_table[01] = 'b00010010111001000000010100011101; // 26.565 degrees -> atan(2^-1)
  assign atan_table[02] = 'b00001001111110110011100001011011; // 14.036 degrees -> atan(2^-2)
  assign atan_table[03] = 'b00000101000100010001000111010100; // atan(2^-3)
  assign atan_table[04] = 'b00000010100010110000110101000011;
  assign atan_table[05] = 'b00000001010001011101011111100001;
  assign atan_table[06] = 'b00000000101000101111011000011110;
  assign atan_table[07] = 'b00000000010100010111110001010101;
  assign atan_table[08] = 'b00000000001010001011111001010011;
  assign atan_table[09] = 'b00000000000101000101111100101110;
  assign atan_table[10] = 'b00000000000010100010111110011000;
  assign atan_table[11] = 'b00000000000001010001011111001100;
  assign atan_table[12] = 'b00000000000000101000101111100110;
  assign atan_table[13] = 'b00000000000000010100010111110011;
  assign atan_table[14] = 'b00000000000000001010001011111001;
  assign atan_table[15] = 'b00000000000000000101000101111100;

  reg signed [width:0] x [0:width-1];
  reg signed [width:0] y [0:width-1];
  reg signed    [31:0] z [0:width-1];

  always @(posedge clock)
  begin // make sure the rotation angle is in the -pi/2 to pi/2 range
        x[0] <= x_start;
        y[0] <= y_start;
        z[0] <= angle;
  end


  // run through iterations
  genvar i;

  generate
  for (i=0; i < (width-1); i=i+1)
  begin: xyz
    wire z_sign;
    wire signed [width:0] x_shr, y_shr;

    assign x_shr = x[i] >>> i; // signed shift right
    assign y_shr = y[i] >>> i;

    //the sign of the current rotation angle
    assign z_sign = z[i][31];

    always @(posedge clock)
    begin
      // add/subtract shifted data
      x[i+1] <= z_sign ? x[i] + y_shr : x[i] - y_shr;
      y[i+1] <= z_sign ? y[i] - x_shr : y[i] + x_shr;
      z[i+1] <= z_sign ? z[i] + atan_table[i] : z[i] - atan_table[i];
    end
  end
  endgenerate

  // assign output
     assign cosine = x[width-1];
     assign sine = y[width-1];
endmodule
-

