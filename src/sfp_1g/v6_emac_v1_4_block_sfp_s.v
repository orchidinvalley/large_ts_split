
`timescale 1 ps / 1 ps


//-----------------------------------------------------------------------------
// Module declaration for the block-level wrapper
//-----------------------------------------------------------------------------

module v6_emac_v1_4_block_sfp_s
(
    
      independent_clock ,     
		txoutclk		,
		resetdone_i		,
		mmcm_locked		,
		userclk			,
		userclk2		,

    // Client receiver interface
    EMACCLIENTRXD,
    EMACCLIENTRXDVLD,
    EMACCLIENTRXGOODFRAME,
    EMACCLIENTRXBADFRAME,

    // Client transmitter interface
    CLIENTEMACTXD,
    CLIENTEMACTXDVLD,
    EMACCLIENTTXACK,
   
    // 1000BASE-X PCS/PMA interface
    TXP,
    TXN,
    RXP,
    RXN,
    RESETDONE,

    // 1000BASE-X PCS/PMA clock buffer input
    CLK_DS,
    PMA_RESET,
    // Asynchronous reset
    RESET,	
	mac_lost,
	status_vector,
	 // Client receiver interface
    EMACCLIENTRXD1,
    EMACCLIENTRXDVLD1,
    EMACCLIENTRXGOODFRAME1,
    EMACCLIENTRXBADFRAME1,

    // Client transmitter interface
    CLIENTEMACTXD1,
    CLIENTEMACTXDVLD1,
    EMACCLIENTTXACK1,
    status_vector1
);


//-----------------------------------------------------------------------------
// Port declarations
//-----------------------------------------------------------------------------

	input 			independent_clock;
	output			txoutclk		;
	output			resetdone_i		;
	input			mmcm_locked		;
	input			userclk			;
	input			userclk2		;
    // Client receiver interface
    output   [7:0]  EMACCLIENTRXD;
    output          EMACCLIENTRXDVLD;
    output          EMACCLIENTRXGOODFRAME;
    output          EMACCLIENTRXBADFRAME;
   
    // Client transmitter interface
    input    [7:0]  CLIENTEMACTXD;
    input           CLIENTEMACTXDVLD;
    output          EMACCLIENTTXACK;

    // 1000BASE-X PCS/PMA interface
    output   [1:0]   TXP;
    output   [1:0]   TXN;
    input    [1:0]   RXP;
    input    [1:0]   RXN;

    output          RESETDONE;

    // 1000BASE-X PCS/PMA clock buffer inputs
    input           CLK_DS;
    input			PMA_RESET;

    // Asynchronous reset
    input           RESET;
	
	output			mac_lost;
	output	[15:0]	status_vector;
	 // Client receiver interface
    output   [7:0]  EMACCLIENTRXD1;
    output          EMACCLIENTRXDVLD1;
    output          EMACCLIENTRXGOODFRAME1;
    output          EMACCLIENTRXBADFRAME1;
   
    // Client transmitter interface
    input    [7:0]  CLIENTEMACTXD1;
    input           CLIENTEMACTXDVLD1;
    output          EMACCLIENTTXACK1;
    output	[15:0]	status_vector1;


//-----------------------------------------------------------------------------
// Wire and register declarations
//-----------------------------------------------------------------------------

    // Asynchronous reset signals
    wire            reset_ibuf_i;


    // Physical interface signals
    wire            gmii_tx_en_i;
    wire            gmii_tx_er_i;
    wire     [7:0]  gmii_txd_i;
    wire            gmii_rx_dv_i;
    wire            gmii_rx_er_i;
    wire     [7:0]  gmii_rxd_i;

   wire         txoutclk_bufg;                 // txoutclk from GT transceiver.
 
   wire         resetdone_i;                // To indicate that the GT transceiver has completed its reset cycle

	// Physical interface signals
     wire           gmii_tx_en1_i;
    wire            gmii_tx_er1_i;
    wire     [7:0]  gmii_txd1_i;
    wire            gmii_rx_dv1_i;
    wire            gmii_rx_er1_i;
    wire     [7:0]  gmii_rxd1_i;
  
//-----------------------------------------------------------------------------
// Main body of code
//-----------------------------------------------------------------------------


  // Route txoutclk input through a BUFG
   BUFG  bufg_txoutclk (
      .I         (txoutclk_bufg),
      .O         (txoutclk)
   );

    //-------------------------------------------------------------------------
    // Main reset circuitry
    //-------------------------------------------------------------------------

    assign reset_ibuf_i = RESET;

	sfp_1g_core_block		 K7_PCS_PMA (
    .drpaddr_in(9'b0), 
    .drpclk_in(userclk2), 
    .drpdi_in(16'b0), 
    .drpdo_out(), 
    .drpen_in(1'b0), 
    .drprdy_out(), 
    .drpwe_in(1'b0), 
    .gtrefclk				(CLK_DS), 
    .txp					(TXP			), 
    .txn					(TXN			), 
    .rxp					(RXP			), 
    .rxn					(RXN			), 
    .txoutclk				(txoutclk_bufg), 
    .resetdone				(resetdone_i), 
    .mmcm_locked			(mmcm_locked), 
    .userclk				(userclk), 
    .userclk2				(userclk2), 
    .independent_clock_bufg(independent_clock), 
    .pma_reset				(PMA_RESET), 
    .reset					(reset_ibuf_i), 
    
    .gmii_txd  	 			(gmii_txd_i		), 
    .gmii_tx_en	 			(gmii_tx_en_i	), 
    .gmii_tx_er	 			(gmii_tx_er_i	), 
    .gmii_rxd  	 			(gmii_rxd_i		), 
    .gmii_rx_dv	 			(gmii_rx_dv_i	), 
    .gmii_rx_er	 			(gmii_rx_er_i	), 
    .gmii_isolate			(gmii_isolate	), 
    .configuration_vector	(5'b0), 
    .status_vector			(status_vector),    
    .signal_detect			(1'b1),
    
    .gmii_txd1  	 		(gmii_txd1_i	), 
    .gmii_tx_en1	 		(gmii_tx_en1_i	), 
    .gmii_tx_er1	 		(gmii_tx_er1_i	), 
    .gmii_rxd1  	 		(gmii_rxd1_i	), 
    .gmii_rx_dv1	 		(gmii_rx_dv1_i	), 
    .gmii_rx_er1	 		(gmii_rx_er1_i	), 
    .gmii_isolate1			(gmii_isolate1	), 
    .configuration_vector1	(5'b0), 
    .status_vector1			(status_vector1), 
    .signal_detect1			(1'b1)
    );

	
    assign RESETDONE = resetdone_i;
    
   
	mac_gtx_top   top_uut
    (
		 .gtx_clk				(userclk2				),
		 .tx_data_valid			(CLIENTEMACTXDVLD		),
		 .tx_underrun			(),
         .tx_data				(CLIENTEMACTXD			),
         .tx_ack				(EMACCLIENTTXACK		),
         .gmii_tx_er			(gmii_tx_er_i			),			
         .gmii_tx_en			(gmii_tx_en_i			),			
         .gmii_txd				(gmii_txd_i				),			

		 .reset					(reset_ibuf_i			),
         .gmii_rx_er			(gmii_rx_er_i			),
         .gmii_rx_clk			(userclk2),

         .gmii_rx_dv			(gmii_rx_dv_i			),
         .gmii_rxd				(gmii_rxd_i				),
         .rx_data				(EMACCLIENTRXD			),
         .rx_good_frame			(EMACCLIENTRXGOODFRAME	),
         .rx_bad_frame			(EMACCLIENTRXBADFRAME	),
         .rx_data_valid			(EMACCLIENTRXDVLD		)
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
	

	mac_gtx_top   				top_uut1
    (
		 .gtx_clk				(userclk2				),
		 .tx_data_valid			(CLIENTEMACTXDVLD1		),
		 .tx_underrun			(),
         .tx_data				(CLIENTEMACTXD1			),
         .tx_ack				(EMACCLIENTTXACK1		),
         .gmii_tx_er			(gmii_tx_er1_i			),			
         .gmii_tx_en			(gmii_tx_en1_i			),			
         .gmii_txd				(gmii_txd1_i			),			

		 .reset					(reset_ibuf_i			),
         .gmii_rx_clk			(userclk2),
		 .gmii_rx_er			(gmii_rx_er1_i			),
         .gmii_rx_dv			(gmii_rx_dv1_i			),
         .gmii_rxd				(gmii_rxd1_i			),
         .rx_data				(EMACCLIENTRXD1			),
         .rx_good_frame			(EMACCLIENTRXGOODFRAME1	),
         .rx_bad_frame			(EMACCLIENTRXBADFRAME1	),
         .rx_data_valid			(EMACCLIENTRXDVLD1		)
    );
endmodule
