`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:36:20 08/02/2011 
// Design Name: 
// Module Name:    sfp_s_top 
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
module sfp_s_top(
	input				rocket_refclk		,
	input				clk125				,
	input				RESET				,
	output				txoutclk			,
	output				resetdone_i			,
	input				mmcm_locked			,
	input				userclk				,
	input				userclk2			,

	input				pma_reset_i		    ,
	input 				independent_clock	,
	
	input				clk_27m				,
	                    
	output	[1:0]		TXP				    ,
	output	[1:0]		TXN				    ,
	input	[1:0]		RXP				    ,
	input	[1:0]		RXN				    ,
    
	input	[31:0]		local0_ip			,
	input	[47:0]		local0_mac			,
    input				rx_clk_0			,
    input				rx_rst_0			,
    output	[7:0]		udp_dout_0			,
    output				udp_dout_en_0	    ,
   
    output	[7:0]		arp_dout_0			,
    output				arp_dout_en_0	    ,
    input				tx_clk_0			,
    input				tx_rst_0			,
    input	[7:0]		udp_din_0			,
    input				udp_din_en_0		,
    input	[7:0]		arp_din_0			,
    input				arp_din_en_0		,
    output				udp_prog_full_0		,
                        
	input	[31:0]		local1_ip			,
	input	[47:0]		local1_mac			,
    input				rx_clk_1			,
    input				rx_rst_1			,
    output	[7:0]		udp_dout_1			,
    output				udp_dout_en_1	    ,
   
    output	[7:0]		arp_dout_1			,
    output				arp_dout_en_1	    ,
    input				tx_clk_1			,
    input				tx_rst_1			,
    input	[7:0]		udp_din_1			,
    input				udp_din_en_1		,
    input	[7:0]		arp_din_1			,
    input				arp_din_en_1		,
    output				udp_prog_full_1		,
    output				test_flag			
    );

	wire	[32:0]			pcr_base_cnt0	;
	wire	[8:0]			pcr_ext_cnt0    ;
	
	wire	[32:0]			pcr_base_cnt1	;
	wire	[8:0]			pcr_ext_cnt1    ;

	wire			test_flag_sfp0,test_flag_sfp1;
	assign	test_flag = test_flag_sfp0 & test_flag_sfp1 ;


	// receive -------------------------------------
	pcr_cnt  							pcr_cnt_init_0
    (                           		
    	.clk_main_a						(clk125			),
    	.clk_27m						(clk_27m		),
                     	        		
    	.pcr_base_cnt					(pcr_base_cnt0	), 
    	.pcr_ext_cnt					(pcr_ext_cnt0	)   
    );
    
    sfp_translation_ip_s    udp_sfp_0(  
		.LOCAL_IP	 	                (local0_ip		),
        .LOCAL_MAC 						(local0_mac		),
		.ROCKET_REFCLK					(rocket_refclk	),  
		.independent_clock				(independent_clock),      
	    .PMA_RESET						(pma_reset_i	),
	    .RESET							(RESET			), 	                                	                   
		.txoutclk						(txoutclk),
 	    .resetdone_i					(resetdone_i),
 	    .mmcm_locked					(mmcm_locked),
 	    .userclk						(userclk),
 	    .userclk2						(userclk2),
 	                          	                        
	    .TXP							(TXP),               
	    .TXN							(TXN),               
	    .RXP							(RXP),               
	    .RXN							(RXN),  
	    
	    .clk125							(clk125	),
		
		.RX_CLK			    			(rx_clk_0		),
        .RX_RESET		                (rx_rst_0		),
		.udp_ts_dout		    		(udp_dout_0		),
		.udp_ts_dout_en	  				(udp_dout_en_0	),

		.rx_fifo_dout	    			(arp_dout_0		),
		.rx_fifo_dout_en				(arp_dout_en_0	),
		.TX_CLK			    			(tx_clk_0		),
		.TX_RESET		                (tx_rst_0		),
		.UDP_DIN						(udp_din_0		),
		.UDP_DIN_EN	  	    			(udp_din_en_0	),
		.TX_ARP             			(arp_din_0		),
		.TX_ARP_EN		    			(arp_din_en_0	),

		.src_mac						(src_mac_0		),
		.udp_prog_full					(udp_prog_full_0),
		.pcr_base_cnt					(pcr_base_cnt0	),
		.pcr_ext_cnt					(pcr_ext_cnt0	),
		.test_flag						(test_flag_sfp0 ),

		.LOCAL1_IP	 	                (local1_ip		),
        .LOCAL1_MAC 					(local1_mac		),
		.RX_CLK1			    		(rx_clk_1		),
        .RX_RESET1		                (rx_rst_1		),
		.udp_ts_dout1		    		(udp_dout_1		),
		.udp_ts_dout1_en	  			(udp_dout_en_1	),    
		.rx_fifo_dout1	    			(arp_dout_1		),
		.rx_fifo_dout1_en				(arp_dout_en_1	),
		.TX_CLK1			    		(tx_clk_1		),
		.TX_RESET1		                (tx_rst_1		),
		.UDP_DIN1						(udp_din_1		),
		.UDP_DIN1_EN	  	    		(udp_din_en_1	),
		.TX_ARP1             			(arp_din_1		),
		.TX_ARP1_EN		    			(arp_din_en_1	),

		.src_mac1						(src_mac_1		),                                        
		.udp_prog1_full					(udp_prog_full_1),
		.test_flag1						(test_flag_sfp1 )      
				                                 
	);
    

    
endmodule
    
    