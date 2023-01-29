module AM_gen (
    input clk,
    input rst,
    input [1:0] speed,
    input [2:0] volume,
    input [21:0] note_div_left,
    output reg [15:0] AM_audio
);

reg [15:0] next_AM_audio, AM_audio_abs;
reg [31:0] cnt, global_cnt;
wire [31:0] cnt_max = ((note_div_left >> 1) >> 9) >> 1; //original=9

reg up;
reg [31:0] vol_step;

always @(posedge clk, posedge rst) begin
    if (rst) begin
        cnt <= 0;
        global_cnt <= 0;
        AM_audio <= 1;
        up <= 1;
    end else begin
        cnt <= cnt + 1;
        global_cnt <= global_cnt + 1;

        // up <= 1;
        // if (global_cnt == (note_div_left >> 1)) begin
        //     global_cnt <= 0;
        //     // AM_audio <= next_AM_audio;
        //     up <= ~up;
        // end
        if (global_cnt < note_div_left) begin
            if (global_cnt < (note_div_left >> 1)) begin
                up <= 1;
            end else begin
                up <= 0;
            end
            if (cnt == cnt_max) begin
                cnt <= 0;
                AM_audio <= next_AM_audio;
            end
        end else begin
            global_cnt <= 0;
            cnt <= 0;
            AM_audio <= 1;
            up <= 1;
        end
    end
end

always @(*) begin
    // next_AM_audio = AM_audio;
    if (up == 1) begin
        if (AM_audio[15] == 1) begin
            next_AM_audio = (~AM_audio + 1) + vol_step;
        end else begin
            next_AM_audio = ~AM_audio + 1;
        end
    end else begin
        if (AM_audio[15] == 1) begin
            next_AM_audio = (~AM_audio + 1) - vol_step;
        end else begin
            next_AM_audio = ~AM_audio + 1;
        end
    end

end

//octave=2:80~150,200,500 nice
//octave=1:250
always @(*) begin
    case (volume)
    /*3'd1: vol_step = 16'h3FFF / cnt_max;
    3'd2: vol_step = 16'h4FFF / cnt_max;
    3'd3: vol_step = 16'h5FFF / cnt_max;
    3'd4: vol_step = 16'h6FFF / cnt_max;
    3'd5: vol_step = 16'h7FFF / cnt_max;*/
    3'd1: vol_step = 80;
    3'd2: vol_step = 120;
    3'd3: vol_step = 150;
    3'd4: vol_step = 200;
    3'd5: vol_step = 250;
    default: vol_step = 87;
    endcase
end


// always @(*) begin
//     if(volume==1) begin
//         AM_audio_abs = (up == 1'b0) ? 16'hF000 : 16'h1000;
//     end else if(volume==2) begin
//         AM_audio_abs = (up == 1'b0) ? 16'hE000 : 16'h2000;
//     end else if(volume==3) begin
//         AM_audio_abs = (up == 1'b0) ? 16'hC000 : 16'h4000;
//     end else if(volume==4) begin
//         AM_audio_abs = (up == 1'b0) ? 16'hB000 : 16'h5000;
//     end else if(volume==5) begin
//         AM_audio_abs = (up == 1'b0) ? 16'hA000 : 16'h6000;
//     end else begin
//         AM_audio_abs = 16'h0000;
//     end
// end

endmodule