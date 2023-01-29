module note_gen(
    input clk, // clock from crystal
    input rst, // active high reset
    input [2:0] volume, 
    input [21:0] note_div_left, // div for note generation
    input [21:0] note_div_right,
    input is_noise,
    input is_AM,
    input [1:0] speed,
    input [511:0] key_down,
    input [8:0] last_change,
    input key_valid,
    output reg [15:0] audio_left,
    output [15:0] audio_right
);
    //OP[:square wave duty cycle
    parameter [8:0] KEY_CODES[0:2] = {
        9'b0_0100_0100,	//O => 44
		9'b0_0100_1101,	//P => 4D
		9'b0_0101_0100	//[ => 54
    };

    reg [2:0] key_num;
	always @ (*) begin
        case(last_change)
            KEY_CODES[0] : key_num = 3'b000;   //O
            KEY_CODES[1] : key_num = 3'b001;   //P
            KEY_CODES[2] : key_num = 3'b010;   //[
            default : key_num = 3'b111;
        endcase
    end

    reg [9:0] square_duty_cycle;
    reg [9:0] square_duty_cycle_next;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            square_duty_cycle <= 125;
        end else begin
            square_duty_cycle <= square_duty_cycle_next;
        end
    end

    always @(*) begin
        square_duty_cycle_next = square_duty_cycle;
        if(key_valid && key_down[last_change]) begin
            if(key_num != 3'b111) begin
                if (key_num == 3'b000) begin	//O
					square_duty_cycle_next = 125;
				end else if (key_num == 3'b001) begin	//P
					square_duty_cycle_next = 250;
				end else if (key_num == 3'b010) begin	//[
					square_duty_cycle_next = 500;
				end
			end
		end
    end


    wire [3:0] random3, random2, random1, random0;
    LFSR rng3(.clk(clk), .rst(rst), .seed(4'b1010), .random(random3));
    LFSR rng2(.clk(clk), .rst(rst), .seed(4'b1110), .random(random2));
    LFSR rng1(.clk(clk), .rst(rst), .seed(4'b1111), .random(random1));
    LFSR rng0(.clk(clk), .rst(rst), .seed(4'b1100), .random(random0));

    // Declare internal signals
    reg [21:0] note_cnt, noise_cnt;
    reg note_clk, noise_clk;

    wire [31:0] noise_cnt_max = 1_0000_0000 / (random0 << 4);
    wire [31:0] noise_cnt_duty = noise_cnt_max * 125/1000; //60,70,100,125 nice
    always @(posedge clk, posedge rst) begin
        noise_cnt <= noise_cnt + 1;
        if (rst)
            noise_cnt <= 0;
        else begin
            if (noise_cnt < noise_cnt_max) begin
                if (noise_cnt < noise_cnt_duty)
                    noise_clk <= 1; 
                else
                    noise_clk <= 0; 
            end else
                noise_cnt <= 0;
        end
    end

    wire [31:0] note_cnt_duty = note_div_left * square_duty_cycle/1000;
    always @(posedge clk, posedge rst) begin
        note_cnt <= note_cnt + 1;
        if (rst)
            note_cnt <= 0;
        else begin
            if (note_cnt < note_div_left) begin
                if (note_cnt < note_cnt_duty)
                    note_clk <= 1; 
                else
                    note_clk <= 0; 
            end else
                note_cnt <= 0;
        end
    end

    wire [15:0] AM_audio; 
    AM_gen AMGenInst(
        .clk(clk),
        .rst(rst),
        .speed(speed),
        .volume(volume),
        .note_div_left(note_div_left),
        .AM_audio(AM_audio)
    );

    always @(*) begin
        if(note_div_left == 22'd1) begin
            audio_left = 16'h0000;
        end else if (is_AM) begin
            audio_left = AM_audio;
        end else if (is_noise) begin
            /*audio_left = (noise_clk == 1'b0) ? {3'b101, random3[0], random2, random1, random0}
                                        : {3'b011, random3[0], random2, random1, random0};*/
            audio_left = (noise_clk == 1'b0) ? 16'hA000 : 16'h6000;
        end else begin
            if(volume==1) begin
                audio_left = (note_clk == 1'b0) ? 16'hF000 : 16'h1000;
            end else if(volume==2) begin
                audio_left = (note_clk == 1'b0) ? 16'hE000 : 16'h2000;
            end else if(volume==3) begin
                audio_left = (note_clk == 1'b0) ? 16'hC000 : 16'h4000;
            end else if(volume==4) begin
                audio_left = (note_clk == 1'b0) ? 16'hB000 : 16'h5000;
            end else if(volume==5) begin
                audio_left = (note_clk == 1'b0) ? 16'hA000 : 16'h6000;
            end else begin
                audio_left = 16'h0000;
            end
        end
    end

    assign audio_right = audio_left;

endmodule