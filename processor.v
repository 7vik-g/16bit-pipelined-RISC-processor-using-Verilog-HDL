`timescale 1ns / 1ps


module processor(
    input clk, reset,
    output [12:0] instr_mem_addr,
    input [15:0] instr,
    output [7:0] data_mem_addr,
    input [15:0] read_data,
    output [15:0] write_data,
    output Dataw_en,
    input start,
    output hlt,
    input Serial_input,
    output Serial_output
    );
    wire [4:0] wR_addr, rR1_addr, rR2_addr;
    wire [15:0] R1_bus, R2_bus, write_bus;
    
    //------------------------------------for pipelining----------------------------------------------------
    reg [15:0] instr_stage1, instr_stage2;      // stage 0 is only for getting instruction from instr_memory
    always @(posedge clk, negedge reset)        // for stage 1 operations, the instruction which is stored 
        if(!reset) instr_stage1 <= 16'h0000;    // in the register is decoded and sends control signals 
        else instr_stage1 <= instr;             // to perform operations.. resulting data moves through bus
                                                // and waites at the destination register.
    always @(posedge clk, negedge reset)        // for stage 2 operations, the instruction is transfered
        if(!reset) instr_stage2 <= 16'h0000;    // to this stage register and it is decoded to send signals to store
        else instr_stage2 <= instr_stage1;      // in the corresponding register and at the begining of next cycle,
                                                // the data is being stored in destination register.
    
    
    assign wR_addr  = instr_stage2[12:8];       // as mentioned above data is written at the end of 2nd cycle
    assign rR1_addr = instr_stage1[12:8];       // and read at end of 1st cycle
    assign rR2_addr = instr_stage1[7:3];
    
    
    //------------------------------------register file-----------------------------------------------------
    wire Regw_en, rR1_en, rR2_en;
    Register_file REGISTER_FILE (clk, reset, wR_addr, rR1_addr, rR2_addr, Regw_en,
                                 rR1_en, rR2_en, write_bus, R1_bus, R2_bus);
    
    
    //-----------------------------------------ALU----------------------------------------------------------
    wire [15:0] A, B, Result;
    wire ALU_en;
    wire ALU_write_en;
    
    register_16bit regA (clk, reset, ALU_en, R1_bus, A);       // so that the read data stays on bus only in ALU_en cycle
    register_16bit regB (clk, reset, ALU_en, R2_bus, B);
    tri_state_buffer_16bit w_Result (write_bus, Result, ALU_write_en);  // write of reg file should also be enabled in stage 2
    
    reg p_Z, p_CY;
    wire Z, CY;
    always @(posedge clk, negedge reset)
    if(!reset) begin p_Z <= 1'b0; p_CY <= 1'b0; end
    else if(ALU_write_en) begin p_Z <= Z; p_CY <= CY; end
        
        //----------------------for serial communication-------------------------
        wire SI_en, SO_en;
        wire p_CY_mux_SI = SI_en ? Serial_input : p_CY; // Serial input => if opcode: 001 Rd xxxx1 010 (uses RCL) then MSB first,
                                                        // else if opcode: 001 Rd xxxx1 011 (uses RCR) then LSB first.
        assign Serial_output = p_CY;                    // Serial output=>  if opcode: 001 Rd xxxx0 010 (uses RCL) then MSB first,
                                                        // else if opcode: 001 Rd xxxx0 011 (uses RCR) then LSB first.
        
    ALU Arithmetic_Logic_Unit (instr_stage2[13], instr_stage2[2:0], A, B, p_Z, p_CY_mux_SI, Result, Z, CY);
    
    
    //---------------------------Load & Store operations : Data_memory--------------------------------------
    wire iRW_regw_en, iRW_regr_en;
    wire Datar_en;
    tri_state_buffer_16bit Data_R1 (R1_bus, read_data, Datar_en);                    // Data form memory => R1_bus
    
    wire [15:0] Q_iRW_reg;
    register_16bit iRW_reg (clk, reset, iRW_regw_en, R1_bus, Q_iRW_reg); // intermediate register b/w Read1 and write buses for pipelining
    tri_state_buffer_16bit iRW_reg_data (write_bus, Q_iRW_reg, iRW_regr_en);
    assign write_data = write_bus;                                       // since we have Dataw_en;
    
    
    //---------------------------------------MOV operation--------------------------------------------------
    wire mov_en;
    tri_state_buffer_16bit mov (R1_bus, R2_bus, mov_en);         // since we can send the data to intermediate register from R1_bus
    
    
    //-------------------------------program counter, JUMP & Call-------------------------------------------
    wire PC_load_en;
    wire [12:0] PC_load_addr, PC_load;
    wire R_nJ;
    
    assign PC_load = R_nJ ? write_bus[12:0] : instr_stage2[12:0];   // only for Return operation PC_load is connected to write_bus for retriving instr_mem_address from stack
                                                                    // so that stack read in stage1 is sent to iRW_reg and can be stored from write_bus in stage 2
    buffer pc_load [12:0] (PC_load_addr, PC_load);                  // JZ and JNZ are executed in stage2 because the zero flag of previous
                                                                    // operation gets updated when this instruction is at the end of stage1
    program_counter Program_counter (clk, reset, instr_mem_addr, PC_load_addr, PC_load_en, start, hlt);
    
    
    
    //-----------------------------------stack pointer & Call-----------------------------------------------
    wire SP_load_en, inr_SP, dcr_SP;
    wire [7:0] SP, SP_load;
    buffer sp_load [7:0] (SP_load, instr_stage1[10:3]);         // so as to execute any instruction related to SP without any NOP instruction and as this instruction 
                                                                // doesn't depend on p_Z, and other SP using instructions like Call and return
                                                                // have two NOP instructions following them. => changing in stage1 doesn't affect anything
    
    stack_pointer Stack_pointer (clk, reset, SP_load, SP, SP_load_en, inr_SP, dcr_SP);
    
        
    //-------------------------------------data_memory_addr-------------------------------------------------
    wire SPr, SPw;
    wire [7:0] read_addr = SPr ? SP : instr_stage1[7:0];
    wire [7:0] write_addr = SPw ? SP : instr_stage2[7:0];
    assign data_mem_addr = ({8{Dataw_en}} & write_addr) | ({8{Datar_en}} & read_addr);
    
    
    //---------------------------------------control unit---------------------------------------------------
    CU1 Control_unit1 (instr_stage1, ALU_en, rR1_en, rR2_en, mov_en, SI_en,
                        Datar_en, iRW_regw_en, SP_load_en, dcr_SP, SPr);
    
    CU2 Control_unit2 (instr_stage2, p_Z, ALU_write_en, Regw_en, iRW_regr_en,
                        Dataw_en, PC_load_en, R_nJ, inr_SP, SPw, hlt);
    
    
endmodule




