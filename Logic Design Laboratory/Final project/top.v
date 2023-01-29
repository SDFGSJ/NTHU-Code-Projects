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