`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:27:11 01/20/2010 
// Design Name: 
// Module Name:    vod_ddr2_ctrl 
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
module ddr3_interface(
		clk,
		reset,
		
		rd_fifo_rempty,
		rd_fifo_rreq,
		rd_fifo_rdata,
	
		dvb_flag_overflow,
		
		wr_fifo_rempty,
		wr_fifo_rreq,
		wr_fifo_rdata,
		wr_fifo_rcnt,
		
		app_rd_data_valid,
		app_rd_data,
		
//		iptv_data_valid,
		dvb_data_valid,
		C_data,
		
		app_wdf_rdy,
		app_rdy,
		app_wdf_wren,
		app_en,
		app_addr,
		app_cmd,
		app_wdf_data,
		app_wdf_mask,
		app_wdf_end
		);
		
	parameter	IDLE		=	3'b000,
				WR_ADDR_REQ	=	3'b001,
				WR_DATA_WIT	=	3'b010,
				WR_DATA_REQ	=	3'b011,
				RD_ADDR_REQ	=	3'b100,
				RD_DATA_REQ	=	3'b101,
				RD_DATA_END	=	3'b110;
		
	input			clk;
	input			reset;
	
	input			rd_fifo_rempty;
	output			rd_fifo_rreq;
	input	[35:0]	rd_fifo_rdata;

	input			dvb_flag_overflow;
	
	input			wr_fifo_rempty;
	output			wr_fifo_rreq;
	input	[512:0]	wr_fifo_rdata;
	input	[8:0]	wr_fifo_rcnt;
	
	input			app_rd_data_valid;
	input	[511:0]	app_rd_data;
	
	output			dvb_data_valid;
	output	[512:0]	C_data;
//	output			iptv_data_valid;
	
	input			app_wdf_rdy;
	input			app_rdy;
	output			app_wdf_wren;
	output			app_en;
	output	[28:0]	app_addr;
	output	[2:0]	app_cmd;	
	output	[511:0]	app_wdf_data;
	output	[63:0]	app_wdf_mask;
	output			app_wdf_end;
	
	reg				rd_fifo_rreq;
	reg				rd_fifo_rvalid;
	reg				app_rd_c;
	reg				addr_sig;
	reg		[3:0]	mpmc_cnt;
	reg		[2:0]	rd_addr_cnt;
	reg		[1:0]	rd_data_cnt;
	
	reg				app_wr_doing, app_wr_c;
	reg				wr_fifo_rreq_1, wr_fifo_rreq_2;
	reg				wr_fifo_rvalid_1, wr_fifo_rvalid_2;
	reg		[3:0]	wr_data_cnt, wr_addr_cnt;
	
	reg		[2:0]	ddr_cur_state;
	reg		[2:0]	ddr_next_state;
	
	reg				dvb_data_valid;
	reg		[512:0]	C_data;
//	reg				iptv_data_valid;
	reg				app_en;
	reg				app_wdf_wren;
	reg				app_wdf_end;
	reg		[2:0]	app_cmd;
	reg		[28:0]	app_addr;
	reg		[26:0]	app_wr_addr, app_rd_addr;
	reg		[511:0]	app_wdf_data;
	
	reg				ecm_sig, iptv_sig, dvb_sig;
	
	
	wire	[63:0]	app_wdf_mask;
	assign	app_wdf_mask = 64'h0;
	
	wire			wr_fifo_rreq;
	assign	wr_fifo_rreq = wr_fifo_rreq_1 | wr_fifo_rreq_2;
	
	always @(posedge clk)
	begin
		if(reset)
			ddr_cur_state	<=	IDLE;
		else
			ddr_cur_state	<=	ddr_next_state;
	end
	
	always @(ddr_cur_state or rd_fifo_rempty or dvb_flag_overflow  or wr_fifo_rempty or app_rdy or app_wdf_rdy or wr_fifo_rdata or wr_fifo_rcnt or rd_addr_cnt or app_rd_data_valid or wr_data_cnt or wr_addr_cnt)
	begin
		rd_fifo_rreq		=	1'b0;
		wr_fifo_rreq_1		=	1'b0;
		wr_fifo_rreq_2		=	1'b0;
		app_wr_doing		=	1'b0;
		app_wr_c			=	1'b0;
		app_rd_c			=	1'b0;
		ddr_next_state		=	IDLE;
		case(ddr_cur_state)
			IDLE: begin
				if(!wr_fifo_rempty)
				begin
					wr_fifo_rreq_1	=	1'b1;
					ddr_next_state	=	WR_ADDR_REQ;
				end else if(!rd_fifo_rempty && !dvb_flag_overflow  )
				begin
					rd_fifo_rreq	=	1'b1;
					ddr_next_state	=	RD_ADDR_REQ;
				end else 
					ddr_next_state	=	IDLE;
			end 
			
			WR_ADDR_REQ: begin
				if(wr_fifo_rdata[512] == 1'b1)
				begin
					ddr_next_state	=	WR_DATA_WIT;
				end else if(wr_fifo_rdata[512] == 1'b0)
				begin
					ddr_next_state	=	IDLE;
				end else
					ddr_next_state	=	WR_ADDR_REQ;
			end
			
			WR_DATA_WIT: begin
				if(wr_fifo_rcnt >= 4) 
					ddr_next_state	=	WR_DATA_REQ;
				else  
					ddr_next_state	=	WR_DATA_WIT;
			end
			
			WR_DATA_REQ: begin
				app_wr_doing	=	1'b1;
				if(wr_data_cnt	== 4 && wr_addr_cnt == 4)
					ddr_next_state	=	IDLE;
				else
					ddr_next_state	=	WR_DATA_REQ;
					
				if(app_wdf_rdy && wr_data_cnt < 2)
				begin
					wr_fifo_rreq_2	=	1'b1;
				end
				
				if(app_rdy && wr_addr_cnt < 4)
				begin
					app_wr_c	=	1'b1;
				end 
			end
			
			RD_ADDR_REQ:
			begin
				ddr_next_state	=	RD_DATA_REQ;
			end 
			
			RD_DATA_REQ: begin
				if(rd_addr_cnt == 4)
					ddr_next_state	=	RD_DATA_END;
				else if(app_rdy)
				begin
					app_rd_c	=	1'b1;
					ddr_next_state	=	RD_DATA_REQ;
				end else
					ddr_next_state	=	RD_DATA_REQ;
			end
			
			RD_DATA_END: begin
				if(app_rd_data_valid)
					ddr_next_state	=	IDLE;
				else
					ddr_next_state	=	RD_DATA_END;
			end
		endcase
		
	end
	
//write fifo request
	always @(posedge clk)
	begin
		wr_fifo_rvalid_1	<=	wr_fifo_rreq_1;
	end

	always @(posedge clk)
	begin
		if(reset)
		begin
			wr_fifo_rvalid_2	<=	0;
		end else if(app_wdf_rdy)
		begin
			wr_fifo_rvalid_2	<=	wr_fifo_rreq_2;
		end		
	end
	
//write ddr data ena and data
	always @(posedge clk)
	begin
		if(reset)
		begin
			app_wdf_wren	<=	0;
			app_wdf_end		<=	0;
			app_wdf_data	<=	0;
		end else if(app_wdf_rdy)
		begin
			app_wdf_wren	<=	wr_fifo_rvalid_2;
			app_wdf_end		<=	wr_fifo_rvalid_2;
			app_wdf_data	<=	wr_fifo_rdata[511:0];
		end
	end

	
//write data count
	always @(posedge clk)
	begin
		if(reset)
			wr_data_cnt	<=	0;
		else if(!app_wr_doing)
			wr_data_cnt	<=	0;
		else if(app_wdf_wren && app_wdf_rdy)
			wr_data_cnt	<=	wr_data_cnt + 1;
	end
	
	
//write address count
	always @(posedge clk)
	begin
		if(reset)
			wr_addr_cnt	<=	0;
		else if(!app_wr_doing)
			wr_addr_cnt	<=	0;
		else if(app_wr_c && app_rdy)
			wr_addr_cnt	<=	wr_addr_cnt + 1;
	end

	always @(posedge clk)
	begin
		if(reset)
			app_wr_addr		<=	0;
		else if(wr_fifo_rvalid_1)
			app_wr_addr		<=	wr_fifo_rdata[29:3];
		else if(app_wr_c && app_rdy)
			app_wr_addr		<=	app_wr_addr + 8;
	end
	
	
//read fifo request	
	always @(posedge clk)
	begin
		if(reset)
			rd_fifo_rvalid	<=	0;
		else
			rd_fifo_rvalid	<=	rd_fifo_rreq;
	end
	
//read address acquiration
	always @(posedge clk)
	begin
		if(reset)
		begin
			mpmc_cnt	<=	0;
			addr_sig	<=	0;
		end else if(rd_fifo_rvalid)
		begin
			mpmc_cnt	<=	rd_fifo_rdata[35:32];
			addr_sig	<=	rd_fifo_rdata[31];
		end
	end
	
//ecm packet sig
	always @(posedge clk)
	begin
		if(reset)
		begin
			ecm_sig	<=	0;
		end
		else if(rd_fifo_rvalid)
		begin
			ecm_sig	<=	rd_fifo_rdata[28];
		end
	end
	
//iptv or dvb sig
	always @(posedge clk)
	begin
		if(reset)
		begin
			iptv_sig	<=	0;
		end
		else if(rd_fifo_rvalid)
		begin
			iptv_sig	<=	!rd_fifo_rdata[28] & rd_fifo_rdata[22];
		end
	end
	
//iptv or dvb sig
	always @(posedge clk)
	begin
		if(reset)
		begin
			dvb_sig	<=	0;
		end
		else if(rd_fifo_rvalid)
		begin
			dvb_sig	<=	!rd_fifo_rdata[28] & !rd_fifo_rdata[22];
		end
	end
	
	always @(posedge clk)
	begin
		if(reset)
			app_rd_addr		<=	0;
		else if(rd_fifo_rvalid)
			app_rd_addr		<=	rd_fifo_rdata[29:3];
		else if(app_rd_c)
			app_rd_addr		<=	app_rd_addr + 8;
	end
	

//app address and command	
	always @(posedge clk)
	begin
		if(reset)
		begin
			app_en		<=	0;
			app_addr	<=	0;
			app_cmd		<=	0;
		end else if(app_wr_c && app_rdy)
		begin
			app_en		<=	1'b1;
			app_addr	<=	{2'b0, app_wr_addr};
			app_cmd		<=	0;
		end else if(app_rd_c && app_rdy)
		begin
			app_en		<=	1'b1;
			app_addr	<=	{2'b0, app_rd_addr};
			app_cmd		<=	3'b001;
		end else if(app_rdy)
		begin
			app_en		<=	0;
			app_cmd		<=	0;
		end
	end
	
//read address count	
	always @(posedge clk)
	begin
		if(reset)
			rd_addr_cnt	<=	0;
		else if(rd_addr_cnt == 4)
			rd_addr_cnt	<=	0;
		else if(app_rd_c)
			rd_addr_cnt	<=	rd_addr_cnt + 1;
	end
	
//read data output
	always @(posedge clk)
	begin
		if(reset)
			rd_data_cnt	<=	0;
		else if(app_rd_data_valid && rd_data_cnt == 3)
			rd_data_cnt	<=	0;
		else if(app_rd_data_valid)
			rd_data_cnt	<=	rd_data_cnt + 1;
	end

/*	
	always @(posedge clk)
	begin
		if(reset)
			iptv_data_valid	<=	0;
		else if(app_rd_data_valid && (ecm_sig || iptv_sig))
			iptv_data_valid	<=	1;
		else
			iptv_data_valid	<=	0;
	end
*/
	
	always @(posedge clk)
	begin
		if(reset)
			dvb_data_valid	<=	0;
		else if(app_rd_data_valid && (ecm_sig || dvb_sig))
			dvb_data_valid	<=	1;
		else
			dvb_data_valid	<=	0;
	end
	
	always @(posedge clk)
	begin
		if(reset)
			C_data	<=	0;
		else if(app_rd_data_valid && addr_sig && (rd_data_cnt == 0))
			C_data <= {1'b1, app_rd_data[511:396], mpmc_cnt, app_rd_data[391:0]};
		else if(app_rd_data_valid && !addr_sig && (rd_data_cnt == 0))
			C_data <= {1'b1, app_rd_data};
		else
			C_data <= {1'b0, app_rd_data};
	end
	
						
	

	
	endmodule
	