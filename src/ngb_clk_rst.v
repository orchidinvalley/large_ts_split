`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:24 05/20/2009 
// Design Name: 
// Module Name:    ngb_clk_rst 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ngb_clk_rst(

	clk_in,
	reset,
	
	clk_200,
	clk_125,
	rst_125,
	
	clk_main,
	rst_gen,
	
	clk_27,
	rst_27,
	
	clk_100,
	rst_100
    );
    
    input			clk_in;
    input			reset;
    
    output			clk_200;
    output			clk_125;
    output			rst_125;
    output			clk_main;
    output			rst_gen;
    
    output			clk_27;
    output			rst_27;
    
    output			clk_100;
    output			rst_100;
    
    reg				rst;
    reg				rst_r;
    reg				rst_in;
    reg		[7:0]	clk_cnt;
    
    reg		[5:0]	rst_gen_pre	;
    reg				rst_gen		;
	reg		[5:0]	rst_27_pre	;
    reg				rst_27;
    reg				rst_100;
    reg		[5:0]	rst_125_pre	;
    reg				rst_125		;
    
    wire			clk_200_buf;
    wire			clk_125_buf;
    wire			clk_main_buf;
    wire			clk_27_buf;
    wire			clk_100_buf;
    
    wire			rst_lock;
    wire			clkfb;
    
    
    

   
//      MMCM_ADV #
//    (
//         .COMPENSATION      ("ZHOLD"),
//         .CLKFBOUT_MULT_F   (10),
//         .DIVCLK_DIVIDE     (1),
//         .CLKFBOUT_PHASE    (0),
//         
//         .CLKIN1_PERIOD     (10),
//         .CLKIN2_PERIOD     (10),   //Not used
//         
//         .CLKOUT0_DIVIDE_F  (8),
//         .CLKOUT0_PHASE     (0),
//         
//         .CLKOUT1_DIVIDE    (5),
//         .CLKOUT1_PHASE     (0),
//
//         .CLKOUT2_DIVIDE    (6),
//         .CLKOUT2_PHASE     (0),
//         
//         .CLKOUT3_DIVIDE    (50),
//         .CLKOUT3_PHASE     (0),
//         
//         .CLKOUT4_DIVIDE    (10),
//         .CLKOUT4_PHASE     (0)           
//    )
//    mmcm_adv_i   
//    (
//         .CLKIN1            (clk_in),
//         .CLKIN2            (1'b0),
//         .CLKINSEL          (1'b1),
//         .CLKFBIN           (clkfb),
//         .CLKOUT0           (clk_125_buf),
//         .CLKOUT0B          (),
//         .CLKOUT1           (clk_200_buf),
//         .CLKOUT1B          (),         
//         .CLKOUT2           (clk_main_buf),
//         .CLKOUT2B          (),         
//         .CLKOUT3           (clk_27_buf),
//         .CLKOUT3B          (),         
//         .CLKOUT4           (clk_100_buf),
//         .CLKOUT5           (),
//         .CLKOUT6           (),
//         .CLKFBOUT          (clkfb),
//         .CLKFBOUTB         (),
//         .CLKFBSTOPPED      (),
//         .CLKINSTOPPED      (),
//         .DO                (),
//         .DRDY              (),
//         .DADDR             (7'd0),
//         .DCLK              (1'b0),
//         .DEN               (1'b0),
//         .DI                (16'd0),
//         .DWE               (1'b0),
//         .LOCKED            (rst_lock),
//         .PSCLK             (1'b0),
//         .PSEN              (1'b0),         
//         .PSINCDEC          (1'b0), 
//         .PSDONE            (),         
//         .PWRDWN            (1'b0),         
//         .RST               (1'b0)
//    );



MMCME2_ADV # (
    .BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (2),
    .CLKFBOUT_MULT_F      (10.000),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (8.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.5),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKOUT1_DIVIDE       (5),
    .CLKOUT1_PHASE        (0.000),
    .CLKOUT1_DUTY_CYCLE   (0.5),
    .CLKOUT1_USE_FINE_PS  ("FALSE"),
    .CLKOUT2_DIVIDE       (6),
    .CLKOUT2_PHASE        (0.000),
    .CLKOUT2_DUTY_CYCLE   (0.5),
    .CLKOUT2_USE_FINE_PS  ("FALSE"),
    .CLKOUT3_DIVIDE       (50),
    .CLKOUT3_PHASE        (0.000),
    .CLKOUT3_DUTY_CYCLE   (0.5),
    .CLKOUT3_USE_FINE_PS  ("FALSE"),
    .CLKOUT4_DIVIDE       (10),
    .CLKOUT4_PHASE        (0.000),
    .CLKOUT4_DUTY_CYCLE   (0.5),
    .CLKOUT4_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (5.0),
    .REF_JITTER1          (0.010)
  ) mmcm_adv_inst (
    // Output clocks
    .CLKFBOUT             (clkfb),
    .CLKFBOUTB            (),
    .CLKOUT0              (clk_125_buf),
    .CLKOUT0B             (),
    .CLKOUT1              (clk_200_buf),
    .CLKOUT1B             (),
    .CLKOUT2              (clk_main_buf),
    .CLKOUT2B             (),
    .CLKOUT3              (clk_27_buf),
    .CLKOUT3B             (),
    .CLKOUT4              (clk_100_buf),
    .CLKOUT5              (),
    .CLKOUT6              (),
    // Input clock control
    .CLKFBIN              (clkfb),
    .CLKIN1               (clk_in),
    .CLKIN2               (1'b0),
    // Tied to always select the primary input clock
    .CLKINSEL             (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR                (7'h0),
    .DCLK                 (1'b0),
    .DEN                  (1'b0),
    .DI                   (16'h0),
    .DO                   (),
    .DRDY                 (),
    .DWE                  (1'b0),
    // Ports for dynamic phase shift
    .PSCLK                (1'b0),
    .PSEN                 (1'b0),
    .PSINCDEC             (1'b0),
    .PSDONE               (),
    // Other control and status signals
    .LOCKED               (rst_lock),
    .CLKINSTOPPED         (),
    .CLKFBSTOPPED         (),
    .PWRDWN               (1'b0),
    .RST                  (1'b0)
   );

   		
   BUFG	CLK200_BUFG_INST (
   		.I(clk_200_buf),	  // Clock buffer output
		.O(clk_200)		  // Clock buffer input
		);
		
	BUFG	CLK125_BUFG_INST (
   		.I(clk_125_buf),	  // Clock buffer output
		.O(clk_125)		  // Clock buffer input
		);
		
	BUFG	CLKmain_BUFG_INST (
   		.I(clk_main_buf),	  // Clock buffer output
		.O(clk_main)		  // Clock buffer input
		);
		
	BUFG	CLK27_BUFG_INST (
   		.I(clk_27_buf),	  // Clock buffer output
		.O(clk_27)		  // Clock buffer input
		);
		
	BUFG	CLK100_BUFG_INST (
   		.I(clk_100_buf),	  // Clock buffer output
		.O(clk_100)		  // Clock buffer input
		);

		
	always @(posedge clk_in)
	begin
		if(rst_lock == 1'b0)
		begin
			clk_cnt	<= 8'd0;
		end
		else if(clk_cnt < 8'd200)
		begin
			clk_cnt	<= clk_cnt + 8'd1;
		end
		else
		begin
			clk_cnt	<= clk_cnt;
		end
	end
	
	always @(posedge clk_in)
	begin
		if(rst_lock == 1'b0 || clk_cnt < 8'd200)
		begin
			rst_in	<= 1'b1;
		end
		else
		begin
			rst_in	<= 1'b0;
		end
	end
	
	// reset gen ---------------------------------
	always @(posedge clk_main, posedge rst_in)
	begin
		if (rst_in === 1'b1)
		begin
			rst_gen_pre <= 6'h3F;
			rst_gen     <= 1'b1;
		end
		else
		begin
			rst_gen_pre[0]   <= 1'b0;
			rst_gen_pre[5:1] <= rst_gen_pre[4:0];
			rst_gen          <= rst_gen_pre[5];
		end
	end
	
	always @(posedge clk_27, posedge rst_in)
	begin
		if (rst_in === 1'b1)
		begin
			rst_27_pre <= 6'h3F;
			rst_27     <= 1'b1;
		end
		else
		begin
			rst_27_pre[0]   <= 1'b0;
			rst_27_pre[5:1] <= rst_27_pre[4:0];
			rst_27          <= rst_27_pre[5];
		end
	end
	
	always @(posedge clk_125, posedge rst_in)
	begin
		if (rst_in === 1'b1)
		begin
			rst_125_pre <= 6'h3F;
			rst_125     <= 1'b1;
		end
		else
		begin
			rst_125_pre[0]   <= 1'b0;
			rst_125_pre[5:1] <= rst_125_pre[4:0];
			rst_125          <= rst_125_pre[5];
		end
	end
			
		
endmodule
