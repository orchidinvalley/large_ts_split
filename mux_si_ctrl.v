`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:31:22 03/23/2009 
// Design Name: 
// Module Name:    mux_si_ctrl 
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
module mux_si_ctrl(

	clk,
	rst,
	
	con_din,
	con_din_en,
	con_din_tab,
	con_din_tab_en,
	
	si_ddr_dout,
	si_ddr_dout_en,	// 要存储到ddr的表的ts包；
	si_addr_dout,
	si_addr_dout_en
    );
    
    input			clk;
    input			rst;
    
    input	[7:0]	con_din;
    input			con_din_en;
    input	[7:0]	con_din_tab;
    input			con_din_tab_en;
    
    output	[7:0]	si_ddr_dout;
    output			si_ddr_dout_en;
    output	[35:0]	si_addr_dout;
    output			si_addr_dout_en;
    
    reg		[7:0]	si_ddr_dout;
    reg				si_ddr_dout_en;
    reg		[35:0]	si_addr_dout;
    reg				si_addr_dout_en;
    
    
    reg		[15:0]	con_cnt;
    reg		[3:0]	tab_cnt;
    
//    reg		[7:0]	con_clk_cnt;
    
    reg		[15:0]	si_bandwidth;
    reg		[15:0]	band_cnt;
    reg		[5:0]	clk_cnt;
    
    reg		[9:0]	send_cnt;
    reg		[3:0]	addr_cnt;
    reg		[3:0]	series_cnt;
    
    reg				wr_flag;
    reg				rd_flag;
    
    reg		[3:0]	si_ram_din_r;
    reg		[9:0]	si_ram_addra_r;
    
    reg		[9:0]	si_ram_addr;
    reg				si_ram_wr;
    reg		[7:0]	si_ram_din;
    wire	[7:0]	si_ram_dout;
    reg		[7:0]	si_ram_dout_r;
    
    reg		[3:0]	wr_cnt;
    reg		[3:0]	rd_cnt;
    reg				wr_nerase_flag	;
    
    reg		[2:0]	si_state;
    
    parameter		IDLE		= 3'b001,
    				WR_STATE	= 3'b010,
    				RD_STATE	= 3'b100;
    
    
    always @(posedge clk)
    begin
    	if(con_din_en)
    	begin
    		con_cnt	<= con_cnt + 1;
    	end
    	else
    	begin
    		con_cnt	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_din_tab_en)
    	begin
    		tab_cnt	<= tab_cnt + 1;
    	end
    	else
    	begin
    		tab_cnt	<= 0;
    	end
    end
//    
//    always @(posedge clk)
//    begin
//    	if(con_cnt > 10)
//    	begin
//    		if(con_clk_cnt == 200)
//    		begin
//    			con_clk_cnt	<= 0;
//    		end
//    		else
//    		begin
//    			con_clk_cnt	<= con_clk_cnt + 1;
//    		end
//    	end
//    	else
//    	begin
//    		con_clk_cnt	<= 0;
//    	end
//    end
    
    always @(posedge clk)
    begin
    	if(con_cnt > 10)
    	begin
    		si_ddr_dout	<= con_din;
    		si_ddr_dout_en	<= con_din_en & wr_nerase_flag;
    	end
    	else
    	begin
    		si_ddr_dout	<= 0;
    		si_ddr_dout_en	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_cnt == 8)
    	begin
    		si_ram_addra_r[9:8]	<= con_din[1:0];
    	end
    	else if(con_cnt == 9)
    	begin
    		si_ram_addra_r[7:0]	<= con_din;
    	end
		else
		begin
			si_ram_addra_r	<= si_ram_addra_r;
		end
    end
    
    always @(posedge clk)
    begin
    	if(con_cnt == 10)
    	begin
    		si_ram_din_r	<= con_din[3:0];
    		wr_flag		<= 1'b1;
    	end
    	else
    	begin
    		si_ram_din_r	<= si_ram_din_r;
    		wr_flag	<= 1'b0;
    	end
    end    
    
    always @(posedge clk)
    begin    	
    	if(con_din_en)
    	begin
    		if(con_cnt == 10)	
    		begin
    			if(con_din[3:0] == 0)	
    				wr_nerase_flag <= 0;
    			else
    				wr_nerase_flag <= 1;
    		end
    		else
    			wr_nerase_flag <= wr_nerase_flag;    			
    	end
    	else
    		wr_nerase_flag <= 0;
    end    
    
    always @(posedge clk)
    begin
    	if(rst)
    	begin
    		si_bandwidth	<= 40;
    	end
    	else if(tab_cnt == 6)
    	begin
    		si_bandwidth[15:8]	<= con_din_tab;
    	end
    	else if(tab_cnt == 7)
    	begin
    		si_bandwidth[7:0]	<= con_din_tab;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(si_state == RD_STATE)
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
    	if(si_state == WR_STATE)
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
    		si_state	<= IDLE;
    	end
    	else
    	begin
    		case(si_state)
    			IDLE:
    				begin
    					if(wr_flag == 1'b1)
    					begin
    						si_state	<= WR_STATE;
    					end
    					else if(rd_flag == 1'b1)
    					begin
    						si_state	<= RD_STATE;
    					end
    					else
    					begin
    						si_state	<= IDLE;
    					end
    				end
    			WR_STATE:
    				begin
    					if(wr_cnt == 4)
    					begin
    						si_state	<= IDLE;
    					end
    					else
    					begin
    						si_state	<= WR_STATE;
    					end
    				end
    			RD_STATE:
    				begin
    					if(wr_flag == 1'b1)
    					begin
    						si_state	<= WR_STATE;
    					end
    					else if(rd_cnt == 6)
    					begin
    						si_state	<= IDLE;
    					end
    					else
    					begin
    						si_state	<= RD_STATE;
    					end
    				end
    			default:
    				begin
    					si_state	<= IDLE;
    				end
    		endcase
    	end
    end
    
    always @(posedge clk)
    begin
    	if(clk_cnt == 50)
    	begin
    		clk_cnt	<= 0;
    	end
    	else if(band_cnt == si_bandwidth)
    	begin
    		clk_cnt	<= clk_cnt + 1;
    	end
    	else
    	begin
    		clk_cnt	<= clk_cnt;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(band_cnt == si_bandwidth)
    	begin
    		band_cnt	<= 0;
    	end
    	else
    	begin
    		band_cnt	<= band_cnt + 1;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(rst)
    	begin
    		send_cnt	<= 0;
    		rd_flag		<= 0;
    	end
    	else if(clk_cnt == 50)
    	begin
    		send_cnt	<= send_cnt + 1;
    		rd_flag		<= 1;
    	end
    	else
    	begin
    		send_cnt	<= send_cnt;
    		rd_flag		<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(rst)
    	begin
    		addr_cnt	<= 0;
    	end
    	else if(clk_cnt == 50 && send_cnt == 1)
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
    	if(si_state == RD_STATE)
    	begin
    		si_ram_addr	<= send_cnt;
    	end
    	else if(si_state == WR_STATE)
    	begin
    		si_ram_addr	<= si_ram_addra_r;
    	end
    	else
    	begin
    		si_ram_addr	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	si_ram_dout_r	<= si_ram_dout;
    end
    
    always @(posedge clk)
    begin
    	if(si_state == RD_STATE)
    	begin
    		if(rd_cnt == 4)
    		begin
    			si_addr_dout	<= {si_ram_dout_r[7:4],1'b1,9'b0,send_cnt[9:0],addr_cnt[3:0],8'b0};
    			if(si_ram_dout_r[3:0] > addr_cnt)
    			begin
    				si_addr_dout_en	<= 1'b1;
    			end
    			else
    			begin
    				si_addr_dout_en	<= 1'b0;
    			end
    		end
    		else
    		begin
    			si_addr_dout	<= 0;
    			si_addr_dout_en	<= 0;
    		end
    	end
    	else
    	begin
    		si_addr_dout	<= 0;
    		si_addr_dout_en	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(si_state == RD_STATE)
    	begin
    		if(rd_cnt == 5)
    		begin
    			if(si_addr_dout_en)
    			begin
    				series_cnt	<= si_ram_dout_r[7:4] + 1;
    			end
    			else
    			begin
    				series_cnt	<= si_ram_dout_r[7:4];
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
    
    always @(posedge clk)
    begin
    	if(si_state == RD_STATE)
    	begin
    		if(rd_cnt == 6)
    		begin
    			si_ram_din	<= {series_cnt,si_ram_dout_r[3:0]};
    			si_ram_wr	<= 1'b1;
    		end
    		else
    		begin
    			si_ram_din	<= 0;
    			si_ram_wr	<= 0;
    		end
    	end
    	else if(si_state == WR_STATE)
    	begin
    		if(wr_cnt == 4)
    		begin
    			si_ram_din	<= {si_ram_dout_r[7:4],si_ram_din_r};
    			si_ram_wr	<= 1'b1;
    		end
    		else
    		begin
    			si_ram_din	<= 0;
    			si_ram_wr	<= 0;
    		end
    	end
    	else
    	begin
    		si_ram_din	<= 0;
    		si_ram_wr	<= 0;
    	end
    end
    
    mux_si_ram	si_ram(
		.clka			(clk),
		.dina			(si_ram_din),
		.addra			(si_ram_addr),
		.wea			(si_ram_wr),
		.clkb			(clk),
		.addrb			(si_ram_addr),
		.doutb          (si_ram_dout)
		);


endmodule
