module textmover(Reset, CLK, CLK1HZ, seg, State, charOut, loadedChar, charCountLED);
    input Reset;
    input CLK;
    input CLK1HZ;
    input [7:0] seg;
    input [2:0] State;
    output reg [31:0] charOut;
    output reg [7:0] loadedChar;
    output reg [7:0] charCountLED;
    reg [7:0] characters [0:20];
    reg [7:0] storedChar;
    reg [7:0] charCount;    
    reg [2:0] curState, prevState;
    reg Sp, selReset;

    integer i, counter;
    
    initial
    begin
        for (i=0; i<=20; i=i+1)
            characters[i] <= 8'b11111111;
        charCount <= 1;
        counter = 0;
    end
    
    
    always @(Reset or State or seg)
    begin
        Sp = 1'b0;              //Flag Initialization
        selReset = 1'b0;
        curState <= State;      //Update State Reg
        

        case (State)
            3'b010:
                selReset <= 1'b1;       //Set Reset Flag
            3'b110 :
            begin
            //Nothing to do here
            end
            3'b111 :
            begin
                if (prevState == 3'b110)

                    Sp <= 1'b1;          //Set Store Flag
            end



            default :
            begin
            //Nothing to do here
            end
        endcase
    end


    always @(posedge CLK1HZ)
    begin
    if(State != 3'b110 && State != 3'b111 && State != 3'b010)
        counter = (counter + 1);
    else
        counter = 0;
    end
    

    always @(posedge CLK)
    begin
        charOut <= {characters[(counter)%charCount],characters[(1+counter)%charCount],characters[(2+counter)%charCount],characters[(3+counter)%charCount]};
        loadedChar <= characters[charCount-1];
        
        prevState  <= curState;

        if (Sp == 1'b1) begin
                characters[charCount] <= {seg[7:0]};
                charCount <= charCount + 1;
                if(charCount > 20)
                    charCount = 20;
            end
        if (selReset == 1'b1) begin
            for (i=0; i<=20; i=i+1)
                characters[i] <= 8'b11111111;
            charCount <= 1;
            end
         charCountLED <= charCount - 1;
    end
endmodule
