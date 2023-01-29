`timescale 1ns/100ps
module lab3_2_t;
    reg clk,rst,en,dir;
    wire [15:0] led;

    lab3_2 mylab(.clk(clk), .rst(rst), .en(en), .dir(dir), .led(led));

    always #5 clk=~clk;

    initial begin
        clk=0;
        rst=0;
        en=0;
        dir=0;

        #40
        rst=1;
        #10
        rst=0;

        #50
        en=1;

        #200
        dir=1;
        #200
        dir=0;
    end
endmodule