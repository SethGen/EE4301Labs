`timescale 1ns / 1ps

module seven_segment(
    input clock_100Mhz, // 100 Mhz clock source on Basys 3 FPGA
    input reset, // reset
    input [31:0] characters,
    input [7:0] loadedChar,
    input [7:0] seg,
    input [2:0] State,
    output reg [3:0] Anode_Activate, // anode signals of the 7-segment LED display
    output reg [7:0] LED_out // cathode patterns of the 7-segment LED display
);

    reg [7:0]LED_BCD;
//    reg [2:0] State;
    reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
    // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    wire [1:0] LED_activating_counter;
    // count     0    ->  1  ->  2  ->  3
    // activates    LED1    LED2   LED3   LED4
    // and repeat

    initial
    begin
    end

    always @(posedge clock_100Mhz or posedge reset)
    begin
        if(reset==1)begin
            refresh_counter <= 0;

        end

        else
            refresh_counter <= refresh_counter + 1;
    end
    assign LED_activating_counter = refresh_counter[19:18];
    // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin      
        case(State)
            3'b110:begin
                case(LED_activating_counter)
                    2'b00: begin
                        Anode_Activate = 4'b0111;
                        LED_BCD = 8'b11110001; //"L"
                    end
                    2'b01: begin
                        Anode_Activate = 4'b1011;
//                        LED_BCD = 8'b11111111;
                        LED_BCD = 8'b11111111;                       
                    end
                    2'b10: begin
                        Anode_Activate = 4'b1101;
                        LED_BCD = 8'b11111111;
                    end
                    2'b11: begin
                        Anode_Activate = 4'b1110;
                        LED_BCD = {seg[7:0]}; //Current Segments
                    end
                endcase
            end

            3'b111:begin
                case(LED_activating_counter)
                    2'b00: begin
                        Anode_Activate = 4'b0111;
                        LED_BCD = 8'b11100010; // "o"
                    end
                    2'b01: begin
                        Anode_Activate = 4'b1011;
                        LED_BCD = 8'b11111111;
                    end
                    2'b10: begin
                        Anode_Activate = 4'b1101;
                        LED_BCD = 8'b11111111;
                    end
                    2'b11: begin
                        Anode_Activate = 4'b1110;
                        LED_BCD = {loadedChar[7:0]}; //Last Char
                    end
                endcase
            end

            default: begin
                case(LED_activating_counter)
                    2'b00: begin
                        Anode_Activate = 4'b0111;
                        // activate LED1 and Deactivate LED2, LED3, LED4
                        LED_BCD = {characters[31:24]};
                        // the first digit of the 16-bit number
                    end
                    2'b01: begin
                        Anode_Activate = 4'b1011;
                        // activate LED2 and Deactivate LED1, LED3, LED4
                        LED_BCD = {characters[23:16]};
                        // the second digit of the 16-bit number
                    end
                    2'b10: begin
                        Anode_Activate = 4'b1101;
                        LED_BCD = {characters[15:8]};
                    end
                    2'b11: begin
                        Anode_Activate = 4'b1110;
                        LED_BCD = {characters[7:0]};
                    end
                endcase
            end
        endcase
        LED_out = LED_BCD;        
    end


endmodule
