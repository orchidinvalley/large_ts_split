`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    09:30:23 08/18/2010
// Design Name:
// Module Name:    ngb_vod_top
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
module pcie_dvb_top(
    input				i_sys_clk_p,
	input				i_sys_clk_n,
	input				fpga_rst,
	input 			clk_27m_in,


	inout				io_iic_scl,
   	 inout			io_iic_sda,
    	output			o_si5324_reset_n,
 	input				i_si5324_p,
   	 input			i_si5324_n,


//sfp
    input   		[1:0] 	   		 RXP1,
    input  		 [1:0] 		RXN1,
    output 		 [1:0] 		TXP1,
    output  		[1:0] 			TXN1,
    input  		 [1:0] 	  	 RXP2,
    input  		 [1:0] 		RXN2,
    output  		[1:0] 			TXP2,
    output		  [1:0] 		TXN2,

	output				TILE1_TX_ENABLE	,
	output				TILE2_TX_ENABLE	,
	output				TILE3_TX_ENABLE	,
	output				TILE4_TX_ENABLE	,

   //pcie
  	output	[3:0]			 pci_exp_txp,
	output	[3:0]			 pci_exp_txn,
	input 	[3:0] 		pci_exp_rxp,
	input		[3:0] 		pci_exp_rxn,
	input					sys_reset_n,
	input 				sys_clk_p,
	input 				sys_clk_n,




////
//	output BPI_RST,
	output 				BPI_ADV,
	output				 BPI_CE,
	output				BPI_WE,
	output				BPI_OE,

	output 	[25:0]		BPI_ADDR,
	inout  	[15:0]		BPI_DATA,

	output				led,
	input 				emclk

	);
	assign 		BPI_ADV	=0;
	wire			rst_gen;
	wire			rst;
	wire			rocket_refclk_0;
	wire			clk125m;


///////////////////////////////////////////////////////////////////////

	wire [7:0]			data_in_sfp1;
	wire  				data_in_sfp1_valid;
	wire [7:0]			data_in_sfp2;
	wire 				data_in_sfp2_valid;
	wire [7:0]			data_in_sfp3;
	wire 				data_in_sfp3_valid;
	wire [7:0]			data_in_sfp4;
	wire 				data_in_sfp4_valid;


	wire [32:0] 		data_out;
	wire 				data_out_valid;




	wire	[7:0]		ts_dout_spf1;
	wire				ts_dout_spf1_en;
	wire	[7:0]		ts_dout_spf2;
	wire				ts_dout_spf2_en;
	wire	[7:0]		ts_dout_spf3;
	wire				ts_dout_spf3_en;
	wire	[7:0]		ts_dout_spf4;
	wire				ts_dout_spf4_en;


	wire				tx_fifo_over_1;
	wire				tx_fifo_over_2;
	wire				tx_fifo_over_3;
	wire				tx_fifo_over_4;


	wire	[7:0]			si_dout;
	wire				si_dout_en;
	reg 	[7:0]			net_dout;
	reg 				net_dout_en;


	wire	[7:0]			con_dout;
	wire				con_dout_en;



	wire	[31:0]		sfp1_ip;
	wire	[47:0]		sfp1_mac={16'h0012,sfp1_ip};
	wire	[31:0]		sfp2_ip;
	wire	[47:0]		sfp2_mac={16'h0012,sfp2_ip};
	wire	[31:0]		sfp3_ip;
	wire	[47:0]		sfp3_mac={16'h0012,sfp3_ip};
	wire	[31:0]		sfp4_ip;
	wire	[47:0]		sfp4_mac={16'h0012,sfp4_ip};




	wire	[7:0]		arp2mac1_data;
	wire				arp2mac1_en;

	wire	[7:0]		arp2mac2_data;
	wire				arp2mac2_en;

	wire	[7:0]		arp2mac3_data;
	wire				arp2mac3_en;

	wire	[7:0]		arp2mac4_data;
	wire				arp2mac4_en;


	wire	[7:0]		mac2arp1_data;
	wire				mac2arp1_en;

	wire	[7:0]		mac2arp2_data;
	wire				mac2arp2_en;

	wire	[7:0]		mac2arp3_data;
	wire				mac2arp3_en;

	wire	[7:0]		mac2arp4_data;
	wire				mac2arp4_en;






	wire				rst_125;
	wire				clk_ddr3_ref;
	//---------------------------------------------------







//////////////////////////////////////////////////////////////////////

    assign	TILE1_TX_ENABLE	= 1'b0	;
    assign	TILE2_TX_ENABLE	= 1'b0	;
    assign	TILE3_TX_ENABLE	= 1'b0	;
    assign	TILE4_TX_ENABLE	= 1'b0	;

    assign  rst = ~fpga_rst;

	wire	[15:0]BPI_DATA_in;
	wire [15:0]BPI_DATA_out;
	wire	BPI_DATA_en;
	wire  [7:0]con_bpi;
	wire con_bpi_en;
	wire [7:0]con_reconfig;
	wire  con_reconfig_en;


	wire [12:0]ts_ram_waddr;
	wire ts_ram_wr;
	wire [511:0]ts_ram_wdata;

	wire pcie_test_flag;
	wire tsmf_test_flag;
	wire	test_interval;



	assign led = test_flag_s1_2 & test_flag_s3_4|pcie_test_flag|tsmf_test_flag|test_interval;

///////////////////////////////////////////////////////////////////////////////////////////////////////
wire 		clk_main;
wire 		clk_ddr3;
wire         txoutclk;                 // txoutclk from GT transceiver.
wire         resetdone_i;                // To indicate that the GT transceiver has completed its reset cycle
wire		mmcm_locked;
wire		userclk;
wire		userclk2;

    reg       [9:0] rst_cnt;

//////////////////////////////////////////////////////////

IBUFDS_GTE2 #(
      .CLKCM_CFG("TRUE"),   // Refer to Transceiver User Guide
      .CLKRCV_TRST("TRUE"), // Refer to Transceiver User Guide
      .CLKSWING_CFG(2'b11)  // Refer to Transceiver User Guide
   )
   IBUFDS_GTE2_inst (
      .O(rocket_refclk_0),         // 1-bit output: Refer to Transceiver User Guide
      .ODIV2(), // 1-bit output: Refer to Transceiver User Guide
      .CEB(1'b0),     // 1-bit input: Refer to Transceiver User Guide
      .I(i_si5324_p),         // 1-bit input: Refer to Transceiver User Guide
      .IB(i_si5324_n)        // 1-bit input: Refer to Transceiver User Guide
   );

 /*BUFG BUFG_inst (
      .O(clk125m), // 1-bit output: Clock output
      .I(rocket_refclk_0)  // 1-bit input: Clock input
   );*/


////////////////////////////////////////////////////////////////////////
//    //   --------------------------------------------------------------------
//   //GTX PMA reset circuitry
//  //--------------------------------------------------------------------
//  (* ASYNC_REG = "TRUE" *)
  reg  [ 3:0] reset0_r;
//  wire        clk_ds_0;
  wire        pma_reset_0;

  always@(posedge userclk2 or posedge rst_gen)
     if (rst_gen == 1'b1)
        reset0_r <= 4'b1111;
     else
        reset0_r <= {reset0_r[2:0], rst_gen};

  assign pma_reset_0 = reset0_r[3];


	clk100_50           clk_100_50
 	(
 	    .i_clk_p			(i_sys_clk_p),//100Mhz
 	    .i_clk_n			(i_sys_clk_n),
 	    .i_reset			(rst),

 	    .txoutclk		(txoutclk),		//62.5M  come from SFP output
 	    .resetdone_i		(resetdone_i),
 	    .mmcm_locked	(mmcm_locked),
 	    .userclk			(userclk),	//62.5M output to SFP GTX transceiver
 	    .userclk2		(userclk2),		//125M	output to SFP pcs/pms & MAC

 	    .o_clk_50		(clk50),
 	    .rst_gen		(rst_gen),
            .o_clk_ddr3		(clk_main),//(clk_ddr3),
            .o_clk_ddr3_ref   (clk_ddr3_ref)
 	);


///////clk50 to clk156//////////////////
	clock_control	    clock_control
	(
	    .i2c_clk 		(io_iic_scl),
        .i2c_data  		(io_iic_sda),
//        .i2c_mux_rst_n 	(),
        .si5324_rst_n 	(o_si5324_reset_n),
        .rst 	   		(rst),
        .clk50 			(clk50)
	);

//////////////////////pcie//////////////
	pcie_dma_ep_top             pcie_uut
	(
        .pci_exp_txp			(pci_exp_txp),
        .pci_exp_txn			(pci_exp_txn),
        .pci_exp_rxp			(pci_exp_rxp),
        .pci_exp_rxn			(pci_exp_rxn),

        .cmd_dvb_dout			(con_dout),
        .cmd_dvb_dout_en		(con_dout_en),
        .cmd_dvb_din			(net_dout),
        .cmd_dvb_din_en			(net_dout_en),
        .ts_ram_wr(ts_ram_wr),
    		.ts_ram_waddr(ts_ram_waddr),
    		.ts_ram_wdata(ts_ram_wdata),
    		.ts_ram_valid(ts_ram_valid),
    		.test_flag	(pcie_test_flag),
    		.test_interval(test_interval),
    		.ts_ram_clear	(ts_ram_clear),
        .sys_clk_p				(sys_clk_p),
 	    	.sys_clk_n				(sys_clk_n),
        .sys_reset_n			(sys_reset_n),
        .clk_main				(clk_main),
        .trn_clk(trn_clk),
    		.ram_full_1(ram_full_1),
    		.ram_full_2(ram_full_2),
        .emclk					(emclk)
    );

//
//
	sfp_s_top									sfp_s1_top(
		.rocket_refclk					(rocket_refclk_0),
		.clk125									(userclk2),
		.RESET									(rst_gen		),
		.txoutclk								(txoutclk),
 	    .resetdone_i					(resetdone_i),
 	    .mmcm_locked					(mmcm_locked),
 	    .userclk							(userclk),
 	    .userclk2							(userclk2),
		.pma_reset_i						(pma_reset_0	),
		.independent_clock			(clk_ddr3_ref),
		.TXP				    				(TXP1),
		.TXN				    				(TXN1),
		.RXP				    				(RXP1),
		.RXN				    				(RXN1),

		.clk_27m								(clk_27m_in		),

    	.local0_ip						(sfp1_ip		),//(32'hc0120820),//
    	.local0_mac	          (sfp1_mac		),// (48'h0012c0120820),
    	.rx_clk_0							(clk_main		),
    	.rx_rst_0			        (rst_gen		),
    	.udp_dout_0			   	  (data_in_sfp1	),
    	.udp_dout_en_0	      (data_in_sfp1_valid),

    	.arp_dout_0			      (mac2arp1_data	),
    	.arp_dout_en_0	      (mac2arp1_en	),
    	.tx_clk_0			        (clk_main		),
    	.tx_rst_0			        (rst_gen		),
    	.udp_din_0			    	(ts_dout_spf1	),
    	.udp_din_en_0		      (ts_dout_spf1_en),
    	.arp_din_0			      (arp2mac1_data	),
    	.arp_din_en_0		      (arp2mac1_en	),
    	.udp_prog_full_0			(tx_fifo_over_1	),

    	.local1_ip						(sfp2_ip		),
    	.local1_mac	          (sfp2_mac		),
    	.rx_clk_1							(clk_main		),
    	.rx_rst_1			        (rst_gen		),
    	.udp_dout_1			     	(data_in_sfp2	),
    	.udp_dout_en_1	      (data_in_sfp2_valid),

    	.arp_dout_1			       (mac2arp2_data	),
    	.arp_dout_en_1	       (mac2arp2_en	),
    	.tx_clk_1			         (clk_main		),
    	.tx_rst_1			         (rst_gen		),
    	.udp_din_1			       (ts_dout_spf2	),
    	.udp_din_en_1		       (ts_dout_spf2_en),
    	.arp_din_1			       (arp2mac2_data	),
    	.arp_din_en_1		       (arp2mac2_en	),
    	.udp_prog_full_1			(tx_fifo_over_2	),
    	.test_flag						(test_flag_s1_2	)

    );

	sfp_s_top									sfp_s2_top(
		.rocket_refclk					(rocket_refclk_0),
		.clk125									(userclk2),
		.RESET									(rst_gen		),
		.txoutclk								(),
		.resetdone_i						(),
 	    .mmcm_locked					(mmcm_locked),
 	    .userclk							(userclk),
 	    .userclk2							(userclk2),
		.pma_reset_i						(pma_reset_0	),
		.independent_clock			(clk_ddr3_ref),
		.TXP				    				(TXP2),
		.TXN				    				(TXN2),
		.RXP				    				(RXP2),
		.RXN				    				(RXN2),

		.clk_27m								(clk_27m_in		),

    	.local0_ip						(sfp3_ip		),
    	.local0_mac	          (sfp3_mac		),
    	.rx_clk_0							(clk_main		),
    	.rx_rst_0			        (rst_gen		),
    	.udp_dout_0			     	(data_in_sfp3	),
    	.udp_dout_en_0	      (data_in_sfp3_valid),

    	.arp_dout_0			       (mac2arp3_data	),
    	.arp_dout_en_0	       (mac2arp3_en	),
    	.tx_clk_0			         (clk_main		),
    	.tx_rst_0			         (rst_gen		),
    	.udp_din_0			    	 (ts_dout_spf3	),
    	.udp_din_en_0		       (ts_dout_spf3_en),
    	.arp_din_0			       (arp2mac3_data	),
    	.arp_din_en_0		       (arp2mac3_en	),
    	.udp_prog_full_0			 (tx_fifo_over_3	),

    	.local1_ip						(sfp4_ip		),
    	.local1_mac	          (sfp4_mac		),
    	.rx_clk_1							(clk_main		),
    	.rx_rst_1			        (rst_gen		),
    	.udp_dout_1			   	 (data_in_sfp4	),
    	.udp_dout_en_1	      (data_in_sfp4_valid),

    	.arp_dout_1			       (mac2arp4_data	),
    	.arp_dout_en_1	       (mac2arp4_en	),
    	.tx_clk_1			         (clk_main		),
    	.tx_rst_1			         (rst_gen		),
    	.udp_din_1			       (ts_dout_spf4	),
    	.udp_din_en_1		       (ts_dout_spf4_en),
    	.arp_din_1			       (arp2mac4_data	),
    	.arp_din_en_1		       (arp2mac4_en	),
    	.udp_prog_full_1			(tx_fifo_over_4	),
    	.test_flag						(test_flag_s3_4	)

    );



//
//	data_in_pretreat 		date_pre
//	(
//	    .clk					(clk_main			),
//	    .reset					(rst_gen			),
//	    .data_in_sfp1			(data_in_sfp1		),
//	    .data_in_sfp1_valid		(data_in_sfp1_valid	),
//	    .data_in_sfp2			(data_in_sfp2		),
//	    .data_in_sfp2_valid		(data_in_sfp2_valid	),
//	    .data_in_sfp3			(data_in_sfp3		),
//	    .data_in_sfp3_valid		(data_in_sfp3_valid	),
//	    .data_in_sfp4			(data_in_sfp4		),
//	    .data_in_sfp4_valid		(data_in_sfp4_valid	),
//
//
//	    .data_out				(data_out			),
//	    .data_out_valid			(data_out_valid		),
//	    .test_flag				(test_flag_425     )
//    );


	 sfp_gmii_cmd_mux 			csa_nms_reconfig_cmd_mux
    (
	    .clk					(clk_main			),
	    .rst					(rst_gen			),

	    .cmd_in0				(con_dout			),
	    .cmd_in0_en				(con_dout_en		),

	    .cmd_in1				(con_reconfig		),
	    .cmd_in1_en				(con_reconfig_en    ),

	    .tx_data				(con_dout_mix		),
	    .tx_data_valid			(con_dout_en_mix	)
    );



	ts_split_top ts_split_top_uut (
    .clk(clk_main),
    .rst(rst_gen),
    .con_din(con_dout),
    .con_din_en(con_dout_en),
    .udp_din(data_in_sfp1),
    .udp_din_en(data_in_sfp1_valid),
    .con_dout(si_dout),
    .con_dout_en(si_dout_en),
    .sfp1_ip(sfp1_ip),
    .sfp2_ip(sfp2_ip),
    .sfp3_ip(sfp3_ip),
    .sfp4_ip(sfp4_ip),
    .ts_ram_wr(ts_ram_wr),
    .ts_ram_waddr(ts_ram_waddr),
    .ts_ram_wdata(ts_ram_wdata),
    .ts_ram_valid(ts_ram_valid),
    .test_flag(tsmf_test_flag),
    .ts_ram_clear(ts_ram_clear),
    .clk_pcie(clk_main),
    .ram_full_1(ram_full_1),
    .ram_full_2(ram_full_2)
    );







   BPI_top 			BPI_top_init
    (
    	.clk				(clk_main),
    	.rst				(rst_gen),
    	.BPI_RST			(BPI_RST),
    	.BPI_CE				(BPI_CE),
    	.BPI_WE				(BPI_WE),
    	.BPI_OE				(BPI_OE),
    	.BPI_ADDR			(BPI_ADDR),
			.BPI_DATA_in		(BPI_DATA),
    	.BPI_DATA_out		(BPI_DATA_out),
    	.BPI_DATA_en		(BPI_DATA_en),
    	.con_din			(con_dout),
    	.con_din_en			(con_dout_en),
			.con_dout			(con_bpi),
			.con_dout_en		(con_bpi_en),
			.led 					(),
			.fpga_rst			(fpga_rst),
			.con_reconfig		(con_reconfig),
			.con_reconfig_en	(con_reconfig_en)
    );





assign BPI_DATA=BPI_DATA_en?BPI_DATA_out:16'hz;





    always@(posedge clk_main)begin
    	if(rst_gen)begin
    		net_dout<=0;
    		net_dout_en<=0;
    	end
    	else if(con_bpi_en)begin
    		net_dout<=con_bpi;
    		net_dout_en<=con_bpi_en;
    	end
    	else begin
    		net_dout<=si_dout;
    		net_dout_en<=si_dout_en;
    	end
    end

endmodule
