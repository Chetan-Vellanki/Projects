`include "ALU_64.v"
module Test_Bench;
reg [63:0] A_input;
reg [63:0] B_input;
reg S0;
reg S1;

wire [64:0] Final_Output;
ALU_BLOCK Alu_Operations(.Ain(A_input), .Bin(B_input), .S0(S0), .S1(S1), .Final_Output(Final_Output));
always begin
    #1
    $display("S1 = %b, S0 = %b", S1, S0);
    // $display("------------------");
    $display("A = %b, B = %b", A_input, B_input);
    // $display("------------------");
    $display("Final_Output is %b", Final_Output);
    if(S0==0 && S1 ==0)begin
    $display("Decimal representation: ",$signed(Final_Output));
    end

     if(S0==1 && S1 ==0)begin
    //     genvar count, sum;
    //     generate
    //     for (count = 0, sum = 0; count < 62;count = count+1)begin
    //         sum = sum + (2^(count))*Final_Output[count];
    //     end
    //     sum = sum - (2^(63))*Final_Output[63];
        if(Final_Output[64]==1)begin
        $display("Decimal representation: -",$unsigned(Final_Output[63:0]));
        end

        if(Final_Output[64]==0)begin
            $display("Decimal Representation: ",$signed(Final_Output[63:0]));
        end
    //     endgenerate
     end
    if(S0==0 && S1 ==0)begin
    if(A_input[63]==0 & B_input[63]==0 & Final_Output[63]==1)begin
        $display("OVERFLOW OCCURED");
    end

    if(A_input[63]==1 & B_input[63]==1 & Final_Output[63]==0)begin
        $display("OVERFLOW OCCURED");
    end
    end

    if(S0==1 && S1 ==0)begin
    if(A_input[63]==0 & B_input[63]==1 & Final_Output[63]==1)begin
        $display("OVERFLOW OCCURED");
    end

    if(A_input[63]==1 & B_input[63]==0 & Final_Output[63]==0)begin
        $display("OVERFLOW OCCURED");
    end
    end
    $display("-----------------------");
    $display("-----------------------");
    $display("-----------------------");
end

initial begin
    $dumpfile("ALU_64.vcd");
    $dumpvars(0, Test_Bench);
    S1 = 0 ;S0 = 0;
    A_input = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    B_input = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    #1

    S1 = 0 ;S0 = 1;
    A_input = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    B_input = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    #1

    S1 = 1 ;S0 = 0;
    A_input = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    B_input = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    #1

    S1 = 1 ;S0 = 1;
    A_input = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    B_input = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    #1

    // Case 1 for Overflow: During Addition:// 
    // When +ve + +ve number gives -ve number

    S1 = 0 ;S0 = 0;
    A_input = 64'b0100000000000000000000000000000000000000000000000000000000000000;
    B_input = 64'b0100000000000000000000000000000000000000000000000000000000000000;
    #1

    // Case2 for overflow : During Addition//
    // When -ve  +  -ve number gives +ve number
    S1 = 0 ;S0 = 0;
    A_input = 64'b1000000000000000000000000000000000000000000000000000000000000000;
    B_input = 64'b1000000000000000000000000000000000000000000000000000000000000000;
    #1

    //Case3 for overflow : During Subtraction//
    //When +ve  -  -ve gives -ve number
     S1 = 0 ;S0 = 1;
    A_input = 64'b0110000000000000000000000000000000000000000000000000000000000000;
    B_input = 64'b1000000000000000000000000000000000000000000000000000000000000000;
    #1

    //Case4 for overflow : During subtraction//
    //When -ve  -  +ve gives +ve number
    S1 = 0; S0 = 1;
    A_input = 64'b1110000000000000000000000000000000000000000000000000000000000000;
    B_input = 64'b0111111111111111111111111111111111111111111111111111111111111111;
    #1

    S1 = 0; S0 = 1;
    B_input = 64'b0000000000000000000000000000000000000000000000000000000000000101;
    A_input = 64'b0000000000000000000000000000000000000000000000000000000000001010;
    #1




    

    $finish;
end
endmodule