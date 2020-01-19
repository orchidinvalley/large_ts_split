`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:05:41 05/23/2011 
// Design Name: 
// Module Name:    ts_8to32 
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
module ts_8to64(
	clk_main,
	rst,
	
	ts_din,
	ts_din_en,
	
	ts_dout,
	ts_dout_en
    );
    

input clk_main;
input	rst;	
input	[8:0]ts_din;
input	ts_din_en;
	
output	[32:0]ts_dout;
output	ts_dout_en;

reg ts_din_en_r;
reg [7:0]ts_din_r,ts_din_r1,ts_din_r2,ts_din_r3,ts_din_r4,ts_din_r5,ts_din_r6,ts_din_r7;


reg	[32:0]ts_dout;
reg	ts_dout_en;

reg	[64:0]fifo_din;
reg	wr_en;


reg [1:0]rd_cnt;
reg [7:0]ts_cnt;

always@(posedge clk_main)begin
	if(rst)
		ts_cnt<=0;
	else if(ts_din_en)begin
			if(ts_din[8])
				ts_cnt<=0;
			else
			ts_cnt<=ts_cnt+1;
	end
	else
		ts_cnt<=ts_cnt;
end


always@(posedge clk_main)begin
	if(rst)
	rd_cnt<=0;
	else if(ts_din_en)begin
		if(ts_cnt>9)
			rd_cnt<=rd_cnt+1;
		else
			rd_cnt<=0;
	end
	else
		rd_cnt<=rd_cnt;
end

always@(posedge clk_main)begin
	if(rst)
		ts_din_en_r<=0;
	else
		ts_din_en_r<=ts_din_en;
end

always@(posedge clk_main)begin 
if(rst)begin	
	ts_din_r<=0;
	ts_din_r1<=0;
	ts_din_r2<=0;
	ts_din_r3<=0;
	ts_din_r4<=0;
	ts_din_r5<=0;
	ts_din_r6<=0;
	ts_din_r7<=0;
end
else 
	if(ts_din_en)begin	
	ts_din_r<=ts_din[7:0];
	ts_din_r1<=ts_din_r;
	ts_din_r2<=ts_din_r1;
	ts_din_r3<=ts_din_r2;
	ts_din_r4<=ts_din_r3;
	ts_din_r5<=ts_din_r4;
	ts_din_r6<=ts_din_r5;
	ts_din_r7<=ts_din_r6;
	end
	else begin
	ts_din_r<=ts_din_r;
	ts_din_r1<=ts_din_r1;
	ts_din_r2<=ts_din_r2;
	ts_din_r3<=ts_din_r3;
	ts_din_r4<=ts_din_r4;
	ts_din_r5<=ts_din_r5;
	ts_din_r6<=ts_din_r6;
	ts_din_r7<=ts_din_r7;
	end
end

always@(posedge clk_main)begin
	if(rst)begin
		ts_dout<=0;
		ts_dout_en<=0;
	end
	else if(ts_din_en_r)
	begin
		if(ts_cnt==0)
		begin
		ts_dout_en<=1;
		ts_dout<={1'b1,24'b0,ts_din_r};//�����
		end 
		else if(ts_cnt==2)
		begin
		ts_dout_en<=1;
		ts_dout<={1'b0,16'b0,ts_din_r1,ts_din_r};//PID���
		end
		else if(ts_cnt==3)
		begin
		ts_dout_en<=1;
		ts_dout<={1'b0,24'b0,ts_din_r};//gbe���
		end
		else if(ts_cnt==7)
		begin
		ts_dout_en<=1;
		ts_dout<={1'b0,ts_din_r3,ts_din_r2,ts_din_r1,ts_din_r};//ip	
		end
		else if(ts_cnt==9)
		begin
		ts_dout_en<=1;
		ts_dout<={1'b0,16'b0,ts_din_r1,ts_din_r};//PORT
		end
		else if(ts_cnt>9 && ts_cnt<198)
		begin
		if(rd_cnt==3)
		begin
			ts_dout_en<=1;
			ts_dout<={1'b0,ts_din_r3,ts_din_r2,ts_din_r1,ts_din_r};
		end
		else begin
			ts_dout<=0;
			ts_dout_en<=0;
		end
		end
//		else if(ts_cnt==197)
//	begin
//	ts_dout_en<=1;
//	ts_dout<={1'b0,ts_din_r3,ts_din_r2,ts_din_r1,ts_din_r,32'h0};
//	end
		else begin
			ts_dout<=0;
			ts_dout_en<=0;
		end
	end	
	else begin
		ts_dout<=0;
		ts_dout_en<=0;
	end
end


//reg 	cstate;
//reg 	nstate;
//reg 	[4:0]rd_ts_cnt;
//wire prog_full;
//wire  empty;
//reg rd_en;
//wire [64:0]fifo_dout;
//
//parameter IDLE =0,
//				READ_DATA=1;
//				
//always@(posedge clk_main)
//begin
//if(rst)
//cstate<=IDLE;
//else
//cstate<=nstate;
//end
//
//
//always@(cstate or prog_full  or empty or rd_ts_cnt )
//begin
//case(cstate)
//IDLE:
//	if(prog_full && !empty)
//	nstate	=READ_DATA;
//	else
//	nstate	=IDLE;
//READ_DATA:
//	if(rd_ts_cnt==31)
//	nstate	=IDLE;
//	else 
//	nstate	=READ_DATA;
//default:
//	nstate	=IDLE;
//endcase
//end
//
//
//always@(posedge clk_main)
//begin
//if(rst)
//rd_en<=0;
//else if(nstate==READ_DATA && rd_ts_cnt <26)
//rd_en<=1;
//else 
//rd_en<=0;
//end
//
//
//always@(posedge clk_main)
//begin
//if(rst)
//begin
//ts_dout<=0;
//ts_dout_en<=0;
//end
//else if(cstate==READ_DATA && rd_ts_cnt >0 && rd_ts_cnt <28)
//begin
//ts_dout<=fifo_dout;
//ts_dout_en<=1;
//end
//else 
//begin
//ts_dout<=0;
//ts_dout_en<=0;
//end
//end
//
//always @(posedge clk_main)
//begin
//if(rst)
//rd_ts_cnt<=0;
//else if(cstate==READ_DATA)
//rd_ts_cnt<=rd_ts_cnt+1;
//else 
//rd_ts_cnt<=0;
//end
//
//
//fifo_ts_8_64 fifo_ts (
//	.rst(rst),
//	.wr_clk(clk_main),
//	.rd_clk(clk_main),
//	.din(fifo_din), // Bus [64 : 0] 
//	.wr_en(wr_en),
//	.rd_en(rd_en),
//	.dout(fifo_dout), // Bus [64 : 0] 
//	.full(),
//	.empty(empty),
//	.prog_full(prog_full));


endmodule
