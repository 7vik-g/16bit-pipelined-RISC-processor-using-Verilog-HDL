`timescale 1ns / 1ps

module CU1(
    input [15:0] instr_stage1,
    output ALU_en,
    output rR1_en, rR2_en, mov_en,
    output SI_en, Datar_en, iRW_regw_en,
    output SP_load_en, dcr_SP, SPr
    );
    wire [0:7] p;
    wire p1f5 = p[1]&( instr_stage1[2])&(~instr_stage1[1])&( instr_stage1[0]);
    wire RETZ  = p1f5&(~instr_stage1[12])&( instr_stage1[11]);
    wire RETNZ = p1f5&( instr_stage1[12])&(~instr_stage1[11]);
    wire CZ = p[6];
    wire CNZ = p[7];
    
    decoder_3x8 instr_decoder1 (p, instr_stage1[15:13], 1'b1);
    
    assign ALU_en = p[0] | (p[1]&(~instr_stage1[2]));
    assign rR1_en = ALU_en | p[3];
    assign rR2_en = ALU_en | mov_en;
    assign mov_en = p[1]&(instr_stage1[2])&(~instr_stage1[1])&(~instr_stage1[0]); // MOV opcode : 001 Rd Rs 100
    assign SI_en =  p[1]&(~instr_stage1[2])&(instr_stage1[1])& (instr_stage1[3]); // Serial input => if opcode: 001 Rd xxxx1 010 (uses RCL) then MSB first,
                                                                                  // else if opcode: 001 Rd xxxx1 011 (uses RCR) then LSB first.
    assign Datar_en = p[2] | SPr;             
    assign iRW_regw_en = p[2] | p[3] | mov_en | RETZ | RETNZ;                     // data gets transferred to intermediate register at the end of stage 1;
    assign SP_load_en = p1f5&(~instr_stage1[12])&(~instr_stage1[11]);
    assign SPr = RETZ | RETNZ;
    assign dcr_SP = CZ | CNZ;
    
endmodule



module CU2(
    input [15:0] instr_stage2,
    input p_Z,
    output ALU_write_en, Regw_en,
    output iRW_regr_en, Dataw_en,
    output PC_load_en, R_nJ,
    output inr_SP, SPw,
    output HLT
    );
    wire [0:7] p;
    wire mov = p[1]&(instr_stage2[2])&(~instr_stage2[1])&(~instr_stage2[0]); // MOV opcode : 001 xxxxx xxxxx 100
    wire JZ = p[4];
    wire JNZ = p[5];
    wire CZ = p[6];
    wire CNZ = p[7];
    wire Call_en = (CZ & p_Z) | (CNZ & ~p_Z);
    wire p1f5 = p[1]&( instr_stage2[2])&(~instr_stage2[1])&( instr_stage2[0]);
    wire RETZ  = p1f5&(~instr_stage2[12])&( instr_stage2[11]);
    wire RETNZ = p1f5&( instr_stage2[12])&(~instr_stage2[11]);
    assign HLT = p1f5&( instr_stage2[12])&( instr_stage2[11]);
    
    decoder_3x8 instr_decoder2 (p, instr_stage2[15:13], 1'b1);
        
    assign ALU_write_en = p[0] | (p[1]&(~instr_stage2[2]));
    assign Regw_en = ALU_write_en | mov | p[2];
    assign iRW_regr_en = p[2] | p[3] | mov | R_nJ;
    assign Dataw_en = p[3] | Call_en;
    assign PC_load_en = (JZ & p_Z) | (JNZ & ~p_Z) | R_nJ | Call_en;
    assign R_nJ = (RETZ & p_Z) | (RETNZ & ~p_Z);
    assign inr_SP = R_nJ | ~(Call_en);                    // since we decremented the SP in stage 1 without checking the condition
    assign SPw = Call_en;
     
endmodule




