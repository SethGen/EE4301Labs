`timescale 1ns / 1ps

module seven_segment(
    input clock_100Mhz, // 100 Mhz clock source on Basys 3 FPGA
    input reset, // reset
    input selIn,    
    input [15:0]sine, //Sine Value
    input [15:0]cosine, // Cosine Value
    output reg [3:0] Anode_Activate, // anode signals of the 7-segment LED display
    output reg [7:0] LED_out // cathode patterns of the 7-segment LED display
);
    
    reg [15:0] number;
    wire sel;
    assign sel = selIn;
    reg [4:0]LED_BCD;
    reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
    // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    wire [1:0] LED_activating_counter;
    // count     0    ->  1  ->  2  ->  3
    // activates    LED1    LED2   LED3   LED4
    // and repeat

    always @(posedge clock_100Mhz or posedge reset)
    begin
        if(reset==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end
    assign LED_activating_counter = refresh_counter[19:18];
    // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    
    always@(sel or sine or cosine)
        number <= sel ? cosine : sine;
    
    always @(*)
    begin
        case(LED_activating_counter)
            2'b00: begin
                Anode_Activate = 4'b0111;
                // activate LED1 and Deactivate LED2, LED3, LED4
                LED_BCD = sel ? 10 + cosine[15:12] : 10 + sine[15:12];
                // the first digit of the 16-bit number
            end
            2'b01: begin
                Anode_Activate = 4'b1011;
                // activate LED2 and Deactivate LED1, LED3, LED4
                LED_BCD = sel ? cosine[11:8] : sine[11:8];
                // the second digit of the 16-bit number
            end
            2'b10: begin
                Anode_Activate = 4'b1101;
                LED_BCD = sel ? cosine[7:4] : sine[7:4];
                // activate LED3 and Deactivate LED2, LED1, LED4 
            end
            2'b11: begin
                Anode_Activate = 4'b1110;
                LED_BCD = sel ? cosine[3:0] : sine[3:0];
                // activate LED4 and Deactivate LED2, LED3, LED1
            end
        endcase
    end
    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
        case(LED_BCD)
            5'b00000: LED_out = 8'b10000001; // "0"     
            5'b00001: LED_out = 8'b11001111; // "1" 
            5'b00010: LED_out = 8'b10010010; // "2" 
            5'b00011: LED_out = 8'b10000110; // "3" 
            5'b00100: LED_out = 8'b11001100; // "4" 
            5'b00101: LED_out = 8'b10100100; // "5" 
            5'b00110: LED_out = 8'b10100000; // "6" 
            5'b00111: LED_out = 8'b10001111; // "7" 
            5'b01000: LED_out = 8'b10000000; // "8"     
            5'b01001: LED_out = 8'b10000100; // "9"
            5'b01010: LED_out = 8'b00000001; // "0."     
            5'b01011: LED_out = 8'b01001111; // "1." 
            5'b01100: LED_out = 8'b00010010; // "2." 
            5'b01101: LED_out = 8'b00000110; // "3." 
            5'b01110: LED_out = 8'b01001100; // "4." 
            5'b01111: LED_out = 8'b00100100; // "5." 
            5'b10000: LED_out = 8'b00100000; // "6." 
            5'b10001: LED_out = 8'b00001111; // "7." 
            5'b10010: LED_out = 8'b00000000; // "8."     
            5'b10011: LED_out = 8'b00000100; // "9."
            default: LED_out = 8'b11111111; // " "
        endcase
    end
endmodule
