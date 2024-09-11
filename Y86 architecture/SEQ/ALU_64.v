module DECODER (input S0,input S1,output D0,output D1,output D2,output D3);
wire out1;
wire out2; 

not notgate1(out1,S0);
not notgate2(out2,S1);
and andgate1(D0,out1,out2);
and andgate2(D1,out2,S0);
and andgate3(D2,out1,S1);
and andgate4(D3,S0,S1);

endmodule

module ENABLE_BLOCK(input wire signed [63:0]Ain, input  wire signed [63:0]Bin, input wire D, output signed [63:0]A_enable, output signed [63:0] B_enable );
genvar count;
generate
    for (count = 0; count < 64 ; count = count + 1)begin
        and Ain_and_D(A_enable[count], Ain[count],D);
        and Bin_and_D(B_enable[count], Bin[count],D);

    end
endgenerate
endmodule

module FULL_ADDER(input Ain, input Bin, input Cin, output S_final, output C_final);
wire S1, and_1, and_2, and_3, C1;
xor xor_of_ab(S1,Ain, Bin);
xor final_sum_bit(S_final,S1, Cin);
and and_ab(and_1,Ain,Bin);
and and_bc(and_2,Bin, Cin);
and and_ca(and_3,Cin, Ain);
or or1(C1,and_1, and_2);
or final_carry(C_final,and_3,C1);
endmodule

module ADDER_64(input signed [63:0]Ain, input signed [63:0] Bin, input D0, output signed [63:0] carry_outputs,output signed [64:0]Sum);
wire signed [63:0] A_enabled;
wire signed [63:0] B_enabled;
ENABLE_BLOCK enabling_A_B_for_add(.Ain(Ain), .Bin(Bin), .D(D0), .A_enable(A_enabled), .B_enable(B_enabled));
genvar count;
generate
    FULL_ADDER Adding_first_bits(.Ain(A_enabled[0]), .Bin(B_enabled[0]), .Cin(1'b0), .S_final(Sum[0]), .C_final(carry_outputs[0]));
    for(count = 1 ;count < 63 ; count = count+1)begin
         FULL_ADDER A_count_add_B_count_add_carry(.Ain(A_enabled[count]), .Bin(B_enabled[count]), .Cin(carry_outputs[count-1]), .S_final(Sum[count]), .C_final(carry_outputs[count]));
    end
    FULL_ADDER Adding_last_bits(.Ain(A_enabled[63]), .Bin(B_enabled[63]), .Cin(carry_outputs[62]), .S_final(Sum[63]), .C_final(Sum[64]));
endgenerate

endmodule

module AND_64(input signed [63:0]Ain, input signed [63:0] Bin, input D2, output signed [63:0] AND);
wire signed [63:0] A_enabled,B_enabled;
ENABLE_BLOCK enabling_A_B_for_and(.Ain(Ain), .Bin(Bin), .D(D2), .A_enable(A_enabled), .B_enable(B_enabled));
genvar count;
generate
    for (count = 0; count < 64;count = count+1)begin
        and A_count_and_B_count(AND[count], A_enabled[count], B_enabled[count]);
    end
endgenerate
endmodule

module XOR_64(input signed [63:0]Ain, input signed [63:0] Bin, input D3, output signed [63:0] XOR);
wire signed [63:0] A_enabled,B_enabled;
ENABLE_BLOCK enabling_A_B_for_XOR(.Ain(Ain), .Bin(Bin), .D(D3), .A_enable(A_enabled), .B_enable(B_enabled));
genvar count;
generate

    for (count = 0; count < 64;count = count+1)begin
        xor A_count_XOR_B_count(XOR[count], A_enabled[count], B_enabled[count]);
    end
endgenerate
endmodule


module SUB_64(input signed [63:0]Ain, input signed [63:0] Bin, input D1, output signed [63:0] carry_outputs,output signed [64:0]Sum);
wire signed [63:0] A_enabled,B_enabled;
ENABLE_BLOCK enabling_A_B_for_subtract(.Ain(Ain), .Bin(Bin), .D(D1), .A_enable(A_enabled), .B_enable(B_enabled));
genvar count;
generate
    xor B_enabled_0_flipped(B_enabled_0_flip, B_enabled[0], D1);
    FULL_ADDER Sub_for_first_bits(.Ain(A_enabled[0]), .Bin(B_enabled_0_flip), .Cin(D1), .S_final(Sum[0]), .C_final(carry_outputs[0]));
    for(count = 1 ;count < 63 ; count = count+1)begin
        xor B_enabled_count_bit(B_enabled_flipped, B_enabled[count], D1);
         FULL_ADDER A_count_sub_B_count_add_carry(.Ain(A_enabled[count]), .Bin(B_enabled_flipped), .Cin(carry_outputs[count-1]), .S_final(Sum[count]), .C_final(carry_outputs[count]));
    end
    xor B_enabled_last_bit(B_63_flipped, B_enabled[63],D1);
    FULL_ADDER subtracting_last_bits(.Ain(A_enabled[63]), .Bin(B_63_flipped), .Cin(carry_outputs[62]), .S_final(Sum[63]), .C_final(Sum[64]));
endgenerate
endmodule

module Final_output_Calculating_Module(input signed  [64:0] sum_out, input signed [64:0] sub_out, input signed [63:0] Xor_out, input signed [63:0] And_out, output signed [64:0] final_output);
genvar count;
generate
    for(count = 0; count<64; count = count+1)begin
        or Or_of_output_bits(final_output[count], sum_out[count], sub_out[count], Xor_out[count], And_out[count]);
    end
    or OR_of_last_carry_bits_of_sum_sub(final_output[64], sum_out[64], sub_out[64]);
endgenerate
endmodule

// module ALU_BLOCK(input [63:0] Ain, input [63:0] Bin, input S0, input S1, output [64:0] Final_output);
// wire D0,D1,D2,D3;
// DECODER Decoding_select_lines(.S0(S0), .S1(S1), .D0(D0), .D1(D1),.D2(D2), .D3(D3));
// wire [64:0] Sum; wire[63:0] carry_outputs_add;
// ADDER_64 Adder_Block(.Ain(Ain), .Bin(Bin), .D0(D0), .carry_outputs(carry_outputs_add), .Sum(Sum));
// wire [64:0] Sub; wire [63:0] carry_outputs_sub;
// SUB_64 Subtractor_Block(.Ain(Ain), .Bin(Bin), .D1(D1), .carry_outputs(carry_outputs_sub), .Sum(Sub));
// wire [63:0] AND;
// AND_64 Ander_Block(.Ain(Ain), .Bin(Bin), .D2(D2), .AND(AND));
// wire [63:0] XOR;
// XOR_64 Xor_Block(.Ain(Ain), .Bin(Bin), .D3(D3), .XOR(XOR));
// Final_output_Calculating_Module Final_output_calculate(.sum_out(Sum), .sub_out(Sub), .Xor_out(XOR), .And_out(AND), .final_output(Final_output));


// endmodule

module ALU_BLOCK(
    input signed [63:0] Ain,
    input signed [63:0] Bin,
    input S0,
    input S1,
    output signed [64:0] Final_Output
);

wire D0, D1, D2, D3;
DECODER Decoding_select_lines(.S0(S0), .S1(S1), .D0(D0), .D1(D1), .D2(D2), .D3(D3));

wire signed [64:0] Sum;
wire signed [63:0] carry_outputs_add;
ADDER_64 Adder_Block(
    .Ain(Ain),
    .Bin(Bin),
    .D0(D0),
    .carry_outputs(carry_outputs_add),
    .Sum(Sum)
);

wire signed [64:0] Sub;
wire signed [63:0] carry_outputs_sub;
SUB_64 Subtractor_Block(
    .Ain(Ain),
    .Bin(Bin),
    .D1(D1),
    .carry_outputs(carry_outputs_sub),
    .Sum(Sub)
);

wire signed [63:0] AND;
AND_64 Ander_Block(
    .Ain(Ain),
    .Bin(Bin),
    .D2(D2),
    .AND(AND)
);

wire signed [63:0] XOR;
XOR_64 Xor_Block(
    .Ain(Ain),
    .Bin(Bin),
    .D3(D3),
    .XOR(XOR)
);

Final_output_Calculating_Module Final_output_calculate(
    .sum_out(Sum),
    .sub_out(Sub),
    .Xor_out(XOR),
    .And_out(AND),
    .final_output(Final_Output)
);

endmodule
