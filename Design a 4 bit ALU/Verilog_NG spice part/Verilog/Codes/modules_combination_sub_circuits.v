
module DECODER_2_4(input S0, input S1, output D0,D1,D2,D3);

wire S0c, S1c;
NOT N_A(.A(S0), .C(S0c));
NOT N_B(.A(S1), .C(S1c));
AND and_d0(.A(S0c), .B(S1c), .C(D0));
AND and_d1(.A(S0), .B(S1c), .C(D1));
AND and_d2(.A(S0c), .B(S1), .C(D2));
AND and_d3(.A(S0), .B(S1), .C(D3));

endmodule

module ENABLE_FOR_A_B(input [3:0] A, input [3:0] B,input  Decoder_output, output [3:0] A_enabled, output [3:0] B_enabled);
AND a_0(.A(A[0]) , .B(Decoder_output), .C(A_enabled[0]));
AND b_0(.A(B[0]) , .B(Decoder_output), .C(B_enabled[0]));
AND a_1(.A(A[1]) , .B(Decoder_output), .C(A_enabled[1]));
AND b_1(.A(B[1]) , .B(Decoder_output), .C(B_enabled[1]));
AND a_2(.A(A[2]) , .B(Decoder_output), .C(A_enabled[2]));
AND b_2(.A(B[2]) , .B(Decoder_output), .C(B_enabled[2]));
AND a_3(.A(A[3]) , .B(Decoder_output), .C(A_enabled[3]));
AND b_3(.A(B[3]) , .B(Decoder_output), .C(B_enabled[3]));

endmodule

module FULL_ADDER(input A, input  B, input wire C, output S_final, output C_final);
wire S1, and_1, and_2, and_3, C1;
XOR xor_of_ab(.A(A), .B(B), .C(S1));
XOR final_sum(.A(S1), .B(C), .C(S_final));
AND and_ab(.A(A), .B(B), .C(and_1));
AND and_bc(.A(B), .B(C), .C(and_2));
AND and_ca(.A(C), .B(A), .C(and_3));
OR or1(.A(and_1), .B(and_2), .C(C1));
OR final_carry(.A(C1), .B(and_3), .C(C_final));
endmodule

module ADDER_SUBTRATOR(input [3:0] A, input [3:0] B, input D0, input D1, output [4:0] S_add);
wire C1,C2,C3;
wire [3:0] A_enabled;
wire [3:0] B_enabled;
wire enable_input;
or Menable_input(enable_input, D0,D1);
ENABLE_FOR_A_B enabling_a_b_for_add(.A(A), .B(B), .Decoder_output(enable_input), .A_enabled(A_enabled), .B_enabled(B_enabled));
XOR Mxor_b0_d1(.A(B_enabled[0]), .B(D1), .C(xor_b0_d1));
XOR Mxor_b1_d1(.A(B_enabled[1]), .B(D1), .C(xor_b1_d1));
XOR Mxor_b2_d1(.A(B_enabled[2]), .B(D1), .C(xor_b2_d1));
XOR Mxor_b3_d1(.A(B_enabled[3]), .B(D1), .C(xor_b3_d1));
FULL_ADDER adder_1(.A(A_enabled[0]), .B(xor_b0_d1), .C(D1), .S_final(S_add[0]), .C_final(C1));
FULL_ADDER adder_2(.A(A_enabled[1]), .B(xor_b1_d1), .C(C1), .S_final(S_add[1]), .C_final(C2));
FULL_ADDER adder_3(.A(A_enabled[2]), .B(xor_b2_d1), .C(C2), .S_final(S_add[2]), .C_final(C3));
FULL_ADDER adder_4(.A(A_enabled[3]), .B(xor_b3_d1), .C(C3), .S_final(S_add[3]), .C_final(S_add[4]));
endmodule

module COMPARATOR(input [3:0] A, input [3:0] B, input D2, output s_equal, output s_greater, output s_lesser);
wire [3:0] A_enabled;
wire [3:0] B_enabled;
ENABLE_FOR_A_B enabling_a_b_for_compare(.A(A), .B(B), .Decoder_output(D2), .A_enabled(A_enabled), .B_enabled(B_enabled));
// structural code when two inputs are equal
wire xnor_ab0,xnor_ab1,xnor_ab2,xnor_ab3;
XNOR Ca0(.A(A_enabled[0]), .B(B_enabled[0]), .C(xnor_ab0));
XNOR Ca1(.A(A_enabled[1]), .B(B_enabled[1]), .C(xnor_ab1));
XNOR Ca2(.A(A_enabled[2]), .B(B_enabled[2]), .C(xnor_ab2));
XNOR Ca3(.A(A_enabled[3]), .B(B_enabled[3]), .C(xnor_ab3));
wire equal_and_1, equal_and_2;
AND anding_a0_a1(.A(xnor_ab0), .B(xnor_ab1), .C(equal_and_1));
AND anding_a2_a3(.A(xnor_ab2), .B(xnor_ab3), .C(equal_and_2));
AND equal_output(.A(equal_and_1), .B(equal_and_2), .C(s_equal));

// structural code when first input is greater than second input
// A>B
wire a3_greater_b3,a2_greater_b2, a1_greater_b1,a0_greater_b0;
wire a3_equal_b3, a2_equal_b2, a1_equal_b1, a0_equal_b0,a3_eq_b3_a2_gt_b2,a3_eq_b3_a2_eq_b2, a3_eq_b3_a2_eq_b2_a1_gt_b1;
wire a1_eq_b1_a0_gt_b0, a3_eq_b3_a2_eq_b2_a1_eq_b1_a0_gt_b0;
wire b3c,b2c,b1c,b0c;
wire a3c,a2c,a1c,a0c;
NOT cb3(.A(B_enabled[3]), .C(b3c));
NOT cb2(.A(B_enabled[2]), .C(b2c));
NOT cb1(.A(B_enabled[1]), .C(b1c));
NOT cb0(.A(B_enabled[0]), .C(b0c));
NOT ca3(.A(A_enabled[3]), .C(a3c));
NOT ca2(.A(A_enabled[2]), .C(a2c));
NOT ca1(.A(A_enabled[1]), .C(a1c));
NOT ca0(.A(A_enabled[0]), .C(a0c));
wire A_GT_B_1, A_GT_B_2;

wire a3_lesser_b3,a2_lesser_b2, a1_lesser_b1,a0_lesser_b0;
wire a3_eq_b3_a2_ls_b2, a3_eq_b3_a2_eq_b2_a1_ls_b1;
wire a1_eq_b1_a0_ls_b0, a3_eq_b3_a2_eq_b2_a1_eq_b1_a0_ls_b0;
wire A_LS_B_1, A_LS_B_2, A_LS_B;


AND Ma3_greater_b3(.A(A_enabled[3]), .B(b3c), .C(a3_greater_b3));
AND Ma2_greater_b2(.A(A_enabled[2]), .B(b2c), .C(a2_greater_b2));
AND Ma1_greater_b1(.A(A_enabled[1]), .B(b1c), .C(a1_greater_b1));
AND Ma0_greater_b0(.A(A_enabled[0]), .B(b0c), .C(a0_greater_b0));
AND Ma3_eq_b3_a2_gt_b2(.A(xnor_ab3), .B(a2_greater_b2), .C(a3_eq_b3_a2_gt_b2));
AND Ma3_eq_b3_a2_eq_b2(.A(xnor_ab3), .B(xnor_ab2), .C(a3_eq_b3_a2_eq_b2));
AND Ma3_eq_b3_a2_eq_b2_a1_gt_b1(.A(a3_eq_b3_a2_eq_b2), .B(a1_greater_b1), .C(a3_eq_b3_a2_eq_b2_a1_gt_b1));
AND Ma1_eq_b1_a0_gt_b0(.A(xnor_ab1), .B(a0_greater_b0), .C(a1_eq_b1_a0_gt_b0));
AND Ma3_eq_b3_a2_eq_b2_a1_eq_b1_a0_gt_b0(.A(a1_eq_b1_a0_gt_b0), .B(a3_eq_b3_a2_eq_b2), .C(a3_eq_b3_a2_eq_b2_a1_eq_b1_a0_gt_b0));
OR MA_GT_B_1(.A(a3_greater_b3), .B(a3_eq_b3_a2_gt_b2), .C(A_GT_B_1));
OR MA_GT_B_2(.A(a3_eq_b3_a2_eq_b2_a1_gt_b1), .B(a3_eq_b3_a2_eq_b2_a1_eq_b1_a0_gt_b0), .C(A_GT_B_2));
OR MA_GT_B(.A(A_GT_B_1), .B(A_GT_B_2), .C(s_greater));


AND Ma3_lesser_b3(.A(a3c), .B(B_enabled[3]), .C(a3_lesser_b3));
AND Ma2_lesser_b2(.A(a2c), .B(B_enabled[2]), .C(a2_lesser_b2));
AND Ma1_lesser_b1(.A(a1c), .B(B_enabled[1]), .C(a1_lesser_b1));
AND Ma0_lesser_b0(.A(a0c), .B(B_enabled[0]), .C(a0_lesser_b0));
AND Ma3_eq_b3_a2_ls_b2(.A(xnor_ab3), .B(a2_lesser_b2), .C(a3_eq_b3_a2_ls_b2));
AND Ma3_eq_b3_a2_eq_b2_a1_ls_b1(.A(a3_eq_b3_a2_eq_b2), .B(a1_lesser_b1), .C(a3_eq_b3_a2_eq_b2_a1_ls_b1));
AND Ma1_eq_b1_a0_ls_b0(.A(xnor_ab1), .B(a0_lesser_b0), .C(a1_eq_b1_a0_ls_b0));
AND Ma3_eq_b3_a2_eq_b2_a1_eq_b1_a0_ls_b0(.A(a1_eq_b1_a0_ls_b0), .B(a3_eq_b3_a2_eq_b2), .C(a3_eq_b3_a2_eq_b2_a1_eq_b1_a0_ls_b0));
OR MA_LS_B_1(.A(a3_lesser_b3), .B(a3_eq_b3_a2_ls_b2), .C(A_LS_B_1));
OR MA_LS_B_2(.A(a3_eq_b3_a2_eq_b2_a1_ls_b1), .B(a3_eq_b3_a2_eq_b2_a1_eq_b1_a0_ls_b0), .C(A_LS_B_2));
OR MA_LS_B(.A(A_LS_B_1), .B(A_LS_B_2), .C(s_lesser));

endmodule

module ANDING(input [3:0] A, input [3:0] B, input D3 ,output  [3:0] S_anding);
wire [3:0] A_enabled;
wire [3:0] B_enabled;
ENABLE_FOR_A_B enabling_a_b_for_and(.A(A), .B(B), .Decoder_output(D3), .A_enabled(A_enabled), .B_enabled(B_enabled));
AND ab3(.A(A_enabled[3]), .B(B_enabled[3]), .C(S_anding[3]));
AND ab2(.A(A_enabled[2]), .B(B_enabled[2]), .C(S_anding[2]));
AND ab1(.A(A_enabled[1]), .B(B_enabled[1]), .C(S_anding[1]));
AND ab0(.A(A_enabled[0]), .B(B_enabled[0]), .C(S_anding[0]));
endmodule
