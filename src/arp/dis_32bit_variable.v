`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:16:21 08/31/2011 
// Design Name: 
// Module Name:    dis_33bit_variable 
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
module dis_32bit_variable(

		dout_32bit,
		
		dout_port1_en,
		dout_port2_en,
		dout_port3_en,
		dout_port4_en,
		dout_port5_en,
		dout_port6_en,
		dout_port7_en,
		dout_port8_en,
		dout_port9_en,
		dout_port10_en,
		dout_port11_en,
		dout_port12_en,
		dout_port13_en,
		dout_port14_en,
		dout_port15_en,
		dout_port16_en,
		dout_port17_en,
		dout_port18_en,
		dout_port19_en,
		dout_port20_en,
		
		find_mac_dout,
		dis_fifo_empty_dout,
    	
		arp_ip_dout,
		arp_netport_dout,
		arp_dout_en,
		
		din_32bit,
		din_32bit_en,
	    
		arp_mac_din,
		arp_mac_din_en,
		arp_del_din_en,
		
//		wr_next,//test_port
//		rd_current,//test_port
//		fifo_dout,//test_port
//		netport_num,//test_port
//		rd_fifo_en,//test_port
		
		rst,
//		clk_main,
//		clk_net
		clk
	);
	
	output	reg	[31:0]	dout_32bit;
	
	output	reg			dout_port1_en;	
	output  reg			dout_port2_en;
	output	reg			dout_port3_en;	
	output  reg			dout_port4_en;
	output	reg			dout_port5_en;	
	output  reg			dout_port6_en;
	output	reg			dout_port7_en;	
	output  reg			dout_port8_en;
	output	reg			dout_port9_en;	
	output  reg			dout_port10_en;
	output	reg			dout_port11_en;	
	output  reg			dout_port12_en;
	output	reg			dout_port13_en;	
	output  reg			dout_port14_en;
	output	reg			dout_port15_en;	
	output  reg			dout_port16_en;
	output	reg			dout_port17_en;	
	output  reg			dout_port18_en;
	output	reg			dout_port19_en;	
	output  reg			dout_port20_en;
	
	output				find_mac_dout;
	output				dis_fifo_empty_dout;	
	
	output		[31:0]	arp_ip_dout;
	output		[23:0]	arp_netport_dout;
	output	reg			arp_dout_en;
	
	input		[31:0]	din_32bit;
	input				din_32bit_en;
	
	input		[47:0]	arp_mac_din;
	input				arp_mac_din_en;
	input				arp_del_din_en;
	
	input				rst;
//	input				clk_main;
//	input				clk_net;
	input				clk;
	
//	output		[2:0]	wr_next;//test_port
//	output		[2:0]	rd_current;//test_port
//	output		[33:0]	fifo_dout;//test_port
//	output		[23:0]	netport_num;//test_port
//	output				rd_fifo_en;//test_port
	
assign	find_mac_dout = (rd_current == SEND_MAC_H);	
assign	dis_fifo_empty_dout = fifo_empty;
	
/**************************************************************************************************/
//Write Fifo
	
	reg			[2:0]	wr_current;
	reg			[2:0]	wr_next;
	
	reg			[33:0]	fifo_din;
	reg					wr_fifo_en;
	reg					din_32bit_en_reg;
	
	wire				fifo_prog_full;
	
	parameter	WR_IDLE	= 3'd0,
				WR_HEAD	= 3'd1,
				WR_DATA	= 3'd2,
				WR_FIN1 = 3'd3,
				WR_FIN2 = 3'd4;
	
always@(posedge clk)
begin
	if(rst)
		din_32bit_en_reg <= 0;
	else
		din_32bit_en_reg <= din_32bit_en;
end
	
always@(posedge clk)
begin
	if(rst)
		wr_current <= WR_IDLE;
	else
		wr_current <= wr_next;
end

always@(wr_current or din_32bit_en or din_32bit_en_reg or fifo_prog_full)
begin
	case(wr_current)

		WR_IDLE:	if(din_32bit_en == 1'b1 && din_32bit_en_reg == 1'b0 && fifo_prog_full == 1'b0)
						wr_next = WR_HEAD;
					else
						wr_next = WR_IDLE;
					
		WR_HEAD:	wr_next = WR_DATA;
						
		WR_DATA:	if(din_32bit_en == 1'b0)
						wr_next = WR_FIN1;
					else
						wr_next = WR_DATA;
						
		WR_FIN1:	wr_next = WR_FIN2;
		
		WR_FIN2:	wr_next = WR_IDLE;
		
		default:	wr_next = WR_IDLE;
		
	endcase					
end

always@(posedge clk)
begin
	case(wr_next)
		WR_IDLE:	begin	wr_fifo_en <= 1'b0;	fifo_din <= 0;					end
		WR_HEAD:	begin	wr_fifo_en <= 1'b1;	fifo_din <= {2'b01,din_32bit};	end
		WR_DATA:	begin	wr_fifo_en <= 1'b1;	fifo_din <= {2'b00,din_32bit};	end
		WR_FIN1:	begin	wr_fifo_en <= 1'b1;	fifo_din <= {2'b10,32'hffff};	end
		WR_FIN2:	begin	wr_fifo_en <= 1'b1;	fifo_din <= {2'b10,32'hffff};	end
		default:	begin	wr_fifo_en <= 1'b0;	fifo_din <= 0;					end
	endcase
end

/***************************************************************************************************/
//Read Fifo

	reg			[15:0]	mac_low_16bit;
	reg			[23:0]	netport_num;
	
	reg					rd_fifo_en;
	reg					head_sign;
	
	reg			[2:0]	rd_current;
	reg			[2:0]	rd_next;
	
	wire		[33:0]	fifo_dout;
	wire				fifo_empty;
	
	parameter	RD_IDLE		= 3'd0,
				RD_NETPORT	= 3'd1,
				RD_ARP		= 3'd2,
				RD_WAIT_RES	= 3'd3,
				SEND_MAC_H	= 3'd4,
				SEND_MAC_L	= 3'd5,
				SEND_DATA	= 3'd6,
				RD_DEL		= 3'd7;
	
assign	arp_ip_dout = fifo_dout[31:0];
assign	arp_netport_dout = netport_num[23:0];	
	
always@(posedge clk)
begin
	if(rst)
		rd_current <= RD_IDLE;
	else
		rd_current <= rd_next;
end

always@(rd_current or fifo_empty or head_sign or arp_mac_din_en or arp_del_din_en or fifo_dout[33])
begin
	case(rd_current)
	
		RD_IDLE:		if(fifo_empty == 1'b0)
							rd_next = RD_NETPORT;
						else
							rd_next = RD_IDLE;
							
		RD_NETPORT:		if(head_sign == 1'b1)
							rd_next = RD_ARP;
						else
							if(fifo_empty == 1'b1)
								rd_next = RD_IDLE;
							else
								rd_next = RD_NETPORT;
							
		RD_ARP:			rd_next = RD_WAIT_RES;
		
		RD_WAIT_RES:	case({arp_mac_din_en,arp_del_din_en})
							2'b00:		rd_next = RD_WAIT_RES;
							2'b01:		rd_next = RD_DEL;		
							2'b10:		rd_next = SEND_MAC_H;	
							2'b11:		rd_next = RD_DEL;		
							default:	rd_next = RD_DEL;		
						endcase	
						
		SEND_MAC_H:		rd_next = SEND_MAC_L;
			
		SEND_MAC_L:		rd_next = SEND_DATA;
		
		SEND_DATA:		if(fifo_dout[33] == 1'b1)
							rd_next = RD_IDLE;	
						else
							rd_next = SEND_DATA;
						
						
		RD_DEL:			if(fifo_dout[33] == 1'b1)
							rd_next = RD_IDLE;	
						else
							rd_next = RD_DEL;
						
		default:		rd_next = RD_IDLE;	
		
	endcase							
end

always@(posedge clk)
begin
	case(rd_next)
		RD_NETPORT:		if(fifo_dout[32])
							rd_fifo_en <= 1'b0;
						else
							rd_fifo_en <= 1'b1;
		SEND_MAC_L:		rd_fifo_en <= 1'b1;
		SEND_DATA:		rd_fifo_en <= 1'b1;
		RD_DEL:			rd_fifo_en <= 1'b1;
		default:		rd_fifo_en <= 1'b0;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		begin
							mac_low_16bit <= 16'b0;
							netport_num <= 8'b0;
							arp_dout_en <= 1'b0;
							head_sign <= 1'b0;
						end
		RD_NETPORT:		begin
							mac_low_16bit <= 16'b0;
//							netport_num[23:0] <= {12'h000,fifo_dout[7:0],4'h0};
							netport_num[23:0] <= fifo_dout[23:0];
							arp_dout_en <= 1'b0;
							head_sign <= fifo_dout[32];
						end
		RD_ARP:			begin
							mac_low_16bit <= 16'b0;
							netport_num <= netport_num;
							arp_dout_en <= 1'b1;
							head_sign <= head_sign;
						end
		SEND_MAC_H:		begin
							mac_low_16bit <= arp_mac_din[15:0];
							netport_num <= netport_num;
							arp_dout_en <= 1'b0;
							head_sign <= head_sign;
						end
		default:		begin
							mac_low_16bit <= mac_low_16bit;
							netport_num <= netport_num;
							arp_dout_en <= 1'b0;
							head_sign <= head_sign;
						end
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		SEND_MAC_H:		dout_32bit <= arp_mac_din[47:16];	
		SEND_MAC_L:		dout_32bit <= mac_low_16bit;		
		SEND_DATA:		dout_32bit <= fifo_dout[31:0];		
		default:		dout_32bit <= 0;					
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port1_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[0])
							dout_port1_en <= 1'b1;
						else
							dout_port1_en <= 1'b0;
		default:		dout_port1_en <= dout_port1_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port2_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[1])
							dout_port2_en <= 1'b1;
						else
							dout_port2_en <= 1'b0;
		default:		dout_port2_en <= dout_port2_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port3_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[2])
							dout_port3_en <= 1'b1;
						else
							dout_port3_en <= 1'b0;
		default:		dout_port3_en <= dout_port3_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port4_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[3])
							dout_port4_en <= 1'b1;
						else
							dout_port4_en <= 1'b0;
		default:		dout_port4_en <= dout_port4_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port5_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[4])
							dout_port5_en <= 1'b1;
						else
							dout_port5_en <= 1'b0;
		default:		dout_port5_en <= dout_port5_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port6_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[5])
							dout_port6_en <= 1'b1;
						else
							dout_port6_en <= 1'b0;
		default:		dout_port6_en <= dout_port6_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port7_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[6])
							dout_port7_en <= 1'b1;
						else
							dout_port7_en <= 1'b0;
		default:		dout_port7_en <= dout_port7_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port8_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[7])
							dout_port8_en <= 1'b1;
						else
							dout_port8_en <= 1'b0;
		default:		dout_port8_en <= dout_port8_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port9_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[8])
							dout_port9_en <= 1'b1;
						else
							dout_port9_en <= 1'b0;
		default:		dout_port9_en <= dout_port9_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port10_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[9])
							dout_port10_en <= 1'b1;
						else
							dout_port10_en <= 1'b0;
		default:		dout_port10_en <= dout_port10_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port11_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[10])
							dout_port11_en <= 1'b1;
						else
							dout_port11_en <= 1'b0;
		default:		dout_port11_en <= dout_port11_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port12_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[11])
							dout_port12_en <= 1'b1;
						else
							dout_port12_en <= 1'b0;
		default:		dout_port12_en <= dout_port12_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port13_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[12])
							dout_port13_en <= 1'b1;
						else
							dout_port13_en <= 1'b0;
		default:		dout_port13_en <= dout_port13_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port14_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[13])
							dout_port14_en <= 1'b1;
						else
							dout_port14_en <= 1'b0;
		default:		dout_port14_en <= dout_port14_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port15_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[14])
							dout_port15_en <= 1'b1;
						else
							dout_port15_en <= 1'b0;
		default:		dout_port15_en <= dout_port15_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port16_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[15])
							dout_port16_en <= 1'b1;
						else
							dout_port16_en <= 1'b0;
		default:		dout_port16_en <= dout_port16_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port17_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[16])
							dout_port17_en <= 1'b1;
						else
							dout_port17_en <= 1'b0;
		default:		dout_port17_en <= dout_port17_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port18_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[17])
							dout_port18_en <= 1'b1;
						else
							dout_port18_en <= 1'b0;
		default:		dout_port18_en <= dout_port18_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port19_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[18])
							dout_port19_en <= 1'b1;
						else
							dout_port19_en <= 1'b0;
		default:		dout_port19_en <= dout_port19_en;
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		RD_IDLE:		dout_port20_en <= 1'b0;
		SEND_MAC_H:		if(netport_num[19])
							dout_port20_en <= 1'b1;
						else
							dout_port20_en <= 1'b0;
		default:		dout_port20_en <= dout_port20_en;
	endcase
end

fifo_34bit_variable		fifo_34bit_variable_inst
	(	
		.dout		(fifo_dout		),
		.rd_en		(rd_fifo_en		),
		
		.din		(fifo_din		),
		.wr_en		(wr_fifo_en		),
		
		.full		(),
		.prog_full	(fifo_prog_full	),
		.empty		(fifo_empty		),
		
		.rst		(rst			),
//		.wr_clk		(clk_main		),
//		.rd_clk		(clk_net		),
		.clk		(clk			)
	);

endmodule