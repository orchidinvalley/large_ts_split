`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:06:58 10/18/2011 
// Design Name: 
// Module Name:    cmd_treat 
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
module cmd_treat(

clk,
rst,

reconfig_data,
reconfig_data_en,

bpi_idle,

config_valid,

reconfig_read_start,
reconfig_read_end,

con_dout,
con_dout_en,
reconfig_status,
reconfig_version1

    );
	
	
input clk;
input rst;

input [15:0]reconfig_data;
input reconfig_data_en;

input  bpi_idle;

input config_valid;

output reconfig_read_start;
output reconfig_read_end;

output [7:0]con_dout;
output con_dout_en;

output  [7:0]reconfig_status;
output 	[7:0]reconfig_version1;

reg reconfig_read_start;
reg reconfig_read_end;

reg [7:0]con_dout,con_dout_r;
reg con_dout_en;


reg [8:0]con_cnt;

////////////////////////重配置是否正常完成或者出错中断的处理
reg  [7:0]reconfig_status;///aa 表示配置完成 55 表示 配置失败
reg  [15:0]reconfig_record;//重配置命令记录的总数目
reg  [15:0]reconfig_cnt;//记录的条数计数器
reg 	reconfig_success_tmp,reconfig_success_tmp_r;
reg reconfig_success,reconfig_fail;

reg [7:0]reconfig_version1;//第一块中取得	
reg [7:0]reconfig_version2;//最后一块中取得



parameter IDLE=0,
		  READ_ENABLE_SEND=1,
		  READ_CMD=2;
		
				
reg [1:0]state;
reg [1:0]nextstate;

reg [15:0]reconfig_data_reverse_r;
reg reconfig_data_en_r;

reg [7:0]fifo_din;
reg fifo_wr;

reg  fifo_rd;
reg  fifo_rd_r;
wire [7:0]fifo_dout;
wire prog_full;
wire fifo_full;

// reg power_up_r;
reg config_valid_r;

// wire power_up_flag=power_up&!power_up_r;
wire config_valid_flag=config_valid&!config_valid_r;
wire [15:0]reconfig_data_reverse;


assign reconfig_data_reverse[15]=reconfig_data[8];
assign reconfig_data_reverse[14]=reconfig_data[9];
assign reconfig_data_reverse[13]=reconfig_data[10];
assign reconfig_data_reverse[12]=reconfig_data[11];
assign reconfig_data_reverse[11]=reconfig_data[12];
assign reconfig_data_reverse[10]=reconfig_data[13];
assign reconfig_data_reverse[9]=reconfig_data[14];
assign reconfig_data_reverse[8]=reconfig_data[15];


assign reconfig_data_reverse[7]=reconfig_data[0];
assign reconfig_data_reverse[6]=reconfig_data[1];
assign reconfig_data_reverse[5]=reconfig_data[2];
assign reconfig_data_reverse[4]=reconfig_data[3];
assign reconfig_data_reverse[3]=reconfig_data[4];
assign reconfig_data_reverse[2]=reconfig_data[5];
assign reconfig_data_reverse[1]=reconfig_data[6];
assign reconfig_data_reverse[0]=reconfig_data[7];


always@(posedge clk)begin
	reconfig_data_en_r<=reconfig_data_en;
	reconfig_data_reverse_r<=reconfig_data_reverse;
end 

always@(posedge clk)begin
	if(reconfig_data_en)begin
		fifo_din<=reconfig_data_reverse[15:8];
		fifo_wr<=1;
	end
	else if(reconfig_data_en_r)begin
		fifo_din<=reconfig_data_reverse_r[7:0];
		fifo_wr<=1;
	end
	else begin
		fifo_din<=00;
		fifo_wr<=0;
	end
end



always@(posedge clk)begin
	//power_up_r<=power_up;
	config_valid_r<=config_valid;
	con_dout_r<=con_dout;
end 


	
always@(posedge clk )begin 
	if(rst)
		state<=IDLE;
	else 
		state<=nextstate;
end 	
	
always@(*)begin 
	case(state)
	IDLE:
//	if(power_up&&config_valid_flag)
	if(config_valid_flag)
		nextstate=READ_ENABLE_SEND;
	else if(fifo_full&&bpi_idle)
		nextstate=READ_CMD;
	else 
		nextstate=IDLE;	
	READ_ENABLE_SEND:
		nextstate=IDLE;
	READ_CMD:
	if(con_cnt==255)
		nextstate=IDLE;
	else 
		nextstate=READ_CMD;
	default:
		nextstate=IDLE;
	endcase
end 	



always@(posedge clk)begin
	if(rst)
		con_cnt<=0;
	else if(state==READ_CMD)
		con_cnt<=con_cnt+9'h1;
	else	
		con_cnt<=0;
end 


//////////////////////////////////////////////////////

always@(posedge clk)begin//记录条数计数器 ，没读出一个256 加 1
	if(rst)
		reconfig_cnt<=0;
	else if(state==READ_CMD && con_cnt==0)
		reconfig_cnt<=reconfig_cnt+16'b1;
	else
		reconfig_cnt<=reconfig_cnt;
end 

always@(posedge clk)begin//在第一个块中取出 记录总条数  第一个重配置版本号
	if(rst)
	begin 
		reconfig_record<=0;
		reconfig_version1<=0;
	end
	else if(reconfig_cnt==1)
	begin
	if(con_cnt==6)
	begin
		reconfig_record<={reconfig_record[7:0],con_dout};
		reconfig_version1<=reconfig_version1;
	end
	else if(con_cnt==7)
	begin
		reconfig_version1<=reconfig_version1;
		reconfig_record<={reconfig_record[7:0],con_dout};
	end
	else if (con_cnt==8)
	begin
	reconfig_record<=reconfig_record;
		reconfig_version1<=con_dout;	
	end
	else
	begin
		reconfig_record<=reconfig_record;
		reconfig_version1<=reconfig_version1;
	end
	end
	else
	begin
		reconfig_record<=reconfig_record;
		reconfig_version1<=reconfig_version1;
	end
end

always@(posedge clk )begin
	if(rst)
		reconfig_success_tmp<=0;
	else if(con_cnt==3 && con_dout==8'h00)
		reconfig_success_tmp<=1;
	else if(con_cnt<10)
		reconfig_success_tmp<=reconfig_success_tmp;
	else	
		reconfig_success_tmp<=0;
end 


always@(posedge clk)
begin
	if(rst)
		reconfig_version2<=0;
	else if(reconfig_success_tmp &&(con_cnt==6))
		reconfig_version2<=con_dout;
	else 
		reconfig_version2<=reconfig_version2;
end 



// always@(posedge clk )
// begin
	// reconfig_success_tmp_r<=reconfig_success_tmp;
// end

always@(posedge clk)
begin
	if(rst)
		reconfig_success<=0;
	else if(reconfig_success_tmp && con_cnt==8)
	begin
		if((reconfig_record+1==reconfig_cnt)&&(reconfig_version1==reconfig_version2))
			reconfig_success<=1;
		else 
			reconfig_success<=0;
	end
	else if(con_cnt<18)
		reconfig_success<=reconfig_success;
	else		
		reconfig_success<=0;
end

always@(posedge clk )begin
	if(rst)
		reconfig_fail<=0;	
	 else if(con_cnt==3 && con_dout>6)
		 reconfig_fail<=1;
	else if(con_cnt==4 && (con_dout>con_dout_r))
		reconfig_fail<=1;
	else if(reconfig_success_tmp && con_cnt==8)
	begin
		if((reconfig_record+1!=reconfig_cnt)||(reconfig_version1!=reconfig_version2))
			reconfig_fail<=1;
		else 
			reconfig_fail<=0;
	end
	else if(con_cnt<18)
		reconfig_fail<=reconfig_fail;
	else	
		reconfig_fail<=0;
end 

always@(posedge clk)
begin
	if(rst)
		reconfig_status<=0;
	else if(reconfig_success)
		reconfig_status<=8'haa;//配置成功
	else if(reconfig_fail)
		reconfig_status<=8'h55;//配置失败
	else 
		reconfig_status<=reconfig_status;
end



always@(posedge clk )begin
	if(rst)
		reconfig_read_start<=0;
	else if(state==READ_ENABLE_SEND)
		reconfig_read_start<=1;
	else	
		reconfig_read_start<=0;
end

always@(posedge clk )begin
	if(rst)
		reconfig_read_end<=0;
	else if(con_cnt==3 && con_dout==8'h00)
		reconfig_read_end<=1;
	else if(con_cnt==3 && con_dout > 6)
		reconfig_read_end<=1;
	else if(con_cnt==4 && (con_dout>con_dout_r))
		reconfig_read_end<=1;
	else	
		reconfig_read_end<=0;
end 


always@(posedge clk )begin
	if(rst)
		fifo_rd<=0;
	else if(state==READ_CMD )
		fifo_rd<=1;
	else	
		fifo_rd<=0;
end 

always@(posedge clk)
	fifo_rd_r<=fifo_rd;

always@(posedge clk)begin
	if(rst)begin
		con_dout<=0;
		con_dout_en<=0;
	end
	else if(fifo_rd_r)begin
		con_dout<=fifo_dout;
		con_dout_en<=1;
	end
	else begin
		con_dout<=0;
		con_dout_en<=0;
	end	
end


cmd_pre_fifo cmd_buffer (
	.clk(clk),
	.rst(rst),
	.din(fifo_din), // Bus [7 : 0] 
	.wr_en(fifo_wr),
	.rd_en(fifo_rd),
	.dout(fifo_dout), // Bus [7 : 0] 
	.full(fifo_full),
	.empty(),
	.prog_full());



endmodule
