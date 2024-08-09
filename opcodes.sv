//-----------------------------------------------------
// File Name: opcodes.sv
// Function: opcodes for decoder
// Author: rz
// Last rev. 24/04/2024
//-----------------------------------------------------


`define WAIT0    3'b000  // No operation 

`define ADD    3'b001  // ADD %d, %s;  %d = %d + %s

`define ADDI   3'b010  // ADDI %d, %s, imm;  %d = %s + imm

`define MULI   3'b011  // MULI %d, %s, imm;  %d = %s * imm

`define ADDF   3'b110  // ADDF %d, %s, imm;  %d = %s + inport imm

`define RETURN    3'b111  //branch at specified conditions 

 `define WAIT1   3'b101  // branch at readyin=1
 
 `define SHOW     3'b100