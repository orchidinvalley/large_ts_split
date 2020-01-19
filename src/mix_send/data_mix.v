`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:13:33 05/21/2011 
// Design Name: 
// Module Name:    data_mix 
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
module data_mix(
  	clk,
	rst,
	// 5 * head_num;
	emm_head_din,
	emm_head_din_en,
	//5空 + 94 
	emm_din,
	emm_din_en,
	ts_din,//（pid）+（gbe+ip+port）+TS（188/8） 1+1+24
	ts_din_en,
	ddr_din,
	ddr_din_en,
	head_num,

	ts_dout,
	ts_dout_en
//	fifo_ts_full,
//	fifo_ddr_full
	);

	input			clk;
	input			rst;
	input	[31:0]	emm_head_din;
	input			emm_head_din_en;
	input	[31:0]	emm_din;
    input			emm_din_en;
	input	[32:0]	ts_din;
	input			ts_din_en;
    input	[32:0]	ddr_din;
    input			ddr_din_en;
    input	[5:0]	head_num;
	
	output	[31:0]	ts_dout;
	output			ts_dout_en;
//	output			fifo_ts_full;
//	output			fifo_ddr_full;
	
	reg		[31:0]	ts_dout;
	reg				ts_dout_en;
	
// ---------------- Memory Ports ------------------
//	reg				ram_head_wr;
	reg		[10:0]	ram_head_wr_addr;
	reg		[10:0]	ram_head_rd_addr;
	wire	[31:0]	ram_head_dout;

	reg		[5:0]	ram_emm_wr_addr;
	reg		[5:0]	ram_emm_rd_addr;
	wire	[31:0]	ram_emm_dout;
	
	RAM_HEAD ram_head (
		.clka	(clk),
		.wea	(emm_head_din_en), 			// Bus [0 : 0] 
		.addra	(ram_head_wr_addr), 	// Bus [8 : 0] 
		.dina	(emm_head_din), 		// Bus [7 : 0] 
		.clkb	(clk),
		.addrb	(ram_head_rd_addr), 	// Bus [8 : 0] 
		.doutb	(ram_head_dout)); 		// Bus [7 : 0] 	
	
	RAM_EMM ram_emm (
		.clka	(clk),
		.wea	(emm_din_en), 			// Bus [0 : 0] 
		.addra	(ram_emm_wr_addr), 		// Bus [7 : 0] 
		.dina	(emm_din), 				// Bus [7 : 0] 
		.clkb	(clk),
		.addrb	(ram_emm_rd_addr),
		.doutb	(ram_emm_dout)); 		// Bus [7 : 0] 

	reg				fifo_ts_rd;
	wire	[32:0]	fifo_ts_dout;
	wire			fifo_ts_prog_empty;
	wire			fifo_ts_full;

	reg				fifo_ddr_rd;
	wire	[32:0]	fifo_ddr_dout;
	wire			fifo_ddr_prog_empty;
	wire			fifo_ddr_full;

	FIFO_TS fifo_ts (
		.clk	(clk),
		.rst	(rst),
		.din	(ts_din), 			// Bus [8 : 0] 
		.wr_en	(ts_din_en),
		.rd_en	(fifo_ts_rd),
		.dout	(fifo_ts_dout), 	// Bus [8 : 0] 
		.full	(fifo_ts_full),
		.empty	( ),
		.prog_empty(fifo_ts_prog_empty));
		
	FIFO_TS fifo_ddr (
		.clk	(clk),
		.rst	(rst),
		.din	(ddr_din), 		// Bus [8 : 0] 
		.wr_en	(ddr_din_en),
		.rd_en	(fifo_ddr_rd),
		.dout	(fifo_ddr_dout), 	// Bus [8 : 0] 
		.full	(fifo_ddr_full),
		.empty	( ),
		.prog_empty(fifo_ddr_prog_empty));
		
// --------------------- EMM_Storage_IN --------------------------
	reg		[3:0]	head_dog_cnt;
	reg		[3:0]	body_dog_cnt;
	
	always @(posedge clk)
	begin
		if(rst || emm_head_din_en)
			head_dog_cnt <= 0;
		else
			head_dog_cnt <= head_dog_cnt + 1;
	end
	
	always @(posedge clk)
	begin
		if(rst)
			ram_head_wr_addr <= 0;
		else
		if(emm_head_din_en)
			ram_head_wr_addr <= ram_head_wr_addr + 1;	
		else
		if(head_dog_cnt == 10)
			ram_head_wr_addr <= 0;
		else
			ram_head_wr_addr <= ram_head_wr_addr;
	end
	
	always @(posedge clk)
	begin
		if(rst || emm_din_en)
			body_dog_cnt <= 0;
		else
			body_dog_cnt <= body_dog_cnt + 1;
	end
	
	always @(posedge clk)
	begin
		if(rst)
			ram_emm_wr_addr <= 0;
		else
		if(emm_din_en)
			ram_emm_wr_addr <= ram_emm_wr_addr + 1;	
		else
		if(body_dog_cnt == 12)
			ram_emm_wr_addr <= 0;
		else
			ram_emm_wr_addr <= ram_emm_wr_addr;
	end

	
	reg				emm_signal;
	reg		[5:0]	head_num_cnt;
	
	always @(posedge clk)
	begin
		if(rst)
			emm_signal <= 0;
		else
		if(ram_emm_wr_addr ==51)// 25)
			emm_signal <= 1;
		else
		if(head_num_cnt == head_num)
			emm_signal <= 0;
		else
			emm_signal <= emm_signal;
	end
		
// -------------------------------------------------
		
// --------------------- RD_Schedule --------------------------
	parameter	IDLE		= 0,
				EMM_HEAD	= 1,
				EMM_BODY	= 2,
				TS_SEND		= 3,
				DDR_SEND	= 4,
				INTERVAL	= 5;
				
				
	reg		[2:0]	rd_state;
	reg		[2:0]	nxt_state;
	reg		[2:0]	head_rd_cnt;
	reg		[4:0]	inter_cnt;
	reg		[6:0]	rd_cnt;
	
	always @(posedge clk)
	begin
		if(rst)
			rd_state <= 0;
		else
			rd_state <= nxt_state;
	end

	always @(rd_state or fifo_ts_prog_empty or emm_signal or fifo_ddr_prog_empty or head_rd_cnt 
				or ram_emm_rd_addr or rd_cnt or inter_cnt)
	begin
		nxt_state   = 0;
		
		case(rd_state)
		IDLE		:	begin
						if(!fifo_ts_prog_empty)
							nxt_state = TS_SEND;
						else
						if(emm_signal)
							nxt_state = EMM_HEAD;
						else
						if(!fifo_ddr_prog_empty)
							nxt_state = DDR_SEND;
						else
							nxt_state = IDLE;
						end
		EMM_HEAD	:	begin
						if(head_rd_cnt ==3)// 1)//8)
							nxt_state = EMM_BODY;
						else
							nxt_state = EMM_HEAD;	
						end
		EMM_BODY 	:	begin
						if(ram_emm_rd_addr == 50)//25)//196)
							nxt_state = INTERVAL;
						else
							nxt_state = EMM_BODY;
						end
		TS_SEND	 	:	begin
						if(rd_cnt == 53)//28)//196)
							nxt_state = INTERVAL;
						else
							nxt_state = TS_SEND;
						end
		DDR_SEND 	:	begin
						if(rd_cnt == 53)//28)//196)
							nxt_state = INTERVAL;
						else
							nxt_state = DDR_SEND;
						end
		INTERVAL	 :	begin
						if(inter_cnt == 7)
							nxt_state = IDLE;
						else
							nxt_state = INTERVAL;
						end
		default		:	begin
						nxt_state = IDLE;
						end
		endcase	
	end

	// FIFO(TS or DDR) reading;
	reg		ts_send_en;
	reg		ddr_send_en;
	reg		emm_rd_en;
	reg		head_rd_en;
	
	always @(posedge clk)
	begin
		if((rd_state == TS_SEND) && (rd_cnt < 48))//23))//194))
			fifo_ts_rd <= 1;
		else
			fifo_ts_rd <= 0;
	end
	
	always @(posedge clk)
	begin
		if((rd_state == DDR_SEND) && (rd_cnt < 48))//23))//194))
			fifo_ddr_rd <= 1;
		else
			fifo_ddr_rd <= 0;
	end
	
	always @(posedge clk)
	begin
		if(ts_send_en || ddr_send_en)
			rd_cnt <= rd_cnt + 1;
		else
			rd_cnt <= 0;
	end
	
	always @(posedge clk)
	begin
		if(rd_state == TS_SEND)
			begin
			if(fifo_ts_dout[32])
				ts_send_en <= 1;
			else
				ts_send_en <= ts_send_en;
			end
		else
			begin
				ts_send_en <= 0;
			end		
	end
	
	always @(posedge clk)
	begin
		if(rd_state == DDR_SEND)
			begin
			if(fifo_ddr_dout[32])
				ddr_send_en <= 1;
			else
				ddr_send_en <= ddr_send_en;
			end
		else
			begin
				ddr_send_en <= 0;
			end		
	end
	//--end------------------------
	
	// emm_head处理；
	always @(posedge clk)
	begin
		if(rd_state == EMM_HEAD)
			head_rd_cnt <= head_rd_cnt + 1;
		else
			head_rd_cnt <= 0;
	end
	
	always @(posedge clk)
	begin
		if(head_rd_cnt == 3)//1)//8)
			head_num_cnt <= head_num_cnt + 1;
		else
		if(emm_signal)
			head_num_cnt <= head_num_cnt;
		else
			head_num_cnt <= 0;
	end

	always @(posedge clk)
	begin
		if(rd_state == EMM_HEAD)
			ram_head_rd_addr <= ram_head_rd_addr + 1;
		else
		if(emm_signal)	//(head_num_cnt < head_num)
			ram_head_rd_addr <= ram_head_rd_addr;
		else
			ram_head_rd_addr <= 0;
	end
	
	always @(posedge clk)
	begin
		if(rd_state == EMM_HEAD)
			head_rd_en <= 1;
		else
			head_rd_en <= 0;
	end
	
	//--end------------------------
	
	// emm_body处理；
	always @(posedge clk)
	begin
		if((rd_state == EMM_HEAD) || (rd_state == EMM_BODY))
			ram_emm_rd_addr	<= ram_emm_rd_addr + 1;
		else
			ram_emm_rd_addr <= 0;
	end
	
	always @(posedge clk)
	begin
		if(rd_state == EMM_BODY)
			emm_rd_en <= 1;
		else
			emm_rd_en <= 0;
	end
	//--end------------------------
	
	// 包间隔处理；
	always @(posedge clk)
	begin
		if(rd_state == INTERVAL)
			inter_cnt <= inter_cnt + 1;
		else
			inter_cnt <= 0;
	end
	//--end------------------------

	// 混合输出；
	reg		[31:0]	fifo_ts_dout_r;
	reg		[31:0]	fifo_ddr_dout_r;
	wire			ts_send_en_w;
	wire			ddr_send_en_w;
	
	
	assign	ts_send_en_w  = ts_send_en && (rd_cnt < 51);//26);//197);
	assign	ddr_send_en_w = ddr_send_en && (rd_cnt < 51);//26);//197);
	
	always @(posedge clk)
	begin
		fifo_ts_dout_r  <= fifo_ts_dout[31:0];
		fifo_ddr_dout_r <= fifo_ddr_dout[31:0];
	end
	
	
	always @(posedge clk)
	begin
		if(rst)
			begin
			ts_dout	   <= 0;
			ts_dout_en <= 0;
			end
		else
			begin
			case({ts_send_en_w,head_rd_en,emm_rd_en,ddr_send_en_w})
			4'b1000	:	begin
						ts_dout	   <= fifo_ts_dout_r;
						ts_dout_en <= 1;
						end
			4'b0100	:	begin
						ts_dout	   <= ram_head_dout;
						ts_dout_en <= 1;
						end
			4'b0010	:	begin
						ts_dout	   <= ram_emm_dout;
						ts_dout_en <= 1;
						end
			4'b0001	:	begin
						ts_dout	   <= fifo_ddr_dout_r;
						ts_dout_en <= 1;
						end
			default	:	begin
						ts_dout	   <= 0;
						ts_dout_en <= 0;
						end
			endcase
			end
	end
				
endmodule
