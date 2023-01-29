`timescale 1ns / 1ps

module Lab1_Team5_Comparator_4bits_tb;
reg [3:0] A,B;
wire A_lt_B, A_gt_B, A_eq_B;

Comparator_4bits c(A, B, A_lt_B, A_gt_B, A_eq_B);
initial begin

    A=4'b0000;
    B=4'b0000;
    // edit your own testbench
	repeat (16 * 16) begin
		#100
		A = A + 1;
		if(A === 4'b0000)
		begin
			A = 0;
			B = B + 1;	
		end
	end
    $finish;    
end
initial begin
    $monitor("A = %b , B = %b , A_lt_B=%b,A_gt_B=%b,A_eq_B=%b, success=%b",A,B,A_lt_B, A_gt_B, A_eq_B, (((A>B&A_gt_B)|(A<=B&!A_gt_B))&((A<B&A_lt_B)|(A>=B&!A_lt_B))&((A==B&A_eq_B)|(A!=B&!A_eq_B))));
end
endmodule
