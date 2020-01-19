`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:24:47 06/02/2011 
// Design Name: 
// Module Name:    tx_sel 
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
module tx_sel_new
(
	input				clk			,
	input				rst			,
	
	input	[7:0]		udp_din		,
	input				udp_din_en	,
	output	reg			udp_ack		,
	
	input	[7:0]		arp_din		,
	input				arp_din_en	,
	output	reg			arp_ack		,
	
	output	reg [7:0]	tx_dout		,
	output	reg 		tx_dout_en	,
	input				dst_fifo_pfull
);

//--------------------------------------------    
	reg		[2:0]		state		;
	reg		[2:0]		nxt_state	;
	
	parameter       IDLE_S 		= 3'd1;
	parameter       UDP_ACK_S 	= 3'd2;
	parameter       ARP_ACK_S 	= 3'd3;
	parameter       UDP_S 		= 3'd4;
	parameter       ARP_S 		= 3'd5;
	parameter       END_S 		= 3'd6;
	parameter       DLY_S 		= 3'd7;

//-------------------------------------------
	reg	[2:0]	dly_cnt ;
	reg			dly_end	;
//---------------------------------------------


	always @ (posedge clk)
	begin
		if(rst)
			state <= IDLE_S ;
		else
			state <= nxt_state ;
	end
	
	always @ (state or dst_fifo_pfull or udp_din_en or arp_din_en or dly_end)
	begin
		case(state)	
			IDLE_S:
				if(!dst_fifo_pfull)
				begin
					if(udp_din_en)	
						nxt_state <= UDP_ACK_S ;
					else if(arp_din_en)
						nxt_state <= ARP_ACK_S ;
					else
						nxt_state <= IDLE_S ;	
				end
				else
					nxt_state <= IDLE_S ;					
			UDP_ACK_S:
				nxt_state <= UDP_S ;
			ARP_ACK_S:
				nxt_state <= ARP_S ;
			UDP_S :
				if(udp_din_en)
					nxt_state <= UDP_S ;
				else
					nxt_state <= END_S ;			
			ARP_S :
				if(arp_din_en)
					nxt_state <= ARP_S ;
				else
					nxt_state <= END_S ;
			END_S :
				nxt_state <= DLY_S ;
			DLY_S :
				if(dly_end)
					nxt_state <= IDLE_S ;	
				else
					nxt_state <= DLY_S ;
		default : nxt_state <= IDLE_S ;
	endcase
	end
	
	always @ (posedge clk)
	begin
		if(nxt_state == DLY_S)	
			dly_cnt <= dly_cnt + 1;
		else
			dly_cnt <= 0;
	end
	
	always @ (posedge clk)
	begin
		if(dly_cnt == 3'd3)	
			dly_end <= 1'b1;
		else
			dly_end <= 1'b0;	
	end
	
	
	always @ (posedge clk)
	begin
		if(nxt_state == UDP_S && state == UDP_S)	
		begin
			tx_dout 	<= udp_din  ;
			tx_dout_en 	<= 1'b1		;	
		end
		else if(nxt_state == ARP_S &&state == ARP_S)	
		begin
			tx_dout 	<= arp_din  ;
			tx_dout_en 	<= 1'b1		;	
		end
		else
		begin
			tx_dout 	<= 0  ;
			tx_dout_en 	<= 1'b0		;	
		end	
	end
	
	always @ (posedge clk)
	begin
		if(nxt_state == UDP_ACK_S)
			udp_ack <= 1'b1;
		else
			udp_ack <= 1'b0;	
	end
	
	always @ (posedge clk)
	begin
		if(nxt_state == ARP_ACK_S)
			arp_ack <= 1'b1;
		else
			arp_ack <= 1'b0;	
	end
	
	
endmodule