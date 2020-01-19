`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:22:44 06/17/2010 
// Design Name: 
// Module Name:    ddr_rd_treat 
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
module ddr_rd_treat(

	wr_clk,
	rd_clk,
	rst,
	
	rd_din,
	rd_din_en,
	
	rd_dout,
	rd_dout_en,
	flag_overflow
    );
    
    input			wr_clk;
    input			rd_clk;
    input			rst;
    
    input	[512:0]	rd_din;
    input			rd_din_en;
    
    output	[8:0]	rd_dout;
    output			rd_dout_en;
    output			flag_overflow;
    
    reg		[8:0]	rd_dout;
    reg				rd_dout_en;
    
    reg				rd_fifo_rd;
    wire	[512:0]	rd_fifo_dout;
    wire			rd_fifo_empty;
    
    
    reg		[7:0]	send_cnt;
    reg		[8:0]	rd_dout_r;
    reg				rd_dout_en_r;
    
    reg		[6:0]	sd_cnt;
    reg		[3:0]	rd_state;
    
    parameter		IDLE	= 4'b0001,
    				FIFO_RD	= 4'b0010,
    				FIFO_WT	= 4'b0100,
    				DATA_SD	= 4'b1000;
    
    always @(posedge rd_clk)
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
    					if(rd_fifo_empty == 1'b0)
    					begin
    						rd_state	<= FIFO_RD;
    					end
    					else
    					begin
    						rd_state	<= IDLE;
    					end
    				end
    			FIFO_RD:
    				begin
    					rd_state	<= FIFO_WT;
    				end
    			FIFO_WT:
    				begin
    					rd_state	<= DATA_SD;
    				end
    			DATA_SD:
    				begin
    					if(sd_cnt == 63)
    					begin
    						rd_state	<= IDLE;
    					end
    					else
    					begin
    						rd_state	<= DATA_SD;
    					end
    				end
    			default:
    				begin
    					rd_state	<= IDLE;
    				end
    		endcase
    	end
    end    
    
    always @(posedge rd_clk)
    begin
    	if(rd_state == DATA_SD)
    	begin
    		sd_cnt	<= sd_cnt + 1;
    	end
    	else
    	begin
    		sd_cnt	<= 0;
    	end
    end
    
    always @(posedge rd_clk)
    begin
    	if(rd_state == DATA_SD)
    	begin
    		case(sd_cnt)
    			0:rd_dout_r	<= rd_fifo_dout[512:504];
    			1:rd_dout_r	<= {1'b0,rd_fifo_dout[503:496]};
    			2:rd_dout_r	<= {1'b0,rd_fifo_dout[495:488]};
    			3:rd_dout_r	<= {1'b0,rd_fifo_dout[487:480]};
    			4:rd_dout_r	<= {1'b0,rd_fifo_dout[479:472]};
    			5:rd_dout_r	<= {1'b0,rd_fifo_dout[471:464]};
    			6:rd_dout_r	<= {1'b0,rd_fifo_dout[463:456]};
    			7:rd_dout_r	<= {1'b0,rd_fifo_dout[455:448]};
    			8:rd_dout_r	<= {1'b0,rd_fifo_dout[447:440]};
    			9:rd_dout_r	<= {1'b0,rd_fifo_dout[439:432]};
    			10:rd_dout_r	<= {1'b0,rd_fifo_dout[431:424]};
    			11:rd_dout_r	<= {1'b0,rd_fifo_dout[423:416]};
    			12:rd_dout_r	<= {1'b0,rd_fifo_dout[415:408]};
    			13:rd_dout_r	<= {1'b0,rd_fifo_dout[407:400]}; 
    			14:rd_dout_r	<= {1'b0,rd_fifo_dout[399:392]}; 
    			15:rd_dout_r	<= {1'b0,rd_fifo_dout[391:384]}; 
    			16:rd_dout_r	<= {1'b0,rd_fifo_dout[383:376]}; 
    			17:rd_dout_r	<= {1'b0,rd_fifo_dout[375:368]}; 
    			18:rd_dout_r	<= {1'b0,rd_fifo_dout[367:360]}; 
    			19:rd_dout_r	<= {1'b0,rd_fifo_dout[359:352]}; 
    			20:rd_dout_r	<= {1'b0,rd_fifo_dout[351:344]}; 
    			21:rd_dout_r	<= {1'b0,rd_fifo_dout[343:336]}; 
    			22:rd_dout_r	<= {1'b0,rd_fifo_dout[335:328]}; 
    			23:rd_dout_r	<= {1'b0,rd_fifo_dout[327:320]}; 
    			24:rd_dout_r	<= {1'b0,rd_fifo_dout[319:312]}; 
    			25:rd_dout_r	<= {1'b0,rd_fifo_dout[311:304]}; 
    			26:rd_dout_r	<= {1'b0,rd_fifo_dout[303:296]}; 
    			27:rd_dout_r	<= {1'b0,rd_fifo_dout[295:288]}; 
    			28:rd_dout_r	<= {1'b0,rd_fifo_dout[287:280]}; 
    			29:rd_dout_r	<= {1'b0,rd_fifo_dout[279:272]}; 
    			30:rd_dout_r	<= {1'b0,rd_fifo_dout[271:264]}; 
    			31:rd_dout_r	<= {1'b0,rd_fifo_dout[263:256]}; 
 			32:rd_dout_r	<= {1'b0,rd_fifo_dout[255:248]};  
			33:rd_dout_r	<= {1'b0,rd_fifo_dout[247:240]};  
			34:rd_dout_r	<= {1'b0,rd_fifo_dout[239:232]};
			35:rd_dout_r	<= {1'b0,rd_fifo_dout[231:224]};
			36:rd_dout_r	<= {1'b0,rd_fifo_dout[223:216]};
			37:rd_dout_r	<= {1'b0,rd_fifo_dout[215:208]};
			38:rd_dout_r	<= {1'b0,rd_fifo_dout[207:200]};
			39:rd_dout_r	<= {1'b0,rd_fifo_dout[199:192]};
			40:rd_dout_r	<= {1'b0,rd_fifo_dout[191:184]};
			41:rd_dout_r	<= {1'b0,rd_fifo_dout[183:176]};
			42:rd_dout_r	<= {1'b0,rd_fifo_dout[175:168]};
			43:rd_dout_r	<= {1'b0,rd_fifo_dout[167:160]};
			44:rd_dout_r	<= {1'b0,rd_fifo_dout[159:152]};
			45:rd_dout_r	<= {1'b0,rd_fifo_dout[151:144]};
			46:rd_dout_r	<= {1'b0,rd_fifo_dout[143:136]};
			47:rd_dout_r	<= {1'b0,rd_fifo_dout[135:128]};
			48:rd_dout_r	<= {1'b0,rd_fifo_dout[127:120]};
			49:rd_dout_r	<= {1'b0,rd_fifo_dout[119:112]};
			50:rd_dout_r	<= {1'b0,rd_fifo_dout[111:104]};
			51:rd_dout_r	<= {1'b0,rd_fifo_dout[103:96]}; 
			52:rd_dout_r	<= {1'b0,rd_fifo_dout[95:88]};  
			53:rd_dout_r	<= {1'b0,rd_fifo_dout[87:80]};  
			54:rd_dout_r	<= {1'b0,rd_fifo_dout[79:72]};  
			55:rd_dout_r	<= {1'b0,rd_fifo_dout[71:64]};  
			56:rd_dout_r	<= {1'b0,rd_fifo_dout[63:56]};  
			57:rd_dout_r	<= {1'b0,rd_fifo_dout[55:48]};  
			58:rd_dout_r	<= {1'b0,rd_fifo_dout[47:40]};  
			59:rd_dout_r	<= {1'b0,rd_fifo_dout[39:32]};  
			60:rd_dout_r	<= {1'b0,rd_fifo_dout[31:24]};  
			61:rd_dout_r	<= {1'b0,rd_fifo_dout[23:16]};  
			62:rd_dout_r	<= {1'b0,rd_fifo_dout[15:8]};   
			63:rd_dout_r	<= {1'b0,rd_fifo_dout[7:0]};    

    			default:rd_dout_r	<= 0;
    		endcase
    	end
    	else
    	begin
    		rd_dout_r	<= 0;
    	end
    end
    
    always @(posedge rd_clk)
    begin
    	if(rd_state == DATA_SD)
    	begin
    		rd_dout_en_r	<= 1'b1;
    	end
    	else
    	begin
    		rd_dout_en_r	<= 1'b0;
    	end
    end
    
    always @(posedge rd_clk)
    begin
    	if(rd_dout_en_r == 1'b1)
    	begin
    		if(rd_dout_r[8] == 1'b1)
    		begin
    			send_cnt	<= 0;
    		end
    		else
    		begin
    			send_cnt	<= send_cnt + 1;
    		end
    	end
    	else
    	begin
    		send_cnt	<= send_cnt;
    	end
    end
    
    always @(posedge rd_clk)
    begin
    	if(send_cnt < 191 || (send_cnt >= 248 && send_cnt <= 254) || (rd_dout_r[8] == 1'b1))//if(send_cnt < 191 || (send_cnt >= 205 && send_cnt <= 209) || (rd_dout_r[8] == 1'b1))
    	begin
    		rd_dout	<= rd_dout_r;
    		rd_dout_en	<= rd_dout_en_r;
    	end
    	else
    	begin
    		rd_dout	<= 0;
    		rd_dout_en	<= 0;
    	end
    end
    
    always @(posedge rd_clk)
    begin
    	if(rd_state == FIFO_RD)
    	begin
    		rd_fifo_rd	<= 1'b1;
    	end
    	else
    	begin
    		rd_fifo_rd	<= 1'b0;
    	end
    end
    
    ddr_read_fifo	rd_fifo(
		.rst				(rst),
		.wr_clk				(wr_clk),
		.rd_clk				(rd_clk),
		.din				(rd_din),
		.wr_en				(rd_din_en),
		.rd_en				(rd_fifo_rd),
		.dout				(rd_fifo_dout),
		.full				(flag_overflow),
		.empty              (rd_fifo_empty)
		);

endmodule
