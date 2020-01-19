`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:38:48 02/05/2012 
// Design Name: 
// Module Name:    cmd_125_8b_rtn 
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
module cmd_125_8b_rtn
(
	input				clk			,
	input				rst			,
	input		[7:0]	rx_din		,
	input				rx_din_en	,
	
	input				tx_ack		,
	output	reg	[7:0]	tx_dout		,
	output	reg			tx_dout_en	
);

//-----------------------------------------------------
	reg		[7:0]	rx_din_r		;
	reg				rx_din_en_r		;
	reg				wr_en			;
	wire			wr_end			;

	//--------------------------------
	reg		[1:0]	wr_state		;
	reg		[1:0]	wr_nxt_state	;	
	
	parameter	WR_IDLE_S 	= 	2'd0;
	parameter	WR_DATA_S	=   2'd1;
	parameter	WR_OVER_S   =	2'd2;
	parameter	WR_END_S    =   2'd3;
	
	//----------------------------------
	reg		[1:0]	rd_state		;
	reg		[2:0]	rd_nxt_state	;
	
	parameter	RD_IDLE_S 	= 	2'd0;
	parameter	RD_WACK_S   =   2'd1;
	parameter	RD_DATA_S	=   2'd2;
	parameter	RD_DLY_S    =	2'd3;

	
	
//-----------------------------------------------------
	wire		prog_full			;
	reg			pack_cnt_inc		;
	reg			pack_cnt_dec		;
	reg	[7:0]	pack_cnt			;
	reg			pack_in_fifo		;

	wire [8:0]	rd_fifo_dout		;
	wire		rd_en               ;
//	reg	 [1:0]	rd_cnt				;
	reg	 [3:0]	rd_dly_cnt			;
	reg			rd_dly_end			;

//----------------------------------------------------
	assign	wr_end = rx_din_en == 0 && rx_din_en_r == 1;
	assign	rd_en  = (rd_nxt_state == RD_DATA_S)?1'b1:1'b0;
//---------------------------------------
	always @ (posedge clk)
	begin
		rx_din_r 	<= rx_din 	;
		rx_din_en_r	<= rx_din_en;		
	end
	
	always @ (posedge clk)
	begin
		if(rst)
			wr_state <= WR_IDLE_S;
		else	
			wr_state <= wr_nxt_state ;
	end
	
	
	always @ (wr_state or rx_din_en or rx_din_en_r or prog_full)
	begin
		case(wr_state)
			WR_IDLE_S:
				if(rx_din_en == 1'b1 && rx_din_en_r == 1'b0)
				begin
					if(prog_full)
						wr_nxt_state <= WR_OVER_S ;
					else
						wr_nxt_state <= WR_DATA_S ;
				end
				else
					wr_nxt_state <= WR_IDLE_S;
			
			WR_DATA_S:
				if(rx_din_en == 1'b0)
					wr_nxt_state <= WR_END_S;
				else
					wr_nxt_state <= WR_DATA_S;
			WR_OVER_S:
				if(rx_din_en == 1'b0)
					wr_nxt_state <= WR_END_S;
				else
					wr_nxt_state <= WR_OVER_S;
			WR_END_S :			
				wr_nxt_state <= WR_IDLE_S;						
		default: wr_nxt_state <= WR_IDLE_S;		
		endcase
	end
	
	always @ (posedge clk)
	begin
		if(wr_nxt_state == WR_DATA_S)
			wr_en <= 1;
		else	
			wr_en <= 0;		
	end

	always @ (posedge clk)
	begin
		if(wr_en == 1 && wr_end == 1)	
			pack_cnt_inc <= 1;
		else
			pack_cnt_inc <= 0;
	end
	
	always @ (posedge clk)
	begin
		if(rd_state == RD_WACK_S && rd_nxt_state == RD_DATA_S)	
			pack_cnt_dec <= 1;
		else
			pack_cnt_dec <= 0;
	end
	
	always @ (posedge clk)
	begin
		if(empty == 1'b1)
			pack_cnt <= 1'b0;	
		else if(pack_cnt_inc == 1 && pack_cnt_dec == 1'b0)
			pack_cnt <= pack_cnt + 1;
		else if(pack_cnt_inc == 0 && pack_cnt_dec == 1'b1)
		begin
			if(pack_cnt == 0)
				pack_cnt <= pack_cnt;
			else
				pack_cnt <= pack_cnt - 1;
		end
		else
			pack_cnt	<= pack_cnt;
	end
	
	always @ (posedge clk)
	begin
		if(empty == 1'b1 || pack_cnt == 0)
			pack_in_fifo <= 1'b0;	
		else 
			pack_in_fifo <= 1'b1;			
	end
	
	
	always @ (posedge clk)
	begin
		if(rst)
			rd_state <= RD_IDLE_S 	 ;
		else	
			rd_state <= rd_nxt_state ;
	end
	
	always @ (rd_state or pack_in_fifo or tx_ack or rd_fifo_dout[8])
	begin
		case(rd_state)	
			RD_IDLE_S :
				if(pack_in_fifo)
					rd_nxt_state <= RD_WACK_S ;
				else
					rd_nxt_state <= RD_IDLE_S ;	
			RD_WACK_S:
				if(tx_ack)
					rd_nxt_state <= RD_DATA_S ;
				else
					rd_nxt_state <= RD_WACK_S ;				
			RD_DATA_S :	
				if(rd_fifo_dout[8])	
					rd_nxt_state <= RD_DLY_S  ;
				else
					rd_nxt_state <= RD_DATA_S ;	
			RD_DLY_S:
				if(rd_dly_end)
					rd_nxt_state <= RD_IDLE_S ;
				else
					rd_nxt_state <= RD_DLY_S ;
					
			default: rd_nxt_state <= RD_IDLE_S	;
		endcase
	end
	
//	always @ (posedge clk)
//	begin
//		if(rd_nxt_state == RD_DATA_S)
//			rd_cnt <= rd_cnt + 1;
//		else	
//			rd_cnt <= 0;		
//	end
	
	always @ (posedge clk)
	begin
		if(rd_nxt_state == RD_DLY_S)
			rd_dly_cnt <= rd_dly_cnt + 1;
		else
			rd_dly_cnt <= 0;
	end	
	
	always @ (posedge clk)
	begin
		if(rd_nxt_state == RD_DLY_S && rd_dly_cnt == 4'd8)
			rd_dly_end <= 1;
		else	
			rd_dly_end <= 0;
	end
	
	always @ (posedge clk)
	begin
		if(rd_state == RD_DATA_S)
			tx_dout <= rd_fifo_dout[7:0];
		else
			tx_dout 	<= 0;
	end
	
	always @ (posedge clk)
	begin
		if(rd_state == RD_WACK_S || rd_state == RD_DATA_S)
			tx_dout_en 	<= 1'b1;
		else
			tx_dout_en 	<= 1'b0;
	end
	
	fifo_9_2048 	fifo_9_2048_init
	(
		.clk		(clk			),
		.rst		(rst			),
		.din		({wr_end,rx_din_r}), 
		.wr_en		(wr_en			),
		
		.rd_en		(rd_en			),
		.dout		(rd_fifo_dout	), 
		.full		(			),
		.empty		(empty			),
		.prog_full	(prog_full		)
	);
	
	
endmodule

