`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:49:51 05/19/2011 
// Design Name: 
// Module Name:    fifo_32bit 
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
module fifo_32bit(
				
		dout_33bit,
		
		dout_port1_en,
		dout_port2_en,
		dout_port3_en,
		dout_port4_en,
		dout_port5_en,
		dout_port6_en,
		dout_port7_en,
		dout_port8_en,

		arp_ip_dout,
		arp_port_num_dout,
		arp_dout_en,
		
		din_33bit,
		din_33bit_en,
		
		arp_mac_din,
		arp_mac_din_en,
		arp_del_din_en,
		
//		current_state,//test_port
//		rd_fifo_en,//test_port
//		fifo_dout,//test_port
//		data_cnt,//test_port
//		net_port_num,//test_port
//		fifo_empty//test_port
		
		rst,
		clk_main,
		clk_net
		);

	output	reg	[32:0]	dout_33bit;
	
	output	reg			dout_port1_en;	
	output  reg			dout_port2_en;
	output	reg			dout_port3_en;	
	output  reg			dout_port4_en;
	output	reg			dout_port5_en;	
	output  reg			dout_port6_en;
	output	reg			dout_port7_en;	
	output  reg			dout_port8_en;
	
	output		[31:0]	arp_ip_dout;
	output		[3:0]	arp_port_num_dout;
	output	reg			arp_dout_en;	
	
	input		[32:0]	din_33bit;
	input				din_33bit_en;
	
	input		[47:0]	arp_mac_din;
	input				arp_mac_din_en;
	input				arp_del_din_en;
	
	input				rst;
	input				clk_main;
	input				clk_net;
	
//	output		[2:0]	current_state;//test_port
//	output				rd_fifo_en;//test_port  
//	output		[32:0]	fifo_dout;//test_port   
//	output		[5:0]	data_cnt;//test_port 
//	output		[7:0]	net_port_num;//test_port
//	output				fifo_empty;//test_port
	
	reg			[5:0]	data_cnt;
	
	reg					rd_fifo_en;
	
	reg			[15:0]	mac_low_16bit;
	reg			[7:0]	net_port_num;
	
	reg			[2:0]	current_state;
	reg			[2:0]	next_state;
	
	wire		[32:0]	fifo_dout;
	wire				fifo_empty;
	
	parameter	DATA_LENGTH = 6'd50,
				DATA_MAX = DATA_LENGTH - 6'd1;
	
	parameter	IDLE 		 = 3'b000,
				RD_NET_PORT  = 3'b001,
				SEND_ARP_IP	 = 3'b010,
				WAIT_ARP_RES = 3'b011,
				SEND_MAC_H	 = 3'b100,
				SEND_MAC_L	 = 3'b101,
				SEND_DATA	 = 3'b110,
				DEL_DATA	 = 3'b111;
	
/***********************************************************************************/
//Finite State Machine;
	
always@(posedge clk_net)
begin
	if(rst)
	begin
		current_state <= IDLE;
	end
	else
	begin
		current_state <= next_state;
	end
end

always@(current_state or fifo_empty or net_port_num[7] or arp_mac_din_en or arp_del_din_en or data_cnt or rst)
begin
	if(rst)
	begin
		next_state = IDLE;
	end
	else
	begin
		case(current_state)
			
			IDLE:			begin
								if(fifo_empty == 1'b0)
								begin
									next_state = RD_NET_PORT;
								end
								else
								begin
									next_state = IDLE;
								end
							end
							
			RD_NET_PORT:	begin
								if(net_port_num[7] == 1'b1)
								begin
									next_state = SEND_ARP_IP;
								end
								else
								begin
									if(fifo_empty == 1'b1)
									begin
										next_state = IDLE;
									end
									else
									begin
										next_state = RD_NET_PORT;
									end
								end
							end
							
			SEND_ARP_IP:	begin	next_state = WAIT_ARP_RES;	end
							
			WAIT_ARP_RES:	begin
								case({arp_mac_din_en,arp_del_din_en})
									2'b00:		begin	next_state = WAIT_ARP_RES;	end
									2'b01:		begin	next_state = DEL_DATA;		end
									2'b10:		begin	next_state = SEND_MAC_H;	end
									2'b11:		begin	next_state = DEL_DATA;		end
								endcase
							end
							
			SEND_MAC_H:		begin	next_state = SEND_MAC_L;	end
			
			SEND_MAC_L:		begin	next_state = SEND_DATA;		end
			
			SEND_DATA:		begin
								if(data_cnt == DATA_MAX)
								begin
									next_state = IDLE;	
								end
								else
								begin
									next_state = SEND_DATA;
								end
							end
							
			DEL_DATA:		begin
								if(data_cnt == DATA_MAX - 1'b1)
								begin
									next_state = IDLE;	
								end
								else
								begin
									next_state = DEL_DATA;
								end
							end
							
			default:		begin	next_state = IDLE;	end
		endcase
	end
end

/***********************************************************************************/
//data_counter;

always@(posedge clk_net)
begin
	case(next_state)
		SEND_DATA:			begin	data_cnt <= data_cnt + 1'b1;	end
		DEL_DATA:			begin	data_cnt <= data_cnt + 1'b1;	end
		default:			begin	data_cnt <= 6'b0;				end
	endcase
end

/***********************************************************************************/
//Read Fifo;		

always@(posedge clk_net)
begin
	case(next_state)
		RD_NET_PORT:	begin
							if(fifo_dout[32])
							begin
								rd_fifo_en <= 1'b0;
							end
							else
							begin
								rd_fifo_en <= 1'b1;
							end
						end
		SEND_MAC_L:		begin	rd_fifo_en <= 1'b1;	end
		SEND_DATA:		begin
							if(data_cnt >= DATA_MAX - 6'd2)
							begin
								rd_fifo_en <= 1'b0;
							end
							else
							begin
								rd_fifo_en <= 1'b1;
							end
						end
		DEL_DATA:		begin	rd_fifo_en <= 1'b1;	end
		default:		begin	rd_fifo_en <= 1'b0;	end
	endcase	
end

fifo_33bit	fifo_33bit_inst
	(	
		.rst		(rst			),
		.wr_clk		(clk_main		),
		.rd_clk		(clk_net		),
		
		.din		(din_33bit		),
		.wr_en		(din_33bit_en	),
		
		.dout		(fifo_dout		),
		.rd_en		(rd_fifo_en		),
		
		.full		(),
		.empty		(fifo_empty		)
	);

/*******************************************************************************/
//Get Mac;

assign	arp_ip_dout = fifo_dout[31:0];
assign	arp_port_num_dout = net_port_num[3:0];

always@(posedge clk_net)
begin
	case(next_state)
		IDLE:			begin
							mac_low_16bit <= 16'b0;
							net_port_num <= 8'b0;
							arp_dout_en <= 1'b0;
						end
		RD_NET_PORT:	begin
							mac_low_16bit <= 16'b0;
							net_port_num[6:0] <= fifo_dout[6:0];
							net_port_num[7] <= fifo_dout[32];
							arp_dout_en <= 1'b0;
						end
		SEND_ARP_IP:	begin
							mac_low_16bit <= 16'b0;
							net_port_num <= net_port_num;
							arp_dout_en <= 1'b1;
						end
		SEND_MAC_H:		begin
							mac_low_16bit <= arp_mac_din[15:0];
							net_port_num <= net_port_num;
							arp_dout_en <= 1'b0;
						end
		default:		begin
							mac_low_16bit <= mac_low_16bit;
							net_port_num <= net_port_num;
							arp_dout_en <= 1'b0;
						end
	endcase
end

/******************************************************************************/
//Send Data;

always@(posedge clk_net)
begin
	case(next_state)
		SEND_MAC_H:		begin	dout_33bit <= {1'b1,arp_mac_din[47:16]};	end
		SEND_MAC_L:		begin	dout_33bit <= {17'b0,mac_low_16bit};	end
		SEND_DATA:		begin	dout_33bit <= fifo_dout;	end
		default:		begin	dout_33bit <= 33'b0;	end
	endcase
end

always@(posedge clk_net)
begin
	case(next_state)
		IDLE:			begin
							dout_port1_en <= 1'b0; 
							dout_port2_en <= 1'b0;
							dout_port3_en <= 1'b0; 
							dout_port4_en <= 1'b0;
							dout_port5_en <= 1'b0; 
							dout_port6_en <= 1'b0;
							dout_port7_en <= 1'b0; 
							dout_port8_en <= 1'b0;
						end
		SEND_MAC_H:		begin
							case(net_port_num[6:0])
								7'd1:		dout_port1_en <= 1'b1;
								7'd2:		dout_port2_en <= 1'b1;
								7'd3:		dout_port3_en <= 1'b1;
								7'd4:		dout_port4_en <= 1'b1;
								7'd5:		dout_port5_en <= 1'b1;
								7'd6:		dout_port6_en <= 1'b1;
								7'd7:		dout_port7_en <= 1'b1;
								7'd8:		dout_port8_en <= 1'b1;
								default:	begin
												dout_port1_en <= 1'b0; 
												dout_port2_en <= 1'b0;
												dout_port3_en <= 1'b0; 
												dout_port4_en <= 1'b0;
												dout_port5_en <= 1'b0; 
												dout_port6_en <= 1'b0;
												dout_port7_en <= 1'b0; 
												dout_port8_en <= 1'b0;
											end 
							endcase
						end
		default:		begin
							dout_port1_en <= dout_port1_en; 
							dout_port2_en <= dout_port2_en;
							dout_port3_en <= dout_port3_en; 
							dout_port4_en <= dout_port4_en;
							dout_port5_en <= dout_port5_en; 
							dout_port6_en <= dout_port6_en;
							dout_port7_en <= dout_port7_en; 
							dout_port8_en <= dout_port8_en;
						end
	endcase
end
	
endmodule
