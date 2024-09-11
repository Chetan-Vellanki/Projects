// `timescale 1ns / 1ps
module Decode(
    input clk,
    input [3 : 0] D_Ins_Code,
    input [3 : 0] D_Ins_fun,
    input [3 : 0] D_rA,
    input [3 : 0] D_rB,
    input [2 : 0] D_stat,
    input signed [63 : 0] D_Val_C,
    input [63 : 0] D_Val_P,
    input [3 : 0] e_dstE,
    input signed [63 : 0] e_Value_E,
    input [3 : 0] M_dstE,
    input [3 : 0] M_dstM,
    input signed [63 : 0] m_Value_M,
    input signed [63 : 0] M_Value_E,
    input [3 : 0] W_dstM,
    input signed [63 : 0] W_Value_M,
    input [3 : 0] W_dstE,
    input signed [63 : 0] W_Value_E,
    output reg signed [63 : 0] d_value_A,
    output reg signed [63 : 0] d_value_B,
    output reg signed [63 : 0] d_rvalue_A,
    output reg signed [63 : 0] d_rvalue_B,
    output reg [3 : 0] d_srcA,
    output reg [3 : 0] d_srcB,
    output reg [3 : 0] d_dstE,
    output reg [3 : 0] d_dstM,
    output reg signed  [63 : 0] rax,
    output reg signed [63 : 0] rcx,
    output reg signed [63 : 0] rdx,
    output reg signed [63 : 0] rbx,
    output reg [63 : 0] rsp,
    output reg signed [63 : 0] rbp,
    output reg signed [63 : 0] rsi,
    output reg signed [63 : 0] rdi,
    output reg signed [63 : 0] r8,
    output reg signed [63 : 0] r9,
    output reg signed [63 : 0] r10,
    output reg signed [63 : 0] r11,
    output reg signed [63 : 0] r12,
    output reg signed [63 : 0] r13,
    output reg signed [63 : 0] r14

    // getting outputs from fetch stage for 

);
reg signed [63 : 0] Program_Registers_adress [0 : 14];
initial begin
    Program_Registers_adress[0] = 64'd1;
    Program_Registers_adress[1] = 64'd2;
    Program_Registers_adress[2] = 64'd4;
    Program_Registers_adress[3] = 64'd8;
    Program_Registers_adress[4] = 64'd256;
    Program_Registers_adress[5] = 64'd32;
    Program_Registers_adress[6] = 64'd64;
    Program_Registers_adress[7] = 64'd128;
    Program_Registers_adress[8] = 64'd256;
    Program_Registers_adress[9] = 64'd512;
    Program_Registers_adress[10] = 64'd1024;
    Program_Registers_adress[11] = 64'd2048;
    Program_Registers_adress[12] = 64'd4096;
    Program_Registers_adress[13] = 64'd8192;
    Program_Registers_adress[14] = 64'd16384;


    rax = Program_Registers_adress[0][63 : 0];
    rcx = Program_Registers_adress[1][63 : 0];
    rdx = Program_Registers_adress[2][63 : 0];
    rbx = Program_Registers_adress[3][63 : 0];
    rsp = $unsigned(Program_Registers_adress[4][63 : 0]);
    rbp = Program_Registers_adress[5][63 : 0];
    rsi = Program_Registers_adress[6][63 : 0];
    rdi = Program_Registers_adress[7][63 : 0];
    r8 = Program_Registers_adress[8][63 : 0];
    r9 = Program_Registers_adress[9][63 : 0];
    r10 = Program_Registers_adress[10][63 : 0];
    r11 = Program_Registers_adress[11][63 : 0];
    r12 = Program_Registers_adress[12][63 : 0];
    r13 = Program_Registers_adress[13][63 : 0];
    r14 = Program_Registers_adress[14][63 : 0];
end

// calculating srcA and SrcB from icode 
always @ (*)begin
    #0.5
    if(D_Ins_Code == 2)begin
         d_srcA <= D_rA;
         d_dstE <= D_rB;
         d_srcB <= 4'd15;
         d_dstM <= 4'd15;
    end

    if(D_Ins_Code == 3)begin
        d_srcA <= 4'd15;
        d_srcB <= 4'd15;
        d_dstE <= D_rB;
        d_dstM <= 4'd15;
    end

    if(D_Ins_Code == 4)begin
        d_srcA <= D_rA;
        d_srcB <= D_rB;
        d_dstM <= 4'd15;
        d_dstE <= 4'd15;
        
    end

    if(D_Ins_Code == 5)begin
        d_srcA <= 4'd15;
        d_srcB <= D_rB;
        d_dstM <= D_rA;
        d_dstE <= 4'd15;
        
    end

    if(D_Ins_Code == 6)begin
        d_srcA <= D_rA;
        d_srcB <= D_rB;
        d_dstE <= D_rB;
        d_dstM <= 4'd15;

    end

    if(D_Ins_Code == 7)begin
        d_srcA <= 4'd15;
        d_srcB <= 4'd15;
        d_dstM <= 4'd15;
        d_dstE <= 4'd15;
    end

    if(D_Ins_Code == 8)begin
        d_srcA <= 4'd4;
        d_srcB <= 4'd15;
        d_dstE <= 4'd4;
        d_dstM <= 4'd15;
    end

    if(D_Ins_Code == 9)begin
        d_srcA <= 4'd4;
        d_srcB <= 4'd4;
        d_dstE <= 4'd4;
        d_dstM <= 4'd15;
    end

    if(D_Ins_Code == 10)begin
        d_srcA <= D_rA;
        d_srcB <= 4'd4;
        d_dstE <= 4'd4;
        d_dstM <= 4'd15;
    end

    if(D_Ins_Code == 11)begin
        d_srcA <= 4'd4;
        d_srcB <= 4'd4;
        d_dstE <= 4'd4;
        d_dstM <= D_rB;
    end
    #0.2
    d_rvalue_A = Program_Registers_adress[d_srcA][63 : 0];
    d_rvalue_B = Program_Registers_adress[d_srcB][63 : 0];
    #0.1
    if(W_dstE != 15)begin
        Program_Registers_adress [W_dstE] = W_Value_E;
    end
    if(W_dstM != 15)begin
        Program_Registers_adress[W_dstM] = W_Value_M;
    end

    #0.1
    rax = Program_Registers_adress[0][63 : 0];
    rcx = Program_Registers_adress[1][63 : 0];
    rdx = Program_Registers_adress[2][63 : 0];
    rbx = Program_Registers_adress[3][63 : 0];
    rsp = $unsigned(Program_Registers_adress[4][63 : 0]);
    rbp = Program_Registers_adress[5][63 : 0];
    rsi = Program_Registers_adress[6][63 : 0];
    rdi = Program_Registers_adress[7][63 : 0];
    r8 = Program_Registers_adress[8][63 : 0];
    r9 = Program_Registers_adress[9][63 : 0];
    r10 = Program_Registers_adress[10][63 : 0];
    r11 = Program_Registers_adress[11][63 : 0];
    r12 = Program_Registers_adress[12][63 : 0];
    r13 = Program_Registers_adress[13][63 : 0];
    r14 = Program_Registers_adress[14][63 : 0];
    
end

// forwarding Val A and Val B from SrcA , srcB, and other parameters from execute , memory and write back stage
always @(*)begin
    #4
    if(D_Ins_Code == 7 || D_Ins_Code == 8)begin
        d_value_A = D_Val_P;
        
    end
    else if(d_srcA == e_dstE)begin
        d_value_A = e_Value_E;
    end
    else if(d_srcA == M_dstM)begin
        d_value_A = m_Value_M;
    end
    else if(d_srcA == M_dstE)begin
        d_value_A = M_Value_E;
    end
    else if(d_srcA == W_dstM)begin
        d_value_A = W_Value_M;
    end
    else if(d_srcA == W_dstE)begin
        d_value_A = W_Value_E;
    end
    else begin
        d_value_A = d_rvalue_A;
    end

end

always @(*)begin
    #4
    if(d_srcB == e_dstE)begin
        d_value_B = e_Value_E;
    end
    else if(d_srcB == M_dstM)begin
        d_value_B = m_Value_M;
    end
    else if(d_srcB == M_dstE)begin
        d_value_B = M_Value_E;
    end
    else if(d_srcB == W_dstM)begin
        d_value_B = W_Value_M;
    end
    else if(d_srcB == W_dstE)begin
        d_value_B = W_Value_E;
    end
    else begin
        d_value_B = d_rvalue_B;
    end
end

endmodule