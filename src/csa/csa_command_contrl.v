`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:43 06/10/2010 
// Design Name: 
// Module Name:    csa_command_contrl 
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
module csa_command_contrl(

	clk,
	rst,
	
	con_din,
	con_din_en,
	
	pid_con_dout,
	pid_con_dout_en,
	cw_con_dout,
	cw_con_dout_en,
	ecm_ddr_dout,
	ecm_ddr_dout_en,
	ecm_con_dout,
	ecm_con_addr,
	ecm_con_dout_en,
	emm_dout,
	emm_dout_en,
	emm_send,
	emm_send_en
    );
    
    input			clk;
    input			rst;
    
    input	[7:0]	con_din;
    input			con_din_en;
    
    output	[7:0]	pid_con_dout;
    output			pid_con_dout_en;
    output	[7:0]	cw_con_dout;
    output			cw_con_dout_en;
    output	[7:0]	ecm_ddr_dout;
    output			ecm_ddr_dout_en;
    output	[7:0]	ecm_con_dout;
    output	[15:0]	ecm_con_addr;
    output			ecm_con_dout_en;
    output	[8:0]	emm_dout;
    output			emm_dout_en;
    output	[8:0]	emm_send;
    output			emm_send_en;
	
    reg		[7:0]	pid_con_dout;
    reg				pid_con_dout_en;
    reg		[7:0]	cw_con_dout;
    reg				cw_con_dout_en;
    reg		[7:0]	ecm_ddr_dout;
    reg				ecm_ddr_dout_en;
    reg		[7:0]	ecm_con_dout;
    reg		[15:0]	ecm_con_addr;
    reg				ecm_con_dout_en;
    reg		[8:0]	emm_dout;
    reg				emm_dout_en;
	
	reg	[8:0]	emm_send;
    reg			emm_send_en;
    
    reg		[15:0]	con_cnt;
    
    reg		[7:0]	con_din_r;
    
    reg		[7:0]	cw_con_ram_din;
    reg		[12:0]	cw_con_ram_addra,cw_con_ram_addrb;
    reg				cw_con_ram_wr;
    wire	[7:0]	cw_con_ram_dout;
    
    reg		[7:0]	clear_cnt;
    
    reg		[7:0]	con_dout;
    reg				con_dout_en;
    
    reg		[15:0]	send_cnt;
    reg		[7:0]	send_clk_cnt;
    
    reg		[15:0]	emm_cnt;
    reg		[7:0]	emm_clk_cnt;

    reg		[7:0]	emm_dout_r;
    reg				emm_dout_en_r;
    
	 reg		[15:0]	emm_send_cnt;
    reg		[7:0]	emm_send_clk_cnt;

    reg		[7:0]	emm_send_r;
    reg				emm_send_en_r;
	
    reg		[12:0]	send_num;
    
    reg		[7:0]	package_cnt;
    reg				send_flag;
    
    reg		[3:0]	cmd_state;
    
    parameter		IDLE	= 4'b0001,
    				CMD_CHECK	= 4'b0010,
    				PID_CON	= 4'b0100,
    				CW_CON	= 4'b1000,
    				CON_WR	= 4'h3,
    				CON_WAIT	= 4'h5,
    				PACKAGE_CK	= 4'h6,
    				CON_SEND	= 4'h7,
    				ECM_CL		= 4'h9,
    				EMM_SD		= 4'hA,
					EMM_HEAD	=4'hB;
    
    always @(posedge clk)
    begin
    	con_din_r	<= con_din;
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
    
    always @(posedge clk)
    begin
    	if(rst)
    	begin
    		cmd_state	<= IDLE;
    	end
    	else
    	begin
    		case(cmd_state)
    			IDLE:
    				begin
    					if(con_cnt == 0 && con_din_en == 1'b1)
    					begin
    						if(con_din == 8'h40)
    						begin
    							cmd_state	<= CMD_CHECK;
    						end
    						else
    						begin
    							cmd_state	<= IDLE;
    						end
    					end
    					else
    					begin
    						cmd_state	<= IDLE;
    					end
    				end
    			CMD_CHECK:
    				begin
    					if(con_din == 8'h11)
    					begin
    						cmd_state	<= PID_CON;
    					end
    					else if(con_din == 8'h12)
    					begin
    						cmd_state	<= CW_CON;
    					end
    					else if(con_din == 8'h13)
    					begin
    						cmd_state	<= ECM_CL;
    					end
    					else if(con_din == 8'h14)
    					begin
    						cmd_state	<= EMM_SD;
    					end
						else if(con_din == 8'h15)
    					begin
    						cmd_state	<= EMM_HEAD;
    					end
    					else
    					begin
    						cmd_state	<= IDLE;
    					end
    				end
    			PID_CON:
    				begin
    					if(con_din_en == 1'b0)
    					begin
    						cmd_state	<= IDLE;
    					end
    					else
    					begin
    						cmd_state	<= PID_CON;
    					end
    				end
    			ECM_CL:
    				begin
    					if(con_din_en == 1'b0)
    					begin	
    						cmd_state	<= IDLE;
    					end
    					else
    					begin
    						cmd_state	<= ECM_CL;
    					end
    				end
    			EMM_SD:
    				begin
    					if(con_din_en == 1'b0)
    					begin
    						cmd_state	<= IDLE;
    					end
    					else
    					begin
    						cmd_state	<= EMM_SD;
    					end
    				end
				EMM_HEAD:
    				begin
    					if(con_din_en == 1'b0)
    					begin
    						cmd_state	<= IDLE;
    					end
    					else
    					begin
    						cmd_state	<= EMM_HEAD;
    					end
    				end	
    			CW_CON:
    				begin
    					if(con_cnt == 5)
    					begin
    						if(con_din == 8'h01)
    						begin
    							cmd_state	<= CON_WR;
    						end
    						else
    						begin
    							cmd_state	<= IDLE;
    						end
    					end
    					else
    					begin
    						cmd_state	<= CW_CON;
    					end
    				end
    			CON_WR:
    				begin
    					if(con_din_en == 1'b0)
    					begin
    						if(send_flag == 1'b1)
    						begin
    							cmd_state	<= CON_SEND;
    						end
    						else
    						begin
    							cmd_state	<= CON_WAIT;
    						end
    					end
    					else
    					begin
    						cmd_state	<= CON_WR;
    					end
    				end
    			CON_WAIT:
    				begin
    					if(con_cnt == 1 && con_din_r == 8'h40)
    					begin
    						if(con_din == 8'h12)
    						begin
    							cmd_state	<= PACKAGE_CK;
    						end
    						else if(con_din == 8'h11)
    						begin
    							cmd_state	<= PID_CON;
    						end
    						else
    						begin
    							cmd_state	<= IDLE;
    						end
    					end
    					else
    					begin
    						cmd_state	<= CON_WAIT;
    					end
    				end
    			PACKAGE_CK:
    				begin
    					if(con_cnt == 5)
    					begin
    						if(con_din == package_cnt)
    						begin
    							cmd_state	<= CON_WR;
    						end
    						else if(con_din == 8'h01)
    						begin
    							cmd_state	<= CON_WR;
    						end
    						else
    						begin
    							cmd_state	<= IDLE;
    						end
    					end
    				end
    			CON_SEND:
    				begin
    					if(cw_con_ram_addrb == send_num)
    					begin
    						cmd_state	<= IDLE;
    					end
    					else
    					begin
    						cmd_state	<= CON_SEND;
    					end
    				end
    			default:
    				begin
    					cmd_state	<= IDLE;
    				end
    		endcase
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_cnt == 5)
    	begin
    		if(con_din == 8'h01)
    		begin
    			package_cnt	<= 8'h01;
    		end
    		else
    		begin
    			package_cnt	<= package_cnt;
    		end
    	end
    	else if(con_cnt == 64)
    	begin
    		package_cnt	<= package_cnt + 1;
    	end
    	else
    	begin
    		package_cnt	<= package_cnt;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_cnt == 7)
    	begin
    		if(package_cnt == con_din)
    		begin
    			send_flag	<= 1'b1;
    		end
    		else
    		begin
    			send_flag	<= 1'b0;
    		end
    	end
    	else
    	begin
    		send_flag	<= send_flag;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(cmd_state == CON_WR)
    	begin
    		if(con_cnt == 8)
    		begin
    			if(package_cnt == 8'h01)
    			begin
    				cw_con_ram_addra	<= 0;
    				cw_con_ram_din		<= con_din;
    				cw_con_ram_wr		<= con_din_en;
    			end
    			else
    			begin
    				cw_con_ram_addra	<= cw_con_ram_addra + 1;
    				cw_con_ram_din		<= con_din;
    				cw_con_ram_wr		<= con_din_en;
    			end
    		end
    		else if(con_cnt > 8)
    		begin
    				cw_con_ram_addra	<= cw_con_ram_addra + con_din_en;
    				cw_con_ram_din		<= con_din;
    				cw_con_ram_wr		<= con_din_en;
    		end
    		else
    		begin
    			cw_con_ram_addra	<= cw_con_ram_addra;
    			cw_con_ram_din	<= 0;
    			cw_con_ram_wr	<= 0;
    		end
    	end
    	else
    	begin
    		cw_con_ram_addra	<= cw_con_ram_addra;
    		cw_con_ram_din	<= 0;
    		cw_con_ram_wr	<= 0;
    	end
    end
        
    always @(posedge clk)
    begin
    	if(cmd_state == CON_WR && con_din_en == 1'b0)
    	begin
    		send_num	<= cw_con_ram_addra + 1;
    	end
    	else
    	begin
    		send_num	<= send_num;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(cmd_state == CON_SEND)
    	begin
    		cw_con_ram_addrb	<= cw_con_ram_addrb + 1;
    	end
    	else
    	begin
    		cw_con_ram_addrb	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(cmd_state == PID_CON)
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
 //emm°ü 
    always @(posedge clk)
    begin
    	if(cmd_state == EMM_SD)
    	begin
    		emm_dout_r	<= con_din;
    		emm_dout_en_r	<= con_din_en;
    	end
    	else
    	begin
    		emm_dout_r	<= 0;
    		emm_dout_en_r	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(emm_dout_en_r == 1'b1)
    	begin
    		emm_cnt	<= emm_cnt + 1;
    	end
    	else
    	begin
    		emm_cnt	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(emm_cnt > 5)
    	begin
    		if(emm_clk_cnt == 202)
    		begin
    			emm_clk_cnt	<= 0;
    		end
    		else
    		begin
    			emm_clk_cnt	<= emm_clk_cnt + 1;
    		end
    	end
    	else
    	begin
    		emm_clk_cnt	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(emm_clk_cnt == 4)
    	begin
    		emm_dout	<= {1'b1,emm_dout_r};
    		emm_dout_en	<= 1'b1;
    	end
    	else if(emm_clk_cnt > 4)
    	begin
    		emm_dout	<= {1'b0,emm_dout_r};
    		emm_dout_en	<= emm_dout_en_r;
    	end
    	else
    	begin
    		emm_dout	<= 0;
    		emm_dout_en	<= 0;
    	end
    end
  
//EMMtÍ·
   always @(posedge clk)
    begin
    	if(cmd_state == EMM_HEAD)
    	begin
    		emm_send_r	<= con_din;
    		emm_send_en_r	<= con_din_en;
    	end
    	else
    	begin
    		emm_send_r	<= 0;
    		emm_send_en_r	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(emm_send_en_r == 1'b1)
    	begin
    		emm_send_cnt	<= emm_send_cnt + 1;
    	end
    	else
    	begin
    		emm_send_cnt	<= 0;
    	end
    end
    
//    always @(posedge clk)
//    begin
//    	if(emm_send_cnt > 5)
//    	begin
//    		if(emm_send_clk_cnt == 204)
//    		begin
//    			emm_send_clk_cnt	<= 0;
//    		end
//    		else
//    		begin
//    			emm_send_clk_cnt	<= emm_send_clk_cnt + 1;
//    		end
//    	end
//    	else
//    	begin
//    		emm_send_clk_cnt	<= 0;
//    	end
//    end
    
//    always @(posedge clk)
//    begin
//    	if(emm_send_clk_cnt == 4)
//    	begin
//    		emm_send	<= {1'b1,emm_send_r};
//    		emm_send_en	<= 1'b1;
//    	end
//    	else if(emm_send_clk_cnt > 4)
//    	begin
//    		emm_send	<= {1'b0,emm_send_r};
//    		emm_send_en	<= emm_send_en_r;
//    	end
//    	else
//    	begin
//    		emm_send	<= 0;
//    		emm_send_en	<= 0;
//    	end
//    end

    always @(posedge clk)
    begin
    	if(emm_send_cnt == 10)
    	begin
    		emm_send	<= {1'b1,emm_send_r};
    		emm_send_en	<= 1'b1;
    	end
    	else if(emm_send_cnt > 10)
    	begin
    		emm_send	<= {1'b0,emm_send_r};
    		emm_send_en	<= emm_send_en_r;
    	end
    	else
    	begin
    		emm_send	<= 0;
    		emm_send_en	<= 0;
    	end
    end



  ///cw/ecm
    always @(posedge clk)
    begin
    	if(cmd_state == CON_SEND && cw_con_ram_addrb > 0)
    	begin
    		con_dout	<= cw_con_ram_dout;
    		con_dout_en	<= 1'b1;
    	end
    	else
    	begin
    		con_dout	<= 0;
    		con_dout_en	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_dout_en)
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
    	if(send_cnt > 145)
    	begin
    		if(send_clk_cnt == 203)
    		begin
    			send_clk_cnt	<= 0;
    		end
    		else
    		begin
    			send_clk_cnt	<= send_clk_cnt + 1;
    		end
    	end
    	else
    	begin
    		send_clk_cnt	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(con_dout_en == 1'b1 && send_cnt < 146)
    	begin
    		cw_con_dout	<= con_dout;
    		cw_con_dout_en	<= 1'b1;
    	end
    	else
    	begin
    		cw_con_dout	<= 0;
    		cw_con_dout_en	<= 1'b0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(send_clk_cnt > 0)
    	begin
    		ecm_ddr_dout	<= con_dout;
    		ecm_ddr_dout_en	<= con_dout_en;
    	end
    	else
    	begin
    		ecm_ddr_dout	<= 0;
    		ecm_ddr_dout_en	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(cmd_state == ECM_CL)
    	begin
    		clear_cnt	<= clear_cnt + 1;
    	end
    	else
    	begin
    		clear_cnt	<= 0;
    	end
    end
    
    always @(posedge clk)
    begin    	
    	if(send_cnt > 145)
    	begin
    		if(send_clk_cnt == 0)
    		begin
    			ecm_con_dout[7:4]	<= con_dout[3:0];
    		end
    		else if(send_clk_cnt == 3)
    		begin
    			ecm_con_dout[2:0]	<= con_dout[1:0] + 1;
    			ecm_con_dout[3]		<= con_dout[2];
    		end
    		else
    		begin
    			ecm_con_dout	<= ecm_con_dout;
    		end
    	end
    	else if(cmd_state == ECM_CL)
    	begin
    		ecm_con_dout	<= 0;
    	end
    	else
    	begin
    		ecm_con_dout	<= ecm_con_dout;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(send_clk_cnt == 1)
    	begin
    		ecm_con_addr[15:13]	<= con_dout[2:0];
    	end
    	else if(send_clk_cnt == 2)
    	begin
    		ecm_con_addr[12:5]	<= con_dout[7:0];
    	end
    	else if(send_clk_cnt == 3)
    	begin
    		ecm_con_addr[4:0]	<= con_dout[7:3];
    	end
    	else if(clear_cnt == 6)
    	begin
    		ecm_con_addr[15:13]	<= con_din[1:0];
    	end
    	else if(clear_cnt == 7)
    	begin
    		ecm_con_addr[12:5]	<= con_din[7:0];
    	end
    	else if(clear_cnt == 8)
    	begin
    		ecm_con_addr[4:0]	<= con_din[7:3];
    	end
    	else
    	begin
    		ecm_con_addr	<= ecm_con_addr;
    	end
    end
    
    always @(posedge clk)
    begin
    	if(send_clk_cnt == 203)
    	begin
    		ecm_con_dout_en	<= 1'b1;
    	end
    	else if(clear_cnt == 10)
    	begin
    		ecm_con_dout_en	<= 1'b1;
    	end
    	else
    	begin
    		ecm_con_dout_en	<= 1'b0;
    	end
    end
    
    csa_cmd_ram	cw_con_ram(
		.clka				(clk),
		.wea				(cw_con_ram_wr),
		.addra				(cw_con_ram_addra),
		.dina				(cw_con_ram_din),
		.clkb				(clk),
		.addrb				(cw_con_ram_addrb),
		.doutb              (cw_con_ram_dout)
		);


endmodule
