`define silence 32'd1_0000_0000
module top(
    input clk,
    input rst,      // BTNC
    input play,     // BTNU: play/pause
    input right_button,
    input left_button,
    input loop, //temp loop effect
    inout PS2_DATA,
    inout PS2_CLK,
    input [15:0] sw,
    output [15:0] led,
    output audio_mclk, // master clock
    output audio_lrck, // left-right clock
    output audio_sck,  // serial clock
    output audio_sdin, // serial audio data input
    output [6:0] DISPLAY,
    output [3:0] DIGIT
);
    // Internal Signal
    wire [15:0] audio_in_left, audio_in_right;
    wire [11:0] ibeatNum;               // Beat counter
    wire [31:0] freqL, freqR;           // Raw frequency, produced by music module
    reg [21:0] freq_outL, freq_outR;    // Processed frequency, adapted to the clock rate of Basys3

    //clocks
    wire play_clk;    //for playing music
    wire display_clk;   //for 7 segment
    clock_divider #(.n(13)) display(.clk(clk), .clk_div(display_clk));  //7-segment display

    wire [2:0] volume, octave;
    wire play_pause;
    wire play_debounced, loop_debounced, right_button_debounced, left_button_debounced;    //loop only have debounced
    wire play_1p;
    debounce play_or_pause_de(.clk(clk), .pb(play), .pb_debounced(play_debounced));
    debounce loop_de(.clk(clk), .pb(loop), .pb_debounced(loop_debounced));
    debounce rb_de(.clk(clk), .pb(right_button), .pb_debounced(right_button_debounced));
    debounce lb_de(.clk(clk), .pb(left_button), .pb_debounced(left_button_debounced));

    onepulse play_or_pause_op(.clk(clk), .signal(play_debounced), .op(play_1p));
    

    wire [511:0] key_down;
    wire [8:0] last_change;
    wire key_valid;
    KeyboardDecoder keydecode1(
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(key_valid),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(rst),
        .clk(clk)
    );

    parameter [8:0] KEY_R = 9'b0_0010_1101; //R:2D
    reg reverse, reverse_next;
    reg key_num;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            reverse <= 0;
        end else begin
            reverse <= reverse_next;
        end
    end
    always @(*) begin
        reverse_next = reverse;
        if(key_valid && key_down[last_change]) begin
            if(key_num!=1) begin
                if(key_num==0) begin
                    reverse_next = ~reverse;
                end
            end
        end
    end
    always @(*) begin
        case(last_change)
            KEY_R: key_num=0;
            default: key_num=1;
        endcase
    end
    


    //[in] clk, rst, play_1p
    //[out] play_pause
    play_pause_controller playPauseCtrl(
        .clk(clk),
        .rst(rst),
        .play_1p(play_1p),
        .play_or_pause(play_pause)
    );


    //debounce, onepulse inside this module
    //[in] clk, rst, key_down, last_change, key_valid
    //[out] play_clk
    wire [1:0] speed; // for note_gen
    speed_controller speedCtrl(
        .clk(clk),
        .rst(rst),
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(key_valid),
        .play_clk(play_clk),
        .speed(speed)
    );
    
    //[in] clk, rst, key_down, last_change, key_valid
    //[out]loop_width
    wire [2:0] loop_width;  //3 bits(2 ~ 6)
    loop_width_controller lwCtrl(
        .clk(clk),
        .rst(rst),
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(key_valid),
        .loop_width(loop_width)
    );


    //[in] play_clk, rst, play_pause, loop_debounced, loop_width
    //[out] beat number
    player_control #(.LEN(64)) playerCtrl(
        .clk(play_clk),
        .rst(rst),
        .play_pause(play_pause),
        .loop_de(loop_debounced),
        .loop_width(loop_width),
        .reverse(reverse),
        .ibeat(ibeatNum)
    );


    //Music module
    //[in]  beat number, play_pause, sw
    //[out] left & right raw frequency, led
    music_example musicExCtrl(
        .clk(clk),
        .rst(rst),
        .ibeatNum(ibeatNum),
        .en(play_pause),
        .switch(sw),
        .left_button_de(left_button_debounced),
        .toneL(freqL),
        .toneR(freqR),
        .led(led)
    );


    //[in] clk, rst, key_down, last_change, key_valid
    //[out] volume, octave
    volume_octave_controller volOctCtrl(
        .clk(clk),
        .rst(rst),
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(key_valid),
        .volume(volume),
        .octave(octave)
    );


    // freq_outL, freq_outR
    // Note gen makes no sound, if freq_out = 50000000 / `silence = 1
    /*
    suppose sw[15]=0 && 0<=ibeat<4 is_noise=1
    music_example's toneR output `sil, assign it to freqR, and parse it to freq_outR
    but when octave == 1 or 3, freq_out_R = 10^8/... != 1.
    So when freq_out_R(!=1) is passed to note_gen, the noise wouldn't be muted.
    check whether freqR == `sil?
    */
    always @(*) begin
        freq_outL = 1_0000_0000 / (freqL == 1_0000_0000 ? `silence : freqL);
        if(octave==1) begin
            freq_outL = 1_0000_0000 / (freqL == 1_0000_0000 ? `silence : (freqL/2));
        end else if(octave==2) begin
            freq_outL = 1_0000_0000 / (freqL == 1_0000_0000 ? `silence : freqL);
        end else if(octave==3) begin
            freq_outL = 1_0000_0000 / (freqL == 1_0000_0000 ? `silence : (freqL*2));
        end
    end

    always @(*) begin
        freq_outR = 1_0000_0000 / (freqR == 1_0000_0000 ? `silence : freqR);
        if(octave==1) begin
            freq_outR = 1_0000_0000 / (freqR == 1_0000_0000 ? `silence : (freqR/2));
        end else if(octave==2) begin
            freq_outR = 1_0000_0000 / (freqR == 1_0000_0000 ? `silence : freqR);
        end else if(octave==3) begin
            freq_outR = 1_0000_0000 / (freqR == 1_0000_0000 ? `silence : (freqR*2));
        end
    end

    //[in] display_clk, volume, octave, loop_width
    //[out] DIGIT, DISPLAY
    seven_segment_controller sevenSegCtrl(
        .display_clk(display_clk),
        .volume(volume),
        .octave(octave),
        .loop_width(loop_width),
        .DIGIT(DIGIT),
        .DISPLAY(DISPLAY)
    );

    wire is_noise;
    noise_decider noiseDeciderInst(
        .ibeatNum(ibeatNum),
        .right_button_de(right_button_debounced),
        .left_button_de(left_button_debounced),
        .is_noise(is_noise)
    );

    wire is_AM;
    AM_decider AMDeciderInst(
        .ibeatNum(ibeatNum),
        .is_AM(is_AM)
    );


    // Note generation
    // [in]  processed frequency
    // [out] audio wave signal (using square wave here)
    note_gen noteGen(
        .clk(clk), 
        .rst(rst), 
        .volume(volume),
        .note_div_left(freq_outL), 
        .note_div_right(freq_outR),
        .is_noise(is_noise),
        .is_AM(is_AM),
        .speed(speed),
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(key_valid),
        .audio_left(audio_in_left),     // left sound audio
        .audio_right(audio_in_right)    // right sound audio
    );


    // Speaker controller
    speaker_control speakerCtrl(
        .clk(clk), 
        .rst(rst), 
        .audio_in_left(audio_in_left),      // left channel audio data input
        .audio_in_right(audio_in_right),    // right channel audio data input
        .audio_mclk(audio_mclk),            // master clock
        .audio_lrck(audio_lrck),            // left-right clock
        .audio_sck(audio_sck),              // serial clock
        .audio_sdin(audio_sdin)             // serial audio data input
    );
endmodule

module AM_decider (
    input [11:0] ibeatNum,
    output reg is_AM
);

always @(*) begin
    if (ibeatNum < 4)
        is_AM = 0;
    else if (ibeatNum < 8)
        is_AM = 0;
    else if (ibeatNum < 12)
        is_AM = 0;
    else if (ibeatNum < 16)
        is_AM = 0;
    else if (ibeatNum < 20)
        is_AM = 0;
    else if (ibeatNum < 24)
        is_AM = 0;
    else if (ibeatNum < 28)
        is_AM = 0;
    else if (ibeatNum < 32)
        is_AM = 0;
    else if (ibeatNum < 36)
        is_AM = 0;
    else if (ibeatNum < 40)
        is_AM = 0;
    else if (ibeatNum < 44)
        is_AM = 0;
    else if (ibeatNum < 48)
        is_AM = 1;
    else if (ibeatNum < 52)
        is_AM = 0;
    else if (ibeatNum < 56)
        is_AM = 1;
    else if (ibeatNum < 60)
        is_AM = 0;
    else if (ibeatNum < 64)
        is_AM = 0;
    else
        is_AM = 0;
end
    
endmodule

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
endmodule

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

module debounce(pb_debounced, pb ,clk);
    output pb_debounced;
    input pb;
    input clk;
    
    reg [6:0] shift_reg;
    always @(posedge clk) begin
        shift_reg[6:1] <= shift_reg[5:0];
        shift_reg[0] <= pb;
    end
    
    assign pb_debounced = shift_reg == 7'b111_1111 ? 1'b1 : 1'b0;
endmodule

module KeyboardDecoder(
	input wire rst,
	input wire clk,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	output reg [511:0] key_down,
	output wire [8:0] last_change,
	output reg key_valid
    );
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
	parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state;
    reg been_ready, been_extend, been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl inst (
		.key_in(key_in),
		.is_extend(is_extend),
		.is_break(is_break),
		.valid(valid),
		.err(err),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
	onepulse op (
		.signal(been_ready),
		.clk(clk),
		.op(pulse_been_ready)
	);
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		state <= INIT;
    		been_ready  <= 1'b0;
    		been_extend <= 1'b0;
    		been_break  <= 1'b0;
    		key <= 10'b0_0_0000_0000;
    	end else begin
    		state <= state;
			been_ready  <= been_ready;
			been_extend <= (is_extend) ? 1'b1 : been_extend;
			been_break  <= (is_break ) ? 1'b1 : been_break;
			key <= key;
    		case (state)
    			INIT : begin
    					if (key_in == IS_INIT) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready  <= 1'b0;
							been_extend <= 1'b0;
							been_break  <= 1'b0;
							key <= 10'b0_0_0000_0000;
    					end else begin
    						state <= INIT;
    					end
    				end
    			WAIT_FOR_SIGNAL : begin
    					if (valid == 0) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready <= 1'b0;
    					end else begin
    						state <= GET_SIGNAL_DOWN;
    					end
    				end
    			GET_SIGNAL_DOWN : begin
						state <= WAIT_RELEASE;
						key <= {been_extend, been_break, key_in};
						been_ready  <= 1'b1;
    				end
    			WAIT_RELEASE : begin
    					if (valid == 1) begin
    						state <= WAIT_RELEASE;
    					end else begin
    						state <= WAIT_FOR_SIGNAL;
    						been_extend <= 1'b0;
    						been_break  <= 1'b0;
    					end
    				end
    			default : begin
    					state <= INIT;
						been_ready  <= 1'b0;
						been_extend <= 1'b0;
						been_break  <= 1'b0;
						key <= 10'b0_0_0000_0000;
    				end
    		endcase
    	end
    end
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		key_valid <= 1'b0;
    		key_down <= 511'b0;
    	end else if (key_decode[last_change] && pulse_been_ready) begin
    		key_valid <= 1'b1;
    		if (key[8] == 0) begin
    			key_down <= key_down | key_decode;
    		end else begin
    			key_down <= key_down & (~key_decode);
    		end
    	end else begin
    		key_valid <= 1'b0;
			key_down <= key_down;
    	end
    end

endmodule

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

module loop_width_controller(
    input clk,
    input rst,
    input [511:0] key_down,
    input [8:0] last_change,
    input key_valid,
    output reg [2:0] loop_width
);
    parameter [8:0] KEY_CODES[0:4] = {
        9'b0_0111_0010,	//2 => 72
		9'b0_0111_1010,	//3 => 7A
		9'b0_0110_1011,	//4 => 6B
		9'b0_0111_0011,	//5 => 73
		9'b0_0111_0100	//6 => 74
    };

    reg [2:0] key_num;
	always @ (*) begin
        case(last_change)
            KEY_CODES[0] : key_num = 3'b000;   //2
            KEY_CODES[1] : key_num = 3'b001;   //3
            KEY_CODES[2] : key_num = 3'b010;   //4
            KEY_CODES[3] : key_num = 3'b011;   //5
            KEY_CODES[4] : key_num = 3'b100;   //6
            default : key_num = 3'b111;
        endcase
    end
    
    reg [2:0] loop_width_next;
    always @(posedge clk, posedge rst) begin
		if (rst) begin
			loop_width <= 3;    //reset to 4 will have bug, dont know how to solve
		end else begin
			loop_width <= loop_width_next;
		end
	end


    always @(*) begin
		loop_width_next = loop_width;
		if(key_valid && key_down[last_change]) begin
            if(key_num != 3'b111) begin
                if (key_num == 3'b000) begin	//2
					loop_width_next = 2;
				end else if (key_num == 3'b001) begin	//3
					loop_width_next = 3;
				end else if (key_num == 3'b010) begin	//4
					loop_width_next = 4;
				end else if (key_num == 3'b011) begin	//5
					loop_width_next = 5;
				end else if (key_num == 3'b100) begin	//6
					loop_width_next = 6;
				end
			end
		end
	end
endmodule

`define lc 32'd130  //C2
`define ld 32'd147
`define le 32'd165
`define lf 32'd175
`define lg 32'd196
`define la 32'd220
`define lb 32'd247
`define c  32'd262  // C3
`define d  32'd294
`define e  32'd330
`define f  32'd349
`define g  32'd392  // G3
`define a  32'd440
`define b  32'd494  // B3
`define hc 32'd524  // C4
`define hd 32'd588  // D4
`define he 32'd660  // E4
`define hf 32'd698  // F4
`define hg 32'd784  // G4
`define ha 32'd880
`define hb 32'd988
`define up_d 32'd311

`define sil   32'd1_0000_0000 // slience


module music_example (
    input clk,
    input rst,
	input [11:0] ibeatNum,
	input en,
    input [15:0] switch,
    input left_button_de,
	output reg [31:0] toneL,
    output reg [31:0] toneR,
    output reg [15:0] led
);
    reg [15:0] led_next;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            led <= 16'b1000_0000_0000_0000;
        end else begin
            led <= led_next;
        end
    end

    always @* begin
        toneR = `sil;
        led_next = led;
        if(en) begin   //play
            if(0<=ibeatNum && ibeatNum<4) begin
                if(switch[15]) begin
                    toneR = `lc;
                end
                led_next = 1<<15;
            end else if(4<=ibeatNum && ibeatNum<8) begin
                if(switch[14] && !left_button_de) begin
                    toneR = `up_d;
                end
                led_next = 1<<14;
            end else if(8<=ibeatNum && ibeatNum<12) begin
                if(switch[13] && !left_button_de) begin
                    toneR = `e;
                end
                led_next = 1<<13;
            end else if(12<=ibeatNum && ibeatNum<16) begin
                if(switch[12] && !left_button_de) begin
                    toneR = `lc;
                end
                led_next = 1<<12;
            end else if(16<=ibeatNum && ibeatNum<20) begin
                if(switch[11] && !left_button_de) begin
                    toneR = `ld;
                end
                led_next = 1<<11;
            end else if(20<=ibeatNum && ibeatNum<24) begin
                if(switch[10] && !left_button_de) begin
                    toneR = `lb;
                end
                led_next = 1<<10;
            end else if(24<=ibeatNum && ibeatNum<28) begin
                if(switch[9]) begin
                    toneR = `lf;
                end
                led_next = 1<<9;
            end else if(28<=ibeatNum && ibeatNum<32) begin
                if(switch[8] && !left_button_de) begin
                    toneR = `c;
                end
                led_next = 1<<8;
            end else if(32<=ibeatNum && ibeatNum<36) begin
                if(switch[7] && !left_button_de) begin
                    toneR = `la;
                end
                led_next = 1<<7;
            end else if(36<=ibeatNum && ibeatNum<40) begin
                if(switch[6] && !left_button_de) begin
                    toneR = `ld;
                end
                led_next = 1<<6;
            end else if(40<=ibeatNum && ibeatNum<44) begin
                if(switch[5]) begin
                    toneR = `lc;
                end
                led_next = 1<<5;
            end else if(44<=ibeatNum && ibeatNum<48) begin
                if(switch[4] && !left_button_de) begin
                    toneR = `lc;
                end
                led_next = 1<<4;
            end else if(48<=ibeatNum && ibeatNum<52) begin
                if(switch[3]) begin
                    toneR = `ld;
                end
                led_next = 1<<3;
            end else if(52<=ibeatNum && ibeatNum<56) begin
                if(switch[2] && !left_button_de) begin
                    toneR = `lc;
                end
                led_next = 1<<2;
            end else if(56<=ibeatNum && ibeatNum<60) begin
                if(switch[1]) begin
                    toneR = `ld;
                end
                led_next = 1<<1;
            end else if(60<=ibeatNum && ibeatNum<64) begin
                if(switch[0] && !left_button_de) begin
                    toneR = `c;
                end
                led_next = 1;
            end else begin
                led_next = 65535;
                toneR = `sil;
            end
        end
    end

    always @(*) begin
        toneL = toneR;
    end
endmodule

module noise_decider (
    input [11:0] ibeatNum,
    input right_button_de,
    input left_button_de,
    output reg is_noise
);

always @(*) begin
    is_noise = 0;
    if (ibeatNum < 4) begin //15
        is_noise = 0;
        if(left_button_de) begin
            is_noise = 1;
        end
    end else if (ibeatNum < 8) begin
        is_noise = 0;
    end else if (ibeatNum < 12) begin
        is_noise = 0;
    end else if (ibeatNum < 16) begin   //12
        is_noise = 0;
    end else if (ibeatNum < 20) begin
        is_noise = 1;
    end else if (ibeatNum < 24) begin
        is_noise = 0;
    end else if (ibeatNum < 28) begin
        is_noise = 0;
        if(left_button_de) begin
            is_noise = 1;
        end
    end else if (ibeatNum < 32) begin   //8
        is_noise = 0;
    end else if (ibeatNum < 36) begin
        is_noise = 0;
    end else if (ibeatNum < 40) begin
        is_noise = 0;
    end else if (ibeatNum < 44) begin
        is_noise = 0;
        if(left_button_de) begin
            is_noise = 1;
        end
    end else if (ibeatNum < 48) begin   //4
        is_noise = 0;
    end else if (ibeatNum < 52) begin
        is_noise = 1;
        if(left_button_de) begin
            is_noise = 1;
        end
    end else if (ibeatNum < 56) begin
        is_noise = 0;
    end else if (ibeatNum < 60) begin
        is_noise = 0;
        if(right_button_de || left_button_de) begin
            is_noise = 1;
        end
    end else if (ibeatNum < 64) begin   //0
        is_noise = 0;
    end
end
    
endmodule

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

module onepulse(signal, clk, op);
    input signal, clk;
    output reg op;
    
    reg delay;
    
    always @(posedge clk) begin
        if((signal == 1) & (delay == 0)) op <= 1;
        else op <= 0; 
        delay <= signal;
    end
endmodule

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

module player_control (
	input clk, 
	input rst,
	input play_pause,
	input loop_de,
	input [2:0] loop_width,
	input reverse,
	output reg [11:0] ibeat
);
	parameter LEN = 4095;
    reg [11:0] next_ibeat;
	reg [11:0] bound, bound_next;


	always @(posedge clk, posedge rst) begin
		if (rst) begin
			ibeat <= 0;
			bound <= 0;
		end else begin
            ibeat <= next_ibeat;
			bound <= bound_next;
		end
	end

	/*
	looping idea:
		once pressed the loop button, variable 'bound' will record the upper bound of current ibeat,
		and ibeat will immediately jump 4 notes to the front, then ibeat increase by 1 as usual.
		When ibeat == bound, ibeat will jump 4 notes to the front again...so on and so forth.
		(notice that this effect doesnt work on the rightmost three leds, since we jumps 4 notes to the front)

	always update 'bound' when not pressing loop button
	once the loop button is pressed, we can directly use this information
	*/
    always @* begin
		next_ibeat = ibeat;
		bound_next = bound;
		if(play_pause) begin	//play
			if(!loop_de) begin
				if(reverse) begin
					next_ibeat = (ibeat > 0) ? (ibeat - 1) : LEN-1;
					
					bound_next = (ibeat - 1 > 0) ? (ibeat - (ibeat%4)) : 0;
				end else begin
					next_ibeat = (ibeat + 1 < LEN) ? (ibeat + 1) : 0;
					//check the boundary case, (ibeat + 3 - (ibeat%4)) is the upper bound of the current ibeat range
					bound_next = (ibeat + 1 < LEN) ? (ibeat + 3 - (ibeat%4)) : 0;
				end
			end else begin
				if(reverse) begin
					if(ibeat > 63 - 4*(loop_width-1) || ibeat != bound) begin
						next_ibeat = (ibeat > 0) ? (ibeat - 1) : LEN-1;
					end else begin
						next_ibeat = ibeat + (4*loop_width-1);
					end
				end else begin
					if(ibeat < 4*(loop_width-1) || ibeat != bound) begin	//loop width=4 => ibeat<12. general form = ibeat < 4*(loop_width-1)
						next_ibeat = (ibeat + 1 < LEN) ? (ibeat + 1) : 0;
					end else begin	//loop width=4 => ibeat-15. general form = ibeat - (4*loop_width-1)
						next_ibeat = ibeat - (4*loop_width-1);	//when reaching the bound, go back [loop_width] note
					end
				end
			end
		end
    end
endmodule

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

module speaker_control(
    clk,  // clock from the crystal
    rst,  // active high reset
    audio_in_left, // left channel audio data input
    audio_in_right, // right channel audio data input
    audio_mclk, // master clock
    audio_lrck, // left-right clock, Word Select clock, or sample rate clock
    audio_sck, // serial clock
    audio_sdin // serial audio data input
);

    // I/O declaration
    input clk;  // clock from the crystal
    input rst;  // active high reset
    input [15:0] audio_in_left; // left channel audio data input
    input [15:0] audio_in_right; // right channel audio data input
    output audio_mclk; // master clock
    output audio_lrck; // left-right clock
    output audio_sck; // serial clock
    output audio_sdin; // serial audio data input
    reg audio_sdin;

    // Declare internal signal nodes 
    wire [8:0] clk_cnt_next;
    reg [8:0] clk_cnt;
    reg [15:0] audio_left, audio_right;

    // Counter for the clock divider
    assign clk_cnt_next = clk_cnt + 1'b1;

    always @(posedge clk or posedge rst)
        if (rst == 1'b1)
            clk_cnt <= 9'd0;
        else
            clk_cnt <= clk_cnt_next;

    // Assign divided clock output
    assign audio_mclk = clk_cnt[1];
    assign audio_lrck = clk_cnt[8];
    assign audio_sck = 1'b1; // use internal serial clock mode

    // audio input data buffer
    always @(posedge clk_cnt[8] or posedge rst)
        if (rst == 1'b1)
            begin
                audio_left <= 16'd0;
                audio_right <= 16'd0;
            end
        else
            begin
                audio_left <= audio_in_left;
                audio_right <= audio_in_right;
            end

    always @*
        case (clk_cnt[8:4])
            5'b00000: audio_sdin = audio_right[0];
            5'b00001: audio_sdin = audio_left[15];
            5'b00010: audio_sdin = audio_left[14];
            5'b00011: audio_sdin = audio_left[13];
            5'b00100: audio_sdin = audio_left[12];
            5'b00101: audio_sdin = audio_left[11];
            5'b00110: audio_sdin = audio_left[10];
            5'b00111: audio_sdin = audio_left[9];
            5'b01000: audio_sdin = audio_left[8];
            5'b01001: audio_sdin = audio_left[7];
            5'b01010: audio_sdin = audio_left[6];
            5'b01011: audio_sdin = audio_left[5];
            5'b01100: audio_sdin = audio_left[4];
            5'b01101: audio_sdin = audio_left[3];
            5'b01110: audio_sdin = audio_left[2];
            5'b01111: audio_sdin = audio_left[1];
            5'b10000: audio_sdin = audio_left[0];
            5'b10001: audio_sdin = audio_right[15];
            5'b10010: audio_sdin = audio_right[14];
            5'b10011: audio_sdin = audio_right[13];
            5'b10100: audio_sdin = audio_right[12];
            5'b10101: audio_sdin = audio_right[11];
            5'b10110: audio_sdin = audio_right[10];
            5'b10111: audio_sdin = audio_right[9];
            5'b11000: audio_sdin = audio_right[8];
            5'b11001: audio_sdin = audio_right[7];
            5'b11010: audio_sdin = audio_right[6];
            5'b11011: audio_sdin = audio_right[5];
            5'b11100: audio_sdin = audio_right[4];
            5'b11101: audio_sdin = audio_right[3];
            5'b11110: audio_sdin = audio_right[2];
            5'b11111: audio_sdin = audio_right[1];
            default: audio_sdin = 1'b0;
        endcase

endmodule

//BTNL, BTNR
module speed_controller(
    input clk,
    input rst,
    input [511:0] key_down,
    input [8:0] last_change,
    input key_valid,
    output reg play_clk,
    output reg [1:0] speed
);
    parameter [8:0] KEY_CODES[0:1] = {
        9'b0_0001_1010,	//Z => 1A
		9'b0_0010_0010	//X => 22
    };

    reg [1:0] key_num;
	always @ (*) begin
        case(last_change)
            KEY_CODES[0] : key_num = 2'b00;   //Z
            KEY_CODES[1] : key_num = 2'b01;   //X
            default : key_num = 2'b11;
        endcase
    end
    
    
    wire clkDiv21, clkDiv22;
    clock_divider #(.n(21)) clock_21(.clk(clk), .clk_div(clkDiv21));    // for player[fast]
    clock_divider #(.n(22)) clock_22(.clk(clk), .clk_div(clkDiv22));    // for player[normal]

    reg [1:0] speed_next;    //speed: 1~2, default = 1
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            speed <= 1;
        end else begin
            speed <= speed_next;
        end
    end

    always @(*) begin
        speed_next = speed;
		if(key_valid && key_down[last_change]) begin
            if(key_num != 2'b11) begin
                if (key_num == 2'b00) begin	//Z
					speed_next = 1;
				end else if (key_num == 2'b01) begin	//X
					speed_next = 2;
				end
			end
		end
	end

    //assign the clock
    always @(*) begin
        if(speed == 1) begin  //normal
            play_clk = clkDiv22;
        end else begin    //fast
            play_clk = clkDiv21;
        end
    end
endmodule

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

module KeyboardCtrl#(
   parameter SYSCLK_FREQUENCY_HZ = 100000000
)(
    output reg [7:0] key_in,
    output reg is_extend,
    output reg is_break,
	output reg valid,
    output err,
    inout PS2_DATA,
    inout PS2_CLK,
    input rst,
    input clk
);
//////////////////////////////////////////////////////////
// This Keyboard  Controller do not support lock LED control
//////////////////////////////////////////////////////////

    parameter RESET          = 3'd0;
	parameter SEND_CMD       = 3'd1;
	parameter WAIT_ACK       = 3'd2;
    parameter WAIT_KEYIN     = 3'd3;
	parameter GET_BREAK      = 3'd4;
	parameter GET_EXTEND     = 3'd5;
	parameter RESET_WAIT_BAT = 3'd6;
    
    parameter CMD_RESET           = 8'hFF; 
    parameter CMD_SET_STATUS_LEDS = 8'hED;
	parameter RSP_ACK             = 8'hFA;
	parameter RSP_BAT_PASS        = 8'hAA;
    
    parameter BREAK_CODE  = 8'hF0;
    parameter EXTEND_CODE = 8'hE0;
    parameter CAPS_LOCK   = 8'h58;
    parameter NUM_LOCK    = 8'h77;
    parameter SCR_LOCK    = 8'h7E;
    
    wire [7:0] rx_data;
	wire rx_valid;
	wire busy;
	
	reg [7:0] tx_data;
	reg tx_valid;
	reg [2:0] state;
	reg [2:0] lock_status;
	
	always @ (posedge clk, posedge rst)
	  if(rst)
	    key_in <= 0;
	  else if(rx_valid)
	    key_in <= rx_data;
	  else
	    key_in <= key_in;
	
	always @ (posedge clk, posedge rst)begin
	  if(rst)begin
	    state <= RESET;
        is_extend <= 1'b0;
        is_break <= 1'b1;
		valid <= 1'b0;
		lock_status <= 3'b0;
		tx_data <= 8'h00;
		tx_valid <= 1'b0;
	  end else begin
	    is_extend <= 1'b0;
	    is_break <= 1'b0;
	    valid <= 1'b0;
	    lock_status <= lock_status;
	    tx_data <= tx_data;
	    tx_valid <= 1'b0;
	    case(state)
	      RESET:begin
	          is_extend <= 1'b0;
              is_break <= 1'b1;
		      valid <= 1'b0;
		      lock_status <= 3'b0;
		      tx_data <= CMD_RESET;
		      tx_valid <= 1'b0;
			  state <= SEND_CMD;
	        end
		  
		  SEND_CMD:begin
		      if(busy == 1'b0)begin
			    tx_valid <= 1'b1;
				state <= WAIT_ACK;
			  end else begin
			    tx_valid <= 1'b0;
				state <= SEND_CMD;
		      end
		    end
	      
		  WAIT_ACK:begin
		      if(rx_valid == 1'b1)begin
			    if(rx_data == RSP_ACK && tx_data == CMD_RESET)begin
				  state <= RESET_WAIT_BAT;
				end else if(rx_data == RSP_ACK && tx_data == CMD_SET_STATUS_LEDS)begin
				  tx_data <= {5'b00000, lock_status};
				  state <= SEND_CMD;
				end else begin
				  state <= WAIT_KEYIN;
				end
			  end else if(err == 1'b1)begin
			    state <= RESET;
			  end else begin
			    state <= WAIT_ACK;
			  end
		    end
			
		  WAIT_KEYIN:begin
		      if(rx_valid == 1'b1 && rx_data == BREAK_CODE)begin
			    state <= GET_BREAK;
			  end else if(rx_valid == 1'b1 && rx_data == EXTEND_CODE)begin
			    state <= GET_EXTEND;
			  end else if(rx_valid == 1'b1)begin
			    state <= WAIT_KEYIN;
				valid <= 1'b1;
			  end else if(err == 1'b1)begin
			    state <= RESET;
			  end else begin
			    state <= WAIT_KEYIN;
			  end
		    end
		    
		  GET_BREAK:begin
		      is_extend <= is_extend;
		      if(rx_valid == 1'b1)begin
			    state <= WAIT_KEYIN;
                valid <= 1'b1;
				is_break <= 1'b1;
			  end else if(err == 1'b1)begin
			    state <= RESET;
			  end else begin
			    state <= GET_BREAK;
			  end
		    end
			
		  GET_EXTEND:begin
		      if(rx_valid == 1'b1 && rx_data == BREAK_CODE)begin
		        state <= GET_BREAK;
		        is_extend <= 1'b1;
		      end else if(rx_valid == 1'b1)begin
		        state <= WAIT_KEYIN;
                valid <= 1'b1;
		        is_extend <= 1'b1;
			  end else if(err == 1'b1)begin
			    state <= RESET;
		      end else begin
		        state <= GET_EXTEND;
		      end
		    end
			
		  RESET_WAIT_BAT:begin
		      if(rx_valid == 1'b1 && rx_data == RSP_BAT_PASS)begin
			    state <= WAIT_KEYIN;
			  end else if(rx_valid == 1'b1)begin
			    state <= RESET;
			  end else if(err == 1'b1)begin
			    state <= RESET;
			  end else begin
			    state <= RESET_WAIT_BAT;
			  end
		    end
		  default:begin
		      state <= RESET;
		      valid <= 1'b0;
		    end
		endcase
	  end
	end
	
    Ps2Interface #(
      .SYSCLK_FREQUENCY_HZ(SYSCLK_FREQUENCY_HZ)
    ) Ps2Interface_i(
      .ps2_clk(PS2_CLK),
      .ps2_data(PS2_DATA),
      
      .clk(clk),
      .rst(rst),
      
      .tx_data(tx_data),
      .tx_valid(tx_valid),
      
      .rx_data(rx_data),
      .rx_valid(rx_valid),
      
      .busy(busy),
      .err(err)
    );
        
endmodule