`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:44:55 02/10/2012 
// Design Name: 
// Module Name:    net_cmd_treat 
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
module net_cmd_treat(
	clk,
	rst,
	
	con_din_en,
	con_din,
	
	update_flag,//升级数据标志
	reconfig_flag,//重配置数据标志
	
	con_dout_en_bpi,
	con_dout_bpi,
	
	con_dout,
	con_dout_en


    );
input clk;
input	rst;

input con_din_en;
input [7:0]con_din;

input update_flag;//升级数据标志
input reconfig_flag;//重配置数据标志

input con_dout_en_bpi;
input [7:0]con_dout_bpi;

output [7:0]con_dout;
output con_dout_en;

reg  [7:0]con_dout;
reg  con_dout_en;

reg [7:0]cmd_reg1;
reg [7:0]cmd_reg2;
reg [7:0]cmd_reg3;
reg [7:0]cmd_reg4;
reg [7:0]cmd_reg5;
reg [7:0]cmd_reg6;
reg [7:0]cmd_reg7;
reg [7:0]cmd_reg8;


reg [10:0]con_cnt;

parameter IDLE=0,
				 CMD_SEND=1;

reg [7:0]ack_flag;
reg state;
reg [3:0]send_cnt;

reg [7:0]con_din_r,con_din_rr;


always@(posedge clk)begin
	con_din_r<=con_din;
	con_din_rr<=con_din_r;
end




always@(posedge clk)begin
	if(rst)
			ack_flag<=0;
	else if(con_dout_en_bpi)
			ack_flag<=con_dout_bpi;
	else 
			ack_flag<=ack_flag;
	
end

always@(posedge clk)
begin
	if(rst)
		con_cnt<=0;
	else if(con_din_en)
		con_cnt<=con_cnt+1;
	else 
		con_cnt<=0;
end 


always@(posedge clk)begin
	if(rst)
	begin
		cmd_reg1<=0;
		cmd_reg2<=0;
		cmd_reg3<=0;
		cmd_reg4<=0;
		cmd_reg5<=0;
		cmd_reg6<=0;
		cmd_reg7<=0;
		cmd_reg8<=0;		
	end 
	else if(reconfig_flag || update_flag)
	begin
		case(con_cnt)
			2:cmd_reg1<=con_din_rr;
			3:cmd_reg2<=con_din_rr;
			4:cmd_reg3<=con_din_rr;
			5:cmd_reg4<=con_din_rr;
			6:cmd_reg5<=con_din_rr;
			7:cmd_reg6<=con_din_rr;
			8:cmd_reg7<=con_din_rr;
			9:cmd_reg8<=con_din_rr;
		default:
		begin
			cmd_reg1<=cmd_reg1;
			cmd_reg2<=cmd_reg2;
			cmd_reg3<=cmd_reg3;
			cmd_reg4<=cmd_reg4;
			cmd_reg5<=cmd_reg5;
			cmd_reg6<=cmd_reg6;
			cmd_reg7<=cmd_reg7;
			cmd_reg8<=cmd_reg8;		
		end
		endcase
	end 
	else begin
		cmd_reg1<=cmd_reg1;
		cmd_reg2<=cmd_reg2;
		cmd_reg3<=cmd_reg3;
		cmd_reg4<=cmd_reg4;
		cmd_reg5<=cmd_reg5;
		cmd_reg6<=cmd_reg6;
		cmd_reg7<=cmd_reg7;
		cmd_reg8<=cmd_reg8;
	end
end


always@(posedge clk)
begin
	if(rst)
			state<=0;
	else 
	begin
		case(state)
			IDLE:if(con_dout_en_bpi)
				state<=CMD_SEND;
			else	
				state<=IDLE;
			CMD_SEND:if(send_cnt==12)
					state<=IDLE;
				else
					state<=state;
		default:
			state<=IDLE;		
		endcase
	end
end


always@(posedge clk)
begin
	if(rst)
		send_cnt<=0;
	else if(state==CMD_SEND)
		send_cnt<=send_cnt+1;
	else
		send_cnt<=0;
end


always@(posedge clk)begin
	if(rst)
	begin
		con_dout<=0;
		con_dout_en<=0;
	end
	else 	if(state==CMD_SEND)
	begin
		case(send_cnt)
		0:
		begin
			con_dout<=cmd_reg1;
			con_dout_en<=1;
		end
		1:
		begin
			con_dout<=cmd_reg2;
			con_dout_en<=1;
		end
		2:
		begin
			con_dout<=cmd_reg3;
			con_dout_en<=1;
		end
		3:
		begin
			con_dout<=cmd_reg4;
			con_dout_en<=1;
		end
		4:
		begin
			con_dout<=cmd_reg5;
			con_dout_en<=1;
		end
		5:
		begin
			con_dout<=cmd_reg6;
			con_dout_en<=1;
		end
		6:
		begin
			con_dout<=cmd_reg7;
			con_dout_en<=1;
		end
		7:
		begin
			con_dout<=cmd_reg8;
			con_dout_en<=1;
		end
		8,9,10,11:
		begin
			con_dout<=8'hff;
			con_dout_en<=1;
		end
		
		12:
		begin
			con_dout<=ack_flag;
			con_dout_en<=1;
		end
		default:
		begin
			con_dout<=0;
			con_dout_en<=0;
		end
		endcase
	end
	else 
	begin
		con_dout<=0;
		con_dout_en<=0;
	end	 
end 


endmodule
