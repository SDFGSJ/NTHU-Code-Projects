module LFSR (
    input clk,
    input rst,
    input [3:0] seed,
    output reg [3:0] random
);

always @(posedge clk, posedge rst) begin
    if (rst)
        random <= seed;
    else begin
        random[2:0] <= random[3:1];
        random[3] <= random[1] ^ random[0]; 
    end
end
    
endmodule