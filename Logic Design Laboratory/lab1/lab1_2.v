`timescale 1ns/100ps
module lab1_2(a,b,aluctr,d);
    input [3:0] a;
    input [1:0] b;
    input [1:0] aluctr;
    output reg [3:0] d;

    wire [3:0] ls;
    wire [3:0] rs;
    lab1_1 mylab1_1_left(.a(a),.b(b),.dir(0),.d(ls));
    lab1_1 mylab1_1_right(.a(a),.b(b),.dir(1),.d(rs));


    always@* begin
        if(aluctr==2'b00) begin
            d=ls;
        end else if(aluctr==2'b01) begin
            d=rs;
        end else if(aluctr==2'b10) begin
            d=a+b;
        end else begin
            d=a-b;
        end
    end

endmodule