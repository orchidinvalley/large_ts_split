`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:00:16 02/10/2012 
// Design Name: 
// Module Name:    sfp_gmii_cmd_mux 
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
module sfp_gmii_cmd_mux
(
	input			clk			,
	input			rst			,
	
	input	[7:0]	cmd_in0		,
	input			cmd_in0_en	,
	
	input	[7:0]	cmd_in1		,
	input			cmd_in1_en	,
	
	output reg	[7:0]	tx_data	,
	output reg			tx_data_valid
	
);

	//--------------------------------------
	wire	[7:0]	tx_dout0		;
    wire			tx_dout0_en		;
    reg				tx_ack0			;
    
    wire	[7:0]	tx_dout1		;
    wire			tx_dout1_en		;
    reg				tx_ack1			;
    
    reg		[3:0]	dly_cnt			;
	
	reg	[2:0]	rd_state 		;
    reg	[2:0]	rd_state_temp	;
    
    parameter	RD_IDLE_S   	= 3'd0 ;
    parameter	RD_ACK_S    	= 3'd1 ;
    parameter	RD_ACK_DLY1_S   = 3'd2 ;
    parameter	RD_ACK_DLY2_S   = 3'd3 ;
    parameter   RD_CHAN0_S 	 	= 3'd4 ; 
    parameter   RD_CHAN1_S  	= 3'd5 ; 
    parameter	RD_DLY_S		= 3'd6 ;
	
	//----------------------------------------

	cmd_125_8b_rtn 		cmd_125_8b_rtn_init1
	(
	    .clk			(clk			), 
	    .rst			(rst			), 
	    .rx_din			(cmd_in0		), 
	    .rx_din_en		(cmd_in0_en		), 
	    
	    .tx_ack			(tx_ack0		), 
	    .tx_dout		(tx_dout0		), 
	    .tx_dout_en		(tx_dout0_en	)
    );
    
    
    cmd_125_8b_rtn 		cmd_125_8b_rtn_init2
	(
	    .clk			(clk			), 
	    .rst			(rst			), 
	    .rx_din			(cmd_in1		), 
	    .rx_din_en		(cmd_in1_en		), 
	    
	    .tx_ack			(tx_ack1		), 
	    .tx_dout		(tx_dout1		), 
	    .tx_dout_en		(tx_dout1_en	)
    );

	//--------------------------------------------------
	
	always @ (posedge clk)
	begin
		if(rst)
			rd_state <= RD_IDLE_S ;
		else
		begin	
			case(rd_state)
				RD_IDLE_S:
				begin					
					if(tx_dout0_en)
					begin
						rd_state 		<= RD_ACK_S   ;
						rd_state_temp	<= RD_CHAN0_S ;
					end
					else if(tx_dout1_en)
					begin
						rd_state 		<= RD_ACK_S   ;
						rd_state_temp	<= RD_CHAN1_S ;
					end
					else
						rd_state <= RD_IDLE_S ;
				end
				RD_ACK_S:
					rd_state 	<= RD_ACK_DLY1_S   ;
				RD_ACK_DLY1_S:
					rd_state    <= RD_ACK_DLY2_S  ;
				RD_ACK_DLY2_S:
					rd_state    <= rd_state_temp  ;
				RD_CHAN0_S :
				begin
					if(tx_dout0_en)
						rd_state <= RD_CHAN0_S ;
					else
						rd_state <= RD_DLY_S   ;
				end
				RD_CHAN1_S :
				begin
					if(tx_dout1_en)
						rd_state <= RD_CHAN1_S ;
					else
						rd_state <= RD_DLY_S   ;
				end
				RD_DLY_S:
				begin
					if(dly_cnt == 4'd8)
						rd_state <= RD_IDLE_S ;
					else
						rd_state <= RD_DLY_S  ;
				end			
				default : rd_state <= RD_IDLE_S ;
			endcase
		end
	end

	always @ (posedge clk)
	begin
		if(rd_state == RD_DLY_S)
			dly_cnt <= dly_cnt + 1;
		else
			dly_cnt <= 0;	
	end

	always @ (posedge clk)
	begin
		if(rd_state == RD_ACK_S)
		case(rd_state_temp)
			RD_CHAN0_S: {tx_ack0,tx_ack1} <= 2'b10;
			RD_CHAN1_S: {tx_ack0,tx_ack1} <= 2'b01;
			default:{tx_ack0,tx_ack1} <= 2'b0;
		endcase
		else
			{tx_ack0,tx_ack1} <= 2'b0;
	end

	always @ (posedge clk)
	begin
		case(rd_state)
			RD_CHAN0_S:
			begin	
				tx_data 		<= tx_dout0   ;
				tx_data_valid 	<= tx_dout0_en; 
			end
			RD_CHAN1_S:
			begin	
				tx_data 		<= tx_dout1   ;
				tx_data_valid 	<= tx_dout1_en; 
			end
		default:	
			begin	
				tx_data 		<= 0 ;
				tx_data_valid 	<= 0; 
			end
		endcase
	end

endmodule
