`include "ALU_64.v"

module Execute(
    input clk,
    input [3 : 0] Ins_Code,
    input [3 : 0] Ins_fun,
    input instruction_invalid_check,
    input mem_invalid_check,
    input signed [63 : 0] Val_C,
    input signed [63 : 0] value_A,
    input signed [63 : 0] value_B,
    output reg signed [63 : 0] Value_E,
    output reg signed_flag,
    output reg overflow_flag,
    output reg zero_flag,
    output reg condition_satisfy_check

);

initial begin
    signed_flag = 1'b0;
    overflow_flag = 1'b0;
    zero_flag = 1'b0;
    condition_satisfy_check = 1'b0;
end
reg signed [63 : 0] Ain;
reg signed [63 : 0] Bin;
wire signed [64 : 0] Final_Output;
reg S0;
reg S1;
ALU_BLOCK Calling_ALU_For_Operations(.Ain(Ain), .Bin(Bin), .S0(S0), .S1(S1), .Final_Output(Final_Output));
// modules types for general gates.
reg in_AND11,in_AND12, in_or11, in_or12, in_xor11,in_xor12, in_not1;
wire out_AND1, out_or1, out_xor1, out_not1;

reg in_AND21,in_AND22, in_or21, in_or22, in_xor21,in_xor22, in_not2;
wire out_AND2, out_or2, out_xor2, out_not2;

reg in_AND31,in_AND32, in_or31, in_or32, in_xor31,in_xor32, in_not3;
wire out_AND3, out_or3, out_xor3, out_not3;

and AND_compute1(out_AND1, in_AND11, in_AND12);
or OR_compute1(out_or1, in_or11, in_or12);
xor XOR_compute1(out_xor1, in_xor11, in_xor12);
not NOT_compute1(out_not1, in_not1);

and AND_compute2(out_AND2, in_AND21, in_AND22);
or OR_compute2(out_or2, in_or21, in_or22);
xor XOR_compute2(out_xor2, in_xor21, in_xor22);
not NOT_compute2(out_not2, in_not2);

and AND_compute3(out_AND3, in_AND31, in_AND32);
or OR_compute3(out_or3, in_or31, in_or32);
xor XOR_compute3(out_xor3, in_xor31, in_xor32);
not NOT_compute3(out_not3, in_not3);

reg in_xnor1, in_xnor2;
wire out_xnor;




always @ (posedge clk)begin
    Value_E = 64'bx;
    //Value_M = 64'bx;
    #2.5
    if(mem_invalid_check == 0)begin
        // memory address isnt invalid
        if(instruction_invalid_check == 0)begin
            // instruction should be valid
            if(Ins_Code == 0)begin
                /// HALT :  no need to execute 
                //condition_satisfy_check = 1'bx;
            end

            if(Ins_Code == 1)begin
                /// no operation 
                //condition_satisfy_check = 1'bx;
            end

            if(Ins_Code == 2 || Ins_Code == 7)begin
                // two things to do.
                // 1. calculate Val_E and check for condition satisfy.
                // 2. for that we need to generate flags
                
                // 1. calculate Val_E
                if(Ins_Code == 2)begin
                    Ain = value_A;
                    Bin = value_B;
                    S1 = 0;
                    S0 = 0;
                    #5
                    Value_E = Final_Output [63 : 0];

                end
                // 2. check condition and change rB accordingly
                // that we will do in write back stage
                if(Ins_fun == 0)begin
                    condition_satisfy_check = 1;
                end
                if(Ins_fun == 1)begin
                    // less than of equal to
                    //( SF ^ OF ) | ZF
                    in_xor11 = signed_flag;
                    in_xor12 = overflow_flag;
                    in_or11 = out_xor1;
                    in_or12 = zero_flag;
                    condition_satisfy_check = out_or1;
                end

                if(Ins_fun == 2)begin
                    // less than
                    // SF ^ OF
                    in_xor11 = signed_flag;
                    in_xor12 = overflow_flag;
                    condition_satisfy_check = out_xor1;
                end

                if(Ins_fun == 3)begin
                    // equal to
                    condition_satisfy_check = zero_flag;
                end

                if(Ins_fun == 4)begin
                    // not equal to
                    in_not1 = zero_flag;
                    condition_satisfy_check = out_not1;
                end

                if(Ins_fun == 5)begin
                    // greater than or equal to
                    // ~(SF ^ OF)
                    in_xor11 = signed_flag;
                    in_xor12 = overflow_flag;
                    in_not1 = out_xor1;
                    condition_satisfy_check = out_not1;
                end

                if(Ins_fun == 6)begin
                    // greater than
                    in_not1 = zero_flag;
                    in_xor11 = signed_flag;
                    in_xor12 = overflow_flag;
                    in_not2 = out_xor1;
                    in_AND11 = out_not2;
                    in_AND12 = out_not1;
                    condition_satisfy_check = out_AND1;
                end


            end

            /// immediate register move
            if(Ins_Code == 3)begin
                // nothing to execute
                condition_satisfy_check = 1'bx;
                Value_E = Val_C;
            end

            /// register to memory move
            if(Ins_Code == 4)begin
                // addition of displacement of memory adress to Value_B
                // here, displacement can be +Ve or -ve 
                // but final Val_E should be unsigned as per memory for instruction
                // should work on that after some time
                Ain = value_B;
                Bin = Val_C;
                S0 = 0;
                S1 = 0;
                #5
                Value_E = Final_Output [63 : 0];
            end

            /// memory to register move
            if(Ins_Code == 5)begin

                Ain = value_B;
                Bin = Val_C;
                S0 = 0;
                S1 = 0;
                #5
                Value_E = Final_Output [63 : 0];

            end

            /// operation : 
            if(Ins_Code == 6)begin
                // 1. operation between A and B
                if(Ins_fun == 0)begin
                    // addq
                    Ain = value_A;
                    Bin = value_B;
                    S0 = 0;
                    S1 = 0;
                    #5
                    Value_E = Final_Output [63 : 0];
                end

                if(Ins_fun == 1)begin

                    //sub
                    Ain = value_A;
                    Bin = value_B;
                    S1 = 0;
                    S0 = 1;
                    #5
                    Value_E = Final_Output [63 : 0];
                end

                if(Ins_fun == 2)begin
                    // and
                    Bin = value_B;
                    Ain = value_A;
                    
                    
                    S1 = 1;
                    S0 = 0;
                    $display("------and output------ %d %b %d",Ain,value_B,Final_Output);
                    #5
                    Value_E = Final_Output [63 : 0];
                end

                if(Ins_fun == 3)begin
                    // xor
                    Ain = value_A;
                    Bin = value_B;
                    S1 = 1;
                    S0 = 1;
                    #5
                    Value_E = Final_Output[63 : 0];
                end

                // conditional flags
                if(Value_E == 64'd0)begin // zero flag
                    zero_flag = 1;
                end
                else begin
                    zero_flag = 0;
                end

                if(Value_E [63] == 1)begin // signed flag
                    signed_flag = 1;
                end
                else begin
                    signed_flag = 0;
                end

                in_xnor1 = value_A [63];
                in_xnor2 = value_B [63];
                in_xor11 = value_A [63];
                in_xor12 = signed_flag;
                in_AND11 = out_xnor;
                in_AND12 = out_xor1;
                overflow_flag = out_AND1; // overflow flag set
            end

            // call and pushq
            if(Ins_Code == 8 || Ins_Code == 10 )begin
                // decrementing stack pointer
                Ain = value_B;
                Bin = 64'd64;
                S1 = 0;
                S0 = 1;
                #5
                Value_E = Final_Output[63 : 0];
            end

            /// return ret and popq : 
            if(Ins_Code == 9 || Ins_Code == 11 )begin
                // incrementing stack pointer
                Ain = value_B;
                Bin = 64'd64;
                S1 = 0;
                S0 = 0;
                #5
                Value_E = Final_Output[63 : 0];
            end
        end
    end
end
endmodule

module test();

endmodule