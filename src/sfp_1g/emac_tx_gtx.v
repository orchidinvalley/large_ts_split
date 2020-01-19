`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:10:50 07/08/2011 
// Design Name: 
// Module Name:    emac_tx 
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
module emac_tx_gtx(
	input				clk	,
	input				rst	,
	input	[7:0]		tx_data	,
	input				tx_data_valid	,
	output	reg			tx_ack	,
	input	[7:0]		crc_data	,
	input				crc_en		,
	
	output	reg	[7:0]	gmii_txd	,
	output	reg			gmii_tx_en	,
	output				gmii_tx_er	
	
    );
    
    parameter		KIDLE_S	= 4'd1,
    				IDLE_S	= 4'd2,
    				PRE_S	= 4'd3,
    				FRAME_S	= 4'd4,
    				CRC_S	= 4'd5,
    				END1_S  = 4'd6,
    				END2_S	= 4'd7,
    				KDLY_S	= 4'd8,
    				DLY_S	= 4'd9,
    				TRAIL_S	= 4'd10;
    				
   	reg		[3:0]		state		;
   	reg		[3:0]		next_state	;
   	reg		[5:0]		cnt			;
   	
//	reg	[7:0]	gmii_txd_r		;
//	reg			gmii_tx_en_r	;
//	reg			gmii_tx_er_r    ;
	reg	[7:0]	tx_data_r		;
	reg			tx_data_valid_r	;
	reg			frame_cnt		;
	reg			end_sel			;
	
	
	always @(posedge clk)
	begin
		tx_data_r			<= tx_data;
		tx_data_valid_r		<= tx_data_valid;
	end
   	
   	// state machine -----------------------
   	always @(posedge clk)
   	begin
   		if (rst)
   			state	<= IDLE_S;
   		else
   			state	<= next_state	;
   	end
   	
   	always @(*)
   	begin
   		case (state)
   			KIDLE_S:
   			begin
   				next_state	= IDLE_S;
   			end
   			IDLE_S:
   			begin
   				if (tx_data_valid_r)
   					next_state	= PRE_S;
   				else
   					next_state	= KIDLE_S;
   			end
   			PRE_S:
   			begin
   				if (cnt == 6'd8)
   					next_state	= FRAME_S;
   				else
   					next_state	= PRE_S;
   			end
   			FRAME_S:
   			begin
   				if (crc_en)
   					next_state	= CRC_S;
   				else if (tx_data_valid_r == 1'b0)
					next_state	= TRAIL_S;
   				else
   					next_state	= FRAME_S;
   			end
   			TRAIL_S:
   			begin
   				if (crc_en)
   					next_state	= CRC_S;
   				else
   					next_state	= TRAIL_S;
   			end
   			CRC_S:
   			begin
   				if (crc_en == 1'b0)
   					next_state	= END1_S;
   				else
   					next_state	= CRC_S;
   			end
   			END1_S:
   			begin
   				next_state	= END2_S;
   			end
   			END2_S:
   			begin
   				if (end_sel)
   				next_state	= KDLY_S;
	   			else
	   				next_state	= END2_S;
   			end
   			KDLY_S:
   			begin
   				next_state	= DLY_S;
   			end
   			DLY_S:
   			begin
   				if (cnt >= 6'd23)
   					next_state	= KIDLE_S;
   				else
   					next_state	= KDLY_S;
   			end
   			
   			default:
   				next_state	= KIDLE_S;
   		endcase
   	end
   	
   	always @(posedge clk)
   	begin
   		if ((next_state == PRE_S)||(next_state == DLY_S)||(next_state == KDLY_S))
   			cnt	<= cnt + 6'd1;
   		else 
   			cnt	<= 6'd0;
   	end
   	
   	always @(posedge clk)
   	begin
   		if ((next_state == FRAME_S)||(next_state == TRAIL_S))
   			frame_cnt	<= frame_cnt + 1'b1;
   		else if ((next_state == CRC_S)||(next_state == END1_S))
   			frame_cnt	<= frame_cnt;
   		else if ((next_state == END2_S)&&(frame_cnt == 1'b1))
   			frame_cnt	<= frame_cnt + 1'b1;
   		else
   			frame_cnt	<= 1'b0;
   	end
   	
   	always @(posedge clk)
   	begin
   		if (next_state == END2_S)
   			end_sel	<= ~frame_cnt;
   		else
   			end_sel	<= 1'b0;
   	end
   	
   	// output -----------------------------------
   	always @(posedge clk)
   	begin
   		if ((next_state == PRE_S)&&(cnt == 6'd7))
   		begin
   			gmii_txd		<= 8'hd5;
   			gmii_tx_en	<= 1'b1;
   		end
   		else if (next_state == PRE_S)
   		begin
   			gmii_txd		<= 8'h55;
   			gmii_tx_en	<= 1'b1;
   		end
   		else if (next_state == FRAME_S)
   		begin
   			gmii_txd		<= tx_data_r;
   			gmii_tx_en	<= tx_data_valid_r;
   		end
   		else if (next_state == TRAIL_S)
   		begin
   			gmii_txd		<= 8'h00;
   			gmii_tx_en	<= 1'b1;
   		end
   		else if (next_state == CRC_S)
   		begin
   			gmii_txd		<= crc_data;
   			gmii_tx_en		<= crc_en	;
   		end
   		else if (next_state == END1_S)
   		begin
   			gmii_txd		<= 8'hFD;
   			gmii_tx_en	<= 1'b0;
   		end
   		else if (next_state == END2_S)
   		begin
   			gmii_txd		<= 8'hF7;
   			gmii_tx_en	<= 1'b0;
   		end
   		else if ((next_state == KIDLE_S)||(next_state == KDLY_S))
   		begin
   			gmii_txd		<= 8'hBC;
   			gmii_tx_en	<= 1'b0;
   		end
   		else
   		begin
   			gmii_txd		<= 8'h50;
   			gmii_tx_en	<= 1'b0;
   		end
   	end
   	
//   	always @(posedge clk)
//   	begin
//   		if (next_state == CRC_S)
//   		begin
//   			gmii_txd		<= crc_data;
//   			gmii_tx_en		<= crc_en	;
//   		end
//   		else
//   		begin
//   			gmii_txd		<= gmii_txd_r	;    
//   			gmii_tx_en		<= gmii_tx_en_r	;
//   		end
//   	end
   	
//   	always @(posedge clk)
//   	begin
//   		if ((state == KIDLE_S)||(state == KDLY_S))
//   			gmii_kw	<= 1'b1;
//   		else
//   			gmii_kw	<= 1'b0;
//   	end
   	
   	always @(posedge clk)
   	begin
   		if ((next_state == PRE_S)&&(cnt == 6'd6))
   			tx_ack	<= 1'b1;
   		else
   			tx_ack	<= 1'b0;
   	end
   	
	assign 	gmii_tx_er = 1'b0;

endmodule
