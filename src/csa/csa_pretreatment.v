`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:16:15 05/07/2009 
// Design Name: 
// Module Name:    mux_data_send 
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
// data packet frame header
// {1'b1, count_packet[31:0]}
// {1'b0, 29'b0,pid_flag,csa_flag,csa_oe}
// {1'b0, cw[63:64]}
// {1'b1, cw[31:0]}   
//{}
//////////////////////////////////////////////////////////////////////////////////
module csa_pretreatment(
    			clk_main,    			
				rst,
				
				ts_din,
				ts_din_en,
				finish_blk_enc,				
			
				en_count_packet,
				count_packet,				 
				ts_dout,
				en_ts_dout,
				pid_num,
				en_pid_num,
				gbe_num,
				en_gbe_num,
				ip_port,
				en_ip_port,
				cw_data,
				en_cw_data
    			);



	input			clk_main;
	
	input			rst;
	
	input	[32:0]	ts_din;
	input			ts_din_en;
	input			finish_blk_enc;
    
	output	[7:0]	ts_dout;
	output			en_ts_dout;	
	
	output		[7:0]pid_num;
	output			en_pid_num;
	output		[7:0]	gbe_num;
	output			en_gbe_num;
	output		[7:0]	ip_port;
	output			en_ip_port;
	output	[7:0]	cw_data;
	output			en_cw_data;	
	
	output      en_count_packet; 
	output[7:0] count_packet; 

	
	reg		[7:0]	ts_dout;
	reg				en_ts_dout;	
	reg		[7:0]pid_num;
	reg			en_pid_num;
	reg		[7:0]	gbe_num;
	reg			en_gbe_num;
	reg		[7:0]	ip_port;
	reg			en_ip_port;
	reg		[7:0]	cw_data;
	reg				en_cw_data;
	reg       en_count_packet; 
	reg[7:0]  count_packet; 
		
	reg		[32:0]	ts_valid;
	reg				en_valid;
	reg		[8:0]	count_valid;
	
	reg				rd_blkf;
	wire	[32:0]	dout_blkf;
	wire			pfull_blkf;
	wire 		empty;
//	wire      full_blkf_b;
			
	reg		[1:0]	send_state;				
	
	reg				full_blkf;

	reg	[1:0]	rd_blkf_cnt;
	
	
	parameter  WATCH_DOG_AGE = 8000; 
	reg[12:0]	 count_state; 
	
//	reg[7:0]	 idx_blkf; 
//	reg        en_dout_blkf;
	
//	reg        miss_sync_blkf; 
	
//	reg[7:0]   idx_wr_blkf;
//	reg        miss_sync_blkf_in; 
	
//	always@(posedge clk_main)
//	begin
//	   full_blkf <= full_blkf_b;	   
//	end	
	
	
	always @(posedge clk_main)
	begin
		if(rst)
		begin
			send_state	<= 2'b01;
		end
		else
		begin			
			case(send_state)
				2'b01:
					begin
						if(pfull_blkf == 1 && ! empty)
						begin
							send_state	<= 2'b10;
						end
						else
						begin
							send_state <= 2'b01;
						end
					end
				2'b10:
					begin
						if(count_valid == 219)
						begin
							send_state <= 2'b11;
						end
						else
						begin
							send_state <= 2'b10;
						end
					end
				2'b11:
					begin
						if(finish_blk_enc || (count_state > WATCH_DOG_AGE) ) 
						begin
							send_state <= 2'b01;
						end
						else
						begin
							send_state <= 2'b11;
						end
					end
				default:
					begin
						send_state <= 2'b01;
					end
			endcase
		end
	end
	
	always @ (posedge clk_main)
	begin
		if (rst)
			begin
				count_state <= 0; 
			end 
		else 
			begin
				if (send_state == 2'b11)
					begin
						count_state <= count_state + 1; 						
					end 
				else 
					begin
						count_state <= 0; 
					end 
			end 
	end 
	
	////count for reading from ram every four clock cycles
	always @(posedge clk_main)
	begin
		if(rst)
			rd_blkf_cnt	<=	0;
		else if(send_state == 2'b01)
			rd_blkf_cnt	<=	0;
		else if(rd_blkf_cnt == 3)
			rd_blkf_cnt	<=	0;
		else if(send_state==2'b10)
			rd_blkf_cnt	<=	rd_blkf_cnt + 1;
	end
	
	always @ (posedge clk_main)
	begin
		if (rst)
			begin
				rd_blkf <= 0; 
			end 
		else 
			begin
				if (send_state==2'b10 && rd_blkf_cnt==0 && count_valid < 216)
					begin
						rd_blkf <= 1; 
					end 
				else 
					begin
						rd_blkf <= 0; 
					end 
			end 
	end 
	
//	always @ (posedge clk_main)
//	begin
//		en_dout_blkf <= rd_blkf; 
//	end 
	
//	always@(posedge clk_main)
//		begin
//			if(rst)
//				begin
//					idx_blkf <= 0;
//				end
//			else
//				begin
//					if (send_state == 2'b10)
//						begin
//							if (en_dout_blkf)
//							begin
//								idx_blkf <= idx_blkf + 1;
//							end
//							else
//							begin
//								idx_blkf <= idx_blkf;
//							end
//						end					
//					else 
//						begin
//							idx_blkf <= 0;
//						end 
//				end
//		end	 
//	
//	always @ (posedge clk_main)
//	begin
//		if (rst)
//			begin
//				miss_sync_blkf <= 0; 
//			end 
//		else 
//			begin
//				if(send_state == 2'b10)
//				begin			
//					if((en_dout_blkf==1'b1) && (dout_blkf[64] == 1'b1))			
//					begin
//						if (idx_blkf>0)	
//							begin
//								miss_sync_blkf <= 1; 
//							end 
//						else 
//							begin
//								miss_sync_blkf <= 0; 
//							end 
//					end
//					else
//					begin
//						miss_sync_blkf <= 0; 
//					end
//				end		
//				else
//				begin
//					miss_sync_blkf <= 0; 
//				end
//			end 
//	end 
	
		
	always @(posedge clk_main)
	begin
		if(send_state == 2'b10)
		begin			
			if(dout_blkf[32] == 1'b1)			
			begin
				en_valid	<= 1'b1;				
			end
			else
			begin
				en_valid	<= en_valid;										
			end
		end		
		else
		begin
			en_valid	<= 0;			
		end
	end				
	
	always @(posedge clk_main)
	begin
		if(send_state == 2'b10)
		begin
			ts_valid	<= dout_blkf[31:0];
		end
		else
		begin
			ts_valid	<= 0;
		end
	end
	
	always @(posedge clk_main)
	begin
		if(rst)
		begin
			count_valid	<= 8'b0;
		end
		else if(en_valid == 1'b1)
		begin
			count_valid	<= count_valid + 1;
		end
		else
		begin
			count_valid	<= 8'b0;
		end
	end	
	
//////////output count data/////////////////////	
	always @(posedge clk_main)
	begin
		if(en_valid == 1'b1 && count_valid == 0)
		begin
			count_packet <= ts_valid[7:0];
			en_count_packet <= 1; 
		end
		else
		begin
			count_packet <= 0; 
			en_count_packet <= 0; 
		end
	end

///////////output head data//////////////////////	
	always @(posedge clk_main)
	begin
		if(en_valid == 1'b1 && count_valid==18)
		begin
			pid_num <=ts_valid[15:8];
			en_pid_num	<=	1'b1;			
		end
		else if(en_valid == 1'b1 && count_valid==19)
		begin
			pid_num <=ts_valid[7:0];
			en_pid_num	<=	1'b1;			
		end
		else
		begin
					pid_num <=0;
					en_pid_num	<=	1'b0;					
		end
	end
	
	
	always @(posedge clk_main)
	begin
		if(en_valid == 1'b1 && count_valid==23)
		begin
			gbe_num <=ts_valid[7:0];
			en_gbe_num	<=	1'b1;					
		end
		else
		begin
			gbe_num <=0;
			en_gbe_num	<=	1'b0;					
		end
	end
		
		
	always @(posedge clk_main)
	begin
		if(en_valid == 1'b1)
		begin
			case(count_valid)			
				9'h18:
				begin
					ip_port	<= ts_valid[31:24];//IP
					en_ip_port	<= 1'b1;
				end
				9'h19:
				begin
					ip_port	<= ts_valid[23:16];
					en_ip_port	<= 1'b1;
				end
				9'h1a:
				begin
					ip_port	<= ts_valid[15:8];
					en_ip_port	<= 1'b1;
				end
				9'h1b:
				begin
					ip_port	<= ts_valid[7:0];
					en_ip_port	<= 1'b1;
				end
				9'h1e:
				begin
					ip_port	<= ts_valid[15:8];//PORT
					en_ip_port	<= 1'b1;
				end
				9'h1f:
				begin
					ip_port	<= ts_valid[7:0];
					en_ip_port	<= 1'b1;
				end
				default:
				begin
					ip_port	<= 0;
					en_ip_port	<= 1'b0;
				end
			endcase
		end
		else
		begin
					ip_port<=0;
					en_ip_port	<=	1'b0;					
		end
	end	
	
	

/////////output cw data////////////////////////	
	always @(posedge clk_main)
	begin
		if(en_valid == 1'b1 &&( count_valid == 4 ||count_valid >=8 && count_valid <= 15))
		begin
			case(count_valid)
				9'h4:
				begin
					cw_data[7:2]	<=	6'b0;				
					cw_data[1]		<= ts_valid[2] & ts_valid[1];		//csa_flag
					cw_data[0]		<= ts_valid[0];					//csa_oe
					en_cw_data	<=	1'b1;
				end
				9'h8:
				begin
					cw_data	<=	ts_valid[31:24];
					en_cw_data	<=	1'b1;
				end
				9'h9:
				begin
					cw_data	<=	ts_valid[23:16];
					en_cw_data	<=	1'b1;
				end
				9'ha:
				begin
					cw_data	<=	ts_valid[15:8];
					en_cw_data	<=	1'b1;
				end
				9'hb:
				begin
					cw_data	<=	ts_valid[7:0];
					en_cw_data	<=	1'b1;
				end
				9'hc:
				begin
					cw_data	<=	ts_valid[31:24];
					en_cw_data	<=	1'b1;
				end
				9'hd:
				begin
					cw_data	<=	ts_valid[23:16];
					en_cw_data	<=	1'b1;
				end
				9'he:
				begin
					cw_data	<=	ts_valid[15:8];
					en_cw_data	<=	1'b1;
				end
				9'hf:
				begin
					cw_data	<=	ts_valid[7:0];
					en_cw_data	<=	1'b1;
				end	
				default:
				begin
					cw_data	<=	0;
					en_cw_data	<=	1'b0;
				end
			endcase
		end else
		begin
			cw_data	<= 0;
			en_cw_data	<= 0;
		end
	end			

//////////output ts data////////////////////////////	
	always @(posedge clk_main)
	begin
		if(en_valid == 1'b1 &&  count_valid >= 32 && count_valid <= 219)
		begin
			en_ts_dout	<= 1'b1;
		end
		else
		begin
			en_ts_dout	<= 1'b0;
		end
	end
	
		
	always @(posedge clk_main)
	begin
		if(rst)
		begin
			ts_dout	<= 8'b0;
		end
		else
		begin
			case(rd_blkf_cnt)
//				3'b011:
//					ts_dout	<=	ts_valid[63:56];
//				3'b100:
//					ts_dout	<=	ts_valid[55:48];
//				3'b101:
//					ts_dout	<=	ts_valid[47:40];
//				3'b110:
//					ts_dout	<=	ts_valid[39:32];
				2'b11:
					ts_dout	<=	ts_valid[31:24];
				2'b00:
					ts_dout	<=	ts_valid[23:16];
				2'b01:
					ts_dout	<=	ts_valid[15:8];
				2'b10:
					ts_dout	<=	ts_valid[7:0];
				default:
					ts_dout	<=	0;
			endcase
		end
	end

	
	csa_fifo_blk	m_csa_fifo_blk(
				.din			(ts_din),
				.rd_clk			(clk_main),
				.rd_en			(rd_blkf),
				.rst			(rst),
				.wr_clk			(clk_main),
				.wr_en			(ts_din_en),
				.dout			(dout_blkf),
				.empty			(empty),
				.full			(),
				.prog_full      (pfull_blkf)
				);				

//	always@(posedge clk_main)
//		begin
//			if(rst)
//				begin
//					idx_wr_blkf <= 0;
//				end
//			else
//				begin
//					if(ts_din_en)
//						begin					
//							if(idx_wr_blkf==51)
//								begin
//									idx_wr_blkf <= 0;
//								end
//							else
//								begin
//									idx_wr_blkf <= idx_wr_blkf + 1;
//								end
//						end
//					else
//						begin
//							idx_wr_blkf <= idx_wr_blkf;
//						end					
//				end
//		end
//	
//	always@(posedge clk_main)
//		begin
//			if(rst)
//				begin
//					miss_sync_blkf_in  <= 0;					
//				end
//			else
//				begin					
//					if((ts_din_en==1'b1) && (idx_wr_blkf==0) && (ts_din[64]!=1'b1))					
//						begin												
//							miss_sync_blkf_in <= 1;								
//						end
//					else
//						begin							
//							miss_sync_blkf_in <= 0; 
//						end					
//				end
//		end	
				
endmodule

