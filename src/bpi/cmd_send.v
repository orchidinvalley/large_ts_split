`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:07:11 10/18/2011 
// Design Name: 
// Module Name:    cmd_send 
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
module cmd_send(
	clk,
	rst,
	
	con_din,
	con_din_en,
	
	reconfig_read_continue,
	
	con_dout,
	con_dout_en
    );

input	clk;
input	rst;
	
input	[7:0]con_din;
input	con_din_en;

output reconfig_read_continue;
	
output	[7:0]con_dout;
output	con_dout_en;

reg reconfig_read_continue;

reg	[7:0]con_dout;
reg	con_dout_en;


reg  [8:0]con_cnt;
reg [7:0]pack_num;
reg [7:0]pack_cnt;
reg [7:0]length;



reg fifo_wr;
reg [7:0]fifo_din;
reg  fifo_rd;
reg fifo_rd_r;

wire [7:0]fifo_dout;
wire [10:0]fifo_data_count;
wire empty;
                                 
wire  pack_flag1;
wire  pack_flag2;
wire  pack_flag3;
wire  pack_flag4;
                                 
                                 
                                 
                                 
parameter IDLE=0,                
				CMD_WR=1,
				CMD_WAIT=2,
				CMD_CONTINUE=3,
				CMD_SEND_PRE=4,
				CMD_SEND=5;
reg [2:0] state;
reg [2:0]nextstate;

// wire wr_start;

// always@(posedge clk)begin
	// con_dout_en_r<=con_din_en;
// end 

// assign wr_start<=con_dout_en&!con_dout_en_r;

always@(posedge clk)begin 
	if(rst)
		con_cnt<=0;
	else if(con_din_en)
		con_cnt<=con_cnt+9'h1;
	else 
		con_cnt<=0;		
end 

always@(posedge clk)begin
	if(rst)
		pack_num<=0;
	else	if(con_din_en && con_cnt==0)
		pack_num<=con_din;
	else 
		pack_num<=pack_num;
end 

always@(posedge clk)begin
	if(rst)
		pack_cnt<=0;
	else	if( con_cnt==1)
		pack_cnt<=con_din;
	else 
		pack_cnt<=pack_cnt;
end 

always@(posedge clk)begin
	if(rst)
		length<=0;
	else if(con_cnt==2)
		length<=con_din;
	else 
		length<=length;
end 

assign pack_flag1=(pack_cnt!=0)?1'b1:1'b0;
assign pack_flag2=(pack_num!=0)?1'b1:1'b0;
assign pack_flag3=(pack_cnt>pack_num)?1'b1:1'b0;
assign pack_flag4=(pack_num<7)?1'b1:1'b0;


always@(posedge clk)begin 
	if(rst)
		state<=IDLE;
	else
		state<=nextstate;
end 

always@(*)begin
	case(state)
		IDLE:
		if((con_cnt==2 && con_din !=8'h0 )&&pack_flag1 && pack_flag2 && !pack_flag3 && pack_flag4)
			nextstate=CMD_WR;
		else
			nextstate=IDLE;
		CMD_WR:
		if(con_cnt==(length+2))
			nextstate=CMD_WAIT;
		else
			nextstate=CMD_WR;
		CMD_WAIT:	
		if(pack_cnt==pack_num)
			nextstate=CMD_SEND_PRE;
		else
			nextstate=CMD_CONTINUE;
		CMD_CONTINUE:
			nextstate=IDLE;
		CMD_SEND_PRE:
			if(fifo_data_count==1)
				nextstate=IDLE;
			else
				nextstate=CMD_SEND;
		CMD_SEND:
		if(fifo_data_count==2)
			nextstate=IDLE;
		else
			nextstate=CMD_SEND;
		default:
			nextstate=IDLE;
	endcase
end 

always@(posedge clk)begin
	if(rst)begin 
		fifo_din<=0;
		fifo_wr<=0;
	end 
	else if(state==CMD_WR)begin
		fifo_din<=con_din;
		fifo_wr<=1;
	end
	else begin
		fifo_din<=0;
		fifo_wr<=0;
	end 
end 


//always@(posedge clk)begin
//	if(rst)
//		read_cnt<=0;
//	else if(state==CMD_SEND)
//		read_cnt<=read_cnt+1;
//	else
//		read_cnt<=0;
//end

always@(posedge clk)begin 
	if(rst)
		fifo_rd<=0;
	else if(state==CMD_SEND ||state==CMD_SEND_PRE) 
		fifo_rd<=1;	
	else 
		fifo_rd<=0;
end 

always@(posedge clk)begin 
	if(rst)
		reconfig_read_continue<=0;
	else if(state==CMD_CONTINUE)
		reconfig_read_continue<=1;
	else if(state == CMD_SEND_PRE &&nextstate==IDLE)
		reconfig_read_continue<=1;
	else if(state == CMD_SEND && nextstate==IDLE)
		reconfig_read_continue<=1;
	else
		reconfig_read_continue<=0;
end 



always@(posedge clk)
	fifo_rd_r<=fifo_rd;
	
always@(posedge clk)begin 
	if(rst)begin
		con_dout<=0;
		con_dout_en<=0;
	end 
	if(fifo_rd_r)begin
		con_dout<=fifo_dout;
		con_dout_en<=1;
	end
	else begin
		con_dout<=0;
		con_dout_en<=0;
	end 		
end 


cmd_send_fifo cmd_fifo (
	.clk(clk),
	.rst(rst),
	.din(fifo_din), // Bus [7 : 0] 
	.wr_en(fifo_wr),
	.rd_en(fifo_rd),
	.dout(fifo_dout), // Bus [7 : 0] 
	.full(),
	.empty(),
	.data_count(fifo_data_count));


endmodule
