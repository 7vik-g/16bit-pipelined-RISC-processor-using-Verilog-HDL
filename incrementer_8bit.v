`timescale 1ns / 1ps

module incrementer_8bit(
    input [7:0] A,
    output [7:0] Y
    );
    wire [7:0] C;
    wire C_out;
    
    assign C[0] = 1'b1;
    
    half_adder HA [7:0] (A, C, Y, {C_out,C[7:1]});
    
endmodule



module half_adder(
    input A, B,
    output Y, C
    );
    
    assign Y = A^B;
    assign C = A|B;
    
endmodule