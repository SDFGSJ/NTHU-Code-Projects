`timescale 1ns/100ps
module lab4_1_t;
    reg clk,rst,en,dir,speedup,speeddown;
    wire [3:0] DIGIT;
    wire [6:0] DISPLAY;
    wire max;
    wire min;

    lab4_1 my(.clk(clk), .rst(rst), .en(en), .dir(dir), .speedup(speedup), .speeddown(speeddown),
                .DIGIT(DIGIT), .DISPLAY(DISPLAY), .max(max), .min(min));

    always #5 clk=~clk;

    initial begin
        clk=0;
        rst=0;
        en=0;
        dir=0;
        speedup=0;
        speeddown=0;
        #100
        en=1;
        
        #500
        rst=1;
        #10
        rst=0;
        
        #10
        en=1;
        #1200
        dir=1;
    end
endmodule