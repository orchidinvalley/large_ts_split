`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:31:46 05/24/2011 
// Design Name: 
// Module Name:    ts_cut_head 
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
module ts_cut_head(
	clk,
	rst,
	
	ts_din_en,
	ts_din,
	
	ts_dout,
	ts_dout_en

    );

input	clk;
input	rst;
	
input	ts_din_en;
input	[31:0]ts_din;
	
output	[31:0]ts_dout;
output	ts_dout_en;
	
reg	[31:0]ts_dout;
reg	ts_dout_en;
////////////////////////////////////////
//reg [5:0]ts_cnt;

    reg ts_din_en_r;
    
    always @ (posedge clk)
    begin
        ts_din_en_r <= ts_din_en;
    end
    
    always @ (posedge clk)
    begin
        ts_dout <= ts_din;
        ts_dout_en <= ts_din_en_r && ts_din_en;
    end


//always@(posedge clk)begin
//	if(rst)
//		ts_cnt<=0;
//	else
//		if(ts_din_en)
//			ts_cnt<=ts_cnt+1;
//		else
//			ts_cnt<=0;
//end

//always@(posedge clk)begin
//	if(rst)begin
//		ts_dout<=0;
//		ts_dout_en<=0;
//	end
//	else 
//	if(ts_cnt==1)begin
//		ts_dout<=ts_din;
//		ts_dout_en<=ts_din_en;
//	end
//	else 
//	if(ts_cnt>1)begin
//		ts_dout<=ts_din;
//		ts_dout_en<=ts_din_en;
//	end
//	else begin
//		ts_dout<=0;
//		ts_dout_en<=0;
//	end
//	
//end



endmodule
