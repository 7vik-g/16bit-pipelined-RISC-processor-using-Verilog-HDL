`timescale 1ns / 1ps

module stack_pointer(
    input clk, reset,
    input [7:0] SP_load,
    output reg [7:0] SP,
    input SP_load_en,
    input inr_SP, dcr_SP
    );
    wire [7:0] SP_next;
    
    always @(posedge clk, negedge reset)
        if(!reset) SP <= 8'hFF;                 // after reset: stack pointer to 255th memory location
    else SP <= SP_next;
    
    // while storing, decrement the SP and store in that location
    // while loading, read from that location and increment the SP
    
    // increment & decrement circuit
    wire [7:0] A_in = ({8{inr_SP}} & SP) | ({8{dcr_SP}} & ~SP);
    wire [7:0] Y;
    wire [7:0] Y_out = ({8{inr_SP}} & Y) | ({8{dcr_SP}} & ~Y);
    incrementer_8bit Incrementer_8bit (A_in, Y);
    
    wire no_change = (~SP_load_en) & (~inr_SP) & (~dcr_SP);
    assign SP_next = ({8{SP_load_en}} & SP_load) | Y_out | ({8{no_change}} & SP);
    
endmodule
