`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:58:39 10/18/2011 
// Design Name: 
// Module Name:    reconfig_powerup 
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
module reconfig_powerup(

clk,
rst,

reconfig_data,
reconfig_data_en,

bpi_idle,
config_valid,
reconfig_status,
reconfig_version,

reconfig_read_start,
reconfig_read_continue,
reconfig_read_end,

con_dout,
con_dout_en



    );
	
	
input clk;
input rst;

input [15:0]reconfig_data;
input reconfig_data_en;

input bpi_idle;

input config_valid;



output  [7:0]reconfig_status;
output 	[7:0]reconfig_version;

output reconfig_read_start;
output reconfig_read_continue;
output	reconfig_read_end;

output [7:0]con_dout;
output con_dout_en;


wire [7:0]con_dout_tran;
wire con_dout_tran_en;



cmd_treat cmd_tre (
    .clk(clk), 
    .rst(rst), 
    .reconfig_data(reconfig_data), 
    .reconfig_data_en(reconfig_data_en), 
    .bpi_idle(bpi_idle),   
	.config_valid(config_valid),
    .reconfig_read_start(reconfig_read_start), 
    .reconfig_read_end(reconfig_read_end), 
    .con_dout(con_dout_tran), 
    .con_dout_en(con_dout_tran_en),
    .reconfig_status(reconfig_status), 
    .reconfig_version1(reconfig_version)
    );

cmd_send cmd_sd (
    .clk(clk), 
    .rst(rst), 
    .con_din(con_dout_tran), 
    .con_din_en(con_dout_tran_en), 
    .reconfig_read_continue(reconfig_read_continue), 
    .con_dout(con_dout), 
    .con_dout_en(con_dout_en)
    );


	
	
endmodule
