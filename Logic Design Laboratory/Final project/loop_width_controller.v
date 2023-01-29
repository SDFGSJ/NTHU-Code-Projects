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