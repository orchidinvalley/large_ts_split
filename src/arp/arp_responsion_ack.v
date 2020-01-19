`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:38:19 05/05/2011 
// Design Name: 
// Module Name:    arp_responsion_ack 
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
module arp_responsion_ack(
	
	arp_dout,
	arp_dout_en,
	
	tx_ip, 
	tx_mac,
	tx_en,  
	
	arp_din,
	arp_din_en,
	
	local_mac,
	local_ip,
	
	tx_ready,
	rx_ack,
	
	rst,
	clk
	
    );
	
	output	reg		[7:0]	arp_dout;     
	output	reg				arp_dout_en;  
				              
	output	reg		[31:0]	tx_ip;        
	output  reg		[47:0]	tx_mac;       
	output  reg				tx_en; 
	
	output					tx_ready;       
	
	input			[7:0]	arp_din;     
	input                   arp_din_en; 
                               
	input           [47:0]  local_mac;   
	input           [31:0]  local_ip;
	
	input					rx_ack;    
	                               
	input                   rst;
	input                   clk;
	                                
	reg				[2:0]	current_state;
	reg				[2:0]	next_state;
	
	reg				[5:0]	arp_cnt;
	reg				[6:0]	send_cnt;
	
	reg						sign;
	
	reg						trig1;
	reg						trig2;
	
	wire					trig;
	
	parameter		DATA_LEN = 7'd64;
	
	parameter		IDLE 			= 3'd0,
					ARP_FRAME		= 3'd1,
    				ARP_CHECK 		= 3'd2,
    				ARP_RES_ACK 	= 3'd3,
    				ARP_RES_READY 	= 3'd4,
    				ARP_RES_SEND 	= 3'd5,
    				ARP_FIN 		= 3'd6;  
    				
assign	tx_ready = (current_state == ARP_RES_READY);

always@(posedge clk)
begin
	if(rst)
		begin
			trig1 <= 1'b0;
			trig2 <= 1'b0;
		end
	else
	begin
		trig2 <= trig1;
		trig1 <= arp_din_en;
	end
end

assign	trig = trig1 && (~trig2);

always@(posedge clk)
begin
	if(next_state == ARP_RES_SEND)
		send_cnt <= send_cnt + 1'b1;
	else
		send_cnt <= 0;
end
			
always@(posedge clk)
begin
	if(arp_din_en)
		arp_cnt <= arp_cnt + 1'b1;
	else
		arp_cnt <= 0;
end

always@(posedge clk)
begin
	if(rst)
		current_state <= IDLE;
	else
		current_state <= next_state;
end

always@(current_state or trig or arp_cnt or arp_din or local_ip or sign or send_cnt or rx_ack)
begin
	case(current_state)
	
		IDLE:			if(trig)
							next_state = ARP_FRAME;
						else
							next_state = IDLE;
	
		ARP_FRAME:		case(arp_cnt)
							
							6'd13:		if(arp_din == 8'h06)
											next_state = ARP_FRAME;
										else
											next_state = IDLE;
									
							6'd14:		next_state = ARP_CHECK;	
							
							default:	next_state = ARP_FRAME;
							
						endcase
					
		ARP_CHECK:		case(arp_cnt)
						
							6'd21:		case(arp_din)
											8'h01:		next_state = ARP_CHECK;	
											8'h02:		next_state = ARP_CHECK;	
											default:	next_state = IDLE;		
										endcase
							6'd22:		next_state = ARP_RES_ACK;
									
							default:	next_state = ARP_CHECK;
							
						endcase
						
		ARP_RES_ACK:	case(arp_cnt)
								
							6'd38:		if(arp_din == local_ip[31:24])
											next_state = ARP_RES_ACK;
										else
											next_state = IDLE;
							
							6'd39:		if(arp_din == local_ip[23:16])
											next_state = ARP_RES_ACK;
										else
											next_state = IDLE;
							
							6'd40:		if(arp_din == local_ip[15:8])
											next_state = ARP_RES_ACK;
										else
											next_state = IDLE;
							
							6'd41:		if(arp_din == local_ip[7:0])
											if(sign == 1'b1)
												next_state = ARP_FIN;
											else
												next_state = ARP_RES_READY;
										else
											next_state = IDLE;
							
							default:	next_state = ARP_RES_ACK;
							
						endcase
						
		ARP_RES_READY:	if(rx_ack == 1'b1)
							next_state = ARP_RES_SEND;
						else
							next_state = ARP_RES_READY;
						
		ARP_RES_SEND:	if(send_cnt == DATA_LEN)
							next_state	= ARP_FIN;
						else
							next_state	= ARP_RES_SEND;
						
		ARP_FIN:		next_state = IDLE;	
		
		default:		next_state = IDLE;
	endcase	
end

always@(posedge clk)
begin
	case(next_state)
		IDLE:		sign <= 1'b0;
		ARP_CHECK:	case(arp_cnt)
						6'd21:		case(arp_din)
										8'h01:		sign <= 1'b0;
										8'h02:		sign <= 1'b1;
										default:	sign <= sign;
									endcase
						default:	sign <= sign;
					endcase	
		default:	sign <= sign;
	endcase	
end

always@(posedge clk)
begin
	case(next_state)
		IDLE:			begin
							tx_ip <= 32'b0;
							tx_mac <= 48'b0;
							tx_en <= 1'b0;
						end
		ARP_RES_ACK:	case(arp_cnt)
							6'd22:		begin	tx_mac[47:40] <= arp_din;	tx_ip <= tx_ip;		tx_en <= 1'b0;	end
							6'd23:		begin	tx_mac[39:32] <= arp_din;	tx_ip <= tx_ip;		tx_en <= 1'b0;	end
							6'd24:		begin	tx_mac[31:24] <= arp_din;	tx_ip <= tx_ip;		tx_en <= 1'b0;	end
							6'd25:		begin	tx_mac[23:16] <= arp_din;	tx_ip <= tx_ip;		tx_en <= 1'b0;	end
							6'd26:		begin	tx_mac[15:8] <= arp_din;	tx_ip <= tx_ip;		tx_en <= 1'b0;	end
							6'd27:		begin	tx_mac[7:0] <= arp_din;		tx_ip <= tx_ip;		tx_en <= 1'b0;	end
							6'd28:		begin	tx_ip[31:24] <= arp_din;	tx_mac <= tx_mac;	tx_en <= 1'b0;	end
							6'd29:		begin	tx_ip[23:16] <= arp_din;	tx_mac <= tx_mac;	tx_en <= 1'b0;	end
							6'd30:		begin	tx_ip[15:8] <= arp_din;		tx_mac <= tx_mac;	tx_en <= 1'b0;	end
							6'd31:		begin	tx_ip[7:0] <= arp_din;		tx_mac <= tx_mac;	tx_en <= 1'b0;	end
							default:	begin	tx_ip <= tx_ip;				tx_mac <= tx_mac;	tx_en <= 1'b0;	end
						endcase
		ARP_FIN:		begin	tx_ip <= tx_ip;	tx_mac <= tx_mac;	tx_en <= 1'b1;	end
							/*if(sign == 1'b1)
							begin
								tx_ip <= tx_ip;
								tx_mac <= tx_mac;	
								tx_en <= 1'b1;	
							end
							else
							begin
								tx_ip <= tx_ip;
								tx_mac <= tx_mac;	
								tx_en <= 1'b0;
							end
						end*/	
		default:		begin	tx_ip <= tx_ip;	tx_mac <= tx_mac;	tx_en <= 1'b0;	end
	endcase
end

always@(posedge clk)
begin
	case(next_state)
		ARP_RES_SEND:		case(send_cnt)
								7'd0:		begin	arp_dout <= tx_mac[47:40];		arp_dout_en <= 1'b1;	end
								7'd1:		begin	arp_dout <= tx_mac[39:32];		arp_dout_en <= 1'b1;	end
								7'd2:		begin	arp_dout <= tx_mac[31:24];		arp_dout_en <= 1'b1;	end
								7'd3:		begin	arp_dout <= tx_mac[23:16];		arp_dout_en <= 1'b1;	end
								7'd4:		begin	arp_dout <= tx_mac[15:8];		arp_dout_en <= 1'b1;	end
								7'd5:		begin	arp_dout <= tx_mac[7:0];		arp_dout_en <= 1'b1;	end
								7'd6:		begin	arp_dout <= local_mac[47:40];	arp_dout_en <= 1'b1;	end
								7'd7:		begin	arp_dout <= local_mac[39:32];	arp_dout_en <= 1'b1;	end
								7'd8:		begin	arp_dout <= local_mac[31:24];	arp_dout_en <= 1'b1;	end
								7'd9:		begin	arp_dout <= local_mac[23:16];	arp_dout_en <= 1'b1;	end
								7'd10:		begin	arp_dout <= local_mac[15:8];	arp_dout_en <= 1'b1;	end
								7'd11:		begin	arp_dout <= local_mac[7:0];		arp_dout_en <= 1'b1;	end
								7'd12:		begin	arp_dout <= 8'h08;				arp_dout_en <= 1'b1;	end
    							7'd13:		begin	arp_dout <= 8'h06;				arp_dout_en <= 1'b1;	end
    							7'd14:		begin	arp_dout <= 8'h00;				arp_dout_en <= 1'b1;	end
    							7'd15:		begin	arp_dout <= 8'h01;				arp_dout_en <= 1'b1;	end
    							7'd16:		begin	arp_dout <= 8'h08;				arp_dout_en <= 1'b1;	end
    							7'd17:		begin	arp_dout <= 8'h00;				arp_dout_en <= 1'b1;	end
    							7'd18:		begin	arp_dout <= 8'h06;				arp_dout_en <= 1'b1;	end
    							7'd19:		begin	arp_dout <= 8'h04;				arp_dout_en <= 1'b1;	end
    							7'd20:		begin	arp_dout <= 8'h00;				arp_dout_en <= 1'b1;	end
    							7'd21:		begin	arp_dout <= 8'h02;				arp_dout_en <= 1'b1;	end
    							7'd22:		begin	arp_dout <= local_mac[47:40];	arp_dout_en <= 1'b1;	end	
    							7'd23:		begin	arp_dout <= local_mac[39:32];	arp_dout_en <= 1'b1;	end	
    							7'd24:		begin	arp_dout <= local_mac[31:24];	arp_dout_en <= 1'b1;	end	
    							7'd25:		begin	arp_dout <= local_mac[23:16];	arp_dout_en <= 1'b1;	end	
    							7'd26:		begin	arp_dout <= local_mac[15:8];	arp_dout_en <= 1'b1; 	end	
    							7'd27:		begin	arp_dout <= local_mac[7:0];		arp_dout_en <= 1'b1;  	end	
    							7'd28:		begin	arp_dout <= local_ip[31:24];	arp_dout_en <= 1'b1; 	end	
    							7'd29:		begin	arp_dout <= local_ip[23:16];	arp_dout_en <= 1'b1; 	end	
    							7'd30:		begin	arp_dout <= local_ip[15:8];		arp_dout_en <= 1'b1;  	end	
    							7'd31:		begin	arp_dout <= local_ip[7:0];		arp_dout_en <= 1'b1;   	end
    							7'd32:		begin	arp_dout <= tx_mac[47:40];		arp_dout_en <= 1'b1;	end
    							7'd33:		begin	arp_dout <= tx_mac[39:32];		arp_dout_en <= 1'b1;	end
    							7'd34:		begin	arp_dout <= tx_mac[31:24];		arp_dout_en <= 1'b1;	end
    							7'd35:		begin	arp_dout <= tx_mac[23:16];		arp_dout_en <= 1'b1;	end
    							7'd36:		begin	arp_dout <= tx_mac[15:8];		arp_dout_en <= 1'b1; 	end
    							7'd37:		begin	arp_dout <= tx_mac[7:0]; 		arp_dout_en <= 1'b1; 	end
    							7'd38:		begin	arp_dout <= tx_ip[31:24];		arp_dout_en <= 1'b1; 	end
    							7'd39:		begin	arp_dout <= tx_ip[23:16];		arp_dout_en <= 1'b1; 	end
    							7'd40:		begin	arp_dout <= tx_ip[15:8]; 		arp_dout_en <= 1'b1; 	end
    							7'd41:		begin	arp_dout <= tx_ip[7:0];  		arp_dout_en <= 1'b1; 	end
    							default:	begin	arp_dout <= 8'b0;				arp_dout_en <= 1'b1;	end
    						endcase
		default:			begin	arp_dout <= 8'b0;	arp_dout_en <= 1'b0;	end
	endcase					
end

endmodule
