module  Fireboy ( input      Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input         w_key, a_key, d_key,
					output logic  is_Fireboy,           // Whether current pixel belongs to Fireboy
					output logic [11:0] Fireboy_address,	// return the character pixel adress for ROM inference
					output logic [3:0] Fireboy_direction	//from 0-8, denote 9 moving direction: from left to right and from top to bottom. 
              );
    
    parameter [9:0] Fireboy_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Fireboy_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Fireboy_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Fireboy_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Fireboy_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Fireboy_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Fireboy_X_Step = 10'd2;      // Step size on the X axis
	 
	 parameter [9:0] Fireboy_X_Size = 10'd30; 	// size of Fireboy on the X axis
	 parameter [9:0] Fireboy_Y_Size = 10'd30; 	// size of Fireboy on the Y axis
	 parameter [9:0] initial_motion = 10'd15; 	// the initial velocity given when jumping
    
    logic [9:0] Fireboy_X_Pos, Fireboy_X_Motion, Fireboy_Y_Pos, Fireboy_Y_Motion;
    logic [9:0] Fireboy_X_Pos_in, Fireboy_X_Motion_in, Fireboy_Y_Pos_in, Fireboy_Y_Motion_in;
	 logic [3:0] Fireboy_direction_in;
	 logic on_ground,on_ground_in;
	 logic is_Wall_up,is_Wall_down,is_Wall_left,is_Wall_right;
	 logic [9:0] x_bias_left, x_bias_right, y_bias_up, y_bias_down;
	 
	 Map Wall_up(.DrawX(Fireboy_X_Pos_in),.DrawY(Fireboy_Y_Pos_in - Fireboy_Y_Size),
						.Wall_address(),.is_Wall(is_Wall_up),.x_bias(),.y_bias(y_bias_up));
	 Map Wall_down(.DrawX(Fireboy_X_Pos_in),.DrawY(Fireboy_Y_Pos_in + Fireboy_Y_Size),
						.Wall_address(),.is_Wall(is_Wall_down),.x_bias(),.y_bias(y_bias_down));
	 Map Wall_left(.DrawX(Fireboy_X_Pos_in - Fireboy_X_Size),.DrawY(Fireboy_Y_Pos_in),
						.Wall_address(),.is_Wall(is_Wall_left),.x_bias(x_bias_left),.y_bias());
	 Map Wall_right(.DrawX(Fireboy_X_Pos_in + Fireboy_X_Size),.DrawY(Fireboy_Y_Pos_in),
						.Wall_address(),.is_Wall(is_Wall_right),.x_bias(x_bias_right),.y_bias());
	 
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
				Fireboy_direction <= 4'd4;
				on_ground <= 1'b1;
        end
        else
        begin
            Fireboy_X_Pos <= Fireboy_X_Pos_in;
            Fireboy_Y_Pos <= Fireboy_Y_Pos_in;
            Fireboy_X_Motion <= Fireboy_X_Motion_in;
            Fireboy_Y_Motion <= Fireboy_Y_Motion_in;
				Fireboy_direction <= Fireboy_direction_in;
				on_ground			<= on_ground_in;
        end
    end
	 
	 always_comb
    begin
        // By default, keep motion, position, and direction unchanged
        Fireboy_X_Pos_in = Fireboy_X_Pos;
        Fireboy_Y_Pos_in = Fireboy_Y_Pos;
        Fireboy_X_Motion_in = Fireboy_X_Motion;
        Fireboy_Y_Motion_in = Fireboy_Y_Motion;
		  Fireboy_direction_in = Fireboy_direction;
		  on_ground_in=on_ground;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				// y-axis
				if (on_ground) //on ground
					begin
						if(w_key)
							begin
								Fireboy_Y_Motion_in = (~initial_motion)+1'b1; 	//give initial velocity to Fireboy
								on_ground_in =1'b0;			//jump
							end
					end
				else //not on ground
				begin
					Fireboy_Y_Motion_in = Fireboy_Y_Motion+1'b1;	//set acceleration for Fireboy
				end
				
				// x-axis
				if (a_key && ~d_key)	//press a (left)
					begin
						Fireboy_X_Motion_in = (~(Fireboy_X_Step)+1'b1);
					end
				else if (d_key && ~a_key) // press d (right)
					begin	
						Fireboy_X_Motion_in = Fireboy_X_Step;
					end	
				else if (~d_key && ~a_key) // not press a or d (still)
					begin
						Fireboy_X_Motion_in = 10'b0;	
					end
				
//				// y-axis boundary
//				if( Fireboy_Y_Pos + Fireboy_Y_Size >= Fireboy_Y_Max && ~w_key)  // Fireboy is at the bottom edge, STOP!
//					begin
//						Fireboy_Y_Motion_in = 10'h0;  
//						on_ground_in = 1'b1;
//					end
//            else if ( Fireboy_Y_Pos <= Fireboy_Y_Min + Fireboy_Y_Size )  // Fireboy is at the top edge, Falling!
//					begin
//						Fireboy_Y_Motion_in = 10'h1;
//					end
//				
//				// x-axis boundary
//				if( Fireboy_X_Pos + Fireboy_X_Size >= Fireboy_X_Max && ~a_key) // Fireboy is at the rightest edge
//					begin
//						Fireboy_X_Motion_in = 10'h0;	
//					end
//            else if ( Fireboy_X_Pos <= Fireboy_X_Min + Fireboy_X_Size && ~d_key) // Fireboy is at the leftest edge
//					begin
//						Fireboy_X_Motion_in = 10'h0;	
//					end
				
				//decide direction by motion's signs
				if (Fireboy_X_Motion_in == 10'h0)	//x_motion = 0
					begin
						if (Fireboy_Y_Motion_in == 10'h0)
							begin
								Fireboy_direction_in=4'd4;
							end
						else if (Fireboy_Y_Motion_in[9] == 1'b0)
							begin
								Fireboy_direction_in=4'd7;
							end
						else if (Fireboy_Y_Motion_in[9] == 1'b1)
							begin
								Fireboy_direction_in=4'd1;
							end
						
					end
				else if (Fireboy_X_Motion_in[9] == 1'b0) // moving right
					begin
						if (Fireboy_Y_Motion_in == 10'h0)
							begin
								Fireboy_direction_in=4'd5;
							end
						else if (Fireboy_Y_Motion_in[9] == 1'b0)
							begin
								Fireboy_direction_in=4'd8;
							end
						else if (Fireboy_Y_Motion_in[9] == 1'b1)
							begin
								Fireboy_direction_in=4'd2;
							end
					end
				else if (Fireboy_X_Motion_in[9] == 1'b1)	// moving left
					begin
						if (Fireboy_Y_Motion_in == 10'h0)
							begin
								Fireboy_direction_in=4'd3;
							end
						else if (Fireboy_Y_Motion_in[9] == 1'b0)
							begin
								Fireboy_direction_in=4'd6;
							end
						else if (Fireboy_Y_Motion_in[9] == 1'b1)
							begin
								Fireboy_direction_in=4'd0;
							end
					end
					
				Fireboy_X_Pos_in = Fireboy_X_Pos + Fireboy_X_Motion;
            Fireboy_Y_Pos_in = Fireboy_Y_Pos + Fireboy_Y_Motion;
				
//				if (Fireboy_Y_Pos_in + Fireboy_Y_Size >= Fireboy_Y_Max)// Fireboy will reach out of bottom boundary
//					begin
//						Fireboy_Y_Pos_in = Fireboy_Y_Max+(~Fireboy_Y_Size+1'b1);  //set the position to drop on the ground perfectly
//					end
//				else if (Fireboy_Y_Pos <= Fireboy_Y_Min + Fireboy_Y_Size ) // Fireboy will reach out of top boundary
//					begin
//						Fireboy_Y_Pos_in = Fireboy_Y_Min+Fireboy_Y_Size; //set the motion in order not to go through the ceiling
//					end
				
				//y-axis
				if (is_Wall_down) 
				begin
						Fireboy_Y_Pos_in = Fireboy_Y_Pos_in - y_bias_down; //set the position to drop on the ground perfectly
						on_ground_in =1'b1;	//on ground now
				end
				else if (is_Wall_up) 
				begin
						Fireboy_Y_Pos_in = Fireboy_Y_Pos_in + y_bias_up; //set the motion in order not to go through the ceiling
						Fireboy_Y_Motion_in = 10'h0;
				end
				
				//x-axis
				if (is_Wall_left) 
				begin
						Fireboy_X_Pos_in = Fireboy_X_Pos_in + x_bias_left; //prevent from moving through the wall
				end
				else if (is_Wall_right) 
				begin
						Fireboy_X_Pos_in = Fireboy_X_Pos_in - x_bias_right; //prevent from moving through the wall
				end
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
			Fireboy_address = 9'b0; //don't care, it won't be used
	end 
endmodule