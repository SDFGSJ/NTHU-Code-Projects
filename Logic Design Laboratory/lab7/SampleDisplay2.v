module SampleDisplay(
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
);
	parameter [8:0] LEFT_SHIFT_CODES  = 9'b0_0001_0010;
	parameter [8:0] RIGHT_SHIFT_CODES = 9'b0_0101_1001;
	parameter [8:0] KEY_CODES [0:11] = {
		9'b0_0100_0100,	// o => 44
		9'b0_0100_1101,	// p => 4d
		9'b0_0101_0100,	// [ => 54
		9'b0_0101_1011,	// ] => 5b
		9'b0_0100_0010,	// k => 42
		9'b0_0100_1011,	// l => 4b
		9'b0_0100_1100,	// ; => 4c
		9'b0_0101_0010,	// ' => 52
		9'b0_0011_1010,	// m => 3a
		9'b0_0100_0001,	// , => 41
		9'b0_0100_1001, // . => 49
		9'b0_0100_1010 // / => 4a
	};
	
	reg [15:0] nums;
	reg [3:0] key_num;
	
	wire shift_down;
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	
	assign shift_down = (key_down[LEFT_SHIFT_CODES] == 1'b1 || key_down[RIGHT_SHIFT_CODES] == 1'b1) ? 1'b1 : 1'b0;
		
	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);

	always @ (posedge clk, posedge rst) begin
		if (rst) begin
			nums <= 16'b0;
		end else begin
			nums <= nums;
			if (been_ready && key_down[last_change] == 1'b1) begin
				if (key_num != 4'b1111)begin
					if (shift_down == 1'b1) begin
						//nums <= {key_num, nums[15:4]};
					end else begin
						//nums <= {nums[11:0], key_num};
					end
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
			KEY_CODES[10] : key_num = 4'b1010;
			KEY_CODES[11] : key_num = 4'b1011;
			default		  : key_num = 4'b1111;
		endcase
	end
	
endmodule
