module testbench();

// Half clock cycle at 50 MHz
// This is the amount of time represented by #1
timeunit 10ns;
timeprecision 1ns;

   // Internal variables
	logic Clk;
	logic Reset;
	logic frame_clk;
	logic [9:0] DrawX, DrawY;
	logic w_key, a_key, d_key;
	logic is_Fireboy;
	logic [11:0] Fireboy_address;
	logic [3:0] Fireboy_direction;
	
	// initialize the toplevel entity
	Fireboy test(.*);
	
	// set clock rule
   always begin : CLOCK_GENERATION 
		#1 Clk = ~Clk;
   end
	
	always begin : frame_clk_GENERATION 
		#88 frame_clk = ~frame_clk;
   end
	
	// initialize clock signal 
	initial begin: INITIALIZATION 
		Clk = 0;
   end
	
	// begin testing
	initial begin
		Reset = 0; 
		DrawX = 9'b0;
		DrawY = 9'b0;
		w_key = 1'b0; 
		a_key = 1'b0;
		d_key = 1'b0;
	#2	Reset = 1; 
	#2 Reset = 0; 		
#30	w_key = 1;
#30   w_key = 0;
		d_key = 1;
#30   d_key = 0;
		a_key = 1;
	end
	 
endmodule
