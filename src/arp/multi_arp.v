`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:16:09 05/21/2011 
// Design Name: 
// Module Name:    multi_arp 
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
module multi_arp(
	
	tx_seek_ip,
	tx_seek_mac,
	tx_seek_en,
	tx_seek_del,
	
	tx_re1,
	tx_re1_en,
	    
	tx_re2,
	tx_re2_en,
	    
	tx_re3,
	tx_re3_en,
	    
	tx_re4,
	tx_re4_en,

	
	tx_arp1_ready,
	tx_arp2_ready,
	tx_arp3_ready,
	tx_arp4_ready,
	

	rx_seek_ip,
	rx_seek_netport,
	rx_seek_en,
	
	rx_re1,
	rx_re1_en,
	
	rx_re2,
	rx_re2_en,
	
	rx_re3,
	rx_re3_en,
	
	rx_re4,
	rx_re4_en,
	
	
	rx_arp1_ack,
	rx_arp2_ack,
	rx_arp3_ack,
	rx_arp4_ack,
	

	local1_ip,
	local1_mac,
	
	local2_ip,
	local2_mac,
	
	local3_ip,
	local3_mac,
	
	local4_ip,
	local4_mac,
	

	
	rst,
	clk
	
    );
    
	output	[31:0]	tx_seek_ip;
	output	[47:0]	tx_seek_mac;     
	output			tx_seek_en;      
	output			tx_seek_del;     
	
	output	[7:0]	tx_re1;      
	output			tx_re1_en;
		              
	output	[7:0]	tx_re2;      
	output			tx_re2_en;
	
	output	[7:0]	tx_re3;      
	output			tx_re3_en;
		              
	output	[7:0]	tx_re4;      
	output			tx_re4_en;
	
	
	output			tx_arp1_ready;
	output			tx_arp2_ready;
	output			tx_arp3_ready;
	output			tx_arp4_ready;
	
		                 
	input	[31:0]	rx_seek_ip;      
	input	[23:0]	rx_seek_netport; 
	input			rx_seek_en;
	
	input	[7:0]	rx_re1;    
	input			rx_re1_en;
			            
	input	[7:0]	rx_re2;    
	input			rx_re2_en;
	
	input	[7:0]	rx_re3;    
	input			rx_re3_en;
			            
	input	[7:0]	rx_re4;    
	input			rx_re4_en;
	
	
	
	input			rx_arp1_ack;
	input			rx_arp2_ack;
	input			rx_arp3_ack;
	input			rx_arp4_ack;
	
	input	[31:0]	local1_ip;       
	input	[47:0]	local1_mac;      
		                 
	input	[31:0]	local2_ip;       
	input	[47:0]	local2_mac;      
	
	input	[31:0]	local3_ip;       
	input	[47:0]	local3_mac;
	
	input	[31:0]	local4_ip;       
	input	[47:0]	local4_mac;
	

			                 
	input			rst;             
	input			clk;             
    
	wire	[9:0]	seek_hash2lut_addr;
	wire	[9:0]	mux_hash2ram_addr;
	
	wire	[31:0]	lut2req_ip;
	wire	[23:0]	lut2req_netport;
	wire			lut2req_en;
	
	wire	[31:0]	fade2req_ip;
	wire	[23:0]	fade2req_netport;
	wire			fade2req_en;
	
	wire	[31:0]	fade2mux_ip;
	wire			fade2mux_en;
	
	wire	[23:0]	mux2ram_netport;
	wire	[31:0]	mux2ram_ip;
	wire	[47:0]	mux2ram_mac;
	wire			mux2ram_en;
	
	wire 	[31:0]	res12mux_ip;
	wire	[47:0]	res12mux_mac;
	wire			res12mux_en;
	
	wire 	[31:0]	res22mux_ip;
	wire	[47:0]	res22mux_mac;
	wire			res22mux_en;
	
	wire 	[31:0]	res32mux_ip;
	wire	[47:0]	res32mux_mac;
	wire			res32mux_en;
	
	wire 	[31:0]	res42mux_ip;
	wire	[47:0]	res42mux_mac;
	wire			res42mux_en;
	
	wire 	[31:0]	res52mux_ip;
	wire	[47:0]	res52mux_mac;
	wire			res52mux_en;
	
	wire 	[31:0]	res62mux_ip;
	wire	[47:0]	res62mux_mac;
	wire			res62mux_en;
	
	wire 	[31:0]	res72mux_ip;
	wire	[47:0]	res72mux_mac;
	wire			res72mux_en;
	
	wire 	[31:0]	res82mux_ip;
	wire	[47:0]	res82mux_mac;
	wire			res82mux_en;
	
	wire 	[31:0]	res92mux_ip;
	wire	[47:0]	res92mux_mac;
	wire			res92mux_en;
	
	wire 	[31:0]	res102mux_ip;
	wire	[47:0]	res102mux_mac;
	wire			res102mux_en;
	
	wire 	[31:0]	res112mux_ip;
	wire	[47:0]	res112mux_mac;
	wire			res112mux_en;
	
	wire 	[31:0]	res122mux_ip;
	wire	[47:0]	res122mux_mac;
	wire			res122mux_en;
	
	wire 	[31:0]	res132mux_ip;
	wire	[47:0]	res132mux_mac;
	wire			res132mux_en;
	
	wire 	[31:0]	res142mux_ip;
	wire	[47:0]	res142mux_mac;
	wire			res142mux_en;
	
	wire 	[31:0]	res152mux_ip;
	wire	[47:0]	res152mux_mac;
	wire			res152mux_en;
	
	wire 	[31:0]	res162mux_ip;
	wire	[47:0]	res162mux_mac;
	wire			res162mux_en;
	
	wire 	[31:0]	res172mux_ip;
	wire	[47:0]	res172mux_mac;
	wire			res172mux_en;
	
	wire 	[31:0]	res182mux_ip;
	wire	[47:0]	res182mux_mac;
	wire			res182mux_en;
	
	wire 	[31:0]	res192mux_ip;
	wire	[47:0]	res192mux_mac;
	wire			res192mux_en;
	
	wire 	[31:0]	res202mux_ip;
	wire	[47:0]	res202mux_mac;
	wire			res202mux_en;
	
	wire	[7:0]	req2remux_data;
	wire			req12remux_en;
	wire			req22remux_en;
	wire			req32remux_en;
	wire			req42remux_en;
	wire			req52remux_en;
	wire			req62remux_en;
	wire			req72remux_en;
	wire			req82remux_en;
	wire			req92remux_en;
	wire			req102remux_en;
	wire			req112remux_en;
	wire			req122remux_en;
	wire			req132remux_en;
	wire			req142remux_en;
	wire			req152remux_en;
	wire			req162remux_en;
	wire			req172remux_en;
	wire			req182remux_en;
	wire			req192remux_en;
	wire			req202remux_en;
	
	wire	[7:0]	res12remux_data;
	wire			res12remux_en;
	
	wire	[7:0]	res22remux_data;	
	wire			res22remux_en;
	
	wire	[7:0]	res32remux_data;	
	wire			res32remux_en;  
	
	wire	[7:0]	res42remux_data;	
	wire			res42remux_en; 
	
	wire	[7:0]	res52remux_data;	
	wire			res52remux_en; 
	
	wire	[7:0]	res62remux_data;	
	wire			res62remux_en; 
	
	wire	[7:0]	res72remux_data;	
	wire			res72remux_en; 
	
	wire	[7:0]	res82remux_data;	
	wire			res82remux_en;
	
	wire	[7:0]	res92remux_data;	
	wire			res92remux_en; 
	
	wire	[7:0]	res102remux_data;	
	wire			res102remux_en; 
	
	wire	[7:0]	res112remux_data;	
	wire			res112remux_en; 
	
	wire	[7:0]	res122remux_data;	
	wire			res122remux_en;
	
	wire	[7:0]	res132remux_data;	
	wire			res132remux_en; 
	
	wire	[7:0]	res142remux_data;	
	wire			res142remux_en; 
	
	wire	[7:0]	res152remux_data;	
	wire			res152remux_en; 
	
	wire	[7:0]	res162remux_data;	
	wire			res162remux_en;
	
	wire	[7:0]	res172remux_data;	
	wire			res172remux_en; 
	
	wire	[7:0]	res182remux_data;	
	wire			res182remux_en; 
	
	wire	[7:0]	res192remux_data;	
	wire			res192remux_en; 
	
	wire	[7:0]	res202remux_data;	
	wire			res202remux_en; 
	
	wire			res1_ready;
	wire			res2_ready;
	wire			res3_ready;
	wire			res4_ready; 
	wire			res5_ready;
	wire			res6_ready;
	wire			res7_ready;
	wire			res8_ready;
	wire			res9_ready;
	wire			res10_ready;
	wire			res11_ready;
	wire			res12_ready;
	wire			res13_ready;
	wire			res14_ready;
	wire			res15_ready;
	wire			res16_ready;
	wire			res17_ready;
	wire			res18_ready;
	wire			res19_ready;
	wire			res20_ready;

	wire			req1_ready;
	wire			req2_ready; 
	wire			req3_ready;
	wire			req4_ready;
	wire			req5_ready;
	wire			req6_ready;
	wire			req7_ready;
	wire			req8_ready;
	wire			req9_ready;
	wire			req10_ready;
	wire			req11_ready;
	wire			req12_ready;
	wire			req13_ready;
	wire			req14_ready;
	wire			req15_ready;
	wire			req16_ready;
	wire			req17_ready;
	wire			req18_ready;
	wire			req19_ready;
	wire			req20_ready;
	
	wire			res1_ack;
	wire			res2_ack;
	wire			res3_ack;
	wire			res4_ack;
	wire			res5_ack;
	wire			res6_ack;
	wire			res7_ack;
	wire			res8_ack;
	wire			res9_ack;
	wire			res10_ack;
	wire			res11_ack;
	wire			res12_ack;
	wire			res13_ack;
	wire			res14_ack;
	wire			res15_ack;
	wire			res16_ack;
	wire			res17_ack;
	wire			res18_ack;
	wire			res19_ack;
	wire			res20_ack;
	
	wire			req1_ack;
	wire			req2_ack;
	wire			req3_ack;
	wire			req4_ack;
	wire			req5_ack;
	wire			req6_ack;
	wire			req7_ack;
	wire			req8_ack;
	wire			req9_ack;
	wire			req10_ack;
	wire			req11_ack;
	wire			req12_ack;
	wire			req13_ack;
	wire			req14_ack;
	wire			req15_ack;
	wire			req16_ack;
	wire			req17_ack;
	wire			req18_ack;
	wire			req19_ack;
	wire			req20_ack;

hash	seek_hash_inst
	(
	
    .data				(rx_seek_ip			),
    .dvald				(rx_seek_en			),
    .addr				(seek_hash2lut_addr	),
    
    .reset				(rst				)
    
    );
    
lut_netport_ip_mac	lut_netport_ip_mac_inst
	(

	.tx_ip				(tx_seek_ip			),
	.tx_mac				(tx_seek_mac		),
	.tx_en				(tx_seek_en			),
	.tx_del_en			(tx_seek_del		),
                      
	.tx_req_ip			(lut2req_ip			),
	.tx_req_netport		(lut2req_netport	),
	.tx_req_en			(lut2req_en			),
                      
	.rx_wr_ip			(mux2ram_ip       	),
	.rx_wr_mac			(mux2ram_mac     	),
	.rx_wr_addr			(mux_hash2ram_addr	),
	.rx_wr_en			(mux2ram_en      	),
                        
	.rx_seek_ip			(rx_seek_ip			),
	.rx_seek_netport	(rx_seek_netport	),
	.rx_seek_addr		(seek_hash2lut_addr	),
	.rx_seek_en			(rx_seek_en			),
                        
	.rst				(rst				),
	.clk				(clk				)

	//.rd_current
          
	);
	
res_mux_20	res_mux_20_inst
	(
		
	.rx_port1_ip		(res12mux_ip		),
	.rx_port1_mac		(res12mux_mac		),
	.rx_port1_en		(res12mux_en		),

	.rx_port2_ip		(res22mux_ip		),
	.rx_port2_mac		(res22mux_mac		),
	.rx_port2_en		(res22mux_en		),
	
	.rx_port3_ip		(res32mux_ip		),
	.rx_port3_mac		(res32mux_mac		),
	.rx_port3_en		(res32mux_en		),
	
	.rx_port4_ip		(res42mux_ip		),
	.rx_port4_mac		(res42mux_mac		),
	.rx_port4_en		(res42mux_en		),
	
	.rx_port5_ip		(res52mux_ip		),
	.rx_port5_mac		(res52mux_mac		),
	.rx_port5_en		(res52mux_en		),
	
	.rx_port6_ip		(res62mux_ip		),
	.rx_port6_mac		(res62mux_mac		),
	.rx_port6_en		(res62mux_en		),
	
	.rx_port7_ip		(res72mux_ip		),
	.rx_port7_mac		(res72mux_mac		),
	.rx_port7_en		(res72mux_en		),
	
	.rx_port8_ip		(res82mux_ip		),
	.rx_port8_mac		(res82mux_mac		),
	.rx_port8_en		(res82mux_en		),
	
	.rx_port9_ip		(res92mux_ip		),
	.rx_port9_mac		(res92mux_mac		),
	.rx_port9_en		(res92mux_en		),
	
	.rx_port10_ip		(res102mux_ip		),
	.rx_port10_mac		(res102mux_mac		),
	.rx_port10_en		(res102mux_en		),
	
	.rx_port11_ip		(res112mux_ip		),
	.rx_port11_mac		(res112mux_mac		),
	.rx_port11_en		(res112mux_en		),
	
	.rx_port12_ip		(res122mux_ip		),
	.rx_port12_mac		(res122mux_mac		),
	.rx_port12_en		(res122mux_en		),
	
	.rx_port13_ip		(res132mux_ip		),
	.rx_port13_mac		(res132mux_mac		),
	.rx_port13_en		(res132mux_en		),
	
	.rx_port14_ip		(res142mux_ip		),
	.rx_port14_mac		(res142mux_mac		),
	.rx_port14_en		(res142mux_en		),
	
	.rx_port15_ip		(res152mux_ip		),
	.rx_port15_mac		(res152mux_mac		),
	.rx_port15_en		(res152mux_en		),
	
	.rx_port16_ip		(res162mux_ip		),
	.rx_port16_mac		(res162mux_mac		),
	.rx_port16_en		(res162mux_en		),
	
	.rx_port17_ip		(res172mux_ip		),
	.rx_port17_mac		(res172mux_mac		),
	.rx_port17_en		(res172mux_en		),
	
	.rx_port18_ip		(res182mux_ip		),
	.rx_port18_mac		(res182mux_mac		),
	.rx_port18_en		(res182mux_en		),
	
	.rx_port19_ip		(res192mux_ip		),
	.rx_port19_mac		(res192mux_mac		),
	.rx_port19_en		(res192mux_en		),
	
	.rx_port20_ip		(res202mux_ip		),
	.rx_port20_mac		(res202mux_mac		),
	.rx_port20_en		(res202mux_en		),

	.rx_del_ip			(fade2mux_ip		),
	.rx_del_en			(fade2mux_en		),
	
	.tx_netport			(mux2ram_netport	),
	.tx_ip				(mux2ram_ip       	),
	.tx_mac				(mux2ram_mac     	),
	.tx_en				(mux2ram_en			),
	
	.rst				(rst				),
	.clk				(clk				)
		
    );
    
hash	mux_hash_inst
	(
	
    .data				(mux2ram_ip       	),
    .dvald				(mux2ram_en			),
    .addr				(mux_hash2ram_addr	),
    
    .reset				(rst				)
    
    );

arp_fade	arp_fade_inst
	(

	.tx_req_netport		(fade2req_netport   ),
	.tx_req_ip			(fade2req_ip		),
	.tx_req_en			(fade2req_en		),
                    	
	.tx_del_ip			(fade2mux_ip		),
	.tx_del_en			(fade2mux_en		),
                    	
	.rx_wr_netport		(mux2ram_netport	),
	.rx_wr_ip			(mux2ram_ip       	),
	.rx_wr_addr			(mux_hash2ram_addr	),
	.rx_wr_en			(mux2ram_en			),
                    	
	.rst				(rst				),
	.clk				(clk				) 
	
    );
    
arp_request_20	arp_request_20_inst
	(
	
	.tx_data			(req2remux_data		),
	.tx_data1_en		(req12remux_en		),
	.tx_data2_en		(req22remux_en		),
	.tx_data3_en		(req32remux_en		),
	.tx_data4_en		(req42remux_en		),
	.tx_data5_en		(req52remux_en		),
	.tx_data6_en		(req62remux_en		),
	.tx_data7_en		(req72remux_en		),
	.tx_data8_en		(req82remux_en		),
	.tx_data9_en		(req92remux_en		),
	.tx_data10_en		(req102remux_en		),
	.tx_data11_en		(req112remux_en		),
	.tx_data12_en		(req122remux_en		),
	.tx_data13_en		(req132remux_en		),
	.tx_data14_en		(req142remux_en		),
	.tx_data15_en		(req152remux_en		),
	.tx_data16_en		(req162remux_en		),
	.tx_data17_en		(req172remux_en		),
	.tx_data18_en		(req182remux_en		),
	.tx_data19_en		(req192remux_en		),
	.tx_data20_en		(req202remux_en		),

	.req1_ready			(req1_ready			),
	.req2_ready			(req2_ready			),
	.req3_ready			(req3_ready			),
	.req4_ready			(req4_ready			),
	.req5_ready			(req5_ready			),
	.req6_ready			(req6_ready			),
	.req7_ready			(req7_ready			),
	.req8_ready			(req8_ready			),
	.req9_ready			(req9_ready			),
	.req10_ready		(req10_ready		),
	.req11_ready		(req11_ready		),
	.req12_ready		(req12_ready		),
	.req13_ready		(req13_ready		),
	.req14_ready		(req14_ready		),
	.req15_ready		(req15_ready		),
	.req16_ready		(req16_ready		),
	.req17_ready		(req17_ready		),
	.req18_ready		(req18_ready		),
	.req19_ready		(req19_ready		),
	.req20_ready		(req20_ready		),

	.req1_ack			(req1_ack			),
	.req2_ack			(req2_ack			),
	.req3_ack			(req3_ack			),
	.req4_ack			(req4_ack			),
	.req5_ack			(req5_ack			),
	.req6_ack			(req6_ack			),
	.req7_ack			(req7_ack			),
	.req8_ack			(req8_ack			),
	.req9_ack			(req9_ack			),
	.req10_ack			(req10_ack			),
	.req11_ack			(req11_ack			),
	.req12_ack			(req12_ack			),
	.req13_ack			(req13_ack			),
	.req14_ack			(req14_ack			),
	.req15_ack			(req15_ack			),
	.req16_ack			(req16_ack			),
	.req17_ack			(req17_ack			),
	.req18_ack			(req18_ack			),
	.req19_ack			(req19_ack			),
	.req20_ack			(req20_ack			),

	.local1_ip			(local1_ip			),
	.local1_mac			(local1_mac 		),
	          		
	.local2_ip			(local2_ip			),
	.local2_mac			(local2_mac 		),
	           		
	.local3_ip			(local3_ip			),
	.local3_mac			(local3_mac 		),
	           		
	.local4_ip			(local4_ip			),
	.local4_mac			(local4_mac 		),
	          		
	.local5_ip			(local5_ip			),
	.local5_mac			(local5_mac 		),
	          		
	.local6_ip			(local6_ip			),
	.local6_mac			(local6_mac 		),
	           		
	.local7_ip			(local7_ip			),
	.local7_mac			(local7_mac 		),

	.local8_ip			(local8_ip			),
	.local8_mac			(local8_mac 		),
	
	.local9_ip			(local9_ip			),
	.local9_mac			(local9_mac 		),
	          		
	.local10_ip			(local10_ip			),
	.local10_mac		(local10_mac 		),
	           		
	.local11_ip			(local11_ip			),
	.local11_mac		(local11_mac 		),

	.local12_ip			(local12_ip			),
	.local12_mac		(local12_mac 		),
	
	.local13_ip			(local13_ip			),
	.local13_mac		(local13_mac 		),
	          		
	.local14_ip			(local14_ip			),
	.local14_mac		(local14_mac 		),
	           		
	.local15_ip			(local15_ip			),
	.local15_mac		(local15_mac 		),

	.local16_ip			(local16_ip			),
	.local16_mac		(local16_mac 		),
	
	.local17_ip			(local17_ip			),
	.local17_mac		(local17_mac 		),
	          		
	.local18_ip			(local18_ip			),
	.local18_mac		(local18_mac 		),
	           		
	.local19_ip			(local19_ip			),
	.local19_mac		(local19_mac 		),

	.local20_ip			(local20_ip			),
	.local20_mac		(local20_mac 		),
	
	.rx_lut_netport		(lut2req_netport	),
	.rx_lut_ip			(lut2req_ip			),
	.rx_lut_ip_en		(lut2req_en			),
	                   
	.rx_fade_netport	(fade2req_netport   ),
	.rx_fade_ip			(fade2req_ip		),
	.rx_fade_ip_en		(fade2req_en		),
                        
	.rst				(rst				),
	.clk				(clk				)
	
    );
    
arp_responsion_ack	arp_responsion_ack_inst1
	(
	
	.arp_dout			(res12remux_data	),
	.arp_dout_en		(res12remux_en		),
	                	
	.tx_ip				(res12mux_ip		), 
	.tx_mac				(res12mux_mac		),
	.tx_en				(res12mux_en		),  
	                	
	.arp_din			(rx_re1		  	 	),
	.arp_din_en			(rx_re1_en			),
	                	
	.local_mac			(local1_mac			),
	.local_ip			(local1_ip			),
	                	
	.tx_ready			(res1_ready			),
	.rx_ack				(res1_ack			),
	                	
	.rst				(rst				),
	.clk				(clk				)
	
    );
    
arp_responsion_ack	arp_responsion_ack_inst2
	(
	
	.arp_dout			(res22remux_data	),
	.arp_dout_en		(res22remux_en		),
	                	
	.tx_ip				(res22mux_ip		), 
	.tx_mac				(res22mux_mac		),
	.tx_en				(res22mux_en		),  
	                	
	.arp_din			(rx_re2		  	  	),
	.arp_din_en			(rx_re2_en			),
	                	
	.local_mac			(local2_mac			),
	.local_ip			(local2_ip			),
	                	
	.tx_ready			(res2_ready			),
	.rx_ack				(res2_ack			),
	                	
	.rst				(rst				),
	.clk				(clk				)
	
    );
    
arp_responsion_ack	arp_responsion_ack_inst3
	(
	
	.arp_dout			(res32remux_data	),
	.arp_dout_en		(res32remux_en		),
	                	
	.tx_ip				(res32mux_ip		), 
	.tx_mac				(res32mux_mac		),
	.tx_en				(res32mux_en		),  
	                	
	.arp_din			(rx_re3		  	 	),
	.arp_din_en			(rx_re3_en			),
	                	
	.local_mac			(local3_mac			),
	.local_ip			(local3_ip			),
	                	
	.tx_ready			(res3_ready			),
	.rx_ack				(res3_ack			),
	                	
	.rst				(rst				),
	.clk				(clk				)
	
    );
    
arp_responsion_ack	arp_responsion_ack_inst4
	(
	
	.arp_dout			(res42remux_data	),
	.arp_dout_en		(res42remux_en		),
	                	
	.tx_ip				(res42mux_ip		), 
	.tx_mac				(res42mux_mac		),
	.tx_en				(res42mux_en		),  
	                	
	.arp_din			(rx_re4		    	),
	.arp_din_en			(rx_re4_en			),
	                	
	.local_mac			(local4_mac			),
	.local_ip			(local4_ip			),
	                	
	.tx_ready			(res4_ready			),
	.rx_ack				(res4_ack			),
	                	
	.rst				(rst				),
	.clk				(clk				)
	
    );
    

    
coordinate_res_req	coordinate_res_req_inst1
	(
		
	.dout				(tx_re1			 	),
	.dout_en			(tx_re1_en			),
	                    
	.res_ack			(res1_ack			),
	.req_ack			(req1_ack			),			
			
	.tx_arp_ready		(tx_arp1_ready		),
                        
	.res_din			(res12remux_data	),
	.res_din_en			(res12remux_en		),
	                    
	.req_din			(req2remux_data		),
	.req_din_en			(req12remux_en		),
	                    
	.res_ready			(res1_ready			),
	.req_ready			(req1_ready			),
	                    
	.rx_arp_ack			(rx_arp1_ack		),
	                    
	.rst				(rst				),
	.clk				(clk				)         
	             
    );
    
coordinate_res_req	coordinate_res_req_inst2
	(
		
	.dout				(tx_re2			 	),
	.dout_en			(tx_re2_en			),
	                    
	.res_ack			(res2_ack			),
	.req_ack			(req2_ack			),			
			
	.tx_arp_ready		(tx_arp2_ready		),
                        
	.res_din			(res22remux_data	),
	.res_din_en			(res22remux_en		),
	                    
	.req_din			(req2remux_data		),
	.req_din_en			(req22remux_en		),
	                    
	.res_ready			(res2_ready			),
	.req_ready			(req2_ready			),
	                    
	.rx_arp_ack			(rx_arp2_ack		),
	                    
	.rst				(rst				),
	.clk				(clk				)         
	             
    );
    
coordinate_res_req	coordinate_res_req_inst3
	(
		
	.dout				(tx_re3			 	),
	.dout_en			(tx_re3_en			),
	                    
	.res_ack			(res3_ack			),
	.req_ack			(req3_ack			),			
			
	.tx_arp_ready		(tx_arp3_ready		),
                        
	.res_din			(res32remux_data	),
	.res_din_en			(res32remux_en		),
	                    
	.req_din			(req2remux_data		),
	.req_din_en			(req32remux_en		),
	                    
	.res_ready			(res3_ready			),
	.req_ready			(req3_ready			),
	                    
	.rx_arp_ack			(rx_arp3_ack		),
	                    
	.rst				(rst				),
	.clk				(clk				)         
	             
    );
    
coordinate_res_req	coordinate_res_req_inst4
	(
		
	.dout				(tx_re4			 	),
	.dout_en			(tx_re4_en			),
	                    
	.res_ack			(res4_ack			),
	.req_ack			(req4_ack			),			
			
	.tx_arp_ready		(tx_arp4_ready		),
                        
	.res_din			(res42remux_data	),
	.res_din_en			(res42remux_en		),
	                    
	.req_din			(req2remux_data		),
	.req_din_en			(req42remux_en		),
	                    
	.res_ready			(res4_ready			),
	.req_ready			(req4_ready			),
	                    
	.rx_arp_ack			(rx_arp4_ack		),
	                    
	.rst				(rst				),
	.clk				(clk				)         
	             
    );
    


endmodule
