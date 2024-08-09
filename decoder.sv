//---------------------------------------------------------
// File Name   : decoder.sv
// Function    : picoMIPS instruction decoder 
// Author: rz
// Last revised: 24/04/2024
//---------------------------------------------------------

`include "alucodes.sv"
`include "opcodes.sv"
//---------------------------------------------------------
module decoder
( input logic [2:0] opcode, // top 6 bits of instruction
input logic readyin,
 // Branch status, connected to specified switch
output logic PCincr,PCrelbranch,//PCabsbranch,
//output logic[Psize-1:0]Branchaddr,
//    ALU control
output logic  ALUfunc, 
// imm mux control
output logic imm,
 // fetch mux control
 output logic fetch,
  // output display control
 output logic show,
//   register file control
output logic w,
output logic addr1,addr2 );
   
//------------- code starts here ---------
// instruction decoder
//logic takeBranch; // temp variable to control conditional branching
always_comb 
begin
  // set default output signal values for NOP instruction
   PCincr = 1'b1; // PC increments by default
   //PCabsbranch = 1'b0; 
   PCrelbranch = 1'b0;
   ALUfunc = `RADD; 
   imm=1'b0;
   w=1'b0; 
   fetch = 1'b0;
   show = 1'b0;
   addr1 = 1'b0;
   addr2 = 1'b0;
   //takeBranch =  1'b0; 
   case(opcode)
     
     `ADD: begin // register-register
	        w = 1'b1; // write result to dest register
			ALUfunc =`RADD;
	      end
     `ADDI: begin // register-immediate
	        w = 1'b1; // write result to dest register
		  imm = 1'b1; // set ctrl signal for imm operand MUX
		  ALUfunc =`RADD;
	      end
	 `MULI:begin
	        w = 1'b1; // write result to dest register
		  imm = 1'b1; // set ctrl signal for imm operand MUX
		  ALUfunc =`RMUL;
	     end
	`ADDF:begin // register-immediate
               w = 1'b1; // write result to dest register
               imm = 1'b1; // set ctrl signal for imm operand MUX
               fetch = 1'b1; // set ctrl signal for fetch inport data operand MUX
               ALUfunc = `RADD;
			   addr1 = 1'b1;
            end
	 `SHOW: begin	         
               show = 1'b1;
               ALUfunc = `RADD;
			   addr2 = 1'b1;
            end
     
      `WAIT1 :begin
	          imm = 1'b1;
			  if(readyin == 1)
			     begin
                    PCincr = 1'b0;
	                PCrelbranch = 1'b1; 
                  end	  
             end
	  `WAIT0 :begin
	           imm = 1'b1;
			   if(readyin == 0) 
			    begin
                    PCincr = 1'b0;
	                PCrelbranch = 1'b1; 
                end	             			  
             end
    `RETURN:begin
		         imm = 1'b1;
                 PCincr = 1'b0;
                 PCrelbranch = 1'b1;				 
			     //PCabsbranch=1'b1;
				 end
	 	  
	
	default:
	    $error("unimplemented opcode %h",opcode);
 
  endcase // opcode
  
  

end // always_comb


endmodule //module decoder --------------------------------