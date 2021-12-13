/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module Fireboy_still
(
                input [11:0] read_address,
                output logic [23:0] pixel_color
);

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
assign pixel_color = palette[ram[read_address]];

initial
begin
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_still.txt",ram);
end

endmodule

module Fireboy_left
(
                input [11:0] read_address,
                output logic [23:0] pixel_color
);

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
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_left.txt",ram);
end

endmodule

module Fireboy_right
(
                input [11:0] read_address,
                output logic [23:0] pixel_color
);

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
assign pixel_color = palette[ram[read_address]];

initial
begin
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_right.txt",ram);
end

endmodule

