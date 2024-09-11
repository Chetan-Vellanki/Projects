module Decode(
    input clk,
    input condition_satisfy_check,
    input [3 : 0] Ins_Code,
    input [3 : 0] Ins_fun,
    input [3 : 0] rA,
    input [3 : 0] rB,
    input mem_invalid_check,
    input instruction_invalid_check,
    input need_regids,
    input need_Val_C,
    output reg signed [63 : 0] value_A,
    output reg signed [63 : 0] value_B,
    input signed [63 : 0] Value_E,
    input signed [63 : 0] Value_M,
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

);
reg signed [63 : 0] Program_Registers_adress [0 : 14];
initial begin
    Program_Registers_adress[0] = 64'd1;
    Program_Registers_adress[1] = 64'd2;
    Program_Registers_adress[2] = 64'd4;
    Program_Registers_adress[3] = 64'd8;
    Program_Registers_adress[4] = 64'd16;
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
end
/// DECODE operation: 
//integer rA_encoded_value = $unsigned(rA);
//integer rB_encoded_value = $unsigned(rB);
always @ (posedge clk) begin
    value_A = 64'bx;
    value_B = 64'bx;

    if(mem_invalid_check == 0)begin
        if(instruction_invalid_check == 0)begin
            #1.1;
            if(Ins_Code == 0)begin
                // do not read anything
            end
            //// no operation nop
            if(Ins_Code == 1)begin
                // do not decode anything
            end
            //// Conditional move cmovXX
            if(Ins_Code == 2)begin
                if(need_regids == 1)begin
                    // reading the register A and taking 0 for value B so as to generate some conditional codes for the next instruction
                    value_A = Program_Registers_adress [$unsigned(rA)][63 : 0];
                    value_B = 64'd0;

                end

            end
            // irmovq immediate register
            if(Ins_Code == 3)begin
                // do not decode anything
            end 

            if(Ins_Code == 4)begin
                if(need_regids == 1)begin
                    value_A = Program_Registers_adress[$unsigned(rA)][63 : 0];
                    value_B = Program_Registers_adress[$unsigned(rB)][63 : 0];
                end
            end

            if(Ins_Code == 5)begin
                if(need_regids == 1)begin
                    value_B = Program_Registers_adress[$unsigned(rB)][63 : 0];
                end
            end

            if(Ins_Code == 6)begin
                if(need_regids == 1)begin
                    value_A = Program_Registers_adress[$unsigned(rA)][63 : 0];
                    value_B = Program_Registers_adress[$unsigned(rB)][63 : 0];
                end
            end

            if(Ins_Code == 7)begin
                // no need to decode any register value. we need to jump to some instruction
            end

            if(Ins_Code == 8)begin
                // stack pointer is used to return to the next instruction
                value_B = Program_Registers_adress[4][63 : 0];
            end
            /// return ret : 
            if(Ins_Code == 9)begin
                //
                value_A = Program_Registers_adress[4][63 : 0];
                value_B = Program_Registers_adress[4][63 : 0];
            end
            /// pushq 
            if(Ins_Code == 10)begin

                value_A = Program_Registers_adress[$unsigned(rA)][63 : 0];
                value_B = Program_Registers_adress[4];
            end
            /// popq 
            if(Ins_Code == 11)begin
                value_A = Program_Registers_adress[4][63 : 0];
                value_B = Program_Registers_adress[4][63 : 0];
            end
        end
        
    end

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
//// Write Back Operation
always @ (negedge clk)begin
#2
    if(mem_invalid_check == 0)begin
        if(instruction_invalid_check == 0)begin
            if(Ins_Code == 0)begin
                // do not read anything
            end
            //// no operation nop
            if(Ins_Code == 1)begin
                // do not write anything
            end
            //// Conditional move cmovXX
            if(Ins_Code == 2)begin
                if(need_regids == 1)begin

                    if(Ins_fun>=0 && Ins_fun<=6)begin
                        // reading the register A and taking 0 for value B so as to generate some conditional codes for the next instruction
                        // writing back the executed valE into the updated register encoder rB.
                        // the rB is changed according to the condition in the execute stage.
                        if(condition_satisfy_check == 1)begin
                            Program_Registers_adress [$unsigned(rB)] = Value_E;
                        end
                    end

                    if(Ins_fun > 6)begin
                        $display("Invalid Function code for cmovXX");
                    end

                end

            end
            // irmovq immediate register
            if(Ins_Code == 3)begin
                // push the valu E into the dest register rB
                if(Ins_fun == 0)begin
                    Program_Registers_adress[$unsigned(rB)] = Value_E;
                end

                if(Ins_Code != 0)begin
                    $display("Invalid function code for irmovq");
                end
            end
            /// registerr to memory rmmovq
            if(Ins_Code == 4)begin
                // no need to write back, it is already added to the memory in rmmovq
            end
            /// mrmovq : memory to register move
            if(Ins_Code == 5)begin
                // the read value from the memory is pushed into the register rA
                Program_Registers_adress[$unsigned(rA)] = Value_M;
            end

            if(Ins_Code == 6)begin
                if(Ins_fun >=0 &&Ins_fun <=3)begin
                    Program_Registers_adress[$unsigned(rB)] = Value_E;
                end

                if(Ins_fun > 3)begin
                    $display("Invalid function code for opXX ..");
                end

            end

            /// Jump to the destination adress is sufficient jXX
            if(Ins_Code == 7)begin
                // no need to write to any register value. we need to jump to some instruction
            end

            if(Ins_Code == 8)begin
                // stack pointer is used to return to the next instruction
                // Val E contains the adress of the next instruction. it should be put on the top of the stack
                if(Ins_fun == 0)begin
                    Program_Registers_adress [4] = $unsigned(Value_E);
                end
                if(Ins_fun != 0)begin
                    $display("Invalid Function code for call :");
                end
            end

            if(Ins_Code == 9)begin
                // when we called, the adress we added to the stack is the adress of the instruction
                // that should be returned, so returning that adreess to the stack pointer
                if(Ins_fun == 0)begin

                    Program_Registers_adress [4] = $unsigned(Value_E);
                end
                if(Ins_fun != 0)begin
                    $display("Invalid Function code for return ret :");
                end
            end

            if(Ins_Code == 10)begin
                /// updating the new adress of the stack pointer
                if(Ins_fun == 0)begin
                    Program_Registers_adress[4] = $unsigned(Value_E);
                end

                if(Ins_fun != 0)begin
                    $display("Invalid Function Code for pushq : ");
                end
            end

            if(Ins_Code == 11)begin

                if(Ins_fun == 0)begin
                    Program_Registers_adress[4] = $unsigned(Value_E);
                    Program_Registers_adress[$unsigned(rA)] = Value_M;
                end
                
                if(Ins_fun != 0)begin
                    $display("Invalid Function code for popq : ");
                end
            end
        end
        
    end

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

endmodule