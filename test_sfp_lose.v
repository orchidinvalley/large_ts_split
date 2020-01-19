`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:40:06 03/19/2015 
// Design Name: 
// Module Name:    test_sfp_lose 
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
module test_sfp_lose(
input  	clk,
input	[7:0]		data_in		,
input				data_in_en	,
output 	flag

    );

	reg		[5:0]		ip_head_cnt	;
	reg		[7:0]		ts_cnt		;
	
	reg		[3:0]		cc_reg1_mux	;
	reg		[3:0]		cc_dif1_mux	;
	
	reg		[8:0]		data_in_r1	;
	reg		[8:0]		data_in_r2	;
	reg		[8:0]		data_in_r3	;
	
	always @ (posedge clk)
	begin
		data_in_r1	<=	data_in		;
		data_in_r2	<=	data_in_r1	;
		data_in_r3	<=	data_in_r2	;
	end
	
	always @ (posedge clk)
	begin
		if(data_in_en)	
		begin	
			if(ip_head_cnt >6'd5)
				ip_head_cnt <= ip_head_cnt;
			else
				ip_head_cnt <= ip_head_cnt + 1;
		end
		else
		ip_head_cnt <= 6'd0;
	end
	
	always @ (posedge clk)
	begin
		if(ip_head_cnt >6'd5)
		begin
			if(ts_cnt == 8'd187)
				ts_cnt <= 0;
			else
				ts_cnt <= ts_cnt + 1;	
		end
		else
			ts_cnt <= 0;		
	end


	always@(posedge clk)
	begin
		if(ts_cnt == 3 && data_in_r3 == 8'h47 && {data_in_r2[4:0],data_in_r1[7:0]} == 13'h1386 && data_in[4])
		begin
			cc_reg1_mux	<=	data_in[3:0];
			cc_dif1_mux	<=	data_in[3:0] - cc_reg1_mux;
		end
		else
		begin
			cc_reg1_mux	 <= cc_reg1_mux;
			cc_dif1_mux  <= cc_dif1_mux;
		end
	end
	
	assign  flag = (cc_dif1_mux == 0)?1'b1:1'b0;
endmodule
