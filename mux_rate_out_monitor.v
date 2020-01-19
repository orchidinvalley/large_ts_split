`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:37:05 06/24/2010 
// Design Name: 
// Module Name:    mux_rate_monitor 
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
module mux_rate_out_monitor
(
	clk,
	rst,
	
	rate_din,
	rate_din_en,
	
	con_din,
	con_din_en,
	
	rate_dout,
	rate_dout_en	
);
    
    input			clk;
    input			rst;
    
    input	[15:0]	rate_din;
    input			rate_din_en;
    input	[7:0]	con_din;
    input			con_din_en;
    
    output	[7:0]	rate_dout;
    output			rate_dout_en;
    
    reg		[7:0]	rate_dout;
    reg				rate_dout_en;
    

    reg		[7:0]	con_cnt;
    reg		[11:0]	start_addr;
    reg		[11:0]	end_addr;
    reg		[11:0]	send_num;
    
    reg		[11:0]	send_cnt;
    reg				clk_cnt;
    
    reg		[15:0]	rate_ram_din;
    reg				rate_ram_wr;
    reg		[11:0]	rate_ram_addra,rate_ram_addrb;
    wire	[15:0]	rate_ram_dout;
    
    reg				send_flag;
    
    reg		[7:0]	cmd1,cmd2,cmd3,cmd4,cmd5,cmd6 ;
        
    reg		[1:0]	sd_state;
    
    parameter		IDLE	= 1'd0,
    				RATE_SD	= 1'd1;
    
    
    always @(posedge clk)
    begin
    	if(rate_din_en)
    	begin
    		rate_ram_addra	<= rate_ram_addra + 1;
    		rate_ram_din	<= rate_din;
    		rate_ram_wr		<= 1'b1;
    	end
    	else
    	begin
    		rate_ram_addra	<= 0;
    		rate_ram_din	<= 0;
    		rate_ram_wr		<= 0;
    	end
    end
    
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
    
    always @ (posedge clk)
    begin
    	if(con_din_en == 1 && con_cnt == 0)	
    		cmd1 <= con_din ;
    	else
    		cmd1 <= cmd1 ;
    end
    
    always @ (posedge clk)
    begin
    	if(con_din_en == 1 && con_cnt == 1)	
    		cmd2 <= con_din ;
    	else
    		cmd2 <= cmd2 ;
    end
    
    always @ (posedge clk)
    begin
    	if(con_din_en == 1 && con_cnt == 2)	
    		cmd3 <= con_din ;
    	else
    		cmd3 <= cmd3 ;
    end
    
    always @ (posedge clk)
    begin
    	if(con_din_en == 1 && con_cnt == 3)	
    		cmd4 <= con_din ;
    	else
    		cmd4 <= cmd4 ;
    end
    
    always @ (posedge clk)
    begin
    	if(con_din_en == 1 && con_cnt == 4)	
    		cmd5 <= con_din ;
    	else
    		cmd5 <= cmd5 ;
    end
    
    always @ (posedge clk)
    begin
    	if(con_din_en == 1 && con_cnt == 5)	
    		cmd6 <= con_din ;
    	else
    		cmd6 <= cmd6 ;
    end
    
    always @(posedge clk)
    begin
    	if(con_cnt == 6)
    	begin
    		start_addr[11:8]	<= con_din[3:0];
    	end
    	else if(con_cnt == 7)
    	begin
    		start_addr[7:0]	<= con_din;
    	end
    	else
    	begin
    		start_addr	<= start_addr;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_cnt == 8)
    	begin
    		end_addr[11:8]	<= con_din[3:0];
    	end
    	else if(con_cnt == 9)
    	begin
    		end_addr[7:0]	<= con_din;
    	end
    	else
    	begin
    		end_addr	<= end_addr;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_cnt == 9)
    	begin
    		send_flag	<= 1'b1;
    	end
    	else
    	begin
    		send_flag	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(send_flag == 1'b1)
    	begin
    		send_num	<= end_addr + 1;
    	end
    	else
    	begin
    		send_num	<= send_num;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(rst)
    	begin
    		sd_state	<= IDLE;
    	end
    	else
    	begin
    		case(sd_state)
    			IDLE:
    				begin
    					if(send_flag)
    					begin
    						sd_state	<= RATE_SD;
    					end
    					else
    					begin
    						sd_state	<= IDLE;
    					end
    				end
    			RATE_SD:
    				begin
    					if(rate_ram_addrb == send_num)
    					begin
    						sd_state	<= IDLE;
    					end
    					else
    					begin
    						sd_state	<= RATE_SD;
    					end
    				end
    			default:
    				begin
    					sd_state	<= IDLE;
    				end
    		endcase
    	end
    end
    
    always @(posedge clk)
    begin
    	if(sd_state == RATE_SD)
    	begin
    		send_cnt	<= send_cnt + 1;
    	end
    	else
    	begin
    		send_cnt	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(send_flag)
    		clk_cnt <= 1;
    	else if(sd_state == RATE_SD)
    		clk_cnt	<= clk_cnt + 1;
    	else
    		clk_cnt	<= 0;
    end
    
    always @(posedge clk)
    begin
    	if(send_flag == 1'b1)
    	begin
    		rate_ram_addrb	<= start_addr;
    	end
    	else if(sd_state == RATE_SD && send_cnt > 7 )
    	begin
    		rate_ram_addrb	<= rate_ram_addrb + clk_cnt;
    	end
    	else
    	begin
    		rate_ram_addrb	<= rate_ram_addrb;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(sd_state == RATE_SD)
    	begin
    		if(send_cnt == 0)
    			rate_dout	<= 8'h04 ;
    		else if(send_cnt == 1)
    			rate_dout	<= 8'h0a ;
    		else if(send_cnt == 2)
    			rate_dout	<= cmd1  ;
    		else if(send_cnt == 3)
    			rate_dout	<= cmd2  ;
    		else if(send_cnt == 4)
    			rate_dout	<= cmd3  ;
    		else if(send_cnt == 5)
    			rate_dout	<= cmd4  ;
    		else if(send_cnt == 6)
    			rate_dout	<= cmd5  ;
    		else if(send_cnt == 7)
    			rate_dout	<= cmd6  ;
    		else if(clk_cnt == 1)
    			rate_dout	<= rate_ram_dout[15:8];
    		else	
 				rate_dout	<= rate_ram_dout[7:0];
   	 	end
    	else
    	begin
    		rate_dout	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(sd_state == RATE_SD)
    	begin
    		rate_dout_en	<= 1'b1;
    	end
    	else
    	begin
    		rate_dout_en	<= 1'b0;
    	end
    end
    
    rate_ram	rate_ram
    (
		.clka				(clk				),
		.wea				(rate_ram_wr		),
		.addra				(rate_ram_addra		),
		.dina				(rate_ram_din		),
		.clkb				(clk				),
		.addrb				(rate_ram_addrb		),
		.doutb              (rate_ram_dout		)
	);

endmodule
