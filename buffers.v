`timescale 1ns / 1ps

module tri_state_buffer_16bit(
    output [15:0] o,
    input [15:0] i,
    input control
    );
    
    tri_state_buffer ts_buf [0:15] (o, i, control);
    
endmodule

module tri_state_buffer(
    output Y,
    input A,
    input C
    );
    
    bufif1 tri_state_buf (Y, A, C);
    
endmodule

module buffer(
    output Y,
    input A
    );
    
    buf normal_buf (Y, A);
    
endmodule