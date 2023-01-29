//0.5Hz clock divider
module clock_divider_05Hz #(parameter n = 1_0000_0000)(
    input clk,
    output clk_div
);
    reg [31:0] num = 0;
    wire [31:0] next_num;

    always @(posedge clk) begin
        if(next_num >= n+1) begin
            num<=0;
        end else begin
            num<=next_num;
        end
    end

    assign next_num = num + 1;
    assign clk_div = (num > n/2) ? 1 : 0;
endmodule

module clock_divider_1s #(parameter n = 1_0000_0000)(
    input clk,
    output clk_div
);
    reg [31:0] num = 0;
    wire [31:0] next_num;

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

module lab5(
    input clk,
    input rst,
    input BTNL,
    input BTNR,
    input BTNU,
    input BTND,
    input BTNC,
    output reg [15:0] LED,
    output reg [3:0] DIGIT,
    output reg [6:0] DISPLAY
);
    parameter IDLE=0;
    parameter TYPE=1;
    parameter AMOUNT=2;
    parameter PAYMENT=3;
    parameter RELEASE=4;
    parameter CHANGE=5;

    parameter ADULT=11;
    parameter STUDENT=5;
    parameter CHILD=12;

    parameter DARK=13;

    wire display_clk, led_clk, onesec_clk, led_clk_1p;
    clock_divider #(.n(13)) display(.clk(clk), .clk_div(display_clk));  //7-segment display
    clock_divider_05Hz led_cd(.clk(clk), .clk_div(led_clk));    //led clk
    clock_divider_1s onesec(.clk(clk), .clk_div(onesec_clk));   //exact 1s
    onepulse ledclk_1p(.clk(clk), .pb_debounced(led_clk), .pb_1pulse(led_clk_1p));

    wire btnl_debounced, btnr_debounced, btnu_debounced, btnd_debounced, btnc_debounced;
    debounce btnl_de(.clk(clk), .pb(BTNL), .pb_debounced(btnl_debounced));
    debounce btnr_de(.clk(clk), .pb(BTNR), .pb_debounced(btnr_debounced));
    debounce btnu_de(.clk(clk), .pb(BTNU), .pb_debounced(btnu_debounced));
    debounce btnd_de(.clk(clk), .pb(BTND), .pb_debounced(btnd_debounced));
    debounce btnc_de(.clk(clk), .pb(BTNC), .pb_debounced(btnc_debounced));

    wire btnl_1pulse, btnr_1pulse, btnu_1pulse, btnd_1pulse, btnc_1pulse;
    onepulse btnl_1p(.clk(clk), .pb_debounced(btnl_debounced), .pb_1pulse(btnl_1pulse));
    onepulse btnr_1p(.clk(clk), .pb_debounced(btnr_debounced), .pb_1pulse(btnr_1pulse));
    onepulse btnu_1p(.clk(clk), .pb_debounced(btnu_debounced), .pb_1pulse(btnu_1pulse));
    onepulse btnd_1p(.clk(clk), .pb_debounced(btnd_debounced), .pb_1pulse(btnd_1pulse));
    onepulse btnc_1p(.clk(clk), .pb_debounced(btnc_debounced), .pb_1pulse(btnc_1pulse));

    integer i;
    reg [3:0] value;
    reg [3:0] my[0:3], my_next[0:3]; //used for display
    reg [15:0] led_next;
    reg [2:0] state=IDLE, state_next;
    reg [1:0] amount=1, amount_next;    //how many tickets does user want
    reg [3:0] type=ADULT, type_next; //inorder to match the width of my[0:3]
    reg [2:0] cycle=0, cycle_next;  //for counting 5s
    reg [3:0] remain=0, remain_next;    //the money to be returned

    always @(posedge clk,posedge rst) begin
        if(rst) begin
            for(i=0;i<4;i=i+1) begin
                my[i]=DARK;
            end
            LED<=0;
            state<=IDLE;
            amount<=1;
            type<=ADULT;
            cycle<=0;
            remain<=0;
        end else begin
            for(i=0;i<4;i=i+1) begin
                my[i]=my_next[i];
            end
            LED<=led_next;
            state<=state_next;
            amount<=amount_next;
            type<=type_next;
            cycle<=cycle_next;
            remain<=remain_next;
        end
    end


    always @(*) begin
        for(i=0;i<4;i=i+1) begin
            my_next[i]=my[i];
        end
        led_next=LED;
        state_next=state;
        amount_next=amount;
        type_next=type;
        cycle_next=cycle;
        remain_next=remain;

        if(state==IDLE) begin
            if(led_clk_1p) begin
                for(i=0;i<4;i=i+1) begin
                    my_next[i] = (my[i]==DARK) ? 10 : DARK;    //flash
                end
                led_next = ~LED;
            end

            if(btnl_1pulse || btnc_1pulse || btnr_1pulse) begin
                state_next=TYPE;
                if(btnl_1pulse) begin
                    type_next=CHILD;
                    my_next[0]=CHILD;
                    my_next[1]=DARK;
                    my_next[2]=0;
                    my_next[3]=5;
                end else if(btnc_1pulse) begin
                    type_next=STUDENT;
                    my_next[0]=STUDENT;
                    my_next[1]=DARK;
                    my_next[2]=1;
                    my_next[3]=0;
                end else if(btnr_1pulse) begin
                    type_next=ADULT;
                    my_next[0]=ADULT;
                    my_next[1]=DARK;
                    my_next[2]=1;
                    my_next[3]=5;
                end
            end else begin
                state_next=state;
            end
        end else if(state==TYPE) begin
            my_next[1]=DARK;
            led_next=0;
            type_next=type;
            if(btnl_1pulse) begin   //child 5
                type_next=CHILD;
                my_next[0]=CHILD;
                my_next[2]=0;
                my_next[3]=5;
            end else if(btnc_1pulse) begin  //student 10
                type_next=STUDENT;
                my_next[0]=STUDENT;
                my_next[2]=1;
                my_next[3]=0;
            end else if(btnr_1pulse) begin  //adult 15
                type_next=ADULT;
                my_next[0]=ADULT;
                my_next[2]=1;
                my_next[3]=5;
            end

            if(btnu_1pulse) begin
                state_next=AMOUNT;
                my_next[0]=my[0];
                my_next[1]=DARK;
                my_next[2]=DARK;
                my_next[3]=1;   //initial amount is 1
            end else if(btnd_1pulse) begin
                state_next=IDLE;
                //turn both my,led on
                for(i=0;i<4;i=i+1) begin
                    my_next[i]=10;
                end
                led_next=65535;
            end
        end else if(state==AMOUNT) begin
            my_next[0]=my[0];   //maintain the type
            my_next[1]=DARK;
            my_next[2]=DARK;
            my_next[3]=my[3];
            led_next=0;
            type_next=my[0];
            amount_next=my[3];

            if(btnl_1pulse && my[3]>1) begin    //-1
                amount_next=my[3]-1;
                my_next[3]=my[3]-1;
            end else if(btnr_1pulse && my[3]<3) begin   //+1
                amount_next=my[3]+1;
                my_next[3]=my[3]+1;
            end else begin
                amount_next=my[3];
                my_next[3]=my[3];
            end

            if(btnu_1pulse) begin
                state_next=PAYMENT;
                my_next[0]=0;
                my_next[1]=0;

                //show the needed money(6 situations in total)
                if(type==CHILD && my[3]==1) begin //child*1 => $5
                    my_next[2]=0;
                    my_next[3]=5;
                end else if((type==CHILD && my[3]==2) || (type==STUDENT && my[3]==1)) begin   //child*2, student*1 => $10
                    my_next[2]=1;
                    my_next[3]=0;
                end else if((type==CHILD && my[3]==3) || (type==ADULT && my[3]==1)) begin   //child*3, adult*1 => $15
                    my_next[2]=1;
                    my_next[3]=5;
                end else if(type==STUDENT && my[3]==2) begin   //student*2 => 20
                    my_next[2]=2;
                    my_next[3]=0;
                end else if((type==STUDENT && my[3]==3) || (type==ADULT && my[3]==2)) begin   //student*3, adult*2 => 30
                    my_next[2]=3;
                    my_next[3]=0;
                end else if(type==ADULT && my[3]==3) begin   //adult*3 => 45
                    my_next[2]=4;
                    my_next[3]=5;
                end
            end else if(btnd_1pulse) begin
                state_next=IDLE;
                //turn both my,led on
                for(i=0;i<4;i=i+1) begin
                    my_next[i]=10;
                end
                led_next=65535;
            end
        end else if(state==PAYMENT) begin
            led_next=0;

            //deal with input money
            if(btnl_1pulse) begin   //1
                if(my[1]==9) begin  //09=>10
                    my_next[1]=0;
                    my_next[0]=my[0]+1;
                end else begin  //01=>02
                    my_next[1]=my[1]+1;
                    my_next[0]=my[0];
                end
            end else if(btnc_1pulse) begin  //5
                if(my[1]>=5) begin  //16=>21
                    my_next[1]=my[1]+5-10;
                    my_next[0]=my[0]+1;
                end else begin  //14=>19
                    my_next[1]=my[1]+5;
                    my_next[0]=my[0];
                end
            end else if(btnr_1pulse) begin  //10
                my_next[1]=my[1];
                my_next[0]=my[0]+1;
            end


            if(10*my[0]+my[1] >= 10*my[2]+my[3]) begin
                my_next[0]=type;
                my_next[1]=DARK;
                my_next[2]=DARK;
                my_next[3]=amount;
                remain_next = (10*my[0]+my[1]) - (10*my[2]+my[3]);
                state_next=RELEASE;
            end else if(btnd_1pulse) begin
                my_next[0]=DARK;
                my_next[1]=DARK;
                my_next[2]=my[0];
                my_next[3]=my[1];
                remain_next = 10*my[0] + my[1]; //if cancelled,return the deposited money
                state_next=CHANGE;
            end else begin
                state_next=state;
            end
        end else if(state==RELEASE) begin
            my_next[0]=type;
            my_next[1]=DARK;
            my_next[2]=DARK;
            my_next[3]=amount;
            if(led_clk_1p) begin
                led_next = ~LED;
            end

            if(onesec_clk) begin
                cycle_next=cycle+1;
            end
            if(cycle>5) begin
                my_next[0]=DARK;
                my_next[1]=DARK;
                my_next[2]=0;   //the max remain money=9,so ten must be 0
                my_next[3]=remain;
                state_next=CHANGE;
            end else begin
                state_next=state;
            end
        end else if(state==CHANGE) begin
            my_next[0]=DARK;
            my_next[1]=DARK;
            my_next[2]=my[2];
            my_next[3]=my[3];
            led_next=0;

            if(onesec_clk) begin    //slow down
                if(my[0]==DARK && my[1]==DARK && my[2]==0 && my[3]==0) begin
                    //go to IDLE state,reset everything
                    for(i=0;i<4;i=i+1) begin
                        my_next[i]=10;
                    end
                    led_next=65535;
                    state_next=IDLE;
                    amount_next=0;
                    type_next=ADULT;
                    cycle_next=0;
                    remain_next=0;
                end else begin
                    if(10*my[2] + my[3] >= 5) begin //if the total>=5,then decrease by 5
                        if(my[3]<5) begin
                            if(my[2]>0) begin   //14-5=09
                                my_next[3]=my[3]+10-5;
                                my_next[2]=my[2]-1;
                            end else begin  //09-5=04
                                my_next[3]=my[3]-5;
                                my_next[2]=my[2];
                            end
                        end else begin  //18-5=13
                            my_next[3]=my[3]-5;
                            my_next[2]=my[2];
                        end
                    end else begin  //decrease by 1
                        my_next[3]=my[3]-1;
                        my_next[2]=my[2];
                    end
                end
            end
        end
    end

    //7-segment control
    always @(posedge display_clk) begin
        case(DIGIT)
            4'b1110: begin
                value=my[2];
                DIGIT=4'b1101;
            end
            4'b1101: begin
                value=my[1];
                DIGIT=4'b1011;
            end
            4'b1011: begin
                value=my[0];
                DIGIT=4'b0111;
            end
            4'b0111: begin
                value=my[3];
                DIGIT=4'b1110;
            end
            default: begin
                value=my[3];
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
            4'd5: DISPLAY=7'b001_0010;  //'S'
            4'd6: DISPLAY=7'b000_0010;
            4'd7: DISPLAY=7'b111_1000;
            4'd8: DISPLAY=7'b000_0000;
            4'd9: DISPLAY=7'b001_0000;
            4'd10: DISPLAY=7'b011_1111; //'-'
            4'd11: DISPLAY=7'b000_1000; //'A'
            4'd12: DISPLAY=7'b100_0110; //'C'
            4'd13: DISPLAY=7'b111_1111; //all dark
            default: DISPLAY=7'b111_1111;
        endcase
    end
endmodule