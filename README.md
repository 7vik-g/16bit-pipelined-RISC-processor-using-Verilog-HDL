# 16bit-pipelined-RISC-processor-using-Verilog-HDL
- Developed a new Reduced Instruction Set with least possible no. of instructions in it such that the designed Processor can be used to implement almost any Function by combination of instructions
- Implemented the Processor using Verilog HDL in Xilinx Vivado
- In the process of Designing the processor, I have implemented many smaller components like 16-bit adder, Decoders, Register file, Stack Pointer, Program Counter, ALU and finally integrating everything as processor by designing Control Unit, buses, instruction registers, etc
- Using the concept of pipelining divided execution of instruction in several stages such that approximately one instruction is executed for every clock cycle


Processor schematic
![processor_schematic1](https://user-images.githubusercontent.com/97520594/202520401-72d4a9eb-84e6-4165-bba4-f04cb39df76e.png)
![processor_schematic2](https://user-images.githubusercontent.com/97520594/202520407-31db42d6-1803-44e7-bac4-9d32972de8c1.png)


ALU schematic
![ALU_schematic](https://user-images.githubusercontent.com/97520594/202520563-5a068225-069e-4ff4-9a8e-b1336c4f873e.png)


Control unit schematic
![Control_unit1_schematic](https://user-images.githubusercontent.com/97520594/202520569-1dfd3510-e9d0-4665-a333-9142adaf6dc3.png)
![Control_unit2_schematic](https://user-images.githubusercontent.com/97520594/202520572-f80a96f6-bbf4-431c-a738-607342fbbf4d.png)
