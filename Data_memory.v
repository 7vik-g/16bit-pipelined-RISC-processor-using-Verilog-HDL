`timescale 1ns / 1ps

`define Data_memory_file "C:\\Users\\sathv\\Documents\\Verilog\\16bit risc processor\\16bit risc processor.srcs\\sim_1\\new\\Data_memory.txt"


module Data_memory(
    input clk,
    input [7:0] addr,
    input [15:0] write_data,
    output reg [15:0] read_data,
    input w_en,         // if(w_en == 1) data is written into the memory
    input hlt           // if(hlt == 1) data in the memory is tranfered into Data_memory_file so that after the excecution of program we see the results in the file
    );
    reg [15:0] data_mem [0:255];
    
    initial $readmemb(`Data_memory_file, data_mem);
    
    always @(posedge clk)
    begin
        if(w_en) data_mem [addr] <= write_data;
    end
    
    always @(addr)
    begin
        read_data = #40 data_mem [addr];        // added delay to replicate real case
    end
    
    integer mcd, i;
    always @(hlt)
    if(hlt)
    begin
        mcd = $fopen(`Data_memory_file, "w");
        $fdisplay(mcd, "//After the execution of program: ");
        for(i = 0; i < 255; i = i + 1)
        begin
            $fdisplay(mcd, "%b", data_mem[i]);
        end
        $fclose(mcd);
    end
    
endmodule
