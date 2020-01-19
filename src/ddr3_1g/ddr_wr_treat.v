`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:11:40 06/12/2010 
// Design Name: 
// Module Name:    ddr_wr_treat 
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
module ddr_wr_treat(

	clk,
	rst,
	
	ecm_din,
	ecm_din_en,
	si_din,
	si_din_en,
	
	wr_dout,
	wr_dout_en
    );
    
    
    input			clk;
    input			rst;
    
    input	[7:0]	ecm_din;
    input			ecm_din_en;
    input	[7:0]	si_din;
    input			si_din_en;
    
    output	[512:0]	wr_dout;
    output			wr_dout_en;
    
    reg		[512:0]	wr_dout;
    reg				wr_dout_en;
    
    reg		[7:0]	wr_din;
    reg				wr_din_en;
    
    reg		[7:0]	wr_cnt;
    reg		[5:0]	wr_clk_cnt;
    
//    reg				pad_flag;
    
    reg		[31:0]	wr_addr;
    reg				wr_addr_en;
    
    reg		[511:0]	wr_dout_r;
    reg				wr_dout_en_r;
    
    always @(posedge clk)
    begin
    	if(si_din_en)
    	begin
    		wr_din	<= si_din;
    		wr_din_en	<= 1'b1;
    	end
    	else
    	begin
    		wr_din	<= ecm_din;
    		wr_din_en	<= ecm_din_en;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(wr_din_en)
    	begin
    		if(wr_cnt == 202)
    		begin
    			wr_cnt	<= 0;
    		end
    		else
    		begin
    			wr_cnt	<= wr_cnt + 1;
    		end
    	end
    	else
    	begin
    		wr_cnt	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(wr_cnt > 3)
    	begin
    		wr_clk_cnt	<= wr_clk_cnt + 1;
    	end
    	else
    	begin
    		wr_clk_cnt	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    if(rst)
    	wr_addr	<=0;
    	else 
    	if(wr_din_en == 1'b1 && wr_cnt == 0)
    	begin
    		wr_addr[31:24]	<= wr_din;
    	end
    	else if(wr_cnt == 1)
    	begin
    		wr_addr[23:16]	<= wr_din;
    	end
    	else if(wr_cnt == 2)
    	begin
    		wr_addr[15:8]	<= wr_din;
    	end
    	else if(wr_cnt == 3)
    	begin
    		wr_addr[7:0]	<= wr_din;
    	end
    	else
    	begin
    		wr_addr	<= wr_addr;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(wr_cnt == 3)
    	begin
    		wr_addr_en	<= 1'b1;
    	end
    	else
    	begin
    		wr_addr_en	<= 1'b0;
    	end
    end
    
    always @(posedge clk)
    begin
    if(rst)
    			wr_dout_r	<=0;
    	else 
    	if(wr_cnt > 3 && wr_din_en == 1'b1)
    	begin
//    		wr_dout_r[255:248]	<= wr_dout_r[247:240];
//    		wr_dout_r[247:240]	<= wr_dout_r[239:232];
//    		wr_dout_r[239:232]	<= wr_dout_r[231:224];
//    		wr_dout_r[231:224]	<= wr_dout_r[223:216];
//    		wr_dout_r[223:216]	<= wr_dout_r[215:208];
//    		wr_dout_r[215:208]	<= wr_dout_r[207:200];
//    		wr_dout_r[207:200]	<= wr_dout_r[199:192];
//    		wr_dout_r[199:192]	<= wr_dout_r[191:184];
//    		wr_dout_r[191:184]	<= wr_dout_r[183:176];
//    		wr_dout_r[183:176]	<= wr_dout_r[175:168];
//    		wr_dout_r[175:168]	<= wr_dout_r[167:160];
//    		wr_dout_r[167:160]	<= wr_dout_r[159:152];
//    		wr_dout_r[159:152]	<= wr_dout_r[151:144];
//    		wr_dout_r[151:144]	<= wr_dout_r[143:136];
//    		wr_dout_r[143:136]	<= wr_dout_r[135:128];
//    		wr_dout_r[135:128]	<= wr_dout_r[127:120];
//    		wr_dout_r[127:120]	<= wr_dout_r[119:112];
//    		wr_dout_r[119:112]	<= wr_dout_r[111:104];
//    		wr_dout_r[111:104]	<= wr_dout_r[103:96];
//    		wr_dout_r[103:96]	<= wr_dout_r[95:88];
//    		wr_dout_r[95:88]	<= wr_dout_r[87:80];
//    		wr_dout_r[87:80]	<= wr_dout_r[79:72];
//    		wr_dout_r[79:72]	<= wr_dout_r[71:64];
//    		wr_dout_r[71:64]	<= wr_dout_r[63:56];
//    		wr_dout_r[63:56]	<= wr_dout_r[55:48];
//    		wr_dout_r[55:48]	<= wr_dout_r[47:40];
//    		wr_dout_r[47:40]	<= wr_dout_r[39:32];
//    		wr_dout_r[39:32]	<= wr_dout_r[31:24];
//    		wr_dout_r[31:24]	<= wr_dout_r[23:16];
//    		wr_dout_r[23:16]	<= wr_dout_r[15:8];
//    		wr_dout_r[15:8]		<= wr_dout_r[7:0];
//    		wr_dout_r[7:0]		<= wr_din;
			wr_dout_r	<=	{wr_dout_r[503:0],wr_din};
    	end
    	else
    	begin
    		wr_dout_r	<= wr_dout_r;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(wr_clk_cnt == 63)
    	begin
    		wr_dout_en_r	<= 1'b1;
    	end
    	else if(wr_cnt == 202)
    	begin
    		wr_dout_en_r	<= 1'b1;
    	end
    	else
    	begin
    		wr_dout_en_r	<= 1'b0;
    	end
    end
    
//    always @(posedge clk)
//    begin
//    	if(wr_cnt == 0 && wr_dout_en_r == 1'b1)
//    	begin
//    		pad_flag	<= 1'b1;
//    	end
//    	else
//    	begin
//    		pad_flag	<= 1'b0;
//    	end
//    end
    
    always @(posedge clk)
    begin
    	if(wr_addr_en)
    	begin
    		wr_dout	<= {1'b1,480'b0,wr_addr};
    		wr_dout_en	<= 1'b1;
    	end
    	else
 if(wr_dout_en_r == 1'b1)
    	begin
//    	if(wr_cnt==68)
//    	wr_dout	<= {1'b1,wr_dout_r};
//    	else 
    		wr_dout	<= {1'b0,wr_dout_r};
    		wr_dout_en	<= 1'b1;
    	end
//    	else if(pad_flag)
//    	begin
//    		wr_dout	<= 0;
//    		wr_dout_en	<= 1'b1;
//    	end
    	else
    	begin
    		wr_dout	<= 0;
    		wr_dout_en	<= 0;
    	end
    end


endmodule
