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
	 //Fireboy images
	 logic [23:0] pixel_color_Fireboy_still,pixel_color_Fireboy_left,pixel_color_Fireboy_right,
						pixel_color_Fireboy_up,pixel_color_Fireboy_down,pixel_color_Fireboy_ru,
						pixel_color_Fireboy_rd,pixel_color_Fireboy_lu,pixel_color_Fireboy_ld;
    logic [23:0] pixel_color;
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
		  pixel_color = 24'hffffff; //background color
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
					pixel_color = 24'hffffff;
			end
			Red = pixel_color[23:16];
			Green = pixel_color[15:8];
			Blue = pixel_color[7:0];
	 end 
    
endmodule
