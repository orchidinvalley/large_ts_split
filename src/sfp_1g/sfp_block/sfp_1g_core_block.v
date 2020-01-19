//------------------------------------------------------------------------------
// File       : sfp_1g_core_block.v
// Author     : Xilinx Inc.
//------------------------------------------------------------------------------
// (c) Copyright 2009 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES. 
//
//
//------------------------------------------------------------------------------
// Description: This Core Block Level wrapper connects the core to a
//              Series-7 Transceiver.
//
//
//   ------------------------------------------------------------
//   |                      Core Block wrapper                  |
//   |                                                          |
//   |        ------------------          -----------------     |
//   |        |      Core      |          | Transceiver   |     |
//   |        |                |          |               |     |
//   |        |                |          |               |     |
//   |        |                |          |               |     |
// ---------->| GMII           |--------->|           TXP |-------->
//   |        | Tx             |          |           TXN |     |
//   |        |                |          |               |     |
//   |        |                |          |               |     |
//   |        |                |          |               |     |
//   |        |                |          |               |     |
//   |        |                |          |               |     |
//   |        | GMII           |          |           RXP |     |
// <----------| Rx             |<---------|           RXN |<--------
//   |        |                |          |               |     |
//   |        ------------------          -----------------     |
//   |                                                          |
//   ------------------------------------------------------------
//
//


`timescale 1 ps/1 ps

//------------------------------------------------------------------------------
// The module declaration for the Core Block wrapper.
//------------------------------------------------------------------------------

module sfp_1g_core_block #
(
    parameter EXAMPLE_SIMULATION                     =  0         // Set to 1 for simulation
)
   (
      // Transceiver Interface
      //----------------------
      input   [8:0]    drpaddr_in,
      input            drpclk_in,
      input   [15:0]   drpdi_in,
      output  [15:0]   drpdo_out,
      input            drpen_in,
      output           drprdy_out,
      input            drpwe_in,
      input        		gtrefclk,              // Very high quality 125MHz clock for GT transceiver.
      output  [1:0]     txp,                   // Differential +ve of serial transmission from PMA to PMD.
      output  [1:0]     txn,                   // Differential -ve of serial transmission from PMA to PMD.
      input   [1:0]     rxp,                   // Differential +ve for serial reception from PMD to PMA.
      input   [1:0]     rxn,                   // Differential -ve for serial reception from PMD to PMA.

      output       		txoutclk,              // txoutclk from GT transceiver (62.5MHz)
      output       		resetdone,             // The GT transceiver has completed its reset cycle
      input        		mmcm_locked,           // locked indication from MMCM
      input        		userclk,               // 62.5MHz global clock.
      input        		userclk2,              // 125MHz global clock.
      input        		independent_clock_bufg,// 200MHz Independent clock,
      input        		pma_reset,             // transceiver PMA reset signal
      input        		reset,                 // Asynchronous reset for entire core.

      // GMII Interface
      //---------------
      input [7:0]  		gmii_txd,              // Transmit data from client MAC.
      input        		gmii_tx_en,            // Transmit control signal from client MAC.
      input        		gmii_tx_er,            // Transmit control signal from client MAC.
      output [7:0] 		gmii_rxd,              // Received Data to client MAC.
      output       		gmii_rx_dv,            // Received control signal to client MAC.
      output       		gmii_rx_er,            // Received control signal to client MAC.
      output       		gmii_isolate,          // Tristate control to electrically isolate GMII.

      input [4:0]  		configuration_vector,  // Alternative to MDIO interface.
      // General IO's
      //-------------
      output [15:0]		 status_vector,         // Core status.      
      input        		signal_detect,          // Input from PMD to indicate presence of optical input.
      
      // GMII Interface
      //---------------
      input [7:0]  		gmii_txd1,              // Transmit data from client MAC.
      input        		gmii_tx_en1,            // Transmit control signal from client MAC.
      input        		gmii_tx_er1,            // Transmit control signal from client MAC.
      output [7:0] 		gmii_rxd1,              // Received Data to client MAC.
      output       		gmii_rx_dv1,            // Received control signal to client MAC.
      output       		gmii_rx_er1,            // Received control signal to client MAC.
      output       		gmii_isolate1,          // Tristate control to electrically isolate GMII.

      input [4:0]  		configuration_vector1,  // Alternative to MDIO interface.
      // General IO's
      //-------------
      output [15:0]		 status_vector1,         // Core status.      
      input        		signal_detect1          // Input from PMD to indicate presence of optical input.

   );

	//***************************** Parameter Declarations ************************
    parameter QPLL_FBDIV_TOP =  16;

    parameter QPLL_FBDIV_IN  =  (QPLL_FBDIV_TOP == 16)  ? 10'b0000100000 : 
				(QPLL_FBDIV_TOP == 20)  ? 10'b0000110000 :
				(QPLL_FBDIV_TOP == 32)  ? 10'b0001100000 :
				(QPLL_FBDIV_TOP == 40)  ? 10'b0010000000 :
				(QPLL_FBDIV_TOP == 64)  ? 10'b0011100000 :
				(QPLL_FBDIV_TOP == 66)  ? 10'b0101000000 :
				(QPLL_FBDIV_TOP == 80)  ? 10'b0100100000 :
				(QPLL_FBDIV_TOP == 100) ? 10'b0101110000 : 10'b0000000000;

   parameter QPLL_FBDIV_RATIO = (QPLL_FBDIV_TOP == 16)  ? 1'b1 : 
				(QPLL_FBDIV_TOP == 20)  ? 1'b1 :
				(QPLL_FBDIV_TOP == 32)  ? 1'b1 :
				(QPLL_FBDIV_TOP == 40)  ? 1'b1 :
				(QPLL_FBDIV_TOP == 64)  ? 1'b1 :
				(QPLL_FBDIV_TOP == 66)  ? 1'b0 :
				(QPLL_FBDIV_TOP == 80)  ? 1'b1 :
				(QPLL_FBDIV_TOP == 100) ? 1'b1 : 1'b1;
				
	//***************************** Wire Declarations *****************************

    // ground and vcc signals
    wire            tied_to_ground_i;
    wire    [63:0]  tied_to_ground_vec_i;
    wire            tied_to_vcc_i;
    wire    [63:0]  tied_to_vcc_vec_i;
   
    wire            gt0_qplloutclk_i;
    wire            gt0_qplloutrefclk_i;

    wire            gt0_qpllclk_i;
    wire            gt0_qpllrefclk_i;

         
//********************************* Main Body of Code**************************

    assign tied_to_ground_i             = 1'b0;
    assign tied_to_ground_vec_i         = 64'h0000000000000000;
    assign tied_to_vcc_i                = 1'b1;
    assign tied_to_vcc_vec_i            = 64'hffffffffffffffff;

    assign  gt0_qpllclk_i    = gt0_qplloutclk_i;  
    assign  gt0_qpllrefclk_i = gt0_qplloutrefclk_i; 
   //---------------------------------------------------------------------------
   // Internal signals used in this block level wrapper.
   //---------------------------------------------------------------------------

   // Core <=> Transceiver interconnect
   wire         plllock;                  // The PLL Locked status of the Transceiver
   wire         mgt_rx_reset;             // Reset for the receiver half of the Transceiver
   wire         mgt_tx_reset;             // Reset for the transmitter half of the Transceiver
   wire [1:0]   rxbufstatus;              // Elastic Buffer Status (bit 1 asserted indicates  overflow or underflow).
   wire         rxchariscomma;            // Comma detected in RXDATA.
   wire         rxcharisk;                // K character received (or extra data bit) in RXDATA.
   wire [2:0]   rxclkcorcnt;              // Indicates clock correction.
   wire [7:0]   rxdata;                   // Data after 8B/10B decoding.
   wire         rxrundisp;                // Running Disparity after current byte, becomes 9th data bit when RXNOTINTABLE='1'.
   wire         rxdisperr;                // Disparity-error in RXDATA.
   wire         rxnotintable;             // Non-existent 8B/10 code indicated.
   wire         txbuferr;                 // TX Buffer error (overflow or underflow).
   wire         loopback;                 // Set the Transceiver for loopback.
   wire         powerdown;                // Powerdown the Transceiver
   wire         txchardispmode;           // Set running disparity for current byte.
   wire         txchardispval;            // Set running disparity value.
   wire         txcharisk;                // K character transmitted in TXDATA.
   wire [7:0]   txdata;                   // Data for 8B/10B encoding.
   wire         enablealign;              // Allow the transceivers to serially realign to a comma character.

	// Core <=> Transceiver interconnect
   wire         plllock1;                  // The PLL Locked status of the Transceiver
   wire         mgt_rx_reset1;             // Reset for the receiver half of the Transceiver
   wire         mgt_tx_reset1;             // Reset for the transmitter half of the Transceiver
   wire [1:0]   rxbufstatus1;              // Elastic Buffer Status (bit 1 asserted indicates  overflow or underflow).
   wire         rxchariscomma1;            // Comma detected in RXDATA.
   wire         rxcharisk1;                // K character received (or extra data bit) in RXDATA.
   wire [2:0]   rxclkcorcnt1;              // Indicates clock correction.
   wire [7:0]   rxdata1;                   // Data after 8B/10B decoding.
   wire         rxrundisp1;                // Running Disparity after current byte, becomes 9th data bit when RXNOTINTABLE='1'.
   wire         rxdisperr1;                // Disparity-error in RXDATA.
   wire         rxnotintable1;             // Non-existent 8B/10 code indicated.
   wire         txbuferr1;                 // TX Buffer error (overflow or underflow).
   wire         loopback1;                 // Set the Transceiver for loopback.
   wire         powerdown1;                // Powerdown the Transceiver
   wire         txchardispmode1;           // Set running disparity for current byte.
   wire         txchardispval1;            // Set running disparity value.
   wire         txcharisk1;                // K character transmitted in TXDATA.
   wire [7:0]   txdata1;                   // Data for 8B/10B encoding.
   wire         enablealign1;              // Allow the transceivers to serially realign to a comma character.

	//_________________________________________________________________________
    //_________________________________________________________________________
    //_________________________GTXE2_COMMON____________________________________

    GTXE2_COMMON #
    (
            // Simulation attributes
            .SIM_RESET_SPEEDUP   ("FALSE"),//(WRAPPER_SIM_GTRESET_SPEEDUP),
            .SIM_QPLLREFCLK_SEL  (3'b001),
            .SIM_VERSION         ("4.0"),//(SIM_VERSION),


           //----------------COMMON BLOCK Attributes---------------
            .BIAS_CFG                               (64'h0000040000001000),
            .COMMON_CFG                             (32'h00000000),
            .QPLL_CFG                               (27'h06801C1),
            .QPLL_CLKOUT_CFG                        (4'b0000),
            .QPLL_COARSE_FREQ_OVRD                  (6'b010000),
            .QPLL_COARSE_FREQ_OVRD_EN               (1'b0),
            .QPLL_CP                                (10'b0000011111),
            .QPLL_CP_MONITOR_EN                     (1'b0),
            .QPLL_DMONITOR_SEL                      (1'b0),
            .QPLL_FBDIV                             (QPLL_FBDIV_IN),
            .QPLL_FBDIV_MONITOR_EN                  (1'b0),
            .QPLL_FBDIV_RATIO                       (QPLL_FBDIV_RATIO),
            .QPLL_INIT_CFG                          (24'h000006),
            .QPLL_LOCK_CFG                          (16'h21E8),
            .QPLL_LPF                               (4'b1111),
            .QPLL_REFCLK_DIV                        (1)

    )
    gtxe2_common_0_i
    (
        //----------- Common Block  - Dynamic Reconfiguration Port (DRP) -----------
        .DRPADDR                        (tied_to_ground_vec_i[7:0]),
        .DRPCLK                         (tied_to_ground_i),
        .DRPDI                          (tied_to_ground_vec_i[15:0]),
        .DRPDO                          (),
        .DRPEN                          (tied_to_ground_i),
        .DRPRDY                         (),
        .DRPWE                          (tied_to_ground_i),
        //-------------------- Common Block  - Ref Clock Ports ---------------------
        .GTGREFCLK                      (tied_to_ground_i),
        .GTNORTHREFCLK0                 (tied_to_ground_i),
        .GTNORTHREFCLK1                 (tied_to_ground_i),
        .GTREFCLK0                      (gtrefclk),//(GT0_GTREFCLK0_COMMON_IN),
        .GTREFCLK1                      (tied_to_ground_i),
        .GTSOUTHREFCLK0                 (tied_to_ground_i),
        .GTSOUTHREFCLK1                 (tied_to_ground_i),
        //----------------------- Common Block -  QPLL Ports -----------------------
        .QPLLDMONITOR                   (),
        //--------------------- Common Block - Clocking Ports ----------------------
        .QPLLOUTCLK                     (gt0_qplloutclk_i),
        .QPLLOUTREFCLK                  (gt0_qplloutrefclk_i),
        .REFCLKOUTMONITOR               (),
        //----------------------- Common Block - QPLL Ports ------------------------
        .QPLLFBCLKLOST                  (),
        .QPLLLOCK                       (),//(GT0_QPLLLOCK_OUT),
        .QPLLLOCKDETCLK                 (independent_clock_bufg),//(GT0_QPLLLOCKDETCLK_IN),
        .QPLLLOCKEN                     (tied_to_vcc_i),
        .QPLLOUTRESET                   (tied_to_ground_i),
        .QPLLPD                         (tied_to_ground_i),
        .QPLLREFCLKLOST                 (),//(GT0_QPLLREFCLKLOST_OUT),
        .QPLLREFCLKSEL                  (3'b001),
        .QPLLRESET                      (1'b0),//(GT0_QPLLRESET_IN),
        .QPLLRSVD1                      (16'b0000000000000000),
        .QPLLRSVD2                      (5'b11111),
        //------------------------------- QPLL Ports -------------------------------
        .BGBYPASSB                      (tied_to_vcc_i),
        .BGMONITORENB                   (tied_to_vcc_i),
        .BGPDB                          (tied_to_vcc_i),
        .BGRCALOVRD                     (5'b00000),
        .PMARSVD                        (8'b00000000),
        .RCALENB                        (tied_to_vcc_i)

    );
   //---------------------------------------------------------------------------
   // Instantiate the core
   //---------------------------------------------------------------------------
   sfp_1g_core 				gig_eth_pcs_pma_core
     (
      .mgt_rx_reset          (mgt_rx_reset),
      .mgt_tx_reset          (mgt_tx_reset),
      .userclk               (userclk2),
      .userclk2              (userclk2),
      .dcm_locked            (mmcm_locked),
      .rxbufstatus           (rxbufstatus),
      .rxchariscomma         (rxchariscomma),
      .rxcharisk             (rxcharisk),
      .rxclkcorcnt           (rxclkcorcnt),
      .rxdata                (rxdata),
      .rxdisperr             (rxdisperr),
      .rxnotintable          (rxnotintable),
      .rxrundisp             (rxrundisp),
      .txbuferr              (txbuferr),
      .powerdown             (powerdown),
      .txchardispmode        (txchardispmode),
      .txchardispval         (txchardispval),
      .txcharisk             (txcharisk),
      .txdata                (txdata),
      .enablealign           (enablealign),
      .gmii_txd              (gmii_txd),
      .gmii_tx_en            (gmii_tx_en),
      .gmii_tx_er            (gmii_tx_er),
      .gmii_rxd              (gmii_rxd),
      .gmii_rx_dv            (gmii_rx_dv),
      .gmii_rx_er            (gmii_rx_er),
      .gmii_isolate          (gmii_isolate),
      .configuration_vector  (configuration_vector),
      .status_vector         (status_vector),
      .reset                 (reset),
      .signal_detect         (signal_detect)

      );


   //---------------------------------------------------------------------------
   //  Component Instantiation for the Series-7 Transceiver wrapper
   //---------------------------------------------------------------------------

   sfp_1g_core_transceiver #
   (
        .EXAMPLE_SIMULATION              (EXAMPLE_SIMULATION)
   )

transceiver_inst (
		.gt0_qpllclk_i					(gt0_qpllclk_i),
   		.gt0_qpllrefclk_i				(gt0_qpllrefclk_i),
   		
      .drpaddr_in            (drpaddr_in),
      .drpclk_in             (drpclk_in ),
      .drpdi_in              (drpdi_in  ),
      .drpdo_out             (drpdo_out ),
      .drpen_in              (drpen_in  ),
      .drprdy_out            (drprdy_out),
      .drpwe_in              (drpwe_in  ),
      .encommaalign          (enablealign),
      .loopback              (loopback),
      .powerdown             (powerdown),
      .usrclk                (userclk),
      .usrclk2               (userclk2),
      .independent_clock     (independent_clock_bufg),
      .data_valid            (status_vector[1]),
      .txreset               (mgt_tx_reset),
      .txchardispmode        (txchardispmode),
      .txchardispval         (txchardispval),
      .txcharisk             (txcharisk),
      .txdata                (txdata),
      .rxreset               (mgt_rx_reset),
      .rxchariscomma         (rxchariscomma),
      .rxcharisk             (rxcharisk),
      .rxclkcorcnt           (rxclkcorcnt),
      .rxdata                (rxdata),
      .rxdisperr             (rxdisperr),
      .rxnotintable          (rxnotintable),
      .rxrundisp             (rxrundisp),
      .rxbuferr              (rxbufstatus[1]),
      .txbuferr              (txbuferr),
      .plllkdet              (plllock),
      
      .txoutclk              (txoutclk),
      .txn                   (txn[0]),
      .txp                   (txp[0]),
      .rxn                   (rxn[0]),
      .rxp                   (rxp[0]),
      
      .gtrefclk              (gtrefclk),
      .pmareset              (pma_reset),
      .mmcm_locked           (mmcm_locked),
      .resetdone             (resetdone)
   );

	 // Unused
  assign rxbufstatus[0] = 1'b0;



  // Loopback is performed in the core itself.  To alternatively use
  // Transceiver loopback, please drive this port appropriately.
  assign loopback = 1'b0;
  
  
  	//---------------------------------------------------------------------------
   // Instantiate the core
   //---------------------------------------------------------------------------
   sfp_1g_core 				gig_eth_pcs_pma_core1
     (
      .mgt_rx_reset          (mgt_rx_reset1),
      .mgt_tx_reset          (mgt_tx_reset1),
      .userclk               (userclk2),
      .userclk2              (userclk2),
      .dcm_locked            (mmcm_locked),
      .rxbufstatus           (rxbufstatus1),
      .rxchariscomma         (rxchariscomma1),
      .rxcharisk             (rxcharisk1),
      .rxclkcorcnt           (rxclkcorcnt1),
      .rxdata                (rxdata1),
      .rxdisperr             (rxdisperr1),
      .rxnotintable          (rxnotintable1),
      .rxrundisp             (rxrundisp1),
      .txbuferr              (txbuferr1),
      .powerdown             (powerdown1),
      .txchardispmode        (txchardispmode1),
      .txchardispval         (txchardispval1),
      .txcharisk             (txcharisk1),
      .txdata                (txdata1),
      .enablealign           (enablealign1),
      .gmii_txd              (gmii_txd1),
      .gmii_tx_en            (gmii_tx_en1),
      .gmii_tx_er            (gmii_tx_er1),
      .gmii_rxd              (gmii_rxd1),
      .gmii_rx_dv            (gmii_rx_dv1),
      .gmii_rx_er            (gmii_rx_er1),
      .gmii_isolate          (gmii_isolate1),
      .configuration_vector  (configuration_vector1),
      .status_vector         (status_vector1),
      .reset                 (reset),
      .signal_detect         (signal_detect1)

      );

		 //---------------------------------------------------------------------------
   //  Component Instantiation for the Series-7 Transceiver wrapper
   //---------------------------------------------------------------------------

   sfp_1g_core_transceiver #
   (
        .EXAMPLE_SIMULATION              (EXAMPLE_SIMULATION)
   )

transceiver_inst1 (
	.gt0_qpllclk_i			(gt0_qpllclk_i),
   	.gt0_qpllrefclk_i		(gt0_qpllrefclk_i),
   		
      .drpaddr_in            (drpaddr_in),
      .drpclk_in             (drpclk_in ),
      .drpdi_in              (drpdi_in  ),
      .drpdo_out             ( ),
      .drpen_in              (drpen_in  ),
      .drprdy_out            (),
      .drpwe_in              (drpwe_in  ),
      .encommaalign          (enablealign1),
      .loopback              (loopback1),
      .powerdown             (powerdown1),
      .usrclk                (userclk),
      .usrclk2               (userclk2),
      .independent_clock     (independent_clock_bufg),
      .data_valid            (status_vector1[1]),
      .txreset               (mgt_tx_reset1),
      .txchardispmode        (txchardispmode1),
      .txchardispval         (txchardispval1),
      .txcharisk             (txcharisk1),
      .txdata                (txdata1),
      .rxreset               (mgt_rx_reset1),
      .rxchariscomma         (rxchariscomma1),
      .rxcharisk             (rxcharisk1),
      .rxclkcorcnt           (rxclkcorcnt1),
      .rxdata                (rxdata1),
      .rxdisperr             (rxdisperr1),
      .rxnotintable          (rxnotintable1),
      .rxrundisp             (rxrundisp1),
      .rxbuferr              (rxbufstatus1[1]),
      .txbuferr              (txbuferr1),
      .plllkdet              (plllock1),
      
      .txoutclk              (),
      .txn                   (txn[1]),
      .txp                   (txp[1]),
      .rxn                   (rxn[1]),
      .rxp                   (rxp[1]),
      
      .gtrefclk              (gtrefclk),
      .pmareset              (pma_reset),
      .mmcm_locked           (mmcm_locked),
      .resetdone             ()
   );


 
  
  // Unused
  assign rxbufstatus1[0] = 1'b0;



  // Loopback is performed in the core itself.  To alternatively use
  // Transceiver loopback, please drive this port appropriately.
  assign loopback1 = 1'b0;




endmodule // sfp_1g_core_block

