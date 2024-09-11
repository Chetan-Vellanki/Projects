// `timescale 1ns / 1ps
module Execute_pipeline_register(
    input clk,
    input E_toBubble,
    input [2 : 0] D_stat,
    input [3 : 0] D_Ins_Code,
    input [3 : 0] D_Ins_fun,
    input signed [63 : 0] D_Val_C,
    input signed [63 : 0] d_value_A,
    input signed [63 : 0] d_value_B,
    input [3 : 0] d_dstE,
    input [3 : 0] d_dstM,
    input [3 : 0] d_srcA,
    input [3 : 0] d_srcB,
    output reg [2 : 0] E_stat,
    output reg [3 : 0] E_Ins_Code,
    output reg [3 : 0] E_Ins_fun,
    output reg signed [63 : 0] E_Val_C,
    output reg signed [63 : 0] E_value_A,
    output reg signed [63 : 0] E_value_B,
    output reg [3 : 0] E_srcA,
    output reg [3 : 0] E_srcB

);

always @(posedge clk)begin
    #0.2
    if(E_toBubble == 1)begin
        E_stat <= 3'd0;
        E_Ins_Code <= 4'd1;
        E_Ins_fun <= 4'd0;
        E_Val_C <= 63'd0;
        E_value_A <= 63'd0;
        E_value_B <= 63'd0;
        E_srcA <= 63'd0;
        E_srcB <= 63'd0;

    end

    else begin
        E_stat <= D_stat;
        E_Ins_Code <= D_Ins_Code;
        E_Ins_fun <= D_Ins_fun;
        E_Val_C <= D_Val_C;
        E_value_A <= d_value_A;
        E_value_B <= d_value_B;
        E_srcA <= d_srcA;
        E_srcB <= d_srcB;
    end
end


endmodule