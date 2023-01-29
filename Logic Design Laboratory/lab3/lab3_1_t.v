//`timescale 1ns/100ps
module lab3_1_t;
    reg clk,rst,en,speed;
    wire [15:0] led;

    lab3_1 mylab(.clk(clk), .rst(rst), .en(en), .speed(0), .led(led));

    always #5 clk=~clk;

    initial begin
        clk=0;
        rst=0;
        en=0;
        speed=0;

        #40
        rst=1;
        #10
        rst=0;

        #50
        en=1;
        #40
        en=0;
        #40
        rst=1;
        #10
        rst=0;
        #200
        en=1;
        #40
        en=0;
    end
endmodule