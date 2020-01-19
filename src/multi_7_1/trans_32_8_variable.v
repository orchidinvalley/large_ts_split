`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:50:36 08/31/2011 
// Design Name: 
// Module Name:    trans_32_8_variable 
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
module trans_32_8_variable(

		dout_8bit,
		dout_8bit_en,
		
		din_32bit,
		din_32bit_en,
		
//		wr_current,
//		rd_current,
//		trans_cnt,
//		rd_fifo_en,
//		fifo_dout,
//		fifo_din,
		
		rst,
		clk
		
    );
    
    output	reg		[7:0]	dout_8bit;
	output	reg				dout_8bit_en;
	
	input			[31:0]	din_32bit;
	input					din_32bit_en;
	
	input					rst;
	input					clk;
	
//	output			[1:0]	wr_current;
//	output			[3:0]	rd_current;
//	output			[2:0]	trans_cnt;
//	output					rd_fifo_en;
//	output			[33:0]	fifo_dout;
//	output			[33:0]	fifo_din;
	
/*************************************************************************************/
//Write Fifo
	
	reg			[1:0]	wr_current;
	reg			[1:0]	wr_next;
	
	reg			[33:0]	fifo_din;
	reg					wr_fifo_en;
	reg					din_32bit_en_reg;
	
	wire				fifo_prog_full;
	
	parameter	WR_IDLE	= 2'd0,
				WR_HEAD	= 2'd1,
				WR_DATA	= 2'd2,
				WR_FIN	= 2'd3;
	
always@(posedge clk)
begin
	if(rst)
		din_32bit_en_reg <= 0;
	else
		din_32bit_en_reg <= din_32bit_en;
end
	
always@(posedge clk)
begin
	if(rst)
		wr_current <= WR_IDLE;
	else
		wr_current <= wr_next;
end
	
always@(wr_current or din_32bit_en or din_32bit_en_reg or fifo_prog_full)
begin
	case(wr_current)

		WR_IDLE:	if(din_32bit_en == 1'b1 && din_32bit_en_reg == 1'b0 && fifo_prog_full == 1'b0)
						wr_next = WR_HEAD;
					else
						wr_next = WR_IDLE;
					
		WR_HEAD:	wr_next = WR_DATA;
						
		WR_DATA:	if(din_32bit_en == 1'b0)
						wr_next = WR_FIN;
					else
						wr_next = WR_DATA;
						
		WR_FIN:		wr_next = WR_IDLE;
		
		default:	wr_next = WR_IDLE;
		
	endcase					
end

always@(posedge clk)
begin
	case(wr_next)
		WR_IDLE:	begin	wr_fifo_en <= 1'b0;	fifo_din <= 0;					end
		WR_HEAD:	begin	wr_fifo_en <= 1'b1;	fifo_din <= {2'b01,din_32bit};	end
		WR_DATA:	begin	wr_fifo_en <= 1'b1;	fifo_din <= {2'b00,din_32bit};	end
		WR_FIN:		begin	wr_fifo_en <= 1'b1;	fifo_din <= {2'b10,32'hffff};	end
		default:	begin	wr_fifo_en <= 1'b0;	fifo_din <= 0;					end
	endcase
end

/****************************************************************************************************/
//Transform 32-8

	reg			[2:0]	trans_cnt;
	reg					switch_sign;
	reg					rd_fifo_en;

	reg			[3:0]	rd_current;
	reg			[3:0]	rd_next;
	
	wire		[33:0]	fifo_dout;
	wire				fifo_empty;
	
	parameter	TRANS_PERIOD	= 3'd3;
	parameter	MAC_LOW16bit	= 3'd1;
	parameter	PORT_16BIT		= 3'd1;
	parameter	WAIT_MAX		= 3'd7;
	
	parameter	RD_IDLE		= 4'd0,
				RD_FIFO		= 4'd1,
				RD_CHECK	= 4'd2,
				TRANS_MAC_H	= 4'd3,
				TRANS_MAC_L	= 4'd4,
				TRANS_IP	= 4'd5,
				TRANS_PORT	= 4'd6,
				TRANS_DATA	= 4'd7,
				TRANS_WAIT	= 4'd8;

always@(posedge clk)
begin
	if(rst)
		rd_current <= RD_IDLE;
	else
		rd_current <= rd_next;
end

always@(rd_current or fifo_empty or fifo_dout[32] or fifo_dout[33] or switch_sign or trans_cnt)
begin
	case(rd_current)
		
		RD_IDLE:		if(fifo_empty == 1'b0)
							rd_next = RD_FIFO;
						else
							rd_next = RD_IDLE;
							
		RD_FIFO:		rd_next = RD_CHECK;
		            	
		RD_CHECK:		if(fifo_dout[32] == 1'b1)
							rd_next = TRANS_MAC_H;
						else
							rd_next = RD_FIFO;
						
		TRANS_MAC_H:	if(switch_sign == 1'b1)
							rd_next = TRANS_MAC_L;
						else
							rd_next = TRANS_MAC_H;
						
		TRANS_MAC_L:	if(switch_sign == 1'b1)
							rd_next = TRANS_IP;
						else
							rd_next = TRANS_MAC_L;
						
		TRANS_IP:		if(switch_sign == 1'b1)
							rd_next = TRANS_PORT;
						else
							rd_next = TRANS_IP;
		
		TRANS_PORT:		if(switch_sign == 1'b1)
							rd_next = TRANS_DATA;
						else
							rd_next = TRANS_PORT;
						
		TRANS_DATA:		if(fifo_dout[33] == 1'b1)
							rd_next = TRANS_WAIT;
						else
							rd_next = TRANS_DATA;
		
		TRANS_WAIT:		if(trans_cnt == WAIT_MAX)
							rd_next = RD_IDLE;
						else
							rd_next = TRANS_WAIT;
							
		default:		rd_next = RD_IDLE;
		
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		TRANS_MAC_H:	if(trans_cnt == TRANS_PERIOD)
						begin
							trans_cnt <= 0;
							switch_sign <= 1'b1;
						end
						else
						begin
							trans_cnt <= trans_cnt + 1'b1;
							switch_sign <= 1'b0;
						end
		TRANS_MAC_L:	if(trans_cnt == MAC_LOW16bit)
						begin
							trans_cnt <= 0;
							switch_sign <= 1'b1;
						end
						else
						begin
							trans_cnt <= trans_cnt + 1'b1;
							switch_sign <= 1'b0;
						end
		TRANS_IP:		if(trans_cnt == TRANS_PERIOD)
						begin
							trans_cnt <= 0;
							switch_sign <= 1'b1;
						end
						else
						begin
							trans_cnt <= trans_cnt + 1'b1;
							switch_sign <= 1'b0;
						end
		TRANS_PORT:		if(trans_cnt == PORT_16BIT)
						begin
							trans_cnt <= 0;
							switch_sign <= 1'b1;
						end
						else
						begin
							trans_cnt <= trans_cnt + 1'b1;
							switch_sign <= 1'b0;
						end
		TRANS_DATA:		if(trans_cnt == TRANS_PERIOD)
						begin
							trans_cnt <= 0;
							switch_sign <= 1'b1;
						end
						else
						begin
							trans_cnt <= trans_cnt + 1'b1;
							switch_sign <= 1'b0;
						end
		TRANS_WAIT:		begin
							trans_cnt <= trans_cnt + 1'b1;
							switch_sign <= 1'b0;
						end
		default:		begin
							trans_cnt <= 0;
							switch_sign <= 1'b0;
						end
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_FIFO:		begin
							dout_8bit <= 8'b0;	
							dout_8bit_en <= 1'b0;	
							rd_fifo_en <= 1'b1;	
						end
		TRANS_MAC_H:	case(trans_cnt)
							3'd0:		begin	
											dout_8bit <= fifo_dout[31:24];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b0;
										end
							3'd1:		begin
											dout_8bit <= fifo_dout[23:16];	
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b0;	
										end
							3'd2:		begin
											dout_8bit <= fifo_dout[15:8];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b1;
										end
							3'd3:		begin
											dout_8bit <= fifo_dout[7:0];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b0;
										end
						endcase
		TRANS_MAC_L:	case(trans_cnt)
							3'd0:		begin	
											dout_8bit <= fifo_dout[15:8];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b1;
										end
							3'd1:		begin
											dout_8bit <= fifo_dout[7:0];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b0;
										end
							default:	begin
											dout_8bit <= 8'b0;
											dout_8bit_en <= 1'b0;
											rd_fifo_en <= 1'b0;
										end
						endcase
		TRANS_IP:		case(trans_cnt)
							3'd0:		begin	
											dout_8bit <= fifo_dout[31:24];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b0;
										end
							3'd1:		begin
											dout_8bit <= fifo_dout[23:16];	
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b0;	
										end
							3'd2:		begin
											dout_8bit <= fifo_dout[15:8];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b1;
										end
							3'd3:		begin
											dout_8bit <= fifo_dout[7:0];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b0;
										end
						endcase
		TRANS_PORT:		case(trans_cnt)
							3'd0:		begin	
											dout_8bit <= fifo_dout[15:8];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b1;
										end
							3'd1:		begin
											dout_8bit <= fifo_dout[7:0];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b0;
										end
							default:	begin
											dout_8bit <= 8'b0;
											dout_8bit_en <= 1'b0;
											rd_fifo_en <= 1'b0;
										end
						endcase
		TRANS_DATA:		case(trans_cnt)
							3'd0:		begin	
											dout_8bit <= fifo_dout[31:24];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b0;
										end
							3'd1:		begin
											dout_8bit <= fifo_dout[23:16];	
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b0;	
										end
							3'd2:		begin
											dout_8bit <= fifo_dout[15:8];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b1;
										end
							3'd3:		begin
											dout_8bit <= fifo_dout[7:0];
											dout_8bit_en <= 1'b1;
											rd_fifo_en <= 1'b0;
										end
						endcase
		default:		begin	
							dout_8bit <= 8'b0;	
							dout_8bit_en <= 1'b0;	
							rd_fifo_en <= 1'b0;
						end
	endcase
end

fifo_32_8_variable	fifo_32_8_variable_inst
	(
	
	.dout		(fifo_dout		),
	.rd_en		(rd_fifo_en		),
    
	.din		(fifo_din		),
	.wr_en		(wr_fifo_en		),
	
	.full		(),
	.prog_full	(fifo_prog_full	),
	.empty		(fifo_empty		),
    
	.rst		(rst			),
	.clk     	(clk			)
	
	);

endmodule
