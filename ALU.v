`timescale 1ns / 1ps
module ALU(
    input op,
    input [2:0] ALU_func,
    input [15:0] A, B,
    input p_Z, p_CY,
    output [15:0] Y_out,
    output Z, CY
    );
    wire [15:0] Y0, Y1;
    wire Z0, CY0, Z1, CY1;
    
    assign Z = op ? Z1 : Z0;
    assign CY = op ? CY1 : CY0;
    assign Y_out = op ? Y1 : Y0;
    
    ALU000 ALU_000 (ALU_func, A, B, p_CY, Y0, Z0, CY0);
    ALU001 ALU_001 (ALU_func[1:0], A, B, p_Z, p_CY, Y1, Z1, CY1); 
    
endmodule


module ALU000(
    input [2:0] ALU_func,
    input [15:0] A, B,
    input p_CY,
    output [15:0] Y,
    output reg Z, CY
    );
    reg [15:0] A_in, B_in;
    reg C_in;
    wire C_out;
    
    always @(*)
    case (ALU_func)
    3'b000 : begin A_in = A;        B_in = B;           C_in = p_CY;  CY = C_out;  Z = ~|Y; end      // {CY,Y} = A + B + p_CY;
    3'b001 : begin A_in = A;        B_in = B;           C_in = 1'b0;  CY = C_out;  Z = ~|Y; end      // {CY,Y} = A + B;
    3'b010 : begin A_in = A;        B_in = 16'h0000;    C_in = 1'b1;  CY = C_out;  Z = ~|Y; end      // {CY,Y} = A + 1;
    3'b011 : begin A_in = 16'h0000; B_in = ~B;          C_in = 1'b0;  CY = C_out;  Z = ~|Y; end      // {CY,Y} = ~B;
    3'b100 : begin A_in = A;        B_in = ~B;          C_in = ~p_CY; CY = ~C_out; Z = ~|Y; end      // {CY,Y} = A - B - p_CY;
    3'b101 : begin A_in = A;        B_in = ~B;          C_in = 1'b1;  CY = ~C_out; Z = ~|Y; end      // {CY,Y} = A - B;
    3'b110 : begin A_in = A;        B_in = 16'hFFFF;    C_in = 1'b0;  CY = ~C_out; Z = ~|Y; end      // {CY,Y} = A - 1;
    3'b111 : begin A_in = A;        B_in = ~B;          C_in = 1'b1;  CY = ~C_out; Z = CY;  end      // if(A<B) Z = 1; else Z = 0;
    endcase
    
    adder_16bit Adder_16bit (A_in, B_in, C_in, Y, C_out);
    
endmodule

module ALU001(
    input [1:0] ALU_func,
    input [15:0] A, B,
    input p_Z, p_CY,
    output reg [15:0] Y,
    output reg Z, CY
    );
    
    always @(*)
    case (ALU_func)
    2'b00 : begin Y = A&B;           CY = 1'b0;  Z = ~|Y; end    // AND  
    2'b01 : begin Y = A|B;           CY = 1'b0;  Z = ~|Y; end    // OR   
    2'b10 : begin {Y,CY} = {A[14:0],p_CY,A[15]};  Z = p_Z; end    // RCL: Rotate with Carry Left  
    2'b11 : begin {Y,CY} = {p_CY,A};             Z = p_Z; end    // RCR: Rotate with Carry Right 
    endcase
    
endmodule
