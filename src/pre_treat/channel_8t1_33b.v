`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:27:57 04/23/2011 
// Design Name: 
// Module Name:    channel_4t1_33b 
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
module channel_8t1_33b
(
	input				clk				,
	input				reset			,
	input		[32:0]	data_in1		,
	input				data_in1_valid	,
	input		[32:0]	data_in2		,
	input				data_in2_valid	,
	input		[32:0]	data_in3		,
	input				data_in3_valid	,
	input		[32:0]	data_in4		,
	input				data_in4_valid	,

	
	output	reg			rd_ack1			,
	output	reg			rd_ack2			,
	output	reg			rd_ack3			,
	output	reg			rd_ack4			,
	

	output	reg	[32:0]	data_out		,
	output	reg			data_out_valid	,
	output				test_flag    
);

//----------------------------------------------
	reg		[5:0]		state		;
	reg		[5:0]		nxt_state	;
	
	parameter	IDLES			= 6'd0	;
	parameter	CH1_ACK 		= 6'd1  ;
	parameter	CH2_ACK 		= 6'd2  ;
	parameter	CH3_ACK 		= 6'd3  ;
	parameter	CH4_ACK 		= 6'd4  ;
	parameter	CH5_ACK 		= 6'd5  ;
	parameter	CH6_ACK 		= 6'd6  ;
	parameter	CH7_ACK 		= 6'd7  ;
	parameter	CH8_ACK 		= 6'd8  ;	
	parameter	CH9_ACK 		= 6'd9  ;	
	parameter	CH10_ACK 		= 6'd10 ;	
	parameter	CH11_ACK 		= 6'd11 ;	
	parameter	CH12_ACK 		= 6'd12 ;
	parameter	CH13_ACK 		= 6'd13 ;
	parameter	CH14_ACK 		= 6'd14 ;
	parameter	CH15_ACK 		= 6'd15 ;
	parameter	CH16_ACK 		= 6'd16 ;	
	parameter	CH425_ACK_1     = 6'd17 ;
	parameter	CH425_ACK_2     = 6'd18 ;
	parameter	CH425_ACK_3     = 6'd19 ;
	parameter	CH425_ACK_4     = 6'd20 ;		
	parameter	DATA1_TRS 		= 6'd21 ;
	parameter	DATA2_TRS 		= 6'd22 ;
	parameter	DATA3_TRS 		= 6'd23 ;
	parameter	DATA4_TRS 		= 6'd24 ;
	parameter	DATA5_TRS 		= 6'd25 ;
	parameter	DATA6_TRS 		= 6'd26 ;
	parameter	DATA7_TRS 		= 6'd27 ;
	parameter	DATA8_TRS 		= 6'd28 ;	                              
	parameter	DATA9_TRS 		= 6'd29	;	                              
	parameter	DATA10_TRS 		= 6'd30	;	                              
	parameter	DATA11_TRS 		= 6'd31	;	                              
	parameter	DATA12_TRS 		= 6'd32	;
	parameter	DATA13_TRS 		= 6'd33	;
	parameter	DATA14_TRS 		= 6'd34	;
	parameter	DATA15_TRS 		= 6'd35	;
	parameter	DATA16_TRS 		= 6'd36	;
	parameter	DATA_425_1_TRS  = 6'd37	; 
	parameter	DATA_425_2_TRS  = 6'd38	;
	parameter	DATA_425_3_TRS  = 6'd39	;
	parameter	DATA_425_4_TRS  = 6'd40	;		                              
	parameter	TR_ENDS 		= 6'd41	;	
	parameter	TR_DLY 			= 6'd42	;	
//	parameter	TR_DLY2 		= 5'd19	;	
//	parameter	TR_DLY3 		= 5'd20	;	
//	parameter	TR_DLY4 		= 5'd21	;	
//	parameter	TR_DLY5 		= 5'd22	;
//	parameter	TR_DLY6 		= 5'd23	;	
	
	
	reg	[5:0]	delay_cnt			;
	reg			delay_end			;
	
//	reg	[3:0]	tx_425_cnt			;
//	reg	[7:0]   tx_425_temp			;
//----------------------------------------------

//----------------------------------------------
	
	always @ (posedge clk)
	begin
		if(reset)
			state  <=  IDLES ;
		else
			state  <=  nxt_state ;
	end

////////prf modify 20150722  添加敏感列表并将<=改为=
//	always @ (state or data_in1_valid or data_in2_valid or data_in3_valid or data_in4_valid  or data_in5_valid or data_in6_valid or data_in7_valid or data_in8_valid or delay_end)
//	always @(*)
        always @ (state or data_in1_valid or data_in2_valid or data_in3_valid or data_in4_valid or delay_end)
	begin
		case(state)
		IDLES :
			begin
				if(data_in1_valid)
					nxt_state	= CH1_ACK	;
				else if(data_in2_valid)
					nxt_state	= CH2_ACK	;
				else if(data_in3_valid)
					nxt_state	= CH3_ACK	;
				else if(data_in4_valid)
					nxt_state	= CH4_ACK	;			
				else	
					nxt_state	= IDLES	;
			end
	    CH1_ACK :
	    	nxt_state	=	DATA1_TRS ;
	    CH2_ACK :
	 		nxt_state	=	DATA2_TRS ;
	    CH3_ACK :
			nxt_state	=	DATA3_TRS ;
	    CH4_ACK :
			nxt_state	=	DATA4_TRS ;	
		DATA1_TRS:
			if(data_in1_valid)
				nxt_state = DATA1_TRS  ;
			else
				nxt_state = TR_ENDS	;
		DATA2_TRS:
			if(data_in2_valid)
				nxt_state = DATA2_TRS  ;
			else
				nxt_state = TR_ENDS	;
		DATA3_TRS:
			if(data_in3_valid)
				nxt_state = DATA3_TRS  ;
			else
				nxt_state = TR_ENDS	;
		DATA4_TRS:
			if(data_in4_valid)
				nxt_state = DATA4_TRS  ;
			else
				nxt_state = TR_ENDS	;
	

		TR_ENDS :	
			nxt_state = TR_DLY	;
		TR_DLY:
			if(delay_end)
				nxt_state	= IDLES	;
			else
				nxt_state  = TR_DLY	;

		default:	nxt_state	= IDLES	;
		endcase
	end

	always @ (posedge clk)
	begin
		if(nxt_state == TR_DLY)
			delay_cnt	<=  delay_cnt + 1;
		else
			delay_cnt   <= 0;
	end

	always @ (posedge clk)
	begin
		if(delay_cnt == 6'd10)
			delay_end   <= 1;
		else
			delay_end	<= 0;
	end


	always @ (posedge clk)
	begin
		if(nxt_state  == CH1_ACK)
			begin
				rd_ack1	 <= 1'b1 ;rd_ack2  <= 1'b0;rd_ack3  <= 1'b0;rd_ack4  <= 1'b0;			
			end	
		else if(nxt_state  == CH2_ACK)
			begin
				rd_ack1	<= 1'b0	;rd_ack2 <= 1'b1;rd_ack3 <= 1'b0;rd_ack4 <= 1'b0;			
			end	
		else if(nxt_state  == CH3_ACK)
			begin
				rd_ack1	<= 1'b0	;rd_ack2 <= 1'b0;rd_ack3 <= 1'b1;rd_ack4 <= 1'b0;
			end	
		else if(nxt_state  == CH4_ACK)
			begin
				rd_ack1	<= 1'b0	;rd_ack2 <= 1'b0;rd_ack3 <= 1'b0;rd_ack4 <= 1'b1;			
		
			end	
	
		else
			begin
				rd_ack1	 <= 1'b0 ;rd_ack2  <= 1'b0;rd_ack3  <= 1'b0;rd_ack4  <= 1'b0;
		
			end	
	end
	
	

	
	
	
	always @ (posedge clk)
	begin
		case(state)		
		DATA1_TRS:
			begin
			data_out		<= data_in1;
			data_out_valid	<= data_in1_valid;
			end
		DATA2_TRS:
			begin
			data_out		<= data_in2;
			data_out_valid	<= data_in2_valid;
			end
		DATA3_TRS:
			begin
			data_out		<= data_in3;
			data_out_valid	<= data_in3_valid;
			end
		DATA4_TRS:
			begin
			data_out		<= data_in4;
			data_out_valid	<= data_in4_valid;
			end		
		default:
			begin
			data_out		<= 33'b0  ;
			data_out_valid	<= 1'b0	  ;
			end		
		endcase
	end
	
	//------------------------------------------
	
//	reg	[3:0]	cc_reg1_mux	;
//	reg	[3:0]	cc_dif1_mux	;
//	
//	
//	always @ (posedge clk)
//	begin
//		if(tx_425_cnt == 3 && data_out[31:24] == 8'h47 && data_out[20:8] == 13'h1101)
//			begin
//				cc_reg1_mux	<= data_out[3:0];	
//				cc_dif1_mux	<= data_out[3:0] - cc_reg1_mux;
//			end
//		else	
//			begin
//				cc_reg1_mux	 <= cc_reg1_mux;
//				cc_dif1_mux  <= cc_dif1_mux;
//			end		
//	end
//	
//	assign	test_flag = (cc_dif1_mux == 0)?1'b1:1'b0;	
	
	
	
endmodule
