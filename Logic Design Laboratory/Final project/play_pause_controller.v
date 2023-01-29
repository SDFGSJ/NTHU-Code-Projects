module play_pause_controller(
    input clk,
    input rst,
    input play_1p,
    output reg play_or_pause
);
    reg play_pause_next;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            play_or_pause <= 0;
        end else begin
            play_or_pause <= play_pause_next;
        end
    end

    always @(*) begin
        play_pause_next = play_or_pause;
        if(play_1p) begin
            play_pause_next = ~play_or_pause;
        end
    end
endmodule