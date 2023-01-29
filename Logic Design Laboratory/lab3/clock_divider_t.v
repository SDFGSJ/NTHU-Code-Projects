`timescale 1ns/100ps
module clock_divider_t;
    reg clk;
    wire o_clk;

    clock_divider #(.n(3)) a(.clk(clk), .clk_div(o_clk));

    initial begin
        clk=0;
    end

    always #10 clk=~clk;
endmodule