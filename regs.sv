//-----------------------------------------------------
// File Name : regs.sv
// Function : picoMIPS 32 x n registers, %0 == 0
// Author: rz
// Last rev. 24/04/2024
//-----------------------------------------------------
module regs #(parameter n = 8) // n - data bus width
(input logic  clk, w,fetch,addr1,addr2, // clk and write control
 input logic [n-1:0] Wdata,
 input logic  [1:0] Raddr1, Raddr2,
 output logic [n-1:0] Rdata1, Rdata2
 );

 	// Declare 6 n-bit registers 
	logic [n-1:0] gpr [3:0];
	//logic addr1,addr2;
	
	// write process, dest reg is Raddr1
	always_ff @ (posedge clk)
	begin
		if (w)
            gpr[Raddr1] <= Wdata;
	end
	


	// read process, output 0 if %0 is selected
	always_comb
	begin
	   if (addr1==1)
	         Rdata1 =  {n{1'b0}};
		else  if (fetch)
		        Rdata1 =  {n{1'b0}};
              else  
			    Rdata1 = gpr[Raddr1];
	 
        if (addr2==1)
	        Rdata2 =  {n{1'b0}};
	  else  Rdata2 = gpr[Raddr2];
	end	
	

endmodule // module regs