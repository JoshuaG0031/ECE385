module abs(
		input [9:0] dina,
		input [9:0] dinb,
		input [9:0] dout,
	);
	
assign dout = (dina > dinb)? (dina-dinb):(dinb-dina);

endmodule