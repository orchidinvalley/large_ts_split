`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:48:56 05/26/2009 
// Design Name: 
// Module Name:    ecm_ctrl 
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
module csa_ecm_ctrl(
		clk,
		rst,										
		con_din,
		con_addr,
		con_din_en,
		
		ecm_addr_dout,					
		ecm_addr_dout_en	,
		erro_flag
		);								 
							 
	input			clk, rst;
	input	[7:0]	con_din;
	input	[15:0]	con_addr;
	input			con_din_en;	
	                
	output			ecm_addr_dout_en;
	output	[35:0]	ecm_addr_dout;	 
	output	erro_flag;
	       
	reg				ecm_addr_dout_en;
	reg		[35:0]	ecm_addr_dout;		

		reg [3:0]cnt_reg,dif;
	
	                
	//assume work frequency.	                
	parameter       CHECK_PERIOD = 166666666/20;
	
	//共检测8家ca*32个频点*64个pid = 8192个pid
//	parameter       CHECK_TIMES = 8192;
	parameter       CHECK_TIMES = 65536*4;
	
	//要在50ms的时间内，处理完8192个pid. 每个pid占用的处理时间是CHECK_PERIOD/8192.
//parameter       AVERAGE_PERIOD = (CHECK_PERIOD>>13)-50;
	 parameter       AVERAGE_PERIOD = CHECK_PERIOD/CHECK_TIMES;
//	parameter       AVERAGE_PERIOD = (CHECK_PERIOD>>14);
	
	//高地址存储ecm包. 8388608 = 4家ca*32个频点*64个pid*4个包*256个字节.
//	parameter       NEXT_PACKET_ADDR = 8388608;
//parameter       NEXT_PACKET_ADDR = 8388608;
	//parameter       NEXT_PACKET_ADDR = 65536;//16777216;
	
	reg		[7:0]	clk_cnt;

	reg		[4:0]	freq_cnt;//32频点
	reg		[6:0]	pid_cnt;//128PID
	reg		[3:0]	cmp_cnt;//16家CA
	reg		[1:0]	addr_cnt;//ECM包计数
	
	
	reg				check_flag;
	reg				rd_flag;
	reg				wr_flag;
	
	reg		[3:0]	series_cnt;
	reg		[2:0]	piriod_cnt;
	
	reg		[11:0]	ecm_ram_din;
	reg		[7:0]	ecm_ram_din_r;
	reg				ecm_ram_wr;
	reg		[15:0]	ecm_ram_addr;
	reg		[15:0]	ecm_ram_addra,ecm_ram_addrb;
	wire	[11:0]	ecm_ram_dout;
	reg		[11:0]	ecm_ram_dout_r;
	
	
	reg		[3:0]	rd_cnt;
	reg		[3:0]	wr_cnt;
	reg		[2:0]	ecm_state;
    
    parameter		IDLE		= 3'b001,
    				WR_STATE	= 3'b010,
    				RD_STATE	= 3'b100;
	
	
	always @(posedge clk)
	begin
		if(clk_cnt == (AVERAGE_PERIOD - 1))
		begin
			clk_cnt	<= 0;
		end
		else
		begin
			clk_cnt	<=clk_cnt + 1;
		end
	end
	
	always @(posedge clk)
	begin
		if(clk_cnt == 0)
		begin
			check_flag	<= 1'b1;
		end
		else
		begin
			check_flag	<= 1'b0;
		end
	end
	
	always @(posedge clk)
	begin
		if(check_flag == 1'b1)
		begin
			pid_cnt	<= pid_cnt + 1;
		end
		else
		begin
			pid_cnt	<= pid_cnt;
		end
	end
	
	always @(posedge clk)
	begin
		if(check_flag == 1'b1 && pid_cnt == 0)
		begin
			addr_cnt	<= addr_cnt + 1;
		end
		else
		begin
			addr_cnt	<= addr_cnt;
		end
	end
	
	always @(posedge clk)
	begin
		if(check_flag == 1'b1 && pid_cnt == 0 && addr_cnt == 0)
		begin
			freq_cnt	<= freq_cnt + 1;
		end
		else
		begin
			freq_cnt	<= freq_cnt;
		end
	end
	
	always @(posedge clk)
	begin
		if(check_flag == 1'b1 && freq_cnt == 0 && pid_cnt == 0 && addr_cnt == 0)
		begin
			cmp_cnt	<= cmp_cnt + 1;
		end
		else
		begin
			cmp_cnt	<= cmp_cnt;
		end
	end
	
	always @(posedge clk)
	begin
		if(check_flag == 1'b1 && freq_cnt == 0 && pid_cnt == 0 && addr_cnt == 0 && cmp_cnt == 0)
		begin
			piriod_cnt	<= piriod_cnt + 1;
		end
		else
		begin
			piriod_cnt	<= piriod_cnt;
		end
	end
	
	always @(posedge clk)
	begin
		if(rd_flag == 1'b1)
		begin
			ecm_ram_addrb	<={freq_cnt,pid_cnt,cmp_cnt};
		end
		else
		begin
			ecm_ram_addrb	<= ecm_ram_addrb;
		end
	end
	
	always @(posedge clk)
	begin
		if(check_flag == 1'b1)
		begin
			rd_flag	<= 1'b1;
		end
		else if(rd_cnt == 4)
		begin
			rd_flag	<= 1'b0;
		end
		else
		begin
			rd_flag	<= rd_flag;
		end
	end
	
	always @(posedge clk)
    begin
    	if(ecm_state == RD_STATE)
    	begin
    		rd_cnt	<= rd_cnt + 1;
    	end
    	else
    	begin
    		rd_cnt	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(ecm_state == WR_STATE)
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
		if(rst)
		begin
			ecm_state	<= IDLE;
		end
		else
		begin
			case(ecm_state)
				IDLE:
					begin
						if(wr_flag)
						begin
							ecm_state	<= WR_STATE;
						end
						else if(rd_flag)
						begin
							ecm_state	<= RD_STATE;
						end
						else
						begin
							ecm_state	<= IDLE;
						end
					end
				WR_STATE:
					begin
						if(wr_cnt == 4)
						begin
							ecm_state	<= IDLE;
						end
						else
						begin
							ecm_state	<= WR_STATE;
						end
					end
				RD_STATE:
					begin
						if(wr_flag == 1'b1)
						begin
							ecm_state	<= WR_STATE;
						end
						else if(rd_cnt == 6)
						begin
							ecm_state	<= IDLE;
						end
						else
						begin
							ecm_state	<= RD_STATE;
						end
					end
				default:
					begin
						ecm_state	<= IDLE;
					end
			endcase
		end
	end
	
	always @(posedge clk)
	begin
		if(con_din_en == 1'b1)
		begin
			ecm_ram_din_r	<= con_din;
			ecm_ram_addra	<= con_addr;
			wr_flag	<= 1'b1;
		end
		else
		begin
			ecm_ram_din_r	<= ecm_ram_din_r;
			ecm_ram_addra	<= ecm_ram_addra;
			wr_flag	<= 1'b0;
		end
	end
	
	always @(posedge clk)
    begin
    	ecm_ram_dout_r	<= ecm_ram_dout;
    end
    
    always @(posedge clk)
    begin
    	if(ecm_state == RD_STATE && rd_cnt == 4)
    	begin
    		if(ecm_ram_dout_r[2:0] > addr_cnt)
    		begin
    			if(ecm_ram_dout_r[4] == 1'b1)
    			begin
    				ecm_addr_dout_en	<= 1'b1;
    			end
    			else if(ecm_ram_dout_r[5] == 1'b1 && piriod_cnt[0] == 1'b0)
    			begin
    				ecm_addr_dout_en	<= 1'b1;
    			end
    			else if(ecm_ram_dout_r[6] == 1'b1 && piriod_cnt[1:0] == 2'b00)
    			begin
    				ecm_addr_dout_en	<= 1'b1;
    			end
    			else if(ecm_ram_dout_r[7] == 1'b1 && piriod_cnt == 0)
    			begin
    				ecm_addr_dout_en	<= 1'b1;
    			end
    			else
    			begin
    				ecm_addr_dout_en	<= 1'b0;
    			end
    		end
    		else
    		begin
    			ecm_addr_dout_en	<= 1'b0;
    		end
    	end
    	else
    	begin
    		ecm_addr_dout_en	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(ecm_state == RD_STATE && rd_cnt == 4)
    	begin
    		ecm_addr_dout	<= {ecm_ram_dout_r[11:8],1'b1,4'b0010,ecm_ram_addr,ecm_ram_dout_r[3],addr_cnt[1:0],8'b0};
    	end
    	else
    	begin
    		ecm_addr_dout	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(ecm_state == RD_STATE)
    	begin
    		if(rd_cnt == 5)
    		begin
    			if(ecm_addr_dout_en)
    			begin
    				series_cnt	<= ecm_ram_dout_r[11:8] + 1;
    			end
    			else
    			begin
    				series_cnt	<= ecm_ram_dout_r[11:8];
    			end
    		end
    		else
    		begin
    			series_cnt	<= 0;
    		end
    	end
    	else
    	begin
    		series_cnt	<= 0;
    	end
    end
    
	
	always@(posedge clk)begin
		if(rd_cnt==5&&ecm_addr_dout_en)
			cnt_reg<=ecm_ram_dout_r[11:8];
		else
			cnt_reg<=cnt_reg;
	end
	always@(posedge clk)begin
		if(rd_cnt==6)
			dif<=series_cnt-cnt_reg;
		else
			dif<=dif;
	end
	
	assign erro_flag=((rd_cnt==6)&&(dif !=1))?1:0;
	
	
	
	
    always @(posedge clk)
    begin
    	if(rd_cnt == 6)
    	begin
    		ecm_ram_din	<= {series_cnt,ecm_ram_dout_r[7:0]};
    		ecm_ram_wr	<= 1'b1;
    	end
    	else if(wr_cnt == 4)
    	begin
    		ecm_ram_din	<= {ecm_ram_dout_r[11:8],ecm_ram_din_r};
    		ecm_ram_wr	<= 1'b1;
    	end
    	else
    	begin
    		ecm_ram_din	<= 0;
    		ecm_ram_wr	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(ecm_state == RD_STATE)
    	begin
    		ecm_ram_addr	<= ecm_ram_addrb;
    	end
    	else if(ecm_state == WR_STATE)
    	begin
    		ecm_ram_addr	<= ecm_ram_addra;
    	end
    	else
    	begin
    		ecm_ram_addr	<= 0;
    	end
    end
    
    csa_ecm_ram	ecm_ram(
		.clka			(clk),
		.dina			(ecm_ram_din),
		.addra			(ecm_ram_addr),
		.wea			(ecm_ram_wr),
		.clkb			(clk),
		.addrb			(ecm_ram_addr),
		.doutb          (ecm_ram_dout)
		);
	
endmodule
