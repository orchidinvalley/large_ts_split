`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		sunyongqin
// 
// Create Date:    2011-3-19 15:50:55
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
//   115200      125M/115200 = 1085.0694444444444444
//   9600		 166M/9600	= 17361.111040;
//////////////////////////////////////////////////////////////////////////////////

module s_port_byte_in # 
	(
		parameter 	PERIOD_VALUE 		= 15'h43d1 ,//9600
		parameter	PERIOD_VALUE_HALF	= 15'h21e8  //
		//parameter 	ODD_EVEN			= 1     //O ODD_PARITY  1:	EVEN_PARITY	
	)
(
	input				clk				,
	input				reset			,	
	input				s_in			,
		        	
	output	reg	[7:0]	byte_out		,
	output	reg			byte_out_en		,     	
	output	reg			right_parity  	
);

//-------------------------------------------
	reg					s_in_temp1		;
	reg					s_in_temp2		;	
	
	reg		[14:0]		period_cnt		;
	reg					sample_point	;
	reg					parity_check	;
	reg		[3:0]		sample_cnt		;
	reg		[1:0]		state			;
	
	parameter  		IDLE_S 			= 2'd0;
	parameter  		CHECK_START_S 	= 2'd1;
	parameter  		DATA_S 			= 2'd2;
	parameter  		PARITY_CHECK	= 2'd3;	
		
//-------------------------------------------	
	
	always @ (posedge clk)
	begin
		s_in_temp1 <= s_in			;
		s_in_temp2 <= s_in_temp1 	;		
	end	
	
	always @ (posedge clk)
	begin
		if(state == IDLE_S)
			period_cnt <= 0;
		else if(period_cnt == PERIOD_VALUE)	
			period_cnt <= 0;
		else
			period_cnt <= period_cnt + 1;
	end
	
	always @ (posedge clk)
	begin
		if(period_cnt == PERIOD_VALUE_HALF)
			sample_point <= 1;
		else
			sample_point <= 0;
	end
	
	always @ (posedge clk)
	begin
		if(reset)
			state <= IDLE_S	;
		else
			begin
			case(state)
				IDLE_S:
					begin
					
					parity_check 	<= 1'b0;
					byte_out_en		<= 1'b0;
					right_parity	<= 1'b0;
					
					if(s_in_temp2 && !s_in_temp1)	
						state <= CHECK_START_S;
					else
						state <= IDLE_S ;	
					end				
				CHECK_START_S:
					if(sample_point)
						begin
							if(s_in_temp2)
								state <= IDLE_S ;	
							else
								begin	
								state <= DATA_S ;	
								sample_cnt <= 0 ;
								end
						end
					else
						state <= CHECK_START_S;
				DATA_S:
					begin
						if(sample_point)
						begin
							byte_out[7:0] <= {s_in_temp2,byte_out[7:1]};
							parity_check  <= parity_check + s_in_temp2;							
							sample_cnt 	  <= sample_cnt + 1;
							if(sample_cnt == 4'd7)
								state <= PARITY_CHECK ;
							else	
								state <= DATA_S ;							
						end
						else
						begin
							byte_out 	<= byte_out;
							sample_cnt 	<= sample_cnt;
							state 		<= DATA_S ;
						end				
					end
				PARITY_CHECK:
					begin
						if(sample_point)
						begin
							state 		<= IDLE_S;
							byte_out_en	<= 1'b1;
							if(parity_check == s_in_temp2)
								right_parity <= 1'b1;
							else
								right_parity <= 1'b0;	
						end
						else
						begin
							state <= PARITY_CHECK;
						end
					end			
				default: state <= IDLE_S;
			endcase
			end
	end
endmodule