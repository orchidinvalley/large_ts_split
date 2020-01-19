`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:39:30 06/25/2010 
// Design Name: 
// Module Name:    ts_out_monitor 
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
module ts_out_monitor(

	clk,
	rst,
	
	ts_din,
	ts_din_en,
	
	rate_dout,
	rate_dout_en
    );
    
    input			clk;
    input			rst;
    
    input	[31:0]	ts_din;
    input			ts_din_en;
    
    output	[15:0]	rate_dout;
    output			rate_dout_en;
    
    reg		[7:0]	ts_cnt;
    
    reg		[15:0]	rate_dout;
    reg				rate_dout_en;
    
//    reg		[3:0]	rate_state;
    reg     [2:0]   rate_state;
    
    reg		[11:0]	wr_cnt;
    
    reg		[15:0]	rate_ram_din;
    reg				rate_ram_wr;
    reg		[11:0]	rate_ram_addra,rate_ram_addrb;
    wire	[15:0]	rate_ram_dout;
    reg		[11:0]	rate_ram_addr;
    
    
    reg		[27:0]	clk_cnt;
    reg				rd_flag;
    
//    parameter		IDLES	= 4'b0001,
//    				RATE_WR	= 4'b0010,
//    				RATE_RD	= 4'b1000;
    parameter IDLES = 3'b001,
              RATE_WR = 3'b010,
              RATE_RD = 3'b100;
    				
    				
    always @(posedge clk)
    begin
    	if(ts_din_en)
    	begin
    		ts_cnt	<= ts_cnt + 1;
    	end
    	else
    	begin
    		ts_cnt	<= 0;
    	end
    end
    				
//    always @(posedge clk)//167Mʱ�ӣ�����1s��ʱ��
//	begin
//		if(clk_cnt == 166666666)
//		begin
//			clk_cnt	<= 0;
//		end
//		else
//		begin
//			clk_cnt	<= clk_cnt + 1;
//		end
//	end
    always @ (posedge clk)//156.25Mʱ�ӣ�����1���ʱ��
    begin
        if(clk_cnt == 28'd125000000)
            clk_cnt <= 28'd0;
        else
            clk_cnt <= clk_cnt + 28'd1;
    end
	
	always @(posedge clk)
	begin
		if(clk_cnt == 1)
		begin
			rd_flag	<= 1'b1;
		end
		else if(rate_state == RATE_RD)
		begin
			rd_flag	<= 1'b0;
		end
		else
		begin
			rd_flag	<= rd_flag;
		end
	end
		
	always @(posedge clk)//PID��Ӧ��port�ţ���PID��Ӧ�Ĵ���RAM�ĵ�ַ
	begin
		if(ts_cnt == 0 && ts_din_en)
		begin
			rate_ram_addr 	<= ts_din[11:0];
		end		
		else
		begin
			rate_ram_addr	<= rate_ram_addr;
		end
	end
	
	
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			rate_state	<= IDLES;
		end
		else
		begin
			case(rate_state)
				IDLES:
					begin
						if(ts_cnt == 5)
						begin
							rate_state	<= RATE_WR;
						end
						else if(rd_flag)
						begin
							rate_state	<= RATE_RD;
						end
						else
						begin
							rate_state	<= IDLES;
						end
					end
				RATE_WR:
					begin
						if(wr_cnt == 5)
						begin
							rate_state	<= IDLES;
						end
						else
						begin
							rate_state	<= RATE_WR;
						end
					end
				RATE_RD:
					begin
						if(wr_cnt == 4094)
						begin
							rate_state	<= IDLES;
						end
						else
						begin
							rate_state	<= RATE_RD;
						end
					end
				default:
					begin
						rate_state	<= IDLES;
					end
			endcase
		end
	end
	
	always @(posedge clk)
	begin
		if(rate_state == RATE_WR || rate_state == RATE_RD)
		begin
			wr_cnt	<= wr_cnt + 1;
		end
		else
		begin
			wr_cnt	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(rate_state == RATE_WR)
		begin
			rate_ram_addrb	<= rate_ram_addr;
		end
		else if(rate_state == RATE_RD)
		begin		
			rate_ram_addrb	<= wr_cnt;		
		end
		else
		begin
			rate_ram_addrb	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(rate_state == RATE_WR)
		begin
			rate_ram_addra	<= rate_ram_addr;
		end
		else if(rate_state == RATE_RD)
		begin
		if(wr_cnt==0)
			rate_ram_addra	<= wr_cnt;
		else 
			rate_ram_addra	<= wr_cnt-1;
		end
		else
		begin
			rate_ram_addra	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(rate_state == RATE_WR && wr_cnt == 4)
		begin
			rate_ram_din	<= rate_ram_dout + 1;
			rate_ram_wr		<= 1'b1;
		end
		else if(rate_state == RATE_RD)
		begin
			rate_ram_din	<= 0;
			rate_ram_wr		<= 1'b1;
		end
		else
		begin
			rate_ram_din	<= 0;
			rate_ram_wr		<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(rate_state == RATE_RD)
		begin
			if(wr_cnt > 1)
			begin
				rate_dout	<= rate_ram_dout;
				rate_dout_en	<= 1'b1;
			end
			else
			begin
				rate_dout	<= 0;
				rate_dout_en	<= 0;
			end
		end
		else
		begin
			rate_dout	<= 0;
			rate_dout_en	<= 0;
		end
	end
	
	rate_ram	rate_ram(
		.clka				(clk),
		.wea				(rate_ram_wr),
		.addra				(rate_ram_addra),
		.dina				(rate_ram_din),
		.clkb				(clk),
		.addrb				(rate_ram_addrb),
		.doutb              (rate_ram_dout)
		);



endmodule