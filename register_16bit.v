`timescale 1ns / 1ps

module register_16bit(
    input clk, reset,
    input write_en,
    input [15:0] D,
    output reg [15:0] Q
    );
    
    always @(posedge clk, negedge reset)
    begin
        if(!reset) Q <= 16'h0000;
        else if(write_en) Q <= D;
    end
    
endmodule
