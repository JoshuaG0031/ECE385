module  Fireboy ( input      Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input         w_key, a_key, d_key,
					output logic  is_Fireboy,           // Whether current pixel belongs to Fireboy
					output logic [11:0] Fireboy_address,	// return the character pixel adress for ROM inference
					output logic [3:0] Fireboy_direction,	//from 0-8, denote 9 moving direction: from left to right and from top to bottom. 
					output logic is_Wall_up,is_Wall_down,is_Wall_left,is_Wall_right,
					
					output logic  on_ground
              );
    
    parameter [9:0] Fireboy_X_Center = 10'd55;  // Center position on the X axis
    parameter [9:0] Fireboy_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Fireboy_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Fireboy_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Fireboy_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Fireboy_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Fireboy_X_Step = 10'd2;      // Step size on the X axis
	 
	 parameter [9:0] Fireboy_X_Size = 10'd15; 	// size of Fireboy on the X axis
	 parameter [9:0] Fireboy_Y_Size = 10'd20; 	// size of Fireboy on the Y axis
	 parameter [9:0] initial_motion = 10'd10; 	// the initial velocity given when jumping
    
    logic [9:0] Fireboy_X_Pos, Fireboy_X_Motion, Fireboy_Y_Pos, Fireboy_Y_Motion;
    logic [9:0] Fireboy_X_Pos_in, Fireboy_X_Motion_in, Fireboy_Y_Pos_in, Fireboy_Y_Motion_in,Fireboy_Y_Motion_in_fake;
	 logic [3:0] Fireboy_direction_in;
	 logic on_ground_in,reach_lwall_in,reach_rwall_in,reach_lwall,reach_rwall;//on_ground
	 logic [3:0] counter;
	 logic [9:0] down_position,up_position,left_position,right_position;
	 
	 logic Y_speed_action,Y_speed_action_in;
	 logic [9:0] Y_speed_store,Y_speed_store_in;
	 
	 logic [3:0] debugger_in;
	 
//	 logic is_Wall_up,is_Wall_down,is_Wall_left,is_Wall_right;
	 logic [9:0] x_bias_left, x_bias_right, y_bias_up, y_bias_down;
	 
	 Map Wall_up(.DrawX(Fireboy_X_Pos),.DrawY(up_position),
						.Wall_address(),.is_Wall(is_Wall_up));
						
	 Map Wall_down(.DrawX(Fireboy_X_Pos),.DrawY(down_position),
						.Wall_address(),.is_Wall(is_Wall_down));
						
	 Map Wall_left(.DrawX(left_position),.DrawY(Fireboy_Y_Pos),
						.Wall_address(),.is_Wall(is_Wall_left));
						
	 Map Wall_right(.DrawX(right_position),.DrawY(Fireboy_Y_Pos),
						.Wall_address(),.is_Wall(is_Wall_right));
	 
	 up_counter counter_inst(.out(counter),.reset(Reset),.clk(Clk));
	 // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
	 logic is_Wall_up_delayed,is_Wall_up_rising_edge;
	 logic is_Wall_down_delayed,is_Wall_down_rising_edge; 
	 logic is_Wall_left_delayed,is_Wall_left_rising_edge,is_Wall_left_down_edge;
	 logic is_Wall_right_delayed,is_Wall_right_rising_edge,is_Wall_right_down_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
		  
		  is_Wall_up_delayed<= is_Wall_up;
		  is_Wall_up_rising_edge<=(is_Wall_up == 1'b1) && (is_Wall_up_delayed == 1'b0);
		  
		  is_Wall_down_delayed<= is_Wall_down;
		  is_Wall_down_rising_edge<=(is_Wall_down == 1'b1) && (is_Wall_down_delayed == 1'b0);
		  
		  is_Wall_left_delayed<= is_Wall_left;
		  is_Wall_left_rising_edge<=(is_Wall_left == 1'b1) && (is_Wall_left_delayed == 1'b0);
		  is_Wall_left_down_edge<=(is_Wall_left == 1'b0) && (is_Wall_left_delayed == 1'b1);
		  
		  
		  is_Wall_right_delayed<= is_Wall_right;
		  is_Wall_right_rising_edge<=(is_Wall_right == 1'b1) && (is_Wall_right_delayed == 1'b0);
		  is_Wall_right_down_edge<=(is_Wall_right == 1'b0) && (is_Wall_right_delayed == 1'b1);
		  
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
				on_ground <= 1'b0;
				reach_lwall<=1'b0;
				reach_rwall<=1'b0;
				Y_speed_action<=1'b0;
				Y_speed_store<=1'b0;
				
        end
        else
        begin
            Fireboy_X_Pos <= Fireboy_X_Pos_in;
            Fireboy_Y_Pos <= Fireboy_Y_Pos_in;
            Fireboy_X_Motion <= Fireboy_X_Motion_in;
            Fireboy_Y_Motion <= Fireboy_Y_Motion_in;
				Fireboy_direction <= Fireboy_direction_in;
				on_ground			<= on_ground_in;
				reach_lwall <= reach_lwall_in;
				reach_rwall <= reach_rwall_in;
				Y_speed_action<=Y_speed_action_in;
				Y_speed_store<=Y_speed_store_in;
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
		  down_position = Fireboy_Y_Pos+Fireboy_Y_Size;
		  up_position = Fireboy_Y_Pos-Fireboy_Y_Size;
		  right_position = Fireboy_X_Pos+Fireboy_X_Size;
		  left_position = Fireboy_X_Pos-Fireboy_X_Size;
		  reach_lwall_in=reach_lwall;
		  reach_rwall_in=reach_rwall;
		  Y_speed_action_in=Y_speed_action;
		  Y_speed_store_in=Y_speed_store;
		  Fireboy_Y_Motion_in_fake=Fireboy_Y_Motion;
		  
		  debugger_in = 4'b0;
        
		  
		  if (frame_clk_rising_edge)
        begin
				// y-axis
				if (on_ground) //on ground
					begin
						if(w_key)
							begin
								Fireboy_Y_Motion_in = (~initial_motion)+1'b1; 	//give initial velocity to Fireboy
								Y_speed_store_in=Fireboy_Y_Motion_in;
								on_ground_in =1'b0;			//jump
							end
						if(~is_Wall_down)
							begin
								on_ground_in =1'b0; // falling
							end
					end
				else //not on ground
				begin
					if(Y_speed_action==1'b1) begin
						Fireboy_Y_Motion_in = Y_speed_store+1'b1;	//set acceleration for Fireboy
						Y_speed_action_in=1'b0;
						end
					else if (Y_speed_action==1'b0) begin
						Y_speed_store_in=Fireboy_Y_Motion;
						Fireboy_Y_Motion_in_fake=Fireboy_Y_Motion;
						Fireboy_Y_Motion_in=10'b0;
						Y_speed_action_in=1'b1;
						end
					if (Fireboy_Y_Motion_in[9]==0 && Fireboy_Y_Motion_in>initial_motion )	//Fireboy is falling and is bounded by its initial jumping velocity
						begin
							Fireboy_Y_Motion_in=initial_motion;
						end
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
				if(on_ground==1'b0 && Y_speed_action==1'b0)begin
				Fireboy_Y_Motion_in=Fireboy_Y_Motion_in_fake;
				end
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
					Fireboy_Y_Motion_in=1'b0;
					
					if (reach_rwall==1'b1 && Fireboy_X_Motion_in==Fireboy_X_Step)begin
						Fireboy_X_Motion_in=1'b0;
					end
					if (reach_lwall==1'b1 && Fireboy_X_Motion_in==~(Fireboy_X_Step)+1'b1)begin
						Fireboy_X_Motion_in=1'b0;
					end
						
					
//					if (reach_rwall=1'b1 && (Fireboy_Y_Motion_in!=0 Fireboy_X_Motion_in[9]=1'b0))begin
//						reach_rwall_in=1'b0;
					
				Fireboy_X_Pos_in = Fireboy_X_Pos + Fireboy_X_Motion;
            Fireboy_Y_Pos_in = Fireboy_Y_Pos + Fireboy_Y_Motion;
				
					
     end
		// Update position and motion only at rising edge of frame clock
			
				
				if ( Fireboy_Y_Motion[9] ==1'b0 && counter <= Fireboy_Y_Motion)  begin
					down_position = Fireboy_Y_Pos+Fireboy_Y_Size+counter;
				end
				
				if ( Fireboy_Y_Motion[9]==1'b1 && counter <= ~Fireboy_Y_Motion+1'b1)  begin
					up_position = Fireboy_Y_Pos-Fireboy_Y_Size-counter;
				end
				if (Fireboy_X_Motion[9]==1'b0 && counter <= Fireboy_X_Motion) begin
					right_position = Fireboy_X_Pos+Fireboy_X_Size+counter;
				end
				if (Fireboy_X_Motion[9]==1'b1 && counter <= ~Fireboy_X_Motion+1'b1) begin
					left_position = Fireboy_X_Pos-Fireboy_X_Size-counter;
				end
	 
				if(is_Wall_down_rising_edge==1'b1) begin
					Fireboy_Y_Pos_in = down_position-Fireboy_Y_Size;
					Fireboy_Y_Motion_in = 10'd0;
					on_ground_in=1'b1;
				end
				
				if(is_Wall_up_rising_edge==1'b1) begin
					Fireboy_Y_Pos_in = up_position+Fireboy_Y_Size;
					Fireboy_Y_Motion_in = 10'd0;
				end
				
				if(is_Wall_right_rising_edge==1'b1) begin
					Fireboy_X_Pos_in = right_position-Fireboy_X_Size;
					Fireboy_X_Motion_in = 10'd0;
					reach_rwall_in=1'b1;
				end
				
				
				if(is_Wall_left_rising_edge==1'b1) begin
					Fireboy_X_Pos_in = left_position+Fireboy_X_Size;
					Fireboy_X_Motion_in = 10'd0;
					reach_lwall_in=1'b1;
				end
				 
				if(is_Wall_left_down_edge==1'b1) begin
					reach_lwall_in=1'b0;
				end
				
				if(is_Wall_right_down_edge==1'b1) begin
					reach_rwall_in=1'b0;
				end
	 
	 
	  end
			
	 parameter [9:0] Fireboy_pic_X_Size = 10'd30; 	// size of Fireboy on the X axis
	 parameter [9:0] Fireboy_pic_Y_Size = 10'd30; 	// size of Fireboy on the Y axis			
			
	int pixel_x, pixel_y;
   assign pixel_x = DrawX - Fireboy_X_Pos + Fireboy_pic_X_Size;  // compute the address of the character
   assign pixel_y = DrawY - Fireboy_Y_Pos + Fireboy_pic_Y_Size;
	
	
	 always_comb begin
	// figure out which pixel is a background pixel or a character pixel 
		if (pixel_x < (Fireboy_pic_X_Size*2) && pixel_y < (Fireboy_pic_Y_Size*2) && pixel_x >= 0 && pixel_y >= 0)
			is_Fireboy = 1'b1;
		else
			is_Fireboy = 1'b0;
			// check that it is a character
		if (is_Fireboy == 1'b1)

			//if (Fireboy_direction == 1'b1)
			// get that character address 
			// use dimensions of the character
			Fireboy_address = pixel_x + pixel_y * Fireboy_pic_X_Size*2;
			

		else
			Fireboy_address = 9'b0; //don't care, it won't be used
	end 
endmodule