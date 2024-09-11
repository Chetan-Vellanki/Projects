// MODULE FOR NOT
module NOT(input  A, output  C);
assign C = ~A;
endmodule


// MODULE FOR AND
module AND(input  A, input  B, output  C);
assign C = A & B;
endmodule

// MODULE FOR OR
module OR(input  A, input  B, output  C);
assign C = A | B;
endmodule

// MODULE FOR NAND
module NAND(input A, input B, output C);
AND first_and(.A(A), .B(B), .C(C1));
NOT then_not(.A(C1),.C(C));

endmodule

//MODULE FOR NOR
module NOR(input A, input B, output C);
OR first_or(.A(A), .B(B), .C(C1));
NOT then_not(.A(C1), .C(C1));
endmodule

//MODULE FOR XOR
module XOR(input A, input B, output C);
NOT N1(.A(A), .C(A'));
NOT N2(.A(B), .C(B'));
AND and_1(.A(A), .B(B'), .C(and1));
AND and_2(.A(B), .B(A'), .C(and2));
OR final_xor_output(.A(and1), .B(and2), .C(C));
endmodule

//MODULE FOR XNOR
module XNOR(input A, input B, output C);
XOR first_xor(.A(A), .B(B), .C(xor));
NOT then_not(.A(xor), .C(C));
endmodule