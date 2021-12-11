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
module  color_mapper ( input              is_Fireboy, is_Watergirl,         
							  input 			[3:0] Fireboy_direction,Watergirl_direction,
							  input        [11:0]Fireboy_address,Watergirl_address,
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
	 logic [23:0] pixel_color_Fireboy_still,pixel_color_Fireboy_left,pixel_color_Fireboy_right;
    logic [23:0] pixel_color;
	 //sprite modules
	 Fireboy_still Fireboy_still(.read_address(Fireboy_address),.pixel_color(pixel_color_Fireboy_still));
	 Fireboy_left Fireboy_left(.read_address(Fireboy_address),.pixel_color(pixel_color_Fireboy_left));
	 Fireboy_right Fireboy_right(.read_address(Fireboy_address),.pixel_color(pixel_color_Fireboy_right));
	 
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_Fireboy signal
    always_comb
    begin
        Red = 8'hff; 
        Green = 8'hff;
        Blue = 8'hff;
		  pixel_color = 24'd0;
		  
		  
		  if (is_Fireboy == 1'b1) 
        begin
				case(Fireboy_direction)
					4'd4:begin
						pixel_color=pixel_color_Fireboy_still;
						end
					4'd3:begin
						pixel_color=pixel_color_Fireboy_left;
						end
					4'd5:begin
						pixel_color=pixel_color_Fireboy_right;
						end
					default:
						begin
						end
				endcase
			Red = pixel_color[23:16];
			Green = pixel_color[15:8];
			Blue = pixel_color[7:0];
		  end

	 end 
    
endmodule
