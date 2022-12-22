`timescale 1ns / 1ps

module decoder_5x32(
    output [0:31] Y,
    input [4:0] A,
    input en
    );
    
    decoder_3x8 D0 (Y[0:7] ,A[2:0], (~A[4] & ~A[3] & en)),
                D1 (Y[8:15] ,A[2:0], (~A[4] &  A[3] & en)),
                D2 (Y[16:23] ,A[2:0], ( A[4] & ~A[3] & en)),
                D3 (Y[24:31] ,A[2:0], ( A[4] &  A[3] & en));
    
endmodule
