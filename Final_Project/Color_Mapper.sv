//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              is_Fireboy, is_Watergirl, is_Wall ,
							  input 					is_Fire_pool, is_Water_pool, is_Swamp,
							  input 			[3:0] Fireboy_direction,Watergirl_direction,
							  input        [11:0]Fireboy_address,Watergirl_address,
							  input			[13:0]Wall_address,
							  input        [8:0] Fire_pool_address, Water_pool_address, Swamp_address,
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
	 //background and wall images
	 logic [23:0] pixel_color_Background, pixel_color_Wall;
	 //pool images
	 logic [23:0] pixel_color_Fire_pool, pixel_color_Water_pool, pixel_color_Swamp;
	 
	 //Fireboy images
	 logic [23:0] pixel_color_Fireboy_still,pixel_color_Fireboy_left,pixel_color_Fireboy_right,
						pixel_color_Fireboy_up,pixel_color_Fireboy_down,pixel_color_Fireboy_ru,
						pixel_color_Fireboy_rd,pixel_color_Fireboy_lu,pixel_color_Fireboy_ld;
    logic [23:0] pixel_color;
	 //background and wall modules
	 Background Background(.read_address((DrawX % 75) + (DrawY % 75) * 75),.pixel_color(pixel_color_Background));
	 Wall Wall(.read_address(Wall_address),.pixel_color(pixel_color_Wall));
	 
	 //pool modules
	 Fire_pool Fire_pool(.read_address(Fire_pool_address),.pixel_color(pixel_color_Fire_pool));
	 Water_pool Water_pool(.read_address(Water_pool_address),.pixel_color(pixel_color_Water_pool));
	 Swamp Swamp(.read_address(Swamp_address),.pixel_color(pixel_color_Swamp));
	 

	 //sprite modules
	 Fireboy_still Fireboy_still(.read_address(Fireboy_address),.pixel_color(pixel_color_Fireboy_still));
	 Fireboy_left Fireboy_left(.read_address(Fireboy_address),.pixel_color(pixel_color_Fireboy_left));
	 Fireboy_right Fireboy_right(.read_address(Fireboy_address),.pixel_color(pixel_color_Fireboy_right));
	 Fireboy_up Fireboy_up(.read_address(Fireboy_address),.pixel_color(pixel_color_Fireboy_up));
	 Fireboy_down Fireboy_down(.read_address(Fireboy_address),.pixel_color(pixel_color_Fireboy_down));
	 Fireboy_ru Fireboy_ru(.read_address(Fireboy_address),.pixel_color(pixel_color_Fireboy_ru));
	 Fireboy_rd Fireboy_rd(.read_address(Fireboy_address),.pixel_color(pixel_color_Fireboy_rd));
	 Fireboy_lu Fireboy_lu(.read_address(Fireboy_address),.pixel_color(pixel_color_Fireboy_lu));
	 Fireboy_ld Fireboy_ld(.read_address(Fireboy_address),.pixel_color(pixel_color_Fireboy_ld));
	 
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_Fireboy signal
    always_comb
    begin
		  pixel_color = pixel_color_Background; //background color
		  if (is_Fireboy) 
        begin
				case(Fireboy_direction)
					4'd0:begin
						pixel_color=pixel_color_Fireboy_lu;
						end
					4'd1:begin
						pixel_color=pixel_color_Fireboy_up;
						end
					4'd2:begin
						pixel_color=pixel_color_Fireboy_ru;
						end
					4'd3:begin
						pixel_color=pixel_color_Fireboy_left;
						end
					4'd4:begin
						pixel_color=pixel_color_Fireboy_still;
						end
					4'd5:begin
						pixel_color=pixel_color_Fireboy_right;
						end
					4'd6:begin
						pixel_color=pixel_color_Fireboy_ld;
						end
					4'd7:begin
						pixel_color=pixel_color_Fireboy_down;
						end
					4'd8:begin
						pixel_color=pixel_color_Fireboy_rd;
						end
					default:
						begin
						end
				endcase		
			if (pixel_color == 24'h800080)
				pixel_color = pixel_color_Background;
			end
			
			if (is_Wall) 
			begin
				pixel_color=pixel_color_Wall;
			end
			
			if (is_Fire_pool)
			begin
				pixel_color=pixel_color_Fire_pool;
			end
			
			if (is_Water_pool)
			begin
				pixel_color=pixel_color_Water_pool;
			end
			
			if (is_Swamp)
			begin
				pixel_color=pixel_color_Swamp;
			end
			
			Red = pixel_color[23:16];
			Green = pixel_color[15:8];
			Blue = pixel_color[7:0];
	 end 
    
endmodule
