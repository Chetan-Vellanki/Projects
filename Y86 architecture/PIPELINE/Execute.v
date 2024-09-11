// `timescale 1ns / 1ps
`include "ALU_64.v"

module Execute(
    input clk,
    input [3 : 0] E_Ins_Code,
    input [3 : 0] E_Ins_fun,
    input signed [63 : 0] E_Val_C,
    input signed [63 : 0] E_value_A,
    input signed [63 : 0] E_value_B,
    output reg signed [63 : 0] e_Value_E,
    output reg signed_flag,
    output reg overflow_flag,
    output reg zero_flag,
    output reg e_Cnd,
    output reg [3 : 0] e_dstE,
    input [2 : 0] E_stat,
    input [2 : 0] m_stat,
    input [2 : 0] W_stat,
    output reg SET_CC,
    input [3 : 0] E_dstE 
);

initial begin
   #9
    SET_CC = 1;
    signed_flag = 1'b0;
    overflow_flag = 1'b0;
    zero_flag = 1'b0;
    // condition_satisfy_check = 1'b0;
end

// always @ (*)begin
//     // Just thinking
//     if((E_Ins_Code == 6) && (E_stat == 0) && (m_stat == 0) && (W_stat == 0 ))begin
//         SET_CC = 1;
//     end
//     else begin
//         SET_CC = 0;
//     end
// end


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
xnor XNOR_compute(out_xnor, in_xnor1, in_xnor2);


always @ (*)begin
    //Value_E = 64'bx;
    //Value_M = 64'bx;
    #2.5

            if(E_Ins_Code == 0)begin
                /// HALT :  no need to execute 
                //condition_satisfy_check = 1'bx;
            end

            if(E_Ins_Code == 1)begin
                /// no operation 
                //condition_satisfy_check = 1'bx;
            end

            if(E_Ins_Code == 2)begin
                // two things to do.
                // 1. calculate Val_E and check for condition satisfy.
                // 2. for that we need to generate flags
                
                // 1. calculate Val_E
                if(E_Ins_Code == 2)begin
                    Ain = E_value_A;
                    Bin = 0;
                    S1 = 0;
                    S0 = 0;
                    #5
                    e_Value_E = Final_Output [63 : 0];

                end
                // 2. check condition and change rB accordingly
                // that we will do in write back stage
                if(E_Ins_fun == 0)begin
                    e_Cnd = 1;
                end
                if(E_Ins_fun == 1)begin
                    // less than of equal to
                    //( SF ^ OF ) | ZF
                    in_xor11 = signed_flag;
                    in_xor12 = overflow_flag;
                    in_or11 = out_xor1;
                    in_or12 = zero_flag;
                    #0.1
                    e_Cnd = out_or1;
                end

                if(E_Ins_fun == 2)begin
                    // less than
                    // SF ^ OF
                    in_xor11 = signed_flag;
                    in_xor12 = overflow_flag;
                    #0.1
                    e_Cnd = out_xor1;
                end

                if(E_Ins_fun == 3)begin
                    // equal to
                    e_Cnd = zero_flag;
                end

                if(E_Ins_fun == 4)begin
                    // not equal to
                    in_not1 = zero_flag;
                    #0.1
                    e_Cnd = out_not1;
                end

                if(E_Ins_fun == 5)begin
                    // greater than or equal to
                    // ~(SF ^ OF)
                    in_xor11 = signed_flag;
                    in_xor12 = overflow_flag;
                    #0.1
                    in_not1 = out_xor1;
                    #0.1
                    e_Cnd = out_not1;
                end

                if(E_Ins_fun == 6)begin
                    // greater than
                    in_not1 = zero_flag;
                    in_xor11 = signed_flag;
                    in_xor12 = overflow_flag;
                     #0.1
                    in_not2 = out_xor1;
                    #0.1
                    in_AND11 = out_not2;
                    in_AND12 = out_not1;
                    #0.1
                    e_Cnd = out_AND1;
                end
                if(e_Cnd == 0)begin
                    e_dstE = 4'd15;
                end
                else if(e_Cnd == 1)begin
                    e_dstE = E_dstE;
                end
            end

            if(E_Ins_Code == 7)begin
                if(E_Ins_fun == 0)begin
                    e_Cnd = 1;
                end
                if(E_Ins_fun == 1)begin
                    // less than of equal to
                    //( SF ^ OF ) | ZF
                    in_xor11 = signed_flag;
                    in_xor12 = overflow_flag;
                    in_or11 = out_xor1;
                    in_or12 = zero_flag;
                    #0.1
                    e_Cnd = out_or1;
                end

                if(E_Ins_fun == 2)begin
                    // less than
                    // SF ^ OF
                    in_xor11 = signed_flag;
                    in_xor12 = overflow_flag;
                    #0.1
                    e_Cnd = out_xor1;
                end

                if(E_Ins_fun == 3)begin
                    // equal to
                    e_Cnd = zero_flag;
                end

                if(E_Ins_fun == 4)begin
                    // not equal to
                    in_not1 = zero_flag;
                    #0.1
                    e_Cnd = out_not1;
                end

                if(E_Ins_fun == 5)begin
                    // greater than or equal to
                    // ~(SF ^ OF)
                    in_xor11 = signed_flag;
                    in_xor12 = overflow_flag;
                    #0.1
                    in_not1 = out_xor1;
                    #0.1
                    e_Cnd = out_not1;
                end

                if(E_Ins_fun == 6)begin
                    // greater than
                    in_not1 = zero_flag;
                    in_xor11 = signed_flag;
                    in_xor12 = overflow_flag;
                    #0.1
                    in_not2 = out_xor1;
                    #0.1
                    in_AND11 = out_not2;
                    in_AND12 = out_not1;
                    #0.1
                    e_Cnd = out_AND1;
                end


            end

            /// immediate register move
            if(E_Ins_Code == 3)begin
                // nothing to execute
                e_Cnd = 1'bx;
                e_Value_E = E_Val_C;
            end

            /// register to memory move
            if(E_Ins_Code == 4)begin
                // addition of displacement of memory adress to Value_B
                // here, displacement can be +Ve or -ve 
                // but final Val_E should be unsigned as per memory for instruction
                // should work on that after some time
                Ain = E_value_B;
                Bin = E_Val_C;
                S0 = 0;
                S1 = 0;
                #5
                e_Value_E = Final_Output [63 : 0];
            end

            /// memory to register move
            if(E_Ins_Code == 5)begin

                Ain = E_value_B;
                Bin = E_Val_C;
                S0 = 0;
                S1 = 0;
                #5
                e_Value_E = Final_Output [63 : 0];

            end

            /// operation : 
            
            if(E_Ins_Code == 6)begin
                // 1. operation between A and B
                if(E_Ins_fun == 0)begin
                    // addq
                    Ain = E_value_A;
                    Bin = E_value_B;
                    S0 = 0;
                    S1 = 0;
                    #5
                    e_Value_E = Final_Output [63 : 0];
                end

                if(E_Ins_fun == 1)begin

                    //sub
                    Ain = E_value_A;
                    Bin = E_value_B;
                    S1 = 0;
                    S0 = 1;
                    #5
                    e_Value_E = Final_Output [63 : 0];
                end

                if(E_Ins_fun == 2)begin
                    // and
                    Bin = E_value_B;
                    Ain = E_value_A;
                    
                    
                    S1 = 1;
                    S0 = 0;
                    //$display("------and output------ %d %b %d",Ain,value_B,Final_Output);
                    #5
                    e_Value_E = Final_Output [63 : 0];
                end

                if(E_Ins_fun == 3)begin
                    // xor
                    Ain = E_value_A;
                    Bin = E_value_B;
                    S1 = 1;
                    S0 = 1;
                    #5
                    e_Value_E = Final_Output[63 : 0];
                end

                // conditional flags
                //if(SET_CC == 1) begin
                    if(e_Value_E == 64'd0)begin // zero flag
                        zero_flag = 1;
                    end
                    else begin
                        zero_flag = 0;
                    end

                    if(e_Value_E [63] == 1)begin // signed flag
                        signed_flag = 1;
                    end
                    else begin
                        signed_flag = 0;
                    end

                    in_xnor1 = E_value_A [63];
                    $display("-----in_xnor1 : %b-------", in_xnor1);
                    in_xnor2 = E_value_B [63];
                    $display("-----in_xnor2 : %b-------", in_xnor2);
                    in_xor11 = E_value_A [63];
                    $display("-----in_xor11 : %b-------", in_xor11);
                    in_xor12 = signed_flag;
                    $display("-----in_xor12 : %b-------", in_xor12);
                    in_AND21 = out_xnor;
                    $display("-----in_and21 : %b-------", in_AND21);
                    in_AND22 = out_xor1;
                    $display("-----in_and22 : %b-------", in_AND22);
                    #0.2
                    overflow_flag = out_AND2; // overflow flag set
                    $display("-----out_and2 : %b ------", out_AND2);
                    $display(" ---------SIGNED FLAG = %b-------------", signed_flag);
                    $display("----------OVERFLOW FLAG = %b-------------", overflow_flag);
                    $display("-----------ZERO FLAG = %b---------------", zero_flag);
                    end   

                //end

            // call and pushq
            if(E_Ins_Code == 8 || E_Ins_Code == 10 )begin
                // decrementing stack pointer
                Ain = E_value_B;
                Bin = 64'd64;
                S1 = 0;
                S0 = 1;
                #5
                e_Value_E = Final_Output[63 : 0];
            end

            /// return ret and popq : 
            if(E_Ins_Code == 9 || E_Ins_Code == 11 )begin
                // incrementing stack pointer
                Ain = E_value_B;
                Bin = 64'd64;
                S1 = 0;
                S0 = 0;
                #5
                e_Value_E = Final_Output[63 : 0];
            end
            if(E_Ins_Code != 2) begin
                e_dstE = E_dstE;
            end
        end
endmodule
