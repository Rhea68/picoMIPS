module top(
  input logic fastclk,  // 50MHz Altera DE0 clock
  input logic [7:0] SW, 
  input logic nreset,
  input logic readyin,
  output logic [7:0] LED); // LEDs
  
  logic clk; // slow clock, about 10Hz
  
  counter c (.fastclk(fastclk),.clk(clk)); // slow clk from counter
  
  
  cpu c0 (.clk(clk),.readyin(readyin), .nreset(nreset),.x(SW),.outport(LED));
  
endmodule  