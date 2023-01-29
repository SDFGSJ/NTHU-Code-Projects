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

//remember to remove debounce,onepulse
module lab06(
    input clk,
    input rst,
    inout PS2_CLK,
    inout PS2_DATA,
    output reg [3:0] DIGIT,
    output reg [6:0] DISPLAY,
    output reg [15:0] LED
);
    parameter BOTTOM = 0;
    parameter TOP = 1;
    parameter STANDBY = 2;
    parameter RUN = 3;


    wire display_clk, work_clk,work_clk_1p;
    clock_divider #(.n(13)) display(.clk(clk), .clk_div(display_clk));  //7-segment display
    clock_divider #(.n(26)) work(.clk(clk), .clk_div(work_clk));
    onepulse workclk_1p(.clk(clk),.pb_debounced(work_clk),.pb_1pulse(work_clk_1p));


    parameter [8:0] LEFT_SHIFT_CODES  = 9'b0_0001_0010;
	parameter [8:0] RIGHT_SHIFT_CODES = 9'b0_0101_1001;
	parameter [8:0] KEY_CODES [0:19] = {
		9'b0_0100_0101,	// 0 => 45
		9'b0_0001_0110,	// 1 => 16
		9'b0_0001_1110,	// 2 => 1E
		9'b0_0010_0110,	// 3 => 26
		9'b0_0010_0101,	// 4 => 25
		9'b0_0010_1110,	// 5 => 2E
		9'b0_0011_0110,	// 6 => 36
		9'b0_0011_1101,	// 7 => 3D
		9'b0_0011_1110,	// 8 => 3E
		9'b0_0100_0110,	// 9 => 46
		
		9'b0_0111_0000, // right_0 => 70
		9'b0_0110_1001, // right_1 => 69
		9'b0_0111_0010, // right_2 => 72
		9'b0_0111_1010, // right_3 => 7A
		9'b0_0110_1011, // right_4 => 6B
		9'b0_0111_0011, // right_5 => 73
		9'b0_0111_0100, // right_6 => 74
		9'b0_0110_1100, // right_7 => 6C
		9'b0_0111_0101, // right_8 => 75
		9'b0_0111_1101  // right_9 => 7D
	};

	wire [511:0] key_down;
    wire [8:0] last_change;
    wire key_valid;
	reg [3:0] key_num;
    
	wire shift_down;
	assign shift_down = (key_down[LEFT_SHIFT_CODES] == 1'b1 || key_down[RIGHT_SHIFT_CODES] == 1'b1) ? 1'b1 : 1'b0;

    
    KeyboardDecoder keydecode(
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(key_valid),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(rst),
        .clk(clk)
    );


    integer i;
    reg [3:0] value;
    reg [3:0] my[0:3], my_next[0:3]; //used for display
    reg [15:0] led_next;
    reg [2:0] state=STANDBY, state_next;
    reg climbup=1, climbup_next;
    reg [1:0] passenger=0, passenger_next;
    reg [6:0] revenue=0, revenue_next;
    reg [6:0] gas_amount=0, gas_amount_next;

    //flags
    reg getdown_finish=0, getdown_finish_next;
    reg getup_finish=0, getup_finish_next;
    reg get_revenue_finish=0, get_revenue_finish_next;

    always @(posedge clk,posedge rst) begin
        if(rst) begin
            for(i=0;i<4;i=i+1) begin
                my[i]<=0;
            end
            LED<=1; //bus stops at bottom
            state<=STANDBY;
            climbup<=1;
            passenger<=0;
            revenue<=0;
            gas_amount<=0;

            //flags
            getdown_finish<=0;
            getup_finish<=0;
            get_revenue_finish<=0;
        end else begin
            for(i=0;i<4;i=i+1) begin
                my[i]<=my_next[i];
            end
            LED<=led_next;
            state<=state_next;
            climbup<=climbup_next;
            passenger<=passenger_next;
            revenue<=revenue_next;
            gas_amount<=gas_amount_next;

            //flags
            getdown_finish<=getdown_finish_next;
            getup_finish<=getup_finish_next;
            get_revenue_finish<=get_revenue_finish_next;
        end
    end


    //[6:0] bus position
    //[15:14] people waiting at bottom
    //[12:11] people waiting at top
    //[10:9] passenger
    always @(*) begin
        for(i=0;i<4;i=i+1) begin
            my_next[i]=my[i];
        end
        led_next=LED;
        state_next=state;
        climbup_next=climbup;
        passenger_next=passenger;
        revenue_next=revenue;
        gas_amount_next=gas_amount;

        //flags
        getdown_finish_next = getdown_finish;
        getup_finish_next = getup_finish;
        get_revenue_finish_next = get_revenue_finish;

        if(key_valid && key_down[last_change]) begin
            if(key_num!=4'b1111) begin
                if(!shift_down) begin
                    if(key_num==4'b0001) begin
                        if(LED[15:14]==2'b00) begin
                            led_next[15:14]=2'b10;
                        end else if(LED[15:14]==2'b10) begin
                            led_next[15:14]=2'b11;
                        end else begin
                            led_next[15:14]=2'b11;
                        end
                    end else if(key_num==4'b0010) begin
                        if(LED[12:11]==2'b00) begin
                            led_next[12:11]=2'b10;
                        end else if(LED[12:11]==2'b10) begin
                            led_next[12:11]=2'b11;
                        end else begin
                            led_next[12:11]=2'b11;
                        end
                    end
                end
            end
        end

        if(work_clk_1p) begin
            if(state==BOTTOM) begin
                climbup_next=1;
                //get off the bus
                if(passenger>0 && !getdown_finish) begin   //have passenger => get down one by one
                    led_next[10:9] = {LED[9], 1'b0};    //left shift

                    passenger_next = passenger - 1; //update passenger count
                end else begin  //no passenger => finish get down
                    getdown_finish_next=1;
                end

                //get on the bus
                if(getdown_finish && !getup_finish) begin
                    if(LED[15:14]==2'b00 && LED[12:11]==2'b00) begin
                        state_next=STANDBY;
                    end else begin
                        led_next[10:9] = LED[15:14];    //get on the bus at once
                        led_next[15:14] = 2'b00;
                        
                        if(LED[15:14]==2'b11) begin //update passenger count
                            passenger_next = passenger + 2;
                        end else if(LED[15:14]==2'b10) begin
                            passenger_next = passenger + 1;
                        end

                        getup_finish_next=1;
                    end
                end

                //get revenue
                if(getup_finish && !get_revenue_finish) begin
                    if(revenue + passenger*30 > 90) begin   //beware of $ exceeding the maximum amount
                        revenue_next=90;
                        my_next[2]=9;
                        my_next[3]=0;
                    end else begin
                        revenue_next=revenue + passenger*30;
                        my_next[2]=(revenue + passenger*30) / 10;
                        my_next[3]=0;
                    end
                    get_revenue_finish_next=1;
                end
                
                //fueling
                if(get_revenue_finish) begin
                    if(gas_amount<20 && revenue>=10 && (LED[10:9]==2'b10 || LED[10:9]==2'b11)) begin
                        revenue_next=revenue-10;
                        my_next[2]=my[2]-1;
                        my_next[3]=0;

                        if(gas_amount+10 > 20) begin //exceed the maximum gas amount
                            gas_amount_next=20;
                            my_next[0]=2;
                            my_next[1]=0;
                        end else begin
                            gas_amount_next=gas_amount+10;
                            my_next[0]=my[0]+1;
                            my_next[1]=my[1];
                        end
                    end else begin  //finish fueling => start to run
                        state_next=RUN;

                        //reset all flags before change state
                        getdown_finish_next=0;
                        getup_finish_next=0;
                        get_revenue_finish_next=0;
                    end
                end
            end else if(state==TOP) begin
                climbup_next=0;
                //get off the bus
                if(passenger>0 && !getdown_finish) begin   //have passenger => get down one by one
                    led_next[10:9] = {LED[9], 1'b0};    //left shift

                    passenger_next = passenger - 1; //update passenger count
                end else begin
                    getdown_finish_next=1;
                end

                //get on the bus
                if(getdown_finish && !getup_finish) begin
                    if(LED[15:14]==2'b00 && LED[12:11]==2'b00) begin
                        state_next=STANDBY;
                    end else begin
                        led_next[10:9] = LED[12:11];    //get on the bus at once
                        led_next[12:11] = 2'b00;
                        
                        if(LED[12:11]==2'b11) begin //update passenger count
                            passenger_next = passenger + 2;
                        end else if(LED[12:11]==2'b10) begin
                            passenger_next = passenger + 1;
                        end

                        getup_finish_next=1;
                    end
                end

                //get revenue
                if(getup_finish && !get_revenue_finish) begin
                    if(revenue + passenger*20 > 90) begin   //beware of exceeding the maximum amount
                        revenue_next=90;
                        my_next[2]=9;
                        my_next[3]=0;
                    end else begin
                        revenue_next = revenue + passenger*20;
                        my_next[2]=(revenue + passenger*20) / 10;
                        my_next[3]=0;
                    end
                    get_revenue_finish_next=1;
                end
                
                //fueling
                if(get_revenue_finish) begin
                    if(gas_amount<20 && revenue>=10 && (LED[10:9]==2'b10 || LED[10:9]==2'b11)) begin
                        revenue_next=revenue-10;
                        my_next[2]=my[2]-1;
                        my_next[3]=0;

                        if(gas_amount+10 > 20) begin //exceed the maximum gas amount
                            gas_amount_next=20;
                            my_next[0]=2;
                            my_next[1]=0;
                        end else begin
                            gas_amount_next=gas_amount+10;
                            my_next[0]=my[0]+1;
                            my_next[1]=my[1];
                        end
                    end else begin  //finish fueling => start to run
                        state_next=RUN;

                        //reset all flags before change state
                        getdown_finish_next=0;
                        getup_finish_next=0;
                        get_revenue_finish_next=0;
                    end
                end
            end else if(state==RUN) begin
                //reach station(TOP,BOTTOM,G2),update the gas amonut

                if(climbup) begin   //left shift
                    if(LED[6:0] == 7'b0000100) begin  //about to reach the center gas station
                        if(passenger>0) begin   //if there's passenger,decrease the gas amount
                            gas_amount_next = gas_amount - passenger*5;
                            my_next[0] = (gas_amount - passenger*5) / 10;
                            my_next[1] = (gas_amount - passenger*5) % 10;
                        end
                        led_next[6:0] = 7'b0001000;
                    end else if(LED[6:0] == 7'b0001000) begin  //reach the center gas station
                        if(gas_amount<20 && revenue>=10 && (LED[10:9]==2'b10 || LED[10:9]==2'b11)) begin    //fueling only when there's passenger
                            revenue_next=revenue-10;
                            my_next[2]=my[2]-1;
                            my_next[3]=0;

                            if(gas_amount+10 > 20) begin //exceed the maximum gas amount
                                gas_amount_next=20;
                                my_next[0]=2;
                                my_next[1]=0;
                            end else begin
                                gas_amount_next=gas_amount+10;
                                my_next[0]=my[0]+1;
                                my_next[1]=my[1];
                            end
                            led_next[6:0]=7'b0001000;
                        end else begin
                            led_next[6:0]=7'b0010000;
                        end
                    end else if(LED[6:0]==7'b0100000) begin //about to reach top
                        if(passenger>0) begin   //if there's passenger,decrease the gas amount
                            gas_amount_next = gas_amount - passenger*5;
                            my_next[0] = (gas_amount - passenger*5) / 10;
                            my_next[1] = (gas_amount - passenger*5) % 10;
                        end

                        //no one on the bus && someone waiting at top => can directly get on the bus
                        if(LED[10:9]==2'b00 && (LED[12:11]==2'b10 || LED[12:11]==2'b11)) begin
                            led_next[10:9]=LED[12:11];
                            led_next[12:11]=2'b00;

                            if(LED[12:11]==2'b10) begin
                                passenger_next=passenger+1;
                            end else if(LED[12:11]==2'b11) begin
                                passenger_next=passenger+2;
                            end

                            getdown_finish_next=1;
                            getup_finish_next=1;
                        end else begin  //someone on the bus,get down one by one at top
                            getdown_finish_next=0;
                            getup_finish_next=0;
                            get_revenue_finish_next=0;
                        end
                        led_next[6:0]=7'b1000000;
                    end else if(LED[6:0] == 7'b1000000) begin //reach the top
                        climbup_next=0;
                        state_next=TOP;
                    end else begin
                        led_next[6:0]={LED[5:0],1'b0};  //left shift
                    end
                end else begin  //right shift
                    if(LED[6:0]==7'b0010000) begin  //above to reach center gas station
                        if(passenger>0) begin   //if there's passenger,decrease the gas amount
                            gas_amount_next = gas_amount - passenger*5;
                            my_next[0] = (gas_amount - passenger*5) / 10;
                            my_next[1] = (gas_amount - passenger*5) % 10;
                        end
                        led_next[6:0] = 7'b0001000;
                    end else if(LED[6:0] == 7'b0001000) begin //reach the center gas station
                        if(gas_amount<20 && revenue>=10 && (LED[10:9]==2'b10 || LED[10:9]==2'b11)) begin    //fueling only when there's passenger
                            revenue_next=revenue-10;
                            my_next[2]=my[2]-1;
                            my_next[3]=0;

                            if(gas_amount+10 > 20) begin //exceed the maximum gas amount
                                gas_amount_next=20;
                                my_next[0]=2;
                                my_next[1]=0;
                            end else begin
                                gas_amount_next=gas_amount+10;
                                my_next[0]=my[0]+1;
                                my_next[1]=my[1];
                            end
                            led_next[6:0] = 7'b0001000;
                        end else begin
                            led_next[6:0] = 7'b0000100;
                        end
                    end else if(LED[6:0]==7'b0000010) begin //above to reach bottom
                        if(passenger>0) begin   //if there's passenger,decrease the gas amount
                            gas_amount_next = gas_amount - passenger*5;
                            my_next[0] = (gas_amount - passenger*5) / 10;
                            my_next[1] = (gas_amount - passenger*5) % 10;
                        end

                        //no one on the bus && someone waiting at bottom => can directly get on the bus
                        if(LED[10:9]==2'b00 && (LED[15:14]==2'b10 || LED[15:14]==2'b11)) begin
                            led_next[10:9]=LED[15:14];
                            led_next[15:14]=2'b00;

                            if(LED[15:14]==2'b10) begin
                                passenger_next=passenger+1;
                            end else if(LED[15:14]==2'b11) begin
                                passenger_next=passenger+2;
                            end

                            getdown_finish_next=1;
                            getup_finish_next=1;
                        end else begin
                            getdown_finish_next=0;
                            getup_finish_next=0;
                            get_revenue_finish_next=0;
                        end
                        led_next[6:0]=7'b0000001;   //move to bottom
                    end else if(LED[6:0]==7'b0000001) begin //reach bottom
                        climbup_next=1;
                        state_next=BOTTOM;
                    end else begin
                        led_next[6:0]={1'b0,LED[6:1]};  //right shift
                    end
                end
            end else if(state==STANDBY) begin
                //maintain everything
                //check both bus stop
                if(LED[6:0]==7'b0000001 && (LED[15:14]==2'b10 || LED[15:14]==2'b11)) begin //bus at bottom && someone waiting at bottom
                    state_next=BOTTOM;
                end else if(LED[6:0]==7'b1000000 && (LED[12:11]==2'b10 || LED[12:11]==2'b11)) begin   //bus at top && someone waiting at top
                    state_next=TOP;
                end else if((LED[6:0]==7'b0000001 && (LED[12:11]==2'b10 || LED[12:11]==2'b11)) ||
                            (LED[6:0]==7'b1000000 && (LED[15:14]==2'b10 || LED[15:14]==2'b11)) ) begin  //bus at bottom,someone waiting at top || 
                                                                                                        //bus at top,someone waiting at bottom
                    state_next=RUN;
                end else begin
                    state_next=STANDBY;
                end
            end
        end
    end

    always @ (*) begin
		case (last_change)
			KEY_CODES[00] : key_num = 4'b0000;
			KEY_CODES[01] : key_num = 4'b0001;
			KEY_CODES[02] : key_num = 4'b0010;
			KEY_CODES[03] : key_num = 4'b0011;
			KEY_CODES[04] : key_num = 4'b0100;
			KEY_CODES[05] : key_num = 4'b0101;
			KEY_CODES[06] : key_num = 4'b0110;
			KEY_CODES[07] : key_num = 4'b0111;
			KEY_CODES[08] : key_num = 4'b1000;
			KEY_CODES[09] : key_num = 4'b1001;
			KEY_CODES[10] : key_num = 4'b0000;
			KEY_CODES[11] : key_num = 4'b0001;
			KEY_CODES[12] : key_num = 4'b0010;
			KEY_CODES[13] : key_num = 4'b0011;
			KEY_CODES[14] : key_num = 4'b0100;
			KEY_CODES[15] : key_num = 4'b0101;
			KEY_CODES[16] : key_num = 4'b0110;
			KEY_CODES[17] : key_num = 4'b0111;
			KEY_CODES[18] : key_num = 4'b1000;
			KEY_CODES[19] : key_num = 4'b1001;
			default		  : key_num = 4'b1111;
		endcase
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
            4'd5: DISPLAY=7'b001_0010;
            4'd6: DISPLAY=7'b000_0010;
            4'd7: DISPLAY=7'b111_1000;
            4'd8: DISPLAY=7'b000_0000;
            4'd9: DISPLAY=7'b001_0000;
            default: DISPLAY=7'b111_1111;
        endcase
    end
endmodule