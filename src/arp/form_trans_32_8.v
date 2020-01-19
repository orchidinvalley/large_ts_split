`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:53:14 05/20/2011 
// Design Name: 
// Module Name:    form_trans_32_8 
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
module form_trans_32_8(
		
		dout_8bit,
		dout_8bit_en,
		
		din_33bit,
		din_33bit_en,
		
		rst,
		clk,
		
		current_state,//test port
		fifo_dout,    //test port
		fifo_empty,   //test port
		rd_fifo_en,   //test port
		data_cnt,     //test port
		period_cnt   //test port
		
		);

	output	reg		[7:0]	dout_8bit;
	output	reg				dout_8bit_en;
	
	input			[32:0]	din_33bit;
	input					din_33bit_en;
	
	input					rst;
	input					clk;
	
	output			[3:0]	current_state;//test port
	output			[32:0]	fifo_dout;    //test port
	output					fifo_empty;   //test port
	output					rd_fifo_en;   //test port
	output			[5:0]	data_cnt;     //test port
	output			[1:0]	period_cnt;   //test port 
	
	reg				[5:0]	data_cnt;
	reg				[1:0]	period_cnt;
	
	reg						rd_fifo_en;
	
	reg				[3:0]	current_state;
	reg				[3:0]	next_state;
	
	wire			[32:0]	fifo_dout;
	wire					fifo_empty;
	
	parameter	DATA_LENGTH = 6'd51,
				WAIT_MAX = DATA_LENGTH + 6'd8;//wait 8 clock period
	
	parameter	MAC_LOW16BIT = 2'd1,//2 clock period
				PORT_16BIT = 2'd1,//2 clock period
				TRANS_PERIOD = 2'd3;//4 clock period
	
	parameter	IDLE = 4'b0000,
				RD_FIFO = 4'b0001,
				CHECK = 4'b0010,
				TRANS_MAC_H = 4'b0011,
				TRANS_MAC_L = 4'b0100,
				TRANS_IP = 4'b0101,
				TRANS_PORT = 4'b0110,
				TRANS_DATA = 4'b0111,
				TRANS_WAIT = 4'b1000;
	
/***********************************************************************************/
//Finite State Machine;
	
always@(posedge clk)
begin
	if(rst)
	begin
		current_state <= IDLE;
	end
	else
	begin
		current_state <= next_state;
	end
end

always@(current_state or fifo_empty or fifo_dout[32] or data_cnt or rst)
begin
	if(rst)
	begin
		next_state = IDLE;
	end
	else
	begin
		case(current_state)
			
			IDLE:			begin
								if(fifo_empty == 1'b0 )
								begin
									next_state = RD_FIFO;
								end
								else
								begin
									next_state = IDLE;
								end
							end
							
			RD_FIFO:		begin	next_state = CHECK;	end
			
			CHECK:			begin
								if(fifo_dout[32])
								begin
									next_state = TRANS_MAC_H;
								end
								else
								begin
									next_state = RD_FIFO;
								end
							end
							
			TRANS_MAC_H:	begin
								if(data_cnt == 6'd1)
								begin
									next_state = TRANS_MAC_L;
								end
								else
								begin
									next_state = TRANS_MAC_H;
								end
							end
							
			TRANS_MAC_L:	begin
								if(data_cnt == 6'd2)
								begin
									next_state = TRANS_IP;
								end
								else
								begin
									next_state = TRANS_MAC_L;
								end
							end
							
			TRANS_IP:		begin
								if(data_cnt == 6'd3)
								begin
									next_state = TRANS_PORT;
								end
								else
								begin
									next_state = TRANS_IP;
								end
							end	
			
			TRANS_PORT:		begin
								if(data_cnt == 6'd4)
								begin
									next_state = TRANS_DATA;
								end
								else
								begin
									next_state = TRANS_PORT;
								end
							end
							
			TRANS_DATA:		begin
								if(data_cnt == DATA_LENGTH)
								begin
									next_state = TRANS_WAIT;
								end
								else
								begin
									next_state = TRANS_DATA;
								end
							end		
			
			TRANS_WAIT:		begin
								if(data_cnt == WAIT_MAX)
								begin
									next_state = IDLE;
								end
								else
								begin
									next_state = TRANS_WAIT;
								end
							end
							
			default:		begin	next_state = IDLE;	end
		endcase
	end
end

/************************************************************************************/
//Counter

always@(posedge clk)
begin
	case(next_state)
		IDLE:			begin
							data_cnt <= 6'd0;
							period_cnt <= 2'd0;
						end
						
		RD_FIFO:		begin
							data_cnt <= 6'd0;
							period_cnt <= 2'd0;
						end
		CHECK:			begin
							data_cnt <= 6'd0;
							period_cnt <= 2'd0;
						end
		TRANS_MAC_L:	begin
							if(period_cnt == MAC_LOW16BIT)
							begin
								data_cnt <= data_cnt + 1'b1;
								period_cnt <= 2'd0;
							end
							else
							begin
								data_cnt <= data_cnt;
								period_cnt <= period_cnt + 1'b1;
							end
						end
		TRANS_PORT:		begin
							if(period_cnt == PORT_16BIT)
							begin
								data_cnt <= data_cnt + 1'b1;
								period_cnt <= 2'd0;
							end
							else
							begin
								data_cnt <= data_cnt;
								period_cnt <= period_cnt + 1'b1;
							end
						end
		TRANS_WAIT:		begin	
							data_cnt <= data_cnt + 1'b1;
							period_cnt <= 2'b0;
						end
		default:		begin
							if(period_cnt == TRANS_PERIOD)
							begin
								data_cnt <= data_cnt + 1'b1;
								period_cnt <= 2'd0;
							end
							else
							begin
								data_cnt <= data_cnt;
								period_cnt <= period_cnt + 1'b1;
							end
						end
	endcase	
end

/*********************************************************************/
//Send 8bit	data

always@(posedge clk)
begin
	case(next_state)
		RD_FIFO:		begin	dout_8bit <= 8'b0;	dout_8bit_en <= 1'b0;	rd_fifo_en <= 1'b1;	end
		TRANS_MAC_H:	begin
							case(period_cnt)
								2'b00:		begin	
												dout_8bit <= fifo_dout[31:24];
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b0;
											end
								2'b01:		begin
												dout_8bit <= fifo_dout[23:16];	
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b0;	
											end
								2'b10:		begin
												dout_8bit <= fifo_dout[15:8];
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b1;
											end
								2'b11:		begin
												dout_8bit <= fifo_dout[7:0];
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b0;
											end
							endcase
						end
		TRANS_MAC_L:	begin
							case(period_cnt)
								2'b00:		begin	
												dout_8bit <= fifo_dout[15:8];
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b1;
											end
								2'b01:		begin
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
						end
		TRANS_IP:		begin
							case(period_cnt)
								2'b00:		begin	
												dout_8bit <= fifo_dout[31:24];
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b0;
											end
								2'b01:		begin
												dout_8bit <= fifo_dout[23:16];	
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b0;	
											end
								2'b10:		begin
												dout_8bit <= fifo_dout[15:8];
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b1;
											end
								2'b11:		begin
												dout_8bit <= fifo_dout[7:0];
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b0;
											end
							endcase
						end
		TRANS_PORT:		begin
							case(period_cnt)
								2'b00:		begin	
												dout_8bit <= fifo_dout[15:8];
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b1;
											end
								2'b01:		begin
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
						end
		TRANS_DATA:		begin
							case(period_cnt)
								2'b00:		begin	
												dout_8bit <= fifo_dout[31:24];
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b0;
											end
								2'b01:		begin
												dout_8bit <= fifo_dout[23:16];	
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b0;	
											end
								2'b10:		begin
												if(data_cnt == DATA_LENGTH - 1'b1)
												begin
													dout_8bit <= fifo_dout[15:8];
													dout_8bit_en <= 1'b1;
													rd_fifo_en <= 1'b0;
												end
												else
												begin
													dout_8bit <= fifo_dout[15:8];
													dout_8bit_en <= 1'b1;
													rd_fifo_en <= 1'b1;
												end
											end
								2'b11:		begin
												dout_8bit <= fifo_dout[7:0];
												dout_8bit_en <= 1'b1;
												rd_fifo_en <= 1'b0;
											end
							endcase
						end
		default:		begin	dout_8bit <= 8'b0;	dout_8bit_en <= 1'b0;	rd_fifo_en <= 1'b0;end
	endcase
end

/****************************************************************************************************************/
//fifo

fifo_32_8	fifo_32_8_inst
	(
	
	.dout		(fifo_dout		),
	.rd_en		(rd_fifo_en		),
    
	.din		(din_33bit		),
	.wr_en		(din_33bit_en	),
	
	.full		(),
	.empty		(fifo_empty		),
    
	.rst		(rst			),
	.clk     	(clk			)
	
	);
 
endmodule
