`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:31:37 06/09/2010 
// Design Name: 
// Module Name:    mux_ip_rej 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 32位宽 数据处理，188 ts 仅占47个字节，要47个周期内将ram遍历完成 ram大小只能为32  单光口设置最多支持128个IP PORT 需要4个RAM 分块并行工作
//  
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mux_ip_rej(

	clk,
	rst,
	
	ts_din,
	ts_din_en,
	con_din,
	con_din_en,
	
	ts_dout,
	ts_dout_en
	
    );
    
    input			clk;
    input			rst;
    

	input	[32:0]	ts_din;
    input			ts_din_en;
    input	[7:0]	con_din;
    input			con_din_en;
    

	output	[32:0]	ts_dout;
    output			ts_dout_en;    
	reg		[32:0]	ts_dout;
    reg				ts_dout_en;

////////////////////////////////////////
    
    reg		[7:0]	ts_cnt;
    reg		[15:0]	con_cnt;
    reg		[3:0]	con_clk_cnt;
    
    reg		[7:0]	rd_cnt;
    reg				pass_flag;
    reg				send_flag;
    
    reg		[23:0]	ts_channel;
    reg		[31:0]	ts_ip;
    reg		[15:0]	ts_port;
    reg		[7:0]	ts_gbe;
    

    wire	[32:0]	ts_fifo_dout;
    reg		[32:0]	ts_fifo_dout_r;	
	
    reg				ts_fifo_rd;
    wire			ts_fifo_pfull;
	wire 	        empty;
	
    //4ram 并行工作
    reg		[1:0]	ip_ram_sel;
    reg		[71:0]	ip_ram_din;
    reg		[6:0]	ip_ram_addra;
    
    reg				ip1_ram_wr;
    reg		[6:0]	ip_ram_addrb;
    wire	[71:0]	ip1_ram_dout;
    reg		[71:0]	ip1_ram_dout_r;
    
    reg				ip2_ram_wr;
    wire	[71:0]	ip2_ram_dout;
    reg		[71:0]	ip2_ram_dout_r;
    
    reg				ip3_ram_wr;
    wire	[71:0]	ip3_ram_dout;
    reg		[71:0]	ip3_ram_dout_r;
    
    reg				ip4_ram_wr;
    wire	[71:0]	ip4_ram_dout;
    reg		[71:0]	ip4_ram_dout_r;
    
    
    
    
    reg		[1:0]	rd_state;
    reg     [1:0]   rd_nxt_state;//prf+ 20150725    
    
    parameter		IDLE	= 2'b01,
    				TS_READ	= 2'b10;
  
////////////////////////////////////////    
    always @ (posedge clk)
    begin
    	if(ts_din_en)
    		ts_cnt <= ts_cnt + 1;
    	else
    		ts_cnt <= 0;
    end
    
    always @(posedge clk)
    begin
    	if(rst)
    	    ts_gbe <=0;
    	else if(ts_cnt == 0 && ts_din_en == 1'b1)
    	    ts_gbe <= ts_din[7:0];			
    	else
    		ts_gbe <= ts_gbe;
    end


    always @(posedge clk)
    begin
    	if(ts_cnt == 1 && ts_din_en == 1'b1)
    		ts_ip <= ts_din;			
    	else
    		ts_ip <= ts_ip;
    end
	
    always @(posedge clk)
    begin
    	if(ts_cnt ==2 && ts_din_en == 1'b1)
    		ts_port	<= ts_din[15:0];
    	else
    		ts_port	<= ts_port;
    end
    
    always @(posedge clk)
    begin
    	if(ts_cnt < 4)
    	begin
    		ts_channel	<= 0;
    		pass_flag	<= 0;
    	end
    	else
    	begin
//    	if(ts_cnt <35)
//    	begin
    		if(ip1_ram_dout_r[71:40] == ts_ip && ip1_ram_dout_r[39:24] == ts_port)
    		begin
    			ts_channel	<= ip1_ram_dout_r[23:0];
    			pass_flag	<= 1'b1;
    		end
    		else if(ip2_ram_dout_r[71:40] == ts_ip && ip2_ram_dout_r[39:24] == ts_port)
    		begin
    			ts_channel	<= ip2_ram_dout_r[23:0];
    			pass_flag	<= 1'b1;
    		end
    		else if(ip3_ram_dout_r[71:40] == ts_ip && ip3_ram_dout_r[39:24] == ts_port)
    		begin
    			ts_channel	<= ip3_ram_dout_r[23:0];
    			pass_flag	<= 1'b1;
    		end
    		else if(ip4_ram_dout_r[71:40] == ts_ip && ip4_ram_dout_r[39:24] == ts_port)
    		begin
    			ts_channel	<= ip4_ram_dout_r[23:0];
    			pass_flag	<= 1'b1;
    		end
    		else
    		begin
    			ts_channel	<= ts_channel;
    			pass_flag	<= pass_flag;
    		end
//    		end
//    		else
//    		begin
//    			ts_channel	<= ts_channel;
//    			pass_flag	<= pass_flag;
//    		end
    	end    	
    end

//prf modify 20150725 将一段式状态机改成两段式
    always @ (posedge clk)
    begin
        if(rst)
            rd_state <= IDLE;
        else
            rd_state <= rd_nxt_state;
    end
    
    always @ (rd_state or ts_fifo_pfull or empty or rd_cnt)
    begin
        case(rd_state)
        	IDLE:
        	begin
        	    if(ts_fifo_pfull && !empty)
        	        rd_nxt_state = TS_READ;
        	    else
        	        rd_nxt_state = IDLE;
        	end
        	
        	TS_READ:
        	begin
        	    if(rd_cnt == 8'd51)
        	        rd_nxt_state = IDLE;
        	    else
        	        rd_nxt_state = TS_READ;
        	end
        	
        	default:
        	    rd_nxt_state = IDLE;
        endcase
    end

 /*   
    always @(posedge clk)
    begin
    	if(rst)
    	begin
    		rd_state	<= IDLE;
    	end
    	else
    	begin
    		case(rd_state)
    			IDLE:
    				begin
    					if(ts_fifo_pfull && !empty )
    					begin
    						rd_state	<= TS_READ;
    					end
    					else
    					begin
    						rd_state	<= IDLE;
    					end
    				end
    			TS_READ:
    				begin
						if(rd_cnt == 51)		
    					begin
    						rd_state	<= IDLE;
    					end
    					else
    					begin
    						rd_state	<= TS_READ;
    					end
    				end
    			default:
    				begin
    					rd_state	<= IDLE;
    				end
    		endcase
    	end
    end
*/    
    always @ (posedge clk)
    begin
    	ts_fifo_dout_r	<= ts_fifo_dout;
    end
    
    always @(posedge clk)
	begin
		if(rd_state == TS_READ)
		begin
			if(ts_fifo_dout_r[32] == 1'b1)
			begin
				send_flag	<= 1'b1;
			end
			else
			begin
				send_flag	<= send_flag;
			end
		end
		else
		begin
			send_flag	<= 0;
		end
	end
	
	always @(posedge clk)
    begin
    	if(send_flag)
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
		if(rd_state == TS_READ && rd_cnt < 46)
    	begin
    		ts_fifo_rd	<= 1'b1;
    	end
    	else
    	begin
    		ts_fifo_rd	<= 1'b0;
    	end
    end
    
    always @(posedge clk)
    begin
    	ts_fifo_dout_r	<= ts_fifo_dout;		
    end
    
    always @(posedge clk)
    begin
    	if(send_flag == 1'b1)
    	begin
    		if(rd_cnt == 0)
    		begin
    			ts_dout	<= {33'h100,ts_channel};
    		end

    		else if(rd_cnt < 48)		//188/8=24
    		begin
    			ts_dout	<= ts_fifo_dout;
    		end
    		else
    		begin
    			ts_dout	<= 0;
    		end
    	end
    	else
    	begin
    		ts_dout	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(send_flag == 1'b1)
    	begin
    		if(rd_cnt == 0)
    		begin
    			ts_dout_en	<= pass_flag;
    		end
    		else if(rd_cnt < 48)			
    		begin
    			ts_dout_en	<= ts_dout_en;
    		end
    		else
    		begin
    			ts_dout_en	<= 0;
    		end
    	end
    	else
    	begin
    		ts_dout_en	<= 0;
    	end
    end
    
    
    ip_rej_ts_fifo     ts_fifo 
    (
        .clk          (clk), // input clk
        .rst          (rst), // input rst
        .din          (ts_din), // input [64 : 0] din
        .wr_en        (ts_din_en), // input wr_en
        .rd_en        (ts_fifo_rd), // input rd_en
        .dout         (ts_fifo_dout), // output [64 : 0] dout
        .full         (), // output full
        .empty        (empty), // output empty
        .prog_full    (ts_fifo_pfull) // output prog_full
    );
    
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
    	if(con_cnt > 5)
    	begin
    		if(con_clk_cnt < 14)
    		begin
    			con_clk_cnt	<= con_clk_cnt + 1;
    		end
    		else
    		begin
    			con_clk_cnt	<= 0;
    		end
    	end
    	else
    	begin
    		con_clk_cnt	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(rst)
    		ip_ram_addra	<=0;
    	else if(con_clk_cnt==2)
    	begin
    		ip_ram_addra[6]	<=	con_din[0];
    	end
    	else
    	if(con_clk_cnt == 3)
    	begin
    		ip_ram_addra[5:0]	<= con_din[7:2];
    		
    	end
    	else
    	begin
    		ip_ram_addra	<= ip_ram_addra;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_clk_cnt == 3)
    	begin
    		ip_ram_sel	<=	con_din[1:0];
    	end
    	else
    	begin
    		ip_ram_sel	<=	ip_ram_sel;
    	end
    end    
    
    always @(posedge clk)
    begin
    	if(con_clk_cnt == 4)
    	begin
    		ip_ram_din[71:64]	<= con_din;
    	end
    	else if(con_clk_cnt == 5)
    	begin
    		ip_ram_din[63:56]	<= con_din;
    	end
    	else if(con_clk_cnt == 6)
    	begin
    		ip_ram_din[55:48]	<= con_din;
    	end
    	else if(con_clk_cnt == 7)
    	begin
    		ip_ram_din[47:40]	<= con_din;
    	end
    	
    	else if(con_clk_cnt == 8)
    	begin
    		ip_ram_din[39:32]	<= con_din;
    	end
    	else if(con_clk_cnt == 9)
    	begin
    		ip_ram_din[31:24]	<= con_din;
    	end
    	
    	else if(con_clk_cnt == 12)
    	begin
    		ip_ram_din[23:16]	<= con_din;
    	end
    	else if(con_clk_cnt == 13)
    	begin
    		ip_ram_din[15:8]	<= con_din;
    	end
    	
    	else if(con_clk_cnt == 14)
    	begin
    		ip_ram_din[7:0]	<= con_din;
    	end
    	else
    	begin
    		ip_ram_din	<= ip_ram_din;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_clk_cnt == 14)
    	begin
    		case(ip_ram_sel)
    			2'b00:ip1_ram_wr	<= 1'b1;
    			2'b01:ip2_ram_wr	<= 1'b1;
    			2'b10:ip3_ram_wr	<= 1'b1;
    			2'b11:ip4_ram_wr	<= 1'b1;
    		
    		endcase
    	end
    	else
    	begin
    		ip1_ram_wr	<= 1'b0;
    		ip2_ram_wr	<= 1'b0;
    		ip3_ram_wr	<= 1'b0;
    		ip4_ram_wr	<= 1'b0;
    
    	end
    end
    
    always @(posedge clk)
    begin
    	if(rst)
    	ip_ram_addrb	<=0;
    	else 
    	ip_ram_addrb	<={ts_gbe[1:0], ts_cnt[4:0]};
    end
    
    always @(posedge clk)
    begin
    	ip1_ram_dout_r	<= ip1_ram_dout;
    	ip2_ram_dout_r	<= ip2_ram_dout;
    	ip3_ram_dout_r	<= ip3_ram_dout;
    	ip4_ram_dout_r	<= ip4_ram_dout;
   
    	
    end
    
    
    ip_rej_ram	ip1_ram(
		.clka				(clk),
		.wea				(ip1_ram_wr),
		.addra				(ip_ram_addra),
		.dina				(ip_ram_din),
		.clkb				(clk),
		.addrb				(ip_ram_addrb),
		.doutb              (ip1_ram_dout)
		);
		
	ip_rej_ram	ip2_ram(
		.clka				(clk),
		.wea				(ip2_ram_wr),
		.addra				(ip_ram_addra),
		.dina				(ip_ram_din),
		.clkb				(clk),
		.addrb				(ip_ram_addrb),
		.doutb              (ip2_ram_dout)
		);
		
	ip_rej_ram	ip3_ram(
		.clka				(clk),
		.wea				(ip3_ram_wr),
		.addra				(ip_ram_addra),
		.dina				(ip_ram_din),
		.clkb				(clk),
		.addrb				(ip_ram_addrb),
		.doutb              (ip3_ram_dout)
		);                                
		                                  
	ip_rej_ram	ip4_ram(                  
		.clka				(clk),        
		.wea				(ip4_ram_wr), 
		.addra				(ip_ram_addra),
		.dina				(ip_ram_din), 
		.clkb				(clk),        
		.addrb				(ip_ram_addrb),
		.doutb              (ip4_ram_dout)
		);
		
	
    
endmodule




