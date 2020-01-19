`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:17:55 11/24/2008 
// Design Name: 
// Module Name:    csa_tx 
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
module csa_tx(
							clk_main,							
						  rst,	  							
						  ts_in_csa,
							en_in_csa,	
										
											
						  ts_out_csa_en_64,
						  ts_out_csa_64 							 
					);

  input					clk_main
  , rst;	 	
	input					en_in_csa; 	
	input[32:0]		ts_in_csa; 	
	
	output				ts_out_csa_en_64;
	output[32:0]		ts_out_csa_64;	 
    wire			en_out_csa;
    wire[8:0]		ts_out_csa;
	
	wire	[7:0]	ts_dout;
	wire			en_ts_dout;	
	wire 	[7:0]	pid_num;
	wire  		en_pid_num;
	wire 	[7:0]	gbe_num;
	wire  		en_gbe_num;
	wire 	[7:0]	ip_port;
	wire  		en_ip_port;
	wire	[7:0]	cw_data;
	wire			en_cw_data;	
	wire      		en_count_packet; 
	wire    [7:0] 	count_packet;
	wire			en_tsr;
	wire	[7:0]	tsr; 
	
	wire					finish_blk_enc;
	
	
	
		
	csa_pretreatment       m_csa_pretreatment
	(
    .clk_main                 (clk_main),  
		.rst                 (rst),
		
		.ts_din_en           (en_in_csa),
		.ts_din              (ts_in_csa),		
		.finish_blk_enc      (finish_blk_enc),
		
	
		.en_count_packet     (en_count_packet),
		.count_packet        (count_packet),
		.ts_dout         		(ts_dout),
		.en_ts_dout            (en_ts_dout),
		.pid_num(pid_num), 
		.en_pid_num(en_pid_num), 
		.gbe_num(gbe_num), 
		.en_gbe_num(en_gbe_num), 
		.ip_port(ip_port), 
		.en_ip_port(en_ip_port), 
		.cw_data			(cw_data),
		.en_cw_data			(en_cw_data)				
  );
	
	csa_blk_enc					m_csa_blk_enc
	(
		.clk							(clk_main),
		.rst							(rst),
		.en_count_packet  (en_count_packet),
		.count_packet     (count_packet),		
		.pid_num(pid_num), 
		.en_pid_num(en_pid_num), 
		.gbe_num(gbe_num), 
		.en_gbe_num(en_gbe_num), 
		.ip_port(ip_port), 
		.en_ip_port(en_ip_port), 
		.en_tsf			      (en_ts_dout),
		.tsf					    (ts_dout),
		.en_cwr					(en_cw_data),
		.cwr					(cw_data), 					 
		 
	
		.finish_blk_enc		(finish_blk_enc	),				
		.en_tsr						(en_tsr					),
		.tsr              (tsr            )
	);

 csa_strm_enc         m_csa_strm_enc
 (
		.clk							(clk_main				),
		.rst							(rst				),																	
		.en_tsr						(en_tsr			),
		.tsr							(tsr				),				
	

		.en_out_csa		  	(en_out_csa),
		.ts_out_csa  			(ts_out_csa)
	);
	
	ts_8to64 ts_8to64 (
    .clk_main(clk_main),     
    .rst(rst), 
    .ts_din(ts_out_csa), 
    .ts_din_en(en_out_csa), 
    .ts_dout(ts_out_csa_64), 
    .ts_dout_en(ts_out_csa_en_64)
    );
	
	
endmodule
