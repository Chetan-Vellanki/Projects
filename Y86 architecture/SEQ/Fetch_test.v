`include "Fetch.v"
module Fetch_test;

    reg clk;
    reg [63 : 0] PC_adress;
    wire [3 : 0] Ins_Code;
    wire [3 : 0] Ins_fun;
    wire [3 : 0] rA;
    wire [3 : 0] rB;
    wire [63 : 0] Val_C;
    wire [63 : 0] Val_P;
    wire mem_invalid_check;
    wire instruction_invalid_check;
    wire func_invalid_check;
    wire need_regids;
    wire need_Val_C;
    Fetch Fetch_operation(.clk(clk), .PC_adress(PC_adress), .Ins_Code(Ins_Code),
                          .Ins_fun(Ins_fun), .rA(rA), .rB(rB), .Val_C(Val_C),
                          .Val_P(Val_P), .mem_invalid_check(mem_invalid_check),
                          .instruction_invalid_check(instruction_invalid_check),
                          .func_invalid_check(func_invalid_check),
                          .need_regids(need_regids),
                          .need_Val_C(need_Val_C) );
    always #1 begin
        clk = ~clk;
    end

    initial begin
        clk = 1;
        PC_adress = 64'd0;

        #2
        PC_adress = 64'd8;
        #2
        PC_adress = 64'd24;
        #2
        PC_adress = 64'd32;
        #2
        PC_adress = 64'd48;
        #2
        PC_adress = 64'd64;
        #2
        $finish;
    end

    always begin
        #2
        $display("Memory invalid check : ", mem_invalid_check);
        if(mem_invalid_check == 0)begin
            $display("PC Adress : ", PC_adress);
            $display("Instrction code : %b", Ins_Code);
            $display("Instruction invalid Check : ", instruction_invalid_check);
            if(instruction_invalid_check == 0)begin
                $display("Function code : %b ", Ins_fun);
                $display("Need for Val_C  : ",need_Val_C);
                $display("Need for registers : ", need_regids);
                if(need_Val_C==1)begin
                    $display("Val_C =  %b",Val_C);
                end
                $display("Val P = ", Val_P);
                if(need_regids == 1)begin
                    $display("register A : %b", rA);
                    $display("register B : %b", rB);
                end
            end
        end

        
        


    end

endmodule