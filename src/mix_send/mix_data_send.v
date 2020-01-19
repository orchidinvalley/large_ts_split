`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:48 04/02/2011 
// Design Name: 
// Module Name:    xiugai 
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
module mix_data_send(
   	clk,
	rst,
	// head_num + 12 * head_num; ==>head_num + 9 * head_num;
	emm_head_din,
	emm_head_din_en,
	//9Пе + 188 bytes
	emm_din,
	emm_din_en,
	// 2B + 1byte sfp_num + 4 bytes ip + 2 bytes port + 188 bytes
	ts_din,
	ts_din_en,
	ddr_din,
	ddr_din_en,

	ts_dout,
	ts_dout_en
//	fifo_ts_full,
//	fifo_ddr_full
	
	);

	input			clk;
	input			rst;
	input	[7:0]	emm_head_din;
	input			emm_head_din_en;
	input	[7:0]	emm_din;
    input			emm_din_en;
	input	[32:0]	ts_din;
	input			ts_din_en;
    input	[8:0]	ddr_din;
    input			ddr_din_en;
	
	output	[31:0]	ts_dout;
	output			ts_dout_en;
//	output			fifo_ts_full;
//	output			fifo_ddr_full;

	
	wire			emm_head_dout_en;
	wire	[31:0]	emm_head_dout;
	wire			emm_body_dout_en;
	wire	[31:0]	emm_body_dout;
	wire			ddr_dout_en;
	wire	[32:0]	ddr_dout;
	wire	[5:0]	head_num;	
	
	
emm_ddr_8to32	code_8to32(
		.clk			(clk),
		.rst			(rst),
		.emm_head_din_en(emm_head_din_en),
		.emm_head_din	(emm_head_din	),
		.emm_body_din_en(emm_din_en		),
		.emm_body_din	(emm_din		),
		.ddr_din_en		(ddr_din_en		),
		.ddr_din		(ddr_din		),
		
		.emm_head_dout_en(emm_head_dout_en),
		.emm_head_dout	 (emm_head_dout	  ),
		.emm_body_dout_en(emm_body_dout_en),
		.emm_body_dout	 (emm_body_dout	  ),
		.ddr_dout_en	 (ddr_dout_en	  ),
		.ddr_dout		 (ddr_dout		  ),
		.head_num		 (head_num		  )
		);
		

		
		
data_mix	data_mix(
  	.clk		(clk),
	.rst		(rst),
	.emm_head_din	(emm_head_dout	 ),
	.emm_head_din_en(emm_head_dout_en),
	.emm_din		(emm_body_dout	 ),
	.emm_din_en		(emm_body_dout_en),
	.ts_din			(ts_din			),
	.ts_din_en		(ts_din_en		),
	.ddr_din		(ddr_dout		),
	.ddr_din_en		(ddr_dout_en	),
	.head_num		(head_num		),

	.ts_dout		(ts_dout		),
	.ts_dout_en		(ts_dout_en		)
//	.fifo_ts_full	(fifo_ts_full	),
//	.fifo_ddr_full	(fifo_ddr_full	)
	);	
endmodule
