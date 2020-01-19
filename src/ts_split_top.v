`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:39:09 08/29/2019 
// Design Name: 
// Module Name:    ts_split_top 
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
module ts_split_top(
	clk,
	rst,
	
	con_din,
	con_din_en,
	
	udp_din,
	udp_din_en,
	
	con_dout,
	con_dout_en,
	
	sfp1_ip,
	sfp2_ip,
	sfp3_ip,
	sfp4_ip,
	
	ts_ram_wr,
	ts_ram_waddr,
	ts_ram_wdata,
	ts_ram_valid,
	test_flag,
	ts_ram_clear,
	clk_pcie,
	ram_full_1,
	ram_full_2

	
    );
    
    input 	clk;
    input 	rst;
    
    input		[7:0]con_din;
    input		con_din_en;
    
    input 	[7:0]udp_din;
    input		udp_din_en;
    
    output	[7:0]con_dout;
    output	con_dout_en;
    
    reg			[7:0]con_dout;
    reg			con_dout_en;
    
    output 	[31:0]sfp1_ip;
		output 	[31:0]sfp2_ip;
		output 	[31:0]sfp3_ip;
		output 	[31:0]sfp4_ip;
    
   	output [12:0]ts_ram_waddr;
		output ts_ram_wr;
		output [511:0]ts_ram_wdata;
		output 	ts_ram_valid;
		input		ts_ram_clear;
		
		input 	clk_pcie;
		input		ram_full_1;
		input		ram_full_2;
		


		output 	test_flag;
		wire [7:0] si_get_con;
		wire si_get_con_en;
		wire [7:0]nit_con;
	  wire nit_con_en;
		wire [7:0] freq_con;
		wire freq_con_en;
		wire [7:0] channel_con;
		wire channel_con_en;
		wire [7:0] ip_port_con;
		wire ip_port_con_en;
		wire [7:0] reply_con;
		wire reply_con_en;
		
		wire	[32:0]udp_ip_data;
		wire	udp_ip_data_en;
		
		wire	[31:0]ip_nit_data;
		wire	ip_nit_data_en;
		
		wire	[31:0]nit_tsmf_data;
		wire 	nit_tsmf_data_en;		
		
		wire	[7:0]si_dout;
		wire	si_dout_en;
		
		wire 	[7:0]rate_dout;
		wire	rate_dout_en;
		
		reg	[3:0]udp_cnt;
		reg	[3:0]udp_cc;
		reg	[7:0]udp_ts_cnt;
		wire 		test_udp;
		wire 		test_tsmf;
		
		
		


	command_treat command_treat_uut (
    .clk(clk), 
    .rst(rst), 
    .con_din(con_din), 
    .con_din_en(con_din_en), 
    .si_get_con(si_get_con), 
    .si_get_con_en(si_get_con_en), 
    .nit_con(nit_con), 
    .nit_con_en(nit_con_en), 
    .freq_con(freq_con), 
    .freq_con_en(freq_con_en), 
    .channel_con(channel_con), 
    .channel_con_en(channel_con_en), 
    .ip_port_con(ip_port_con), 
    .ip_port_con_en(ip_port_con_en), 
    .reply_con(reply_con), 
    .reply_con_en(reply_con_en),
    .rate_con_start(rate_con_start),
    .rate_con_end(rate_con_end),
    .sfp1_ip(sfp1_ip), 
    .sfp2_ip(sfp2_ip), 
    .sfp3_ip(sfp3_ip), 
    .sfp4_ip(sfp4_ip)
    );


	



	udp_ts_split udp_ts_split_uut (
    .clk(clk), 
    .rst(rst), 
    .udp_din(udp_din), 
    .udp_din_en(udp_din_en), 
    .ts_dout(udp_ip_data), 
    .ts_dout_en(udp_ip_data_en)
    );
  
  
  always@(posedge clk)begin
  	if(udp_ip_data_en)
  		udp_ts_cnt	<=	udp_ts_cnt+1;
  	else
  		udp_ts_cnt	<=0;
  end  
  
  always@(posedge clk)begin
  	if(udp_ts_cnt	==3 && udp_ip_data[31:23]==9'h8e && udp_ip_data[21:8]==14'h200)begin
  		udp_cnt	<=udp_ip_data[3:0];
  		udp_cc	<=udp_ip_data[3:0]-udp_cnt;
  	end 
  	else begin
  		udp_cnt	<=	udp_cnt;
  		udp_cc	<=	udp_cc;
  	end
  end
  
  assign test_udp	=	udp_cc==1?1'b0:1'b1;
  assign	test_flag=	test_udp&test_tsmf;  
    
    
  si_get si_get_uut (
    .clk(clk), 
    .rst(rst), 
    .ts_din(udp_ip_data), 
    .ts_din_en(udp_ip_data_en), 
    .con_din(si_get_con), 
    .con_din_en(si_get_con_en), 
    .si_dout(si_dout), 
    .si_dout_en(si_dout_en)
    );
    
  ts_ip_rej ts_ip_rej_uut (
    .clk(clk), 
    .rst(rst), 
    .ts_din(udp_ip_data[31:0]), 
    .ts_din_en(udp_ip_data_en), 
    .ts_dout(ip_nit_data), 
    .ts_dout_en(ip_nit_data_en), 
    .ip_port_con_din(ip_port_con), 
    .ip_port_con_din_en(ip_port_con_en)
    );
    
    ts_speed ts_speed_uut (
    .clk(clk), 
    .rst(rst), 
    .ts_din(ip_nit_data), 
    .ts_din_en(ip_nit_data_en), 
    .rate_dout(rate_dout), 
    .rate_dout_en(rate_dout_en), 
    .rate_con_start(rate_con_start), 
    .rate_con_end(rate_con_end)
    );
    
   
    nit_replace nit_replace_uut (
    .clk(clk),
    .rst(rst),
    .ts_din(ip_nit_data),
    .ts_din_en(ip_nit_data_en),
    .nit_con(nit_con),
    .nit_con_en(nit_con_en),
    .ts_dout(nit_tsmf_data),
    .ts_dout_en(nit_tsmf_data_en)
    );

    
    
//   tsmf_split tsmf_split_uut (
//    .clk(clk), 
//    .rst(rst), 
//    .ts_din(ip_nit_data), 
//    .ts_din_en(ip_nit_data_en), 
//    .freq_con_din(freq_con), 
//    .freq_con_din_en(freq_con_en), 
//    .channel_din(channel_con), 
//    .channel_din_en(channel_con_en), 
//    .ts_ram_wr(ts_ram_wr), 
//    .ts_ram_waddr(ts_ram_waddr), 
//    .ts_ram_wdata(ts_ram_wdata),
//    .ts_ram_valid(ts_ram_valid),
//    .test_flag(test_flag),
//    .ts_ram_clear(ts_ram_clear)
//    );
//    

//			tsmf_split_new ts_split_uut (
//	    .clk_ts(clk), 
//	    .rst_ts(rst), 
//	    .ts_din(ip_nit_data), 
//	    .ts_din_en(ip_nit_data_en), 
//	    .freq_con_din(freq_con), 
//	    .freq_con_din_en(freq_con_en), 
//	    .channel_din(channel_con), 
//	    .channel_din_en(channel_con_en), 
//	    .clk_pcie(clk_pcie), 
//	    .ram_full_1(ram_full_1), 
//	    .ram_full_2(ram_full_2), 
//	    .ts_ram_wr(ts_ram_wr), 
//	    .ts_ram_wdata(ts_ram_wdata),
//	    .test_flag(test_flag)
//	    );

		tsmf_split_v1 ts_split_uut (
    .clk(clk), 
    .rst(rst), 
    .ts_din(nit_tsmf_data), 
    .ts_din_en(nit_tsmf_data_en), 
    .freq_con_din(freq_con), 
    .freq_con_din_en(freq_con_en), 
    .channel_din(channel_con), 
    .channel_din_en(channel_con_en), 
    .ts_ram_wr(ts_ram_wr), 
    .ts_ram_wdata(ts_ram_wdata), 
    .test_flag(test_tsmf)
    );	
    
    always@(posedge clk)begin
    	if(si_dout_en)begin
    		con_dout	<=	si_dout;
    		con_dout_en	<=	si_dout_en;
    	end
    	else if(rate_dout_en)begin
    		con_dout	<=		rate_dout;
    		con_dout_en	<=	rate_dout_en;
    	end
    	else begin
    		con_dout	<=	reply_con;
    		con_dout_en	<=	reply_con_en;
    	end
    end
    
  
    

endmodule
