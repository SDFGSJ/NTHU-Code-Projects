`timescale 1ns/100ps
module lab2_1_t;
    reg clk,rst;
    wire [5:0] out;
    
    lab2_1 mycounter(clk,rst,out);
    
    always #5 clk = ~clk;
    
    initial begin
        clk=1;
        rst=0;
        #2000
        rst=1;
        #5
        rst=0;
        $monitor($time,": clk=%b, rst=%b, out=%d",clk,rst,out);
    end

    initial begin
        #3000 $finish;
    end
endmodule
