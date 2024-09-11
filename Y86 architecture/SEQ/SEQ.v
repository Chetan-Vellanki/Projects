`include "Fetch.v"
`include "Decode.v"
`include "Execute.v"
`include "PC_update.v"
`include "MemoryBlock.v"
module SEQ;

    reg clk = 0;
    reg [63 : 0] PC_adress;
    wire [3 : 0] Ins_Code;
    wire [3 : 0] Ins_fun;
    wire [3 : 0] rA;
    wire [3 : 0] rB;
    wire signed [63 : 0] Val_C;
    wire [63 : 0] Val_P;
    wire mem_invalid_check;
    wire instruction_invalid_check;
    wire func_invalid_check;
    wire need_regids;
    wire need_Val_C;
    wire signed [63 : 0] value_A;
    wire signed [63 : 0] value_B;
    wire signed [63 : 0] Value_E;
    wire signed [63 : 0] Value_M;
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
    wire  [63 : 0] no_of_valid_instruction;
    wire condition_satisfy_check;
    wire signed_flag,overflow_flag, zero_flag;
    wire imemory_error, data_memory_error, status_of_memory;
    wire [63 : 0] new_PC_address;
    reg AOK,HLT, ADR, INS; 


    Fetch Fetch_operation(.clk(clk), .PC_adress(PC_adress), .Ins_Code(Ins_Code),
                          .Ins_fun(Ins_fun), .rA(rA), .rB(rB), .Val_C(Val_C),
                          .Val_P(Val_P), .mem_invalid_check(mem_invalid_check),
                          .instruction_invalid_check(instruction_invalid_check),
                          .func_invalid_check(func_invalid_check),
                          .need_regids(need_regids),.need_Val_C(need_Val_C), 
                          .no_of_valid_instruction(no_of_valid_instruction) );
    Decode Decode_write_back_operation(
                          .clk(clk), .condition_satisfy_check(condition_satisfy_check),.Ins_Code(Ins_Code), .Ins_fun(Ins_fun), 
                          .rA(rA), .rB(rB), .mem_invalid_check(mem_invalid_check), 
                          .instruction_invalid_check(instruction_invalid_check),
                          .need_regids(need_regids), .need_Val_C(need_Val_C),
                          .value_A(value_A), .value_B(value_B), .Value_E(Value_E),
                          .Value_M(Value_M), .rax(rax), .rcx(rcx), .rdx(rdx), .rbx(rbx), 
                          .rsp(rsp), .rbp(rbp), .rsi(rsi), .rdi(rdi), .r8(r8), .r9(r9), 
                          .r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14) );

    Execute Execute_operations(
            .clk(clk), .Ins_Code(Ins_Code), .Ins_fun(Ins_fun), 
            .instruction_invalid_check(instruction_invalid_check),
            .mem_invalid_check(mem_invalid_check), .Val_C(Val_C), .value_A(value_A),.value_B(value_B),
            .Value_E(Value_E), .signed_flag(signed_flag), .overflow_flag(overflow_flag),
            .zero_flag(zero_flag), .condition_satisfy_check(condition_satisfy_check)
    );

    MemoryBlock Memmory_instruction_Block(
        .clk(clk), .Ins_Code(Ins_Code), .Ins_fun(Ins_fun), .value_A(value_A), .value_B(value_B),
        .Value_E(Value_E), .Value_M(Value_M), .Val_P(Val_P), .PC_mem_invalid_check(mem_invalid_check), 
        .instruction_invalid_check(instruction_invalid_check), .func_invalid_check(func_invalid_check), 
        .imemory_error(imemory_error), .data_memory_error(data_memory_error), 
        .status_of_memory(status_of_memory), .no_of_valid_instruction(no_of_valid_instruction)
    );

    PC_update PC_update_Block(
        .clk(clk), .no_of_valid_instruction(no_of_valid_instruction), 
        .PC_adress(PC_adress), .Ins_Code(Ins_Code), .Ins_fun(Ins_fun),
        .Val_C(Val_C), .Val_P(Val_P), .Value_M(Value_M), .mem_invalid_check(mem_invalid_check),
        .instruction_invalid_check(instruction_invalid_check), .conditional_code_satisfy_check(condition_satisfy_check), 
        .new_PC_address(new_PC_address)
    );
    always #10 begin
        clk = ~clk;
    end

    always @ (negedge clk)begin
        #9
        PC_adress = new_PC_address;
    end

//    initial begin
//     rax = 64'd1;
//     rcx = 64'd2;
//     rdx = 64'd4;
//     rbx = 64'd8;
//     rsp = 64'd16;
//     rbp = 64'd32;
//     rsi = 64'd64;
//     rdi = 64'd128;
//     r8 = 64'd256;
//     r9 = 64'd512;
//     r10 = 64'd1024;
//     r11 = 64'd2048;
//     r12 = 64'd4096;
//     r13 = 64'd8192;
//     r14 = 64'd16384;
// end

    always @(*)begin
        #4
        // AOK = 1'bx;
        // HLT = 1'bx;
        // ADR = 1'bx;
        // INS = 1'bx;
        //HLT
        if(Ins_Code == 0)begin
            HLT = 1;
        end
        else begin
            HLT = 0;
        end

        //ADR
        if(data_memory_error == 1 || imemory_error == 1 )begin
            ADR = 1;
        end
        else begin
            ADR = 0;
        end

        //INS
        if(instruction_invalid_check == 1)begin
            INS = 1;
        end
        else begin
            INS = 0;
        end

        // ALL ok
        if(HLT == 1 || ADR == 1 || INS == 1)begin
            AOK = 0;
            // $finish;
        end
        else begin
            AOK = 1;
        end   
    end

    

    initial begin
        
        //clk = 0;
        #10
        PC_adress = 64'd0;
        #100
        $finish;
    end

initial begin
    #69
    // $monitor("TIME INSTANT : \n", $time);
    // $monitor("clk : \n", clk);
    // $monitor("Memory invalid check : \n", mem_invalid_check);
    // $monitor("PC Adress : \n", PC_adress);
    // $monitor("Instrction code : %b\n", Ins_Code);
    // $monitor("Instruction invalid Check : \n", instruction_invalid_check);
    // $monitor("Function code : %b \n", Ins_fun);
    // $monitor("Need for Val_C  : \n",need_Val_C);
    // $monitor("Need for registers : \n", need_regids);
    // $monitor("Val_C =  %b\n",Val_C);
    // $monitor("Val P = \n", Val_P);
    // $monitor("register A : %b\n", rA);
    // $monitor("register B : %b\n", rB);
    // $monitor(" PROGRAM REGISTER VALUES:\n");
    // $monitor(" --------------------------------\n ");
    // $monitor("rax  : \n", rax);
    // $monitor("rcx : \n", rcx);
    // $monitor("rdx : \n", rdx);
    // $monitor("rbx : \n", rbx);
    // $monitor("rsp : \n", rsp);
    // $monitor("rbp : \n", rbp);
    // $monitor("rsi : \n", rsi);
    // $monitor("rdi : \n", rdi);
    // $monitor("r8 : \n", r8);
    // $monitor("r9 : \n", r9);
    // $monitor("r10 : \n", r10);
    // $monitor("r11 : \n", r11);
    // $monitor("r12 : \n", r12);
    // $monitor("r13 : \n", r13);
    // $monitor("r14 : \n", r14);
    // $monitor(" --------------------------------  \n");
    // $monitor("Value_A : \n", value_A);
    // $monitor("Value_B : \n", value_B);
    // $monitor("---------------------------- \n");
    // $monitor("Value_E : \n", Value_E);
    // $monitor("Value_M : \n", Value_M);
    // $monitor("No. of valid instructions : \n", no_of_valid_instruction);
    // $monitor("Condition satisfy check : \n", condition_satisfy_check);
    // $monitor("signed flag : \n", signed_flag);
    // $monitor("Overflow flag : \n", overflow_flag);
    // $monitor("Zero Flag : \n",zero_flag);
    // $monitor(" address memory error : \n", imemory_error);
    // $monitor("instruction invalid adress : \n", data_memory_error);
    // $monitor("status of memory : \n", status_of_memory);
    // $monitor("new pc adress : \n", new_PC_address);
    // $monitor("-----STATUS FLAGS : ------\n");
    // $monitor("Memory Adress flag : \n", ADR);
    // $monitor("Halt Flag : \n", HLT);
    // $monitor("Instruction code flag : \n", INS);
    // $monitor("ALL OK FLAG  : \n", AOK);

    $monitor("TIME INSTANT : %t\nclk : %b\nMemory invalid check : %b\nPC Adress : %d\nInstrction code : %b\nInstruction invalid Check : %b\nFunction code : %b \nNeed for Val_C  : %b\nNeed for registers : %b\nVal_C =  %b\nVal P = %d\nregister A : %b\nregister B : %b\nPROGRAM REGISTER VALUES:\n--------------------------------\nrax  : %d\nrcx : %d\nrdx : %d\nrbx : %d\nrsp : %d\nrbp : %d\nrsi : %d\nrdi : %d\nr8 : %d\nr9 : %d\nr10 : %d\nr11 : %d\nr12 : %d\nr13 : %d\nr14 : %d\n --------------------------------  \nValue_A : %d\nValue_B : %d\n---------------------------- \nValue_E : %d\nValue_M : %d\nNo. of valid instructions : %d\nCondition satisfy check : %b\nsigned flag : %b\nOverflow flag : %b\nZero Flag : %b\naddress memory error : %b\ninstruction invalid adress : %b\nstatus of memory : %b\nnew pc adress : %d\n-----STATUS FLAGS : ------\nALL OK FLAG  : %b\nMemory Adress flag : %b\nHalt Flag : %b\nInstruction code flag : %b\n",
      $time, clk, mem_invalid_check, PC_adress, Ins_Code, instruction_invalid_check, Ins_fun, need_Val_C, need_regids, Val_C, Val_P, 
     rA, rB, rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14, value_A, value_B, Value_E, Value_M, no_of_valid_instruction,
     condition_satisfy_check, signed_flag, overflow_flag, zero_flag, imemory_error, data_memory_error, status_of_memory, new_PC_address, AOK, 
     ADR, HLT, INS);
    #90;
    $finish;
end
endmodule