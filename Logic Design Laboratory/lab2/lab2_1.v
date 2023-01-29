`timescale 1ns/100ps

module lab2_1(
    input clk,
    input rst,
    output reg [5:0] out
);
    reg [5:0] an=0,an_next=0,previous=0,previous_next=0,n=0,n_next=0;
    reg countup=0;

    //flip-flop:only cares about connection and reset,dont update values
    always @(posedge clk,posedge rst) begin
        if(rst==1) begin
            out <= 0;

            an <= 0;
            previous <= 0;
            n <= 0;
            an_next<=0;
            previous_next<=0;
            n_next<=0;

            countup <= 0;
        end else begin
            out <= an_next;
            an <= an_next;
            previous <= previous_next;
            n <= n_next;
        end
    end

    //combinational logic
    always @(*) begin
        if(countup) begin
            if(n == 0) begin
                an = 0;
            end else if(previous > n) begin
                an = previous - n;
            end else begin
                an = previous + n;
            end
        end else begin
            an = previous - ( 1<<(n-1) );
        end
        an_next = an;
        previous_next = an;
        n_next = n + 1; //remember to increment
    end
    
    always @(*) begin
        if(an == 0) begin
            countup = ~countup;
            if(rst) begin   //reset,next number is 1
                n = 1;
            end else begin  //normal
                n = 0;
            end
            
        end else if(n == 58) begin
            countup = ~countup;
            n = 1;
        end
    end
endmodule