`timescale 1ns / 1ps

module decoder_3x8(
    output [0:7] Y,
    input [2:0] A,
    input en
    );
    
    and Y0 (Y[0], ~A[2], ~A[1], ~A[0], en),
        Y1 (Y[1], ~A[2], ~A[1],  A[0], en),
        Y2 (Y[2], ~A[2],  A[1], ~A[0], en),
        Y3 (Y[3], ~A[2],  A[1],  A[0], en),
        Y4 (Y[4],  A[2], ~A[1], ~A[0], en),
        Y5 (Y[5],  A[2], ~A[1],  A[0], en),
        Y6 (Y[6],  A[2],  A[1], ~A[0], en),
        Y7 (Y[7],  A[2],  A[1],  A[0], en);
    
endmodule
