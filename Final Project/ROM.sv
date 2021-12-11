/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

//module  ROM
//(
//		parameter size = 400, addrbit = 9,
//		input [addrbit-1:0] read_address,
//		output logic [23:0] color_out
//);
//
//// mem has width of 1 Byte and a total of (size) addresses
//logic [7:0] mem [0:size-1];
//
//initial
//begin
//	 $readmemh("sprite_bytes/tetris_I.txt", mem);
//end
//
//
//always_ff @ (posedge Clk) begin
//	if (we)
//		mem[write_address] <= data_In;
//	data_Out<= mem[read_address];
//end
//
//endmodule


module  Fireboy_still
(
		input [11:0] read_address,
		output logic [23:0] pixel_color
);

// ram has width of 3 bits and a total of 400 addresses
logic [3:0] ram [0:3599];

logic [23:0] palette [10:0];
assign palette[0] = 24'h800080;
assign palette[1] = 24'h000000;
assign palette[2] = 24'hEF2108;
assign palette[3] = 24'h61180C;
assign palette[4] = 24'h9E1609;
assign palette[5] = 24'hF84809;
assign palette[6] = 24'hF9F9F3;
assign palette[7] = 24'h2C1007;
assign palette[8] = 24'hA15427;
assign palette[9] = 24'h6B4E2A;
assign palette[10] = 24'h936450;
//'0x800080', '0x000000', '0xEF2108', '0x61180C', '0x9E1609', '0xF84809', '0xF9F9F3', '0x2C1007', '0xA15427', '0x6B4E2A', '0x936450'
assign pixel_color = palette[ram[read_address]];

initial
begin
	 $readmemh("C:/Users/moyang.19/Documents/GitHub/ECE385/PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_still.txt", ram);
end

endmodule






module  Fireboy_left
(
		input [11:0] read_address,
		output logic [23:0] pixel_color
);

// ram has width of 3 bits and a total of 400 addresses
logic [3:0] ram [0:3599];

logic [23:0] palette [10:0];
assign palette[0] = 24'h800080;
assign palette[1] = 24'h000000;
assign palette[2] = 24'hF51C07;
assign palette[3] = 24'h5D1B10;
assign palette[4] = 24'hF04C0E;
assign palette[5] = 24'h9C170C;
assign palette[6] = 24'h321409;
assign palette[7] = 24'h994E22;
assign palette[8] = 24'hF7F7F5;
assign palette[9] = 24'h704A2F;
assign palette[10] = 24'hA39171;
assign pixel_color = palette[ram[read_address]];

initial
begin
	 $readmemh("C:/Users/moyang.19/Documents/GitHub/ECE385/PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_left.txt", ram);
end

endmodule






module  Fireboy_right
(
		input [11:0] read_address,
		output logic [23:0] pixel_color
);

// ram has width of 3 bits and a total of 400 addresses
logic [3:0] ram [0:3599];

logic [23:0] palette [10:0];
assign palette[0] = 24'h800080;
assign palette[1] = 24'h000000;
assign palette[2] = 24'hF61B07;
assign palette[3] = 24'h5E1B10;
assign palette[4] = 24'hF04B0D;
assign palette[5] = 24'hA11A0D;
assign palette[6] = 24'h311307;
assign palette[7] = 24'hFAF9F3;
assign palette[8] = 24'hA04D25;
assign palette[9] = 24'h6E4A2C;
assign palette[10] = 24'hA19673;
//'0x800080', '0x000000', '0xEF2108', '0x61180C', '0x9E1609', '0xF84809', '0xF9F9F3', '0x2C1007', '0xA15427', '0x6B4E2A', '0x936450'
assign pixel_color = palette[ram[read_address]];

initial
begin
	 $readmemh("C:/Users/moyang.19/Documents/GitHub/ECE385/PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_right.txt", ram);
end

endmodule