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