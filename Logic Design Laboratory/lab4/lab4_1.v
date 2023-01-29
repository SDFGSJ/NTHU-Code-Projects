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

module lab4_1(
    input clk,
    input rst,
    input en,
    input dir,
    input speed_up,
    input speed_down,
    output reg [3:0] DIGIT,
    output reg [6:0] DISPLAY,
    output reg max,
    output reg min
);
    parameter START = 1'b1;
    parameter PAUSE = 1'b0;
    parameter [1:0] SLOW = 2'b00;
    parameter [1:0] NORMAL = 2'b01;
    parameter [1:0] FAST = 2'b10;
    
    wire wire_slow, wire_normal, wire_fast, display_clk;
    wire slow_1pulse, normal_1pulse, fast_1pulse;
    clock_divider #(.n(25)) slow(   .clk(clk), .clk_div(wire_slow));
    clock_divider #(.n(24)) normal( .clk(clk), .clk_div(wire_normal));
    clock_divider #(.n(23)) fast(   .clk(clk), .clk_div(wire_fast));
    clock_divider #(.n(10)) cnt(    .clk(clk), .clk_div(display_clk));  //clock to display 7-segment
    onepulse slow_1p(   .clk(clk), .pb_debounced(wire_slow),    .pb_1pulse(slow_1pulse));
    onepulse normal_1p( .clk(clk), .pb_debounced(wire_normal),  .pb_1pulse(normal_1pulse));
    onepulse fast_1p(   .clk(clk), .pb_debounced(wire_fast),    .pb_1pulse(fast_1pulse));

    //debounce
    wire en_debounced, dir_debounced, speed_up_debounced, speed_down_debounced;
    debounce en_de(         .clk(clk), .pb(en), .pb_debounced(en_debounced));
    debounce dir_de(        .clk(clk), .pb(dir), .pb_debounced(dir_debounced));
    debounce speed_up_de(   .clk(clk), .pb(speed_up), .pb_debounced(speed_up_debounced));
    debounce speed_down_de( .clk(clk), .pb(speed_down), .pb_debounced(speed_down_debounced));

    //1 pulse
    wire en_1pulse, speed_up_1pulse, speed_down_1pulse;
    onepulse en_1(          .clk(clk), .pb_debounced(en_debounced), .pb_1pulse(en_1pulse));
    onepulse speed_up_1(    .clk(clk), .pb_debounced(speed_up_debounced), .pb_1pulse(speed_up_1pulse));
    onepulse speed_down_1(  .clk(clk), .pb_debounced(speed_down_debounced), .pb_1pulse(speed_down_1pulse));

    reg [3:0] value;
    reg mode = PAUSE, mode_next; //1-bit
    reg [1:0] speed = SLOW, speed_next;    //2-bits
    reg countup = 1, countup_next;
    reg [3:0] ten=0, one=0, ten_next, one_next;
    
    reg max_next,min_next;

    //7-segment control
    always @(posedge display_clk) begin
        case(DIGIT)
            4'b1110: begin
                value=ten;
                DIGIT=4'b1101;
            end
            4'b1101: begin
                value=(countup) ? 10 : 11;
                DIGIT=4'b1011;
            end
            4'b1011: begin
                value={2'b00,speed};
                DIGIT=4'b0111;
            end
            4'b0111: begin
                value=one;
                DIGIT=4'b1110;
            end
            default: begin
                value=one;
                DIGIT=4'b1110;
            end
        endcase
    end
    always @(*) begin
        case(value) //0 means on,1 means off
            4'd0: DISPLAY=7'b100_0000;
            4'd1: DISPLAY=7'b111_1001;
            4'd2: DISPLAY=7'b010_0100;
            4'd3: DISPLAY=7'b011_0000;
            4'd4: DISPLAY=7'b001_1001;
            4'd5: DISPLAY=7'b001_0010;
            4'd6: DISPLAY=7'b000_0010;
            4'd7: DISPLAY=7'b111_1000;
            4'd8: DISPLAY=7'b000_0000;
            4'd9: DISPLAY=7'b001_0000;
            4'd10: DISPLAY=7'b101_1100; //arrow up
            4'd11: DISPLAY=7'b110_0011; //arrow down
            default: DISPLAY=7'b111_1111;
        endcase
    end

    always @(posedge clk,posedge rst) begin
        if(rst) begin
            max<=0;
            min<=0;

            mode<=PAUSE;
            speed<=SLOW;
            countup<=1;
            ten<=0;
            one<=0;
        end else begin
            max<=max_next;
            min<=min_next;

            mode<=mode_next;
            speed<=speed_next;
            countup<=countup_next;
            ten<=ten_next;
            one<=one_next;
        end
    end

    //START/PAUSE
    always @(*) begin
        if(en_1pulse) begin
            mode_next = ~mode;
        end else begin
            mode_next = mode;
        end
    end

    //count up/down
    always @(*) begin
        if(mode==START) begin
            if(dir_debounced==1) begin
                countup_next=0;
            end else begin
                countup_next=1;
            end
        end else begin  //PAUSE(can change speed)
            countup_next=countup;
        end
    end

    //speed
    always @(*) begin
        if(speed_up_1pulse) begin
            if(speed==SLOW) begin
                speed_next=NORMAL;
            end else if(speed==NORMAL) begin
                speed_next=FAST;
            end else if(speed==FAST) begin
                speed_next=FAST;
            end
        end else if(speed_down_1pulse) begin
            if(speed==SLOW) begin
                speed_next=SLOW;
            end else if(speed==NORMAL) begin
                speed_next=SLOW;
            end else if(speed==FAST) begin
                speed_next=NORMAL;
            end
        end else begin
            speed_next=speed;
        end
    end

    //calculation and boundary
    always @(*) begin
        if(mode==START) begin
            if((slow_1pulse && speed==SLOW) || (normal_1pulse && speed==NORMAL) || (fast_1pulse && speed==FAST)) begin
                if(countup) begin
                    if(ten==9 && one==9) begin   //99
                        max_next=1;min_next=0;
                        ten_next=9;
                        one_next=9;
                    end else begin  //normal increment
                        max_next=0;min_next=0;
                        if(one==9) begin
                            one_next=0;
                            ten_next=ten+1;
                        end else begin
                            one_next=one+1;
                            ten_next=ten;
                        end
                    end
                end else begin
                    if(ten==0 && one==0) begin   //00
                        min_next=1;max_next=0;
                        ten_next=0;
                        one_next=0;
                    end else begin  //normal decrement
                        min_next=0;max_next=0;
                        if(one==0) begin
                            one_next=9;
                            ten_next=ten-1;
                        end else begin
                            one_next=one-1;
                            ten_next=ten;
                        end
                    end
                end
            end else begin
                ten_next=ten;
                one_next=one;
                max_next=max;
                min_next=min;
            end
        end else begin  //PAUSE
            ten_next=ten;
            one_next=one;
            max_next=max;
            min_next=min;
        end
    end
endmodule