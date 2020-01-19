`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:00:19 09/23/2019 
// Design Name: 
// Module Name:    tsmf_split_v1 
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
module tsmf_split_v1(
		
		
	clk,
	rst,

	ts_din,
	ts_din_en,



	freq_con_din,
	freq_con_din_en,

	channel_din,//取IP PORT配置命令的前两字节
	channel_din_en,

//	pcie_clk

	ts_ram_wr,
	ts_ram_wdata,
	
	test_flag


    );
    
  input clk;
	input rst;

	input [31:0]ts_din;
	input	ts_din_en;



	input [7:0]freq_con_din;
	input		freq_con_din_en;

	input	[7:0]channel_din;
	input 	channel_din_en;

//	input pcie_clk;

	
	output ts_ram_wr;
	output [511:0]ts_ram_wdata;
	output 	test_flag;


	reg ts_ram_wr;
	reg [511:0]ts_ram_wdata; 
	
	
	reg[16:0]freq_reg_1;//最高为1 ，启用该通道。
	reg[16:0]freq_reg_2;
	reg[16:0]freq_reg_3;
	reg[16:0]freq_reg_4;
	reg[16:0]freq_reg_5;
	reg[16:0]freq_reg_6;
	reg[16:0]freq_reg_7;
	reg[16:0]freq_reg_8;

	reg[4:0]freq_cnt;
	
	reg	ts_din_en_r;
	reg	channel_din_en_r;
	
	reg		[3:0]channel_num;
	
	always@(posedge clk)begin
		ts_din_en_r	<=	ts_din_en;
	end
	
	
	always@(posedge clk)begin
		if(freq_con_din_en)
			freq_cnt	<=	freq_cnt+1;
		else
			freq_cnt	<=0;
	end

	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_1	<=0;
		else if(freq_cnt==2)
			freq_reg_1	<={freq_reg_1[15:0],freq_con_din[0]};
		else if(freq_cnt==3)
			freq_reg_1	<={freq_reg_1[8:0],freq_con_din};
		else if(freq_cnt==4)
			freq_reg_1	<={freq_reg_1[8:0],freq_con_din};
		else
			freq_reg_1	<=freq_reg_1;
	end


	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_2	<=0;
		else if(freq_cnt==5)
			freq_reg_2	<={freq_reg_2[15:0],freq_con_din[0]};
		else if(freq_cnt==6)
			freq_reg_2	<={freq_reg_2[8:0],freq_con_din};
		else if(freq_cnt==7)
			freq_reg_2	<={freq_reg_2[8:0],freq_con_din};
		else
			freq_reg_2	<=freq_reg_2;
	end

	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_3	<=0;
		else if(freq_cnt==8)
			freq_reg_3	<={freq_reg_3[15:0],freq_con_din[0]};
		else if(freq_cnt==9)
			freq_reg_3	<={freq_reg_3[8:0],freq_con_din};
		else if(freq_cnt==10)
			freq_reg_3	<={freq_reg_3[8:0],freq_con_din};
		else
			freq_reg_3	<=freq_reg_3;
	end

	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_4	<=0;
		else if(freq_cnt==11)
			freq_reg_4	<={freq_reg_4[15:0],freq_con_din[0]};
		else if(freq_cnt==12)
			freq_reg_4	<={freq_reg_4[8:0],freq_con_din};
		else if(freq_cnt==13)
			freq_reg_4	<={freq_reg_4[8:0],freq_con_din};
		else
			freq_reg_4	<=freq_reg_4;
	end

	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_5	<=0;
		else if(freq_cnt==14)
			freq_reg_5	<={freq_reg_5[15:0],freq_con_din[0]};
		else if(freq_cnt==15)
			freq_reg_5	<={freq_reg_5[8:0],freq_con_din};
		else if(freq_cnt==16)
			freq_reg_5	<={freq_reg_5[8:0],freq_con_din};
		else
			freq_reg_5	<=freq_reg_5;
	end

	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_6	<=0;
		else if(freq_cnt==17)
			freq_reg_6	<={freq_reg_6[15:0],freq_con_din[0]};
		else if(freq_cnt==18)
			freq_reg_6	<={freq_reg_6[8:0],freq_con_din};
		else if(freq_cnt==19)
			freq_reg_6	<={freq_reg_6[8:0],freq_con_din};
		else
			freq_reg_6	<=freq_reg_6;
	end
	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_7	<=0;
		else if(freq_cnt==20)
			freq_reg_7	<={freq_reg_7[15:0],freq_con_din[0]};
		else if(freq_cnt==21)
			freq_reg_7	<={freq_reg_7[8:0],freq_con_din};
		else if(freq_cnt==22)
			freq_reg_7	<={freq_reg_7[8:0],freq_con_din};
		else
			freq_reg_7	<=freq_reg_7;
	end
	always@(posedge clk )begin
		if(freq_cnt==1)
			freq_reg_8	<=0;
		else if(freq_cnt==23)
			freq_reg_8	<={freq_reg_8[15:0],freq_con_din[0]};
		else if(freq_cnt==24)
			freq_reg_8	<={freq_reg_8[8:0],freq_con_din};
		else if(freq_cnt==25)
			freq_reg_8	<={freq_reg_8[8:0],freq_con_din};
		else
			freq_reg_8	<=freq_reg_8;
	end
	
	
	reg	[5:0]tf_wcstate;
	reg	[5:0]tf_wnstate;
	
	reg		ram_sel;
	reg		ram_sel_r;
	reg		tf_ram_full_1;
	reg		tf_ram_full_2;
	
	reg	[15:0]pack_cnt;
	reg	[5:0]ts_cnt;
	parameter TS_NUM=46;
	parameter	TS_HEAD_NUM=48;
	reg [3:0]frame_cnt;
	reg	[3:0]stream_order;
	reg	[2:0]tf_cnt;
	reg	[2:0]tf_cnt_r;
	
	
	reg	[11:0]tf_waddr;
	reg	[31:0]tf_wdata;
	reg	tf_wr;
	reg	[7:0]tf_ram1_raddr;
	wire[511:0]tf_ram1_rdata;
	reg	[7:0]tf_ram2_raddr;
	wire[511:0]tf_ram2_rdata;
	
	
	reg	[31:0]syn_ver_slot;
	reg	[31:0]slot;

	reg	[31:0]stream_info_1;//1-8
	reg	[31:0]stream_info_2;//1-8
	reg	[31:0]stream_info_3;//1-8
	reg	[31:0]stream_info_4;//1-8
	reg	[31:0]stream_info_5;//1-8
	reg	[31:0]stream_info_6;//1-8
	reg	[31:0]stream_info_7;//1-8
	reg	[31:0]stream_info_8;//1-8
	reg	[31:0]stream_info_9;//1-8
	reg	[31:0]stream_info_10;//1-8
	reg	[31:0]stream_info_11;//1-8
	reg	[31:0]stream_info_12;//1-8
	reg	[31:0]stream_info_13;//1-8
	reg	[31:0]stream_info_14;//1-8
	reg	[31:0]stream_info_15;//1-8
	reg	[31:0]stream_info_16;//1-8

	reg	[31:0]stream_type;
	reg	[31:0]carrier_info;

	reg	[31:0]crc_reg;
	
	
	
	parameter	TF_IDLE=0,
						CH1_CHECK=3,
						CH1_TS_WAIT=4,
						CH1_TS_WRITE=5,
						CH1_TS_CHECK=6,
						CH1_TS_HEADER_VALID=7,
						CH1_TSMF_END=43,
						CH2_CHECK=8,
						CH2_TS_WAIT=9,
						CH2_TS_WRITE=10,
						CH2_TS_CHECK=11,
						CH2_TS_HEADER_VALID=12,
						CH2_TSMF_END=44,
						CH3_CHECK=13,
						CH3_TS_WAIT=14,
						CH3_TS_WRITE=15,
						CH3_TS_CHECK=16,
						CH3_TS_HEADER_VALID=17,
						CH3_TSMF_END=45,
						CH4_CHECK=18,
						CH4_TS_WAIT=19,
						CH4_TS_WRITE=20,
						CH4_TS_CHECK=21,
						CH4_TS_HEADER_VALID=22,
						CH4_TSMF_END=46,
						CH5_CHECK=23,
						CH5_TS_WAIT=24,
						CH5_TS_WRITE=25,
						CH5_TS_CHECK=26,
						CH5_TS_HEADER_VALID=27,
						CH5_TSMF_END=47,
						CH6_CHECK=28,
						CH6_TS_WAIT=29,
						CH6_TS_WRITE=30,
						CH6_TS_CHECK=31,
						CH6_TS_HEADER_VALID=32,
						CH6_TSMF_END=48,
						CH7_CHECK=33,
						CH7_TS_WAIT=34,
						CH7_TS_WRITE=35,
						CH7_TS_CHECK=36,
						CH7_TS_HEADER_VALID=37,
						CH7_TSMF_END=49,
						CH8_CHECK=38,
						CH8_TS_WAIT=39,
						CH8_TS_WRITE=40,
						CH8_TS_CHECK=41,
						CH8_TS_HEADER_VALID=42,
						CH8_TSMF_END=50;
						
	reg	[2:0]tf_rcstate;
	reg	[2:0]tf_rnstate;
	
	parameter	RD_IDLE=0,										
						RD_TS_RAM_1=1,
						RD_RAM_DONE_1=2,
						RD_RAM_JUDGE_1=3,
						RD_INTERVAL=4,
						RD_TS_RAM_2=5,						
						RD_RAM_DONE_2=6,
						RD_RAM_JUDGE_2=7;
						
	reg	pcie_ram_sel;
	reg	pcie_ram_sel_r;
	reg	pcie_ram_full_1;
	reg	pcie_ram_full_2;	
	
	
	reg	[10:0]pcie_waddr;
	reg	[511:0]pcie_wdata;
	reg	pcie_wr;
	reg	[10:0]pcie_ram1_raddr;
	wire[511:0]pcie_ram1_rdata;
	reg	[10:0]pcie_ram2_raddr;
	wire[511:0]pcie_ram2_rdata;		
	
	reg	[2:0]sp_rcstate;
	reg	[2:0]sp_rnstate;
		
	parameter	SP_IDLE=0,
						SP_TS_RAM_1=1,
						SP_RAM_DONE_1=2,
						SP_RAM_JUDGE_1=3,
						SP_INTERVAL=4,
						SP_TS_RAM_2=5,						
						SP_RAM_DONE_2=6,
						SP_RAM_JUDGE_2=7;
				
						
	always@(posedge clk)begin
		if(rst)
			tf_wcstate		<=	TF_IDLE;
		else
			tf_wcstate		<=	tf_wnstate;
	end						 

	always@(*)begin
		case(tf_wcstate)
			TF_IDLE:
				tf_wnstate		=	CH1_CHECK;
			CH1_CHECK:
				if(freq_reg_1[16])
					tf_wnstate	=	CH1_TS_WAIT;
				else
					tf_wnstate	=CH2_CHECK;
			CH1_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					tf_wnstate	= CH1_TS_WRITE;
				else
					tf_wnstate	=	CH1_TS_WAIT;
			CH1_TS_WRITE:
				if(ts_cnt==TS_NUM)
					tf_wnstate	=	CH1_TS_CHECK;
				else
					tf_wnstate	=	CH1_TS_WRITE;
			CH1_TS_CHECK:
				if(!freq_reg_1[16])
					tf_wnstate	=	CH1_TS_HEADER_VALID;
				else if(pack_cnt+1==freq_reg_1[15:0])
					tf_wnstate	=	CH1_TS_HEADER_VALID;
				else
					tf_wnstate	= CH1_TS_WAIT;
			CH1_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					tf_wnstate	= CH1_TSMF_END;
				else
					tf_wnstate	=	CH1_TS_HEADER_VALID;
			CH1_TSMF_END:
				tf_wnstate	=	CH2_CHECK;
				
			CH2_CHECK:
				if(freq_reg_2[16])
				tf_wnstate	=	CH2_TS_WAIT;
				else
					tf_wnstate	=CH3_CHECK;
			CH2_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					tf_wnstate	= CH2_TS_WRITE;
				else
					tf_wnstate	=	CH2_TS_WAIT;
			CH2_TS_WRITE:
				if(ts_cnt==TS_NUM)
					tf_wnstate	=	CH2_TS_CHECK;
				else
					tf_wnstate	=	CH2_TS_WRITE;
			CH2_TS_CHECK:
				if(!freq_reg_2[16])
					tf_wnstate	=	CH2_TS_HEADER_VALID;
				else if(pack_cnt+1==freq_reg_2[15:0])
					tf_wnstate	=	CH2_TS_HEADER_VALID;
				else
					tf_wnstate	= CH2_TS_WAIT;
			CH2_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					tf_wnstate	= CH2_TSMF_END;
				else
					tf_wnstate	=	CH2_TS_HEADER_VALID;
			CH2_TSMF_END:
				tf_wnstate	=	CH3_CHECK;

			CH3_CHECK:
				if(freq_reg_3[16])
				tf_wnstate	=	CH3_TS_WAIT;
				else
					tf_wnstate	=CH4_CHECK;
			CH3_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					tf_wnstate	= CH3_TS_WRITE;
				else
					tf_wnstate	=	CH3_TS_WAIT;
			CH3_TS_WRITE:
				if(ts_cnt==TS_NUM)
					tf_wnstate	=	CH3_TS_CHECK;
				else
					tf_wnstate	=	CH3_TS_WRITE;
			CH3_TS_CHECK:
			if(!freq_reg_3[16])
					tf_wnstate	=	CH3_TS_HEADER_VALID;
				else if(pack_cnt+1==freq_reg_3[15:0])
					tf_wnstate	=	CH3_TS_HEADER_VALID;
				else
					tf_wnstate	= CH3_TS_WAIT;
			CH3_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					tf_wnstate	= CH3_TSMF_END;
				else
					tf_wnstate	=	CH3_TS_HEADER_VALID;
			CH3_TSMF_END:
				tf_wnstate	=	CH4_CHECK;
				
			CH4_CHECK:
				if(freq_reg_4[16])
				tf_wnstate	=	CH4_TS_WAIT;
				else
					tf_wnstate	=CH5_CHECK;
			CH4_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					tf_wnstate	= CH4_TS_WRITE;
				else
					tf_wnstate	=	CH4_TS_WAIT;
			CH4_TS_WRITE:
				if(ts_cnt==TS_NUM)
					tf_wnstate	=	CH4_TS_CHECK;
				else
					tf_wnstate	=	CH4_TS_WRITE;
			CH4_TS_CHECK:
				if(!freq_reg_4[16])
					tf_wnstate	=	CH4_TS_HEADER_VALID;
				else if(pack_cnt+1==freq_reg_4[15:0])
					tf_wnstate	=	CH4_TS_HEADER_VALID;
				else
					tf_wnstate	= CH4_TS_WAIT;
			CH4_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					tf_wnstate	= CH4_TSMF_END;
				else
					tf_wnstate	=	CH4_TS_HEADER_VALID;
			CH4_TSMF_END:
				tf_wnstate	=	CH5_CHECK;

			CH5_CHECK:
				if(freq_reg_5[16])
				tf_wnstate	=	CH5_TS_WAIT;
				else
					tf_wnstate	=CH6_CHECK;
			CH5_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					tf_wnstate	= CH5_TS_WRITE;
				else
					tf_wnstate	=	CH5_TS_WAIT;
			CH5_TS_WRITE:
				if(ts_cnt==TS_NUM)
					tf_wnstate	=	CH5_TS_CHECK;
				else
					tf_wnstate	=	CH5_TS_WRITE;
			CH5_TS_CHECK:
				if(!freq_reg_5[16])
					tf_wnstate	=	CH5_TS_HEADER_VALID;
				else 
				if(pack_cnt+1==freq_reg_5[15:0])
					tf_wnstate	=	CH5_TS_HEADER_VALID;
				else
					tf_wnstate	= CH5_TS_WAIT;
			CH5_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					tf_wnstate	= CH5_TSMF_END;
				else
					tf_wnstate	=	CH5_TS_HEADER_VALID;
			CH5_TSMF_END:
				tf_wnstate	=	CH6_CHECK;

			CH6_CHECK:
				if(freq_reg_6[16])
				tf_wnstate	=	CH6_TS_WAIT;
				else
					tf_wnstate	=CH7_CHECK;
			CH6_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					tf_wnstate	= CH6_TS_WRITE;
				else
					tf_wnstate	=	CH6_TS_WAIT;
			CH6_TS_WRITE:
				if(ts_cnt==TS_NUM)
					tf_wnstate	=	CH6_TS_CHECK;
				else
					tf_wnstate	=	CH6_TS_WRITE;
			CH6_TS_CHECK:
			if(!freq_reg_6[16])
					tf_wnstate	=	CH6_TS_HEADER_VALID;
				else 
				if(pack_cnt+1==freq_reg_6[15:0])
					tf_wnstate	=	CH6_TS_HEADER_VALID;
				else
					tf_wnstate	= CH6_TS_WAIT;
			CH6_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					tf_wnstate	= CH6_TSMF_END;
				else
					tf_wnstate	=	CH6_TS_HEADER_VALID;
			CH6_TSMF_END:
				tf_wnstate	=	CH7_CHECK;

			CH7_CHECK:
				if(freq_reg_7[16])
				tf_wnstate	=	CH7_TS_WAIT;
				else
					tf_wnstate	=CH8_CHECK;
			CH7_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					tf_wnstate	= CH7_TS_WRITE;
				else
					tf_wnstate	=	CH7_TS_WAIT;
			CH7_TS_WRITE:
				if(ts_cnt==TS_NUM)
					tf_wnstate	=	CH7_TS_CHECK;
				else
					tf_wnstate	=	CH7_TS_WRITE;
			CH7_TS_CHECK:
				if(!freq_reg_7[16])
					tf_wnstate	=	CH7_TS_HEADER_VALID;
				else 
				if(pack_cnt+1==freq_reg_7[15:0])
					tf_wnstate	=	CH7_TS_HEADER_VALID;
				else
					tf_wnstate	= CH7_TS_WAIT;
			CH7_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					tf_wnstate	= CH7_TSMF_END;
				else
					tf_wnstate	=	CH7_TS_HEADER_VALID;
			CH7_TSMF_END:
				tf_wnstate	=	CH8_CHECK;

			CH8_CHECK:
				if(freq_reg_8[16])
				tf_wnstate	=	CH8_TS_WAIT;
				else
					tf_wnstate	=TF_IDLE;
			CH8_TS_WAIT:
				if(ts_din_en&!ts_din_en_r)
					tf_wnstate	= CH8_TS_WRITE;
				else
					tf_wnstate	=	CH8_TS_WAIT;
			CH8_TS_WRITE:
				if(ts_cnt==TS_NUM)
					tf_wnstate	=	CH8_TS_CHECK;
				else
					tf_wnstate	=	CH8_TS_WRITE;
			CH8_TS_CHECK:
				if(!freq_reg_8[16])
					tf_wnstate	=	CH8_TS_HEADER_VALID;
				else 
				if(pack_cnt+1==freq_reg_8[15:0])
					tf_wnstate	=	CH8_TS_HEADER_VALID;
				else
					tf_wnstate	= CH8_TS_WAIT;
			CH8_TS_HEADER_VALID:
				if(ts_cnt==TS_HEAD_NUM)
					tf_wnstate	= CH8_TSMF_END;
				else
					tf_wnstate	=	CH8_TS_HEADER_VALID;
			CH8_TSMF_END:
				tf_wnstate	=	TF_IDLE;
					
			default:
				tf_wnstate	=	TF_IDLE;		
			
		endcase
	end    
	
	always@(posedge clk)begin
		channel_din_en_r	<=	channel_din_en;
		if(rst)
			syn_ver_slot	<=0;
		else if(channel_din_en&&!channel_din_en_r)
			syn_ver_slot	<={16'h1a86,5'b0,channel_din,3'b0};
		else	if(!channel_din_en&&channel_din_en_r)
			syn_ver_slot	<={syn_ver_slot[31:3],channel_din[7:5]};
		else
			syn_ver_slot	<=syn_ver_slot;
	end
	
	always@(posedge clk)begin
		if(rst)
			slot	<=0;
		else if(!channel_din_en&&channel_din_en_r)
			slot	<={channel_din[4:1],28'h0};
		else
			slot	<=slot;
	end

	always@(posedge clk)begin
		stream_type	<=	{17'h0,15'h7fff};
		carrier_info	<={8'h11,8'h08,8'h00,8'h00};
		crc_reg			<=32'haaaaaaaa;
	end
	 
	 
	 always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_1	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h0
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_1	<={stream_order,stream_info_1[27:0]};
				3'd1:
					stream_info_1	<={stream_info_1[31:28],stream_order,stream_info_1[23:0]};
				3'd2:
					stream_info_1	<={stream_info_1[31:24],stream_order,stream_info_1[19:0]};
				3'd3:
					stream_info_1	<={stream_info_1[31:20],stream_order,stream_info_1[15:0]};
				3'd4:
					stream_info_1	<={stream_info_1[31:16],stream_order,stream_info_1[11:0]};
				3'd5:
					stream_info_1	<={stream_info_1[31:12],stream_order,stream_info_1[7:0]};
				3'd6:
					stream_info_1	<={stream_info_1[31:8],stream_order,stream_info_1[3:0]};
				3'd7:
					stream_info_1	<={stream_info_1[31:4],stream_order};

				default:
					stream_info_1	<=stream_info_1;
			endcase
		end
		else
			stream_info_1	<=	stream_info_1;
	end
	
	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_2	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h1
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_2	<={stream_order,stream_info_2[27:0]};
				3'd1:
					stream_info_2	<={stream_info_2[31:28],stream_order,stream_info_2[23:0]};
				3'd2:
					stream_info_2	<={stream_info_2[31:24],stream_order,stream_info_2[19:0]};
				3'd3:
					stream_info_2	<={stream_info_2[31:20],stream_order,stream_info_2[15:0]};
				3'd4:
					stream_info_2	<={stream_info_2[31:16],stream_order,stream_info_2[11:0]};
				3'd5:
					stream_info_2	<={stream_info_2[31:12],stream_order,stream_info_2[7:0]};
				3'd6:
					stream_info_2	<={stream_info_2[31:8],stream_order,stream_info_2[3:0]};
				3'd7:
					stream_info_2	<={stream_info_2[31:4],stream_order};

				default:
					stream_info_2	<=stream_info_2;
			endcase
		end
		else
			stream_info_2	<=	stream_info_2;
	end
	
	
	
	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_3	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h2
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_3	<={stream_order,stream_info_3[27:0]};
				3'd1:
					stream_info_3	<={stream_info_3[31:28],stream_order,stream_info_3[23:0]};
				3'd2:
					stream_info_3	<={stream_info_3[31:24],stream_order,stream_info_3[19:0]};
				3'd3:
					stream_info_3	<={stream_info_3[31:20],stream_order,stream_info_3[15:0]};
				3'd4:
					stream_info_3	<={stream_info_3[31:16],stream_order,stream_info_3[11:0]};
				3'd5:
					stream_info_3	<={stream_info_3[31:12],stream_order,stream_info_3[7:0]};
				3'd6:
					stream_info_3	<={stream_info_3[31:8],stream_order,stream_info_3[3:0]};
				3'd7:
					stream_info_3	<={stream_info_3[31:4],stream_order};

				default:
					stream_info_3	<=stream_info_3;
			endcase
		end
		else
			stream_info_3	<=	stream_info_3;
	end


	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_4	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h3
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_4	<={stream_order,stream_info_4[27:0]};
				3'd1:
					stream_info_4	<={stream_info_4[31:28],stream_order,stream_info_4[23:0]};
				3'd2:
					stream_info_4	<={stream_info_4[31:24],stream_order,stream_info_4[19:0]};
				3'd3:
					stream_info_4	<={stream_info_4[31:20],stream_order,stream_info_4[15:0]};
				3'd4:
					stream_info_4	<={stream_info_4[31:16],stream_order,stream_info_4[11:0]};
				3'd5:
					stream_info_4	<={stream_info_4[31:12],stream_order,stream_info_4[7:0]};
				3'd6:
					stream_info_4	<={stream_info_4[31:8],stream_order,stream_info_4[3:0]};
				3'd7:
					stream_info_4	<={stream_info_4[31:4],stream_order};

				default:
					stream_info_4	<=stream_info_4;
			endcase
		end
		else
			stream_info_4	<=	stream_info_4;
	end


	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_5	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h4
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_5	<={stream_order,stream_info_5[27:0]};
				3'd1:
					stream_info_5	<={stream_info_5[31:28],stream_order,stream_info_5[23:0]};
				3'd2:
					stream_info_5	<={stream_info_5[31:24],stream_order,stream_info_5[19:0]};
				3'd3:
					stream_info_5	<={stream_info_5[31:20],stream_order,stream_info_5[15:0]};
				3'd4:
					stream_info_5	<={stream_info_5[31:16],stream_order,stream_info_5[11:0]};
				3'd5:
					stream_info_5	<={stream_info_5[31:12],stream_order,stream_info_5[7:0]};
				3'd6:
					stream_info_5	<={stream_info_5[31:8],stream_order,stream_info_5[3:0]};
				3'd7:
					stream_info_5	<={stream_info_5[31:4],stream_order};

				default:
					stream_info_5	<=stream_info_5;
			endcase
		end
		else
			stream_info_5	<=	stream_info_5;
	end

	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_6	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h5
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_6	<={stream_order,stream_info_6[27:0]};
				3'd1:
					stream_info_6	<={stream_info_6[31:28],stream_order,stream_info_6[23:0]};
				3'd2:
					stream_info_6	<={stream_info_6[31:24],stream_order,stream_info_6[19:0]};
				3'd3:
					stream_info_6	<={stream_info_6[31:20],stream_order,stream_info_6[15:0]};
				3'd4:
					stream_info_6	<={stream_info_6[31:16],stream_order,stream_info_6[11:0]};
				3'd5:
					stream_info_6	<={stream_info_6[31:12],stream_order,stream_info_6[7:0]};
				3'd6:
					stream_info_6	<={stream_info_6[31:8],stream_order,stream_info_6[3:0]};
				3'd7:
					stream_info_6	<={stream_info_6[31:4],stream_order};

				default:
					stream_info_6	<=stream_info_6;
			endcase
		end
		else
			stream_info_6	<=	stream_info_6;
	end


	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_7	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h6
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_7	<={stream_order,stream_info_7[27:0]};
				3'd1:
					stream_info_7	<={stream_info_7[31:28],stream_order,stream_info_7[23:0]};
				3'd2:
					stream_info_7	<={stream_info_7[31:24],stream_order,stream_info_7[19:0]};
				3'd3:
					stream_info_7	<={stream_info_7[31:20],stream_order,stream_info_7[15:0]};
				3'd4:
					stream_info_7	<={stream_info_7[31:16],stream_order,stream_info_7[11:0]};
				3'd5:
					stream_info_7	<={stream_info_7[31:12],stream_order,stream_info_7[7:0]};
				3'd6:
					stream_info_7	<={stream_info_7[31:8],stream_order,stream_info_7[3:0]};
				3'd7:
					stream_info_7	<={stream_info_7[31:4],stream_order};

				default:
					stream_info_7	<=stream_info_7;
			endcase
		end
		else
			stream_info_7	<=	stream_info_7;
	end

	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_8	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h7
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_8	<={stream_order,stream_info_8[27:0]};
				3'd1:
					stream_info_8	<={stream_info_8[31:28],stream_order,stream_info_8[23:0]};
				3'd2:
					stream_info_8	<={stream_info_8[31:24],stream_order,stream_info_8[19:0]};
				3'd3:
					stream_info_8	<={stream_info_8[31:20],stream_order,stream_info_8[15:0]};
				3'd4:
					stream_info_8	<={stream_info_8[31:16],stream_order,stream_info_8[11:0]};
				3'd5:
					stream_info_8	<={stream_info_8[31:12],stream_order,stream_info_8[7:0]};
				3'd6:
					stream_info_8	<={stream_info_8[31:8],stream_order,stream_info_8[3:0]};
				3'd7:
					stream_info_8	<={stream_info_8[31:4],stream_order};

				default:
					stream_info_8	<=stream_info_8;
			endcase
		end
		else
			stream_info_8	<=	stream_info_8;
	end

	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_9	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h8
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_9	<={stream_order,stream_info_9[27:0]};
				3'd1:
					stream_info_9	<={stream_info_9[31:28],stream_order,stream_info_9[23:0]};
				3'd2:
					stream_info_9	<={stream_info_9[31:24],stream_order,stream_info_9[19:0]};
				3'd3:
					stream_info_9	<={stream_info_9[31:20],stream_order,stream_info_9[15:0]};
				3'd4:
					stream_info_9	<={stream_info_9[31:16],stream_order,stream_info_9[11:0]};
				3'd5:
					stream_info_9	<={stream_info_9[31:12],stream_order,stream_info_9[7:0]};
				3'd6:
					stream_info_9	<={stream_info_9[31:8],stream_order,stream_info_9[3:0]};
				3'd7:
					stream_info_9	<={stream_info_9[31:4],stream_order};

				default:
					stream_info_9	<=stream_info_9;
			endcase
		end
		else
			stream_info_9	<=	stream_info_9;
	end

	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_10	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'h9
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_10	<={stream_order,stream_info_10[27:0]};
				3'd1:
					stream_info_10	<={stream_info_10[31:28],stream_order,stream_info_10[23:0]};
				3'd2:
					stream_info_10	<={stream_info_10[31:24],stream_order,stream_info_10[19:0]};
				3'd3:
					stream_info_10	<={stream_info_10[31:20],stream_order,stream_info_10[15:0]};
				3'd4:
					stream_info_10	<={stream_info_10[31:16],stream_order,stream_info_10[11:0]};
				3'd5:
					stream_info_10	<={stream_info_10[31:12],stream_order,stream_info_10[7:0]};
				3'd6:
					stream_info_10	<={stream_info_10[31:8],stream_order,stream_info_10[3:0]};
				3'd7:
					stream_info_10	<={stream_info_10[31:4],stream_order};

				default:
					stream_info_10	<=stream_info_10;
			endcase
		end
		else
			stream_info_10	<=	stream_info_10;
	end

	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_11	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'ha
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_11	<={stream_order,stream_info_11[27:0]};
				3'd1:
					stream_info_11	<={stream_info_11[31:28],stream_order,stream_info_11[23:0]};
				3'd2:
					stream_info_11	<={stream_info_11[31:24],stream_order,stream_info_11[19:0]};
				3'd3:
					stream_info_11	<={stream_info_11[31:20],stream_order,stream_info_11[15:0]};
				3'd4:
					stream_info_11	<={stream_info_11[31:16],stream_order,stream_info_11[11:0]};
				3'd5:
					stream_info_11	<={stream_info_11[31:12],stream_order,stream_info_11[7:0]};
				3'd6:
					stream_info_11	<={stream_info_11[31:8],stream_order,stream_info_11[3:0]};
				3'd7:
					stream_info_11	<={stream_info_11[31:4],stream_order};

				default:
					stream_info_11	<=stream_info_11;
			endcase
		end
		else
			stream_info_11	<=	stream_info_11;
	end

	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_12	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'hb
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_12	<={stream_order,stream_info_12[27:0]};
				3'd1:
					stream_info_12	<={stream_info_12[31:28],stream_order,stream_info_12[23:0]};
				3'd2:
					stream_info_12	<={stream_info_12[31:24],stream_order,stream_info_12[19:0]};
				3'd3:
					stream_info_12	<={stream_info_12[31:20],stream_order,stream_info_12[15:0]};
				3'd4:
					stream_info_12	<={stream_info_12[31:16],stream_order,stream_info_12[11:0]};
				3'd5:
					stream_info_12	<={stream_info_12[31:12],stream_order,stream_info_12[7:0]};
				3'd6:
					stream_info_12	<={stream_info_12[31:8],stream_order,stream_info_12[3:0]};
				3'd7:
					stream_info_12	<={stream_info_12[31:4],stream_order};

				default:
					stream_info_12	<=stream_info_12;
			endcase
		end
		else
			stream_info_12	<=	stream_info_12;
	end

	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_13	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'hc
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_13	<={stream_order,stream_info_13[27:0]};
				3'd1:
					stream_info_13	<={stream_info_13[31:28],stream_order,stream_info_13[23:0]};
				3'd2:
					stream_info_13	<={stream_info_13[31:24],stream_order,stream_info_13[19:0]};
				3'd3:
					stream_info_13	<={stream_info_13[31:20],stream_order,stream_info_13[15:0]};
				3'd4:
					stream_info_13	<={stream_info_13[31:16],stream_order,stream_info_13[11:0]};
				3'd5:
					stream_info_13	<={stream_info_13[31:12],stream_order,stream_info_13[7:0]};
				3'd6:
					stream_info_13	<={stream_info_13[31:8],stream_order,stream_info_13[3:0]};
				3'd7:
					stream_info_13	<={stream_info_13[31:4],stream_order};

				default:
					stream_info_13	<=stream_info_13;
			endcase
		end
		else
			stream_info_13	<=	stream_info_13;
	end


	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_14	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'hd
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_14	<={stream_order,stream_info_14[27:0]};
				3'd1:
					stream_info_14	<={stream_info_14[31:28],stream_order,stream_info_14[23:0]};
				3'd2:
					stream_info_14	<={stream_info_14[31:24],stream_order,stream_info_14[19:0]};
				3'd3:
					stream_info_14	<={stream_info_14[31:20],stream_order,stream_info_14[15:0]};
				3'd4:
					stream_info_14	<={stream_info_14[31:16],stream_order,stream_info_14[11:0]};
				3'd5:
					stream_info_14	<={stream_info_14[31:12],stream_order,stream_info_14[7:0]};
				3'd6:
					stream_info_14	<={stream_info_14[31:8],stream_order,stream_info_14[3:0]};
				3'd7:
					stream_info_14	<={stream_info_14[31:4],stream_order};

				default:
					stream_info_14	<=stream_info_14;
			endcase
		end
		else
			stream_info_14	<=	stream_info_14;
	end

	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_15	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'he
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_15	<={stream_order,stream_info_15[27:0]};
				3'd1:
					stream_info_15	<={stream_info_15[31:28],stream_order,stream_info_15[23:0]};
				3'd2:
					stream_info_15	<={stream_info_15[31:24],stream_order,stream_info_15[19:0]};
				3'd3:
					stream_info_15	<={stream_info_15[31:20],stream_order,stream_info_15[15:0]};
				3'd4:
					stream_info_15	<={stream_info_15[31:16],stream_order,stream_info_15[11:0]};
				3'd5:
					stream_info_15	<={stream_info_15[31:12],stream_order,stream_info_15[7:0]};
				3'd6:
					stream_info_15	<={stream_info_15[31:8],stream_order,stream_info_15[3:0]};
				3'd7:
					stream_info_15	<={stream_info_15[31:4],stream_order};

				default:
					stream_info_15	<=stream_info_15;
			endcase
		end
		else
			stream_info_15	<=	stream_info_15;
	end

	always@(posedge clk)begin
		if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))begin
			stream_info_16	<=0;
		end
		else if(ts_cnt==1&&pack_cnt[15:3]==12'hf
		&&((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)))begin
			case(pack_cnt[2:0])
				3'd0:
					stream_info_16	<={stream_order,stream_info_16[27:0]};
				3'd1:
					stream_info_16	<={stream_info_16[31:28],stream_order,stream_info_16[23:0]};
				3'd2:
					stream_info_16	<={stream_info_16[31:24],stream_order,stream_info_16[19:0]};
				3'd3:
					stream_info_16	<={stream_info_16[31:20],stream_order,stream_info_16[15:0]};
				3'd4:
					stream_info_16	<={stream_info_16[31:16],stream_order,stream_info_16[11:0]};
				3'd5:
					stream_info_16	<={stream_info_16[31:12],stream_order,stream_info_16[7:0]};
				3'd6:
					stream_info_16	<={stream_info_16[31:8],stream_order,stream_info_16[3:0]};
				3'd7:
					stream_info_16	<={stream_info_16[31:4],stream_order};

				default:
					stream_info_16	<=stream_info_16;
			endcase
		end
		else
			stream_info_16	<=	stream_info_16;
	end

	
	always@(posedge clk)begin
		if(tf_wcstate==TF_IDLE)
			channel_num	<=0;
		else if(tf_wcstate==CH1_TS_WAIT)
			channel_num	<=1;
		else if(tf_wcstate==CH2_TS_WAIT)
			channel_num	<=2;
		else if(tf_wcstate==CH3_TS_WAIT)
			channel_num	<=3;
		else if(tf_wcstate==CH4_TS_WAIT)
			channel_num	<=4;
		else if(tf_wcstate==CH5_TS_WAIT)
			channel_num	<=5;
		else if(tf_wcstate==CH6_TS_WAIT)
			channel_num	<=6;
		else if(tf_wcstate==CH7_TS_WAIT)
			channel_num	<=7;
		else if(tf_wcstate==CH8_TS_WAIT)
			channel_num	<=8;
		else
			channel_num	<=channel_num;
	end
	
	always@(posedge clk)begin
		if(ts_din_en&!ts_din_en_r)
			stream_order	<=ts_din[3:0];
		else
			stream_order	<=stream_order;
	end

	always@(posedge clk)begin
		if((tf_wcstate==CH1_TS_WRITE)||(tf_wcstate==CH2_TS_WRITE)||(tf_wcstate==CH3_TS_WRITE)||(tf_wcstate==CH4_TS_WRITE)
		||(tf_wcstate==CH5_TS_WRITE)||(tf_wcstate==CH6_TS_WRITE)||(tf_wcstate==CH7_TS_WRITE)||(tf_wcstate==CH8_TS_WRITE)
		||(tf_wcstate==CH1_TS_HEADER_VALID)||(tf_wcstate==CH2_TS_HEADER_VALID)||(tf_wcstate==CH3_TS_HEADER_VALID)||(tf_wcstate==CH4_TS_HEADER_VALID)
		||(tf_wcstate==CH5_TS_HEADER_VALID)||(tf_wcstate==CH6_TS_HEADER_VALID)||(tf_wcstate==CH7_TS_HEADER_VALID)||(tf_wcstate==CH8_TS_HEADER_VALID))
			ts_cnt	<=ts_cnt+1;
		else
			ts_cnt	<=0;
	end

	
	always@(posedge clk)begin
		if(rst)
			pack_cnt	<=0;
		else if((tf_wcstate==CH1_TS_CHECK)||(tf_wcstate==CH2_TS_CHECK)||(tf_wcstate==CH3_TS_CHECK)||(tf_wcstate==CH4_TS_CHECK)
		||(tf_wcstate==CH5_TS_CHECK)||(tf_wcstate==CH6_TS_CHECK)||(tf_wcstate==CH7_TS_CHECK)||(tf_wcstate==CH8_TS_CHECK))
			pack_cnt	<=pack_cnt+1;
		else if((tf_wcstate==CH1_CHECK)||(tf_wcstate==CH2_CHECK)||(tf_wcstate==CH3_CHECK)||(tf_wcstate==CH4_CHECK)
		||(tf_wcstate==CH5_CHECK)||(tf_wcstate==CH6_CHECK)||(tf_wcstate==CH7_CHECK)||(tf_wcstate==CH8_CHECK))
			pack_cnt	<=0;
		else
			pack_cnt	<=pack_cnt;
	end
	
	always@(posedge clk)begin
		if(rst)
			frame_cnt	<=0;
		else begin
			case(tf_wcstate)
				CH1_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM &freq_reg_1[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH2_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM &freq_reg_2[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH3_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM&freq_reg_3[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH4_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM&freq_reg_4[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH5_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM &freq_reg_5[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH6_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM &freq_reg_6[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH7_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM&freq_reg_7[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
				CH8_TS_HEADER_VALID:
					if(ts_cnt==TS_HEAD_NUM&&freq_reg_8[16])
						frame_cnt	<=frame_cnt+1;
					else
						frame_cnt	<=frame_cnt;
			default:
				frame_cnt<=frame_cnt;
			endcase
		end
	end
	
	
	always@(posedge clk)begin
		if(rst)
			ram_sel		<=0;
		else if((tf_wcstate==CH1_TSMF_END||tf_wcstate==CH2_TSMF_END||tf_wcstate==CH3_TSMF_END||tf_wcstate==CH4_TSMF_END
		||tf_wcstate==CH5_TSMF_END||tf_wcstate==CH6_TSMF_END||tf_wcstate==CH7_TSMF_END||tf_wcstate==CH8_TSMF_END))
			ram_sel		<=!ram_sel;
		else
			ram_sel		<=ram_sel;
	end
	
	always@(posedge clk)begin
		ram_sel_r	<=	ram_sel;
		
		if(ram_sel&&!ram_sel_r)
			tf_ram_full_1	<=1;
		else if(tf_rcstate==RD_RAM_DONE_1)
			tf_ram_full_1	<=0;
		else
			tf_ram_full_1	<=tf_ram_full_1;
			
		if(!ram_sel&&ram_sel_r)
			tf_ram_full_2	<=1;
		else if(tf_rcstate==RD_RAM_DONE_2)
			tf_ram_full_2	<=0;
		else
			tf_ram_full_2	<=tf_ram_full_2;			
	end
	
	always@(posedge clk)begin
		if(tf_wcstate==CH1_CHECK&&tf_wnstate==CH1_TS_WAIT||tf_wcstate==CH2_CHECK&&tf_wnstate==CH2_TS_WAIT
		||tf_wcstate==CH3_CHECK&&tf_wnstate==CH3_TS_WAIT||tf_wcstate==CH4_CHECK&&tf_wnstate==CH4_TS_WAIT
		||tf_wcstate==CH5_CHECK&&tf_wnstate==CH5_TS_WAIT||tf_wcstate==CH6_CHECK&&tf_wnstate==CH6_TS_WAIT
		||tf_wcstate==CH7_CHECK&&tf_wnstate==CH7_TS_WAIT||tf_wcstate==CH8_CHECK&&tf_wnstate==CH8_TS_WAIT)
			tf_waddr	<=48;
		else if(tf_wcstate==CH1_TS_WRITE||tf_wcstate==CH2_TS_WRITE||tf_wcstate==CH3_TS_WRITE||tf_wcstate==CH4_TS_WRITE
		||tf_wcstate==CH5_TS_WRITE||tf_wcstate==CH6_TS_WRITE||tf_wcstate==CH7_TS_WRITE||tf_wcstate==CH8_TS_WRITE)
			tf_waddr	<=tf_waddr+1;
		else if((tf_wcstate==CH1_TS_HEADER_VALID||tf_wcstate==CH2_TS_HEADER_VALID||tf_wcstate==CH3_TS_HEADER_VALID
		||tf_wcstate==CH4_TS_HEADER_VALID||tf_wcstate==CH5_TS_HEADER_VALID||tf_wcstate==CH6_TS_HEADER_VALID
		||tf_wcstate==CH7_TS_HEADER_VALID||tf_wcstate==CH8_TS_HEADER_VALID) )begin			
			tf_waddr	<=ts_cnt;
		end
		else
			tf_waddr	<=tf_waddr;
	end
	
	
	always@(posedge clk)begin
		if(tf_wcstate==CH1_TS_WRITE||tf_wcstate==CH2_TS_WRITE||tf_wcstate==CH3_TS_WRITE||tf_wcstate==CH4_TS_WRITE
		||tf_wcstate==CH5_TS_WRITE||tf_wcstate==CH6_TS_WRITE||tf_wcstate==CH7_TS_WRITE||tf_wcstate==CH8_TS_WRITE)begin
			tf_wr			<=ts_din_en;
			tf_wdata	<=ts_din;	
		end
		else if(tf_wcstate==CH1_TS_HEADER_VALID||tf_wcstate==CH2_TS_HEADER_VALID||tf_wcstate==CH3_TS_HEADER_VALID
		||tf_wcstate==CH4_TS_HEADER_VALID||tf_wcstate==CH5_TS_HEADER_VALID||tf_wcstate==CH6_TS_HEADER_VALID
		||tf_wcstate==CH7_TS_HEADER_VALID||tf_wcstate==CH8_TS_HEADER_VALID)begin
			case(ts_cnt)
				6'd0:begin
					tf_wr			<=1;
					tf_wdata	<={8{channel_num}};	
				end
				6'd1:begin
					tf_wr			<=1;
					tf_wdata	<=pack_cnt;
				end
				6'd2:begin//ts baotou
					tf_wdata	<={28'h475ffe1,frame_cnt};
					tf_wr		<=1;
				end
				6'd3:begin//syn_ver_slot
					tf_wdata	<=syn_ver_slot;
					tf_wr		<=1;
				end
				6'd4:begin//slot
					tf_wdata	<=slot;
					tf_wr		<=1;
				end
				6'd5:begin
					tf_wdata	<=stream_info_1;
					tf_wr		<=1;
				end
				6'd6:begin
					tf_wdata	<=stream_info_2;
					tf_wr		<=1;
				end
				6'd7:begin
					tf_wdata	<=stream_info_3;
					tf_wr		<=1;
				end
				6'd8:begin
					tf_wdata	<=stream_info_4;
					tf_wr		<=1;
				end
				6'd9:begin
					tf_wdata	<=stream_info_5;
					tf_wr		<=1;
				end
				6'd10:begin
					tf_wdata	<=stream_info_6;
					tf_wr		<=1;
				end
				6'd11:begin
					tf_wdata	<=stream_info_7;
					tf_wr		<=1;
				end
				6'd12:begin//
					tf_wdata	<=stream_info_8;
					tf_wr		<=1;
				end
				6'd13:begin//
					tf_wdata	<=stream_info_9;
					tf_wr		<=1;
				end
				6'd14:begin//
					tf_wdata	<=stream_info_10;
					tf_wr		<=1;
				end
				6'd15:begin
					tf_wdata	<=stream_info_11;
					tf_wr		<=1;
				end
				6'd16:begin
					tf_wdata	<=stream_info_12;
					tf_wr		<=1;
				end
				6'd17:begin
					tf_wdata	<=stream_info_13;
					tf_wr		<=1;
				end
				6'd18:begin
					tf_wdata	<=stream_info_14;
					tf_wr		<=1;
				end
				6'd19:begin
					tf_wdata	<=stream_info_15;
					tf_wr		<=1;
				end
				6'd20:begin
					tf_wdata	<=stream_info_16;
					tf_wr		<=1;
				end
				6'd21:begin
					tf_wdata	<=stream_type;
					tf_wr		<=1;
				end
				6'd22:begin
					tf_wdata	<=carrier_info;
					tf_wr		<=1;
				end
				6'd48:begin
					tf_wdata	<=crc_reg;
					tf_wr		<=1;
				end
				default:begin
					tf_wdata	<=0;
					tf_wr		<=1;
				end					
			endcase
		end
		else begin
			tf_wr			<=0;
			tf_wdata	<=0;	
		end
	end


//需要改成512输出？

	tsmf_ram_32_16k tsmf_ram_uut_1 (
	  .clka(clk), // input clka
	  .wea(tf_wr&!ram_sel), // input [0 : 0] wea
	  .addra(tf_waddr), // input [11 : 0] addra
	  .dina(tf_wdata), // input [31 : 0] dina
	  .clkb(clk), // input clkb
	  .addrb(tf_ram1_raddr), // input [10 : 0] addrb
	  .doutb(tf_ram1_rdata) // output [63 : 0] doutb
	);

	tsmf_ram_32_16k tsmf_ram_uut_2 (
	  .clka(clk), // input clka
	  .wea(tf_wr&ram_sel), // input [0 : 0] wea
	  .addra(tf_waddr), // input [11 : 0] addra
	  .dina(tf_wdata), // input [31 : 0] dina
	  .clkb(clk), // input clkb
	  .addrb(tf_ram2_raddr), // input [10 : 0] addrb
	  .doutb(tf_ram2_rdata) // output [63 : 0] doutb
	);
	
	
	pice_512_128k pcie_ram_uut_1 (
	  .clka(clk), // input clka
	  .wea(pcie_wr&!pcie_ram_sel), // input [0 : 0] wea
	  .addra(pcie_waddr), // input [10 : 0] addra
	  .dina(pcie_wdata), // input [511 : 0] dina
	  .clkb(clk), // input clkb
	  .addrb(pcie_ram1_raddr), // input [10 : 0] addrb
	  .doutb(pcie_ram1_rdata) // output [511 : 0] doutb
	);

	pice_512_128k pcie_ram_uut_2 (
	  .clka(clk), // input clka
	  .wea(pcie_wr&pcie_ram_sel), // input [0 : 0] wea
	  .addra(pcie_waddr), // input [10 : 0] addra
	  .dina(pcie_wdata), // input [511 : 0] dina
	  .clkb(clk), // input clkb
	  .addrb(pcie_ram2_raddr), // input [10 : 0] addrb
	  .doutb(pcie_ram2_rdata) // output [511 : 0] doutb
	);
	
	
	
		reg	[7:0]pcie_ts_cnt;
	
						
		always@(posedge clk)begin
			if(rst)
				tf_rcstate	<=	RD_IDLE;
			else
				tf_rcstate	<=	tf_rnstate;	
		end
					
		always@(*)begin
			case(tf_rcstate)
				RD_IDLE:
					if(tf_ram_full_1)
						tf_rnstate	=	RD_TS_RAM_1;
					else
						tf_rnstate	=	RD_IDLE;
				RD_TS_RAM_1:
					if(tf_ram1_raddr==8'hff)
						tf_rnstate	=	RD_RAM_DONE_1;
					else
						tf_rnstate	=	RD_TS_RAM_1;
				RD_RAM_DONE_1:
					tf_rnstate	=	RD_RAM_JUDGE_1;
				RD_RAM_JUDGE_1:
					tf_rnstate	=	RD_INTERVAL;
				RD_INTERVAL:
					if(tf_ram_full_2)
						tf_rnstate	=	RD_TS_RAM_2;
					else
						tf_rnstate	=	RD_INTERVAL;
				RD_TS_RAM_2:
					if(tf_ram2_raddr==8'hff)
						tf_rnstate	=	RD_RAM_DONE_2;
					else
						tf_rnstate	=	RD_TS_RAM_2;
				RD_RAM_DONE_2:
					tf_rnstate	=	RD_RAM_JUDGE_2;
				RD_RAM_JUDGE_2:
					tf_rnstate	=	RD_IDLE;
			endcase
		end		
		
		
		always@(posedge clk)begin
			if(tf_rcstate==RD_TS_RAM_1 ||tf_rcstate==RD_TS_RAM_2)
				pcie_ts_cnt	<=	pcie_ts_cnt+1;
			else
				pcie_ts_cnt	<=0;
		end
		
		always@(posedge clk)begin
			if(rst)
				tf_cnt	<=0;
			else if(tf_rcstate==RD_RAM_DONE_1||RD_RAM_DONE_2==tf_rcstate)
				tf_cnt	<=	tf_cnt	+1;
			else
				tf_cnt	<=	tf_cnt;
		end
		
		always@(posedge clk)
			tf_cnt_r	<=	tf_cnt;
		
	
		
		always@(posedge clk)begin
			if(tf_rnstate==RD_TS_RAM_1)
				tf_ram1_raddr	<=	tf_ram1_raddr+1;
			else
				tf_ram1_raddr	<=0;
		end
		
		always@(posedge clk)begin
			if(tf_rnstate==RD_TS_RAM_2)
				tf_ram2_raddr	<=	tf_ram2_raddr+1;
			else
				tf_ram2_raddr	<=0;
		end
		
		
		always@(posedge clk)begin
			if(tf_rcstate==RD_TS_RAM_1||tf_rcstate==RD_RAM_DONE_1)begin
				pcie_wr		<=1;
				pcie_wdata	<=tf_ram1_rdata;	
			end
			else if(tf_rcstate==RD_TS_RAM_2||tf_rcstate==RD_RAM_DONE_2)begin
				pcie_wr		<=1;
				pcie_wdata	<=tf_ram2_rdata;	
			end
			else begin
				pcie_wr		<=0;
				pcie_wdata	<=0;				
			end
		end	
		
		always@(posedge clk)begin
			if(rst)
				pcie_waddr	<=0;
			else if(tf_rcstate==RD_TS_RAM_1||tf_rcstate==RD_RAM_DONE_1)
				pcie_waddr	<={tf_cnt, pcie_ts_cnt};
			else if(tf_rcstate==RD_TS_RAM_2||tf_rcstate==RD_RAM_DONE_2)
				pcie_waddr	<={tf_cnt, pcie_ts_cnt};
			else
				pcie_waddr	<=pcie_waddr;
		end
		
		always@(posedge clk)begin
			if(rst)
				pcie_ram_sel	<=0;
			else	if((tf_rcstate==RD_RAM_JUDGE_1||tf_rcstate==RD_RAM_JUDGE_2)&&tf_cnt==0&&tf_cnt_r==7)
				pcie_ram_sel	<=!pcie_ram_sel;
			else
				pcie_ram_sel	<=pcie_ram_sel;		
		end
		
		always@(posedge clk)begin
			pcie_ram_sel_r	<=pcie_ram_sel;
			
			if(rst)
				pcie_ram_full_1	<=0;
			else	if(pcie_ram_sel& !pcie_ram_sel_r)
				pcie_ram_full_1	<=1;
			else if(sp_rcstate==SP_RAM_JUDGE_1)
				pcie_ram_full_1	<=0;
			else
				pcie_ram_full_1	<=pcie_ram_full_1;
			if(rst)
				pcie_ram_full_2	<=0;
			else if(!pcie_ram_sel& pcie_ram_sel_r)
				pcie_ram_full_2	<=1;
			else if(sp_rcstate==SP_RAM_JUDGE_2)
				pcie_ram_full_2	<=0;	
			else
				pcie_ram_full_2	<=pcie_ram_full_2;	
		end
		

		

		always@(posedge clk)begin
			if(rst)
				sp_rcstate	<=	SP_IDLE;
			else
				sp_rcstate	<=	sp_rnstate;
		end
	
		always@(*)begin
			case(sp_rcstate)
				SP_IDLE:
					if(pcie_ram_full_1)
						sp_rnstate	=	SP_TS_RAM_1;
					else
						sp_rnstate	=	SP_IDLE;
				SP_TS_RAM_1:
					if(pcie_ram1_raddr==11'h7ff)
						sp_rnstate	=	SP_RAM_DONE_1;
					else
						sp_rnstate	=	SP_TS_RAM_1;
				SP_RAM_DONE_1:
					sp_rnstate	=	SP_RAM_JUDGE_1;
				SP_RAM_JUDGE_1:
					sp_rnstate	=	SP_INTERVAL;
				SP_INTERVAL:
					if(pcie_ram_full_2)
						sp_rnstate	=	SP_TS_RAM_2;
					else
						sp_rnstate	=	SP_INTERVAL;
				SP_TS_RAM_2:
					if(pcie_ram2_raddr==11'h7ff)
						sp_rnstate	=	SP_RAM_DONE_2;
					else
						sp_rnstate	=	SP_TS_RAM_2;
				SP_RAM_DONE_2:
					sp_rnstate	=	SP_RAM_JUDGE_2;
				SP_RAM_JUDGE_2:
					sp_rnstate	=	SP_IDLE;	
					
			endcase
		end
		
		
		always@(posedge clk)begin
			if(sp_rnstate==SP_TS_RAM_1)
				pcie_ram1_raddr	<=	pcie_ram1_raddr+1;
			else
				pcie_ram1_raddr	<=0;
		end
		
		always@(posedge clk)begin
			if(sp_rnstate==SP_TS_RAM_2)
				pcie_ram2_raddr	<=	pcie_ram2_raddr+1;
			else
				pcie_ram2_raddr	<=0;
		end
	
	
		always@(posedge clk)begin
		if(rst)begin
			ts_ram_wr	<=	0;
			ts_ram_wdata	<=0;

		end
		else if(sp_rcstate==SP_TS_RAM_1 || sp_rcstate	==	SP_RAM_DONE_1)begin
			ts_ram_wr	<=	1;
			ts_ram_wdata	<=pcie_ram1_rdata;
		end
		else if(sp_rcstate	==	SP_TS_RAM_2 || sp_rcstate==SP_RAM_DONE_2)begin
			ts_ram_wr	<=	1;
			ts_ram_wdata	<=pcie_ram2_rdata;
		end
		else begin
			ts_ram_wr	<=	0;
			ts_ram_wdata	<=0;
		end
	end
	
	
	reg	[3:0]tsmf_cc;
	reg	[3:0]tsmf_cnt;	
				
	always@(posedge clk)begin
		if(rst)
			tsmf_cnt	<=0;
		else if(ts_ram_wr && ts_ram_wdata[187:132]==56'h0d430200471ffe )
			tsmf_cnt	<=ts_ram_wdata[131:128];
		else
			tsmf_cnt		<=tsmf_cnt;
	end

	always@(posedge clk)begin
		if(rst)
			tsmf_cc	<=0;
		else if(ts_ram_wr && ts_ram_wdata[187:132]==56'h0d430200471ffe)
				tsmf_cc	<=ts_ram_wdata[131:128]-tsmf_cnt;
		else
			tsmf_cc	<=	tsmf_cc;
	end		
	
		assign test_flag=tsmf_cc==1?1'b0:1'b1;
	
	
	endmodule
