
`include "alucodes.sv"
module cpu #( parameter n = 8,Psize = 5) // data bus width
(input logic clk,  
  input logic nreset, // master reset
   input  logic readyin, // Branch status
  input  logic[n-1:0] x, // connected to switches

  output logic[n-1:0] outport // need an output port, tentatively this will be the ALU output
);       

// declarations of local signals that connect CPU modules
// ALU
logic  ALUfunc; // ALU function

logic imm; // immediate operand signal
logic [n-1:0] b; // output from imm MUX
//
logic fetch;
logic show;
logic addr1,addr2;
logic [n-1:0] Rdata1, Rdata2, Wdata; // Register data
logic w; // register write control

logic PCincr,PCrelbranch; // program counter control
logic [Psize-1 : 0]ProgAddress;
// Program Memory
parameter Isize = n+7; // Isize - instruction width
logic [Isize-1:0] I; // I - instruction code

//------------- code starts here ---------
// module instantiations
pc  #(.Psize(Psize)) progCounter (
        .clk(clk),
        .nreset(nreset),
        .PCincr(PCincr),
       // .PCabsbranch(PCabsbranch),
        .PCrelbranch(PCrelbranch),
        .Branchaddr(I[Psize-1:0]), 
        .PCout(ProgAddress));

prog #(.Psize(Psize),.Isize(Isize)) 
      progMemory (.address(ProgAddress),.I(I));

decoder  D (.opcode(I[Isize-1:Isize-3]),
            .PCincr(PCincr),		
           // .PCabsbranch(PCabsbranch), 
            .PCrelbranch(PCrelbranch),
			.readyin(readyin),
			.show(show),
			.addr1(addr1),
			.addr2(addr2),
		    .ALUfunc(ALUfunc),
		    .imm(imm),
		    .fetch(fetch),
		    .w(w));

regs   #(.n(n))  gpr(
        .clk(clk),
		.w(w),
        .Wdata(Wdata),
		.fetch(fetch),
		.addr1(addr1),
		.addr2(addr2),
		.Raddr1(I[Isize-4:Isize-5]),  // reg %d number
		.Raddr2(I[Isize-6:Isize-7]), // reg %s number
        .Rdata1(Rdata1),
		.Rdata2(Rdata2));
		

alu    #(.n(n))  iu(
       .a(Rdata1),
	   .b(b),
       .ALUfunc(ALUfunc),
       .result(Wdata)); // ALU result -> destination reg

// create MUX for immediate operand
assign b = (imm ? (fetch ? x[n-1:0] : I[n-1:0]) : Rdata2);

always_ff @(posedge clk or negedge nreset)
begin
	if (!nreset) // sync reset
                outport <= 8'd0;
	else if(show)
                outport <= Wdata;
end

endmodule