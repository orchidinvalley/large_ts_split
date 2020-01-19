`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:40:12 07/08/2011 
// Design Name: 
// Module Name:    mac_gmii_top 
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
module mac_gtx_top(
		input				gtx_clk			    ,
        input				tx_data_valid		,
        input				tx_underrun		    ,
        input	[7:0]		tx_data			    ,
        output				tx_ack			    ,
        output				gmii_tx_er		    ,
        output				gmii_tx_en		    ,
        output	[7:0]		gmii_txd			,
//        output				gmii_kw				,
        input				reset				,
        input				gmii_rx_er		    ,
        input				gmii_rx_clk		    ,
//        gmii_wr_clk		                    ,
        input				gmii_rx_dv		    ,
        input	[7:0]		gmii_rxd			,
        output	[7:0]		rx_data			    ,
        output				rx_good_frame		,
        output				rx_bad_frame		,
        output				rx_data_valid		
    );

	wire		[7:0]		tx_crc_data		;
	wire					tx_crc_en			;
	
	wire					rx_crc_en			;
	wire                    rx_crc_err		    ;
	
	// rx
	emac_recv_gtx emac_recv (
		.clk				(gmii_rx_clk	), 
		.rst				(reset			), 
		.gmii_rxd			(gmii_rxd		), 
		.gmii_rx_dv			(gmii_rx_dv		), 
		.gmii_rx_er			(gmii_rx_er		), 
		.crc_en				(rx_crc_en		), 
		.crc_err			(rx_crc_err		), 
		.rx_data			(rx_data		), 
		.rx_data_valid		(rx_data_valid	), 
		.rx_good			(rx_good_frame	), 
		.rx_bad				(rx_bad_frame	)
	);

	crc_32_check_gtx crc_32_check(
		.clk				(gmii_rx_clk	),
		.gmii_rxd			(gmii_rxd		),
		.gmii_rx_dv			(gmii_rx_dv		),
		.crc_en				(rx_crc_en		),
		.crc_err		    (rx_crc_err		)
    );
    
	
	// tx
	emac_tx_gtx emac_tx (
		.clk				(gtx_clk		), 
		.rst				(reset			), 
		.tx_data			(tx_data		), 
		.tx_data_valid		(tx_data_valid	), 
		.tx_ack				(tx_ack			), 
		
		.crc_data			(tx_crc_data	), 
		.crc_en				(tx_crc_en		), 
		.gmii_txd			(gmii_txd		), 
		.gmii_tx_en			(gmii_tx_en		), 
		.gmii_tx_er			(gmii_tx_er		)
//		.gmii_kw			(gmii_kw		)
	);

	crc_32_gtx crc_32(
		.clk				(gtx_clk		),
		.rst				(reset			),
		.rx_data			(tx_data		),
		.rx_data_valid		(tx_data_valid	),
		.rx_ack				(tx_ack			),
		.tx_data			(tx_crc_data	),
		.tx_data_valid      (tx_crc_en		)
    );
    


endmodule












