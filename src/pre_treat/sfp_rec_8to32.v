`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    2011-4-27 16:15:20 
// Design Name: 
// Module Name:    sfp_rec_8to32 
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

module sfp_rec_8to32 #
	(
		parameter SFP_IN_NUM = 8'd1
	)
(
	input				clk					,
	input				reset				,
	input		[7:0]	data_in_sfp			,
	input	   			data_in_sfp_valid	,

	input				rd_ack				,
	output	reg	[32:0]	data_out			,
	output	reg			data_out_valid		,
	output	reg			flag_test			
);  

//--------------------------------------------------------
				                                	
	reg		[1:0]		wr_state			;
	reg		[1:0]		wr_nxt_state		;
	                                    	
	parameter	WR_IDLES =   2'd0			;
	parameter	WR_DATAS =   2'd1			;
	parameter	WR_OVERS =   2'd2			;
	
	//-------------------------------------------------
	wire				p_full				;
	reg		[15:0]		wr_cnt				;
	reg		[1:0]		wr_cnt_f			;
	reg		[7:0]		data_in_sfp_r		;
	reg					data_in_sfp_valid_r	;
	reg		[7:0]		data_in_sfp_rr		;
	reg					data_in_sfp_valid_rr;
	reg					start_flag			;
	reg					end_flag			;
	reg		[31:0]		wr_data2fifo		;
	reg					wr_data2fifo_valid	;
	
//--------------------------------------------------------
	reg		[7:0]		frame_cnt			;
	reg					frame_in_fifo		;
	
	reg					frame_cnt_inc		;
	reg					frame_cnt_dec		;

//--------------------------------------------------------
	reg		[3:0]		rd_state			;
	reg		[3:0]		rd_nxt_state		;
	
	parameter	RD_IDLES	= 4'd0 ;
	parameter	RD_SFPN		=4'd1;
	parameter	RD_IPS		= 4'd2 ;
	parameter	RD_PORTS 	= 4'd3 ;
	parameter	RD_WAIT_ACK	= 4'd4 ;
	parameter	SEND_IP			=4'd5;
	parameter	SEND_PORT	= 4'd6 ;
	parameter	SEND_DATA	= 4'd7 ;
	parameter	SEND_END1	= 4'd8 ;
	parameter	SEND_END2	= 4'd9;
	
	

//============================================
	reg		[31:0]	sfpnum_reg;
	reg		[31:0]	ip_reg		;
	reg		[31:0]	port_reg	;
	reg		[5:0]	rd_cnt		;
	reg				rd_pack_flag;
//--------------------------------------------------------	
	wire			rd_en	;
	wire	[32:0]	dout	;
	wire			rd_end	;
	wire			empty	;
	
	reg		[3:0]	cc_reg	;
	reg		[3:0]	cc_dif	;
	
	reg		[3:0]	cc_reg2	;
	reg		[3:0]	cc_dif2	;
	reg		[3:0]	cc_reg3	;
	reg		[3:0]	cc_dif3	;
	
	reg		[31:0]	data_out_r1;
	reg		[31:0]	data_out_r2;
	reg				test_flag1;
	reg				test_flag2;

//--------------------------------------------------------
	assign rd_end = dout[32];
	assign rd_en  = ( rd_nxt_state == RD_SFPN || rd_nxt_state == RD_IPS || rd_nxt_state == RD_PORTS || rd_nxt_state == SEND_DATA)?1'b1:1'b0;

//------------------------------------------------------------
	always @ (posedge clk)
	begin
		data_in_sfp_r		<= data_in_sfp			;
		data_in_sfp_rr		<= data_in_sfp_r		;
		data_in_sfp_valid_r <= data_in_sfp_valid	;	
		data_in_sfp_valid_rr<= data_in_sfp_valid_r  ;
		
		start_flag			<= data_in_sfp_valid && !data_in_sfp_valid_r;
		end_flag			<= !data_in_sfp_valid_r && data_in_sfp_valid_rr;
	end
	
	always @ (posedge clk)
	begin
		if(reset)
			wr_state	<= WR_IDLES ;
		else
			wr_state	<= wr_nxt_state	;	
	end
	
	always @ (wr_state or p_full or start_flag or end_flag)
	begin
		case(wr_state)
			WR_IDLES:
				if(start_flag)
				begin
					if(p_full)
						wr_nxt_state <= WR_OVERS;
					else
						wr_nxt_state <= WR_DATAS;
				end
				else
					wr_nxt_state <= WR_IDLES;					
			WR_DATAS:
				if(end_flag)
					wr_nxt_state <= WR_IDLES;	
				else
					wr_nxt_state <= WR_DATAS;		
			WR_OVERS:
				if(end_flag)
					wr_nxt_state <= WR_IDLES;	
				else
					wr_nxt_state <= WR_OVERS;	
//			WR_ENDS :
//				wr_nxt_state <= WR_IDLES;	

		default: wr_nxt_state <= WR_IDLES	;
		endcase	
	end

	always @ (posedge clk)
	begin
		if(wr_nxt_state == WR_DATAS || wr_nxt_state == WR_OVERS)
		begin
		wr_cnt <= wr_cnt + 1;
		end
		else
			wr_cnt <= 0;
	end

	always @ (posedge clk)
	begin
		if(wr_nxt_state == WR_DATAS)
		begin
			if(wr_cnt == 0)
				wr_data2fifo[31:0]	<= {wr_data2fifo[23:0],SFP_IN_NUM};	
			else
				wr_data2fifo[31:0]	<= {wr_data2fifo[23:0],data_in_sfp_rr[7:0]};
		end
		else
			wr_data2fifo[31:0] <= 0;
	end
		
	always @ (posedge clk)
	begin
		if(wr_cnt > 6)
			wr_cnt_f <= wr_cnt_f + 1;
		else
			wr_cnt_f <= 0;
	end
	
	always @ (posedge clk)
	begin
		if(wr_nxt_state == WR_DATAS && (wr_cnt==16'd0 ||	wr_cnt == 16'd4|| wr_cnt == 16'd6 || wr_cnt_f == 2'b11 ))
			wr_data2fifo_valid <= 1'b1;
		else
			wr_data2fifo_valid <= 1'b0;
	end

	always @ (posedge clk)
	begin
		if(rd_nxt_state == SEND_DATA)
			rd_cnt <= rd_cnt + 1;
		else
			rd_cnt <= 0;	
	end
	
	always @ (posedge clk)
	begin
		if(rd_cnt == 6'd46)
			rd_pack_flag <= 1'b1;
		else
			rd_pack_flag <= 1'b0;
	end
	
			
	//----------------------------------------------------
	always @ (posedge clk)
	begin
		if(reset)
			rd_state <= RD_IDLES ;
		else
			rd_state <= rd_nxt_state	;	
	end
	
	always @ (rd_state or frame_in_fifo or rd_ack or rd_pack_flag or empty or rd_end)
	begin
		case(rd_state)
			RD_IDLES:
			begin
				if(frame_in_fifo)
					rd_nxt_state <= RD_SFPN ;
				else
					rd_nxt_state <= RD_IDLES;
			end
			RD_SFPN:
				rd_nxt_state <= RD_IPS;
			RD_IPS:
				rd_nxt_state  <= RD_PORTS ;
			RD_PORTS :
				rd_nxt_state  <= RD_WAIT_ACK;
			RD_WAIT_ACK:
				if(rd_ack)
					rd_nxt_state <= SEND_IP;
				else
					rd_nxt_state <= RD_WAIT_ACK;	
			SEND_IP:
				rd_nxt_state <= SEND_PORT;	
			SEND_PORT:
				rd_nxt_state <= SEND_DATA;
			SEND_DATA:
				begin
				if(rd_end)
					rd_nxt_state <= RD_IDLES ;
				else if(rd_pack_flag)
				begin
					if(empty)
						rd_nxt_state <= RD_IDLES ;
					else
						rd_nxt_state <= SEND_END1;
				end
				else
					rd_nxt_state <= SEND_DATA;
				end
			SEND_END1:
				rd_nxt_state <= SEND_END2;
			SEND_END2:
				rd_nxt_state <= RD_WAIT_ACK;	
				
		default:	rd_nxt_state <= RD_IDLES;		
		endcase
	end	
	
		always @ (posedge clk)
	begin
		if(rd_state == RD_SFPN)
			sfpnum_reg <= dout[31:0];	
		else		
			sfpnum_reg <= sfpnum_reg ;
	end
	
	always @ (posedge clk)
	begin
		if(rd_state == RD_IPS)
			ip_reg <= dout[31:0];	
		else		
			ip_reg <= ip_reg ;
	end
	
	always @ (posedge clk)
	begin
		if(rd_state == RD_PORTS)
			port_reg <= dout[31:0];	
		else		
			port_reg <= port_reg ;
	end
	
	//----------------------------------------------------
	always @ (posedge clk)
	begin
		if(rd_state == RD_WAIT_ACK)
		begin
			data_out 		<= {1'b1,sfpnum_reg[31:0]};
			data_out_valid 	<= 1'b1;
		end
		else if(rd_state == SEND_IP)
		begin
			data_out 		<= {1'b0,ip_reg[31:0]} ;
			data_out_valid 	<= 1'b1;
		end		
		else if(rd_state == SEND_PORT)
		begin
			data_out 		<= {1'b0,port_reg[31:0]} ;
			data_out_valid 	<= 1'b1;
		end
		else if(rd_state == SEND_DATA)
		begin
			data_out 		<= {1'b0,dout[31:0]};
			data_out_valid 	<= 1'b1;
		end
		else
		begin
			data_out 		<= 0;
			data_out_valid 	<= 0;
		end	
	end
	
	always @ (posedge clk)
	begin
		data_out_r1 <= data_out[31:0];	
		data_out_r2 <= data_out_r1;		
	end
	
	//----------------------------------------------------
	//frame_cnt_inc
	
	always @ (posedge clk)
	begin
		if(wr_state == WR_DATAS && wr_nxt_state == WR_IDLES)
			frame_cnt_inc <=  1;
		else 
			frame_cnt_inc <=  0;
	end	
	
	always @ (posedge clk)
	begin
		if(rd_state == RD_IPS && rd_nxt_state == RD_PORTS)
			frame_cnt_dec <=  1;
		else
			frame_cnt_dec <=  0;
	end	
	
	always @ (posedge clk)
	begin
		if(empty)
			frame_cnt <= 0;
		else if(frame_cnt_inc == 1 && frame_cnt_dec == 0)
			frame_cnt <= frame_cnt + 1;
		else if(frame_cnt_inc == 0 && frame_cnt_dec == 1)
			frame_cnt <= frame_cnt - 1;
		else
			frame_cnt <= frame_cnt ;
	end	
	
	always @ (posedge clk)
	begin
		if(empty || frame_cnt == 0)
			frame_in_fifo <= 1'b0;
		else
			frame_in_fifo <= 1'b1;
	end
	
	
	always @ (posedge clk)
	begin
		if(rd_cnt == 2 && data_out[31:24] == 8'h47 && data_out[20:8] == 13'h1001)
			begin
				cc_reg	<= data_out[3:0];	
				cc_dif	<= data_out[3:0] - cc_reg;
			end
		else	
			begin
				cc_reg	<= cc_reg;
				cc_dif  <= cc_dif;
			end		
	end
	
	always @ (posedge clk)
	begin
		if(rd_cnt == 2 && data_out[31:24] == 8'h47 && data_out[20:8] == 13'h1003)
			begin
				cc_reg2	<= data_out[3:0];	
				cc_dif2	<= data_out[3:0] - cc_reg2;
			end
		else	
			begin
				cc_reg2	 <= cc_reg2;
				cc_dif2  <= cc_dif2;
			end		
	end
	
	always @ (posedge clk)
	begin
		if(rd_cnt == 2 && data_out[31:24] == 8'h47 && data_out[20:8] == 13'h1005)
			begin
				cc_reg3	<= data_out[3:0];	
				cc_dif3	<= data_out[3:0] - cc_reg3;
			end
		else	
			begin
				cc_reg3	 <= cc_reg3;
				cc_dif3  <= cc_dif3;
			end		
	end
	
	
	
	always @ (posedge clk)
	begin
		flag_test <= cc_reg && cc_dif && cc_dif2 && cc_dif3 && test_flag1 && test_flag2;
		test_flag1 <= (data_out_r2 == data_out_r1) && (data_out_r1 == data_out);
		test_flag2 <= data_out != 32'h0 && data_out_r1 != 32'hffffffff ;		
		
	end
	//----------------------------------------------------
	
	rec_33b_fifo 	rec_32b_fifo_afp
	(
		.clk		(clk				),
		.din		({end_flag,wr_data2fifo}),
		.wr_en		(wr_data2fifo_valid	),
		
		.rd_en		(rd_en				),
		.dout		(dout				),
		.prog_full	(p_full				),
		.empty		(empty				)
	);

endmodule
