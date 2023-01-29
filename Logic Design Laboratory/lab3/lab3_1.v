module clock_divider #(parameter n=25)(
    input clk,
    output clk_div
);
    reg [n-1:0] num=0;
    wire [n-1:0] next_num;

    always @(posedge clk) begin
        num <= next_num;
    end
    
    assign next_num = num+1;
    assign clk_div = num[n-1];
endmodule


module lab3_1(
    input clk,
    input rst,
    input en,
    input speed,
    output [15:0] led
);

    reg [15:0] led_next=65535,out=65535;
    wire w24,w27,myclk;
    clock_divider #(.n(24)) cd24(.clk(clk), .clk_div(w24));
    clock_divider #(.n(27)) cd27(.clk(clk), .clk_div(w27));
    
    assign led=out;
    assign myclk=(speed==1) ? w27 : w24;
    
    //flipflop
    always @(posedge myclk,posedge rst) begin
        if(rst==1) begin
            out<=65535;
        end else begin
            out<=led_next;
        end
    end

    //combinational block
    always @(*) begin
        if(en==0) begin
            led_next = led;
        end else begin
            led_next = (led) ? 0:65535;
        end
    end
endmodule