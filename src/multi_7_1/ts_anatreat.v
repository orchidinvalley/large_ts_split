`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		syq
// 
// Create Date:    2012-2-4 14:22:28
// Design Name:   
// Module Name:    ts_treat 
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
module ts_anatreat
(
    clk,
    reset,
    
    ts_din,
    ts_din_en,
    
    tx_over_full,
    
    ts_dout,
    ts_dout_en
);

    input   clk;
    input   reset;
    
    input   [7:0] ts_din;
    input   ts_din_en;
    
    input   tx_over_full;
    
    output [7:0] ts_dout;
    output ts_dout_en;
    reg     [7:0] ts_dout;
    reg     ts_dout_en;
    
//------------------------------------------------

	reg		[7:0]	ts_din_r1, ts_din_r2, ts_din_r3, ts_din_r4, ts_din_r5, ts_din_r6, ts_din_r7;  	
	reg		ts_din_en_r1, ts_din_en_r2, ts_din_en_r3, ts_din_en_r4, ts_din_en_r5, ts_din_en_r6, ts_din_en_r7;
	reg		[7:0]	ts_din_r8, ts_din_r9, ts_din_r10, ts_din_r11, ts_din_r12, ts_din_r13,ts_din_r14;  	
	reg		ts_din_en_r8, ts_din_en_r9, ts_din_en_r10, ts_din_en_r11, ts_din_en_r12, ts_din_en_r13,ts_din_en_r14;
	
     reg		[8:0]	wr_data2fifo	;
    reg				wr_en			;
//----------------------------------------------- 
	reg		[3:0]	wr_cnt			;   	
	reg				wr_start		;
	reg				wr_end			;
	reg				ip_port_n_flag	;
	
	reg		[47:0]	mac_temp		;
	reg		[31:0]	ip_temp			;
	reg		[15:0]	port_temp		;
	
	reg		[2:0]	pack_cnt		;	
	reg		[7:0]	ip_pack_cnt 	;
	
	reg				pack_in_fifo	;
	reg				pack_cnt_inc	;
	reg				pack_cnt_dec	;
	
	reg		[5:0]	dly_cnt			;
	reg				dly_end			;
	wire	[8:0]	rd_fifo_dout	;
	wire			fifo_empty		;
	wire			rd_en			;

	//-------------------------------
	reg				ts_flag			    ;
	reg				ts_flag_r			;
	reg				mac_ip_replaced		;	
	
//-------------------------------------------------

	reg		[1:0]	wr_state		;
	reg		[1:0]	wr_nxt_state	;
	
	parameter  	WR_IDLE_S = 2'd0;
	parameter	WR_FLAG_S = 2'd1;
	parameter	WR_DATA_S = 2'd2;
	parameter	WR_END_S  = 2'd3;

//-----------------------------------------------------
	reg		[1:0]	rd_state	;
	reg		[1:0]	rd_nxt_state;
	
	parameter	RD_IDLE_S = 2'd0 ;
	parameter	RD_DATA_S = 2'd1 ;
	parameter	RD_END_S  = 2'd2 ;
	parameter	RD_DLY_S  = 2'd3 ;
	
//------------------------------------------------------
	assign rd_en = (rd_nxt_state == RD_DATA_S)?1'b1:1'b0;
	
	always @ (posedge clk)
	begin
		if(reset)	
			wr_state <= WR_IDLE_S;
		else
			wr_state <= wr_nxt_state ;		
	end 
	
	always @ (wr_state or wr_start or wr_end)
	begin
		case(wr_state)
			WR_IDLE_S:
				if(wr_start == 1'b1)
					wr_nxt_state = WR_FLAG_S;
				else
					wr_nxt_state = WR_IDLE_S;
			WR_FLAG_S:
				wr_nxt_state = WR_DATA_S;
			WR_DATA_S:
				if(wr_end)
					wr_nxt_state = WR_END_S;
				else
					wr_nxt_state = WR_DATA_S;
			WR_END_S :
				wr_nxt_state = WR_IDLE_S;		
		default: wr_nxt_state = WR_IDLE_S;
		
		endcase
	end
   
   //--------------------------------------------------
   
   always @(posedge clk)
	begin
		ts_din_r1	<=	ts_din;
		ts_din_r2	<=	ts_din_r1;
		ts_din_r3	<=	ts_din_r2;
		ts_din_r4	<=	ts_din_r3;
		ts_din_r5	<=	ts_din_r4;
		ts_din_r6	<=	ts_din_r5;
		ts_din_r7	<=	ts_din_r6;
		ts_din_r8	<=	ts_din_r7;
		ts_din_r9	<=	ts_din_r8;
		ts_din_r10	<=	ts_din_r9;
		ts_din_r11	<=	ts_din_r10;
		ts_din_r12	<=	ts_din_r11;
		ts_din_r13	<=	ts_din_r12;
		ts_din_r14	<=	ts_din_r13;		
	end
	
	always @(posedge clk)
	begin
		ts_din_en_r1	<=	ts_din_en;
		ts_din_en_r2	<=	ts_din_en_r1; 
		ts_din_en_r3	<=	ts_din_en_r2; 
		ts_din_en_r4	<=	ts_din_en_r3; 
		ts_din_en_r5	<=	ts_din_en_r4; 
		ts_din_en_r6	<=	ts_din_en_r5; 
		ts_din_en_r7	<=	ts_din_en_r6;  
		ts_din_en_r8	<=	ts_din_en_r7;  
		ts_din_en_r9	<=	ts_din_en_r8; 
		ts_din_en_r10	<=	ts_din_en_r9; 
		ts_din_en_r11	<=	ts_din_en_r10;
		ts_din_en_r12	<=	ts_din_en_r11;
		ts_din_en_r13	<=	ts_din_en_r12;
		ts_din_en_r14	<=	ts_din_en_r13;
	end
   
	always @ (posedge clk)
	begin
   		if(ts_din_en_r14) 
   		begin
   			if(wr_cnt < 4'd13)
   				wr_cnt <= wr_cnt + 4'd1;
   			else
   				wr_cnt <= wr_cnt;
   		end
   		else
   			wr_cnt <= 4'd0;   	
	end
	
	
	always @ (posedge clk)
	begin
		if(ts_din_en_r12 && !ts_din_en_r13)	
			wr_start <= 1'b1;
		else
			wr_start <= 1'b0;		
	end
	
	always @ (posedge clk)
	begin
		if(ts_din_en_r14 == 1'b1 && ts_din_en_r13 == 1'b0)
			wr_end <= 1'b1;
		else
			wr_end <= 1'b0;	
	end
	
//	always @ (posedge clk)
//	begin
//		if(ts_din_en_r12 && !ts_din_en_r13)
//		begin
//			if(ts_din == 8'h47 && {ts_din_r2,ts_din_r1} != 16'd20000 && {ts_din_r2,ts_din_r1} != 16'd20001 && {ts_din_r2,ts_din_r1} != 16'd20002 )
//				ts_flag <= 1;			
//			else
//				ts_flag <= 0;
//		end	
//		else
//			ts_flag <= ts_flag;
//	end
	
	always @ (posedge clk)
	begin
		if(ts_din_en_r12 && !ts_din_en_r13)
		begin
			if(ts_din_r6[7:4] == 4'he)
			begin
				if(ts_din == 8'h47)
					ts_flag <= 1;
				else
					ts_flag <= 0;
			end
			else
			begin
				if(ts_din == 8'h47 && {ts_din_r2,ts_din_r1} != 16'd20000 && {ts_din_r2,ts_din_r1} != 16'd20001 && {ts_din_r2,ts_din_r1} != 16'd20002)
					ts_flag <= 1;			
				else
					ts_flag <= 0;
			end
		end	
		else
			ts_flag <= ts_flag;
	end
	
	always @ (posedge clk)
	begin
		if(ts_din_en_r12 && !ts_din_en_r13)
			ts_flag_r <= ts_flag ;
		else
			ts_flag_r <= ts_flag_r;
	end
	
//	always @ (posedge clk)
//	begin
//		if(ts_din_en_r12 && !ts_din_en_r13)
//		begin
//			if(pack_cnt == 3'd6)
//				ip_port_n_flag	<= 1'b1;			
//			else if({ts_din_r11,ts_din_r10,ts_din_r9,ts_din_r8,ts_din_r7,ts_din_r6,ts_din_r5,ts_din_r4,ts_din_r3,ts_din_r2,ts_din_r1,ts_din} == {mac_temp,ip_temp,port_temp})	
//				ip_port_n_flag	<= 1'b0;
//			else
//				ip_port_n_flag	<= 1'b1;
//		end	
//		else
//			ip_port_n_flag <= ip_port_n_flag;
//	end
	
	always @ (posedge clk)
	begin
		if(ts_din_en_r12 && !ts_din_en_r13)
		begin
			if(ts_din != 8'h47 || (({ts_din_r2,ts_din_r1} == 16'd20000 || {ts_din_r2,ts_din_r1} == 16'd20001 || {ts_din_r2,ts_din_r1} == 16'd20002 )&& ts_din_r6[7:4]!=4'he))
			begin
				ip_port_n_flag	<= 1'b1;	
			end
			else
			begin
				if(pack_cnt == 3'd6)
					ip_port_n_flag	<= 1'b1;			
				else if({ts_din_r12,ts_din_r11,ts_din_r10,ts_din_r9,ts_din_r8,ts_din_r7,ts_din_r6,ts_din_r5,ts_din_r4,ts_din_r3,ts_din_r2,ts_din_r1} == {mac_temp,ip_temp,port_temp})	
					ip_port_n_flag	<= 1'b0;
				else
					ip_port_n_flag	<= 1'b1;
			end
		end	
		else
			ip_port_n_flag <= ip_port_n_flag;
	end
	
	always @ (posedge clk)
	begin
		if(ip_port_n_flag)	
			pack_cnt <= 0;
		else if(wr_end)
			pack_cnt <= pack_cnt + 1;
		else
			pack_cnt <= pack_cnt ;
	end
	
	//------------------------------------------------
	
	always @ (posedge clk)
	begin
		if(ts_din_en_r13 && !ts_din_en_r14)
		begin
			mac_temp	<= {ts_din_r13,ts_din_r12,ts_din_r11,ts_din_r10,ts_din_r9,ts_din_r8};
			ip_temp 	<= {ts_din_r7,ts_din_r6,ts_din_r5,ts_din_r4};	
			port_temp	<= {ts_din_r3,ts_din_r2};
		end	
		else
		begin
			mac_temp	<= mac_temp		;
			ip_temp		<= ip_temp 		;
			port_temp	<= port_temp	;			
		end		
	end
	
	//----------------------------------------
	
	always @ (posedge clk)
	begin
		if(reset)	
			mac_ip_replaced <= 0;
		else if(ts_din_en_r13 && !ts_din_en_r14)
			mac_ip_replaced <= 1;	
		else
			mac_ip_replaced <= mac_ip_replaced ;	
	end
	
	//-------------------------------------------------------
	always @ (posedge clk)
	begin
		if(wr_nxt_state == WR_FLAG_S || wr_nxt_state == WR_END_S)
			wr_data2fifo <= 9'h155;
		else if(wr_nxt_state == WR_DATA_S)
			wr_data2fifo <= {1'b0,ts_din_r14};
		else
			wr_data2fifo <= 9'h0;
	end
	
	//----------------------------------------
	
	always @ (posedge clk)
	begin
		if(wr_nxt_state == WR_FLAG_S)			
		begin
			if(ip_port_n_flag == 1 && mac_ip_replaced == 1 && ts_flag_r == 1  && fifo_empty ==0)
				wr_en <= 1'b1;	
			else
				wr_en <= 1'b0;		
		end
		else if(wr_nxt_state == WR_DATA_S)
		begin
			if(ip_port_n_flag == 1'b1)	
				wr_en <= 1'b1;
			else
			begin
				if(wr_cnt > 4'd11)
					wr_en <= 1'b1;						
				else	
					wr_en <= 1'b0;
			end					
		end	
		else if(wr_nxt_state == WR_END_S)
		begin
			if(ts_flag)
				wr_en <= 0;
			else	
				wr_en <= 1;	
		end	
		else
			wr_en <= 1'b0;		
	end
	
	//pack_cnt_inc
	
	always @ (posedge clk)
	begin
		if(wr_state == WR_FLAG_S)
		begin
			if(wr_en)
				pack_cnt_inc <= 1;
			else		
				pack_cnt_inc <= 0;
		end
		else if(wr_state == WR_END_S)
		begin
			if(wr_en)	
				pack_cnt_inc <= 1;
			else
				pack_cnt_inc <= 0;	
		end
		else 
			pack_cnt_inc <= 0;
	end
	
	always @ (posedge clk)
	begin
		if(rd_state == RD_IDLE_S && rd_nxt_state == RD_DATA_S)	
			pack_cnt_dec <= 1;
		else
			pack_cnt_dec <= 0;
	end
	
	always @ (posedge clk)
	begin
		if(fifo_empty == 1'b1)
			ip_pack_cnt <= 1'b0;	
		else if(pack_cnt_inc == 1 && pack_cnt_dec == 1'b0)
			ip_pack_cnt <= ip_pack_cnt + 1;
		else if(pack_cnt_inc == 0 && pack_cnt_dec == 1'b1)
		begin
			if(ip_pack_cnt == 0)
				ip_pack_cnt <= ip_pack_cnt;
			else
				ip_pack_cnt <= ip_pack_cnt - 1;
		end
		else
			ip_pack_cnt	<= ip_pack_cnt;
	end
	
	
	always @ (posedge clk)
	begin
		if(fifo_empty == 1'b1 || ip_pack_cnt == 0)
			pack_in_fifo <= 1'b0;	
		else 
			pack_in_fifo <= 1'b1;			
	end
    
    always @ (posedge clk)
    begin
    	if(reset)
    		rd_state <= RD_IDLE_S;
    	else	
    		rd_state <= rd_nxt_state ;
    end
    
	always @ (rd_state or pack_in_fifo or tx_over_full or rd_fifo_dout[8] or dly_end)//prf modify <= ��Ϊ =
    begin
    	case(rd_state)	
    		RD_IDLE_S:
    			if(pack_in_fifo && tx_over_full == 1'b0)
    				rd_nxt_state = RD_DATA_S ;
    			else
    				rd_nxt_state = RD_IDLE_S ;
    		RD_DATA_S:
    			if(rd_fifo_dout[8])
    				rd_nxt_state = RD_END_S;
    			else
    				rd_nxt_state = RD_DATA_S ;
    		RD_END_S:
    			rd_nxt_state = RD_DLY_S ;
    		RD_DLY_S:
    			if(dly_end == 1'b1)
    				rd_nxt_state = RD_IDLE_S;
    			else
    				rd_nxt_state = RD_DLY_S;
    	
    	default: rd_nxt_state = RD_IDLE_S ;
    	endcase
    end
    
    always @ (posedge clk)
    begin
    	if(rd_nxt_state == RD_DLY_S)
    		dly_cnt <= dly_cnt  +1;
    	else
    		dly_cnt <= 0;	
    end
    always @ (posedge clk)
    begin
    	if(dly_cnt == 6'd8)
    		dly_end <= 1'b1;
    	else	
    		dly_end <= 1'b0;
    end
        
    always @ (posedge clk)
    begin
    	if(rd_nxt_state == RD_DATA_S && rd_state == RD_DATA_S)
    	begin
    		ts_dout 	<= 	rd_fifo_dout[7:0];
    		ts_dout_en 	<= 1'b1;
    	end
    	else
    	begin
    		ts_dout 	<= 0;
    		ts_dout_en 	<= 1'b0;
    	end    	
    end
       
     anatreat_fifo 	anatreat_fifo_init
     (
		.clk		(clk			),
		.rst		(reset			),
		.din		(wr_data2fifo	),
		.wr_en		(wr_en			),
		.rd_en		(rd_en			),
		.dout		(rd_fifo_dout	),
		.full		(full			),
		.prog_full	(prog_full		),
		.empty		(fifo_empty		)
	);
endmodule
