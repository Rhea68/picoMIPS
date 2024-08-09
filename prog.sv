//-----------------------------------------------------
// File Name : prog.sv
// Function : Program memory Psize x Isize - reads from file prog.hex
// Author: rz 
// Last rev. 24/04/2024
//-----------------------------------------------------
module prog #(parameter Psize = 5, Isize = 15) // psize - address width, Isize - instruction width
(input logic [Psize-1:0] address,
output logic [Isize-1:0] I); // I - instruction code

// program memory declaration, note: 1<<n is same as 2^n
logic [Isize-1:0] progMem[21:0];

// get memory contents from file
initial
  $readmemh("prog.hex", progMem);
  
// program memory read 
always_comb
  I = progMem[address];
  
endmodule // end of module prog