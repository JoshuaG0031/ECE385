module pool (
            input [9:0]   DrawX, DrawY,
				output logic [13:0] Fire_pool_address, Water_pool_address, Swamp_address,
            output logic  is_Fire_pool, is_Water_pool, is_Swamp
				);
	// in this module we set Fire_pool, Water_pool and Swamp
	
	// parameter for each pool (left and top)
	parameter [9:0] Fire_pool_l = 10'd300;  // 
	parameter [9:0] Fire_pool_t = 10'd455;  //
	
	parameter [9:0] Water_pool_l = 10'd405;  // 
	parameter [9:0] Water_pool_t = 10'd455;  //
	
	parameter [9:0] Swamp_l = 10'd330;  //
	parameter [9:0] Swamp_t = 10'd335;  //
	
	parameter [9:0] depth = 10'd8;  // depth of pool
	parameter [9:0] width = 10'd55; // width of pool
	
	always_comb
	begin
		is_Fire_pool = 1'b0;
		is_Water_pool = 1'b0;
		is_Swamp = 1'b0;
		
		
		if ( (DrawX >= Fire_pool_l) && (DrawX < Fire_pool_l + width) && (DrawY >= Fire_pool_t) && (DrawY < Fire_pool_t + depth))	//Fire_pool
		begin
			is_Fire_pool = 1'b1;
		end
		
		else if ( (DrawX >= Water_pool_l) && (DrawX < Water_pool_l + width) && (DrawY >= Water_pool_t) && (DrawY < Water_pool_t + depth))	//Water_pool
		begin
			is_Water_pool = 1'b1;
		end 
		
		else if ((DrawX >= Swamp_l) && (DrawX < Swamp_l + width) && (DrawY >= Swamp_t) && (DrawY < Swamp_t + depth))	//Swamp
		begin
			is_Swamp = 1'b1;
		end
		
		if (is_Fire_pool == 1'b1)	//detect the Fire_pool
			begin
				Fire_pool_address = DrawX -Fire_pool_l + (DrawY - Fire_pool_t) * width; //Fire_pool address
			end
		else if (is_Water_pool == 1'b1)	//detect the Water_pool
			begin
				Water_pool_address = DrawX -Water_pool_l + (DrawY - Water_pool_t) * width; //Water_pool address
			end
		else if (is_Swamp == 1'b1)	//detect the Swamp
			begin
				Swamp_address = DrawX - Swamp_l + (DrawY - Swamp_t) * width; //Swamp address
			end
		
		else
			begin
				Fire_pool_address = 9'b0;	
				Water_pool_address = 9'b0;	
				Swamp_address = 9'b0;	
				
				//don't care here
			end
	end
	end
	
	