`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:37:38 03/18/2010 
// Design Name: 
// Module Name:    sfp_translation_ip 
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
module sfp_translation_ip_s
(
	input	[31:0]			LOCAL_IP	 	,	
    input	[47:0]			LOCAL_MAC 		,
	input					ROCKET_REFCLK	,
    input					PMA_RESET		,
    input           		RESET			,
    input 					independent_clock,
    output					txoutclk			,
	output					resetdone_i			,
	input					mmcm_locked			,
	input					userclk				,
	input					userclk2			,
	
    output   [1:0]       	TXP				,
    output   [1:0]       	TXN				,
    input    [1:0]       	RXP				,
    input    [1:0]       	RXN				,
    
    input					clk125			,
    input	[32:0]			pcr_base_cnt	,
	input	[8:0]			pcr_ext_cnt		,
    
    input					RX_CLK			,	
    input					RX_RESET		,
	output		[7:0]		udp_ts_dout		,	
	output					udp_ts_dout_en	  	,


	output		[7:0]		rx_fifo_dout	,	
	output					rx_fifo_dout_en	,    
    input					TX_CLK			,	
    input					TX_RESET		,
	input		[7:0]		UDP_DIN			,	
	input					UDP_DIN_EN	  	,
	input		[7:0]		TX_ARP          ,
	input					TX_ARP_EN		,
	
	output	[47:0]			src_mac			,
	output					udp_prog_full	,
	
	output					test_flag		,
	
	
	input	[31:0]			LOCAL1_IP		,
	input	[47:0]			LOCAL1_MAC		,
	input					RX_CLK1			,		
	input					RX_RESET1		,    
	output		[7:0]		udp_ts_dout1	,	
	output					udp_ts_dout1_en	,
	output		[7:0]	    rx_fifo_dout1	 ,   
	output				    rx_fifo_dout1_en,	
	input					TX_CLK1			,
	input					TX_RESET1		,    
	input		[7:0]		UDP_DIN1		,	
	input					UDP_DIN1_EN	  	,
	input		[7:0]		TX_ARP1         ,   
	input					TX_ARP1_EN		,   
	                    	                   
	output	[47:0]			src_mac1		,	
	output				    udp_prog1_full	,	
	output                   test_flag1			
    					
	    );
    	
//-----------------------------------------------------------------------------
// Wire and Reg Declarations 
//-----------------------------------------------------------------------------
	wire	[15:0]		status_vector;
	wire	[15:0]		status_vector1;						
    // Global asynchronous reset
    wire            	reset_i;
    wire            	resetdone;
   	reg					resetdone_r;		
    
    // receive module ----------------------

    reg		[5:0] 		pre_rx_reset	;
    reg             	rx_reset		;
    
    wire	[7:0]		rx_data_i		;
    wire				rx_data_valid_i ;
    wire				rx_good_frame_i ;
    wire				rx_bad_frame_i  ;
    reg		[7:0]		rx_data_r       ;
    reg					rx_data_valid_r ;	
    reg					rx_good_frame_r ;	
    reg					rx_bad_frame_r  ;	

//    wire	[7:0]		rx_fifo_dout	;
//    wire				rx_fifo_dout_en	;    
    
    reg		[5:0] 		pre_tx_reset	;
    reg					tx_reset		;	
    wire	[7:0]		tx_arp_dout		;    
    wire				tx_arp_dout_en	;	
    wire				tx_arp_ack		;
	wire	[7:0]		tx_fifo_dout	;	
    wire				tx_fifo_dout_en	;    
    wire				tx_fifo_ack		;    
    wire	[7:0]		udp_dout		;	
    wire				udp_dout_en		;    
    wire				udp_ack			;    
    wire	[7:0]		mac_din			;
    wire				mac_din_en		;	
    wire	[7:0]		tx_data_i		;
    wire				tx_data_valid_i	;    
    wire				tx_ack_i		;	
    
    wire	[7:0]		pub_dout		;
    wire				pub_dout_en		;
    
    wire	[7:0]		pcr_dout		;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

	wire	[7:0]		rx_data1_i		;
    wire				rx_data_valid1_i ;
    wire				rx_good_frame1_i ;
    wire				rx_bad_frame1_i  ;
    reg		[7:0]		rx_data_r1       ;
    reg					rx_data_valid_r1 ;	
    reg					rx_good_frame_r1 ;	
    reg					rx_bad_frame_r1  ;	
    
//    wire	[7:0]		rx_fifo_dout	;
//    wire				rx_fifo_dout_en	;    
    
    reg		[5:0] 		pre_tx_reset1	;
    reg					tx_reset1		;	
    wire	[7:0]		tx_arp_dout1		;    
    wire				tx_arp_dout1_en	;	
    wire				tx_arp_ack1		;
	wire	[7:0]		tx_fifo_dout1	;	
    wire				tx_fifo_dout1_en	;    
    wire				tx_fifo_ack1		;    
    wire	[7:0]		udp_dout1		;	
    wire				udp_dout1_en		;    
    wire				udp_ack1			;    
    wire	[7:0]		mac_din1			;
    wire				mac_din1_en		;	
    wire	[7:0]		tx_data1_i		;
    wire				tx_data_valid1_i	;    
    wire				tx_ack1_i		;	
    
    wire	[7:0]		pub_dout1		;
    wire				pub_dout1_en		;
    
    wire	[7:0]		pcr_dout1		;    
    wire				pcr_dout1_en	;
    wire				good_frame_out1;
    wire				bad_frame_out1;

	//assign	test_flag =  test_flag_bfmac & test_flag_bfpub ;
    assign		test_flag = status_vector[0];
     assign		test_flag1 = status_vector1[0];                    
    assign reset_i 	= RESET;

   //----------------------------------------------------------------------------- 
   	
	// Synchronize resetdone_i from the GT in the transmitter clock domain
	always @(posedge clk125, posedge reset_i)
		if (reset_i === 1'b1)
			resetdone_r <= 1'b0;
		else
			resetdone_r <= resetdone;

	// Create synchronous reset in the receive clock domain.
	always @(posedge clk125, posedge reset_i)
	begin
		if (reset_i === 1'b1)
		begin
			pre_rx_reset <= 6'h3F;
			rx_reset     <= 1'b1;
		end
		else
		begin
			if (resetdone_r == 1'b1)
			begin
				pre_rx_reset[0]   <= 1'b0;
				pre_rx_reset[5:1] <= pre_rx_reset[4:0];
				rx_reset          <= pre_rx_reset[5];
			end
		end
	end
	
	
	// Create synchronous reset in the receive clock domain.
	always @(posedge clk125, posedge reset_i)
	begin
		if (reset_i === 1'b1)
		begin
			pre_tx_reset <= 6'h3F;
			tx_reset     <= 1'b1;
		end
		else
		begin
			if (resetdone_r == 1'b1)
			begin
				pre_tx_reset[0]   <= 1'b0;
				pre_tx_reset[5:1] <= pre_tx_reset[4:0];
				tx_reset          <= pre_tx_reset[5];
			end
		end
	end
//////////////////////////////////////////////////////////////////////////////	
	always @(posedge clk125)
	begin
		if (rx_reset)
		begin
			rx_data_r       	<= 8'h00;
			rx_data_valid_r     <= 1'b0;
			rx_good_frame_r     <= 1'b0;
			rx_bad_frame_r      <= 1'b0;
		end
		else
		begin
			rx_data_r       	<= rx_data_i		;
		    rx_data_valid_r     <= rx_data_valid_i  ;
		    rx_good_frame_r     <= rx_good_frame_i  ;
		    rx_bad_frame_r      <= rx_bad_frame_i   ;
		end
	end

    //------------------------------------------------------------------------
    // Instantiate the EMAC Wrapper with LL FIFO 
    // (v5_emac_v1_5_locallink.v) 
    //------------------------------------------------------------------------

    
    
	v6_emac_v1_4_block_sfp_s 				v6_emac_v1_4_block_init
	(
	    
		.independent_clock					(independent_clock),
		.txoutclk							(txoutclk),
 	    .resetdone_i						(resetdone_i),
 	    .mmcm_locked						(mmcm_locked),
 	    .userclk							(userclk),
 	    .userclk2							(userclk2),
 	    // Client receiver interface
 	    .EMACCLIENTRXD						(rx_data_i		 ),
 	    .EMACCLIENTRXDVLD					(rx_data_valid_i ),
	    .EMACCLIENTRXGOODFRAME				(rx_good_frame_i ),
	    .EMACCLIENTRXBADFRAME				(rx_bad_frame_i  ),
	    // Client transmitter interface
	    .CLIENTEMACTXD						(tx_data_i			),
	    .CLIENTEMACTXDVLD					(tx_data_valid_i	),
	    .EMACCLIENTTXACK					(tx_ack_i			),
	    .status_vector						(status_vector),
	    // 1000BASE-X PCS/PMA interface
	    .TXP								(TXP),        
	    .TXN								(TXN),        
	    .RXP								(RXP),        
	    .RXN								(RXN),        
	    .RESETDONE							(resetdone),
	    // 1000BASE-X PCS/PMA clock buffer input
	    .CLK_DS								(ROCKET_REFCLK	),
	    .PMA_RESET							(PMA_RESET		),
	    // Asynchronous reset
	    .RESET								(reset_i),
		.mac_lost							(mac_lost),
		
		 // Client receiver interface
 	    .EMACCLIENTRXD1						(rx_data1_i		 ),
 	    .EMACCLIENTRXDVLD1					(rx_data_valid1_i ),
	    .EMACCLIENTRXGOODFRAME1				(rx_good_frame1_i ),
	    .EMACCLIENTRXBADFRAME1				(rx_bad_frame1_i  ),
	    // Client transmitter interface
	    .CLIENTEMACTXD1						(tx_data1_i			),
	    .CLIENTEMACTXDVLD1					(tx_data_valid1_i	),
	    .EMACCLIENTTXACK1					(tx_ack1_i			),
	    .status_vector1						(status_vector1)
	 
	);
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////	
		
	pcr_amend_front_sfp 			pcr_amend_front_sfp_init
	(                       		
	    .clk						(clk125			), 
	    .rst						(rx_reset			), 
	    .pcr_din					(rx_data_r       	), 
	    .pcr_din_en					(rx_data_valid_r 	), 
	    .good_frame_in				(rx_good_frame_r 	), 
	    .bad_frame_in				(rx_bad_frame_r  	), 
	                    			
	    .pcr_base_cnt				(pcr_base_cnt		), 
	    .pcr_ext_cnt				(pcr_ext_cnt		), 
	                    			
	    .pcr_dout					(pcr_dout			), 
	    .pcr_dout_en				(pcr_dout_en		), 
	    .good_frame_out				(good_frame_out		), 
	    .bad_frame_out				(bad_frame_out		)
    );

   	// ----------- rx -------------------
	ram_4096byte 					rx_bram_4096byte(
		.rx_clk						(clk125			),
		.rx_rst						(rx_reset			),
		
		.rx_data					(pcr_dout		),
		.rx_data_valid				(pcr_dout_en	),
		.rx_good					(good_frame_out	),
		.rx_bad						(bad_frame_out	),
		
		.tx_clk						(RX_CLK				),
		.tx_rst						(RX_RESET			),
		.tx_data					(rx_fifo_dout		),
		.tx_data_valid  			(rx_fifo_dout_en	)
	);

	udp_public 						udp_public(
		.local_ip					(LOCAL_IP	 		),
		.local_mac					(LOCAL_MAC 			),
		.clk						(RX_CLK				),
		.rst						(RX_RESET			),
		.rx_data					(rx_fifo_dout		),
		.rx_data_valid				(rx_fifo_dout_en	),
		.tx_data					(udp_ts_dout		    ),
		.tx_data_valid	    		(udp_ts_dout_en		),
		
		.src_mac					(src_mac			)
    );


	// ----------- tx -------------------
	fifo_ack 						tx_arp_fifo(
		.rx_clk						(TX_CLK				),
		.rx_rst						(TX_RESET			),
		.rx_data					(TX_ARP          	),
		.rx_data_valid				(TX_ARP_EN		 	),
		.tx_clk						(clk125			),
		.tx_rst						(tx_reset			),
		.tx_data					(tx_arp_dout		),
		.tx_data_valid				(tx_arp_dout_en		),
		.tx_ack						(tx_arp_ack			)
    );

	fifo_ack_udp 					tx_udp_fifo(
		.rx_clk						(TX_CLK				),
		.rx_rst						(TX_RESET			),
		.rx_data					(UDP_DIN			),
		.rx_data_valid				(UDP_DIN_EN			),
		.tx_clk						(clk125			),
		.tx_rst						(tx_reset			),
		.tx_data					(tx_fifo_dout		),
		.tx_data_valid				(tx_fifo_dout_en	),
		.tx_ack						(tx_fifo_ack		),
		.prog_full					(udp_prog_full		)		
    );
    
	udp_send 						udp_send(
		.local_ip					(LOCAL_IP	 		),
		.local_mac					(LOCAL_MAC 			),
		.local_port					(16'h4e20			),
		.clk						(clk125			),
		.rst						(tx_reset			),
		.rx_data					(tx_fifo_dout		),
		.rx_data_valid				(tx_fifo_dout_en	),
		.rx_ack						(tx_fifo_ack		),
		.tx_data					(udp_dout			),
		.tx_data_valid				(udp_dout_en		),
		.tx_ack         			(udp_ack			)
    );
    
    tx_sel_new 						tx_sel(
		.clk						(clk125			),
		.rst						(tx_reset			),
		.udp_din					(udp_dout			),
		.udp_din_en					(udp_dout_en		),
		.udp_ack					(udp_ack			),
		.arp_din					(tx_arp_dout		),
		.arp_din_en					(tx_arp_dout_en		),
		.arp_ack					(tx_arp_ack			),
		.tx_dout					(mac_din			),
		.tx_dout_en					(mac_din_en			),
		.dst_fifo_pfull 			()
	);

	ip_tx_client_new 				ip_tx_client
	(        
		.clk_125					(clk125			),
		.reset						(tx_reset			),	
		.wr_data					(mac_din			),
		.wr_data_en					(mac_din_en			),
		.fifo_p_full				(),	
		.tx_data					(tx_data_i			),       
		.tx_data_valid				(tx_data_valid_i	), 
		.tx_ack						(tx_ack_i			),        		    
		.pcr_base_cnt 				(pcr_base_cnt		),
		.pcr_ext_cnt 				(pcr_ext_cnt		)
	);

//	test_bf_mac 					test_bf_mac_init
//	(
//	    .clk						(clk125			), 
//	    .data_in					(tx_data_i			), 
//	    .data_in_en					(tx_data_valid_i	), 
//	    .mac_ack					(tx_ack_i			), 
//	    .test_flag					(test_flag_bfmac	)
//    );

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	always @(posedge clk125)
	begin
		if (rx_reset)
		begin
			rx_data_r1       	<= 8'h00;
			rx_data_valid_r1     <= 1'b0;
			rx_good_frame_r1     <= 1'b0;
			rx_bad_frame_r1      <= 1'b0;
		end
		else
		begin
			rx_data_r1       	<= rx_data1_i		;
		    rx_data_valid_r1     <= rx_data_valid1_i  ;
		    rx_good_frame_r1     <= rx_good_frame1_i  ;
		    rx_bad_frame_r1      <= rx_bad_frame1_i   ;
		end
	end
	
	
	pcr_amend_front_sfp 			pcr_amend_front_sfp_init1
	(                       		
	    .clk						(clk125			), 
	    .rst						(rx_reset			), 
	    .pcr_din					(rx_data_r1       	), 
	    .pcr_din_en					(rx_data_valid_r1 	), 
	    .good_frame_in				(rx_good_frame_r1 	), 
	    .bad_frame_in				(rx_bad_frame_r1  	), 
	                    			
	    .pcr_base_cnt				(pcr_base_cnt		), 
	    .pcr_ext_cnt				(pcr_ext_cnt		), 
	                    			
	    .pcr_dout					(pcr_dout1			), 
	    .pcr_dout_en				(pcr_dout1_en		), 
	    .good_frame_out				(good_frame_out1		), 
	    .bad_frame_out				(bad_frame_out1		)
    );

   	// ----------- rx -------------------
	ram_4096byte 					rx_bram_4096byte1(
		.rx_clk						(clk125			),
		.rx_rst						(rx_reset			),
		
		.rx_data					(pcr_dout1		),
		.rx_data_valid				(pcr_dout1_en	),
		.rx_good					(good_frame_out1	),
		.rx_bad						(bad_frame_out1	),
		
		.tx_clk						(RX_CLK1				),
		.tx_rst						(RX_RESET1			),
		.tx_data					(rx_fifo_dout1		),
		.tx_data_valid  			(rx_fifo_dout1_en	)
	);

	udp_public 						udp_public1(
		.local_ip					(LOCAL1_IP	 		),
		.local_mac					(LOCAL1_MAC 			),
		.clk						(RX_CLK1				),
		.rst						(RX_RESET1			),
		.rx_data					(rx_fifo_dout1		),
		.rx_data_valid				(rx_fifo_dout1_en	),
		.tx_data					(udp_ts_dout1		    ),
		.tx_data_valid	    		(udp_ts_dout1_en		),
		
		.src_mac					(src_mac1			)
    );


	// ----------- tx -------------------
	fifo_ack 						tx_arp_fifo1(
		.rx_clk						(TX_CLK1				),
		.rx_rst						(TX_RESET1			),
		.rx_data					(TX_ARP1          	),
		.rx_data_valid				(TX_ARP1_EN		 	),
		.tx_clk						(clk125			),
		.tx_rst						(tx_reset			),
		.tx_data					(tx_arp_dout1		),
		.tx_data_valid				(tx_arp_dout1_en		),
		.tx_ack						(tx_arp_ack1			)
    );

	fifo_ack_udp 					tx_udp_fifo1(
		.rx_clk						(TX_CLK1				),
		.rx_rst						(TX_RESET1			),
		.rx_data					(UDP_DIN1			),
		.rx_data_valid				(UDP_DIN1_EN			),
		.tx_clk						(clk125			),
		.tx_rst						(tx_reset			),
		.tx_data					(tx_fifo_dout1		),
		.tx_data_valid				(tx_fifo_dout1_en	),
		.tx_ack						(tx_fifo_ack1		),
		.prog_full					(udp_prog1_full		)		
    );
    
	udp_send 						udp_send1(
		.local_ip					(LOCAL1_IP	 		),
		.local_mac					(LOCAL1_MAC 			),
		.local_port					(16'h4e20			),
		.clk						(clk125			),
		.rst						(tx_reset			),
		.rx_data					(tx_fifo_dout1		),
		.rx_data_valid				(tx_fifo_dout1_en	),
		.rx_ack						(tx_fifo_ack1		),
		.tx_data					(udp_dout1			),
		.tx_data_valid				(udp_dout1_en		),
		.tx_ack         			(udp_ack1			)
    );
    
    tx_sel_new 						tx_sel1(
		.clk						(clk125			),
		.rst						(tx_reset			),
		.udp_din					(udp_dout1			),
		.udp_din_en					(udp_dout1_en		),
		.udp_ack					(udp_ack1			),
		.arp_din					(tx_arp_dout1		),
		.arp_din_en					(tx_arp_dout1_en		),
		.arp_ack					(tx_arp_ack1			),
		.tx_dout					(mac_din1			),
		.tx_dout_en					(mac_din1_en			),
		.dst_fifo_pfull 			()
	);

	ip_tx_client_new 				ip_tx_client1
	(        
		.clk_125					(clk125			),
		.reset						(tx_reset			),	
		.wr_data					(mac_din1			),
		.wr_data_en					(mac_din1_en			),
		.fifo_p_full				(),	
		.tx_data					(tx_data1_i			),       
		.tx_data_valid				(tx_data_valid1_i	), 
		.tx_ack						(tx_ack1_i			),        		    
		.pcr_base_cnt 				(pcr_base_cnt		),
		.pcr_ext_cnt 				(pcr_ext_cnt		)
	);
endmodule