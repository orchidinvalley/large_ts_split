`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:03:25 08/15/2011 
// Design Name: 
// Module Name:    version_detect 
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
module version_detect(
	
	clk,
	rst,
	
	con_din,
	con_din_en,
	
	//mcu_rx,
	
	con_dout,
	con_dout_en

    );
	
	
	
input	clk;
input	rst;

	
input	[7:0]con_din;
input	con_din_en;
	
output	[7:0]con_dout;
output	con_dout_en;

reg	[7:0]con_dout;
reg	con_dout_en;



reg [10:0]con_cnt;

reg [7:0]con_din_r,con_din_rr;
reg	con_din_en_r,con_din_en_rr;
reg [8:0]con_cnt_r,con_cnt_rr;




reg ack_flag;


/////////////////////////////////////////Íø¹ÜÓ¦´ð////////////////////////////////


always@(posedge clk)begin
	con_din_r<=con_din;
	con_din_en_r<=con_din_en;
	con_cnt_r<=con_cnt;
	con_din_rr<=con_din_r;
	con_din_en_rr<=con_din_en_r;
	con_cnt_rr<=con_cnt_r;
end

always@(posedge clk)begin
	if(rst)
		con_cnt<=0;
	else if(con_din_en)
		con_cnt<=con_cnt+11'b1;
	else
		con_cnt<=0;
end



always@(posedge clk)begin
	if(rst)
		ack_flag<=0;
	else if(con_cnt==1)begin
		if((con_din_r==8'h04)&&(con_din==8'h21))
			ack_flag<=1;
		else
			ack_flag<=0;
	end
	else 
		ack_flag<=ack_flag;
end


always@(posedge clk)begin
	if(rst)begin
		con_dout_en<=0;
		con_dout<=0;
	end
	else if(con_din_en_rr&&ack_flag)begin
		if(con_cnt_rr<12)begin
			con_dout_en<=1;
			con_dout<=con_din_rr;
		end
		else if(con_cnt_rr==12)begin
			con_dout_en<=1;
			con_dout<=8'haa;
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
