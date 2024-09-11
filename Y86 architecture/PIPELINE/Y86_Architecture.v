// `timescale 1ns / 1ps
`include "fetch.v"
`include "Decode.v"
`include "D_load.v"
`include "Execute.v"
`include "E_load.v"
`include "MemoryBlock.v"
`include "M_load.v"
`include "W_load.v"
`include "F_load.v"

module Y86_Architecture;
    reg clk;
    wire [63 : 0] F_PC_PREDICT;
    wire [63 : 0] f_PC;
    wire[63 : 0] f_PC_PREDICT; // predict PC for the next instruction
    wire [3 : 0] f_Ins_Code;
    wire [3 : 0] f_Ins_fun;
    wire [3 : 0] f_rA;
    wire [3 : 0] f_rB;
    wire signed [63 : 0] f_Val_C;
    wire [63 : 0] f_Val_P;
    wire  f_mem_invalid_check;
    wire f_instruction_invalid_check;
    wire  f_func_invalid_check;
    wire  f_need_regids;
    wire f_need_Val_C;
    wire [63 : 0] f_no_of_valid_instruction;
    wire [2 : 0] f_stat;
    wire  [3 : 0] D_Ins_Code;
    wire [3 : 0] D_Ins_fun;
    wire [3 : 0] D_rA;
    wire  [3 : 0] D_rB;
    wire [2 : 0] D_stat;
    wire  signed [63 : 0] D_Val_C;
    wire  [63 : 0] D_Val_P;
    wire signed [63 : 0] d_value_A;
    wire signed [63 : 0] d_value_B;
    wire signed [63 : 0] d_rvalue_A;
    wire signed [63 : 0] d_rvalue_B;
    wire [3 : 0] d_srcA;
    wire [3 : 0] d_srcB;
    wire [3 : 0] d_dstE;
    wire [3 : 0] d_dstM;
    wire signed  [63 : 0] rax;
    wire signed [63 : 0] rcx;
    wire signed [63 : 0] rdx;
    wire signed [63 : 0] rbx;
    wire [63 : 0] rsp;
    wire signed [63 : 0] rbp;
    wire signed [63 : 0] rsi;
    wire signed [63 : 0] rdi;
    wire signed [63 : 0] r8;
    wire signed [63 : 0] r9;
    wire signed [63 : 0] r10;
    wire signed [63 : 0] r11;
    wire signed [63 : 0] r12;
    wire signed [63 : 0] r13;
    wire signed [63 : 0] r14;
    reg D_toBubble;
    reg D_tostall;
    wire [3 : 0] E_Ins_Code;
    wire [3 : 0] E_Ins_fun;
    wire signed [63 : 0] E_Val_C;
    wire signed [63 : 0] E_value_A;
    wire signed [63 : 0] E_value_B;
    wire signed [63 : 0] e_Value_E;
    wire e_Cnd;
    wire  [3 : 0] e_dstE;
    wire [2 : 0] E_stat;
    wire SET_CC;
    wire [3 : 0] E_dstE;
    wire signed_flag;
    wire overflow_flag;
    wire zero_flag;
    reg E_toBubble;
    wire [3 : 0] E_srcA;
    wire [3 : 0] E_srcB;
    wire [3 : 0] E_dstM;
    wire [3 : 0] M_Ins_Code;
    wire [3 : 0] M_Ins_fun;
    wire signed [63 : 0] M_value_A;
    wire signed [63 : 0] M_Value_E;
    wire [2 : 0] M_stat;
    wire signed [63 : 0] m_Value_M;
    wire imemory_error; // whether memory to be written or read is valid
    wire data_memory_error; // data read from memory to be valid or not
    wire [2 : 0] m_stat;
    reg M_toBubble;
    wire [2 : 0] W_stat;
    wire [3 : 0] W_Ins_Code;
    wire signed [63 : 0] W_Value_E;
    wire signed [63 : 0] W_Value_M;
    wire [3 : 0] W_dstE;
    wire [3 : 0] W_dstM;
    wire [3 : 0] M_dstE;
    wire [3 : 0] M_dstM;
    reg F_toStall;
    


    // calling modules

    Fetch_Register F_load(
        clk,
        F_toStall,
        F_PC_PREDICT,
        f_PC_PREDICT
    );

    Fetch fetching(
        clk,
        F_PC_PREDICT,
        M_Ins_Code,
        W_Ins_Code,
        M_cnd,
        W_stat,
        M_value_A,
        W_Value_M,
        f_PC,
        f_PC_PREDICT,
        f_Ins_Code,
        f_Ins_fun,
        f_rA,
        f_rB,
        f_Val_C,
        f_Val_P,
        f_mem_invalid_check,
        f_instruction_invalid_check,
        f_func_invalid_check,
        f_need_regids,
        f_need_Val_C,
        f_no_of_valid_instruction,
        f_stat
    );

    Load_Decode_Pipeline_Register D_loading(
        clk,
        f_stat,
        f_Ins_Code,
        f_Ins_fun,
        f_rA,
        f_rB,
        f_Val_C,
        f_Val_P,
        D_toBubble,
        D_tostall,
        D_stat,
        D_Ins_Code,
        D_Ins_fun,
        D_rA,
        D_rB,
        D_Val_C,
        D_Val_P
    );

    Decode Decoding(
        clk,
        D_Ins_Code,
        D_Ins_fun,
        D_rA,
        D_rB,
        D_stat,
        D_Val_C,
        D_Val_P,
        e_dstE,
        e_Value_E,
        M_dstE,
        M_dstM,
        m_Value_M,
        M_Value_E,
        W_dstM,
        W_Value_M,
        W_dstE,
        W_Value_E,
        d_value_A,
        d_value_B,
        d_rvalue_A,
        d_rvalue_B,
        d_srcA,
        d_srcB,
        d_dstE,
        d_dstM,
        rax,
        rcx,
        rdx,
        rbx,
        rsp,
        rbp,
        rsi,
        rdi,
        r8, r9, r10, r11, r12, r13, r14
    );


    Execute_pipeline_register Load_Ececute(
        clk,
        E_toBubble,
        D_stat,
        D_Ins_Code,
        D_Ins_fun,
        D_Val_C,
        d_value_A,
        d_value_B,
        d_dstE,
        d_dstM,
        d_srcA,
        d_srcB,
        E_stat,
        E_Ins_Code,
        E_Ins_fun,
        E_Val_C,
        E_value_A,
        E_value_B,
        E_srcA,
        E_srcB
    );

    Execute Executing(
        clk,
        E_Ins_Code,
        E_Ins_fun,
        E_Val_C,
        E_value_A,
        E_value_B,
        e_Value_E,
        signed_flag,
        overflow_flag,
        zero_flag,
        e_Cnd,
        e_dstE,
        E_stat,
        m_stat,
        W_stat,
        SET_CC,
        E_dstE
    );

    Memory_Pipeline_Register Load_Memory_r(
        clk,
        M_toBubble,
        E_stat,
        E_Ins_Code,
        E_Ins_fun,
        E_value_A,
        E_dstM,
        e_dstE,
        e_Value_E,
        e_Cnd,
        M_stat,
        M_Ins_Code,
        M_cnd,
        M_Value_E,
        M_value_A,
        M_dstE,
        M_dstM,
        M_Ins_fun
    );

    MemoryBlock Memory_Block(
        clk,
        M_Ins_Code,
        M_Ins_fun,
        M_value_A,
        M_Value_E,
        M_stat,
        m_Value_M,
        imemory_error,
        data_memory_error,
        m_stat,
        f_no_of_valid_instruction
    );

    initial begin
        #9
        clk = 0;
        // F_PC_PREDICT <= 0;
        //F_PC_PREDICT <=0;
        F_toStall <= 0;
        D_toBubble <= 0;
        D_tostall <=0;
        E_toBubble <=0;
        M_toBubble <=0;

    end

    always #10 begin
        clk = ~clk;
    end

    always @(posedge clk)begin
        //F_PC_PREDICT <= f_PC_PREDICT;
        #0.5
        D_toBubble = (E_Ins_Code == 7 && e_Cnd == 0)
            || !((E_Ins_Code == 5 || E_Ins_Code == 11) && (E_dstM == d_srcA  || E_dstM == d_srcB)) &&
             (D_Ins_Code == 9 || E_Ins_Code == 9 || M_Ins_Code == 9);
        

        D_tostall = (E_Ins_Code == 5 || E_Ins_Code == 11 ) && (E_dstM == d_srcA || E_dstM == d_srcB);
        E_toBubble = (E_Ins_Code == 7 && e_Cnd == 0) || (E_Ins_Code == 5 || E_Ins_Code == 11 ) && (E_dstM == d_srcA || E_dstM == d_srcB);
        M_toBubble = (m_stat == 2 || m_stat == 3 || m_stat == 1) || (W_stat == 2 || W_stat == 3 || W_stat == 1);
    end

    initial begin
        #30
        $monitor("time : %d\n-------FETCH PARAMETERS-------\nF_PredPC : %d\nf_rA : %b\nf_rB : %b\nf_ValC : %d\nf_icode : %b\nf_ifun : %b\nf_stat : %b\nf_ValP : %d\nf_PC : %d\nf_PredPC : %d\n-----------DECODE PARAMETERS----------\nD_bubble : %d\nD_stall : %d\nD_stat : %d\nD_icode : %b\nD_ifun : %b\nD_rA : %b\nD_rB : %b\nD_ValC : %d\nD_ValP : %d\nd_ValA : %d\nd_ValB : %d\nd_srcA : %b\nd_srcB : %b\nd_dstE : %b\nd_dstM : %b\nd_rValA : %d\nd_rValB : %d\n------------REGISTERS-------------\nrax : %d\nrcx : %d\nrdx : %d\nrbx : %d\nrsp : %d\nrbp : %d\nrsi : %d\nrdi : %d\nr8 : %d\nr9 : %d\nr10 : %d\nr11 : %d\nr12 : %d\nr13 : %d\nr14 : %d\n---------EXECUTE PARAMETERS----------\nE_stat : %b\nE_icode : %b\nE_ifun : %b\nE_ValA : %d\nE_ValB : %d\nE_ValC : %d\nE_dstE : %b\nE_dstM : %b\ne_ValE : %d\ne_dstE : %b\ne_Cnd : %d\nzeroflag : %d\nsignedflag : %d\noverflow_flag : %d\nSET_CC : %d\n---------------MEMORY PARAMETERS----------------\nm_ValM : %d\ndmem_error : %d\nm_stat : %b\nM_stat : %b\nM_icode : %b\nM_dstE : %b\nM_dstM : %b\nM_ValE : %b\nM_ValA : %d\nM_cnd : %d\nW_stat : %b\nW_icode : %b\nW_valE : %d\nW_ValM : %d\nW_dstE : %b\nW_dstM : %b\n",$time,F_PC_PREDICT,f_rA,f_rB,f_Val_C,f_Ins_Code,f_Ins_fun,f_stat,f_Val_P,f_PC,f_PC_PREDICT,D_toBubble,D_tostall,D_stat,D_Ins_Code,D_Ins_fun,D_rA,D_rB, D_Val_C, D_Val_P,d_value_A, d_value_B, d_srcA,d_srcB,d_dstE,d_dstM,d_rvalue_A,d_rvalue_B,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,E_stat,E_Ins_Code,E_Ins_fun,E_value_A,E_value_B,E_Val_C,E_dstE,E_dstM,e_Value_E,e_dstE,e_Cnd,zero_flag,signed_flag, overflow_flag,SET_CC,m_Value_M,data_memory_error,m_stat,M_stat,M_Ins_Code,M_dstE, M_dstM,M_Value_E,M_value_A,M_cnd,W_stat, W_Ins_Code, W_Value_E,W_Value_M,W_dstE,W_dstM);
        #20
        $finish;
    end


























endmodule

