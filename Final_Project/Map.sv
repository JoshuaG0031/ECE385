module Map (
            input [9:0]   DrawX, DrawY,
				output logic [13:0] Wall_address,
            output logic  is_Wall
				);
	// in this module we set Walls
	always_comb 
		begin
		is_Wall = 1'b0;
		if ( (DrawX >= 10'd0) && (DrawX < 10'd640) && (DrawY >= 10'd455) && (DrawY < 10'd480))	//bottom Wall
		begin
			is_Wall = 1'b1;
		end
		
		else if ( (DrawX >= 10'd0) && (DrawX < 10'd640) && (DrawY >= 10'd0) && (DrawY < 10'd25))	//top Wall
		begin
			is_Wall = 1'b1;
		end
		
		else if ( (DrawY >= 10'd0) && (DrawY < 10'd480) && (DrawX >= 10'd615) && (DrawX < 10'd640)) // right Wall
		begin
			is_Wall = 1'b1;
		end
		
		else if ( (DrawY >= 10'd0) && (DrawY < 10'd480) && (DrawX >= 10'd0) && (DrawX < 10'd25)) // left Wall
		begin
			is_Wall = 1'b1;
		end
		
		else if ((DrawX >= 10'd0) && (DrawX < 10'd215) && (DrawY >= 10'd391) && (DrawY < 10'd401)) 	//platform for Fireboy
		begin
			is_Wall = 1'b1;
		end
		
		else if ((DrawX >= 10'd565) && (DrawX < 10'd640) && (DrawY >= 10'd420) && (DrawY < 10'd480)) 	//test block
		begin
			is_Wall = 1'b1;
		end
		
		else if ((DrawX >= 10'd0) && (DrawX < 10'd315) && (DrawY >= 10'd325) && (DrawY < 10'd335))	//second platform
		begin
			is_Wall = 1'b1;
		end

		else if ((DrawX >= 10'd285) && (DrawX < 10'd475) && (DrawY >= 10'd335) && (DrawY < 10'd345))	//second platform
		begin
			is_Wall = 1'b1;
		end
		
		
		else if ((DrawY >= 10'd335) && (DrawY < 10'd385) && (3*DrawX+10'd250 < 5*DrawY) && (3*DrawX+10'd400 >5*DrawY))	//second platform
		begin
			is_Wall = 1'b1;
		end

		else if ((DrawX >= 10'd85) && (DrawX < 10'd375) && (DrawY >= 10'd243) && (DrawY < 10'd253))	//third platform
		begin
			is_Wall = 1'b1;
		end

		else if ((DrawX >= 10'd345) && (DrawX < 10'd640) && (DrawY >= 10'd253) && (DrawY < 10'd263))	//third platform
		begin
			is_Wall = 1'b1;
		end

		else if ((DrawX >= 10'd0) && (DrawX < 10'd555) && (DrawY >= 10'd172) && (DrawY < 10'd182))	//fourth platform
		begin
			is_Wall = 1'b1;
		end

		else if ((DrawX >= 10'd0) && (DrawX < 10'd107) && (DrawY >= 10'd107) && (DrawY < 10'd172))	//block
		begin
			is_Wall = 1'b1;
		end

		else if ((DrawX >= 10'd150) && (DrawX < 10'd640) && (DrawY >= 10'd90) && (DrawY < 10'd100))	//block
		begin
			is_Wall = 1'b1;
		end

		else
		begin
			is_Wall = 1'b0;
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
