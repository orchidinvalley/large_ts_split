`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:10:44 05/07/2009 
// Design Name: 
// Module Name:    mux_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
// The top of multiplexor
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mux_top
(
    //input
    clk,
	rst,	

	data_in	,
	data_in_valid,
	
	con_din,
	con_din_en,	

	rate_din,//输出码率统计用的
	rate_din_en,
		
	//output		
	si_dout,
	si_dout_en,
	
	psi_addr,
	psi_addr_en,
	si_ddr_dout,
	si_ddr_dout_en,
		
    ts_dout,
    ts_dout_en,
 	sfp1_ip,
	sfp1_mac,
	sfp2_ip,
	sfp2_mac,
	sfp3_ip,
	sfp3_mac,
	sfp4_ip,
	sfp4_mac,

	test_flag_mux_ip
);    
   
	input			clk;
	input			rst;

	input	[32:0]	data_in	;//32bit*125M=4G	gbe+ip+port+188=1+1+1+47
//    input   [64:0]  data_in;
	input			data_in_valid;
	
	input	[7:0]	con_din;
	input			con_din_en;	

	input	[15:0]	rate_din;
	input			rate_din_en;
	
	output	[7:0]	si_dout;
	output			si_dout_en;
	
	output	[35:0]	psi_addr;
	output			psi_addr_en;
	output	[7:0]	si_ddr_dout;
	output			si_ddr_dout_en;
	
	
	output	[32:0]	ts_dout;//32bit pid序号+GBE+IP+PORT+188
//    output  [64:0]  ts_dout;
	output			ts_dout_en;
	
	output	[31:0]	sfp1_ip;
	output	[47:0]	sfp1_mac;
	output	[31:0]	sfp2_ip;
	output	[47:0]	sfp2_mac;
	output	[31:0]	sfp3_ip;
	output	[47:0]	sfp3_mac;
	output	[31:0]	sfp4_ip;
	output	[47:0]	sfp4_mac;
	
	output			test_flag_mux_ip;
	
	reg		[7:0]	si_dout;
	reg				si_dout_en;

////////////////////////////////////////////////////////////////////////////////
	
	wire	[7:0]	si_read_dout;
	wire	[7:0]	ip_con_dout;
	wire	[7:0]	pid_con_dout;
	wire	[7:0]	si_con_dout;
	wire	[7:0]	tab_con_dout;
	wire	[7:0]	rate_con_dout;
	wire	[7:0]	rateout_con_dout; 
	wire	[7:0]	rd_tem_sta_dout;
	
	wire	[32:0]	ts1_dout;
	wire	[32:0]	ts_din;	
	wire	[15:0]	rate_dout;
	
	wire	[7:0]	si1_dout;
	wire			si1_dout_en;
	wire	[7:0]	rate1_dout;
	wire			rate1_dout_en;
	wire	[7:0]	rate2_dout;
	wire			rate2_dout_en;
	wire	[7:0]	con_dout;
	wire			con_dout_en;
	wire	[7:0]	ip_dout;
	wire			ip_dout_en;
	wire	[7:0]	sysmonitor_dout;
	wire			sysmonitor_dout_en;
	
	wire 	[7:0]con_reconfig;
	wire 			con_reconfig_en=0;
	
	
	reg     [7:0]   con_din_mux;
	reg             con_din_mux_en;
	
	wire    [7:0]	replay_dout;
	wire		    replay_dout_en;
	
//////////////////////////////////////////////////////////////////////////////// 
    
    mux_con_treat	con_treat(

		.clk					(clk),
		.rst					(rst),
		
		.con_din				(con_din),
		.con_din_en				(con_din_en),
		
		.con_dout				(con_dout),
		.con_dout_en            (con_dout_en),
		.replay_dout  			(replay_dout	),
		.replay_dout_en         (replay_dout_en )
		
    	);
    	
    	
    always@(posedge clk)begin
		if(rst)begin
			con_din_mux<=0;
			con_din_mux_en<=0;
		end
		else if(con_reconfig_en)begin
			con_din_mux<=con_reconfig;
			con_din_mux_en<=con_reconfig_en;
		end
		else begin
			con_din_mux<=con_dout;
			con_din_mux_en<=con_dout_en;
		end
	end 	
    	
    
	mux_command_control	command_ctrl(

		.clk					(clk),
		.rst					(rst),
		
		.con_din				(con_din_mux),
		.con_din_en				(con_din_mux_en),
		
		.si_read_dout			(si_read_dout),
		.si_read_dout_en		(si_read_dout_en),
		.ip_con_dout			(ip_con_dout),
		.ip_con_dout_en			(ip_con_dout_en),
		.pid_con_dout			(pid_con_dout),
		.pid_con_dout_en		(pid_con_dout_en),
		.si_con_dout			(si_con_dout),
		.si_con_dout_en         (si_con_dout_en),
		.rate_con_dout			(rate_con_dout),
		.rate_con_dout_en		(rate_con_dout_en),
		
		.rateout_con_dout			(rateout_con_dout),
		.rateout_con_dout_en		(rateout_con_dout_en),
		
		.tab_con_dout			(tab_con_dout),
		.tab_con_dout_en		(tab_con_dout_en),
		.rd_tem_sta_dout		(rd_tem_sta_dout	),  // interface for rd-temperature and status
		.rd_tem_sta_dout_en		(rd_tem_sta_dout_en )   // interface for rd-temperature and status
    	);


//	mux_si_get_32to8 si_get (
	mux_si_get_32to8_v1_1    si_get     //modify by prf 20150414
	(
	    .i_clk                            (clk), 
	    .i_reset                         (rst), 
	    .iv_ts                            (data_in), 
	    .i_ts_en                        (data_in_valid), 
	    .iv_con                          (si_read_dout), 
	    .i_con_en                      (si_read_dout_en), 
	    .ov_si                            (si1_dout), 
	    .o_si_en                        (si1_dout_en)
	);



	wire [32:0]ts_dout_diff;
    	
   ts_diff uut (
    .clk(clk), 
    .rst(rst), 
    .ts_din(data_in), 
    .ts_din_en(data_in_valid), 
    .ts_dout(ts_dout_diff), 
    .ts_dout_en(ts_dout_diff_en)
    );
 	




    	
    mux_ip_rej	ip_rej(//2014-01-28修改

		.clk					(clk),
		.rst					(rst),
		
		.ts_din					(ts_dout_diff),
		.ts_din_en				(ts_dout_diff_en),
		.con_din				(ip_con_dout),
		.con_din_en				(ip_con_dout_en),
		
		.ts_dout				(ts1_dout),
		.ts_dout_en             (ts1_dout_en)
    	);
    	
    	
    	test_mux_ip instance_name (
    .clk(clk), 
    .rst(rst), 
    .ts_din(ts1_dout), 
    .ts_din_en(ts1_dout_en), 
    .flag(test_flag_mux_ip)
    );
    	
    	
//    mux_test 					mux_test_init//丢包检测，2014-01-28注释掉
//    (
//	    .clk					(clk), 
//	    .data_in				(ts1_dout), 
//	    .data_in_valid			(ts1_dout_en), 
//	    .test_flag				(test_flag_mux_ip)
//    );

    	
    mux_pid_rej	pid_rej(//2014-01-28修改

		.clk					(clk),
		.rst					(rst),
		
		.ts_din					(ts1_dout),
		.ts_din_en				(ts1_dout_en),
		.con_din				(pid_con_dout),
		.con_din_en				(pid_con_dout_en),
		
		.ts_dout				(ts_dout),
		.ts_dout_en             (ts_dout_en),
		.rate_dout				(rate_dout),
		.rate_dout_en			(rate_dout_en)
    	);
    	    	
    mux_si_ctrl	si_ctrl(

		.clk					(clk),
		.rst					(rst),
		
		.con_din				(si_con_dout),
		.con_din_en				(si_con_dout_en),
		.con_din_tab			(tab_con_dout),
		.con_din_tab_en			(tab_con_dout_en),
		
		.si_ddr_dout			(si_ddr_dout),
		.si_ddr_dout_en			(si_ddr_dout_en),
		.si_addr_dout			(psi_addr),
		.si_addr_dout_en        (psi_addr_en)
    	);
    
  	mux_rate_in_monitor	rate_in(

		.clk					(clk),
		.rst					(rst),
		
		.rate_din				(rate_dout),
		.rate_din_en			(rate_dout_en),
		.con_din				(rate_con_dout),
		.con_din_en				(rate_con_dout_en),
		
		.rate_dout				(rate1_dout),
		.rate_dout_en	        (rate1_dout_en)
    	);
    	
    mux_rate_out_monitor	rate_out(

		.clk					(clk),
		.rst					(rst),
		
		.rate_din				(rate_din),
		.rate_din_en			(rate_din_en),
		.con_din				(rateout_con_dout),
		.con_din_en				(rateout_con_dout_en),
		
		.rate_dout				(rate2_dout),
		.rate_dout_en	        (rate2_dout_en)
    	);
    	
    always @(posedge clk)
    begin
    	if(rate1_dout_en)
    	begin
    		si_dout	<= rate1_dout;
    		si_dout_en	<= rate1_dout_en;
    	end
    	else if (ip_dout_en)
    	begin
    		si_dout <= ip_dout;
    		si_dout_en <= ip_dout_en;
    	end
    	else if(rate2_dout_en)
    	begin
    		si_dout	<= rate2_dout;
    		si_dout_en	<= rate2_dout_en;
    	end
    	else if(replay_dout_en)
    	begin
    		si_dout	     <= replay_dout;
    		si_dout_en	 <= replay_dout_en;
    	end 
    	else if(sysmonitor_dout_en)   //rd temperature return
    	begin
    		si_dout		<= sysmonitor_dout;
    		si_dout_en	<= sysmonitor_dout_en;
    	end
    	else 
    	begin
    		si_dout	    <= si1_dout;
    		si_dout_en	<= si1_dout_en;
    	end
    end
    
	cmd_sfp_ip_new cmd_sfp_ip(
		.clk				(clk			),
		.rst				(rst			),
		.rx_data			(con_din_mux		),
		.rx_data_en			(con_din_mux_en		),
		.tx_data			(ip_dout		),
		.tx_data_en			(ip_dout_en		),
		.sfp1_ip			(sfp1_ip		),
		.sfp1_mac			(sfp1_mac		),
		.sfp2_ip			(sfp2_ip		),
		.sfp2_mac			(sfp2_mac		),
		.sfp3_ip			(sfp3_ip		),
		.sfp3_mac			(sfp3_mac		),
		.sfp4_ip			(sfp4_ip		),
		.sfp4_mac			(sfp4_mac		)
//		.sfp5_ip			(sfp5_ip		),
//		.sfp5_mac			(sfp5_mac		),
//		.sfp6_ip			(sfp6_ip		),
//		.sfp6_mac			(sfp6_mac		),
//		.sfp7_ip			(sfp7_ip		),
//		.sfp7_mac			(sfp7_mac		),
//		.sfp8_ip			(sfp8_ip		),
//		.sfp8_mac			(sfp8_mac		),
//		.sfp9_ip			(sfp9_ip		),
//		.sfp9_mac			(sfp9_mac		),
//		.sfp10_ip			(sfp10_ip		),
//		.sfp10_mac			(sfp10_mac		),
//		.sfp11_ip			(sfp11_ip		),
//		.sfp11_mac			(sfp11_mac		),
//		.sfp12_ip			(sfp12_ip		),
//		.sfp12_mac			(sfp12_mac		),
//		.sfp13_ip			(sfp13_ip	),
//		.sfp13_mac	        (sfp13_mac	),
//		.sfp14_ip	        (sfp14_ip	),
//		.sfp14_mac	        (sfp14_mac	),
//		.sfp15_ip	        (sfp15_ip	),
//		.sfp15_mac	        (sfp15_mac	),
//		.sfp16_ip	        (sfp16_ip	),
//		.sfp16_mac	        (sfp16_mac	),
//		.sfp17_ip	        (sfp17_ip	),
//		.sfp17_mac	        (sfp17_mac	),
//		.sfp18_ip	        (sfp18_ip	),
//		.sfp18_mac	        (sfp18_mac	),
//		.sfp19_ip	        (sfp19_ip	),
//		.sfp19_mac	        (sfp19_mac	),
//		.sfp20_ip	        (sfp20_ip	),
//        .sfp20_mac	        (sfp20_mac	) 
    );    
    

//	top_system_monitor		top_system_monitor_init
//	(                       	
//		.CLK_IN				(clk), 		//外部主时钟180MHz
//		.RESET_IN			(rst), 		//复位信号	
//		
//		.con_din			(rd_tem_sta_dout),
//		.con_din_en			(rd_tem_sta_dout_en),
//			
//		.DO_OUT				(sysmonitor_dout),			//8bits数据输出
//		.DATA_READY_OUT		(sysmonitor_dout_en)			//数据输出有效信号  
////		.led1				(led1),
////		.led2				(led2),
////		.led3				(led3),
////		.led4				(led4 ),
////		.led5				(led5 ),
////		.led6				(led6),
////		.led7				(led7),
////		.led8				(led8),
////		.led9				(led9),
////		.led10				(led10),
////		.led11				(led11),
////		.led12				(led12),
////		.led13				(led13),
////		.led14				(led14),
////		.led15				(led15),
////		.led16				(led16),
////		.led17				(led17),
////		.led18				(led18),
////		.led19				(led19),
////		.led20              (led20),
////		.phy_tx				(phy_tx),
////		.phy_rx				(phy_rx),
////		.phy_fdx			(phy_fdx),
////		.phy_1000			(phy_1000)			
//	);


    
endmodule