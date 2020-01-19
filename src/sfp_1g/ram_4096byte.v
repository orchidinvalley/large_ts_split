`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:43:41 07/26/2011 
// Design Name: 
// Module Name:    ram_4096byte 
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
module ram_4096byte(
	input				rx_clk	,
	input				rx_rst	,
	input	[7:0]		rx_data	,
	input				rx_data_valid	,
	input				rx_good	,
	input				rx_bad	,
	input				tx_clk	,
	input				tx_rst	,
	output	reg	[7:0]	tx_data	,
	output	reg			tx_data_valid/*,
	
    output	reg		[2:0]		rx_nxt_state	,
   	output	reg					wr_en			,
   	output	reg		[10:0]		wr_addra		,
   	output	reg		[10:0]		wr_start_addra	,
   	output	reg		[7:0]		wr_data			,
   	output	reg					wr_data_end		,
   	output	reg		[1:0]		tx_nxt_state	,
   	output						rd_start_en		,
   	output	reg		[10:0]		rd_addrb		,
   	output			[8:0]		rd_data			*/
	
    );
    
    parameter	RX_IDLE_S	= 3'd0,
    			RX_FRAME_S	= 3'd1,
    			RX_END_S	= 3'd2,
    			RX_GF_S		= 3'd3,
    			RX_BF_S		= 3'd4;
    			
    reg		[2:0]		rx_state		;
    reg		[2:0]		rx_nxt_state	;
    
    parameter	TX_IDLE_S	= 2'd0,
    			TX_FRAME_S	= 2'd1,
    			TX_END_S	= 2'd2;
    			
   	reg		[1:0]		tx_state		;
   	reg		[1:0]		tx_nxt_state	;
   	
   	// write --------------------------------------
   	reg		[7:0]		rx_data_r		;
   	reg					rx_data_valid_r	;
   	reg					rx_good_r		;
   	reg					rx_bad_r		;
   	reg					rx_start_en		;
   	reg					rx_end_en		;
   	reg					wr_en			;
   	reg		[10:0]		wr_addra		;// 2048 depth
   	reg		[10:0]		wr_start_addra	;
   	reg		[7:0]		wr_data			;
   	reg					wr_data_end		;
   	
   	// share --------------------------------------
   	reg					wr_tog			;
   	reg					rd_tog			;
   	reg					rd_asyn			;
   	reg					rd_syn			;
   	reg					rd_store		;
   	reg		[6:0]		rd_frame_cnt	;
   	
   	// read ---------------------------------------
   	wire				rd_start_en		;
   	reg		[10:0]		rd_addrb		;
   	wire	[8:0]		rd_data			;
	wire				rd_en			;
   	
   	initial
   	begin
   		rd_frame_cnt = 0;
   	end
   	
   	
   	always @(posedge rx_clk)
   	begin
   		rx_data_r		<= rx_data			;
   		rx_data_valid_r	<= rx_data_valid	;
   		rx_start_en		<= (rx_data_valid && (!rx_data_valid_r));
   		rx_end_en		<= ((!rx_data_valid) && rx_data_valid_r);
   		
   		rx_good_r		<= rx_good;
   		rx_bad_r		<= rx_bad;
   	end
   	
   	// wr state machine ---------------------------
   	always @(posedge rx_clk)
   	begin
   		if (rx_rst)
   			rx_state	<= RX_IDLE_S;
   		else
   			rx_state	<= rx_nxt_state	;
   	end
   	
   	always @(*)
   	begin
   		case (rx_state)
   			RX_IDLE_S:
   			begin
   				if (rx_start_en)
   					rx_nxt_state	<= RX_FRAME_S;
   				else
   					rx_nxt_state	<= RX_IDLE_S;
   			end
   			RX_FRAME_S:
   			begin
   				if (rx_end_en)
   					rx_nxt_state	<= RX_END_S;
   				else
   					rx_nxt_state	<= RX_FRAME_S;
   			end
   			RX_END_S:
   			begin
   				if (rx_good_r)
   					rx_nxt_state	<= RX_GF_S;
   				else if (rx_bad_r)
   					rx_nxt_state	<= RX_BF_S;
   				else
   					rx_nxt_state	<= RX_END_S;
   			end
   			
   			default:
   			begin
   				rx_nxt_state	<= RX_IDLE_S;
   			end
   		endcase
   	end
   	
   	// write operation -----------------------------------
   	always @(posedge rx_clk)
   	begin
   		if (rx_nxt_state == RX_FRAME_S)
   			wr_en	<= 1'b1;
   		else
   			wr_en	<= 1'b0;
   	end
   	
   	always @(posedge rx_clk)
   	begin
   		if (rx_nxt_state == RX_IDLE_S)
   			wr_addra	<= wr_start_addra;
   		else if (rx_nxt_state == RX_FRAME_S)
   			wr_addra	<= wr_addra + 11'd1;
   	end

   	always @(posedge rx_clk)
   	begin
   		if (rx_rst)
   			wr_start_addra	<= 11'd0;
   		else if (rx_nxt_state == RX_GF_S)
   			wr_start_addra	<= wr_addra;
   	end
   	
   	always @(posedge rx_clk)
   	begin
   		if (rx_nxt_state == RX_FRAME_S)
   			wr_data	<= rx_data_r;
   	end
   	
   	always @(posedge rx_clk)
   	begin
   		if ((!rx_data_valid)&&rx_data_valid_r)
   			wr_data_end	<= 1'b1;
   		else
   			wr_data_end	<= 1'b0;
   	end
   	
   	// share --------------------------------------
   	always @(posedge rx_clk)
   	begin
   		if (rx_rst)
   			wr_tog	<= 1'b0;
   		else if (rx_nxt_state == RX_GF_S)
   			wr_tog	<= ~wr_tog;
   	end
   	
   	always @(posedge tx_clk)
   	begin
   		if (tx_rst)
   		begin
	   		rd_tog		<= 1'b0;
	   		rd_asyn		<= 1'b0;
	   		rd_syn		<= 1'b0;
	   		rd_store	<= 1'b0;
   		end
   		else
   		begin
	   		rd_tog		<= wr_tog;
	   		rd_asyn		<= rd_tog;
	   		rd_syn		<= rd_asyn;
	   		rd_store	<= (rd_asyn ^ rd_syn);
   		end
   	end
   	
   	always @(posedge tx_clk)
   	begin
   		if (rd_store && (tx_nxt_state != TX_END_S))
   			rd_frame_cnt	<= rd_frame_cnt + 7'd1;
   		else if ((tx_nxt_state == TX_END_S)&&(!rd_store))
   			rd_frame_cnt	<= rd_frame_cnt - 7'd1;
   		else
   			rd_frame_cnt	<= rd_frame_cnt;
   	end

	// rd state machine ----------------------------
	assign	rd_start_en	= (rd_frame_cnt == 7'd0) ? 1'b0 : 1'b1;
	
	always @(posedge tx_clk)
	begin
		if (tx_rst)
			tx_state	<= TX_IDLE_S;
		else
			tx_state	<= tx_nxt_state;
	end
	
	always @(*)
	begin
		case (tx_state)
			TX_IDLE_S:
			begin
				if (rd_start_en)
					tx_nxt_state	<= TX_FRAME_S;
				else
					tx_nxt_state	<= TX_IDLE_S;
			end
			TX_FRAME_S:
			begin
				if (rd_data[8])
					tx_nxt_state	<= TX_END_S;
				else
					tx_nxt_state	<= TX_FRAME_S;
			end
			
			default:
			begin
				tx_nxt_state	<= TX_IDLE_S;
			end
		endcase
	end
	
	// read operation --------------------------------
	always @(posedge tx_clk)
	begin
		if (tx_rst)
			rd_addrb	<= 11'd1;
		else if (tx_nxt_state == TX_FRAME_S)
			rd_addrb	<= rd_addrb + 11'd1;
	end
	
	assign	rd_en = (tx_nxt_state == TX_FRAME_S) ? 1'b1 : 1'b0;
	
	// output ----------------------------------------
	always @(posedge tx_clk)
	begin
		if (tx_state == TX_FRAME_S)
		begin
			tx_data			<= rd_data[7:0];
			tx_data_valid	<= 1'b1;
		end
		else
		begin
			tx_data			<= 8'h00;
			tx_data_valid	<= 1'b0;
		end
	end
	
	
	bram_2048_9byte bram_2048_9byte_init(
		.clka			(rx_clk),
		.wea			(wr_en),
		.addra			(wr_addra),
		.dina			({wr_data_end, wr_data}),
		.clkb			(tx_clk),
		.enb			(rd_en),
		.addrb			(rd_addrb),
		.doutb 	    	(rd_data)
	);

endmodule
