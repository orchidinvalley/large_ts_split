`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:50:58 06/27/2014 
// Design Name: 
// Module Name:    clk100_50 
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
module clk100_50(    
    i_clk_p,
    i_clk_n,
    i_reset,
    
    txoutclk,	
    resetdone_i,
    mmcm_locked,
    userclk,	
    userclk2,	

    
    o_clk_50,
    rst_gen,
    o_clk_ddr3,//166.67mhz
    o_clk_ddr3_ref//200Mhz
    );
    
    input 		i_clk_p;
    input 		i_clk_n;
    input 		i_reset;
    
    input		txoutclk;	
    input		resetdone_i;
    output		mmcm_locked;
    output		userclk;	
    output		userclk2;	
    
    output		 o_clk_50;
    output		 rst_gen;
    output 		o_clk_ddr3;
    output 		o_clk_ddr3_ref;
////////////////////////////////////////
    wire 		clk100m;
    wire 		clk_ddr3_buf;
    wire 		clk_ddr3;
    wire 		clk_ddr3_ref_buf;
    
    wire              rst_lock;               //prf+
    
 //   wire 		clkfbout_clkfbin;
     wire            clkfbout_buf_top;  //prf+
     wire            clkfbout_top;        //prf+
     
////////////////////////////////////
    wire 		clkfbout;
    wire              mmcm_reset;               // MMCM reset signal.
    
    wire              clkout0;                  // MMCM clock0 output (125MHz).
    wire              clkout1;                  // MMCM clock1 output (62.5MHz).
 
 /////////////////////////////////// 
    reg		rst_in;
//    wire              rst_in; //prf modify
    reg		[7:0]	clk_cnt;
    
    reg		[5:0]	rst_gen_pre	;
    reg		rst_gen		;
/////////////////////////////////////////////////////////////////////////////
	 IBUFGDS #(
      .DIFF_TERM("FALSE"), // Differential Termination
      .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD("DEFAULT") // Specifies the I/O standard for this buffer
   ) IBUFGDS_100m_inst (
      .O(clk100m),  // Clock buffer output
      .I(i_clk_p),  // Diff_p clock buffer input
      .IB(i_clk_n) // Diff_n clock buffer input
   );
   
   
   MMCME2_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (10.000),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (20.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKOUT1_DIVIDE       (6),
    .CLKOUT1_PHASE        (0.000),
    .CLKOUT1_DUTY_CYCLE   (0.500),
    .CLKOUT1_USE_FINE_PS  ("FALSE"),
    .CLKOUT2_DIVIDE       (5),
    .CLKOUT2_PHASE        (0.000),
    .CLKOUT2_DUTY_CYCLE   (0.500),
    .CLKOUT2_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (10.000),
    .REF_JITTER1          (0.010))
  mmcm_adv_inst
    // Output clocks
   (.CLKFBOUT            (clkfbout_top),     //(clkfbout_clkfbin),   //prf modify
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (clk50_buf),
    .CLKOUT0B            (clkout0b_unused),
    .CLKOUT1             (clk_ddr3_buf),
    .CLKOUT1B            (clkout1b_unused),
    .CLKOUT2             (clk_ddr3_ref_buf),
    .CLKOUT2B            (clkout2b_unused),
    .CLKOUT3             (clkout3_unused),
    .CLKOUT3B            (clkout3b_unused),
    .CLKOUT4             (clkout4_unused),
    .CLKOUT5             (clkout5_unused),
    .CLKOUT6             (clkout6_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_buf_top),              // (clkfbout_clkfbin),     //prf modify
    .CLKIN1              (clk100m),
    .CLKIN2              (1'b0),
     // Tied to always select the primary input clock
    .CLKINSEL            (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    // Ports for dynamic phase shift
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0),
    .PSDONE              (psdone_unused),
    // Other control and status signals
    .LOCKED              (rst_lock),
    .CLKINSTOPPED        (clkinstopped_unused),
    .CLKFBSTOPPED        (clkfbstopped_unused),
    .PWRDWN              (1'b0),
    .RST                 (1'b0)
    );
 
    BUFG clkf_buf    //prf+
   (.O (clkfbout_buf_top),
    .I (clkfbout_top)); 

    BUFG    BUFG_clk50 
    (
        .O  (o_clk_50), // 1-bit output: Clock output
        .I  (clk50_buf)  // 1-bit input: Clock input
    );
   
    BUFG    BUFG_clk_ddr3 
    (
        .O  (clk_ddr3), // 1-bit output: Clock output
        .I  (clk_ddr3_buf)  // 1-bit input: Clock input
    );    
    
    BUFG    BUFG_clk_ddr3_ref 
    (
        .O  (o_clk_ddr3_ref), // 1-bit output: Clock output
        .I  (clk_ddr3_ref_buf)  // 1-bit input: Clock input
    ); 
    assign o_clk_ddr3 = clk_ddr3;
    
    
    
////////////////////////////////////////////////////////////////////////       
    // The GT transceiver provides a 62.5MHz clock to the FPGA fabrix.  This is 
  // routed to an MMCM module where it is used to create phase and frequency
  // related 62.5MHz and 125MHz clock sources
  MMCME2_ADV # (
    .BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (16.000),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (8.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.5),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKOUT1_DIVIDE       (16),
    .CLKOUT1_PHASE        (0.000),
    .CLKOUT1_DUTY_CYCLE   (0.5),
    .CLKOUT1_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (16.0),
    .REF_JITTER1          (0.010)
  ) mmcm_adv_inst_sfp (
    // Output clocks
    .CLKFBOUT             (clkfbout),
    .CLKFBOUTB            (),
    .CLKOUT0              (clkout0),
    .CLKOUT0B             (),
    .CLKOUT1              (clkout1),
    .CLKOUT1B             (),
    .CLKOUT2              (),
    .CLKOUT2B             (),
    .CLKOUT3              (),
    .CLKOUT3B             (),
    .CLKOUT4              (),
    .CLKOUT5              (),
    .CLKOUT6              (),
    // Input clock control
    .CLKFBIN              (clkfbout),
    .CLKIN1               (txoutclk),
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
    .LOCKED               (mmcm_locked),
    .CLKINSTOPPED         (),
    .CLKFBSTOPPED         (),
    .PWRDWN               (1'b0),
    .RST                  (mmcm_reset)
   );

    assign mmcm_reset = i_reset ||!resetdone_i;

   // This 62.5MHz clock is placed onto global clock routing and is then used
   // for tranceiver TXUSRCLK/RXUSRCLK.
   BUFG bufg_userclk (
      .I     (clkout1),
      .O     (userclk)
   );


   // This 125MHz clock is placed onto global clock routing and is then used
   // to clock all Ethernet core logic.
   BUFG bufg_userclk2 (
      .I     (clkout0),
      .O     (userclk2)
   );
  
  
////////////////////////////////////  
//    assign rst_in = !rst_lock ||  i_reset;        //prf modify

  	
	always @(posedge clk100m)
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
    
    
	always @(posedge clk100m)
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
	always @(posedge clk_ddr3 or posedge rst_in)
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

endmodule
