////// IN OUR IMPLEMENTATION WE HAVE TAKEN INSTRCTION MEMORY ERROR AS data_memory_error
/////// and memory address exceeding error as imemory_error...
// rest implementation is according to the architecture.....
// `timescale 1ns / 1ps

module MemoryBlock(
    input clk,
    input [3 : 0] M_Ins_Code,
    input [3 : 0] M_Ins_fun,
    input signed [63 : 0] M_value_A,
    input signed [63 : 0] M_Value_E,
    input [2 : 0] M_stat,
    output reg signed [63 : 0] m_Value_M,
    output reg imemory_error, // whether memory to be written or read is valid
    output reg data_memory_error , // data read from memory to be valid or not
    output reg [2 : 0] m_stat,
    input [63 : 0] f_no_of_valid_instruction // number of valid instructions given as input 

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
always @ (*)begin
    imemory_error = 1'bx;
    data_memory_error = 1'bx;
    //status_of_memory = 1'bx;
    #9

    if(M_stat[1] == 0)begin
        //$display("-------HOIII-------'---N--------------------------\n");
        if(M_stat[0] == 0)begin
            //$display("-----------------HELLO----------------");

            
               // $display("=-------------IPA-------------------------");
             // HALT : 

                if(M_Ins_Code == 0)begin
                // no need of accessing the memory
                    m_stat = 3'b100;
                end
             // no operation nop
                if(M_Ins_Code == 1)begin
                // no need of accessing the memory
                    m_stat = M_stat;
                end
             // conditional move 
                if(M_Ins_Code == 2)begin
                // no need of accessing the memory for cmovq
                   m_stat = M_stat; 
                end

             //immediate to register move  
                if(M_Ins_Code == 3)begin
                // no need of accessing the memory
                    m_stat = M_stat;
                end

             // register to memory move
                if(M_Ins_Code == 4)begin
                // register an address and we get a displacement
                // the new memory adress should lie in the memory file to store the register value

                    if($unsigned(M_Value_E)<=4095)begin
                        imemory_error = 0;
                        // now push value in register A into the memory
                        // value_A ==> data box of the adress ValueE
                        main_memory_file_data[$unsigned(M_Value_E)] = M_value_A;
                        $display("-------- Memory data value = %d--------",main_memory_file_data[$unsigned(M_Value_E)] );
                        $display("----- Memory Status : Data pushed from register to memory ------");
                        // we do not discuss data error here as we are pushing data into the memory 
                        m_stat = 3'd0;// memory begin used
                    end
                    else begin 
                        imemory_error = 1;
                        $display("---  Memory adress exceeded !!! -----");
                        m_stat = 3'b010;
                    end
                end

                // memory to register move
                if(M_Ins_Code == 5)begin
                    //register rB has adress and Displacement D
                    // val_E stores the rB + D address 
                    // new address of Val_E is searched in memory and given to the ValM
                    // then Val M is pushed into the rA at write back stage
                    if($unsigned(M_Value_E)<=4095)begin
                        imemory_error = 0;
                         $display("-------- Memory data value for mrmovq = %d--------",main_memory_file_data[$unsigned(M_Value_E)] );
                        m_Value_M = main_memory_file_data[$unsigned(M_Value_E)];
                        //if(Value_M != 64'bx)begin
                            data_memory_error = 0;
                            $display("Valid data taken from memory");
                            m_stat = 3'b000;
                        //end
                        // else begin 
                        //     data_memory_error = 1;
                        //     $display("Invalid data taken from memory");
                        //     status_of_memory = 0;
                        // end

                    end
                    else begin
                        m_stat = 3'b010;
                        imemory_error = 1;
                        $display("----- Memory address exceeded !!! -----");
                    end
                end

                // arithematic operations
                if(M_Ins_Code == 6)begin
                    // no need to access memory
                    m_stat = M_stat;
                end

                // conditional jump condition
                if(M_Ins_Code == 7)begin
                    // no need to access to memory
                    m_stat = M_stat;
                end
                
                /// Call function
                if(M_Ins_Code == 8)begin
                    //storing the next instruction address in the memory to access during return command
                    if( $unsigned(M_Value_E)<=4095)begin
                        imemory_error = 0;
                        main_memory_file_data[$unsigned(M_Value_E)] = M_value_A[63 : 0];
                        $display("----- Memory Status : Adress of next unstruction pushed to memory ------");
                        m_stat = 3'd0;// memory begin used
                    end

                    else begin
                        m_stat = 4'b010;
                        imemory_error = 1;
                        $display("----- Memory address exceeded !!! -----");

                    end
                end

                // pushq
                if(M_Ins_Code == 10)begin
                    if( $unsigned(M_Value_E)<=4095)begin
                        imemory_error = 0;
                        main_memory_file_data[$unsigned(M_Value_E)] = M_value_A[63 : 0];
                        $display("----- Memory Status : Adress of pushed data instruction pushed to memory ------");
                        m_stat = 3'd0;// memory begin used
                    end

                    else begin
                        m_stat = 3'b010; 
                        imemory_error = 1;
                        $display("----- Memory address exceeded !!! -----");

                    end
                end

                // popq command
                if(M_Ins_Code == 11)begin
                    if($unsigned(M_value_A)<=4095)begin
                        imemory_error = 0;
                        m_Value_M = main_memory_file_data[$unsigned(M_value_A)];
                        $display("----- Memory Status : Data extracted from the memory ------");
                        

                       //if(Value_M != 64'bx)begin
                            data_memory_error = 0;
                            $display("----Valid data taken from memory-----");
                            m_stat = 3'd0; // memory being used
                        //end
                        // else begin 
                        //     data_memory_error = 1;
                        //     $display("----Invalid data taken from memory----");
                        //     status_of_memory = 0;
                        // end
                    end

                    else begin
                        m_stat = 3'b010;
                        imemory_error = 1;
                        $display("----- Memory address exceeded !!! -----");

                    end
                end

                // return command
                if(M_Ins_Code == 9)begin
                    if($unsigned(M_value_A)<=4095)begin
                        imemory_error = 0;
                        m_Value_M = main_memory_file_data[$unsigned(M_value_A)];
                        $display("----- Memory Status : Data extracted from the memory ------");
                        
                        //if(Value_M != 64'bx)begin

                            if( ($unsigned(m_Value_M)>=0)   && ( $unsigned(m_Value_M) <= f_no_of_valid_instruction))begin
                                data_memory_error = 0;
                                $display("----Valid instruction taken from memory-----");
                                m_stat = 3'd0;
                            end
                        //end
                        // else begin 
                        //     data_memory_error = 1;
                        //     $display("----Invalid instruction taken from memory----");
                        //     status_of_memory = 0;
                        // end
                        
                    end

                     else begin
                        m_stat = 3'b010;
                        imemory_error = 1;
                        $display("----- Memory address exceeded !!! -----");

                    end
                end
            end

            else begin
                m_stat = 3'b001;
            end
        end
        else begin
            m_stat = 3'b010;
        end
    end

endmodule