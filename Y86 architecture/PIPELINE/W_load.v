// `timescale 1ns / 1ps
module WriteBack_Pipeline_Register(
    input clk,
    input [2 : 0] m_stat,
    input [3 : 0] M_Ins_Code,
    input signed [63 : 0] M_Value_E,
    input signed [63 : 0] m_Value_M,
    input [3 : 0] M_dstE,
    input [3 : 0] M_dstM,
    output reg [2 : 0] W_stat,
    output reg [3 : 0] W_Ins_Code,
    output reg signed [63 : 0] W_Value_E,
    output reg signed [63 : 0] W_Value_M,
    output reg [3 : 0] W_dstE,
    output reg [3 : 0] W_dstM

);


always @(posedge clk)begin
    W_stat <= m_stat;
    W_Ins_Code <= M_Ins_Code;
    W_Value_E <= M_Value_E;
    W_Value_M <= m_Value_M;
    W_dstE <= M_dstE;
    W_dstM <= M_dstE;
end
endmodule