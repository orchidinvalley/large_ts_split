`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:50:01 07/27/2011 
// Design Name: 
// Module Name:    udp_send 
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
module udp_send(
	input	[31:0]		local_ip	,
	input	[47:0]		local_mac	,
	input	[15:0]		local_port	,
	input				clk	,
	input				rst	,
	input	[7:0]		rx_data			,
	input				rx_data_valid	,
	output	reg			rx_ack			,
	output	reg	[7:0]	tx_data			,
	output	reg			tx_data_valid	,
	input				tx_ack
    );
    
    parameter	IDLE_S	= 3'd0,
    			HEAD_S	= 3'd1,
    			SEND_S	= 3'd2,
    			WAIT_S	= 3'd3,
    			FRAME_S	= 3'd4;
    			
   	reg		[2:0]		state		;
   	reg		[2:0]		next_state	;
   	
   	reg		[47:0]		dest_mac	;
   	reg		[31:0]		dest_ip		;
   	reg		[15:0]		dest_port	;
   	reg		[5:0]		cnt			;
   	reg					sel			;
   	reg		[15:0]		frame_len	;
   	reg		[16:0]		ip_checksum	;
   	
   	parameter	BASIC_IP_CKM = 17'hC513;
   	
   	
   	// state machine -----------------------------
   	always @(posedge clk)
   	begin
   		if (rst)
   			state	<= IDLE_S;
   		else
   			state	<= next_state;
   	end
   	
   	always @(*)
   	begin
   		case (state)
   			IDLE_S:
   			begin
   				if (rx_data_valid)
   					next_state	<= HEAD_S;
   				else
   					next_state	<= IDLE_S;
   			end
   			HEAD_S:
   			begin
   				if (rx_data_valid == 1'b0)
   					next_state	<= WAIT_S;
   				else
   					next_state	<= HEAD_S;
   			end
   			WAIT_S:
   			begin
   				if (tx_ack)
   					next_state	<= SEND_S;
   				else
   					next_state	<= WAIT_S;
   			end
   			SEND_S:
   			begin
   				if (sel)
   					next_state	<= FRAME_S;
   				else
   					next_state	<= SEND_S;
   			end
   			FRAME_S:
   			begin
   				if (rx_data_valid == 1'b0)
   					next_state	<= IDLE_S;
   				else
   					next_state	<= FRAME_S;
   			end
   			
   			default:
   			begin
   				next_state	<= IDLE_S;
   			end
   		endcase
   	end
   	
   	// counter -----------------------------------
	always @(posedge clk)
	begin
		if (next_state == HEAD_S)
			cnt	<= cnt + 6'd1;
		else if (next_state == SEND_S)
			cnt	<= cnt + 6'd1;
		else
			cnt	<= 6'd0;
	end
	
	always @(posedge clk)
	begin
		if (next_state == IDLE_S)
			sel	<= 1'b0;
		else if ((next_state == SEND_S)&&(cnt == 6'd41))
			sel	<= sel + 1'b1;
	end
	
	// register ---------------------------------
	always @(posedge clk)
	begin
		if (next_state == HEAD_S)
		begin
			if (cnt < 6'd2)
				frame_len	<= {frame_len[7:0], rx_data};
			else if (cnt == 6'd2)
				frame_len	<= frame_len - 6'd12 + 6'd28;
		end
		else if (cnt == 6'd37)
			frame_len	<= frame_len - 6'd20;
		else
		begin
			frame_len	<= frame_len;
		end
	end
	
	always @(posedge clk)
	begin
		if (next_state == HEAD_S)
		begin
			if ((cnt >= 6'd2)&&(cnt <= 6'd7))
				dest_mac	<= {dest_mac[39:0], rx_data};
			else if ((cnt >= 6'd8)&&(cnt <= 6'd11))
				dest_ip		<= {dest_ip[23:0], rx_data};
			else if ((cnt >= 6'd12)&&(cnt <= 6'd13))
				dest_port	<= {dest_port[7:0], rx_data};
		end
		else
		begin
			dest_mac	<= dest_mac;
			dest_ip		<= dest_ip;
			dest_port	<= dest_port;
		end
	end
	
	// ip checksum -----------------------------
	always @(posedge clk)
	begin
		if (next_state == IDLE_S)
		begin
			ip_checksum	<= BASIC_IP_CKM;
		end
		else if (next_state == SEND_S)
		begin
			case (cnt)
				6'd0	: ip_checksum <= {1'b0, ip_checksum[15:0]} + {1'b0, frame_len} + {16'd0, ip_checksum[16]};
				6'd1	: ip_checksum <= {1'b0, ip_checksum[15:0]} + {1'b0, local_ip[31:16]} + {16'd0, ip_checksum[16]};
				6'd2	: ip_checksum <= {1'b0, ip_checksum[15:0]} + {1'b0, local_ip[15:0]} + {16'd0, ip_checksum[16]};
				6'd3	: ip_checksum <= {1'b0, ip_checksum[15:0]} + {1'b0, dest_ip[31:16]} + {16'd0, ip_checksum[16]};
				6'd4	: ip_checksum <= {1'b0, ip_checksum[15:0]} + {1'b0, dest_ip[15:0]} + {16'd0, ip_checksum[16]};
				6'd5	: ip_checksum <= {1'b0, ip_checksum[15:0]} + {16'd0, ip_checksum[16]};
				6'd6	: ip_checksum <= {1'b0, ip_checksum[15:0]} + {16'd0, ip_checksum[16]};
				6'd7	: ip_checksum <= ~ip_checksum;
			endcase
		end
	end
	
	// output ---------------------------------
	always @(posedge clk)
	begin
		if ((next_state == SEND_S)&&(cnt == 6'd40))
			rx_ack	<= 1'b1;
		else
			rx_ack	<= 1'b0;
	end
	
	always @(posedge clk)
	begin
		if ((next_state == WAIT_S)||(next_state == SEND_S)||(next_state == FRAME_S))
			tx_data_valid	<= 1'b1;
		else
			tx_data_valid	<= 1'b0;
	end
	
	always @(posedge clk)
	begin
		if (next_state == SEND_S)
		begin
			case (cnt)
				6'd0:	tx_data <= dest_mac[47:40];
				6'd1:	tx_data <= dest_mac[39:32];
				6'd2:	tx_data <= dest_mac[31:24];
				6'd3:	tx_data <= dest_mac[23:16];
				6'd4:	tx_data <= dest_mac[15:8];
				6'd5:	tx_data <= dest_mac[7:0];
				6'd6:	tx_data <= local_mac[47:40];
				6'd7:	tx_data <= local_mac[39:32];
				6'd8:	tx_data <= local_mac[31:24];
				6'd9:	tx_data <= local_mac[23:16];
				6'd10:	tx_data <= local_mac[15:8]; 
				6'd11:	tx_data <= local_mac[7:0];  
				6'd12:	tx_data	<= 8'h08;
				6'd13:	tx_data	<= 8'h00;
				
				6'd14:	tx_data	<= 8'h45;
				6'd15:	tx_data	<= 8'h00;
				6'd16:	tx_data <= frame_len[15:8]; 
				6'd17:	tx_data <= frame_len[7:0];  
				6'd18:	tx_data	<= 8'h00;
				6'd19:	tx_data	<= 8'h02;
				6'd20:	tx_data	<= 8'h00;
				6'd21:	tx_data	<= 8'h00;
				6'd22:	tx_data	<= 8'h80;
				6'd23:	tx_data	<= 8'h11;
				6'd24:	tx_data <= ip_checksum[15:8]; 
				6'd25:	tx_data <= ip_checksum[7:0];  
				6'd26:	tx_data <= local_ip[31:24];
				6'd27:	tx_data <= local_ip[23:16];
				6'd28:	tx_data <= local_ip[15:8]; 
				6'd29:	tx_data <= local_ip[7:0];  
				6'd30:	tx_data <= dest_ip[31:24];
				6'd31:	tx_data <= dest_ip[23:16];
				6'd32:	tx_data <= dest_ip[15:8]; 
				6'd33:	tx_data <= dest_ip[7:0];  
				
				6'd34:	tx_data <= local_port[15:8]; 
				6'd35:	tx_data <= local_port[7:0];
				  
				6'd36:	tx_data <= dest_port[15:8]; 
				6'd37:	tx_data <= dest_port[7:0];  
				
				6'd38:	tx_data <= frame_len[15:8]; 
				6'd39:	tx_data <= frame_len[7:0];  
				6'd40:	tx_data	<= 8'h00;
				6'd41:	tx_data	<= 8'h00;
				
			endcase
		end
		else if (next_state == FRAME_S)
		begin
			tx_data	<= rx_data;
		end
		else
		begin
			tx_data	<= tx_data;
		end
	end

endmodule
