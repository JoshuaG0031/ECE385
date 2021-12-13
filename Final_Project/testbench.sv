module testbench();

// Half clock cycle at 50 MHz
// This is the amount of time represented by #1
timeunit 10ns;
timeprecision 1ns;

   // Internal variables
	logic Clk;
	logic Reset;

	logic       VGA_HS,      // Horizontal sync pulse.  Active low
				   VGA_VS,      // Vertical sync pulse.  Active low
				   VGA_CLK;     // 25 MHz VGA clock input
	logic       VGA_BLANK_N, // Blanking interval indicator.  Active low.
					VGA_SYNC_N;  // Composite Sync signal.  Active low.  We don't use it in this lab,
                                                        // but the video DAC on the DE2 board requires an input for it.
   logic [9:0] DrawX,       // horizontal coordinate  
					DrawY;
	

	logic         w_key, a_key, d_key;
	logic  is_Fireboy;           // Whether current pixel belongs to Fireboy
	logic [11:0] Fireboy_address;	// return the character pixel adress for ROM inference
	logic [3:0] Fireboy_direction;
	logic frame_clk_delayed, frame_clk_rising_edge;
	
	
// initialize the toplevel entity
	VGA_controller test(.Clk(Clk),.Reset(Reset),.VGA_HS(VGA_HS),.VGA_VS(VGA_VS),.VGA_CLK(VGA_CLK),.VGA_BLANK_N(VGA_BLANK_N),.VGA_SYNC_N(VGA_SYNC_N)
	,.DrawX(DrawX),.DrawY(DrawY));
	vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
	Fireboy Fireboy_test(.*,.frame_clk(VGA_VS));
	
	assign frame_clk_delayed=Fireboy_test.frame_clk_delayed; 
	assign frame_clk_rising_edge=Fireboy_test.frame_clk_rising_edge;
	// set clock rule
   always begin : CLOCK_GENERATION 
		#1 Clk = ~Clk;
   end
	
	// initialize clock signal 
	initial begin: INITIALIZATION 
		Clk = 0;
   end
	
	// begin testing
	initial begin
		Reset = 0; 
		w_key =0; 
		a_key =1;
		d_key =0;
	#60	Reset = 1; 
	#2 	Reset = 0;
	end
	 
endmodule
