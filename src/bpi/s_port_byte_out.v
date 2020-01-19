`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		sunyongqin
// 
// Create Date:    2011-3-19 16:43:56 
// Design Name: 
// Module Name:    s_port_byte_in 
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

module s_port_byte_out # 
	(
		parameter 	PERIOD_VALUE 		= 15'h43d1
	)
(
	input			clk			,
	input			reset		,
	
	input	[7:0]	byte_in		,
	input			byte_in_en	,
	
	output	reg		s_out		,
	output	reg		tx_end		
);
//------------------------------------------
	reg	[14:0]		period_cnt	;
	reg				send_point	;
	reg	[10:0]		send_data	;
	reg	[3:0]		send_cnt	;

	reg				state		;
	parameter		IDLE_S = 0;
	parameter   	SEND_DATA_S	= 1;
	
//-----------------------------------------	
	always @ (posedge clk)
	begin
		if(state == IDLE_S)
			period_cnt <= 0;
		else if(period_cnt == PERIOD_VALUE)
			period_cnt <= 0;
		else
			period_cnt <= period_cnt  + 1;
	end
	
	always @ (posedge clk)
	begin
		if(period_cnt == PERIOD_VALUE)
			send_point  <= 1'b1;
		else
			send_point	<= 1'b0;
	end

	always @ (posedge clk)
	begin
		if(reset)
		begin
			state 	<= IDLE_S	;
			s_out 	<= 1'b1		;
			tx_end	<= 1'b0		;
		end
		else
		begin
			case(state)
				IDLE_S:
				begin
					s_out 	<= 1'b1	;
					tx_end	<= 1'b0	;
					send_cnt<= 4'd0 ; 
					
					if(byte_in_en)
					begin
						send_data <= {1'b1,^byte_in,byte_in[7:0],1'b0}; //even parity
						state	  <= SEND_DATA_S ;
					end
					else
						state <= IDLE_S	;
				end	
				SEND_DATA_S:
				begin
					if(send_point)
					begin
						s_out			<= send_data[0]	;
						send_data[10:0] <= {1'b1,send_data[10:1]};
						send_cnt		<= send_cnt + 1;
						if(send_cnt == 4'd11)
						begin
							state 	<= IDLE_S	;	
							tx_end  <= 1'b1;
						end				
						else
							state	  <= SEND_DATA_S ;
					end					
					else
					begin
						s_out	  <= s_out		;
						send_data <= send_data	;
						send_cnt  <= send_cnt	;					
						state	  <= SEND_DATA_S ;
					end
					
				end
			default:state <= IDLE_S	;
			endcase
		end
	end
endmodule