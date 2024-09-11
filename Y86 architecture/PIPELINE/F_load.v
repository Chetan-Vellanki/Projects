// `timescale 1ns / 1ps
module Fetch_Register(
    input clk, 
    input F_toStall,
    output reg [63 : 0] F_PC_PREDICT,
    input  [63 : 0] f_PC_PREDICT
);
initial begin
    // f_PC_PREDICT = 0;
    #9
    F_PC_PREDICT = 0;
end
always @(posedge clk)begin
    if(F_toStall == 1)begin
        F_PC_PREDICT <= F_PC_PREDICT;
    end

    //else if(F_toStall == 0)begin
        F_PC_PREDICT <= f_PC_PREDICT;
    //end

end


endmodule