module PC_update(
    input clk,
    input [63 : 0] no_of_valid_instruction,
    input [63 : 0] PC_adress,
    input [3 : 0] Ins_Code,
    input [3 : 0] Ins_fun,
    input signed [63 : 0] Val_C,
    input [63 : 0] Val_P,
    input signed [63 : 0] Value_M,
    input mem_invalid_check,
    input instruction_invalid_check,
    input conditional_code_satisfy_check,
    output reg [63 : 0] new_PC_address

);

always @ (negedge clk)begin

    #3
    if(mem_invalid_check == 0)begin
        if(instruction_invalid_check == 0)begin
            if(Ins_Code == 0)begin
                new_PC_address = no_of_valid_instruction * 8 + 64'd8;
            end
            // nop
            if(Ins_Code == 1)begin
                new_PC_address = Val_P;
            end
            //cmov
            if(Ins_Code == 2)begin
                new_PC_address = Val_P;
            end

            //irmovq
            if(Ins_Code == 3)begin
                new_PC_address = Val_P;
            end
            // rmmovq
            if(Ins_Code == 4)begin
                new_PC_address = Val_P;
            end

            // mrmovq
            if(Ins_Code == 5)begin
                new_PC_address = Val_P;
            end

            //opq
            if(Ins_Code == 6)begin
                new_PC_address = Val_P;
            end

            //jump XX
            if(Ins_Code == 7)begin
                if(conditional_code_satisfy_check == 1)begin
                    new_PC_address = Val_C;
                end
                if(conditional_code_satisfy_check == 0)begin
                    new_PC_address = Val_P;
                end
            end

            // call
            if(Ins_Code == 8)begin
                new_PC_address = Val_C;
            end

            //return ret:
            if(Ins_Code == 9)begin
                new_PC_address = Value_M;
            end

            //pushq
            if(Ins_Code == 10)begin
                new_PC_address = Val_P;
            end

            // popq
            if(Ins_Code == 11)begin
                new_PC_address = Val_P;
            end

        end
    end

end

// always @(negedge clk)begin
//     #0.3
//     PC_adress = new_PC_address;
// end
endmodule