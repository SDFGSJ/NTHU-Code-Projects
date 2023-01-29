module clock_divider_100ms #(parameter n = 25'd1000_0000)(
    input clk,
    output clk_div
);
    reg [24:0] num = 0;
    wire [24:0] next_num;

    always @(posedge clk) begin
        if(next_num>=n+1) begin
            num<=0;
        end else begin
            num<=next_num;
        end
    end

    assign next_num = num + 1;
    assign clk_div = (num == n) ? 1 : 0;
endmodule