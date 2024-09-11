module Fetch(
    // allowing up to 64 instructions
    input clk,
    // initially PC_adress takes the first adress of the memory_block
    input [63 : 0] PC_adress,
    output reg [3 : 0] Ins_Code,
    output reg [3 : 0] Ins_fun,
    output reg [3 : 0] rA,
    output reg [3 : 0] rB,
    output reg signed [63 : 0] Val_C,
    output reg [63 : 0] Val_P,
    output reg  mem_invalid_check,
    output reg instruction_invalid_check,
    output reg  func_invalid_check,
    output reg  need_regids,
    output reg need_Val_C,
    output reg [63 : 0] no_of_valid_instruction
    
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
    no_of_valid_instruction = 64'd0;
//     instruction_set[0]=8'b00100000; // 1 0
//    // #2
//     instruction_set[1]=8'b01100001; //6 fn
//     instruction_set[2]=8'b01110110; //rA rB
//    // #2
//     instruction_set[3]=8'b10010000;
//    // #2
//     instruction_set[4]=8'b10100000;
//     instruction_set[5]=8'b10101111;
//    // #2
//     instruction_set[6]=8'b10110000;
//     instruction_set[7]=8'b11101101;
//    // #2
//     instruction_set[8]=8'b10000000;
//     instruction_set[9]=8'b00000001;
//     instruction_set[10]=8'b00000100;
//     instruction_set[11]=8'b00000100;
//     instruction_set[12]=8'b00100000;
//     instruction_set[13]=8'b00001000;
//     instruction_set[14]=8'b00000000;
//     instruction_set[15]=8'b10000000;
//     instruction_set[16]=8'b00001000;
    instruction_set[0] = 8'b00010000; // 0 0
    instruction_set[1] = 8'b01100010; //2 fn
    instruction_set[2] = 8'b01100111; //rA rB
    instruction_set[3] = 8'b00110000; //3 fn
    instruction_set[4] = 8'b01100111; //rA rB
    instruction_set[5] = 8'b00000000; 
    instruction_set[6] = 8'b00000000; 
    instruction_set[7] = 8'b00000000;
    instruction_set[8] = 8'b00000000;
    instruction_set[9] = 8'b00000000;
    instruction_set[10] = 8'b00000000;
    instruction_set[11] = 8'b00000000;
    instruction_set[12] = 8'b00000111;
    instruction_set[13] = 8'b01000000; //4 fn
    instruction_set[14] = 8'b01100111; //rA rB
    instruction_set[15] = 8'b00000000; 
    instruction_set[16] = 8'b00000000; 
    instruction_set[17] = 8'b00000000;
    instruction_set[18] = 8'b00000000;
    instruction_set[19] = 8'b00000000;
    instruction_set[20] = 8'b00000000;
    instruction_set[21] = 8'b00000000;
    instruction_set[22] = 8'b00000011;
    instruction_set[23] = 8'b01010000; //5 fn
    instruction_set[24] = 8'b01100111; //rA rB
    instruction_set[25] = 8'b00010000; 
    instruction_set[26] = 8'b00010000; 
    instruction_set[27] = 8'b00100000;
    instruction_set[28] = 8'b00000010;
    instruction_set[29] = 8'b00010000;
    instruction_set[30] = 8'b00010000;
    instruction_set[31] = 8'b00000000;
    instruction_set[32] = 8'b00000000;
    instruction_set[33] = 8'b01100000; //6 fn
    instruction_set[34] = 8'b01100111; //rA rB
    instruction_set[35] = 8'b01110000; //7 fn
    instruction_set[36] = 8'b00010000; 
    instruction_set[37] = 8'b00010000; 
    instruction_set[38] = 8'b00100000;
    instruction_set[39] = 8'b00000010;
    instruction_set[40] = 8'b00010000;
    instruction_set[41] = 8'b00010000;
    instruction_set[42] = 8'b00000000;
    instruction_set[43] = 8'b00000000;
    instruction_set[44] = 8'b10000000; //8 fn
    instruction_set[45] = 8'b00010000; 
    instruction_set[46] = 8'b00010000; 
    instruction_set[47] = 8'b00100000;
    instruction_set[48] = 8'b00000010;
    instruction_set[49] = 8'b00010000;
    instruction_set[50] = 8'b00010000;
    instruction_set[51] = 8'b00000000;
    instruction_set[52] = 8'b00000000;
    instruction_set[53] = 8'b10110000; //9 fn
    instruction_set[54] = 8'b01100111; //rA rB


end
integer count_instruction_set;
initial begin
    #1
    for (count_instruction_set = 0; count_instruction_set < 300 ; count_instruction_set = count_instruction_set +1)begin

        if(instruction_set[count_instruction_set] == 8'bx)begin
            no_of_valid_instruction = no_of_valid_instruction + 64'd0;
        end

        else begin
            no_of_valid_instruction = no_of_valid_instruction + 64'd1;
        end
    end

end


always @ (posedge clk) begin

// integer PC_increment_bytes;
//integer $unsigned(PC_adress);
//$unsigned(PC_adress) = $unsigned(PC_adress);

if($unsigned(PC_adress) > 2400)begin
    mem_invalid_check = 1;
end
else begin
    mem_invalid_check = 0;
end

if(mem_invalid_check == 0)begin
    Ins_Code = instruction_set[$unsigned(PC_adress)/8][7 : 4];
    Ins_fun = instruction_set [$unsigned(PC_adress)/8][3 : 0];
    if(Ins_Code>=0 && Ins_Code <=11)begin 
        instruction_invalid_check = 0; 
    end
    else begin instruction_invalid_check = 1;
            $display("ERROR  :  Instruction code given is given .:: Range between 0 and 11"); end
    if(instruction_invalid_check == 0)begin
        /// HALT
        if(Ins_Code == 0 && Ins_fun == 0)begin
            // Do not do anything
            // to write something such that the code stops executing
        end
        /// No operation nop 
        if(Ins_Code == 1 && Ins_fun == 0)begin
            // skip this instruction
            need_regids = 0;
            need_Val_C = 0;
            //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
            Val_P = memory_for_instructions[$unsigned(PC_adress) + 8 + need_regids * 8 + need_Val_C * 64][63 : 0];
        end
        /// conditional move cmovXX
        if(Ins_Code == 2)begin
            if(0 <= Ins_fun <= 6)begin
                rA = instruction_set [($unsigned(PC_adress)/8) + 1][7 : 4];
                rB = instruction_set [($unsigned(PC_adress)/8) + 1][3 : 0];
                need_Val_C = 0;
                // since Val_C not present and needed, we do not fetch val_C.
                need_regids = 1;
                // since regids needed, we fetched registers ra and rb
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                Val_P = memory_for_instructions[$unsigned(PC_adress) + 8 + need_regids * 8 + need_Val_C * 64][63:0];

            end

            if(Ins_fun >6)begin
                $display("For cmovXX the function code range between 0 to 6");
            end
        end
        /// immediate Resigter move irmovq
        if(Ins_Code == 3)begin
            if(Ins_fun != 0)begin
                $display("ERROR: for irmovq : function code is 0, but not entered 0");

            end
            if(Ins_fun == 0)begin
                // immediate register move.
                need_Val_C = 1;
                need_regids = 1;
                rA = instruction_set [($unsigned(PC_adress)/8) + 1][7 : 4];
                rB = instruction_set [($unsigned(PC_adress)/8) + 1][3 : 0];
                Val_C = {instruction_set [($unsigned(PC_adress)/8) + 2],
                         instruction_set [($unsigned(PC_adress)/8) + 3],
                         instruction_set [($unsigned(PC_adress)/8) + 4],
                         instruction_set [($unsigned(PC_adress)/8) + 5],
                         instruction_set [($unsigned(PC_adress)/8) + 6],
                         instruction_set [($unsigned(PC_adress)/8) + 7],
                         instruction_set [($unsigned(PC_adress)/8) + 8],
                         instruction_set [($unsigned(PC_adress)/8) + 9]};
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                Val_P = memory_for_instructions [$unsigned(PC_adress) + 8 + need_regids * 8 + need_Val_C * 64][63 : 0];

            end
        end
        /// register to memory move rmmovq 
        if(Ins_Code == 4)begin
            if(Ins_fun != 0)begin
                $display("ERROR: for rmmovq : function code is 0, but not entered 0");

            end

            if(Ins_fun == 0)begin
                need_Val_C = 1;
                need_regids = 1;
                rA = instruction_set [($unsigned(PC_adress)/8) + 1][7 : 4];
                rB = instruction_set [($unsigned(PC_adress)/8) + 1][3 : 0];
                Val_C = {instruction_set [($unsigned(PC_adress)/8) + 2],
                         instruction_set [($unsigned(PC_adress)/8) + 3],
                         instruction_set [($unsigned(PC_adress)/8) + 4],
                         instruction_set [($unsigned(PC_adress)/8) + 5],
                         instruction_set [($unsigned(PC_adress)/8) + 6],
                         instruction_set [($unsigned(PC_adress)/8) + 7],
                         instruction_set [($unsigned(PC_adress)/8) + 8],
                         instruction_set [($unsigned(PC_adress)/8) + 9]};
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                Val_P = memory_for_instructions [$unsigned(PC_adress) + 8 + need_regids * 8 + need_Val_C * 64][63 : 0];
            end
        end

        /// memory to register move mrmovq
        if(Ins_Code == 5)begin
            if(Ins_fun != 0)begin
                $display("ERROR: for mrmovq : function code is 0, but not entered 0");

            end

            if(Ins_fun == 0)begin
                need_Val_C = 1;
                need_regids = 1;
                rA = instruction_set [($unsigned(PC_adress)/8) + 1][7 : 4];
                rB = instruction_set [($unsigned(PC_adress)/8) + 1][3 : 0];
                Val_C = {instruction_set [($unsigned(PC_adress)/8) + 2],
                         instruction_set [($unsigned(PC_adress)/8) + 3],
                         instruction_set [($unsigned(PC_adress)/8) + 4],
                         instruction_set [($unsigned(PC_adress)/8) + 5],
                         instruction_set [($unsigned(PC_adress)/8) + 6],
                         instruction_set [($unsigned(PC_adress)/8) + 7],
                         instruction_set [($unsigned(PC_adress)/8) + 8],
                         instruction_set [($unsigned(PC_adress)/8) + 9]};
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                Val_P = memory_for_instructions [$unsigned(PC_adress) + 8 + need_regids * 8 + need_Val_C * 64][63 : 0];
            end
        end

        /// Arithematic memory operations: OPq
        if(Ins_Code == 6)begin
            if(Ins_fun >3)begin
                $display("For OPq the function code range between 0 to 3");
            end

            if(Ins_fun >=0 && Ins_fun <=3)begin
                need_Val_C = 0;
                need_regids = 1;
                rA = instruction_set [($unsigned(PC_adress)/8) + 1][7 : 4];
                rB = instruction_set [($unsigned(PC_adress)/8) + 1][3 : 0];
               // PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                Val_P = memory_for_instructions [$unsigned(PC_adress) + 8 + need_regids * 8 + need_Val_C * 64][63 : 0];

            end
        end

        /// JUMP operations
        if(Ins_Code == 7)begin
            if(Ins_fun > 6)begin
                $display("Error :  for JUMP operations, the function codes between 0 and 6");
            end

            if(Ins_fun>=0 && Ins_fun <=6)begin
                need_regids = 0;
                need_Val_C =  1;
                Val_C = {instruction_set [($unsigned(PC_adress)/8) + 1],
                         instruction_set [($unsigned(PC_adress)/8) + 2],
                         instruction_set [($unsigned(PC_adress)/8) + 3],
                         instruction_set [($unsigned(PC_adress)/8) + 4],
                         instruction_set [($unsigned(PC_adress)/8) + 5],
                         instruction_set [($unsigned(PC_adress)/8) + 6],
                         instruction_set [($unsigned(PC_adress)/8) + 7],
                         instruction_set [($unsigned(PC_adress)/8) + 8]};
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                Val_P = memory_for_instructions [$unsigned(PC_adress) + 8 + need_regids * 8 + need_Val_C * 64][63 : 0];
                
            end
        end

        /// CALL operations : call
        if(Ins_Code == 8)begin
            if(Ins_fun != 0)begin
                $display("ERROR : for call the function code is 0");
            end

            if(Ins_fun == 0)begin
                need_regids = 0;
                need_Val_C = 1;
                Val_C = {instruction_set [($unsigned(PC_adress)/8) + 1],
                         instruction_set [($unsigned(PC_adress)/8) + 2],
                         instruction_set [($unsigned(PC_adress)/8) + 3],
                         instruction_set [($unsigned(PC_adress)/8) + 4],
                         instruction_set [($unsigned(PC_adress)/8) + 5],
                         instruction_set [($unsigned(PC_adress)/8) + 6],
                         instruction_set [($unsigned(PC_adress)/8) + 7],
                         instruction_set [($unsigned(PC_adress)/8) + 8]};
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                Val_P = memory_for_instructions [$unsigned(PC_adress) + 8 + need_regids * 8 + need_Val_C * 64][63 : 0];
            end
        end

        /// Return operation : ret
        if(Ins_Code == 9)begin
            if(Ins_fun != 0)begin
                $display("Function code for return is 0");
            end

            if(Ins_fun == 0)begin
                //no need to fetch anything, we just need to update pc to the next instruction after the call

                need_regids = 0;
                need_Val_C = 0;
            end
        end

        /// Pushq 
        if(Ins_Code == 10)begin
            if(Ins_fun != 0)begin
                $display("Function code for pushq is 0");
            end

            if(Ins_fun == 0)begin
                need_regids = 1;
                need_Val_C = 0;
                rA = instruction_set [($unsigned(PC_adress)/8) + 1][7 : 4];
                rB = instruction_set [($unsigned(PC_adress)/8) + 1][3 : 0];
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                Val_P = memory_for_instructions [$unsigned(PC_adress) + 8 + need_regids * 8 + need_Val_C * 64][63 : 0];
            end
        end


        /// Popq 
        if(Ins_Code == 11)begin
            if(Ins_fun != 0)begin
                $display("Function code for popq is 0");
            end
            if(Ins_fun == 0)begin
                need_Val_C = 0;
                need_regids = 1;
                rA = instruction_set [($unsigned(PC_adress)/8) + 1][7 : 4];
                rB = instruction_set [($unsigned(PC_adress)/8) + 1][3 : 0];
                //PC_increment_bytes = 8 + need_regids * 8 + need_Val_C * 64;
                Val_P = memory_for_instructions [$unsigned(PC_adress) + 8 + need_regids * 8 + need_Val_C * 64][63 : 0];

            end
        end
    end
end
end

endmodule
