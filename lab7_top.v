`timescale 1ns / 1ps

module lab7_top(
    output [3:0] Anode_Activate, // anode signals of the 7-segment LED display
    output [7:0] LED_out, // cathode patterns of the 7-segment LED display
    input clk,              //100MHz Clock
    input rst,              //Reset
    input [14:0] angle,      //15 bit unsigned angle between 0 - pi/2
    input sel,
    output selLED
//    input CalcButton
);
    wire signed [15:0] sine,cosine,sineDEC,cosDEC;
    wire signed [15:0] x_start, y_start;
    wire signed [31:0] angleIn;
       
    assign angleIn = {2'd0,angle[14:0], 15'd0};
    assign x_start = 32767/1.647;     // == Kn(2^15 - 1)
    assign y_start = 0;
    
   
    assign selLED = sel;
   
    CORDIC calculator(clk, sine, cosine, x_start, y_start, angleIn);
    FixedPointToDecimal sineFP2D(clk,sine,sineDEC);
    FixedPointToDecimal cosFP2D(clk,cosine,cosDEC);
    seven_segment SEG(clk, rst, sel, sineDEC, cosDEC, Anode_Activate,LED_out);
endmodule
