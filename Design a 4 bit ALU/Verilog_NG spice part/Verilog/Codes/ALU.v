`include "module_gates_2.v"
`include "modules_combination_sub_circuits.v"
module Test_Bench;
 reg [3:0] A;
 reg [3:0] B;
 reg S0;
 reg S1;

// Sending these select line inputs into the 2 to 4 decoder :
// Output from the decoder are the four 4 bit code sequence D3,D2,D1,D0
wire D3,D2,D1,D0;
wire [4:0] S_add;
wire [3:0] S_anding;
wire s_lesser, s_greater,s_equal;
DECODER_2_4 DEC(.S0(S0), .S1(S1), .D0(D0), .D1(D1), .D2(D2), .D3(D3));
ADDER_SUBTRATOR A_S(.A(A), .B(B), .D0(D0), .D1(D1), .S_add(S_add));
COMPARATOR a_compare_b(.A(A), .B(B), .D2(D2), .s_equal(s_equal), .s_greater(s_greater), .s_lesser(s_lesser));
ANDING a_and_b(.A(A), .B(B), .D3(D3), .S_anding(S_anding));
    always begin
        #1
    $display("SELECT INPUTS : S1 = ",S1," S0 = ",S0);
    $display("DECODER OUTPUTS : D0 = ",D0," D1 = ",D1," D2 = ",D2," D3 = ",D3);
    $display("GIVEN INPUTS:");
    $display("A = ",A[3],A[2],A[1],A[0]," B = ",B[3],B[2],B[1],B[0]);
    $display("-------------");
    if(D0 == 1)begin
        $display("OPERATION CALLED FOR ADDING");
        $display("ADDER OUTPUTS:: ",S_add[4],S_add[3],S_add[2],S_add[1],S_add[0]);
    end

    if(D1 == 1)begin
        $display("OPERATION CALLED FOR SUBTRACTING");
        $display("ADDER OUTPUTS:: ",S_add[4],S_add[3],S_add[2],S_add[1],S_add[0]);
    end
    
    if(D2 == 1)begin
        
        $display("S_equal is ",s_equal);
        $display("S_greater is ",s_greater);
        $display("S_lesser is ",s_lesser);
        $display("OPERATION CALLED TO COMPARE");
        if(s_greater == 1)begin
            $display("A IS GREATER THAN B");
        end
        if(s_equal == 1)begin
            $display("A is equal to B");
        end
        if(s_lesser == 1)begin
            $display("A IS LESSER THAN B");
        end
    end

    if(D3 == 1)begin
        $display("OPERATION CALLED TO AND");
        $display("A & B = ",S_anding[3],S_anding[2],S_anding[1],S_anding[0]);
    end
    $display("--------------------------------------");

    end


initial begin
    $dumpfile("ALU.vcd");
    $dumpvars(0, Test_Bench);
    S1 = 0; S0 = 0;
    A = 4'b0001;
    B = 4'b1000;

    #1
    S1 = 0; S0 = 0;
    A = 4'b1111;
    B = 4'b1111;

    #1
    S1 = 0; S0 = 0;
    A = 4'b1101;
    B = 4'b0111;
    #1
    S1 = 0; S0 = 1;
    A = 4'b0011;
    B = 4'b0100;
    #1
    S1 = 0; S0 = 1;
    A = 4'b1011;
    B = 4'b0110;
    #1
    S1 = 0; S0 = 1;
    A = 4'b0000;
    B = 4'b0111;

    #1
    S1 = 1; S0 = 0;
    A = 4'b0101;
    B = 4'b0101;

    #1
    S1 = 1; S0 = 0;
    A = 4'b0101;
    B = 4'b0100;

    #1
    S1 = 1; S0 = 0;
    A = 4'b1111;
    B = 4'b1110;

    #1
    S1 = 1; S0 = 0;
    A = 4'b1110;
    B = 4'b1111;

    #1
    S1 = 1; S0 = 1;
    A = 4'b0111;
    B = 4'b0101;
    #1
    S1 = 1; S0 = 1;
    A = 4'b0111;
    B = 4'b1110;
    #1


    $finish;

end

endmodule
