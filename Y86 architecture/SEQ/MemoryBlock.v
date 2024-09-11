////// IN OUR IMPLEMENTATION WE HAVE TAKEN INSTRCTION MEMORY ERROR AS data_memory_error
/////// and memory address exceeding error as imemory_error...
// rest implementation is according to the architecture.....

module MemoryBlock(
    input clk,
    input [3 : 0] Ins_Code,
    input [3 : 0] Ins_fun,
    input signed [63 : 0] value_A,
    input signed [63 : 0] value_B,
    input signed [63 : 0] Value_E,
    output reg signed [63 : 0] Value_M,
    input [63 : 0] Val_P,
    input PC_mem_invalid_check, // PC adress begin invalid or valid
    input instruction_invalid_check, // instruction code validity
    input func_invalid_check, // function begin valid
    output reg imemory_error, // whether memory to be written or read is valid
    output reg data_memory_error , // data read from memory to be valid or not
    output reg status_of_memory,
    input [63 : 0] no_of_valid_instruction // number of valid instructions given as input 

);

// allowing 4096 memory adress into the memory file
// memory addressess 
reg [63 : 0] main_memory_file_adresses [0 : 4095];
// data stored in the memory addressess
reg signed [63 : 0] main_memory_file_data [0 : 4095];

integer memory_index ;
initial begin
    for(memory_index = 0 ; memory_index < 4096 ; memory_index = memory_index + 1)begin

        main_memory_file_adresses[memory_index] = memory_index;
        main_memory_file_data[memory_index] = memory_index + 64'd1;
    end
// we should implement maximum 2 reads and 2 writes in the memory block

end
always @ (posedge clk)begin
    imemory_error = 1'bx;
    data_memory_error = 1'bx;
    status_of_memory = 1'bx;
    #9

    if(PC_mem_invalid_check == 0)begin
        //$display("-------HOIII-------'---N--------------------------\n");
        if(instruction_invalid_check == 0)begin
            //$display("-----------------HELLO----------------");

            
               // $display("=-------------IPA-------------------------");
             // HALT : 

                if(Ins_Code == 0)begin
                // no need of accessing the memory
                end
             // no operation nop
                if(Ins_Code == 1)begin
                // no need of accessing the memory
                end
             // conditional move 
                if(Ins_Code == 2)begin
                // no need of accessing the memory for cmovq
                end

             //immediate to register move  
                if(Ins_Code == 3)begin
                // no need of accessing the memory
                end

             // register to memory move
                if(Ins_Code == 4)begin
                // register an address and we get a displacement
                // the new memory adress should lie in the memory file to store the register value

                    if($unsigned(Value_E)<=4095)begin
                        imemory_error = 0;
                        // now push value in register A into the memory
                        // value_A ==> data box of the adress ValueE
                        main_memory_file_data[$unsigned(Value_E)] = value_A;
                        $display("----- Memory Status : Data pushed from register to memory ------");
                        // we do not discuss data error here as we are pushing data into the memory 
                        status_of_memory = 1;// memory begin used
                    end
                    else begin 
                        imemory_error = 1;
                        $display("---  Memory adress exceeded !!! -----");
                    end
                end

                // memory to register move
                if(Ins_Code == 5)begin
                    //register rB has adress and Displacement D
                    // val_E stores the rB + D address 
                    // new address of Val_E is searched in memory and given to the ValM
                    // then Val M is pushed into the rA at write back stage
                    if($unsigned(Value_E)<=4095)begin
                        imemory_error = 0;
                        Value_M = main_memory_file_data[$unsigned(Value_E)];
                        //if(Value_M != 64'bx)begin
                            data_memory_error = 0;
                            $display("Valid data taken from memory");
                            status_of_memory = 1;
                        //end
                        // else begin 
                        //     data_memory_error = 1;
                        //     $display("Invalid data taken from memory");
                        //     status_of_memory = 0;
                        // end

                    end
                    else begin
                        status_of_memory = 0;
                        imemory_error = 1;
                        $display("----- Memory address exceeded !!! -----");
                    end
                end

                // arithematic operations
                if(Ins_Code == 6)begin
                    // no need to access memory
                end

                // conditional jump condition
                if(Ins_Code == 7)begin
                    // no need to access to memory
                end
                
                /// Call function
                if(Ins_Code == 8)begin
                    //storing the next instruction address in the memory to access during return command
                    if( $unsigned(Value_E)<=4095)begin
                        imemory_error = 0;
                        main_memory_file_data[$unsigned(Value_E)] = Val_P[63 : 0];
                        $display("----- Memory Status : Adress of next unstruction pushed to memory ------");
                        status_of_memory = 1;// memory begin used
                    end

                    else begin
                        status_of_memory = 0;
                        imemory_error = 1;
                        $display("----- Memory address exceeded !!! -----");

                    end
                end

                // pushq
                if(Ins_Code == 10)begin
                    if( $unsigned(Value_E)<=4095)begin
                        imemory_error = 0;
                        main_memory_file_data[$unsigned(Value_E)] = value_A[63 : 0];
                        $display("----- Memory Status : Adress of pushed data instruction pushed to memory ------");
                        status_of_memory = 1;// memory begin used
                    end

                    else begin
                        status_of_memory = 0;
                        imemory_error = 1;
                        $display("----- Memory address exceeded !!! -----");

                    end
                end

                // popq command
                if(Ins_Code == 11)begin
                    if($unsigned(value_A)<=4095)begin
                        imemory_error = 0;
                        Value_M = main_memory_file_data[$unsigned(value_A)];
                        $display("----- Memory Status : Data extracted from the memory ------");
                        

                       //if(Value_M != 64'bx)begin
                            data_memory_error = 0;
                            $display("----Valid data taken from memory-----");
                            status_of_memory = 1;
                        //end
                        // else begin 
                        //     data_memory_error = 1;
                        //     $display("----Invalid data taken from memory----");
                        //     status_of_memory = 0;
                        // end
                    end

                    else begin
                        status_of_memory = 0;
                        imemory_error = 1;
                        $display("----- Memory address exceeded !!! -----");

                    end
                end

                // return command
                if(Ins_Code == 9)begin
                    if($unsigned(value_A)<=4095)begin
                        imemory_error = 0;
                        Value_M = main_memory_file_data[$unsigned(value_A)];
                        $display("----- Memory Status : Data extracted from the memory ------");
                        
                        //if(Value_M != 64'bx)begin

                            if( ($unsigned(Value_M)>=0)   && Value_M <= ($unsigned(no_of_valid_instruction)))begin
                                data_memory_error = 0;
                                $display("----Valid instruction taken from memory-----");
                                status_of_memory = 1;
                            end
                        //end
                        // else begin 
                        //     data_memory_error = 1;
                        //     $display("----Invalid instruction taken from memory----");
                        //     status_of_memory = 0;
                        // end
                        
                    end

                     else begin
                        status_of_memory = 0;
                        imemory_error = 1;
                        $display("----- Memory address exceeded !!! -----");

                    end
                end
            end
        end
    end

endmodule