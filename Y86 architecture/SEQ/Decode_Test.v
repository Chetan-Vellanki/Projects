`include "Fetch.v"
`include "Decode.v"
module Decode_test;

    reg clk = 1;
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
    wire [63 : 0] value_A;
    wire [63 : 0] value_B;
    reg [63 : 0] Value_E;
    reg [63 : 0] Value_M;
    wire [63 : 0] rax;
    wire [63 : 0] rcx;
    wire [63 : 0] rdx;
    wire [63 : 0] rbx;
    wire [63 : 0] rsp;
    wire [63 : 0] rbp;
    wire [63 : 0] rsi;
    wire [63 : 0] rdi;
    wire [63 : 0] r8;
    wire [63 : 0] r9;
    wire [63 : 0] r10;
    wire [63 : 0] r11;
    wire [63 : 0] r12;
    wire [63 : 0] r13;
    wire [63 : 0] r14;
    wire [63 : 0] no_of_valid_instruction;

    Fetch Fetch_operation(.clk(clk), .PC_adress(PC_adress), .Ins_Code(Ins_Code),
                          .Ins_fun(Ins_fun), .rA(rA), .rB(rB), .Val_C(Val_C),
                          .Val_P(Val_P), .mem_invalid_check(mem_invalid_check),
                          .instruction_invalid_check(instruction_invalid_check),
                          .func_invalid_check(func_invalid_check),
                          .need_regids(need_regids),.need_Val_C(need_Val_C), 
                          .no_of_valid_instruction(no_of_valid_instruction) );
    Decode Decode_write_back_operation(
                          .clk(clk), .Ins_Code(Ins_Code), .Ins_fun(Ins_fun), 
                          .rA(rA), .rB(rB), .mem_invalid_check(mem_invalid_check), 
                          .instruction_invalid_check(instruction_invalid_check),
                          .need_regids(need_regids), .need_Val_C(need_Val_C),
                          .value_A(value_A), .value_B(value_B), .Value_E(Value_E),
                          .Value_M(Value_M), .rax(rax), .rcx(rcx), .rdx(rdx), .rbx(rbx), 
                          .rsp(rsp), .rbp(rbp), .rsi(rsi), .rdi(rdi), .r8(r8), .r9(r9), 
                          .r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14) );
    always #1 begin
        clk = ~clk;
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

    

    initial begin
        
        //clk = 0;
        #2
        PC_adress = 64'd0;
        Value_E = 64'd10;
        Value_M = 64'd15;




        // $display("Memory invalid check : ", mem_invalid_check);
        // if(mem_invalid_check == 0)begin
        //     $display("PC Adress : ", PC_adress);
        //     $display("Instrction code : %b", Ins_Code);
        //     $display("Instruction invalid Check : ", instruction_invalid_check);
        //     if(instruction_invalid_check == 0)begin
        //         $display("Function code : %b ", Ins_fun);
        //         $display("Need for Val_C  : ",need_Val_C);
        //         $display("Need for registers : ", need_regids);
        //         if(need_Val_C==1)begin
        //             $display("Val_C =  %b",Val_C);
        //         end
        //         $display("Val P = ", Val_P);
        //         if(need_regids == 1)begin
        //             $display("register A : %b", rA);
        //             $display("register B : %b", rB);
        //         end
        //     end
        // end

        

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
        #3
        $finish;
    end

    //always begin
        //#2
        // $display("Memory invalid check : ", mem_invalid_check);
        // if(mem_invalid_check == 0)begin
        //     $display("PC Adress : ", PC_adress);
        //     $display("Instrction code : %b", Ins_Code);
        //     $display("Instruction invalid Check : ", instruction_invalid_check);
        //     if(instruction_invalid_check == 0)begin
        //         $display("Function code : %b ", Ins_fun);
        //         $display("Need for Val_C  : ",need_Val_C);
        //         $display("Need for registers : ", need_regids);
        //         if(need_Val_C==1)begin
        //             $display("Val_C =  %b",Val_C);
        //         end
        //         $display("Val P = ", Val_P);
        //         if(need_regids == 1)begin
        //             $display("register A : %b", rA);
        //             $display("register B : %b", rB);
        //         end

        //         $display("----------------------------");
        //     end
        // end
    //end

    initial begin
        #2
        #0.5
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
                    $display("register B : %b & %t ", rB, $time);
                end

            end

        end

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
                    $display("register B : %b & %t", rB, $time);
                end

                
            end
        
        end

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
                    $display("register B : %b & %t", rB, $time);
                end

                
            end

        end

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
                    $display("register B : %b & %t", rB, $time);
                end

                
            end

        end

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
                    $display("register B : %b & %t", rB, $time);
                end

                
            end

        end

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
                    $display("register B : %b & %t", rB, $time);
                end

                
            end

        end


    end

    // always begin 
    //     #1
    //     $display(" PROGRAM REGISTER VALUES:");
    //     $display(" -------------------------------- ");
    //     $display("rax  : ", rax);
    //     $display("rcx : ", rcx);
    //     $display("rdx : ", rdx);
    //     $display("rbx : ", rbx);
    //     $display("rsp : ", rsp);
    //     $display("rbp : ", rbp);
    //     $display("rsi : ", rsi);
    //     $display("rdi : ", rdi);
    //     $display("r8 : ", r8);
    //     $display("r9 : ", r9);
    //     $display("r10 : ", r10);
    //     $display("r11 : ", r11);
    //     $display("r12 : ", r12);
    //     $display("r13 : ", r13);
    //     $display("r14 : ", r14);
    //     $display(" --------------------------------");
    

    // end

    initial begin
        #2
        #0.9
        $display(" PROGRAM REGISTER VALUES:");
        $display(" -------------------------------- ");
        $display("rax  : ", rax);
        $display("rcx : ", rcx);
        $display("rdx : ", rdx);
        $display("rbx : ", rbx);
        $display("rsp : ", rsp);
        $display("rbp : ", rbp);
        $display("rsi : ", rsi);
        $display("rdi : ", rdi);
        $display("r8 : ", r8);
        $display("r9 : ", r9);
        $display("r10 : ", r10);
        $display("r11 : ", r11);
        $display("r12 : ", r12);
        $display("r13 : ", r13);
        $display("r14 : ", r14);
        $display(" --------------------------------   & %t ", $time);
        
        #1
           $display(" PROGRAM REGISTER VALUES:");
        $display(" -------------------------------- ");
        $display("rax  : ", rax);
        $display("rcx : ", rcx);
        $display("rdx : ", rdx);
        $display("rbx : ", rbx);
        $display("rsp : ", rsp);
        $display("rbp : ", rbp);
        $display("rsi : ", rsi);
        $display("rdi : ", rdi);
        $display("r8 : ", r8);
        $display("r9 : ", r9);
        $display("r10 : ", r10);
        $display("r11 : ", r11);
        $display("r12 : ", r12);
        $display("r13 : ", r13);
        $display("r14 : ", r14);
        $display(" --------------------------------  & %t", $time);

        #1
           $display(" PROGRAM REGISTER VALUES:");
        $display(" -------------------------------- ");
        $display("rax  : ", rax);
        $display("rcx : ", rcx);
        $display("rdx : ", rdx);
        $display("rbx : ", rbx);
        $display("rsp : ", rsp);
        $display("rbp : ", rbp);
        $display("rsi : ", rsi);
        $display("rdi : ", rdi);
        $display("r8 : ", r8);
        $display("r9 : ", r9);
        $display("r10 : ", r10);
        $display("r11 : ", r11);
        $display("r12 : ", r12);
        $display("r13 : ", r13);
        $display("r14 : ", r14);
        $display(" --------------------------------  & %t", $time);

        #1
           $display(" PROGRAM REGISTER VALUES:");
        $display(" -------------------------------- ");
        $display("rax  : ", rax);
        $display("rcx : ", rcx);
        $display("rdx : ", rdx);
        $display("rbx : ", rbx);
        $display("rsp : ", rsp);
        $display("rbp : ", rbp);
        $display("rsi : ", rsi);
        $display("rdi : ", rdi);
        $display("r8 : ", r8);
        $display("r9 : ", r9);
        $display("r10 : ", r10);
        $display("r11 : ", r11);
        $display("r12 : ", r12);
        $display("r13 : ", r13);
        $display("r14 : ", r14);
        $display(" -------------------------------- &  %t", $time);

        #1
           $display(" PROGRAM REGISTER VALUES:");
        $display(" -------------------------------- ");
        $display("rax  : ", rax);
        $display("rcx : ", rcx);
        $display("rdx : ", rdx);
        $display("rbx : ", rbx);
        $display("rsp : ", rsp);
        $display("rbp : ", rbp);
        $display("rsi : ", rsi);
        $display("rdi : ", rdi);
        $display("r8 : ", r8);
        $display("r9 : ", r9);
        $display("r10 : ", r10);
        $display("r11 : ", r11);
        $display("r12 : ", r12);
        $display("r13 : ", r13);
        $display("r14 : ", r14);
        $display(" -------------------------------- &  %t", $time);

        #1
           $display(" PROGRAM REGISTER VALUES:");
        $display(" -------------------------------- ");
        $display("rax  : ", rax);
        $display("rcx : ", rcx);
        $display("rdx : ", rdx);
        $display("rbx : ", rbx);
        $display("rsp : ", rsp);
        $display("rbp : ", rbp);
        $display("rsi : ", rsi);
        $display("rdi : ", rdi);
        $display("r8 : ", r8);
        $display("r9 : ", r9);
        $display("r10 : ", r10);
        $display("r11 : ", r11);
        $display("r12 : ", r12);
        $display("r13 : ", r13);
        $display("r14 : ", r14);
        $display(" -------------------------------- & %t", $time);

        #1
           $display(" PROGRAM REGISTER VALUES:");
        $display(" -------------------------------- ");
        $display("rax  : ", rax);
        $display("rcx : ", rcx);
        $display("rdx : ", rdx);
        $display("rbx : ", rbx);
        $display("rsp : ", rsp);
        $display("rbp : ", rbp);
        $display("rsi : ", rsi);
        $display("rdi : ", rdi);
        $display("r8 : ", r8);
        $display("r9 : ", r9);
        $display("r10 : ", r10);
        $display("r11 : ", r11);
        $display("r12 : ", r12);
        $display("r13 : ", r13);
        $display("r14 : ", r14);
        $display(" --------------------------------  & %t", $time);

        #1
           $display(" PROGRAM REGISTER VALUES:");
        $display(" -------------------------------- ");
        $display("rax  : ", rax);
        $display("rcx : ", rcx);
        $display("rdx : ", rdx);
        $display("rbx : ", rbx);
        $display("rsp : ", rsp);
        $display("rbp : ", rbp);
        $display("rsi : ", rsi);
        $display("rdi : ", rdi);
        $display("r8 : ", r8);
        $display("r9 : ", r9);
        $display("r10 : ", r10);
        $display("r11 : ", r11);
        $display("r12 : ", r12);
        $display("r13 : ", r13);
        $display("r14 : ", r14);
        $display(" --------------------------------  & %t", $time);

        #1
           $display(" PROGRAM REGISTER VALUES:");
        $display(" -------------------------------- ");
        $display("rax  : ", rax);
        $display("rcx : ", rcx);
        $display("rdx : ", rdx);
        $display("rbx : ", rbx);
        $display("rsp : ", rsp);
        $display("rbp : ", rbp);
        $display("rsi : ", rsi);
        $display("rdi : ", rdi);
        $display("r8 : ", r8);
        $display("r9 : ", r9);
        $display("r10 : ", r10);
        $display("r11 : ", r11);
        $display("r12 : ", r12);
        $display("r13 : ", r13);
        $display("r14 : ", r14);
        $display(" -------------------------------- & %t", $time);
        #1
           $display(" PROGRAM REGISTER VALUES:");
        $display(" -------------------------------- ");
        $display("rax  : ", rax);
        $display("rcx : ", rcx);
        $display("rdx : ", rdx);
        $display("rbx : ", rbx);
        $display("rsp : ", rsp);
        $display("rbp : ", rbp);
        $display("rsi : ", rsi);
        $display("rdi : ", rdi);
        $display("r8 : ", r8);
        $display("r9 : ", r9);
        $display("r10 : ", r10);
        $display("r11 : ", r11);
        $display("r12 : ", r12);
        $display("r13 : ", r13);
        $display("r14 : ", r14);
        $display(" -------------------------------- & %t", $time);

        #1
           $display(" PROGRAM REGISTER VALUES:");
        $display(" -------------------------------- ");
        $display("rax  : ", rax);
        $display("rcx : ", rcx);
        $display("rdx : ", rdx);
        $display("rbx : ", rbx);
        $display("rsp : ", rsp);
        $display("rbp : ", rbp);
        $display("rsi : ", rsi);
        $display("rdi : ", rdi);
        $display("r8 : ", r8);
        $display("r9 : ", r9);
        $display("r10 : ", r10);
        $display("r11 : ", r11);
        $display("r12 : ", r12);
        $display("r13 : ", r13);
        $display("r14 : ", r14);
        $display(" --------------------------------  & %t", $time);

        #1
           $display(" PROGRAM REGISTER VALUES:");
        $display(" -------------------------------- ");
        $display("rax  : ", rax);
        $display("rcx : ", rcx);
        $display("rdx : ", rdx);
        $display("rbx : ", rbx);
        $display("rsp : ", rsp);
        $display("rbp : ", rbp);
        $display("rsi : ", rsi);
        $display("rdi : ", rdi);
        $display("r8 : ", r8);
        $display("r9 : ", r9);
        $display("r10 : ", r10);
        $display("r11 : ", r11);
        $display("r12 : ", r12);
        $display("r13 : ", r13);
        $display("r14 : ", r14);
        $display(" --------------------------------  & %t", $time);
        

    end

    initial begin
        
        #2
        #1.5
        $display("Value_A : ", value_A);
        $display("Value_B : ", value_B);
        $display("----------------------------  & %t", $time);

        
        #2
        $display("Value_A : ", value_A);
            $display("Value_B : ", value_B);
            $display("--------------------------- & %t", $time);

        
        #2
        $display("Value_A : ", value_A);
            $display("Value_B : ", value_B);
            $display("--------------------------- & %t", $time);

        #2
        $display("Value_A : ", value_A);
            $display("Value_B : ", value_B);
            $display("--------------------------- & %t", $time);

        #2
        $display("Value_A : ", value_A);
            $display("Value_B : ", value_B);
            $display("--------------------------- & %t", $time);
        
        
        #2

        $display("Value_A : ", value_A);
            $display("Value_B : ", value_B);
            $display("--------------------------- & %t", $time);
    end
endmodule