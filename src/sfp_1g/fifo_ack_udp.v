`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:56:00 07/07/2011 
// Design Name: 
// Module Name:    fifo_ack 
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
module fifo_ack_udp(
	input				rx_clk	,
	input				rx_rst	,
	input	[7:0]		rx_data			,
	input				rx_data_valid	,
	
	input				tx_clk	,
	input				tx_rst	,
	output	reg	[7:0]	tx_data	,
	output	reg			tx_data_valid	,
	input				tx_ack			,
	
	output				prog_full		,
	
   	output	reg			wr_en			,
   	output	reg	[7:0]	wr_data			,
   	output	reg			rx_end_en		,
   	
   	output	reg			rd_en			,
   	output				rd_data_end		,
   	output	reg	[2:0]	tx_nxt_state	,
	output	[15:0]		rd_len			,
	output	reg			rd_len_en		,
	output	[7:0]		rd_data			,
	output				data_empty		,
	output				len_empty		
	
    );

    parameter		RX_IDLE_S	= 2'd0,
    				RX_FRAME_S	= 2'd1,
    				RX_LEN_S	= 2'd2,
    				RX_OVFLOW_S	= 2'd3;
    				
   	reg		[1:0]		rx_state		;
   	reg		[1:0]		rx_nxt_state	;
    				
   	parameter		TX_IDLE_S	= 3'd0, 
   					TX_LEN_S	= 3'd1, 
   					TX_LEN1_S	= 3'd2, 
   					TX_LEN2_S	= 3'd3, 
   					TX_HEAD_S	= 3'd4,
   					TX_WACK_S	= 3'd5, 
   					TX_FRAME_S	= 3'd6, 
   					TX_DLY_S	= 3'd7;
   					
   	reg		[2:0]		tx_state		;
//   	reg		[2:0]		tx_nxt_state	;
   	
   	
   	reg		[7:0]		rx_data_r		;
   	reg					rx_data_valid_r	;
   	reg					rx_start_en		;
//   	reg					rx_end_en		;
//   	reg					wr_en			;
//   	reg		[7:0]		wr_data			;
//   	wire				rd_en			;
//   	wire				rd_data_end		;
//   	wire				prog_full		;
	reg					rd_end			;
	reg					wr_tog			;
	reg					rd_tog			;
	reg					rd_asyn			;
	reg					rd_red			;
	reg					rd_store		;
	reg		[5:0]		frame_cnt		;
	reg					read_start_en	;
	reg		[3:0]		head_cnt		;
	reg		[15:0]		wr_len			;
	reg					wr_len_en		;
//	wire	[15:0]		rd_len			;
//	reg					rd_len_en		;
//	reg					tx_data_valid_r	;
//	wire	[7:0]		rd_data			;
//	wire				data_empty		;
//	wire				len_empty		;
	reg					tx_sel			;
	reg					frame_c			;

	initial
	begin
		wr_tog	= 0;
	end
   	
   	always @(posedge rx_clk)
   	begin
   		rx_data_r		<= rx_data;
   		rx_data_valid_r	<= rx_data_valid	;
   		rx_start_en		<= (rx_data_valid & (!rx_data_valid_r));
   		rx_end_en		<= ((!rx_data_valid) & rx_data_valid_r);
   	end
   	
   	// rx state machine -----------------------------
   	always @(posedge rx_clk)
   	begin
   		if (rx_rst)
   			rx_state	<= RX_IDLE_S	;
   		else
   			rx_state	<= rx_nxt_state	;
   	end
   	
   	always @(*)
   	begin
   		case (rx_state)
   			RX_IDLE_S:
   			begin
   				if (rx_start_en)
   				begin
   					if (prog_full)
   						rx_nxt_state <= RX_OVFLOW_S;
   					else
	   					rx_nxt_state <= RX_FRAME_S;
   				end
   				else
   					rx_nxt_state <= RX_IDLE_S;
   			end
   			RX_FRAME_S:
   			begin
   				if (rx_end_en)
   					rx_nxt_state <= RX_LEN_S;
   				else
   					rx_nxt_state <= RX_FRAME_S;
   			end
   			RX_LEN_S:
   			begin
				rx_nxt_state <= RX_IDLE_S;
   			end
   			RX_OVFLOW_S:
   			begin
   				if (rx_end_en)
   					rx_nxt_state <= RX_IDLE_S;
   				else
   					rx_nxt_state <= RX_OVFLOW_S;
   			end
   			
   			default:
   			begin
   				rx_nxt_state <= RX_IDLE_S;
   			end
   		endcase
   	end
   	
   	always @(posedge rx_clk)
   	begin
   		if (rx_nxt_state == RX_FRAME_S)
   		begin
   			wr_data		<= rx_data_r;
   			wr_en		<= 1'b1;
   		end
   		else
   		begin
   			wr_data		<= 8'h00;
   			wr_en		<= 1'b0;
   		end
   	end
   	
   	always @(posedge rx_clk)
   	begin
   		if (rx_nxt_state == RX_IDLE_S)
   			wr_len	<= 16'd0;
   		else if (rx_nxt_state == RX_FRAME_S)
   			wr_len	<= wr_len + 16'd1;
   	end
   	
   	always @(posedge rx_clk)
   	begin
   		if (rx_nxt_state == RX_LEN_S)
   			wr_len_en	<= 1'b1;
   		else
   			wr_len_en	<= 1'b0;
   	end
    
   	// share -----------------------------------------
   	always @(posedge rx_clk)
   	begin
   		if (rx_state == RX_LEN_S)
   			wr_tog	<= ~wr_tog;
   		else
   			wr_tog	<= wr_tog;
   	end
   	
   	always @(posedge tx_clk)
   	begin
   		if (tx_rst)
   		begin
   			rd_tog	    <= 1'b0;
   			rd_asyn	    <= 1'b0;
   			rd_red		<= 1'b0;
   			rd_store    <= 1'b0;
   		end                     
   		else
   		begin
   			rd_tog		<= wr_tog	;
   			rd_asyn	    <= rd_tog	;
   			rd_red		<= rd_asyn	;
   			rd_store    <= (rd_asyn ^ rd_red);
   		end
   	end
   	
   	always @(posedge tx_clk)
   	begin
   		if (tx_rst)
   			frame_cnt	<= 6'd0;
   		else if (rd_store && (frame_c == 1'b0))
   			frame_cnt	<= frame_cnt + 6'd1;
   		else if ((rd_store == 1'b0) && frame_c)
   			frame_cnt	<= frame_cnt - 6'd1;
   		else
   			frame_cnt	<= frame_cnt;
   	end
   	
   	always @(posedge tx_clk)
   	begin
   		if ((tx_nxt_state == TX_FRAME_S)&&(tx_state == TX_WACK_S))
   			frame_c <= 1'b1;
   		else
   			frame_c <= 1'b0;
   	end
   	
	always @(posedge tx_clk)
	begin
		if (frame_cnt > 6'd0)
			read_start_en	<= 1'b1;
		else
			read_start_en	<= 1'b0;
	end
   	
   	// read -------------------------------------------
   	always @(posedge tx_clk)
   	begin
   		if (tx_rst)
   			tx_state	<= TX_IDLE_S;
   		else
   			tx_state	<= tx_nxt_state	;
   	end
   	
   	always @(*)
   	begin
   		case (tx_state)
   			TX_IDLE_S:
   			begin
   				if (read_start_en)
   					tx_nxt_state <= TX_LEN_S;
   				else
   					tx_nxt_state <= TX_IDLE_S;
   			end
   			TX_LEN_S:
   			begin
   				tx_nxt_state <= TX_LEN1_S;
   			end
   			TX_LEN1_S:
   			begin
   				tx_nxt_state <= TX_LEN2_S;
   			end
   			TX_LEN2_S:
   			begin
   				tx_nxt_state <= TX_HEAD_S;
   			end
   			TX_HEAD_S:
   			begin
   				if (tx_sel)
   					tx_nxt_state <= TX_WACK_S;
   				else
   					tx_nxt_state  <= TX_HEAD_S;
   			end
   			TX_WACK_S:
   			begin
   				if (tx_ack)
   					tx_nxt_state <= TX_FRAME_S;
   				else
   					tx_nxt_state <= TX_WACK_S;
   			end
   			TX_FRAME_S:
   			begin
   				if (rd_data_end)
   					tx_nxt_state <= TX_DLY_S;
   				else
   					tx_nxt_state <= TX_FRAME_S;
   			end
   			TX_DLY_S:
   			begin
				tx_nxt_state <= TX_IDLE_S;
   			end
   			
   			default:
   				tx_nxt_state <= TX_IDLE_S;
   		endcase
   	end
   	
   	// counter ----------------------------------------
   	always @(posedge tx_clk)
   	begin
   		if (tx_nxt_state == TX_HEAD_S)
   			head_cnt	<= head_cnt + 4'd1;
   		else
   			head_cnt	<= 4'd0;
   	end
   	
   	always @(posedge tx_clk)
   	begin
   		if (head_cnt == 4'd11)
   			tx_sel	<= 1'b1;
   		else
   			tx_sel	<= 1'b0;
   	end
   	
	always @(tx_nxt_state)
	begin
		case (tx_nxt_state)
			TX_LEN2_S,
			TX_HEAD_S,
			TX_FRAME_S:
				rd_en	<= 1'b1;
			default:
				rd_en	<= 1'b0;
		endcase
	end
   	
   	always @(tx_nxt_state)
   	begin
   		case (tx_nxt_state)
   			TX_LEN_S:
   				rd_len_en	<= 1'b1;
   			default:
   				rd_len_en	<= 1'b0;
   		endcase
   	end
   	
	fifo_4096byte fifo_4096byte(
		.rst				(rx_rst	),
		.wr_clk				(rx_clk	),
		.rd_clk				(tx_clk	),
		.din				({rx_end_en, wr_data}),
		.wr_en				(wr_en),
		.rd_en				(rd_en),
		.dout				({rd_data_end, rd_data}),
		.empty				(data_empty),
		.full				(),
		.prog_full          (prog_full	)
	);
	
	fifo_16byte fifo_16byte(
		.rst				(rx_rst),
		.wr_clk				(rx_clk),
		.rd_clk				(tx_clk),
		.din				(wr_len),
		.wr_en				(wr_len_en),
		.rd_en				(rd_len_en),
		.dout				(rd_len),
		.full				(),
		.empty      		(len_empty)
	);
	
	always @(posedge tx_clk)
	begin
		if (tx_nxt_state == TX_LEN1_S)
		begin
			tx_data			<= rd_len[15:8];
			tx_data_valid	<= 1'b1;
		end
		else if (tx_nxt_state == TX_LEN2_S)
		begin
			tx_data			<= rd_len[7:0];
			tx_data_valid	<= 1'b1;
		end
		else if ((tx_nxt_state == TX_HEAD_S)||(tx_nxt_state == TX_FRAME_S)||(tx_state == TX_FRAME_S))
		begin
			tx_data			<= rd_data;
			tx_data_valid	<= 1'b1;
		end
		else
		begin
			tx_data			<= 8'h00;
			tx_data_valid	<= 1'b0;
		end
	end
	
	endmodule
