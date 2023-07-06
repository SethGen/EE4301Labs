`timescale 1ns / 1ps

module CasinoFSM(Rb, Reset, CLK, q, sel, Target, qOut);
     input Rb; 
     input Reset; 
     input CLK; 
     input[7:0] q; 
     output [1:0] sel;
     output [4:0] Target;
     output [7:0] qOut;
     reg Roll;
     reg Win;
     reg Lose;
     reg[4:0] Sum;
     reg[2:0] State; 
     reg[2:0] Nextstate; 
     reg[4:0] Target;
     reg[7:0] qOut;
     reg Sp;
     reg [3:0] qL, qR;
     reg [1:0] selTemp;
     reg selReset;
 initial
         begin
         State = 0;
         Nextstate = 0;
         Target = 0;
         Win = 0;
         Lose = 0;
         selTemp = 2'b11;
         selReset = 1'b0;
         end
 always @(Rb or Reset or State)
        begin
        qL = {q[7:4]};
        qR = {q[3:0]};
        Sp = 1'b0; 
        Roll = 1'b0;
        Win = 1'b0; 
        Lose = 1'b0;     
        Nextstate = 0;
        qOut = q;
        selReset = 1'b0;
    //    selReset = 1'b0;
        case (State)
        0 :
            begin
            Nextstate = 0;
            if (Rb == 1'b1) begin
                Roll = 1'b1; 
                Nextstate = 1; 
                end
            end
        1 :
            begin
            if (Reset == 1'b1) begin
                Nextstate = 0;
                selReset = 1'b1; 
            end        
            Nextstate = 1;
            qOut = Sum; 
            if (Sum > 25) begin
                Nextstate = 2;
            end
            else if (Sum < 5) begin
                Nextstate = 3;
                end
            else begin
                Sp = 1'b1; 
                Nextstate = 4; 
                end
            end
        2 :
            begin
                Win = 1'b1;
                Nextstate = 2;
                qOut = Sum;
                if (Reset == 1'b1) begin
                    Nextstate = 0;
                    selReset = 1'b1; 
                end
            end
        3 :
             begin
                Lose = 1'b1;
                Nextstate = 3;
                qOut = Sum;
                if (Reset == 1'b1) begin
                     Nextstate = 0;
                     selReset = 1'b1; 
                     end
            end
        4 :
            begin
            if (Reset == 1'b1) begin
                Nextstate = 0;
                selReset = 1'b1; 
            end          
            Nextstate = 4;
            if (Rb == 1'b1) begin
                Roll = 1'b1; 
                Nextstate = 5;
                end
            end
        5 :
            begin
            if (Reset == 1'b1) begin
                Nextstate = 0;
                selReset = 1'b1; 
            end          
            Nextstate = 5;
            qOut = Sum;         
    //        if (Rb == 1'b1) begin
    //            Roll = 1'b1; 
    //            end
            if (Sum <= Target) begin
                Nextstate = 4; 
                end
            else if (Sum > 25) begin
                Nextstate = 3; 
                end
            else begin
                Nextstate = 2; 
                end
            end
            default :
            begin
                Nextstate = 0;  
                end
        endcase
        if (selReset == 1'b1)begin
            Win = 1'b0; 
            Lose = 1'b0;     
            Nextstate = 0;
            end
     end
always @(posedge CLK)
    begin
        State <= Nextstate; 
        if (Sp == 1'b1) begin
            Target <= Sum;
        end
        if (Roll == 1'b1)begin
            Sum <= qL + qR;
        end
        if (selReset == 1'b1)begin
            State <= 0;
            Target <= 0;
        end
  end
  always @(Win, Lose, selReset)
    begin
        if(Win == 1'b1)
            selTemp <= 2'b01;
        else if(Lose == 1'b1)
            selTemp <= 2'b10;
        else if(selReset == 1'b1)
            selTemp <= 2'b11;
//        else if (Win != 1'b1 && Lose != 1'b1)
//            selTemp <= 2'b11;
//        sel <= selTemp;
    end
assign sel = selTemp;
endmodule





