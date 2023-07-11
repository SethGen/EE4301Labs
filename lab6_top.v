`timescale 1ns / 1ps

module lab6_top(
    output [3:0] Anode_Activate, // anode signals of the 7-segment LED display
    output [7:0] LED_out, // cathode patterns of the 7-segment LED display
    input clk,
    input rst,
    input [7:0] segIn,
    input [2:0] State,
    output[7:0] charCount
);
    wire clk1HZ;
    wire [31:0] characters;
    wire [7:0] loadedChar;
    wire [7:0] seg;
    assign seg = ~segIn;
    slow_clk_1Hz slowCLK(clk, clk1HZ);
    textmover text(rst,clk,clk1HZ,seg,State,characters,loadedChar,charCount);
    seven_segment SEG(clk,rst,characters,loadedChar,seg,State,Anode_Activate,LED_out);

endmodule



//E: 01001111
//4: 00110011
//3: 01111001
//0: 01111110
//1: 00110000
