// `timescale 1ns / 1ps
module Fetch(
    // allowing up to 64 instructions
    input clk,
    // initially f_PC takes the first adress of the memory_block
    input [63 : 0] F_PC_PREDICT,  // initiallt this would be assigned to the first instruction i.e 0
    input [3 : 0] M_Ins_Code,// memory stage icode
    input [3 : 0] W_Ins_Code, // write  back stage write code
    input M_cnd,
    input [2 : 0] W_stat,
    input signed [63 : 0] M_value_A,
    input signed [63 : 0] W_Value_M,
    output reg [63 : 0] f_PC, // select one pc from previous predicted pc value
    output reg [63 : 0] f_PC_PREDICT, // predict PC for the next instruction
    output reg [3 : 0] f_Ins_Code,
    output reg [3 : 0] f_Ins_fun,
    output reg [3 : 0] f_rA,
    output reg [3 : 0] f_rB,
    output reg signed [63 : 0] f_Val_C,
    output reg [63 : 0] f_Val_P,
    output reg  f_mem_invalid_check,
    output reg f_instruction_invalid_check,
    output reg  f_func_invalid_check,
    output reg  f_need_regids,
    output reg f_need_Val_C,
    output reg [63 : 0] f_no_of_valid_instruction,
    output reg [2 : 0] f_stat // 2 : halt , 1 : mem_invalid_check,  0 :  instruction_invalid_check


    
);

// declaring the instructions codes for comparision : 
// wire halt, nop, rrmovq,cmovle, cmovl, cmove, cmovne, cmovge, cmovq,irmovq, 
// rmmovq, mrmovq, addq, subq, andq, xorq, jmp, jle, jl, je, jne, jge,jg,call, ret,
// pushq, popq;
wire [7 : 0] halt= 8'd0;
reg [7 : 0]  instruction_set [0 : 299];
    // the memory adresses for the 64 instructions
reg [63 : 0] memory_for_instructions [0 : 2399];
integer count;
initial begin

        for(count = 0 ; count < 2400 ; count = count + 1)begin
            memory_for_instructions[count] = count;
        end
end

initial begin
    #9
    f_PC_PREDICT = 0;
    f_no_of_valid_instruction = 64'd0;
    // instruction_set[0] = 8'b00010000; // 1 0  :  no operation 

    // instruction_set[1] = 8'b01100011; //2 fn  :  OPq
    // instruction_set[2] = 8'b01100111; //rA rB

    // instruction_set[3] = 8'b00110000; //3 fn  : irmovq
    // instruction_set[4] = 8'b01100111; //rA rB 
    // instruction_set[5] = 8'b00000000; 
    // instruction_set[6] = 8'b00000000; 
    // instruction_set[7] = 8'b00000000;
    // instruction_set[8] = 8'b00000000;
    // instruction_set[9] = 8'b00000000;
    // instruction_set[10] = 8'b00000000;
    // instruction_set[11] = 8'b00000000;
    // instruction_set[12] = 8'b00000111;

    // instruction_set[13] = 8'b01000000; //4 fn : rmmovq
    // instruction_set[14] = 8'b01100111; //rA rB 
    // instruction_set[15] = 8'b00000000; 
    // instruction_set[16] = 8'b00000000; 
    // instruction_set[17] = 8'b00000000;
    // instruction_set[18] = 8'b00000000;
    // instruction_set[19] = 8'b00000000;
    // instruction_set[20] = 8'b00000000;
    // instruction_set[21] = 8'b00000000;
    // instruction_set[22] = 8'b00000011;

    // instruction_set[23] = 8'b01010000; //5 fn : mromvq
    // instruction_set[24] = 8'b10000111; //rA rB
    // instruction_set[25] = 8'b00000000; 
    // instruction_set[26] = 8'b00000000; 
    // instruction_set[27] = 8'b00000000;
    // instruction_set[28] = 8'b00000000;
    // instruction_set[29] = 8'b00000000;
    // instruction_set[30] = 8'b00000000;
    // instruction_set[31] = 8'b00000000;
    // instruction_set[32] = 8'b00000011;

    // instruction_set[33] = 8'b01100000; //6 fn : OPq
    // instruction_set[34] = 8'b01100111; //rA rB

    // instruction_set[35] = 8'b01110110; //7 fn : jXX
    // instruction_set[36] = 8'b00000000; 
    // instruction_set[37] = 8'b00000000; 
    // instruction_set[38] = 8'b00000000;
    // instruction_set[39] = 8'b00000000;
    // instruction_set[40] = 8'b00000000;
    // instruction_set[41] = 8'b00000000;
    // instruction_set[42] = 8'b00000000;
    // instruction_set[43] = 8'b00011000;

    // instruction_set[44] = 8'b10000000; //8 fn : Call
    // instruction_set[45] = 8'b00000000; 
    // instruction_set[46] = 8'b00000000; 
    // instruction_set[47] = 8'b00000000;
    // instruction_set[48] = 8'b00000000;
    // instruction_set[49] = 8'b00000000;
    // instruction_set[50] = 8'b00000000;
    // instruction_set[51] = 8'b00000001;
    // instruction_set[52] = 8'b10111000;

    // instruction_set[53] = 8'b00100110; // 2 fn : cmovXX fn = 1
    // instruction_set[54] = 8'b00101010; //rA rB

    // instruction_set[55] = 8'b10100000; // 10 fn : PUSHq
    // instruction_set[56] = 8'b10011111; // rA rB

    // instruction_set[57] = 8'b10110000; // 11 fn : POPq
    // instruction_set[58] = 8'b01111111; // rA rB

    // instruction_set[59] = 8'b10010000; //9 fn : ret

    // instruction_set[60]  = 8'b00000000; // 1  :  halt 
    $readmemb("1.txt",instruction_set);


end


integer count_instruction_set;
initial begin
    #1
    for (count_instruction_set = 0; count_instruction_set < 300 ; count_instruction_set = count_instruction_set +1)begin

        if(instruction_set[count_instruction_set] == 8'bx)begin
            f_no_of_valid_instruction = f_no_of_valid_instruction + 64'd0;
        end

        else begin
            f_no_of_valid_instruction = f_no_of_valid_instruction + 64'd1;
        end
    end

end

// PC select process
// selects f_PC between M_valA, W_valM, F_PCpredict
always @(*)begin
    #0.2
    if(M_Ins_Code == 7  && M_cnd == 0)begin
        f_PC = M_value_A;
    end
    else if(W_Ins_Code == 9 && W_stat == 0)begin // all three zeros
        f_PC = W_Value_M;
    end

    else begin
        f_PC = F_PC_PREDICT;
    end
end


always @ (*) begin
#0.3

if($unsigned(f_PC) > 2400)begin
    f_mem_invalid_check = 1;
end
else begin
    f_mem_invalid_check = 0;
end

if(f_mem_invalid_check == 0)begin
    f_Ins_Code = instruction_set[$unsigned(f_PC)/8][7 : 4];
    f_Ins_fun = instruction_set [$unsigned(f_PC)/8][3 : 0];
    if(f_Ins_Code>=0 && f_Ins_Code <=11)begin 
        f_instruction_invalid_check = 0; 
    end
    else begin f_instruction_invalid_check = 1;
            $display("ERROR  :  Instruction code given is given .:: Range between 0 and 11"); end
    if(f_instruction_invalid_check == 0)begin
        /// HALT
        
        if(f_Ins_Code == 0 && f_Ins_fun == 0)begin
            f_stat[2] = 1; 
            // Do not do anything
            // to write something such that the code stops executing
        end
        /// No operation nop 
        if(f_Ins_Code == 1 && f_Ins_fun == 0)begin
            // skip this instruction
            f_need_regids = 0;
            f_need_Val_C = 0;
            //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
            f_Val_P = memory_for_instructions[$unsigned(f_PC) + 8 + f_need_regids * 8 + f_need_Val_C * 64][63 : 0];
        end
        /// conditional move cmovXX
        if(f_Ins_Code == 2)begin
            if(0 <= f_Ins_fun <= 6)begin
                f_rA = instruction_set [($unsigned(f_PC)/8) + 1][7 : 4];
                f_rB = instruction_set [($unsigned(f_PC)/8) + 1][3 : 0];
                f_need_Val_C = 0;
                // since Val_C not present and needed, we do not fetch val_C.
                f_need_regids = 1;
                // since regids needed, we fetched registers ra and rb
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                f_Val_P = memory_for_instructions[$unsigned(f_PC) + 8 + f_need_regids * 8 + f_need_Val_C * 64][63:0];

            end

            if(f_Ins_fun >6)begin
                $display("For cmovXX the function code range between 0 to 6");
            end
        end
        /// immediate Resigter move irmovq
        if(f_Ins_Code == 3)begin
            if(f_Ins_fun != 0)begin
                $display("ERROR: for irmovq : function code is 0, but not entered 0");

            end
            if(f_Ins_fun == 0)begin
                // immediate register move.
                f_need_Val_C = 1;
                f_need_regids = 1;
                f_rA = instruction_set [($unsigned(f_PC)/8) + 1][7 : 4];
                f_rB = instruction_set [($unsigned(f_PC)/8) + 1][3 : 0];
                f_Val_C = {instruction_set [($unsigned(f_PC)/8) + 2],
                         instruction_set [($unsigned(f_PC)/8) + 3],
                         instruction_set [($unsigned(f_PC)/8) + 4],
                         instruction_set [($unsigned(f_PC)/8) + 5],
                         instruction_set [($unsigned(f_PC)/8) + 6],
                         instruction_set [($unsigned(f_PC)/8) + 7],
                         instruction_set [($unsigned(f_PC)/8) + 8],
                         instruction_set [($unsigned(f_PC)/8) + 9]};
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                f_Val_P = memory_for_instructions [$unsigned(f_PC) + 8 + f_need_regids * 8 + f_need_Val_C * 64][63 : 0];

            end
        end
        /// register to memory move rmmovq 
        if(f_Ins_Code == 4)begin
            if(f_Ins_fun != 0)begin
                $display("ERROR: for rmmovq : function code is 0, but not entered 0");

            end

            if(f_Ins_fun == 0)begin
                f_need_Val_C = 1;
                f_need_regids = 1;
                f_rA = instruction_set [($unsigned(f_PC)/8) + 1][7 : 4];
                f_rB = instruction_set [($unsigned(f_PC)/8) + 1][3 : 0];
                f_Val_C = {instruction_set [($unsigned(f_PC)/8) + 2],
                         instruction_set [($unsigned(f_PC)/8) + 3],
                         instruction_set [($unsigned(f_PC)/8) + 4],
                         instruction_set [($unsigned(f_PC)/8) + 5],
                         instruction_set [($unsigned(f_PC)/8) + 6],
                         instruction_set [($unsigned(f_PC)/8) + 7],
                         instruction_set [($unsigned(f_PC)/8) + 8],
                         instruction_set [($unsigned(f_PC)/8) + 9]};
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                f_Val_P = memory_for_instructions [$unsigned(f_PC) + 8 + f_need_regids * 8 + f_need_Val_C * 64][63 : 0];
            end
        end

        /// memory to register move mrmovq
        if(f_Ins_Code == 5)begin
            if(f_Ins_fun != 0)begin
                $display("ERROR: for mrmovq : function code is 0, but not entered 0");

            end

            if(f_Ins_fun == 0)begin
                f_need_Val_C = 1;
                f_need_regids = 1;
                f_rA = instruction_set [($unsigned(f_PC)/8) + 1][7 : 4];
                f_rB = instruction_set [($unsigned(f_PC)/8) + 1][3 : 0];
                f_Val_C = {instruction_set [($unsigned(f_PC)/8) + 2],
                         instruction_set [($unsigned(f_PC)/8) + 3],
                         instruction_set [($unsigned(f_PC)/8) + 4],
                         instruction_set [($unsigned(f_PC)/8) + 5],
                         instruction_set [($unsigned(f_PC)/8) + 6],
                         instruction_set [($unsigned(f_PC)/8) + 7],
                         instruction_set [($unsigned(f_PC)/8) + 8],
                         instruction_set [($unsigned(f_PC)/8) + 9]};
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                f_Val_P = memory_for_instructions [$unsigned(f_PC) + 8 + f_need_regids * 8 + f_need_Val_C * 64][63 : 0];
            end
        end

        /// Arithematic memory operations: OPq
        if(f_Ins_Code == 6)begin
            if(f_Ins_fun >3)begin
                $display("For OPq the function code range between 0 to 3");
            end

            if(f_Ins_fun >=0 && f_Ins_fun <=3)begin
                f_need_Val_C = 0;
                f_need_regids = 1;
                f_rA = instruction_set [($unsigned(f_PC)/8) + 1][7 : 4];
                f_rB = instruction_set [($unsigned(f_PC)/8) + 1][3 : 0];
               // PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                f_Val_P = memory_for_instructions [$unsigned(f_PC) + 8 + f_need_regids * 8 + f_need_Val_C * 64][63 : 0];

            end
        end

        /// JUMP operations
        if(f_Ins_Code == 7)begin
            if(f_Ins_fun > 6)begin
                $display("Error :  for JUMP operations, the function codes between 0 and 6");
            end

            if(f_Ins_fun>=0 && f_Ins_fun <=6)begin
                f_need_regids = 0;
                f_need_Val_C =  1;
                f_Val_C = {instruction_set [($unsigned(f_PC)/8) + 1],
                         instruction_set [($unsigned(f_PC)/8) + 2],
                         instruction_set [($unsigned(f_PC)/8) + 3],
                         instruction_set [($unsigned(f_PC)/8) + 4],
                         instruction_set [($unsigned(f_PC)/8) + 5],
                         instruction_set [($unsigned(f_PC)/8) + 6],
                         instruction_set [($unsigned(f_PC)/8) + 7],
                         instruction_set [($unsigned(f_PC)/8) + 8]};
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                f_Val_P = memory_for_instructions [$unsigned(f_PC) + 8 + f_need_regids * 8 + f_need_Val_C * 64][63 : 0];
                
            end
        end

        /// CALL operations : call
        if(f_Ins_Code == 8)begin
            if(f_Ins_fun != 0)begin
                $display("ERROR : for call the function code is 0");
            end

            if(f_Ins_fun == 0)begin
                f_need_regids = 0;
                f_need_Val_C = 1;
                f_Val_C = {instruction_set [($unsigned(f_PC)/8) + 1],
                         instruction_set [($unsigned(f_PC)/8) + 2],
                         instruction_set [($unsigned(f_PC)/8) + 3],
                         instruction_set [($unsigned(f_PC)/8) + 4],
                         instruction_set [($unsigned(f_PC)/8) + 5],
                         instruction_set [($unsigned(f_PC)/8) + 6],
                         instruction_set [($unsigned(f_PC)/8) + 7],
                         instruction_set [($unsigned(f_PC)/8) + 8]};
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                f_Val_P = memory_for_instructions [$unsigned(f_PC) + 8 + f_need_regids * 8 + f_need_Val_C * 64][63 : 0];
            end
        end

        /// Return operation : ret
        if(f_Ins_Code == 9)begin
            if(f_Ins_fun != 0)begin
                $display("Function code for return is 0");
            end

            if(f_Ins_fun == 0)begin
                //no need to fetch anything, we just need to update pc to the next instruction after the call

                f_need_regids = 0;
                f_need_Val_C = 0;
            end
        end

        /// Pushq 
        if(f_Ins_Code == 10)begin
            if(f_Ins_fun != 0)begin
                $display("Function code for pushq is 0");
            end

            if(f_Ins_fun == 0)begin
                f_need_regids = 1;
                f_need_Val_C = 0;
                f_rA = instruction_set [($unsigned(f_PC)/8) + 1][7 : 4];
                f_rB = instruction_set [($unsigned(f_PC)/8) + 1][3 : 0];
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                f_Val_P = memory_for_instructions [$unsigned(f_PC) + 8 + f_need_regids * 8 + f_need_Val_C * 64][63 : 0];
            end
        end


        /// Popq 
        if(f_Ins_Code == 11)begin
            if(f_Ins_fun != 0)begin
                $display("Function code for popq is 0");
            end
            if(f_Ins_fun == 0)begin
                f_need_Val_C = 0;
                f_need_regids = 1;
                f_rA = instruction_set [($unsigned(f_PC)/8) + 1][7 : 4];
                f_rB = instruction_set [($unsigned(f_PC)/8) + 1][3 : 0];
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                f_Val_P = memory_for_instructions [$unsigned(f_PC) + 8 + f_need_regids * 8 + f_need_Val_C * 64][63 : 0];

            end
        end
    end
end

end

// setting status codes
always @(*)begin
    #0.5
    f_stat[0] = f_instruction_invalid_check;
    f_stat[1] = f_mem_invalid_check;
end

// PC predict
always @(negedge clk)begin
    if(f_Ins_Code == 7 || f_Ins_Code == 8)begin
        f_PC_PREDICT = f_Val_C;
    end
    else begin
        f_PC_PREDICT= f_Val_P;
    end
end


initial begin
    f_stat[0] = 0;
    f_stat[1] = 0;
    f_stat[2] = 0;
end
endmodule
