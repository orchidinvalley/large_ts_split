`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:47:16 09/19/2019 
// Design Name: 
// Module Name:    tsmf_split_new 
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
module tsmf_split_new(
		
		
	clk_ts,
	rst_ts,

	ts_din,
	ts_din_en,



	freq_con_din,
	freq_con_din_en,

	channel_din,//取IP PORT配置命令的前两字节
	channel_din_en,
	
	clk_pcie,
	
	ram_full_1,
	
	ram_full_2,
	
	ts_ram_wr,
	
	ts_ram_wdata,
	
	test_flag


    );
    
    input 	clk_ts;
    input 	rst_ts;
    
    input 	[31:0]ts_din;
    input		ts_din_en;
    
    input 	[7:0]freq_con_din;
    input		freq_con_din_en;
    
    input 	[7:0]channel_din;
    input 	channel_din_en;
    
    input 	clk_pcie;
    input 	ram_full_1;
    input		ram_full_2;
    
    output 	ts_ram_wr;
    output	[31:0]ts_ram_wdata;
    
    output 	test_flag;
    
    reg 	ts_ram_wr;
    reg	[31:0]ts_ram_wdata;
    
    
    reg[16:0]freq_reg_1;//最高为1 ，启用该通道。
		reg[16:0]freq_reg_2;
		reg[16:0]freq_reg_3;
		reg[16:0]freq_reg_4;
		reg[16:0]freq_reg_5;
		reg[16:0]freq_reg_6;
		reg[16:0]freq_reg_7;
		reg[16:0]freq_reg_8;
		reg[4:0]freq_cnt;
		
		
		reg	[15:0]pack_cnt;
		reg	[5:0]ts_cnt;
		parameter TS_NUM=46;
		parameter	TS_HEAD_NUM=48;
		reg [3:0]frame_cnt;
		reg	[3:0]stream_order;


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
		reg	channel_din_en_r;
		
		
		always@(posedge clk_ts)begin
				if(freq_con_din_en)
					freq_cnt	<=	freq_cnt+1;
				else
					freq_cnt	<=0;
			end

			always@(posedge clk_ts )begin
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


			always@(posedge clk_ts )begin
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

			always@(posedge clk_ts )begin
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

			always@(posedge clk_ts )begin
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

			always@(posedge clk_ts )begin
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

			always@(posedge clk_ts )begin
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
			always@(posedge clk_ts )begin
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
			always@(posedge clk_ts )begin
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
		
    
    always@(posedge clk_ts)begin
				channel_din_en_r	<=	channel_din_en;
				if(rst_ts)
					syn_ver_slot	<=0;
				else if(channel_din_en&&!channel_din_en_r)
					syn_ver_slot	<={16'h1a86,5'b0,channel_din,3'b0};
				else	if(!channel_din_en&&channel_din_en_r)
					syn_ver_slot	<={syn_ver_slot[31:4],channel_din[7:5]};
				else
					syn_ver_slot	<=syn_ver_slot;
			end

			always@(posedge clk_ts)begin
				if(rst_ts)
					slot	<=0;
				else if(!channel_din_en&&channel_din_en_r)
					slot	<={channel_din[4:1],28'h0};
				else
					slot	<=slot;
			end

			always@(posedge clk_ts)begin
				stream_type	<=	{17'h0,15'h7fff};
				carrier_info	<={8'h11,8'h08,8'h00,8'h00};
				crc_reg			<=32'haaaaaaaa;
			end
			
						
			reg		ts_din_en_r;
			
			reg		[32:0]ts_body_din;
			reg		ts_body_wr;
			wire	body_prog_full;		
			wire	ts_body_rd;
			wire	[32:0]ts_body_dout;
			
			reg		[33:0]ts_head_din;
			reg		ts_head_wr;
			wire	head_prog_full;		
			wire	ts_head_rd;
			wire	[33:0]ts_head_dout;
			
			
			reg 	tsmf_write_start;
			reg		tsmf_write_end;
			
			
			reg		[3:0]channel_num;
			reg		channel_enable_1;
			reg		channel_enable_2;
			reg		channel_enable_3;
			reg		channel_enable_4;
			reg		channel_enable_5;
			reg		channel_enable_6;
			reg		channel_enable_7;
			reg		channel_enable_8;
			
			
			reg	[15:0]tsmf_cnt;
			reg	tsmf_inc;
			reg	tsmf_dec;
			
			reg	tsmf_dec_r,tsmf_dec_rr,tsmf_dec_rrr;
			wire tsmf_dec_ts;
			
			assign	tsmf_dec_ts=tsmf_dec_rr&!tsmf_dec_rrr;
			
			reg		[5:0]wcstate;
			reg		[5:0]wnstate;
			parameter		IDLE=0,
									TS_RAM_1=1,
									TS_RAM_2=2,
									CH1_CHECK=3,
									CH1_TS_WAIT=4,
									CH1_TS_WRITE=5,
									CH1_TS_CHECK=6,
									CH1_TS_HEADER_VALID=7,
									CH2_CHECK=8,
									CH2_TS_WAIT=9,
									CH2_TS_WRITE=10,
									CH2_TS_CHECK=11,
									CH2_TS_HEADER_VALID=12,
									CH3_CHECK=13,
									CH3_TS_WAIT=14,
									CH3_TS_WRITE=15,
									CH3_TS_CHECK=16,
									CH3_TS_HEADER_VALID=17,
									CH4_CHECK=18,
									CH4_TS_WAIT=19,
									CH4_TS_WRITE=20,
									CH4_TS_CHECK=21,
									CH4_TS_HEADER_VALID=22,
									CH5_CHECK=23,
									CH5_TS_WAIT=24,
									CH5_TS_WRITE=25,
									CH5_TS_CHECK=26,
									CH5_TS_HEADER_VALID=27,
									CH6_CHECK=28,
									CH6_TS_WAIT=29,
									CH6_TS_WRITE=30,
									CH6_TS_CHECK=31,
									CH6_TS_HEADER_VALID=32,
									CH7_CHECK=33,
									CH7_TS_WAIT=34,
									CH7_TS_WRITE=35,
									CH7_TS_CHECK=36,
									CH7_TS_HEADER_VALID=37,
									CH8_CHECK=38,
									CH8_TS_WAIT=39,
									CH8_TS_WRITE=40,
									CH8_TS_CHECK=41,
									CH8_TS_HEADER_VALID=42,
									TS_PCIE_VALID=43;
			wire	sof;
			wire	eof;
			
			assign	sof	=	ts_din_en	&	!ts_din_en_r;
			assign	eof	=	!ts_din_en	&	ts_din_en_r;
			
			always@(posedge clk_ts)begin
				ts_din_en_r	<=	ts_din_en;				
			end
			
			always@(posedge clk_ts)begin
				channel_enable_1=!freq_reg_8[16]&!freq_reg_7[16]&!freq_reg_6[16]&!freq_reg_5[16]
												&!freq_reg_4[16]&!freq_reg_3[16]&!freq_reg_2[16]&freq_reg_1[16];
				channel_enable_2=!freq_reg_8[16]&!freq_reg_7[16]&!freq_reg_6[16]&!freq_reg_5[16]
												&!freq_reg_4[16]&!freq_reg_3[16]&freq_reg_2[16];
				channel_enable_3=!freq_reg_8[16]&!freq_reg_7[16]&!freq_reg_6[16]&!freq_reg_5[16]
												&!freq_reg_4[16]&freq_reg_3[16];
				channel_enable_4=!freq_reg_8[16]&!freq_reg_7[16]&!freq_reg_6[16]&!freq_reg_5[16]
												&freq_reg_4[16];
				channel_enable_5=!freq_reg_8[16]&!freq_reg_7[16]&!freq_reg_6[16]&freq_reg_5[16];
				channel_enable_6=!freq_reg_8[16]&!freq_reg_7[16]&freq_reg_6[16];
				channel_enable_7=!freq_reg_8[16]&freq_reg_7[16];
				channel_enable_8=freq_reg_8[16];
			end
			
			
			always@(posedge clk_ts)begin
				tsmf_dec_r	<=	tsmf_dec;
				tsmf_dec_rr	<=	tsmf_dec_r;
				tsmf_dec_rrr	<=tsmf_dec_rr;
			end
			
			always@(posedge clk_ts)begin
				if(rst_ts)
					tsmf_cnt	<=0;
				else if(tsmf_inc&&!tsmf_dec_ts)
					tsmf_cnt	<=	tsmf_cnt+1;
				else if(tsmf_dec_ts&&!tsmf_inc)
					if(tsmf_cnt	!=0)
						tsmf_cnt	<=	tsmf_cnt-1;
					else
						tsmf_cnt	<=	0;
				else
					tsmf_cnt	<=	tsmf_cnt;						
			end	
				
			always@(posedge clk_ts)begin
				if((wcstate==CH1_TS_HEADER_VALID||wcstate==CH2_TS_HEADER_VALID
				||wcstate==CH3_TS_HEADER_VALID||wcstate==CH4_TS_HEADER_VALID
				||wcstate==CH5_TS_HEADER_VALID||wcstate==CH6_TS_HEADER_VALID
				||wcstate==CH7_TS_HEADER_VALID||wcstate==CH8_TS_HEADER_VALID)
				&&(ts_cnt==TS_HEAD_NUM))
					tsmf_inc	<=1;
				else
					tsmf_inc	<=0;
			end	
				
		
			
			always@(posedge clk_ts)begin
				if(rst_ts)
					wcstate	<=	IDLE;
				else
					wcstate	<=	wnstate;
			end	
	
			always@(*)begin
				case(wcstate)
					IDLE:
						wnstate	=	CH1_CHECK;
					CH1_CHECK:
						if(freq_reg_1[16])
							wnstate	=	CH1_TS_WAIT;
						else
							wnstate	=	CH2_CHECK;
					CH1_TS_WAIT:
						if(body_prog_full)
							wnstate	=	CH1_TS_WAIT;
						else if(sof)
							wnstate	=	CH1_TS_WRITE;
						else
							wnstate	=	CH1_TS_WAIT;
					CH1_TS_WRITE:
						if(eof)
							wnstate	=	CH1_TS_CHECK;
						else
							wnstate	=	CH1_TS_WRITE;	
					CH1_TS_CHECK:
						if(!freq_reg_1[16])
							wnstate	=	CH1_TS_HEADER_VALID;
						else if(pack_cnt==freq_reg_1[15:0])
							wnstate	=	CH1_TS_HEADER_VALID;
						else
							wnstate	= CH1_TS_WAIT;
					CH1_TS_HEADER_VALID:
						if(ts_cnt==TS_HEAD_NUM)
							if(channel_enable_1)
								wnstate	=	TS_PCIE_VALID;
							else
								wnstate	= CH2_CHECK;
						else
							wnstate	=	CH1_TS_HEADER_VALID;
					
					CH2_CHECK:
						if(freq_reg_2[16])
						wnstate	=	CH2_TS_WAIT;
						else
							wnstate	=CH3_CHECK;
					CH2_TS_WAIT:
						if(body_prog_full)
							wnstate	=	CH2_TS_WAIT;
						else if(sof)
							wnstate	=	CH2_TS_WRITE;
						else
							wnstate	=	CH2_TS_WAIT;
					CH2_TS_WRITE:
						if(eof)
							wnstate	=	CH2_TS_CHECK;
						else
							wnstate	=	CH2_TS_WRITE;	
					CH2_TS_CHECK:
						if(!freq_reg_2[16])
							wnstate	=	CH2_TS_HEADER_VALID;
						else if(pack_cnt==freq_reg_2[15:0])
							wnstate	=	CH2_TS_HEADER_VALID;
						else
							wnstate	= CH2_TS_WAIT;
					CH2_TS_HEADER_VALID:
						if(ts_cnt==TS_HEAD_NUM)
							if(channel_enable_2)
								wnstate	=	TS_PCIE_VALID;
							else
								wnstate	= CH3_CHECK;
						else
							wnstate	=	CH2_TS_HEADER_VALID;


					CH3_CHECK:
						if(freq_reg_3[16])
						wnstate	=	CH3_TS_WAIT;
						else
							wnstate	=CH4_CHECK;
					CH3_TS_WAIT:
						if(body_prog_full)
							wnstate	=	CH3_TS_WAIT;
						else if(sof)
							wnstate	=	CH3_TS_WRITE;
						else
							wnstate	=	CH3_TS_WAIT;
					CH3_TS_WRITE:
						if(eof)
							wnstate	=	CH3_TS_CHECK;
						else
							wnstate	=	CH3_TS_WRITE;	
					CH3_TS_CHECK:
					if(!freq_reg_3[16])
							wnstate	=	CH3_TS_HEADER_VALID;
						else if(pack_cnt==freq_reg_3[15:0])
							wnstate	=	CH3_TS_HEADER_VALID;
						else
							wnstate	= CH3_TS_WAIT;
					CH3_TS_HEADER_VALID:
						if(ts_cnt==TS_HEAD_NUM)
							if(channel_enable_3)
								wnstate	=	TS_PCIE_VALID;
							else
								wnstate	= CH4_CHECK;
						else
							wnstate	=	CH3_TS_HEADER_VALID;

					CH4_CHECK:
						if(freq_reg_4[16])
						wnstate	=	CH4_TS_WAIT;
						else
							wnstate	=CH5_CHECK;
					CH4_TS_WAIT:
						if(body_prog_full)
							wnstate	=	CH4_TS_WAIT;
						else if(sof)
							wnstate	=	CH4_TS_WRITE;
						else
							wnstate	=	CH4_TS_WAIT;
					CH4_TS_WRITE:
						if(eof)
							wnstate	=	CH4_TS_CHECK;
						else
							wnstate	=	CH4_TS_WRITE;	
					CH4_TS_CHECK:
						if(!freq_reg_4[16])
							wnstate	=	CH4_TS_HEADER_VALID;
						else if(pack_cnt==freq_reg_4[15:0])
							wnstate	=	CH4_TS_HEADER_VALID;
						else
							wnstate	= CH4_TS_WAIT;
					CH4_TS_HEADER_VALID:
						if(ts_cnt==TS_HEAD_NUM)
							if(channel_enable_4)
								wnstate	=	TS_PCIE_VALID;
							else
								wnstate	= CH5_CHECK;
						else
							wnstate	=	CH4_TS_HEADER_VALID;

					CH5_CHECK:
						if(freq_reg_5[16])
						wnstate	=	CH5_TS_WAIT;
						else
							wnstate	=CH6_CHECK;
					CH5_TS_WAIT:
						if(body_prog_full)
							wnstate	=	CH5_TS_WAIT;
						else if(sof)
							wnstate	=	CH5_TS_WRITE;
						else
							wnstate	=	CH5_TS_WAIT;
					CH5_TS_WRITE:
						if(eof)
							wnstate	=	CH5_TS_CHECK;
						else
							wnstate	=	CH5_TS_WRITE;	
					CH5_TS_CHECK:
						if(!freq_reg_5[16])
							wnstate	=	CH5_TS_HEADER_VALID;
						else 
						if(pack_cnt==freq_reg_5[15:0])
							wnstate	=	CH5_TS_HEADER_VALID;
						else
							wnstate	= CH5_TS_WAIT;
					CH5_TS_HEADER_VALID:
						if(ts_cnt==TS_HEAD_NUM)
							if(channel_enable_5)
								wnstate	=	TS_PCIE_VALID;
							else
								wnstate	= CH6_CHECK;
						else
							wnstate	=	CH5_TS_HEADER_VALID;

					CH6_CHECK:
						if(freq_reg_6[16])
						wnstate	=	CH6_TS_WAIT;
						else
							wnstate	=CH7_CHECK;
					CH6_TS_WAIT:
						if(body_prog_full)
							wnstate	=	CH6_TS_WAIT;
						else if(sof)
							wnstate	=	CH6_TS_WRITE;
						else
							wnstate	=	CH6_TS_WAIT;
					CH6_TS_WRITE:
						if(eof)
							wnstate	=	CH6_TS_CHECK;
						else
							wnstate	=	CH6_TS_WRITE;	
					CH6_TS_CHECK:
					if(!freq_reg_6[16])
							wnstate	=	CH6_TS_HEADER_VALID;
						else 
						if(pack_cnt==freq_reg_6[15:0])
							wnstate	=	CH6_TS_HEADER_VALID;
						else
							wnstate	= CH6_TS_WAIT;
					CH6_TS_HEADER_VALID:
						if(ts_cnt==TS_HEAD_NUM)
							if(channel_enable_6)
								wnstate	=	TS_PCIE_VALID;
							else
								wnstate	= CH7_CHECK;
						else
							wnstate	=	CH6_TS_HEADER_VALID;

					CH7_CHECK:
						if(freq_reg_7[16])
						wnstate	=	CH7_TS_WAIT;
						else
							wnstate	=CH8_CHECK;
					CH7_TS_WAIT:
						if(body_prog_full)
							wnstate	=	CH7_TS_WAIT;
						else if(sof)
							wnstate	=	CH7_TS_WRITE;
						else
							wnstate	=	CH7_TS_WAIT;
					CH7_TS_WRITE:
						if(eof)
							wnstate	=	CH7_TS_CHECK;
						else
							wnstate	=	CH7_TS_WRITE;	
					CH7_TS_CHECK:
						if(!freq_reg_7[16])
							wnstate	=	CH7_TS_HEADER_VALID;
						else 
						if(pack_cnt==freq_reg_7[15:0])
							wnstate	=	CH7_TS_HEADER_VALID;
						else
							wnstate	= CH7_TS_WAIT;
					CH7_TS_HEADER_VALID:
						if(ts_cnt==TS_HEAD_NUM)
							if(channel_enable_7)
								wnstate	=	TS_PCIE_VALID;
							else
								wnstate	= CH8_CHECK;
						else
							wnstate	=	CH7_TS_HEADER_VALID;

					CH8_CHECK:
						if(freq_reg_8[16])
						wnstate	=	CH8_TS_WAIT;
						else
							wnstate	=TS_PCIE_VALID;
					CH8_TS_WAIT:
						if(body_prog_full)
							wnstate	=	CH8_TS_WAIT;
						else if(sof)
							wnstate	=	CH8_TS_WRITE;
						else
							wnstate	=	CH8_TS_WAIT;
					CH8_TS_WRITE:
					if(eof)
							wnstate	=	CH8_TS_CHECK;
						else
							wnstate	=	CH8_TS_WRITE;	
					CH8_TS_CHECK:
						if(!freq_reg_8[16])
							wnstate	=	CH8_TS_HEADER_VALID;
						else 
						if(pack_cnt==freq_reg_8[15:0])
							wnstate	=	CH8_TS_HEADER_VALID;
						else
							wnstate	= CH8_TS_WAIT;
					CH8_TS_HEADER_VALID:
						if(ts_cnt==TS_HEAD_NUM)
							wnstate	= TS_PCIE_VALID;
						else
							wnstate	=	CH8_TS_HEADER_VALID;
					TS_PCIE_VALID:
							wnstate	=	IDLE;
									
					default:
						wnstate	=	IDLE;		
				endcase
			end
			
			always@(posedge clk_ts)begin
				if(wcstate==IDLE)
					channel_num	<=0;
				else if(wcstate==CH1_TS_WAIT)
					channel_num	<=1;
				else if(wcstate==CH2_TS_WAIT)
					channel_num	<=2;
				else if(wcstate==CH3_TS_WAIT)
					channel_num	<=3;
				else if(wcstate==CH4_TS_WAIT)
					channel_num	<=4;
				else if(wcstate==CH5_TS_WAIT)
					channel_num	<=5;
				else if(wcstate==CH6_TS_WAIT)
					channel_num	<=6;
				else if(wcstate==CH7_TS_WAIT)
					channel_num	<=7;
				else if(wcstate==CH8_TS_WAIT)
					channel_num	<=8;
				else
					channel_num	<=channel_num;
			end
			
			always@(posedge clk_ts)begin
				if(ts_din_en&!ts_din_en_r)
					stream_order	<=ts_din[3:0];
				else
					stream_order	<=stream_order;
			end
		
			always@(posedge clk_ts)begin
				if(wcstate	==	CH1_TS_WRITE||wcstate	==	CH2_TS_WRITE||wcstate	==	CH3_TS_WRITE||wcstate	==	CH4_TS_WRITE
				||wcstate	==	CH5_TS_WRITE||wcstate	==	CH6_TS_WRITE||wcstate	==	CH7_TS_WRITE||wcstate	==	CH8_TS_WRITE)
					ts_cnt	<=ts_cnt+1;
				else if(wcstate==CH1_TS_HEADER_VALID ||wcstate==CH2_TS_HEADER_VALID ||wcstate==CH3_TS_HEADER_VALID||wcstate==CH4_TS_HEADER_VALID
				||wcstate==CH5_TS_HEADER_VALID||wcstate==CH6_TS_HEADER_VALID||wcstate==CH7_TS_HEADER_VALID||wcstate==CH8_TS_HEADER_VALID)
					ts_cnt	<=ts_cnt+1;
				else
					ts_cnt	<=0;
			end
			
			always@(posedge clk_ts)begin
				if(rst_ts)
					pack_cnt	<=0;
				else	if(wcstate==	CH1_CHECK||wcstate==	CH2_CHECK ||wcstate==	CH3_CHECK||wcstate==	CH4_CHECK
				||wcstate==	CH5_CHECK||wcstate==	CH6_CHECK||wcstate==	CH7_CHECK||wcstate==	CH8_CHECK )
					pack_cnt	<=	0;
				else	if((wnstate==CH1_TS_CHECK)||(wnstate==CH2_TS_CHECK)||(wnstate==CH3_TS_CHECK)||(wnstate==CH4_TS_CHECK)
				||(wnstate==CH5_TS_CHECK)||(wnstate==CH6_TS_CHECK)||(wnstate==CH7_TS_CHECK)||(wnstate==CH8_TS_CHECK))
					pack_cnt	<=	pack_cnt+1;
				else
					pack_cnt	<=	pack_cnt;
			end
			
			
			always@(posedge clk_ts)begin
				if(rst_ts)
					frame_cnt	<=0;
				else begin
					case(wcstate)
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

			
			always@(posedge clk_ts)begin
				if(wcstate==CH1_TS_WRITE)begin
					if(ts_cnt==6'h2e)begin
						if(pack_cnt+1==freq_reg_1[15:0]||!freq_reg_1[16])begin
							ts_body_din	<={1'b1,ts_din};
							ts_body_wr	<=ts_din_en;
						end
						else begin
							ts_body_din	<={1'b0,ts_din};
							ts_body_wr	<=ts_din_en;
						end

					end
					else begin
						ts_body_din	<={1'b0,ts_din};
						ts_body_wr	<=ts_din_en;
					end 
				end
				else if(wcstate==CH2_TS_WRITE)begin
					if(ts_cnt==6'h2e)begin
						if(pack_cnt+1==freq_reg_2[15:0]||!freq_reg_2[16])begin
							ts_body_din	<={1'b1,ts_din};
							ts_body_wr	<=ts_din_en;
						end
						else begin
							ts_body_din	<={1'b0,ts_din};
							ts_body_wr	<=ts_din_en;
						end

					end
					else begin
						ts_body_din	<={1'b0,ts_din};
						ts_body_wr	<=ts_din_en;
					end 
				end
				else if(wcstate==CH3_TS_WRITE)begin
					if(ts_cnt==6'h2e)begin
						if(pack_cnt+1==freq_reg_3[15:0]||!freq_reg_3[16])begin
							ts_body_din	<={1'b1,ts_din};
							ts_body_wr	<=ts_din_en;
						end
						else begin
							ts_body_din	<={1'b0,ts_din};
							ts_body_wr	<=ts_din_en;
						end

					end
					else begin
						ts_body_din	<={1'b0,ts_din};
						ts_body_wr	<=ts_din_en;
					end 
				end
				else if(wcstate==CH4_TS_WRITE)begin
					if(ts_cnt==6'h2e)begin
						if(pack_cnt+1==freq_reg_4[15:0]||!freq_reg_4[16])begin
							ts_body_din	<={1'b1,ts_din};
							ts_body_wr	<=ts_din_en;
						end
						else begin
							ts_body_din	<={1'b0,ts_din};
							ts_body_wr	<=ts_din_en;
						end

					end
					else begin
						ts_body_din	<={1'b0,ts_din};
						ts_body_wr	<=ts_din_en;
					end 
				end
				else if(wcstate==CH5_TS_WRITE)begin
					if(ts_cnt==6'h2e)begin
						if(pack_cnt+1==freq_reg_5[15:0]||!freq_reg_5[16])begin
							ts_body_din	<={1'b1,ts_din};
							ts_body_wr	<=ts_din_en;
						end
						else begin
							ts_body_din	<={1'b0,ts_din};
							ts_body_wr	<=ts_din_en;
						end

					end
					else begin
						ts_body_din	<={1'b0,ts_din};
						ts_body_wr	<=ts_din_en;
					end 
				end
				else if(wcstate==CH6_TS_WRITE)begin
					if(ts_cnt==6'h2e)begin
						if(pack_cnt+1==freq_reg_6[15:0]||!freq_reg_6[16])begin
							ts_body_din	<={1'b1,ts_din};
							ts_body_wr	<=ts_din_en;
						end
						else begin
							ts_body_din	<={1'b0,ts_din};
							ts_body_wr	<=ts_din_en;
						end

					end
					else begin
						ts_body_din	<={1'b0,ts_din};
						ts_body_wr	<=ts_din_en;
					end 
				end
				else if(wcstate==CH7_TS_WRITE)begin
					if(ts_cnt==6'h2e)begin
						if(pack_cnt+1==freq_reg_7[15:0]||!freq_reg_7[16])begin
							ts_body_din	<={1'b1,ts_din};
							ts_body_wr	<=ts_din_en;
						end
						else begin
							ts_body_din	<={1'b0,ts_din};
							ts_body_wr	<=ts_din_en;
						end

					end
					else begin
						ts_body_din	<={1'b0,ts_din};
						ts_body_wr	<=ts_din_en;
					end 
				end
				else if(wcstate==CH8_TS_WRITE)begin
					if(ts_cnt==6'h2e)begin
						if(pack_cnt+1==freq_reg_8[15:0]||!freq_reg_8[16])begin
							ts_body_din	<={1'b1,ts_din};
							ts_body_wr	<=ts_din_en;
						end
						else begin
							ts_body_din	<={1'b0,ts_din};
							ts_body_wr	<=ts_din_en;
						end

					end
					else begin
						ts_body_din	<={1'b0,ts_din};
						ts_body_wr	<=ts_din_en;
					end 
				end
				else begin
					ts_body_din	<=0;
					ts_body_wr	<=0;
				end
			end
			
			always@(posedge clk_ts)begin
			if(wcstate==CH1_TS_HEADER_VALID || wcstate==CH2_TS_HEADER_VALID||wcstate==CH3_TS_HEADER_VALID||wcstate==CH4_TS_HEADER_VALID
			||wcstate==CH5_TS_HEADER_VALID||wcstate==CH6_TS_HEADER_VALID||wcstate==CH7_TS_HEADER_VALID||wcstate==CH8_TS_HEADER_VALID)begin
				case(ts_cnt)
						6'd0:begin
							ts_head_din	<={2'b00,{8{channel_num}}};
							ts_head_wr		<=1;
						end
						6'd1:begin
							ts_head_din	<={19'h00000,pack_cnt};
							ts_head_wr		<=1;
						end	
						6'd2:begin
							ts_head_din	<={30'h0471ffe1,frame_cnt};
							ts_head_wr		<=1;
						end	
						6'd3:begin//syn_ver_slot
							ts_head_din	<={2'b00,syn_ver_slot};
							ts_head_wr		<=1;
						end
						6'd4:begin//slot
							ts_head_din	<={2'b00,slot};
							ts_head_wr		<=1;
						end
						6'd5:begin
							ts_head_din	<={2'b00,stream_info_1};
							ts_head_wr		<=1;
						end
						6'd6:begin
							ts_head_din	<={2'b00,stream_info_2};
							ts_head_wr		<=1;
						end
						6'd7:begin
							ts_head_din	<={2'b00,stream_info_3};
							ts_head_wr		<=1;
						end
						6'd8:begin
							ts_head_din	<={2'b00,stream_info_4};
							ts_head_wr		<=1;
						end
						6'd9:begin
							ts_head_din	<={2'b00,stream_info_5};
							ts_head_wr		<=1;
						end
						6'd10:begin
							ts_head_din	<={2'b00,stream_info_6};
							ts_head_wr		<=1;
						end
						6'd11:begin
							ts_head_din	<={2'b00,stream_info_7};
							ts_head_wr		<=1;
						end
						6'd12:begin//
							ts_head_din	<={2'b00,stream_info_8};
							ts_head_wr		<=1;
						end
						6'd13:begin//
							ts_head_din	<={2'b00,stream_info_9};
							ts_head_wr		<=1;
						end
						6'd14:begin//
							ts_head_din	<={2'b00,stream_info_10};
							ts_head_wr		<=1;
						end
						6'd15:begin
							ts_head_din	<={2'b00,stream_info_11};
							ts_head_wr		<=1;
						end
						6'd16:begin
							ts_head_din	<={2'b00,stream_info_12};
							ts_head_wr		<=1;
						end
						6'd17:begin
							ts_head_din	<={2'b00,stream_info_13};
							ts_head_wr		<=1;
						end
						6'd18:begin
							ts_head_din	<={2'b00,stream_info_14};
							ts_head_wr		<=1;
						end
						6'd19:begin
							ts_head_din	<={2'b00,stream_info_15};
							ts_head_wr		<=1;
						end
						6'd20:begin
							ts_head_din	<={2'b00,stream_info_16};
							ts_head_wr		<=1;
						end
						6'd21:begin
							ts_head_din	<={2'b00,stream_type};
							ts_head_wr		<=1;
						end
						6'd22:begin
							ts_head_din	<={2'b00,carrier_info};
							ts_head_wr		<=1;
						end
						6'd48:begin
							if((wcstate==CH1_TS_HEADER_VALID && channel_enable_1)||(wcstate==CH2_TS_HEADER_VALID && channel_enable_2)
							||(wcstate==CH3_TS_HEADER_VALID && channel_enable_3)||(wcstate==CH4_TS_HEADER_VALID && channel_enable_4)
							||(wcstate==CH5_TS_HEADER_VALID && channel_enable_5)||(wcstate==CH6_TS_HEADER_VALID && channel_enable_6)
							||(wcstate==CH7_TS_HEADER_VALID && channel_enable_7)||(wcstate==CH8_TS_HEADER_VALID && channel_enable_8)	)
								ts_head_din	<={2'b11,crc_reg};//crc
							else
								ts_head_din	<={2'b10,crc_reg};//crc
							ts_head_wr		<=1;
						end
						default:begin
							ts_head_din	<=0;//crc
							ts_head_wr		<=1;						
						end
					endcase
			end
			else begin
				ts_head_din	<=0;
				ts_head_wr	<=0;
			end
			end

			channel_ts_header channel_ts_header_uut (
			  .rst(rst_ts), // input rst
			  .wr_clk(clk_ts), // input wr_clk
			  .rd_clk(clk_pcie), // input rd_clk
			  .din(ts_head_din), // input [33 : 0] din
			  .wr_en(ts_head_wr), // input wr_en
			  .rd_en(ts_head_rd), // input rd_en
			  .dout(ts_head_dout), // output [33 : 0] dout
			  .full(), // output full
			  .empty(), // output empty
			  .prog_full(head_prog_full) 
			);



			ts_data_buffer channel_ts_body (
			  .rst(rst_ts), // input rst
			  .wr_clk(clk_ts), // input wr_clk
			  .rd_clk(clk_pcie), // input rd_clk
			  .din(ts_body_din), // input [32 : 0] din
			  .wr_en(ts_body_wr), // input wr_en
			  .rd_en(ts_body_rd), // input rd_en
			  .dout(ts_body_dout), // output [32 : 0] dout
			  .prog_full(body_prog_full),
			  .full(), // output full
			  .empty() // output empty
			);
			
			reg	[2:0]tsmf_wcstate;
			reg	[2:0]tsmf_wnstate;
			
			
			
			reg	[32:0]tsmf_din;
			reg	tsmf_wr;
			wire	tsmf_rd;
			wire	[32:0]tsmf_dout;
			wire	tsmf_prog_full;
			wire	[15:0]data_count;
			
			assign test_flag	=&data_count;
			
			reg	[15:0]super_frame_cnt;
			reg		super_frame_inc;
			reg		super_frame_dec;
			reg	[2:0]w_frame_interval;
			
			parameter W_IDLE=0,	    					
	    					W_HEADER=1,
	    					W_BODY=2,
	    					W_BODY_END=3,
	    					W_FRAME_END_1=4,
	    					W_FRAME_END_2=5,
	    					W_FRAME_END_3=6;
			
			always@(posedge clk_pcie)begin
				if(rst_ts)
					tsmf_wcstate	<=W_IDLE;
				else
					tsmf_wcstate	<=tsmf_wnstate;
			end
			
			always@(*)begin
				case(tsmf_wcstate)
					W_IDLE:
						if(!tsmf_prog_full)
							if(tsmf_cnt>0)
								tsmf_wnstate	=	W_HEADER;
							else
								tsmf_wnstate	=	W_IDLE;
						else
							tsmf_wnstate	=	W_IDLE;
					W_HEADER:
						if(ts_head_dout[33])
							if(ts_head_dout[32])
								tsmf_wnstate	=	W_BODY_END;
							else
								tsmf_wnstate	=	W_BODY;
						else
							tsmf_wnstate	=	W_HEADER;
					W_BODY:
						if(ts_body_dout[32])
							tsmf_wnstate	=	W_FRAME_END_1;
						else
							tsmf_wnstate	=	W_BODY;
					W_BODY_END:
						if(ts_body_dout[32])
							tsmf_wnstate	=	W_FRAME_END_1;
						else
							tsmf_wnstate	=	W_BODY_END;
					W_FRAME_END_1:
						tsmf_wnstate	=	W_FRAME_END_2;
					W_FRAME_END_2:
						tsmf_wnstate	=	W_FRAME_END_3;
					W_FRAME_END_3:
						if(w_frame_interval==6)
							tsmf_wnstate	=	W_IDLE;
						else 
							tsmf_wnstate	=	W_FRAME_END_3;			
					default:
						tsmf_wnstate	=	W_IDLE;		
				endcase			
			end
			
			always@(posedge clk_pcie)begin
				if(tsmf_wcstate==W_FRAME_END_1||tsmf_wcstate==W_FRAME_END_2)
					tsmf_dec	<=1;
				else
					tsmf_dec	<=0;
			end
			
			always@(posedge clk_pcie)begin
				if(tsmf_wcstate==W_FRAME_END_3)
					w_frame_interval	<=w_frame_interval+1;
				else
					w_frame_interval	<=0;
			end
			
			
			assign ts_head_rd=tsmf_wnstate==W_HEADER?1'b1:1'b0;
			assign ts_body_rd=(tsmf_wnstate==W_BODY||tsmf_wnstate==W_BODY_END)?1'b1:1'b0;
			
			always@(posedge clk_pcie)begin
				if(tsmf_wcstate==W_HEADER)begin
					tsmf_din	<={1'b0,ts_head_dout[31:0]};
					tsmf_wr		<=1;
				end
				else if(tsmf_wcstate==W_BODY)begin
					tsmf_din	<={1'b0,ts_body_dout[31:0]};
					tsmf_wr		<=1;
				end
				else if(tsmf_wcstate==W_BODY_END)begin
					tsmf_din	<=ts_body_dout;
					tsmf_wr		<=1;
				end
				else begin
					tsmf_din	<=0;
					tsmf_wr		<=0;
				end
			end
			
			
			always@(posedge clk_pcie)begin
				if(rst_ts)
					super_frame_cnt	<=0;
				else if(super_frame_inc&!super_frame_dec)
					super_frame_cnt	<=	super_frame_cnt+1;
				else	if(!super_frame_inc&super_frame_dec)
					if(super_frame_cnt!=0)
						super_frame_cnt	<=	super_frame_cnt-1;
					else
						super_frame_cnt	<=	0;
				else
					super_frame_cnt	<=	super_frame_cnt;
			end
			
			always@(posedge clk_pcie)begin
				if(tsmf_wcstate==W_BODY_END&& tsmf_wnstate==W_FRAME_END_1)
					super_frame_inc	<=1;
				else
					super_frame_inc	<=0;
			end
			
			
			tsmf_buffer tmsf_buff_uut (
			  .clk(clk_pcie), // input clk
			  .rst(rst_ts), // input rst
			  .din(tsmf_din), // input [32 : 0] din
			  .wr_en(tsmf_wr), // input wr_en
			  .rd_en(tsmf_rd), // input rd_en
			  .dout(tsmf_dout), // output [32 : 0] dout
			  .full(), // output full
			  .empty(), // output empty
			  .prog_full(tsmf_prog_full),
			  .data_count(data_count)
			);
			
			
			reg	[2:0]tsmf_rcstate;
			reg	[2:0]tsmf_rnstate;
			parameter R_IDLE=0,	    					
	    					R_START=1,
	    					R_SUPER_FRAME=2,
	    					R_FRAME_END_1=3,
	    					R_FRAME_END_2=4,
	    					R_FRAME_END_3=5;
			
			always@(posedge clk_pcie)begin
				if(rst_ts)	
					tsmf_rcstate	<=	R_IDLE;
				else	
					tsmf_rcstate	<=	tsmf_rnstate;
			end			

			always@(*)begin
				case(tsmf_rcstate)
					R_IDLE:
						if(!ram_full_1||!ram_full_2)
							tsmf_rnstate	=	R_START;
					R_START:	
						if(super_frame_cnt>0)
							tsmf_rnstate	=	R_SUPER_FRAME;
						else
							tsmf_rnstate	=	R_START;
					R_SUPER_FRAME:
						if(tsmf_dout[32])
							tsmf_rnstate	=	R_FRAME_END_1;
						else 
							tsmf_rnstate	=	R_SUPER_FRAME;
					R_FRAME_END_1:
						tsmf_rnstate	=	R_FRAME_END_2;
					R_FRAME_END_2:
						tsmf_rnstate	=	R_FRAME_END_3;
					R_FRAME_END_3:
						tsmf_rnstate	=	R_IDLE;			
					default:
						tsmf_rnstate	=	R_IDLE;	
				endcase
			end
			
			always@(posedge clk_pcie)begin
				if(tsmf_rcstate==R_FRAME_END_1)
					super_frame_dec		<=1;
				else
					super_frame_dec		<=0;
			end
	
			assign	tsmf_rd=	tsmf_rnstate==R_SUPER_FRAME?1'b1:1'b0;
			
			
			always@(posedge clk_pcie)begin
				if(tsmf_rcstate==R_SUPER_FRAME)begin
					ts_ram_wdata	<=tsmf_dout[31:0];
					ts_ram_wr			<=1;
				end
				else begin
					ts_ram_wdata	<=0;
					ts_ram_wr			<=0;
				end
			end			

endmodule
