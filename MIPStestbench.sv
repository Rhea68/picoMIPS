module testpicoMIPS;
    logic clk, nreset, readyin;
    logic [7:0] x;
    logic [7:0] outport;
	
	cpu c1(.*);
	initial
		begin
		clk='0;
		nreset = '1;
 		#5ns nreset = '0;//Assert master reset (SW9=0)
 		#5ns nreset = '1;//Deassert master reset (SW9=1)
		forever #5ns clk=~clk;
		end
		
	initial
	   begin
	      readyin='0;
    #20ns readyin='1;
	      x=8'b00000101;
	#40ns readyin='0;
	
	#40ns readyin='1;
	      x=8'b11111011;
	#40ns readyin='0;//x2
	
	#120ns readyin='1;//y2
	#40ns readyin='0;//return
		end

endmodule