module NOT(input A, output C);
not out_not(C,A);
endmodule


// MODULE FOR AND
module AND(input A, input B, output C);
and out_and(C,A,B);
endmodule

// MODULE FOR OR
module OR(input A, input B, output C);
or out_or(C,A,B);
endmodule

// MODULE FOR NAND
module NAND(input A, input B, output C);
nand out_nand(C,A,B);

endmodule

//MODULE FOR NOR
module NOR(input wire A, input wire B, output wire C);
nor out_nor(C,A,B);
endmodule

//MODULE FOR XOR
module XOR(input A, input B, output C);
xor out_xor(C,A,B);
endmodule

//MODULE FOR XNOR
module XNOR(input A, input B, output C);
xnor out_xnor(C,A,B);
endmodule