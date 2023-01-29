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

module lab3_2(
    input clk,
    input rst,
    input en,
    input dir,
    output [15:0] led
);
    parameter [1:0] FLASH=2'b00;
    parameter [1:0] SHIFT=2'b01;
    parameter [1:0] EXPAND=2'b10;

    reg [15:0] out=65535,led_next=0;
    reg [1:0] state=FLASH, state_next=FLASH;
    reg [3:0] cnt=0,cnt_next=0;
    wire myclk;
    clock_divider #(.n(25)) cd25(.clk(clk), .clk_div(myclk));

    assign led=out;

    /*initial begin
        $monitor($time," state=%d, out=%d, cnt=%d",state,out,cnt);
    end*/

    //flipflop
    always @(posedge myclk,posedge rst) begin
        if(rst==1) begin
            cnt<=0;
            out<=(2**16)-1;
            state <= FLASH;
        end else begin
            cnt <= cnt_next;
            out<=led_next;
            state <= state_next;
        end
    end

    //combinationl block
    always @(*) begin
        if(en==0) begin
            cnt_next<=cnt;
            state_next<=state;
            led_next=led;
        end else begin
            if(state==FLASH) begin
                if(cnt<6*2) begin
                    cnt_next=cnt+1;
                    state_next=FLASH;
                    led_next = ~led;
                end else begin
                    state_next=SHIFT;
                    led_next=16'b1010_1010_1010_1010;
                    cnt_next=0;
                end
            end else if(state==SHIFT) begin
                state_next=SHIFT;
                case (led)
                    16'b1000_0000_0000_0000:
                        led_next=dir ? 16'b0000_0000_0000_0000 : 16'b0100_0000_0000_0000;
                    16'b0100_0000_0000_0000:
                        led_next=dir ? 16'b1000_0000_0000_0000 : 16'b1010_0000_0000_0000;
                    16'b1010_0000_0000_0000:
                        led_next=dir ? 16'b0100_0000_0000_0000 : 16'b0101_0000_0000_0000;
                    16'b0101_0000_0000_0000:
                        led_next=dir ? 16'b1010_0000_0000_0000 : 16'b1010_1000_0000_0000;
                    16'b1010_1000_0000_0000:
                        led_next=dir ? 16'b0101_0000_0000_0000 : 16'b0101_0100_0000_0000;
                    16'b0101_0100_0000_0000:
                        led_next=dir ? 16'b1010_1000_0000_0000 : 16'b1010_1010_0000_0000;
                    16'b1010_1010_0000_0000:
                        led_next=dir ? 16'b0101_0100_0000_0000 : 16'b0101_0101_0000_0000;
                    16'b0101_0101_0000_0000:
                        led_next=dir ? 16'b1010_1010_0000_0000 : 16'b1010_1010_1000_0000;
                    16'b1010_1010_1000_0000:
                        led_next=dir ? 16'b0101_0101_0000_0000 : 16'b0101_0101_0100_0000;
                    16'b0101_0101_0100_0000:
                        led_next=dir ? 16'b1010_1010_1000_0000 : 16'b1010_1010_1010_0000;
                    16'b1010_1010_1010_0000:
                        led_next=dir ? 16'b0101_0101_0100_0000 : 16'b0101_0101_0101_0000;
                    16'b0101_0101_0101_0000:
                        led_next=dir ? 16'b1010_1010_1010_0000 : 16'b1010_1010_1010_1000;
                    16'b1010_1010_1010_1000:
                        led_next=dir ? 16'b0101_0101_0101_0000 : 16'b0101_0101_0101_0100;
                    16'b0101_0101_0101_0100:
                        led_next=dir ? 16'b1010_1010_1010_1000 : 16'b1010_1010_1010_1010;
                    16'b1010_1010_1010_1010:
                        led_next=dir ? 16'b0101_0101_0101_0100 : 16'b0101_0101_0101_0101;
                    16'b0101_0101_0101_0101:
                        led_next=dir ? 16'b1010_1010_1010_1010 : 16'b0010_1010_1010_1010;
                    16'b0010_1010_1010_1010:
                        led_next=dir ? 16'b0101_0101_0101_0101 : 16'b0001_0101_0101_0101;
                    16'b0001_0101_0101_0101:
                        led_next=dir ? 16'b0010_1010_1010_1010 : 16'b0000_1010_1010_1010;
                    16'b0000_1010_1010_1010:
                        led_next=dir ? 16'b0001_0101_0101_0101 : 16'b0000_0101_0101_0101;
                    16'b0000_0101_0101_0101:
                        led_next=dir ? 16'b0000_1010_1010_1010 : 16'b0000_0010_1010_1010;
                    16'b0000_0010_1010_1010:
                        led_next=dir ? 16'b0000_0101_0101_0101 : 16'b0000_0001_0101_0101;
                    16'b0000_0001_0101_0101:
                        led_next=dir ? 16'b0000_0010_1010_1010 : 16'b0000_0000_1010_1010;
                    16'b0000_0000_1010_1010:
                        led_next=dir ? 16'b0000_0001_0101_0101 : 16'b0000_0000_0101_0101;
                    16'b0000_0000_0101_0101:
                        led_next=dir ? 16'b0000_0000_1010_1010 : 16'b0000_0000_0010_1010;
                    16'b0000_0000_0010_1010:
                        led_next=dir ? 16'b0000_0000_0101_0101 : 16'b0000_0000_0001_0101;
                    16'b0000_0000_0001_0101:
                        led_next=dir ? 16'b0000_0000_0010_1010 : 16'b0000_0000_0000_1010;
                    16'b0000_0000_0000_1010:
                        led_next=dir ? 16'b0000_0000_0001_0101 : 16'b0000_0000_0000_0101;
                    16'b0000_0000_0000_0101:
                        led_next=dir ? 16'b0000_0000_0000_1010 : 16'b0000_0000_0000_0010;
                    16'b0000_0000_0000_0010:
                        led_next=dir ? 16'b0000_0000_0000_0101 : 16'b0000_0000_0000_0001;
                    16'b0000_0000_0000_0001:
                        led_next=dir ? 16'b0000_0000_0000_0010 : 16'b0000_0000_0000_0000;
                    16'b0000_0000_0000_0000: begin
                        led_next=16'b0000_0001_1000_0000;
                        state_next=EXPAND;
                    end
                endcase
            end else if(state==EXPAND) begin
                if(dir==0) begin    //expand
                    if(led==0) begin    //special case
                        state_next=EXPAND;
                        led_next=16'b0000_0001_1000_0000;
                    end else begin
                        state_next=EXPAND;
                        led_next=(led<<1) | (led>>1);
                    end
                end else begin  //shrink
                    state_next=EXPAND;
                    led_next=(led<<1) & (led>>1);
                end
                if(led==2**16-1) begin
                    state_next=FLASH;
                    led_next=0;
                    cnt_next=1;
                end
            end else begin
                state_next=FLASH;
                led_next=0;
                cnt_next=0;
            end
        end
    end
endmodule