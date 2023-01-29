//keyboard to adjust volume,octave
module volume_octave_controller(
    input clk,
    input rst,
    input [511:0] key_down,
    input [8:0] last_change,
    input key_valid,
    output reg [2:0] volume,
    output reg [2:0] octave
);
    parameter [8:0] KEY_CODES[0:3] = {
        9'b0_0001_1100, //A:1C
        9'b0_0010_0011, //D:23
        9'b0_0001_1101, //W:1D
        9'b0_0001_1011 //S:1B
    };


    reg [2:0] key_num;
    always @ (*) begin
        case(last_change)
            KEY_CODES[0] : key_num = 3'b000;   //A
            KEY_CODES[1] : key_num = 3'b001;   //D
            KEY_CODES[2] : key_num = 3'b010;   //W
            KEY_CODES[3] : key_num = 3'b011;   //S
            default : key_num = 3'b111;
        endcase
    end


    reg [2:0] volume_next, octave_next;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            volume <= 3'd3;
            octave <= 3'd2;
        end else begin
            volume <= volume_next;
            octave <= octave_next;
        end
    end


    always @(*) begin
        volume_next = volume;
        octave_next = octave;

        if(key_valid && key_down[last_change]) begin
            if(key_num!=3'b111) begin
                if(key_num == 3'b000) begin   //A: volume down
                    if(volume==1) begin
                        volume_next = 1;
                    end else begin
                        volume_next = volume-1;
                    end
                end else if(key_num == 3'b001) begin  //D: volume up
                    if(volume==5) begin
                        volume_next = 5;
                    end else begin
                        volume_next = volume+1;
                    end
                end else if(key_num == 3'b010) begin  //W: octave up
                    if(octave==3) begin
                        octave_next = 3;
                    end else begin
                        octave_next = octave+1;
                    end
                end else if(key_num == 3'b011) begin  //S: octave down
                    if(octave==1) begin
                        octave_next = 1;
                    end else begin
                        octave_next = octave-1;
                    end
                end
            end
        end
    end
endmodule