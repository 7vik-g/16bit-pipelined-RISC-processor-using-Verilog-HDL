`timescale 1ns / 1ps

module Register_file(
    input clk, reset,
    input [4:0] wR_addr, rR1_addr, rR2_addr,        // wR_addr => write register address, rR1_addr => read register 1 address
    input write_en, rR1_en, rR2_en,
    input [15:0] write_data,
    output [15:0] R1_data, R2_data
    );
    wire [0:31] w_control, r1_control, r2_control;
    wire [0:(32*16 - 1)] r;
    
    register_16bit Register [0:31] (clk, reset, w_control, {32{write_data}}, r);
    
    decoder_5x32 write_control (w_control, wR_addr, write_en),
                   rR1_control (r1_control, rR1_addr, rR1_en),
                   rR2_control (r2_control, rR2_addr, rR2_en);
    
    tri_state_buffer_16bit     buff1 [0:31] (R1_data, r, r1_control),
                               buff2 [0:31] (R2_data, r, r2_control);
    
endmodule