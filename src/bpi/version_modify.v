`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:26:12 08/15/2011 
// Design Name: 
// Module Name:    version_modify 
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
module version_modify(
	clk,
	rst,
	
	
	systerm_power_up,
	update_flag,

	config_reset,
	icap_start_r,
	reconfig_flag_set,
	reconfig_flag_clr,
	
	mcu_tx,
	icap_start

    );

input	clk;
input	rst;
	
input systerm_power_up;//系统从flash读取成功，从f单片机读取 是否加载重配置	
input 	update_flag;

input	config_reset;//系统烧写flash 初始复位 
input	icap_start_r;//系统烧写flash成功
input 	reconfig_flag_set;
input 	reconfig_flag_clr;
	
output	mcu_tx;
output icap_start;

reg systerm_power_up_r;
reg config_reset_r;
reg icap_start_rr;
reg icap_start;

reg [7:0]version_reg;
reg version_reg_en;

wire tx_end;

reg [1:0]state;
parameter IDLE=0,
				   SET_WAIT=1,
				   SET_ICAP=2;
reg [7:0]set_cnt;
////////////////////////////////////////设置单片机中的版本号，在编程FLASH一开始将版本号设置为0，再编程成功后在置1
always@(posedge clk)begin
config_reset_r<=config_reset;
icap_start_rr<=icap_start_r;
systerm_power_up_r<=systerm_power_up;
end

always@(posedge clk)begin
	if(rst)begin
		version_reg<=0;
		version_reg_en<=0;
	end
	else if(systerm_power_up&&!systerm_power_up_r)begin //获取重配配置是否加载标志
		version_reg<=8'hAC;
		version_reg_en<=1;
	end
	else if(reconfig_flag_clr)begin//清除重配置加载标志
		version_reg<=8'h59;
		version_reg_en<=1;
	end 
	else if(reconfig_flag_set)begin//置位重配置加载标志
		version_reg<=8'hA6;
		version_reg_en<=1;
	end
	else if(update_flag&config_reset&&!config_reset_r)begin //将版本号写为无效
		version_reg<=8'h55;
		version_reg_en<=1;
	end
	else if(icap_start_r&&!icap_start_rr)begin//将版本号写为有效
		version_reg<=8'haa;
		version_reg_en<=1;
	end
	else begin
		version_reg<=0;
		version_reg_en<=0;
	end

end

	s_port_byte_out uart_rx (
    .clk(clk), 
    .reset(rst), 
    .byte_in(version_reg), 
    .byte_in_en(version_reg_en), 
    .s_out(mcu_tx), 
    .tx_end(tx_end)
    );
//////////////////////////////////////////编程成功，单片机版本设置完成，输出重配置信号

always@(posedge clk)begin
	if(rst)begin
		state<=IDLE;
	end
	else begin
		case(state)
			IDLE:if(icap_start_r)
					state<=SET_WAIT;
			else
				state<=state;
			SET_WAIT:if(tx_end)
				state<=SET_ICAP;
			else
				state<=state;
			SET_ICAP:if(set_cnt==200)
				state<=IDLE;
			else	
				state<=state;
			default:
				state<=IDLE;		
		endcase
	end
end

always@(posedge clk)begin
	if(rst)
		set_cnt<=0;
	else if(state==SET_ICAP)
		set_cnt<=set_cnt+8'h1;
	else
		set_cnt<=0;
end

always@(posedge clk)begin
	if(rst)
		icap_start<=0;
	else if(state==SET_ICAP)
		icap_start<=1;
	else
		icap_start<=0;
end
	

endmodule
