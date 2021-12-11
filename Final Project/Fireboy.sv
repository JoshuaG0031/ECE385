module  Fireboy ( input      Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input         w_key, a_key, d_key,
					output logic  is_Fireboy,           // Whether current pixel belongs to Fireboy
					output logic [11:0] Fireboy_address,	// return the character pixel adress for ROM inference
					output logic [3:0] Fireboy_direction
              );
    
    parameter [9:0] Fireboy_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Fireboy_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Fireboy_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Fireboy_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Fireboy_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Fireboy_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Fireboy_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Fireboy_Y_Step = 10'd1;      // Step size on the Y axis
	 parameter [9:0] Fireboy_X_Size = 10'd30; 
	 parameter [9:0] Fireboy_Y_Size = 10'd30; 
    
    logic [9:0] Fireboy_X_Pos, Fireboy_X_Motion, Fireboy_Y_Pos, Fireboy_Y_Motion;
    logic [9:0] Fireboy_X_Pos_in, Fireboy_X_Motion_in, Fireboy_Y_Pos_in, Fireboy_Y_Motion_in;

	 // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Fireboy_X_Pos <= Fireboy_X_Center;
            Fireboy_Y_Pos <= Fireboy_Y_Center;
            Fireboy_X_Motion <= 10'd0;
            Fireboy_Y_Motion <= 10'd0;
        end
        else
        begin
            Fireboy_X_Pos <= Fireboy_X_Pos_in;
            Fireboy_Y_Pos <= Fireboy_Y_Pos_in;
            Fireboy_X_Motion <= Fireboy_X_Motion_in;
            Fireboy_Y_Motion <= Fireboy_Y_Motion_in;
        end
    end
	 
	 always_comb
    begin
        // By default, reset motion and position unchanged
        Fireboy_X_Pos_in = Fireboy_X_Pos;
        Fireboy_Y_Pos_in = Fireboy_Y_Pos;
        Fireboy_X_Motion_in = 10'd0;
        Fireboy_Y_Motion_in = 10'd0;
		  Fireboy_direction=4'd4;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				
				if (a_key&& !d_key)
					begin
						Fireboy_direction=4'd3;
						Fireboy_X_Motion_in = (~(Fireboy_X_Step)+1'b1);
					end
				if (d_key&& !a_key)
					begin
						Fireboy_direction=4'd5;	
						Fireboy_X_Motion_in = Fireboy_X_Step;
					end
				if (d_key==a_key)
					begin
						Fireboy_direction=4'd4;
					end
//				case(keycode)
//					{Nothing,A}:begin
//							Fireboy_X_Motion_in = (~(Fireboy_X_Step)+1'b1);
//							Fireboy_Y_Motion_in = 10'h0;
//							end
//					{Nothing,D}:begin
//							Fireboy_X_Motion_in = Fireboy_X_Step;
//							Fireboy_Y_Motion_in = 10'h0;
//							end
//					{Nothing,W}:begin
//							Fireboy_X_Motion_in = 10'h0;
//							Fireboy_Y_Motion_in = (~(Fireboy_Y_Step)+1'b1);
//							end
////					S:begin
////							Fireboy_X_Motion_in = 10'h0;
////							Fireboy_Y_Motion_in = Fireboy_Y_Step;
////							end
//					{W,D}:begin
//							Fireboy_X_Motion_in = (~(Fireboy_X_Step)+1'b1);
//							Fireboy_Y_Motion_in = 10'h0;
//					{D,W}:begin
//							Fireboy_X_Motion_in = (~(Fireboy_X_Step)+1'b1);
//							Fireboy_Y_Motion_in = 10'h0;
//					{W,A}:begin
//							Fireboy_X_Motion_in = (~(Fireboy_X_Step)+1'b1);
//							Fireboy_Y_Motion_in = 10'h0;
//					{A,W}:begin
//							Fireboy_X_Motion_in = (~(Fireboy_X_Step)+1'b1);
//							Fireboy_Y_Motion_in = 10'h0;
//					default:
//							begin
//							end
//				endcase
				
				if( Fireboy_Y_Pos + Fireboy_Y_Size >= Fireboy_Y_Max )  // Fireboy is at the bottom edge, STOP!
				begin
               Fireboy_Y_Motion_in = 10'h0;  // 2's complement. 
					Fireboy_X_Motion_in = 10'h0;
				end
            else if ( Fireboy_Y_Pos <= Fireboy_Y_Min + Fireboy_Y_Size )  // Fireboy is at the top edge, STOP!
				begin
               Fireboy_Y_Motion_in = 10'h0;
					Fireboy_X_Motion_in = 10'h0;
				end
            // TODO: Add other boundary detections and handle keypress here.
				else if( Fireboy_X_Pos + Fireboy_X_Size >= Fireboy_X_Max ) 
				begin
               Fireboy_X_Motion_in = 10'h0;
					Fireboy_Y_Motion_in = 10'h0;
				end
            else if ( Fireboy_X_Pos <= Fireboy_X_Min + Fireboy_X_Size )
				begin
               Fireboy_X_Motion_in = 10'h0;
					Fireboy_Y_Motion_in = 10'h0;
				end
				
				Fireboy_X_Pos_in = Fireboy_X_Pos + Fireboy_X_Motion;
            Fireboy_Y_Pos_in = Fireboy_Y_Pos + Fireboy_Y_Motion;
        end
	end
	
	int pixel_x, pixel_y;
   assign pixel_x = DrawX - Fireboy_X_Pos + Fireboy_X_Size;  // compute the address of the character
   assign pixel_y = DrawY - Fireboy_Y_Pos + Fireboy_Y_Size;
	
	
	 always_comb begin
	// figure out which pixel is a background pixel or a character pixel 
		if (pixel_x < (Fireboy_X_Size*2) && pixel_y < (Fireboy_Y_Size*2) && pixel_x >= 0 && pixel_y >= 0)
			is_Fireboy = 1'b1;
		else
			is_Fireboy = 1'b0;
			// check that it is a character
		if (is_Fireboy == 1'b1)

			//if (Fireboy_direction == 1'b1)
			// get that character address 
			// use dimensions of the character
			Fireboy_address = pixel_x + pixel_y * Fireboy_X_Size*2;
			

		else
			Fireboy_address = 9'b0;
	end 
endmodule