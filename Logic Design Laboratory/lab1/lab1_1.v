`timescale 1ns/100ps
module lab1_1 (d, a, b, dir);
    input [3:0] a;
    input [1:0] b;
    input dir;
    output reg [3:0] d;

    always@* begin
        if (dir==1'b0) begin
            d = a<<b;
        end else begin
            d = a>>b;
        end
    end
endmodule