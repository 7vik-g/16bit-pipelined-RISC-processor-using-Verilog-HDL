`timescale 1ns / 1ps

module full_adder(
    input A, B, p_CY,
    output Y, CY
    );
    wire w1, w2, w3;
    
    assign w1 = A^B;
    assign w2 = A&B;
    
    assign Y = w1^p_CY;
    assign w3 = w1&p_CY;
    
    assign CY = w2|w3;
endmodule