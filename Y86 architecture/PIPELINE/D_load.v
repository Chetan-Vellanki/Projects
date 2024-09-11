// `timescale 1ns / 1ps
module Load_Decode_Pipeline_Register(
    input clk,
    input [2 : 0] f_stat,
    input [3 : 0] f_Ins_Code,
    input [3 : 0] f_Ins_fun,
    input [3 : 0] f_rA,
    input [3 : 0] f_rB,
    input signed [63 : 0] f_Val_C,
    input [63 : 0] f_Val_P,
    input D_toBubble,
    input D_tostall, 
    output reg [2 : 0] D_stat,
    output reg [3 : 0] D_Ins_Code,
    output reg [3 : 0] D_Ins_fun,
    output reg [3 : 0] D_rA,
    output reg [3 : 0] D_rB,
    output reg signed [63 : 0] D_Val_C,
    output reg [63 : 0] D_Val_P
);

// initial begin
//     D_toBubble = 0;
//     D_tostall = 0;
// end
/////////To write this at the main architecture module (TEST BENCH)

always @ (posedge clk)begin
   #0.3
    if(D_toBubble == 1)begin
        D_Ins_Code <= 4'd1;
        D_Ins_fun <= 4'd0;
        D_stat <= 3'd0;

    end

    else if(D_tostall != 1)begin
        D_Ins_Code <= f_Ins_Code;
        D_Ins_fun <= f_Ins_fun;
        D_stat <= f_stat;
        D_rA <= f_rA;
        D_rB <= f_rB;
        D_Val_C <= f_Val_C;
        D_Val_P <= f_Val_P;
    end
end
endmodule