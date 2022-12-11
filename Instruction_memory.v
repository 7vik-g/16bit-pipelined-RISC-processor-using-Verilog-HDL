`timescale 1ns / 1ps

`define Instruction_memory_file "C:\\Users\\sathv\\Documents\\Verilog\\16bit risc processor\\16bit risc processor.srcs\\sim_1\\new\\Instruction_memory.txt"

module Instruction_memory(
    input [12:0] addr,          // 13 bit address of 16-bit instruction register
    output reg [15:0] instruction
    );
    reg [15:0] instr_mem [0:8191];      // 0 - (2^13 - 1)
    
    initial $readmemb(`Instruction_memory_file, instr_mem);
    
    always @(addr)
    begin
        instruction = #65 instr_mem [addr];         // added delay to replicate real case
    end
    
endmodule
