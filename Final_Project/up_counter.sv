module up_counter(
output logic [3:0] out,
input logic clk,
input logic reset,
input logic [3:0] up_bound
);

always_ff @ (posedge clk) begin
	if (reset) out<= 4'b0;
	else if (out > up_bound) out <= 4'b0;	
	else   out<= out + 1;
end
endmodule