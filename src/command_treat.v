`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:28:43 08/28/2019 
// Design Name: 
// Module Name:    command_treat 
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
module command_treat(
	clk,
	rst,
	
	con_din,
	con_din_en,
	
	si_get_con,
	si_get_con_en,
	
	nit_con,
	nit_con_en,
	
	freq_con,
	freq_con_en,
	
	channel_con,//取IP PORT配置命令的前两字节
	channel_con_en,
	
	ip_port_con,//去掉命令头
	ip_port_con_en,
	
	rate_con_start,
	rate_con_end,
	
	sfp1_ip,
	sfp2_ip,
	sfp3_ip,
	sfp4_ip,
	
	reply_con,
	reply_con_en

    );
    
    
    input clk;
    input rst;
    
    input	[7:0]con_din;
    input	con_din_en;
    
    output	[7:0]si_get_con;
    output	si_get_con_en;
    
    reg	[7:0]si_get_con;
    reg	si_get_con_en;
    
    output	[7:0]nit_con;
    output	nit_con_en;
    
    reg	[7:0]nit_con;
    reg	nit_con_en;
    
    
    output 	[7:0]freq_con;
    output	freq_con_en;
    
    reg 	[7:0]freq_con;
    reg	freq_con_en;
    
    output	[7:0]channel_con;
    output	channel_con_en;
    
    reg 	[7:0]channel_con;
    reg	channel_con_en;
    
    output	[7:0]ip_port_con;
		output	ip_port_con_en;
		
		reg	[7:0]ip_port_con;
		reg	ip_port_con_en;
		
		output 	rate_con_start;
		output 	rate_con_end;
		
		reg	rate_con_start;
		reg	rate_con_end;
		
		output 	[31:0]sfp1_ip;
		output 	[31:0]sfp2_ip;
		output 	[31:0]sfp3_ip;
		output 	[31:0]sfp4_ip;
		
		
		reg 	[31:0]sfp1_ip;
		reg 	[31:0]sfp2_ip;
		reg 	[31:0]sfp3_ip;
		reg 	[31:0]sfp4_ip;
		
		output 	[7:0]reply_con;
		output	reply_con_en;
		
		reg	[7:0]reply_con;
		reg	reply_con_en;
		
		reg	[7:0]con_din_r,con_din_rr,con_din_rrr,con_din_rrrr;
		reg	reply_en;
		
		
		reg	[15:0]	con_cnt;
		
		reg	[3:0]cmd_cstate;
		reg	[3:0]cmd_nstate;
		
		parameter	IDLE=0,
							READ_CON=1,
							WRITE_CON=2,
							SI_READ=3,
							NIT_CONF=4,
							FRE_CONF=5,
							IP_PORT_CONF=6,
							RATE_READ=7,
							GBE_IP_CON=8;
		
		
		always@(posedge clk)begin
			if(rst)
				con_cnt	<=	0;
			else	if(con_din_en)
				con_cnt	<=	con_cnt+16'h1;
			else
				con_cnt	<=	0;
		end
		
		always@(posedge clk)begin
			con_din_r	<=	con_din;
			con_din_rr	<=	con_din_r;
			con_din_rrr	<=	con_din_rr;
			con_din_rrrr	<=	con_din_rrr;
		end
		
		
		always@(posedge clk)begin
			if(con_cnt==3 && con_din==8'h01)
				reply_en	<=1;
			else if(con_cnt<11)
				reply_en	<=reply_en;
			else
				reply_en	<=0;
		end
		
		always@(posedge clk)begin
			if(reply_en)begin
				reply_con	<=	con_din_rrrr;
				reply_con_en	<=	1;
			end
			else begin
				reply_con	<=	0;
				reply_con_en	<=	0;
			end
		end
		
		
		always@(posedge clk)begin
			if(rst)
				cmd_cstate	<=	IDLE;
			else
				cmd_cstate	<=	cmd_nstate;
		end
		
		
		always@(*)begin
			case(cmd_cstate)
				IDLE:
					if(con_cnt==0 && con_din_en)begin
						if(con_din==8'h04)
							cmd_nstate	=	READ_CON;
						else	if(con_din==8'h40)
							cmd_nstate	=	WRITE_CON;
						else
							cmd_nstate	=	IDLE;
					end
					else
						cmd_nstate	=	IDLE;
				READ_CON:
					if(con_din==8'h01)
						cmd_nstate	=	SI_READ;
					else if(con_din==8'h05)
						cmd_nstate	=	RATE_READ;
					else
						cmd_nstate	=	IDLE;
				WRITE_CON:
					if(con_din==8'h02)
						cmd_nstate	=	NIT_CONF;
					else if(con_din==8'h03)
						cmd_nstate	=	FRE_CONF;
					else if(con_din==8'h04)
						cmd_nstate	=	IP_PORT_CONF;
					else if(con_din==8'h06)
						cmd_nstate	=	GBE_IP_CON;
					else
						cmd_nstate	=	IDLE;
					SI_READ:
						if(!con_din_en)
							cmd_nstate	=	IDLE;
						else
							cmd_nstate	=	SI_READ;
					NIT_CONF:
						if(!con_din_en)
							cmd_nstate	=	IDLE;
						else
							cmd_nstate	=	NIT_CONF;
					FRE_CONF:
						if(!con_din_en)
							cmd_nstate	=	IDLE;
						else
							cmd_nstate	=	FRE_CONF;
					IP_PORT_CONF:
						if(!con_din_en)
							cmd_nstate	=	IDLE;
						else
							cmd_nstate	=	IP_PORT_CONF;
					RATE_READ:
						if(!con_din_en)
							cmd_nstate	=	IDLE;
						else
							cmd_nstate	=	RATE_READ;	
					GBE_IP_CON:
						if(!con_din_en)
							cmd_nstate	=	IDLE;
						else
							cmd_nstate	=	GBE_IP_CON;			
				default:
					cmd_nstate	=	IDLE;
		
			endcase
		end
		
		
		
		always@(posedge clk)begin
			if(cmd_cstate==SI_READ && con_cnt>7)begin
				si_get_con	<= con_din;
				si_get_con_en	<=	con_din_en;
			end
			else begin
				si_get_con	<= 0;
				si_get_con_en	<=	0;
			end
		end
		
		always@(posedge clk)begin
			if(cmd_cstate==NIT_CONF && con_cnt>4)begin
				nit_con	<= con_din;
				nit_con_en	<=	con_din_en;
			end
			else begin
				nit_con	<= 0;
				nit_con_en	<=	0;
			end
		end
		
		
		always@(posedge clk)begin
			if(cmd_cstate==SI_READ && con_cnt>7)begin
				si_get_con	<= con_din;
				si_get_con_en	<=	con_din_en;
			end
			else begin
				si_get_con	<= 0;
				si_get_con_en	<=	0;
			end
		end
		
		
		always@(posedge clk)begin
			if(cmd_cstate==FRE_CONF && con_cnt>7)begin
				freq_con	<=	con_din;
				freq_con_en	<=	con_din_en;
			end
			else begin
				freq_con	<=	0;
				freq_con_en	<=	0;
			end
		end
		
		always@(posedge clk)begin
			if(cmd_cstate==IP_PORT_CONF)begin
				if(con_cnt==8||con_cnt==9)begin
					channel_con	<=con_din;
					channel_con_en	<=1;
				end
				else begin
					channel_con	<=0;
					channel_con_en	<=0;
				end
			end
			else begin
				channel_con	<=0;
				channel_con_en	<=0;
			end
		end
		
		
		always@(posedge clk)begin
			if(cmd_cstate==IP_PORT_CONF && con_cnt>9)begin
				ip_port_con	<= con_din;
				ip_port_con_en	<=con_din_en;
			end
			else begin
				ip_port_con	<= 0;
				ip_port_con_en	<=0;
			end
		end
		
		always@(posedge clk)begin
			if(cmd_cstate==RATE_READ && con_cnt==8 && con_din==8'h01)
				rate_con_start	<=1;
			else 
				rate_con_start	<=0;
		end
		
		always@(posedge clk)begin
			if(cmd_cstate==RATE_READ && con_cnt==8 && con_din==8'h00)
				rate_con_end	<=1;
			else 
				rate_con_end	<=0;
		end
		
		
		always@(posedge clk)begin
			if(rst)
				sfp1_ip	<=	32'hc0120820;
			else if(cmd_cstate==GBE_IP_CON )begin
				if(con_cnt==9||con_cnt==10||con_cnt==11||con_cnt==12)
					sfp1_ip	<={sfp1_ip[23:0],con_din};
				else
					sfp1_ip	<=sfp1_ip;
			end
			else 
				sfp1_ip	<=	sfp1_ip;				
		end		
		
		
		always@(posedge clk)begin
			if(rst)
				sfp2_ip	<=	32'hc0120821;
			else if(cmd_cstate==GBE_IP_CON )begin
				if(con_cnt==17||con_cnt==14||con_cnt==15||con_cnt==16)
					sfp2_ip	<={sfp2_ip[23:0],con_din};
				else
					sfp2_ip	<=sfp2_ip;
			end
			else 
				sfp2_ip	<=	sfp2_ip;				
		end
		
		always@(posedge clk)begin
			if(rst)
				sfp3_ip	<=	32'hc0120822;
			else if(cmd_cstate==GBE_IP_CON )begin
				if(con_cnt==19||con_cnt==20||con_cnt==21||con_cnt==22)
					sfp3_ip	<={sfp3_ip[23:0],con_din};
				else
					sfp3_ip	<=sfp3_ip;
			end
			else 
				sfp3_ip	<=	sfp3_ip;				
		end
		
		always@(posedge clk)begin
			if(rst)
				sfp4_ip	<=	32'hc0120823;
			else if(cmd_cstate==GBE_IP_CON )begin
				if(con_cnt==24||con_cnt==25||con_cnt==26||con_cnt==27)
					sfp4_ip	<={sfp4_ip[23:0],con_din};
				else
					sfp4_ip	<=sfp4_ip;
			end
			else 
				sfp4_ip	<=	sfp4_ip;				
		end

endmodule
