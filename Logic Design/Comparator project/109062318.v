module Comparator_4bits(A,B,A_lt_B,A_gt_B,A_eq_B);

input [4-1:0] A;
input [4-1:0] B;
output A_lt_B,A_gt_B,A_eq_B;

//not:8
wire a0_inv , a1_inv , a2_inv , a3_inv , b0_inv , b1_inv , b2_inv , b3_inv;

//and:15
wire na3_b3 , a3_nb3 , na2_b2 , a2_nb2 , na1_b1 , a1_nb1 , na0_b0 , a0_nb0;
wire output9 , output10 , output11, output12, output13, output14;

//nor:4
wire x3 , x2 , x1 , x0;


//inverter
not not_a3(a3_inv,A[3]);
not not_a2(a2_inv,A[2]);
not not_a1(a1_inv,A[1]);
not not_a0(a0_inv,A[0]);
not not_b3(b3_inv,B[3]);
not not_b2(b2_inv,B[2]);
not not_b1(b1_inv,B[1]);
not not_b0(b0_inv,B[0]);



and and1(na3_b3 , a3_inv , B[3]);
and and2(a3_nb3 , A[3] , b3_inv);
and and3(na2_b2 , a2_inv , B[2]);
and and4(a2_nb2 , A[2] , b2_inv);
and and5(na1_b1 , a1_inv , B[1]);
and and6(a1_nb1 , A[1] , b1_inv);
and and7(na0_b0 , a0_inv , B[0]);
and and8(a0_nb0 , A[0] , b0_inv);



nor nor3(x3 , na3_b3 , a3_nb3);
nor nor2(x2 , na2_b2 , a2_nb2);
nor nor1(x1 , na1_b1 , a1_nb1);
nor nor0(x0 , na0_b0 , a0_nb0);



and and9(output9 , x3 , na2_b2);
and and10(output10 , x3 , a2_nb2);
and and11(output11 , x3 , x2 , na1_b1);
and and12(output12 , x3 , x2 , a1_nb1);
and and13(output13 , x3 , x2 , x1 , na0_b0);
and and14(output14 , x3 , x2 , x1 , a0_nb0);

and and15(A_eq_B , x3 , x2 , x1 , x0);
or altb(A_lt_B , na3_b3 , output9 , output11 , output13);
or agtb(A_gt_B , a3_nb3 , output10, output12 , output14);


endmodule