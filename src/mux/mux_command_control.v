`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:09:23 05/28/2010 
// Design Name: 
// Module Name:    mux_command_control 
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
module mux_command_control(

	clk,
	rst,
	
	con_din,
	con_din_en,
	
	si_read_dout,
	si_read_dout_en,
	ip_con_dout,
	ip_con_dout_en,
	pid_con_dout,
	pid_con_dout_en,
	si_con_dout,
	si_con_dout_en,
	rate_con_dout,
	rate_con_dout_en,
	rateout_con_dout,
	rateout_con_dout_en,

	tab_con_dout,
	tab_con_dout_en ,
	
	rd_tem_sta_dout	,
	rd_tem_sta_dout_en
    );
    
    input			clk;
    input			rst;
    
    input	[7:0]	con_din;				//输入配置信息
    input			con_din_en;				//输入使能信号，高电平有效
    
    output	[7:0]	si_read_dout;			//获取输入的SI信息的配置命令
    output			si_read_dout_en;		//命令有效信号
    output	[7:0]	ip_con_dout;
    output			ip_con_dout_en;
    output	[7:0]	pid_con_dout;			//配置复用的PID信息
    output			pid_con_dout_en;
    output	[7:0]	si_con_dout;			//配置SI信息表
    output			si_con_dout_en;
    output	[7:0]	rate_con_dout;
    output			rate_con_dout_en;
    output	[7:0]	rateout_con_dout;
    output			rateout_con_dout_en;

    output	[7:0]	tab_con_dout;
    output			tab_con_dout_en;
    
    output	[7:0]	rd_tem_sta_dout ;
    output  		rd_tem_sta_dout_en ;
    
    reg		[7:0]	si_read_dout;
    reg				si_read_dout_en;
    reg		[7:0]	ip_con_dout;
    reg				ip_con_dout_en;
    reg		[7:0]	pid_con_dout;
    reg				pid_con_dout_en;
    reg		[7:0]	si_con_dout;
    reg				si_con_dout_en;
    reg		[7:0]	tab_con_dout;
    reg				tab_con_dout_en;
    reg		[7:0]	rate_con_dout;
    reg				rate_con_dout_en;
    reg		[7:0]	rateout_con_dout;
    reg				rateout_con_dout_en;
    
    reg		[7:0]	rd_tem_sta_dout ;
    reg  			rd_tem_sta_dout_en ;
   
    
  
    
    reg		[15:0]	con_cnt;			//the counter of con_din_en
    
    reg		[3:0]	con_state;
    
    parameter		IDLE		= 4'd0 ,//11'b00000000001,
    				SI_READ		= 4'd1 ,//11'b00000000010,
    				MUX_CON		= 4'd2 ,//11'b00000000100,
    				SI_CON		= 4'd3 ,//11'b00000001000,
    				PID_CON		= 4'd4 ,//11'b00000010000,
    				IP_CON		= 4'd5 ,//11'b00000100000,

    				RATE_CON	= 4'd6 ,//11'b00010000000,
    				RATE_OUT	= 4'd7 ,//11'b00100000000,
    				READ_CON	= 4'd8 ,//11'b01000000000,
    				TAB_CON		= 4'd9 , //11'b10000000000;
    				RD_TEM_STA = 4'd10 ;
    
    
    
    
    always @(posedge clk)
    begin
    	if(con_din_en)
    	begin
    		con_cnt	<= con_cnt + 16'b1;
    	end
    	else
    	begin
    		con_cnt	<= 0;
    	end
    end
    
    
    always @(posedge clk)
    begin
    	if(rst)
    	begin
    		con_state	<= IDLE;
    	end
    	else
    	begin
    		case(con_state)
    			IDLE:
    				begin
    					if(con_din_en == 1'b1 && con_cnt == 0)
    					begin
    						if(con_din == 8'h04)
    						begin
    							con_state	<= READ_CON;
    						end
    						else if(con_din == 8'h40)
    						begin
    							con_state	<= MUX_CON;
    						end
    					end
    					else
    					begin
    						con_state	<= IDLE;
    					end
    				end
    			READ_CON:
    				begin
    					if(con_din == 8'h01)
    					begin
    						con_state	<= SI_READ;
    					end
    					else if(con_din == 8'h09)
    					begin
    						con_state	<= RATE_CON;
    					end
    					else if(con_din == 8'h0A)
    					begin
    						con_state	<= RATE_OUT;
    					end
    					else if(con_din == 8'hf1)
    					begin
    						con_state  <= RD_TEM_STA;
    					end
    					
    					else
    					begin
    						con_state	<= IDLE;
    					end
    				end
    			SI_READ:
    				begin
    					if(con_din_en == 1'b0)
    					begin
    						con_state	<= IDLE;
    					end
    					else
    					begin
    						con_state	<= SI_READ;
    					end
    				end
    			MUX_CON:
    				begin
    					if(con_din == 8'h02)
    					begin
    						con_state	<= SI_CON;
    					end
    					else if(con_din == 8'h03)
    					begin
    						con_state	<= IP_CON;
    					end
    					else if(con_din == 8'h04)
    					begin
    						con_state	<= PID_CON;
    					end    				
    					else if(con_din == 8'h06)
    					begin
    						con_state	<= TAB_CON;
    					end
    					else
    					begin
    						con_state	<= IDLE;
    					end
    				end
    			SI_CON:
    				begin
    					if(con_din_en == 1'b0)
    					begin
    						con_state	<= IDLE;
    					end
    					else
    					begin
    						con_state	<= SI_CON;
    					end
    				end
    			IP_CON:
    				begin
    					if(con_din_en == 1'b0)
    					begin
    						con_state	<= IDLE;
    					end
    					else
    					begin
    						con_state	<= IP_CON;
    					end
    				end
    			PID_CON:
    				begin
    					if(con_din_en == 1'b0)
    					begin
    						con_state	<= IDLE;
    					end
    					else
    					begin
    						con_state	<= PID_CON;
    					end
    				end
    			RATE_CON:
    				begin
    					if(con_din_en == 1'b0)
    					begin
    						con_state	<= IDLE;
    					end
    					else
    					begin
    						con_state	<= RATE_CON;
    					end
    				end
    			RATE_OUT:
    				begin
    					if(con_din_en == 1'b0)
    					begin
    						con_state	<= IDLE;
    					end
    					else
    					begin
    						con_state	<= RATE_OUT;
    					end
    				end    		
    			TAB_CON:
    				begin	
    					if(con_din_en == 1'b0)
    					begin
    						con_state	<= IDLE;
    					end
    					else
    					begin
    						con_state	<= TAB_CON;
    					end
    				end 
    			RD_TEM_STA:
    				begin
    					if(con_din_en == 1'b0)
    					begin
    						con_state	<= IDLE;
    					end
    					else
    					begin
    						con_state	<= RD_TEM_STA;
    					end    				
    				end
    				
    			default:
    				begin
    					con_state	<= IDLE;
    				end
    		endcase
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_state == SI_READ)
    	begin
    		si_read_dout	<= con_din;
    		si_read_dout_en	<= con_din_en;
    	end
    	else
    	begin
    		si_read_dout	<= 0;
    		si_read_dout_en	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_state == IP_CON)
    	begin
    		ip_con_dout	<= con_din;
    		ip_con_dout_en	<= con_din_en;
    	end
    	else
    	begin
    		ip_con_dout	<= 0;
    		ip_con_dout_en	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_state == PID_CON)
    	begin
    		pid_con_dout	<= con_din;
    		pid_con_dout_en	<= con_din_en;
    	end
    	else
    	begin
    		pid_con_dout	<= 0;
    		pid_con_dout_en	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_state == SI_CON)
    	begin
    		si_con_dout	<= con_din;
    		si_con_dout_en	<= con_din_en;
    	end
    	else
    	begin
    		si_con_dout	<= 0;
    		si_con_dout_en	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_state == RATE_CON)
    	begin
    		rate_con_dout	<= con_din;
    		rate_con_dout_en	<= con_din_en;
    	end
    	else
    	begin
    		rate_con_dout	<= 0;
    		rate_con_dout_en	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_state == RATE_OUT)
    	begin
    		rateout_con_dout	<= con_din;
    		rateout_con_dout_en	<= con_din_en;
    	end
    	else
    	begin
    		rateout_con_dout	<= 0;
    		rateout_con_dout_en	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_state == TAB_CON)
    	begin
    		tab_con_dout	<= con_din;
    		tab_con_dout_en	<= con_din_en;
    	end
    	else
    	begin
    		tab_con_dout	<= 0;
    		tab_con_dout_en	<= 0;
    	end
    end
    
    always @ (posedge clk)
    begin
    	if(con_state == RD_TEM_STA)
    	begin
    		rd_tem_sta_dout	   <= con_din ;
    		rd_tem_sta_dout_en <= con_din_en ;
    	end
    	else
    	begin
    		rd_tem_sta_dout	   <= 0 ;
    		rd_tem_sta_dout_en <= 0 ;
    	end
    end


endmodule
