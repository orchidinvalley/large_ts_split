`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:52:45 10/19/2011 
// Design Name: 
// Module Name:    cmd_pretreat 
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
module cmd_pretreat(
	clk,
	rst,
	
	con_din,
	con_din_en,
	
	con_bpi_en,
	
	update_flag,

	reconfig_flag,

	con_dout,
	con_dout_en
    );

input clk;
input	rst;

input con_din_en;
input [7:0]con_din;

input con_bpi_en;


output update_flag;
output reconfig_flag;

output [7:0]con_dout;
output con_dout_en;

reg update_flag;
reg reconfig_flag;

reg [7:0]con_dout;
reg con_dout_en;

reg update_tmp;
reg reconfig_tmp;
reg [10:0]con_cnt;
reg [7:0]con_din_r;

always@(posedge clk)
	con_din_r<=con_din;

always@(posedge clk)begin
	if(rst)
		con_cnt<=0;
	else if(con_din_en)
		con_cnt<=con_cnt+11'h1;
	else
		con_cnt<=0;
end 

always@(posedge clk)begin
	if(rst)
		update_flag<=0;
	else if(con_cnt==1)begin
		if(con_din_r==8'h04 && con_din==8'h20)
			update_flag<=1;
		else
			update_flag<=0;
	end
	else if(con_bpi_en)
		update_flag<=0;
	else
		update_flag<=update_flag;
end

// always@(posedge clk)begin
	// if(rst)
		// update_flag<=0;
	// else if(con_cnt==5 && update_tmp)begin
		// if(con_din_r==8'h00 && con_din ==8'h01)
			// update_flag<=1;
		// else
			// update_flag<=0;
	// end
	// else if(con_bpi_en)
		// update_flag<=0;
	// else 
		// update_flag<=update_flag;		
// end

always@(posedge clk)begin
	if(rst)
		reconfig_flag<=0;
	else if(con_cnt==1)begin
		if(con_din_r==8'h04 && con_din==8'h30)
			reconfig_flag<=1;
		else
			reconfig_flag<=0;
	end
	else if(con_bpi_en)
		reconfig_flag<=0;
	else
		reconfig_flag<=reconfig_flag;
end

// always@(posedge clk)begin
	// if(rst)
		// reconfig_flag<=0;
	// else if(con_cnt==5 && reconfig_tmp)begin
		// if(con_din_r==8'h00 && con_din ==8'h01)
			// reconfig_flag<=1;
		// else
			// reconfig_flag<=0;
	// end
	// else if(con_bpi_en)
		// reconfig_flag<=0;
	// else 
		// reconfig_flag<=reconfig_flag;		
// end

always@(posedge clk)begin
	if(rst)begin
		con_dout_en<=0;
		con_dout<=0;
	end
	else if(con_cnt>3)begin
		if(update_flag ||reconfig_flag)begin
			con_dout_en<=con_din_en;
			con_dout<=con_din;
		end
		else begin
			con_dout_en<=0;
			con_dout<=0;
		end
	end 
	else begin
		con_dout_en<=0;
		con_dout<=0;
	end
end 



endmodule
