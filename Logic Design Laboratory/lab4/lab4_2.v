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

module lab4_2(
    input clk,
    input rst,
    input en,
    input input_number,
    input enter,
    input count_down,
    output reg [3:0] DIGIT,
    output reg [6:0] DISPLAY,
    output led0
);
    parameter START = 1'b0;
    parameter PAUSE = 1'b1;
    parameter [2:0] DIRECTION=0;    //direction setting state
    parameter [2:0] MINUTE=1;
    parameter [2:0] TENSEC=2;
    parameter [2:0] SECOND=3;
    parameter [2:0] POINTSEC=4;
    parameter [2:0] COUNTING=5; //counting state
    
    integer i,j,k;
    reg [3:0] value;
    reg countdown=0, countdown_next;    //initial is countup
    reg mode=START;
    reg [2:0] state=DIRECTION, state_next;

    //{min, 10s, 1s, 0.1s}
    reg [3:0] mytime[0:3], mytime_next[0:3];
    reg [3:0] cnt_time[0:3], cnt_time_next[0:3];

    wire display_clk, myclk;
    clock_divider #(.n(10)) cnt(.clk(clk), .clk_div(display_clk));  //clock to display 7-segment
    clock_divider_100ms myclkdiv(.clk(clk), .clk_div(myclk));   //already have one pulse effect

    //7-segment control
    always @(posedge display_clk) begin
        case(DIGIT)
            4'b1110: begin
                value=mytime[2];
                DIGIT=4'b1101;
            end
            4'b1101: begin
                value=mytime[1];
                DIGIT=4'b1011;
            end
            4'b1011: begin
                value=mytime[0];
                DIGIT=4'b0111;
            end
            4'b0111: begin
                value=mytime[3];
                DIGIT=4'b1110;
            end
            default: begin
                value=mytime[3];
                DIGIT=4'b1110;
            end
        endcase
    end
    always @(*) begin
        case(value) //0 means on,1 means off(GFEDCBA)
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
            4'd10: DISPLAY=7'b011_1111; //'-'
            default: DISPLAY=7'b111_1111;
        endcase
    end

    wire input_number_debounced, enter_debounced, count_down_debounced;
    debounce input_number_de(   .clk(clk), .pb(input_number),.pb_debounced(input_number_debounced));
    debounce enter_de(          .clk(clk), .pb(enter),       .pb_debounced(enter_debounced));
    debounce count_down_de(     .clk(clk), .pb(count_down),  .pb_debounced(count_down_debounced));

    wire input_number_1pulse, enter_1pulse, count_down_1pulse;
    onepulse input_number_1(.clk(clk), .pb_debounced(input_number_debounced),.pb_1pulse(input_number_1pulse));
    onepulse enter_1(       .clk(clk), .pb_debounced(enter_debounced),       .pb_1pulse(enter_1pulse));
    onepulse count_down_1(  .clk(clk), .pb_debounced(count_down_debounced),  .pb_1pulse(count_down_1pulse));


    always @(posedge clk,posedge rst) begin
        if(rst) begin
            state<=DIRECTION;
            countdown<=0;
            for(i=0;i<4;i=i+1) begin
                mytime[i] <= 10;    //reset to '-',not '0'
                cnt_time[i] <= 0;
            end
        end else begin
            state<=state_next;
            countdown<=countdown_next;
            for(i=0;i<4;i=i+1) begin
                mytime[i] <= mytime_next[i];
                cnt_time[i] <= cnt_time_next[i];
            end
        end
    end

    //start/pause(en is switch,dont need to debounce/one pulse)
    always @(*) begin
        if(en) begin
            mode=START;
        end else begin
            mode=PAUSE;
        end
    end

    //count up/down,led0
    always @(*) begin
        countdown_next=countdown;
        if(state==DIRECTION) begin
            if(count_down_1pulse) begin
                countdown_next = ~countdown;
            end
        end
    end
    assign led0 = (countdown) ? 1 : 0;
    
    
    //number setting(input_number_1pulse)
    //set the goal
    //state transition logic(remember to add enter_1pulse)
    //counting
    always @(*) begin
        for(i=0;i<4;i=i+1) begin
            mytime_next[i]=mytime[i];
            cnt_time_next[i]=cnt_time[i];
        end
        state_next=state;

        if(state==DIRECTION) begin
            if(enter_1pulse) begin
                state_next = MINUTE;
                for(i=0;i<4;i=i+1) begin    //initialize
                    mytime_next[i]=0;
                    cnt_time_next[i]=0;
                end
            end
        end else if(state==MINUTE) begin
            if(input_number_1pulse) begin
                if(mytime[0]==1) begin //minute has reach its max 1
                    mytime_next[0] = 0;
                    cnt_time_next[0] = 0;   //set the goal
                end else begin
                    mytime_next[0] = mytime[0] + 1;
                    cnt_time_next[0] = (countdown) ? 0 : mytime[0]+1;   //set the goal
                end
            end else if(enter_1pulse) begin
                state_next = TENSEC;
            end
        end else if(state==TENSEC) begin
            if(input_number_1pulse) begin
                if(mytime[1]==5) begin //tensec has reach its max 5
                    mytime_next[1] = 0;
                    cnt_time_next[1] = 0;
                end else begin
                    mytime_next[1] = mytime[1] + 1;
                    cnt_time_next[1] = (countdown) ? 0 : mytime[1]+1;
                end
            end else if(enter_1pulse) begin
                state_next = SECOND;
            end
        end else if(state==SECOND) begin
            if(input_number_1pulse) begin
                if(mytime[2]==9) begin //second has reach its max 9
                    mytime_next[2] = 0;
                    cnt_time_next[2] = 0;
                end else begin
                    mytime_next[2] = mytime[2] + 1;
                    cnt_time_next[2] = (countdown) ? 0 : mytime[2]+1;
                end
            end else if(enter_1pulse) begin
                state_next = POINTSEC;
            end
        end else if(state==POINTSEC) begin
            if(input_number_1pulse) begin
                if(mytime[3]==9) begin   //pointsec has reach its max 9
                    mytime_next[3] = 0;
                    cnt_time_next[3] = 0;
                end else begin
                    mytime_next[3] = mytime[3]+1;
                    cnt_time_next[3] = (countdown) ? 0 : mytime[3]+1;
                end
            end else if(enter_1pulse) begin
                state_next = COUNTING;
                for(i=0;i<4;i=i+1) begin
                    mytime_next[i] = (countdown) ? mytime[i] : 0;
                end
            end
        end else if(state==COUNTING) begin
            state_next = COUNTING;
            if(mode==START) begin
                if(myclk) begin
                    if(mytime[0]!=cnt_time[0] || mytime[1]!=cnt_time[1] || mytime[2]!=cnt_time[2] || mytime[3]!=cnt_time[3]) begin  //havent reach the goal
                        if(countdown) begin
                            if(mytime[0]==0 && mytime[1]==0 && mytime[2]==0 && mytime[3]==0) begin
                                mytime_next[0]=0;
                                mytime_next[1]=0;
                                mytime_next[2]=0;
                                mytime_next[3]=0;
                            end else begin
                                if(mytime[3]==0) begin   //ex.1:11.0=>1:10.9
                                    mytime_next[3]=9;
                                    if(mytime[2]==0) begin //ex.1:10.0=>1:09.9
                                        mytime_next[2]=9;
                                        if(mytime[1]==0) begin //ex.1:00.0=>0:59.9
                                            mytime_next[0]=0;
                                            mytime_next[1]=5;
                                        end else begin  //ex.0:10.0=>0:09.9
                                            mytime_next[1]=mytime[1]-1;
                                        end
                                    end else begin  //ex.0:05.0=>0:04.9
                                        mytime_next[2]=mytime[2]-1;
                                    end
                                end else begin  //ex.0:00.5=>0:00.4
                                    mytime_next[3]=mytime[3]-1;
                                end
                            end
                        end else begin  //countup
                            if(mytime[0]==cnt_time[0] && mytime[1]==cnt_time[1] && mytime[2]==cnt_time[2] && mytime[3]==cnt_time[3]) begin  //should be goal here
                                mytime_next[0]=cnt_time[0];
                                mytime_next[1]=cnt_time[1];
                                mytime_next[2]=cnt_time[2];
                                mytime_next[3]=cnt_time[3];
                            end else begin
                                if(mytime[3]==9) begin   //ex.0:00.9=>0:01.0
                                    mytime_next[3]=0;
                                    if(mytime[2]==9) begin //ex.0:09.9=>0:10.0
                                        mytime_next[2]=0;
                                        if(mytime[1]==5) begin //ex.0:59.9=>1:00.0
                                            mytime_next[0]=1;
                                            mytime_next[1]=0;
                                        end else begin  //ex.0:49.9=>0:50.0
                                            mytime_next[1]=mytime[1]+1;
                                        end
                                    end else begin  //ex.0:04.9=>0:05.0
                                        mytime_next[2]=mytime[2]+1;
                                    end
                                end else begin  //ex.0:00.1=>0:00.2
                                    mytime_next[3]=mytime[3]+1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
endmodule