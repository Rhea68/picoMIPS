//-----------------------------------------------------
// File Name : pc.sv
// Function : picoMIPS Program Counter
// functions: increment, absolute and relative branches
// Author: rz
// Last rev. 24/04/2024
//-----------------------------------------------------
module pc #(parameter Psize = 5) // up to 32 instructions
(input logic clk, nreset, PCincr,PCrelbranch,//PCabsbranch,
 input logic [Psize-1:0] Branchaddr,
 output logic [Psize-1 : 0]PCout
);

//------------- code starts here---------
logic[Psize-1:0] Rbranch; // temp variable for addition operand

	
always_comb
  if (PCincr)
      Rbranch = {{(Psize-1){1'b0}}, 1'b1};
  else
      Rbranch =  Branchaddr;

always_ff @(posedge clk or negedge nreset) // async reset
   if (!nreset) // sync reset
      PCout <= {Psize{1'b0}};
   else if (PCincr | PCrelbranch) // increment or relative branch
      PCout <= PCout + Rbranch; // 1 adder does both
   
	 
	 
endmodule // module pc