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
