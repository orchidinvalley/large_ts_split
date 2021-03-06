`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:15:39 07/01/2009 
// Design Name: 
// Module Name:    csa_ts_proc 
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
module csa_ts_proc(
    clk,
	rst,
	
	ts_din,//  pid num+GBE_IP_PORT+188/8(空最好字节)
	ts_din_en,	
				
	cw_con_din,
	cw_con_din_en,
	pid_con_din,
	pid_con_din_en,
	
	ts1_dout_en,
	ts2_dout_en,
	ts3_dout_en,
	ts4_dout_en,
	ts5_dout_en,
	ts6_dout_en,
	ts7_dout_en,
	ts8_dout_en,
	ts9_dout_en,	
	ts10_dout_en,
	ts11_dout_en,
	ts12_dout_en,
	ts13_dout_en,
	ts14_dout_en,
	ts15_dout_en,
	ts16_dout_en,
	ts17_dout_en,
	ts18_dout_en,
	ts19_dout_en,	
	ts20_dout_en,
	ts21_dout_en,
	ts22_dout_en,
	ts23_dout_en,
	ts24_dout_en,
	ts25_dout_en,
	ts26_dout_en,
	ts27_dout_en,
	ts28_dout_en,
	ts29_dout_en,	
	ts30_dout_en,
	ts31_dout_en,
	ts32_dout_en,
//	ts33_dout_en,
//	ts34_dout_en,
//	ts35_dout_en,
//	ts36_dout_en,
//	ts37_dout_en,
//	ts38_dout_en,
//	ts39_dout_en,	
//	ts40_dout_en,
//	ts41_dout_en,
//	ts42_dout_en,
//	ts43_dout_en,
//	ts44_dout_en,
//	ts45_dout_en,
//	ts46_dout_en,
//	ts47_dout_en,
//	ts48_dout_en,
//	ts49_dout_en,	
//	ts50_dout_en,
//	ts51_dout_en,
//	ts52_dout_en,
//	ts53_dout_en,
//	ts54_dout_en,	

	ts_dout
    );
    
	input			clk;
 	input			rst;
	
	input	[31:0]	ts_din;
	input			ts_din_en;
	
	input			cw_con_din_en;
	input	[7:0]	cw_con_din;
	input	[7:0]	pid_con_din;
	input			pid_con_din_en;
	
	output			ts1_dout_en;
	output			ts2_dout_en;
	output			ts3_dout_en;
	output			ts4_dout_en;
	output			ts5_dout_en;
	output			ts6_dout_en;
	output			ts7_dout_en;
	output			ts8_dout_en;
	output			ts9_dout_en; 
	output			ts10_dout_en;
	output			ts11_dout_en;
	output			ts12_dout_en;
	output			ts13_dout_en;
	output			ts14_dout_en;
	output			ts15_dout_en; 
	output			ts16_dout_en;												
	output			ts17_dout_en;												
	output			ts18_dout_en;												
	output			ts19_dout_en;													
	output			ts20_dout_en;												
	output			ts21_dout_en;												
	output			ts22_dout_en;												
	output			ts23_dout_en;												
	output			ts24_dout_en;																			
	output			ts25_dout_en;	
	output			ts26_dout_en;												
	output			ts27_dout_en;												
	output			ts28_dout_en;												
	output			ts29_dout_en;													
	output			ts30_dout_en;												
	output			ts31_dout_en;												
	output			ts32_dout_en;												
//	output			ts33_dout_en;	
//	output 			ts34_dout_en;
//	output 			ts35_dout_en;
//	output 			ts36_dout_en;
//	output 			ts37_dout_en;
//	output 			ts38_dout_en;
//	output 			ts39_dout_en;
//	output 			ts40_dout_en;
//	output 			ts41_dout_en;
//	output 			ts42_dout_en;
//	output 			ts43_dout_en;
//	output 			ts44_dout_en;
//	output 			ts45_dout_en;
//	output 			ts46_dout_en;
//	output 			ts47_dout_en;
//	output 			ts48_dout_en;
//	output 			ts49_dout_en;
//	output 			ts50_dout_en;
//	output 			ts51_dout_en;
//	output 			ts52_dout_en;
//	output 			ts53_dout_en;
//	output 			ts54_dout_en;

  	output	[32:0]  ts_dout;
  	
  	reg				ts1_dout_en;
	reg				ts2_dout_en;
	reg				ts3_dout_en;
	reg				ts4_dout_en;
	reg				ts5_dout_en;
	reg				ts6_dout_en;
	reg				ts7_dout_en;
	reg				ts8_dout_en;
	reg				ts9_dout_en;	
	reg				ts10_dout_en;
	reg				ts11_dout_en;
	reg				ts12_dout_en;
	reg				ts13_dout_en;
	reg				ts14_dout_en;
	reg				ts15_dout_en;	
	reg				ts16_dout_en;												
	reg				ts17_dout_en;												
	reg				ts18_dout_en;												
	reg				ts19_dout_en;													
	reg				ts20_dout_en;												
	reg				ts21_dout_en;												
	reg				ts22_dout_en;												
	reg				ts23_dout_en;												
	reg				ts24_dout_en;																			
	reg				ts25_dout_en;	
	reg				ts26_dout_en;												
	reg				ts27_dout_en;												
	reg				ts28_dout_en;												
	reg				ts29_dout_en;													
	reg				ts30_dout_en;												
	reg				ts31_dout_en;												
	reg				ts32_dout_en;												
//	reg				ts33_dout_en;	
//	reg 			ts34_dout_en;
//	reg 			ts35_dout_en;
//	reg 			ts36_dout_en;
//	reg 			ts37_dout_en;
//	reg 			ts38_dout_en;
//	reg 			ts39_dout_en;
//	reg 			ts40_dout_en;
//	reg 			ts41_dout_en;
//	reg 			ts42_dout_en;
//	reg 			ts43_dout_en;
//	reg 			ts44_dout_en;
//	reg 			ts45_dout_en;
//	reg 			ts46_dout_en;
//	reg 			ts47_dout_en;
//	reg 			ts48_dout_en;
//	reg 			ts49_dout_en;
//	reg 			ts50_dout_en;
//	reg 			ts51_dout_en;
//	reg 			ts52_dout_en;
//	reg 			ts53_dout_en;
//	reg 			ts54_dout_en;


	
																			
	reg		[32:0]	ts_dout;			
  	
  	reg		[7:0]	ts_cnt;
  	
  	reg		[31:0]	ts_din_r,ts_din_r1,ts_din_r2,ts_din_r3,ts_din_r4,ts_din_r5;
  	reg				ts_din_en_r,ts_din_en_r1,ts_din_en_r2,ts_din_en_r3,ts_din_en_r4,ts_din_en_r5,ts_din_en_r6;
  	
  	
  	reg		[32:0]	ts_dout_r;
  	reg				ts_dout_en;
  	
  	reg		[2:0]	pid_con_clk_cnt;
  	reg		[15:0]	pid_con_cnt;
  	
  	reg				pid_ram_din;
  	reg				pid_ram_wr;
  	reg		[11:0]	pid_ram_addra,pid_ram_addrb;
  	wire			pid_ram_dout;
  	
  	reg		[7:0]	cw_con_cnt;
  	
  	reg		[65:0]	cw_ram_din;
  	reg				cw_ram_wr;
  	reg		[11:0]	cw_ram_addra,cw_ram_addrb;
  	wire	[65:0]	cw_ram_dout;
  	
  	reg		[7:0]	cnt_ram_din;
  	reg				cnt_ram_wr;
  	reg		[11:0]	cnt_ram_addr;
  	wire	[7:0]	cnt_ram_dout;
  	
  	reg				csa_flag;
  	reg		[7:0]	ram_dout_cnt;
  	
  	reg		[3:0]	continue_cnt;
  	reg		[4:0]	channel_cnt;
	

	parameter	CHANNEL_NUM	= 32;
	
	
	always @(posedge clk)
	begin
		if(rst)
		ts_cnt		<=0;
		else 	if(ts_din_en)
		begin
			ts_cnt	<= ts_cnt + 8'b1;
		end
		else
		begin
			ts_cnt	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
	if(rst)
	begin
		ts_din_r			<= 0;
		ts_din_r1			<= 0;
		ts_din_r2			<= 0;
		ts_din_r3			<= 0;
		ts_din_r4			<= 0;
		ts_din_r5			<= 0;
		ts_din_en_r		<= 0;
		ts_din_en_r1	<= 0;
		ts_din_en_r2	<= 0;
		ts_din_en_r3	<= 0;
		ts_din_en_r4	<= 0;  
		ts_din_en_r5	<=0;
		ts_din_en_r6	<=0;
	end
	else 
	begin
		ts_din_r	<= ts_din;
		ts_din_r1	<= ts_din_r;
		ts_din_r2	<= ts_din_r1;
		ts_din_r3	<= ts_din_r2;
		ts_din_r4	<= ts_din_r3;
		ts_din_r5	<= ts_din_r4;
		ts_din_en_r	<= ts_din_en;
		ts_din_en_r1	<= ts_din_en_r;
		ts_din_en_r2	<= ts_din_en_r1;
		ts_din_en_r3	<= ts_din_en_r2;
		ts_din_en_r4	<= ts_din_en_r3;
		ts_din_en_r5	<=	ts_din_en_r4;   
		ts_din_en_r6	<=ts_din_en_r5;
end
	end
	
	always @(posedge clk)
	begin
		if(ts_cnt == 0&&ts_din_en)
		begin
			pid_ram_addrb	<= ts_din[11:0];
			cw_ram_addrb	<= ts_din[11:0];
		end
		else
		begin
			pid_ram_addrb	<= pid_ram_addrb;
			cw_ram_addrb	<= pid_ram_addrb;
		end
	end
	
	always @(posedge clk)
	begin
		if(rst)
		channel_cnt		<=0;
		else 	if(!ts_din_en_r5&& ts_din_en_r6)//(ts_cnt == 1)
		begin
			if(channel_cnt == (CHANNEL_NUM - 1))
			begin
				channel_cnt	<= 0;
			end
			else
			begin
				channel_cnt	<= channel_cnt + 6'b1;
			end
		end
		else
		begin
			channel_cnt	<= channel_cnt;
		end
	end
	
	always @(posedge clk)
	begin
		if(rst)
		continue_cnt		<=0;
		else 	if(/*ts_cnt== 4*/ !ts_din_en_r5 && ts_din_en_r6 && channel_cnt == (CHANNEL_NUM - 1))
		begin
			continue_cnt	<= continue_cnt + 4'b1;
		end
		else
		begin
			continue_cnt	<= continue_cnt;
		end
	end
	
	always @(posedge clk)
	begin
		if(ts_cnt == 2)
		begin
			ts_dout_r	<= {1'b1,28'b0,continue_cnt};//25个包打成一个块，块号为0-15
			ts_dout_en	<= 1'b1;
		end		
		else if(ts_cnt == 3)
		begin
			ts_dout_r	<= {1'b0,29'b0,pid_ram_dout,cw_ram_dout[65:64]};//PID是否加扰，连续计数器是否连续，奇偶性，CW寄存器地址
			ts_dout_en	<= 1'b1;
		end
		else if(ts_cnt == 4)
		begin
			ts_dout_r	<= {1'b0,cw_ram_dout[63:32]};//64'hbe00460446007cc2};//
			ts_dout_en	<= 1'b1;
		end
		else if(ts_cnt == 5)
		begin
			ts_dout_r	<= {1'b0,cw_ram_dout[31:0]};
			ts_dout_en	<= 1'b1;
		end
		else
		begin
			ts_dout_r	<= {1'b0,ts_din_r5};
			ts_dout_en	<= ts_din_en_r5;
		end
	end
	
	always @(posedge clk)
	begin
		ts_dout	<= ts_dout_r;
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 0)
		begin
			ts1_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts1_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 1)
		begin
			ts2_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts2_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 2)
		begin
			ts3_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts3_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 3)
		begin
			ts4_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts4_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 4)
		begin
			ts5_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts5_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 5)
		begin
			ts6_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts6_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 6)
		begin
			ts7_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts7_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 7)
		begin
			ts8_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts8_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 8)
		begin
			ts9_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts9_dout_en	<= 0;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(channel_cnt == 9)
		begin
			ts10_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts10_dout_en	<= 0;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(channel_cnt == 10)
		begin
			ts11_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts11_dout_en	<= 0;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(channel_cnt == 11)
		begin
			ts12_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts12_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 12)
		begin
			ts13_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts13_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 13)
		begin
			ts14_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts14_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 14)
		begin
			ts15_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts15_dout_en	<= 0;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(channel_cnt == 14)
		begin
			ts15_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts15_dout_en	<= 0;
		end
	end
	
	
	
	always @(posedge clk)
	begin
		if(channel_cnt == 15)
		begin
			ts16_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts16_dout_en	<= 0;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(channel_cnt == 16)
		begin
			ts17_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts17_dout_en	<= 0;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(channel_cnt == 17)
		begin
			ts18_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts18_dout_en	<= 0;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(channel_cnt == 18)
		begin
			ts19_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts19_dout_en	<= 0;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(channel_cnt == 19)
		begin
			ts20_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts20_dout_en	<= 0;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(channel_cnt == 20)
		begin
			ts21_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts21_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 21)
		begin
			ts22_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts22_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 22)
		begin
			ts23_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts23_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 23)
		begin
			ts24_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts24_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 24)
		begin
			ts25_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts25_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 25)
		begin
			ts26_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts26_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 26)
		begin
			ts27_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts27_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 27)
		begin
			ts28_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts28_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 28)
		begin
			ts29_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts29_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 29)
		begin
			ts30_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts30_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 30)
		begin
			ts31_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts31_dout_en	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(channel_cnt == 31)
		begin
			ts32_dout_en	<= ts_dout_en;
		end
		else
		begin
			ts32_dout_en	<= 0;
		end
	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 32)
//		begin
//			ts33_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts33_dout_en	<= 0;
//		end
//	end
//	
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 33)
//		begin
//			ts34_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts34_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 34)
//		begin
//			ts35_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts35_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 35)
//		begin
//			ts36_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts36_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 36)
//		begin
//			ts37_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts37_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 37)
//		begin
//			ts38_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts38_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 38)
//		begin
//			ts39_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts39_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 39)
//		begin
//			ts40_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts40_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 40)
//		begin
//			ts41_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts41_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 41)
//		begin
//			ts42_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts42_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 42)
//		begin
//			ts43_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts43_dout_en	<= 0;
//		end
//	end
//	
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 43)
//		begin
//			ts44_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts44_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 44)
//		begin
//			ts45_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts45_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 45)
//		begin
//			ts46_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts46_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 46)
//		begin
//			ts47_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts47_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 47)
//		begin
//			ts48_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts48_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 48)
//		begin
//			ts49_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts49_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 49)
//		begin
//			ts50_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts50_dout_en	<= 0;
//		end
//	end
//	
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 50)
//		begin
//			ts51_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts51_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 51)
//		begin
//			ts52_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts52_dout_en	<= 0;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 52)
//		begin
//			ts53_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts53_dout_en	<= 0;
//		end
//	end
//	
//	
//	always @(posedge clk)
//	begin
//		if(channel_cnt == 53)
//		begin
//			ts54_dout_en	<= ts_dout_en;
//		end
//		else
//		begin
//			ts54_dout_en	<= 0;
//		end
//	end

	
	
	
	always @(posedge clk)
	begin
		if(pid_con_din_en == 1'b1)
		begin
			pid_con_cnt	<= pid_con_cnt + 16'b1;
		end
		else
		begin
			pid_con_cnt	<= 0;
		end
	end
		
	always @(posedge clk)
	begin
		if(pid_con_cnt > 5)
		begin
			if(pid_con_clk_cnt == 4)
			begin
				pid_con_clk_cnt	<= 0;
			end
			else
			begin
				pid_con_clk_cnt	<= pid_con_clk_cnt + 4'b1;
			end
		end
		else
		begin
			pid_con_clk_cnt	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(pid_con_clk_cnt == 2)
		begin
			pid_ram_addra[11:8]	<= pid_con_din[3:0];
		end
		else if(pid_con_clk_cnt == 3)
		begin
			pid_ram_addra[7:0]	<= pid_con_din;
		end
		else
		begin
			pid_ram_addra	<= pid_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		if(pid_con_clk_cnt == 4)
		begin
			pid_ram_din	<= pid_con_din[0];
			pid_ram_wr	<= 1'b1;
		end
		else
		begin
			pid_ram_din	<= 0;
			pid_ram_wr	<= 0;
		end
	end
	
	csa_ram_pid	pid_ram(
			.clka			(clk),
			.dina			(pid_ram_din),
			.addra			(pid_ram_addra),
			.wea			(pid_ram_wr),
			.clkb			(clk),
			.addrb			(pid_ram_addrb),
			
			.doutb          (pid_ram_dout)
			);
			
	always @(posedge clk)
	begin
		if(cw_con_din_en)
		begin
			cw_con_cnt	<= cw_con_cnt + 8'b1;
		end
		else
		begin
			cw_con_cnt	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(cw_con_cnt == 2)
		begin
			cnt_ram_addr[11:8]	<= cw_con_din[3:0];
		end
		else if(cw_con_cnt == 3)
		begin
			cnt_ram_addr[7:0]	<= cw_con_din;
		end
		else
		begin
			cnt_ram_addr	<= cnt_ram_addr;
		end
	end
	
	always @(posedge clk)
	begin
		if(cw_con_cnt == 4)
		begin
			cnt_ram_din	<= cw_con_din;
		end
		else 
		begin
			cnt_ram_din	<= cnt_ram_din;
		end
	end
	
	always @(posedge clk)
	begin
		if(cw_con_cnt == 8)
		begin
			cnt_ram_wr	<= 1'b1;
		end
		else
		begin
			cnt_ram_wr	<= 1'b0;
		end
	end
	
	always @(posedge clk)
	begin
		if(cw_con_cnt == 6)
		begin
			ram_dout_cnt	<= cnt_ram_dout + 8'b1;
		end
		else
		begin
			ram_dout_cnt	<= ram_dout_cnt;
		end
	end
	
	always @(posedge clk)
	begin
		if(cw_con_cnt == 8)
		begin
			if(ram_dout_cnt == cnt_ram_din)
			begin
				csa_flag	<= 1'b1;
			end
			else
			begin
				csa_flag	<= 1'b0;
			end
		end
		else
		begin
			csa_flag	<= csa_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(cw_con_cnt == 5)
		begin
			cw_ram_din[64]	<= cw_con_din[0];
		end
		else if(cw_con_cnt == 6)
		begin
			cw_ram_din[63:56]	<= cw_con_din;
		end
		else if(cw_con_cnt == 7)
		begin
			cw_ram_din[55:48]	<= cw_con_din;
		end
		else if(cw_con_cnt == 8)
		begin
			cw_ram_din[47:40]	<= cw_con_din;
		end
		else if(cw_con_cnt == 9)
		begin
			cw_ram_din[39:32]	<= cw_con_din;
		end
		else if(cw_con_cnt == 10)
		begin
			cw_ram_din[31:24]	<= cw_con_din;
		end
		else if(cw_con_cnt == 11)
		begin
			cw_ram_din[23:16]	<= cw_con_din;
		end
		else if(cw_con_cnt == 12)
		begin
			cw_ram_din[15:8]	<= cw_con_din;
		end
		else if(cw_con_cnt == 13)
		begin
			cw_ram_din[7:0]	<= cw_con_din;
			cw_ram_din[65]	<= csa_flag;
		end
		else
		begin
			cw_ram_din	<= cw_ram_din;
		end
	end
	
	always @(posedge clk)
	begin
		if(cw_con_cnt > 17)
		begin
			if(cw_con_cnt[0] == 0)
			begin
				cw_ram_addra[11:8]	<= cw_con_din[3:0];
				cw_ram_wr	<= 1'b0;
			end
			else if(cw_con_cnt[0] == 1)
			begin
				cw_ram_addra[7:0]	<= cw_con_din;
				cw_ram_wr		<= 1'b1;
			end
		end
		else
		begin
			cw_ram_addra	<= cw_ram_addra;
			cw_ram_wr	<= 0;
		end
	end
			
	csa_ram_cw	 csa_ram_cw(
			.clka			(clk),
			.dina			(cw_ram_din),
			.addra			(cw_ram_addra),
			.wea			(cw_ram_wr),
			.clkb			(clk),
			.addrb			(cw_ram_addrb),
			
			.doutb          (cw_ram_dout)
			);	
			
	csa_cnt_ram	cnt_ram(
			.clka			(clk),
			.dina			(cnt_ram_din),
			.addra			(cnt_ram_addr),
			.wea			(cnt_ram_wr),
			.clkb			(clk),
			.addrb			(cnt_ram_addr),
			
			.doutb          (cnt_ram_dout)
			);	
			
	
	
endmodule
