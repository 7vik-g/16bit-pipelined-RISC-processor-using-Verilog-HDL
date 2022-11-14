`timescale 1ns / 1ps

module decoder_3x8(
    output [0:7] Y,
    input [2:0] A,
    input en
    );
    
    and (Y[0], ~A[2], ~A[1], ~A[0], en),
        (Y[1], ~A[2], ~A[1],  A[0], en),
        (Y[2], ~A[2],  A[1], ~A[0], en),
        (Y[3], ~A[2],  A[1],  A[0], en),
        (Y[4],  A[2], ~A[1], ~A[0], en),
        (Y[5],  A[2], ~A[1],  A[0], en),
        (Y[6],  A[2],  A[1], ~A[0], en),
        (Y[7],  A[2],  A[1],  A[0], en);
    
endmodule
