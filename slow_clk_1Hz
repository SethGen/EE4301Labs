`timescale 1ns / 1ps
module slow_clk_1Hz(
    input clk_in,
    output reg clk_out
    );
    
    reg [56:0] period_count = 0;
    
    always @(posedge clk_in)
    begin
        if(period_count != 50_000_000 - 1)
        begin
            period_count <= period_count +1;
            clk_out <= 0;
        end
        else
        begin
            period_count <= 0;
            clk_out <= 1;
        end
    end  
endmodule
