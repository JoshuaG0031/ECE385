/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  ROM
(
		parameter size = 400, addrbit = 9,
		input [addrbit-1:0] read_address,
		output logic [23:0] color_out
);

// mem has width of 1 Byte and a total of (size) addresses
logic [7:0] mem [0:size-1];

initial
begin
	 $readmemh("sprite_bytes/tetris_I.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule
