//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [7:0]  LEDG,
				 output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6,HEX7, 
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,      //SDRAM Clock
											
				 output logic [22:0] FL_ADDR, // Flash memory Address - bit0 is signa to grab lower/upper byte
				 input  logic [7:0]  FL_DQ,   
				 output logic        FL_OE_N, FL_RST_N, FL_WE_N, FL_CE_N,FL_WP_N,
				 output logic        AUD_DACDAT, AUD_XCK, I2C_SCLK,AUD_DACLRCK, AUD_BCLK,
				 inout  wire         I2C_SDAT
             );
    
    logic Reset_h, Clk;
    logic [47:0] keycode;
	 logic [9:0] DrawX,DrawY;
	 logic is_ball;
	 logic [7:0] led;
    logic w_key, a_key, d_key, arrow_up, arrow_left, arrow_right;
	 logic  debugger; 
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
		  LEDG <= led;
	 end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 
	 logic [11:0] Fireboy_address,Watergirl_address;
	 logic [8:0] Fire_pool_address, Water_pool_address, Swamp_address;
	 logic [3:0] Fireboy_direction,Watergirl_direction;
	 
	 logic is_Fireboy, is_Watergirl, is_Wall;
	 logic is_Fire_pool, is_Water_pool, is_Swamp;
	 
	 //fireboy is wall
	 logic is_Wall_up,is_Wall_down,is_Wall_left,is_Wall_right;
    
	 
	 logic [13:0] Wall_address;
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(1'b0),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode1_export(keycode[7:0]), 
									  .keycode2_export(keycode[15:8]),
									  .keycode3_export(keycode[23:16]), 
									  .keycode4_export(keycode[31:24]),
									  .keycode5_export(keycode[39:32]),
									  .keycode6_export(keycode[47:40]),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(
														.Clk(Clk),
														.Reset(Reset_h),
														.VGA_HS(VGA_HS),
														.VGA_VS(VGA_VS),
														.VGA_CLK(VGA_CLK),
                                          .VGA_BLANK_N(VGA_BLANK_N),
                                          .VGA_SYNC_N(VGA_SYNC_N),
                                          .DrawX(DrawX),
                                          .DrawY(DrawY)
														);
    
    // Which signal should be frame_clk?
    Fireboy Fireboy(
								.Clk(Clk),
                        .Reset(Reset_h),
                        .frame_clk(VGA_VS),
                        .w_key(w_key), .a_key(a_key), .d_key(d_key),
                        .DrawX(DrawX),
                        .DrawY(DrawY),
                        .is_Fireboy(is_Fireboy),
								.Fireboy_address(Fireboy_address),
								.Fireboy_direction(Fireboy_direction),
								.is_Wall_up(is_Wall_up),.is_Wall_down(is_Wall_down),.is_Wall_left(is_Wall_left),.is_Wall_right(is_Wall_right),
								.on_ground(debugger)
								);
    
	 pool pool(.DrawX(DrawX),.DrawY(DrawY),.Fire_pool_address(Fire_pool_address),.is_Fire_pool(is_Fire_pool)
	 .Water_pool_address(Water_pool_address),.is_Water_pool(is_Water_pool),
	 .Swamp_address(Swamp_address),.is_Swamp(is_Swamp)
	 );
	 
	 Map Map(.DrawX(DrawX),.DrawY(DrawY),.Wall_address(Wall_address),.is_Wall(is_Wall));
	 
    color_mapper color_instance(
										  .is_Fireboy(is_Fireboy),
										  .is_Watergirl(is_Watergirl),
										  .is_Wall(is_Wall),
										  .Fireboy_direction(Fireboy_direction),.Watergirl_direction(Watergirl_direction),
										  .Fireboy_address(Fireboy_address),.Watergirl_address(Watergirl_address),
                                .Wall_address(Wall_address),
										  .DrawX(DrawX),
                                .DrawY(DrawY),
                                .VGA_R(VGA_R),
                                .VGA_G(VGA_G),
                                .VGA_B(VGA_B),
										  .*
										  );
//    AudioController AC(.CLK(CLOCK_50),.Reset(~Reset_h),.FL_ADDR(FL_ADDR),.FL_DQ(FL_DQ),.FL_OE_N(FL_OE_N),.FL_WP_N(FL_WP_N),
//							  .FL_RST_N(FL_RET_N),.FL_WE_N(FL_WE_N),.FL_CE_N(FL_CE_N),.AUD_DACLRCK(AUD_DACLRCK),.AUD_BCLK(AUD_BCLK),
//							  .AUD_DACDAT(AUD_DACDAT),.AUD_XCK(AUD_XCK),.I2C_SCLK(I2C_SCLK),.I2C_SDAT(I2C_SDAT));
							  
	 keycode_reader keycode_reader(.*);
	 
    //Display keycode on hex display
	 assign led[3:0]=Fireboy_direction[3:0];
	 assign led[7]=is_Wall_up;
	 assign led[6]=is_Wall_down;
	 assign led[5]=is_Wall_left;
	 assign led[4]=is_Wall_right;
    HexDriver hex_inst_0 ({1'b0,w_key, a_key, d_key}, HEX6);
	 HexDriver hex_inst_1 ({1'b0,arrow_up, arrow_left, arrow_right}, HEX7);
	 HexDriver hex_inst_2 (debugger,HEX0);
//	 HexDriver hex_inst_1 (keycode[43:40], HEX6);
//    HexDriver hex_inst_2 (keycode[47:44], HEX7);
	 
	 
	 /*
	 always_comb
    begin
	   led = 8'b0000;
		case(keycode)
					16'h04: begin
								led = 8'b0010;
							 end
					16'h07: begin
								led = 8'b0001;
							 end
					16'h1a: begin
								led = 8'b1000;
							 end
					16'h16: begin
								led = 8'b0100;
							 end
		endcase
    end
    */
	 
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
