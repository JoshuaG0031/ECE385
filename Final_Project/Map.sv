module Map (
            input [9:0]   DrawX, DrawY,
				output logic [13:0] Wall_address,
            output logic  is_Wall,
				output [9:0]  x_bias, y_bias
				);
	// in this module we set Walls
	always_comb 
		begin
		is_Wall = 1'b0;
		x_bias = 10'b0;
		y_bias = 10'b0;	//by default
		
		if ( (DrawX >= 10'd0) && (DrawX < 10'd640) && (DrawY >= 10'd455) )	//bottom Wall
		begin
			is_Wall = 1'b1;
			y_bias = 10'd455;
		end
		
		else if ( (DrawX >= 10'd0) && (DrawX < 10'd640) && (DrawY < 10'd25))	//top Wall
		begin
			is_Wall = 1'b1;
			y_bias = 10'd25;
		end
		
		else if ( (DrawY >= 10'd0) && (DrawY < 10'd480) && (DrawX >= 10'd615)) // right Wall
		begin
			is_Wall = 1'b1;
			x_bias = 10'd615;
		end
		
		else if ( (DrawY >= 10'd0) && (DrawY < 10'd480) && (DrawX < 10'd25)) // left Wall
		begin
			is_Wall = 1'b1;
			x_bias = 10'd25;
		end
		
		else if ((DrawX >= 10'd0) && (DrawX < 10'd215) && (DrawY >= 10'd391) && (DrawY < 10'd411)) 	//platform for Fireboy
		begin
			is_Wall = 1'b1;
			y_bias = 10'd391;
		end
		
		else if ((DrawX >= 10'd565) && (DrawX < 10'd640) && (DrawY >= 10'd420) && (DrawY < 10'd480)) 	//test block
		begin
			is_Wall = 1'b1;
			x_bias = 10'd565;
			y_bias = 10'd420;
		end
		
		else
		begin
			is_Wall = 1'b0;
			x_bias = 10'b0;
			y_bias = 10'b0;
		end
		
		if (is_Wall == 1'b1)	//detect the Wall
			begin
				Wall_address = (DrawX % 176) + (DrawY % 71) * 176; //tile address
			end
		else
			begin
				Wall_address = 9'b0;	//don't care here
			end
	end
endmodule
