`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:46:43 06/07/2011 
// Design Name: 
// Module Name:    coordinate_udp_arp 
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
module coordinate_res_req(
		
		dout,
		dout_en,
		
		res_ack,
		req_ack,
		
		tx_arp_ready,

		res_din,
		res_din_en,
		
		req_din,
		req_din_en,
		
		res_ready,
		req_ready,
		
		rx_arp_ack,
		
//		current_state,
		
		rst,
		clk
		
    );

  		output	reg	[7:0]	dout;       
  		output	reg			dout_en; 
  		
  		output	reg			res_ack;
  		output	reg			req_ack;
  		
  		output				tx_arp_ready;
            
  		input		[7:0]	res_din;    
  		input				res_din_en;
  		
  		input		[7:0]	req_din;	   
  		input				req_din_en; 
  		
  		input				res_ready;
  		input				req_ready;
  		
  		input				rx_arp_ack;  
  		            
  		input				rst;        
  		input				clk;
  		
//  		output		[2:0]	current_state;
  		
  		reg					res_din_en_reg;
  		reg					req_din_en_reg;
  		
  		reg			[7:0]	wait_cnt;
  		
  		reg			[2:0]	current_state;
  		reg			[2:0]	next_state;
  		
  		parameter	WAIT_MAX = 8'd180;
  		
  		parameter	IDLE	 = 3'b000,
  					ACK_WAIT = 3'b001,
  					ACK_SEND = 3'b010,
  					RES_SEND = 3'b011,
  					REQ_SEND = 3'b100; 
  					
assign	tx_arp_ready = (current_state == ACK_WAIT);

always@(posedge clk)
begin
	if(rst)
		res_din_en_reg <= 1'b0;
	else
		res_din_en_reg <= res_din_en;
end 

always@(posedge clk)
begin
	if(rst)
		req_din_en_reg <= 1'b0;
	else
		req_din_en_reg <= req_din_en;
end        
  		
always@(posedge clk)
begin
	if(rst)
		current_state <= IDLE;
	else
		current_state <= next_state;
end

always@(current_state or res_ready or req_ready or rx_arp_ack or res_din_en or req_din_en or res_din_en_reg or 
		req_din_en_reg or wait_cnt )
begin
	case(current_state)
		
		IDLE:		if(res_ready || req_ready)
						next_state = ACK_WAIT;
					else
						next_state = IDLE;
					
		ACK_WAIT:	if(rx_arp_ack)
						next_state = ACK_SEND;
					else
						next_state = ACK_WAIT;
					
		ACK_SEND:	case({req_ready,res_ready})
						2'b00:	next_state = IDLE;		
						2'b01:	next_state = RES_SEND;
						2'b10:	next_state = REQ_SEND;
						2'b11:	next_state = RES_SEND;
					endcase
					
		RES_SEND:	if((res_din_en == 1'b0 && res_din_en_reg == 1'b1) || wait_cnt == WAIT_MAX)
						next_state = ACK_WAIT;
					else
						next_state = RES_SEND;
					
		REQ_SEND:	if((req_din_en == 1'b0 && req_din_en_reg == 1'b1) || wait_cnt == WAIT_MAX)
						next_state = ACK_WAIT;
					else
						next_state = REQ_SEND;
		
		default:	next_state = IDLE;
	
	endcase
end

always@(posedge clk)
begin
	case(next_state)
		RES_SEND:	begin
						dout <= res_din;
						dout_en <= res_din_en;
					end
		REQ_SEND:	begin
						dout <= req_din;
						dout_en <= req_din_en;
					end
		default:	begin
						dout <= 8'b0;
						dout_en <= 1'b0;
					end
	endcase
end

always@(posedge clk)
begin
	case(next_state)
		ACK_SEND:	begin
						case({req_ready,res_ready})
							2'b00:		begin	req_ack <= 1'b0;	res_ack <= 1'b0;	end
							2'b01:		begin	req_ack <= 1'b0;	res_ack <= 1'b1;	end
							2'b10:		begin	req_ack <= 1'b1;	res_ack <= 1'b0;	end
							2'b11:		begin	req_ack <= 1'b0;	res_ack <= 1'b1;	end
						endcase
					end
		default:	begin	req_ack <= 1'b0;	res_ack <= 1'b0;	end	
	endcase
end

always@(posedge clk)
begin
	case(next_state)
		RES_SEND:	begin	wait_cnt <= wait_cnt + 1'b1;	end
		REQ_SEND:	begin	wait_cnt <= wait_cnt + 1'b1;	end
		default:	begin	wait_cnt <= 1'b0;				end
	endcase
end
  		
endmodule
