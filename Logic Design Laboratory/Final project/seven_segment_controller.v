module seven_segment_controller(
    input display_clk,
    input [2:0] volume,
    input [2:0] octave,
    input [2:0] loop_width,
    output reg [3:0] DIGIT,
    output reg [6:0] DISPLAY
);
    reg [3:0] value;
    always @(posedge display_clk) begin
        case(DIGIT)
            4'b1110: begin
                value = 10;
                DIGIT = 4'b1101;
            end
            4'b1101: begin
                value = volume;
                DIGIT = 4'b1011;
            end
            4'b1011: begin
                value = octave;
                DIGIT = 4'b0111;
            end
            4'b0111: begin
                value = loop_width;
                DIGIT = 4'b1110;
            end
            default: begin
                value = 10;
                DIGIT = 4'b1110;
            end
        endcase
    end
    
    always @(*) begin
        //4'd0~7 means number 0~7
        case(value) //0 means on,1 means off(GFEDCBA)
            4'd0: DISPLAY = 7'b100_0000;
            4'd1: DISPLAY = 7'b111_1001;
            4'd2: DISPLAY = 7'b010_0100;
            4'd3: DISPLAY = 7'b011_0000;
            4'd4: DISPLAY = 7'b001_1001;
            4'd5: DISPLAY = 7'b001_0010;
            4'd6: DISPLAY = 7'b000_0010;
            4'd7: DISPLAY = 7'b111_1000;
            4'd8: DISPLAY = 7'b000_0000;
            4'd9: DISPLAY = 7'b001_0000;
            4'd10: DISPLAY = 7'b011_1111;   //-
            default: DISPLAY = 7'b111_1111;
        endcase
    end
endmodule