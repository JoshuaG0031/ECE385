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
logic [23:0] palette [15:0];
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
assign palette[11] = 24'hAAA793;
assign palette[12] = 24'h5C5A4A;
assign palette[13] = 24'h998C6E;
assign palette[14] = 24'h946C67;
assign palette[15] = 24'hD4CBAF;
assign pixel_color = palette[ram[read_address]];

initial
begin
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_still.txt",ram);
end

endmodule


module Fireboy_up
(
                input [11:0] read_address,
                output logic [23:0] pixel_color
);

logic [3:0] ram [0:3599];
logic [23:0] palette [15:0];
assign palette[0] = 24'h800080;
assign palette[1] = 24'h000000;
assign palette[2] = 24'hF21D08;
assign palette[3] = 24'h5F180C;
assign palette[4] = 24'h9C140C;
assign palette[5] = 24'hEF4B0F;
assign palette[6] = 24'h2D0D06;
assign palette[7] = 24'h975125;
assign palette[8] = 24'hFAF7F1;
assign palette[9] = 24'hACA194;
assign palette[10] = 24'h694A2A;
assign palette[11] = 24'hA28C70;
assign palette[12] = 24'h966964;
assign palette[13] = 24'h876D58;
assign palette[14] = 24'h661F1D;
assign palette[15] = 24'h624A37;
assign pixel_color = palette[ram[read_address]];

initial
begin
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_up.txt",ram);
end

endmodule


module Fireboy_left
(
                input [11:0] read_address,
                output logic [23:0] pixel_color
);

logic [3:0] ram [0:3599];
logic [23:0] palette [15:0];
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
assign palette[11] = 24'h8F7063;
assign palette[12] = 24'hB1A897;
assign palette[13] = 24'h8E6E57;
assign palette[14] = 24'hEEDD18;
assign palette[15] = 24'h6B5D60;
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
logic [23:0] palette [15:0];
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
assign palette[10] = 24'hABA395;
assign palette[11] = 24'hA19673;
assign palette[12] = 24'h926D63;
assign palette[13] = 24'h735D60;
assign palette[14] = 24'hD4CDA9;
assign palette[15] = 24'h9A6B4F;
assign pixel_color = palette[ram[read_address]];

initial
begin
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_right.txt",ram);
end

endmodule


module Fireboy_ld
(
                input [11:0] read_address,
                output logic [23:0] pixel_color
);

logic [3:0] ram [0:3599];
logic [23:0] palette [15:0];
assign palette[0] = 24'h800080;
assign palette[1] = 24'h000000;
assign palette[2] = 24'hF31A09;
assign palette[3] = 24'h601B0E;
assign palette[4] = 24'hEF4D0D;
assign palette[5] = 24'h9B1A0B;
assign palette[6] = 24'h2F160A;
assign palette[7] = 24'hFAF8F2;
assign palette[8] = 24'h965523;
assign palette[9] = 24'h6F4C2F;
assign palette[10] = 24'hA58E71;
assign palette[11] = 24'h967355;
assign palette[12] = 24'hB3A79C;
assign palette[13] = 24'hAD9A6D;
assign palette[14] = 24'h686249;
assign palette[15] = 24'h746A5C;
assign pixel_color = palette[ram[read_address]];

initial
begin
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_ld.txt",ram);
end

endmodule

module Fireboy_lu
(
                input [11:0] read_address,
                output logic [23:0] pixel_color
);

logic [3:0] ram [0:3599];
logic [23:0] palette [15:0];
assign palette[0] = 24'h800080;
assign palette[1] = 24'h000000;
assign palette[2] = 24'hF4220E;
assign palette[3] = 24'hF0511A;
assign palette[4] = 24'h5B1F11;
assign palette[5] = 24'hA22511;
assign palette[6] = 24'h2A1309;
assign palette[7] = 24'h9C5F50;
assign palette[8] = 24'h974F23;
assign palette[9] = 24'h684C27;
assign palette[10] = 24'hF9FBF4;
assign palette[11] = 24'h906B4D;
assign palette[12] = 24'h937258;
assign palette[13] = 24'hADA694;
assign palette[14] = 24'hCAAFA3;
assign palette[15] = 24'h9E8B6B;
assign pixel_color = palette[ram[read_address]];

initial
begin
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_lu.txt",ram);
end

endmodule

module Fireboy_rd
(
                input [11:0] read_address,
                output logic [23:0] pixel_color
);

logic [3:0] ram [0:3599];
logic [23:0] palette [15:0];
assign palette[0] = 24'h800080;
assign palette[1] = 24'h000000;
assign palette[2] = 24'hF21B09;
assign palette[3] = 24'h601A0E;
assign palette[4] = 24'hF04E0D;
assign palette[5] = 24'h9B180B;
assign palette[6] = 24'h2F1509;
assign palette[7] = 24'h9A501E;
assign palette[8] = 24'hF7F6F0;
assign palette[9] = 24'h6F4D2B;
assign palette[10] = 24'h937153;
assign palette[11] = 24'h6D644D;
assign palette[12] = 24'hD3B69C;
assign palette[13] = 24'h9F8E6D;
assign palette[14] = 24'hA5855D;
assign palette[15] = 24'hF2D314;
assign pixel_color = palette[ram[read_address]];

initial
begin
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_rd.txt",ram);
end

endmodule

module Fireboy_ru
(
                input [11:0] read_address,
                output logic [23:0] pixel_color
);

logic [3:0] ram [0:3599];
logic [23:0] palette [15:0];
assign palette[0] = 24'h800080;
assign palette[1] = 24'h000000;
assign palette[2] = 24'hF3220E;
assign palette[3] = 24'hEF511A;
assign palette[4] = 24'h5B1F10;
assign palette[5] = 24'h2B1309;
assign palette[6] = 24'h9F2412;
assign palette[7] = 24'h9D6051;
assign palette[8] = 24'h9E4F24;
assign palette[9] = 24'hF4F1EE;
assign palette[10] = 24'h6D4E26;
assign palette[11] = 24'h99745A;
assign palette[12] = 24'h956C4B;
assign palette[13] = 24'hB2A691;
assign palette[14] = 24'h9B8D63;
assign palette[15] = 24'hAD9576;
assign pixel_color = palette[ram[read_address]];

initial
begin
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_ru.txt",ram);
end

endmodule

module Fireboy_down
(
                input [11:0] read_address,
                output logic [23:0] pixel_color
);

logic [3:0] ram [0:3599];
logic [23:0] palette [15:0];
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
assign palette[11] = 24'hAAA793;
assign palette[12] = 24'h5C5A4A;
assign palette[13] = 24'h998C6E;
assign palette[14] = 24'h946C67;
assign palette[15] = 24'hD4CBAF;
assign pixel_color = palette[ram[read_address]];

initial
begin
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Fireboy_down.txt",ram);
end

endmodule

module Wall
(
                input [13:0] read_address,
                output logic [23:0] pixel_color
);

logic [3:0] ram [0:12495];
logic [23:0] palette [15:0];
assign palette[0] = 24'h800080;
assign palette[1] = 24'h616121;
assign palette[2] = 24'h6E682E;
assign palette[3] = 24'h13290B;
assign palette[4] = 24'h185214;
assign palette[5] = 24'h6F6C47;
assign palette[6] = 24'h1A8B1A;
assign palette[7] = 24'h836D33;
assign palette[8] = 24'h856A50;
assign palette[9] = 24'h43391D;
assign palette[10] = 24'h619857;
assign palette[11] = 24'h32944A;
assign palette[12] = 24'h57892E;
assign palette[13] = 24'h386842;
assign palette[14] = 24'h868147;
assign palette[15] = 24'h80803E;
assign pixel_color = palette[ram[read_address]];

initial
begin
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Wall.txt",ram);
end

endmodule

module Background
(
                input [12:0] read_address,
                output logic [23:0] pixel_color
);

logic [3:0] ram [0:5624];
logic [23:0] palette [4:0];
assign palette[0] = 24'h800080;
assign palette[1] = 24'h292B09;
assign palette[2] = 24'h2E300D;
assign palette[3] = 24'h1E2000;
assign palette[4] = 24'h1D1F00;
assign pixel_color = palette[ram[read_address]];

initial
begin
        $readmemh("../PNG_To_Hex/On-Chip_Memory/sprite_bytes/Background.txt",ram);
end

endmodule

