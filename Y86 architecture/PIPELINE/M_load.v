// `timescale 1ns / 1ps
module Memory_Pipeline_Register(
    input clk,
    input M_toBubble,
    input [2 : 0] E_stat,
    input [3 : 0] E_Ins_Code,
    input [3 : 0] E_Ins_fun,
    input signed [63 : 0] E_value_A,
    input [3 : 0] E_dstM,
    input [3 : 0] e_dstE,
    input signed [63 : 0] e_Value_E,
    input e_Cnd,
    output reg [2 : 0] M_stat,
    output reg [3 : 0] M_Ins_Code,
    output reg M_cnd,
    output reg signed [63 : 0] M_Value_E,
    output reg signed [63 : 0] M_value_A,
    output reg [3 : 0] M_dstE,
    output reg [3 : 0] M_dstM,
    output reg [3 : 0] M_Ins_fun

);

always @ (posedge clk)begin
    //#0.1
    #0.1
    if(M_toBubble == 1)begin
        M_stat <= 3'd0;
        M_Ins_Code <= 4'd1;
        M_Ins_fun <= 4'd0;
        M_cnd <= 1;
        M_Value_E <= 63'd0;
        M_value_A <= 63'd0;
        M_dstE <= 4'd15;
        M_dstM <= 4'd15;
        
    end

    else begin
        M_stat <= E_stat;
        M_Ins_Code <= E_Ins_Code;
        M_Ins_fun <= E_Ins_fun;
        M_cnd <= e_Cnd;
        M_value_A <= E_value_A;
        M_Value_E <= e_Value_E;
        M_dstE <= e_dstE;
        M_dstM <= E_dstM;
    end
end
endmodule