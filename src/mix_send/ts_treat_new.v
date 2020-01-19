`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2014/01/03 14:51:25
// Design Name: 
// Module Name: ts_treat_new
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ts_treat_new(

	input				clk			,
	input				reset		,
	input		[63:0]	ts_din	,
	input				ts_din_en	,
	
	input				tx_over_full,
	            		
	output	reg [63:0]	ts_dout	,//8字节有效数据，不满时 填高位空低位
	output	reg [7:0]	ts_mask,//对应8字节，有效为1 
	output	reg			ts_dout_en	,
	output 	reg			ts_sof,//帧起始
	output 	reg			ts_eof,//帧结束
	output				prog_full	,
	output				full		
);

	reg 	[47:0]		mac_tmp;
	reg		[31:0]		ip_tmp;
	reg		[15:0]		port_tmp;
	
	
	reg		[63:0]		ts_din_r1,ts_din_r2,ts_din_r3,ts_din_r4,ts_din_r5;
	reg					ts_din_en_r1,ts_din_en_r2,ts_din_en_r3,ts_din_en_r4;
	
	reg 				new_frame;
	
	
	parameter			WR_FRAME_IDLE=0,
						WR_FRAME_END=1,
						WR_FRAME_MAC=2,						
						WR_FRAME_IP_PORT=3,					
						WR_FRAME_TS1=4,
						WR_FRAME_TS2=5,
						
						WR_FRAME_WAIT=6;
	reg		[3:0]		wr_cstate;
	reg		[3:0]		wr_nstate;
	reg		[7:0]		wr_ts_cnt;
	parameter			TS_LEN	=23;
	reg		[65:0]		wr_fifo_din;//包头 写66‘h25555555555555555+MAC+IPPORT+184/8+{2'b01,ts最后4字节，32’h0000000000}
	reg					wr_en;
	reg 	[7:0]		ts_cnt;
	reg 	[3:0]		ts_num;
	
	
	parameter 			RD_FRAME_IDLE=0,
						RD_FRAME_TS_FIRST=1,
						RD_FRAME_TS_ODD=2,
						RD_FRAME_TS_EVEN=3,						
						RD_FRAME_WAIT=4;
	reg		[1:0]		rd_cstate;
	reg		[1:0]		rd_nstate;
	reg		[2:0]		wait_cnt;
	wire	[65:0]		rd_fifo_dout;
	reg 	[65:0]		rd_fifo_dout_r;
	reg [65:0]			rd_fifo_dout_r2;
	wire				rd_en;
	// wire				full;
	// wire				prog_full;
	wire				empty;
	reg 	[2:0]		frame_cnt;
	reg					frame_in_fifo;
	reg 	[4:0]		rd_cnt_first;
	reg 	[4:0]		rd_cnt_even;
	reg 	[4:0]		rd_cnt_odd;
	reg 				frame_cnt_inc;
	reg					frame_cnt_dec;
	
	
	
	always@(posedge clk)
	begin
	if(reset)
	ts_cnt			<=0;
	else if(ts_din_en)
	ts_cnt			<=ts_cnt+1;
	else
	ts_cnt			<=0;
	end
	
	
	always@(posedge clk)
	begin
	if(reset)
	begin
	ts_din_r1		<=0;
	ts_din_r2		<=0;
	ts_din_r3		<=0;
	ts_din_r4		<=0;
	ts_din_r5		<=0;
	ts_din_en_r1	<=0;
	ts_din_en_r2	<=0;
	ts_din_en_r3	<=0;
	ts_din_en_r4	<=0;
	end
	else 
	begin
	ts_din_r1		<=ts_din;
	ts_din_r2		<=ts_din_r1;
	ts_din_r3		<=ts_din_r2;
	ts_din_r4		<=ts_din_r3;
	ts_din_r5		<=ts_din_r4;
	ts_din_en_r1	<=ts_din_en;
	ts_din_en_r2	<=ts_din_en_r1;
	ts_din_en_r3	<=ts_din_en_r2;
	ts_din_en_r4	<=ts_din_en_r3;
	end
	end
	
	always@(posedge clk)
	begin
	if(reset)
	begin
	mac_tmp			<=0;
	ip_tmp			<=0;
	port_tmp		<=0;
	end
	else if(ts_cnt==1)
	begin
	mac_tmp			<=ts_din_r1[47:0];
	ip_tmp			<=ts_din[47:16];
	port_tmp		<=ts_din[15:0];
	end
	else 
	begin
	mac_tmp			<=mac_tmp;
	ip_tmp			<=ip_tmp;
	port_tmp		<=port_tmp;
	end
	end
	
	
	always@(posedge clk)
	begin
	if(reset)
	ts_num		<=0;
	else if(new_frame)
	ts_num		<=0;
	else if(ts_cnt==5)
	ts_num		<=ts_num+1;
	else 
	ts_num		<=ts_num;
	end
	////////////////write frame
	always@(posedge clk)
	begin
	if(reset)
	new_frame		<=0;
	else if(ts_cnt==1&&({ts_din_r1[47:0],ts_din[47:0]}!={mac_tmp,ip_tmp,port_tmp}))//新的IP PORT出现
	new_frame		<=1;
	//满7个包 需要重新写入IP PORT头
	else if(ts_cnt==1&& (ts_num==7))
	new_frame		<=1;
	else 
	new_frame		<=0;
	end

	
	always@(posedge clk)
	begin
	if(reset)
	wr_cstate		<=WR_FRAME_IDLE;
	else
	wr_cstate		<=wr_nstate;
	end
	
	always@(wr_cstate or new_frame or wr_ts_cnt or ts_cnt  or ts_num )
	begin
	case(wr_cstate)
	WR_FRAME_IDLE:
	if(ts_cnt==2 &&new_frame )
	wr_nstate		=WR_FRAME_END;
	else if(ts_cnt==2 && !new_frame)
	wr_nstate		=WR_FRAME_TS2;
	else
	wr_nstate		=WR_FRAME_IDLE;
	WR_FRAME_END:
	wr_nstate		=WR_FRAME_MAC;
	WR_FRAME_MAC:	
	wr_nstate		=WR_FRAME_IP_PORT;
	WR_FRAME_IP_PORT:	
	wr_nstate		=WR_FRAME_TS1;
	WR_FRAME_TS1:
	if(wr_ts_cnt==TS_LEN )	
	wr_nstate		=WR_FRAME_WAIT;	
	else
	wr_nstate		=WR_FRAME_TS1;
	WR_FRAME_TS2:
	if(wr_ts_cnt==TS_LEN)	
	wr_nstate		=WR_FRAME_WAIT;	
	else
	wr_nstate		=WR_FRAME_TS2;
	WR_FRAME_WAIT:
	wr_nstate		=WR_FRAME_IDLE;
	default:	
	wr_nstate		=WR_FRAME_IDLE;
	endcase
	end
	
	
	always@(posedge clk)
	begin
	if(reset)
	wr_ts_cnt		<=0;
	else if(wr_cstate==WR_FRAME_TS1 ||wr_cstate==WR_FRAME_TS2 )
	wr_ts_cnt		<=wr_ts_cnt+1;
	else
	wr_ts_cnt		<=0;
	end
	
	
	always@(posedge clk)
	begin
	if(reset)
	begin
	wr_fifo_din		<=0;
	wr_en			<=0;
	end
	else if(wr_nstate == WR_FRAME_MAC||wr_nstate == WR_FRAME_IP_PORT ||wr_nstate == WR_FRAME_TS1)
	begin
	if(wr_ts_cnt==22)
	begin
	wr_fifo_din		<={2'b1,ts_din_r3};
	wr_en			<=1;
	end 
	else 
	begin
	wr_fifo_din		<={2'b0,ts_din_r3};
	wr_en			<=1;
	end
	end
	else if(wr_nstate == WR_FRAME_TS2)
	begin
	if(wr_ts_cnt==22)
	begin
	wr_fifo_din		<={2'b1,ts_din};
	wr_en			<=1;
	end 
	else 
	begin
	wr_fifo_din		<={2'b0,ts_din};
	wr_en			<=1;
	end
	end
	else if(wr_nstate == WR_FRAME_END)	
	begin
	wr_fifo_din		<=66'h25555555555555555;
	wr_en			<=1;
	end
	else 
	begin
	wr_fifo_din		<=0;
	wr_en			<=0;
	end
	end
	
	//////////////////////READ FRAME
		always@(posedge clk)
	begin
	if(rst)
	frame_cnt_inc	<=0;
	else if(wr_cstate==WR_FRAME_END) 
	frame_cnt_inc	<=1;
	else 
	frame_cnt_inc	<=0;
	end
	
	always@(posedge clk)
	begin
	if(rst)
	frame_cnt_dec	<=0;
	else if(rd_cstate==RD_FRAME_IDLE && rd_nstate==RD_FRAME_TS_FIRST)
	frame_cnt_dec	<=1;
	else 
	frame_cnt_dec<=0;
	end
	
	
	always@(posedge clk)
	begin
	if(reset)
	frame_cnt		<=0;
	else if(frame_cnt_inc&& !frame_cnt_dec)
	frame_cnt		<=frame_cnt+1;
	else if(! frame_cnt_inc && frame_cnt_dec)
	frame_cnt		<=frame_cnt-1;
	else
	frame_cnt		<=frame_cnt;
	end
	
	always@(posedge clk)
	begin
	if(reset)
	frame_in_fifo	<=0;
	else if(empty)
	frame_in_fifo	<=0;
	else if(frame_cnt==0)
	frame_in_fifo	<=0;
	else 
	frame_in_fifo	<=1;
	end
	
	
	always@(posedge clk)
	begin
	if(reset)
	begin
		rd_fifo_dout_r<=0;
		rd_fifo_dout_r2<=0;
	end
	else 
	begin
		rd_fifo_dout_r<=rd_fifo_dout;
		rd_fifo_dout_r2<=rd_fifo_dout_r;
	end
	end
	
	always@(posedge clk)
	begin
	if(reset)
	rd_cstate		<=0;
	else
	rd_cstate		<=rd_nstate;
	end
	
	always@(rd_cstate or frame_in_fifo or tx_over_full  or rd_fifo_dout or wait_cnt)
	begin
	case(rd_cstate)
	RD_FRAME_IDLE:
	if(frame_in_fifo && ! tx_over_full)
	rd_nstate		=RD_FRAME_TS_FIRST;
	else
	rd_nstate		=RD_FRAME_IDLE;
	RD_FRAME_TS_FIRST:
	if(rd_fifo_dout[65])
	rd_nstate		=RD_FRAME_WAIT;
	else if(rd_fifo_dout[64])
	rd_nstate		=RD_FRAME_TS_EVEN;
	else
	rd_nstate		=RD_FRAME_TS_FIRST;
	RD_FRAME_TS_EVEN:
	if(rd_fifo_dout[65])
	rd_nstate		=RD_FRAME_WAIT;
	else if(rd_fifo_dout[64])
	rd_nstate		=RD_FRAME_TS_ODD;
	else
	rd_nstate		=RD_FRAME_TS_EVEN;
	RD_FRAME_TS_ODD:
	if(rd_fifo_dout[65])
	rd_nstate		=RD_FRAME_WAIT;
	else if(rd_fifo_dout[64])
	rd_nstate		=RD_FRAME_TS_EVEN;
	else
	rd_nstate		=RD_FRAME_TS_ODD;
	RD_FRAME_WAIT:
	if(wait_cnt==7)
	rd_nstate		=RD_FRAME_IDLE;
	else
	rd_nstate		=RD_FRAME_WAIT;
	default:
	rd_nstate		=RD_FRAME_IDLE;
	endcase
	end
	
	assign rd_en=(rd_nstate==RD_FRAME_TS_FIRST||rd_nstate==RD_FRAME_TS_EVEN||rd_nstate==RD_FRAME_TS_ODD)?1'b1:1'b0;
	
	always @(posedge clk)
	begin
	if(reset)
	rd_cnt_first	<=0;
	else if(rd_cstate==RD_FRAME_TS_FIRST)
	rd_cnt_first<=rd_cnt_first+1;
	else 
	rd_cnt_first<=0;	
	end
	
	always @(posedge clk)
	begin
	if(reset)
	rd_cnt_even	<=0;
	else if(rd_cstate==RD_FRAME_TS_EVEN)
	rd_cnt_even<=rd_cnt_even+1;
	else 
	rd_cnt_even<=0;	
	end
	
	always @(posedge clk)
	begin
	if(reset)
	rd_cnt_odd	<=0;
	else if(rd_cstate==RD_FRAME_TS_ODD)
	rd_cnt_odd<=rd_cnt_odd+1;
	else 
	rd_cnt_odd<=0;	
	end
	
	always@(posedge clk)
	begin
	if(reset)
	begin
	ts_dout			<=0;
	ts_dout_en		<=0;
	ts_mask		<=0;
	ts_sof			<=0;
	ts_eof			<=0;
	end
	//////////////////////////
	else if(rd_cstate==RD_FRAME_TS_FIRST )
	begin	
	if(rd_cnt_first==0 && !rd_fifo_dout[65] )
	begin
	ts_dout			<=rd_fifo_dout[63:0];
	ts_dout_en		<=1;
	ts_mask		<=8'hff;
	ts_sof			<=1;
	ts_eof			<=0;
	end		 
	else if(rd_cnt_first>0 && rd_cnt_first<25)
	begin
	ts_dout			<=rd_fifo_dout[63:0];
	ts_dout_en		<=1;
	ts_mask		<=8'hff;
	ts_sof			<=0;
	ts_eof			<=0;
	end	
	else 	begin
	ts_dout			<=0;
	ts_dout_en	<=0;
	ts_mask		<=0;
	ts_sof			<=0;
	ts_eof			<=0;
	end	
	end	
	//////////////////////////
	else if(rd_cstate==RD_FRAME_TS_EVEN )
	begin
	if(rd_cnt_even==0)
	begin
	if(rd_fifo_dout[65])
	begin
	ts_dout			<=rd_fifo_dout_r[63:0];
	ts_dout_en	<=1;
	ts_mask		<=8'hf0;
	ts_sof			<=0;
	ts_eof			<=1;	
	end
	else 
	begin
	ts_dout			<={rd_fifo_dout_r[63:32],rd_fifo_dout[63:32]};
	ts_dout_en	<=1;
	ts_mask		<=8'hff;
	ts_sof			<=0;
	ts_eof			<=0;	
	end	
	end
	else if(rd_cnt_even>0 && rd_cnt_even <23)
	begin
	ts_dout			<={rd_fifo_dout_r[31:0],rd_fifo_dout[63:32]};
	ts_dout_en	<=1;
	ts_mask		<=8'hff;
	ts_sof			<=0;
	ts_eof			<=0;	
	end
	else 	begin
	ts_dout			<=0;
	ts_dout_en	<=0;
	ts_mask		<=0;
	ts_sof			<=0;
	ts_eof			<=0;
	end	
	end
	//////////////////////////
	else if(rd_cstate==RD_FRAME_TS_ODD )
	begin
	if(rd_cnt_odd==0)
	begin	
	ts_dout			<={rd_fifo_dout_r2[31:0],rd_fifo_dout_r[63:32]};
	ts_dout_en	<=1;
	ts_mask		<=8'hff;
	ts_sof			<=0;
	ts_eof			<=rd_fifo_dout[65];	
	end
	else //if(rd_cnt_odd>=0&&rd_cnt_odd<23)
	begin
	ts_dout			<={rd_fifo_dout_r[63:0]};
	ts_dout_en	<=1;
	ts_mask		<=8'hff;
	ts_sof			<=0;
	ts_eof			<=0;	
	end	
	end	
	//////////////////////////
		
	else 
	begin
		ts_dout		<=0;
	ts_dout_en	<=0;
	ts_mask		<=0;
	ts_sof			<=0;
	ts_eof			<=0;	
	end
	end
	
	always@(posedge clk)
	begin
	if(reset)
	wait_cnt		<=0;
	else if(rd_cstate==RD_FRAME_WAIT)
	wait_cnt		<=wait_cnt+1;
	else 
	wait_cnt		<=0;
	end
	
	//////////////////////
	
anatreat_fifo fifo_ts (
  .clk(clk),              // input wire clk
  .rst(reset),              // input wire rst
  .din(wr_fifo_din),              // input wire [65 : 0] din
  .wr_en(wr_en),          // input wire wr_en
  .rd_en(rd_en),          // input wire rd_en
  .dout(rd_fifo_dout),            // output wire [65 : 0] dout
  .full(full),            // output wire full
  .empty(empty),          // output wire empty
  .prog_full(prog_full)  // output wire prog_full
);
	
	

endmodule
