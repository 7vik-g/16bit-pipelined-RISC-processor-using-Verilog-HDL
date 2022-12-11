`timescale 1ns / 1ps

module program_counter(
    input clk, reset,
    output reg [12:0] instr_mem_addr,
    input [12:0] PC_load_addr,
    input load_enable,
    input start,
    input hlt
    );
    
    always @(posedge clk, negedge reset)
    if(!reset) instr_mem_addr <= 13'b00000_0000_0000;
    else if(!start) instr_mem_addr <= 13'b00000_0000_0000;
    else if(load_enable) instr_mem_addr <= PC_load_addr;
    else if(!hlt) instr_mem_addr <= instr_mem_addr + 1'b1;           // implementation of up counter
endmodule