`timescale 1ns / 1ps

module adder_16bit(
    input [15:0] A, B,
    input C_in,
    output [15:0] Y,
    output C_out
    );
    wire [15:0] C;
    
    assign C[0] = C_in;
    
    full_adder FA [15:0] (A, B, C, Y, {C_out,C[15:1]});
    
endmodule