`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:      2011-6-9 15:57:48
// Design Name: 
// Module Name:    ip_tx_client 
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
// pcr_din wr_fifo_full
//////////////////////////////////////////////////////////////////////////////////
module ip_tx_client_new
(        
	input        		clk_125			,
	input        		reset			,	
	input  [7:0] 		wr_data			,
	input				wr_data_en		,
	output       		fifo_p_full		,	
	output reg	[7:0] 	tx_data			,
	output reg	     	tx_data_valid	,
	input        		tx_ack			,		    
	input  	[32:0]  	pcr_base_cnt 	,
	input  	[ 8:0]  	pcr_ext_cnt 	
);

//----------------------------------------------------
	reg		[7:0]		wr_data_r		;
	reg					wr_data_en_r	;
	reg		[7:0]		wr_data2fifo	;
	reg					wr_data2fifo_en	;
	reg					start_flag		;	
	reg					end_flag		;

	reg		[1:0]		wr_state		;
	reg		[1:0]		wr_nxt_state	;
	
	parameter	WR_IDLE_S	= 2'd0      ;
	parameter	WR_DATA_S   = 2'd1		;
	parameter	WR_OVER_S   = 2'd2      ;
	parameter	WR_END_S    = 2'd3		;
	
	reg		[8:0]	frame_cnt			;
	reg				frame_in_fifo		;
	
	reg				frame_cnt_inc		;
	reg				frame_cnt_dec		;
	
	wire	[8:0]	rd_dout				;
	
//---------------------------------------------------- 
 	reg		[3:0]	rd_state			;
 	reg		[3:0]	rd_nxt_state		;
//---------------------------------------------------- 
	parameter  RD_IDLE_S 			= 4'd0;      
 	parameter  QUEUE1_S 			= 4'd1;
  	parameter  QUEUE2_S 			= 4'd2;    
  	parameter  QUEUE3_S 			= 4'd3;  
  	parameter  QUEUE4_S 			= 4'd4;
  	parameter  QUEUE5_S 			= 4'd5;
	parameter  QUEUE6_S 			= 4'd6;
	parameter  QUEUE7_S 			= 4'd7;
	parameter  QUEUE8_S 			= 4'd8;
  	parameter  QUEUE_ACK_S 			= 4'd9; 
  	parameter  WAIT_ACK_S 			= 4'd10;
  	parameter  FRAME_S 				= 4'd11;
  	parameter  DLY1_S 				= 4'd12;
  	parameter  DLY2_S 				= 4'd13;
  	parameter  DLY3_S 				= 4'd14;
  	parameter  DLY4_S 				= 4'd15;     
  	
 //----------------------------------------------------
 	reg			rd_en			;	
 	reg	[7:0]	valid_flag		;
 
  	 //----------------------------------------
  
	reg		[47:0]	data_in_r 	;
	reg		[7:0]	cnt			;
	reg		[7:0]	ts_cnt		;
	reg		[7:0]	pcr_dout	;
        	
	reg		[32:0]	pcr_base_cnt_r;
	reg		[8:0]	pcr_ext_cnt_r;
	reg		[8:0]	pcr_ext_cnt_r1;
  	
  	wire			empty		;
  		
  	wire	   	  	rd_end			;  	  	
  	reg   [3:0]   	pcr_state     	;
//------------------------------------------------------------------------------
    parameter       IDLE    =   4'd0	;	// state definition of the fsm
    parameter       BYTE1   =   4'd1	;
    parameter       BYTE2   =   4'd2	;
    parameter       BYTE3   =   4'd3	;
    parameter       BYTE4   =   4'd4	;
    parameter       BYTE5   =   4'd5	;
    parameter       BYTE6   =   4'd6	;
    parameter       BYTE7   =   4'd7	;
    parameter       BYTE8   =   4'd8	;
    parameter       BYTE9   =   4'd9	;
    parameter       BYTE10  =   4'd10	;
    parameter       BYTE11  =   4'd11	;
    parameter       BYTE12  =   4'd12	;  
   
//---------------------------------------------------------------------------

	always @ (posedge clk_125)
	begin
		wr_data_r	 <= wr_data	  ;
		wr_data_en_r <= wr_data_en;	
		start_flag	 <= !wr_data_en_r & wr_data_en;
		end_flag	 <= wr_data_en_r & !wr_data_en;
	end 
	
	always @ (posedge clk_125)
	begin
		if(reset)
			wr_state <= WR_IDLE_S ;
		else
			wr_state <= wr_nxt_state ;
	end
	
	always @ (wr_state or start_flag or  fifo_p_full or end_flag)
	begin
		case(wr_state)
			WR_IDLE_S :
				if(start_flag)
				begin
					if(fifo_p_full)
						wr_nxt_state <= WR_OVER_S	;
					else
						wr_nxt_state <= WR_DATA_S	;
				end
				else
					wr_nxt_state <= WR_IDLE_S ;
			WR_DATA_S :
				if(end_flag)
					wr_nxt_state <= WR_END_S	;		
				else
					wr_nxt_state <= WR_DATA_S	;	
			WR_OVER_S :
				if(end_flag)
					wr_nxt_state <= WR_END_S	;		
				else
					wr_nxt_state <= WR_OVER_S	;
			WR_END_S  :
				wr_nxt_state <= WR_IDLE_S ;
		default: wr_nxt_state <= WR_IDLE_S ;
		endcase
	end
	
	always @ (posedge clk_125)
	begin
		if(wr_nxt_state == WR_DATA_S)	
		begin
			wr_data2fifo 	<= wr_data_r    ;
			wr_data2fifo_en <= wr_data_en_r ;	
		end
		else
		begin
			wr_data2fifo 	<= 0 ;
			wr_data2fifo_en <= 0 ;	
		end
	end
		
//----------------------------------------------------
//frame_cnt_inc  
	always @ (posedge clk_125)
	begin
		if(wr_state == WR_DATA_S && wr_nxt_state == WR_END_S)
			frame_cnt_inc	<= 1;
		else 
			frame_cnt_inc	<= 0;
	end
	
	always @ (posedge clk_125)
	begin
		if(rd_nxt_state == QUEUE2_S)
			frame_cnt_dec	<= 1;
		else	
			frame_cnt_dec	<= 0;
	end
	
	always @ (posedge clk_125)
	begin
		if(empty)
			frame_cnt   <= 0 ;	
		else if(frame_cnt_inc == 1'b1 && frame_cnt_dec == 1'b0)
			frame_cnt	<= frame_cnt + 1;
		else if(frame_cnt_inc == 1'b0 && frame_cnt_dec == 1'b1)
			frame_cnt	<= frame_cnt - 1;
		else	
			frame_cnt   <= frame_cnt ;
	end
	
	always @ (posedge clk_125)
	begin
		if(empty || frame_cnt == 0)	
			frame_in_fifo <= 1'b0;
		else
			frame_in_fifo <= 1'b1;
	end
	
//---------------------------------------------------- 
 
	assign	rd_end = rd_dout[8];
	
//------------------------------------------------------
	always @ (posedge clk_125)
	begin
		if(reset)
			rd_state <= RD_IDLE_S ;
		else	
			rd_state <= rd_nxt_state ;
	end
	
	always @ (rd_state or frame_in_fifo or rd_end or tx_ack)
	begin
		case(rd_state)
			RD_IDLE_S:
				if(frame_in_fifo)
					rd_nxt_state <= QUEUE1_S ;
				else
					rd_nxt_state <= RD_IDLE_S;	
						
			QUEUE1_S: rd_nxt_state <= QUEUE2_S ;
			QUEUE2_S: rd_nxt_state <= QUEUE3_S ;
			QUEUE3_S: rd_nxt_state <= QUEUE4_S ;
			QUEUE4_S: rd_nxt_state <= QUEUE5_S ;
			QUEUE5_S: rd_nxt_state <= QUEUE6_S ;
			QUEUE6_S: rd_nxt_state <= QUEUE7_S ;
			QUEUE7_S: rd_nxt_state <= QUEUE8_S ;
			QUEUE8_S: rd_nxt_state <= QUEUE_ACK_S ;						
			QUEUE_ACK_S:
				 rd_nxt_state <= WAIT_ACK_S;
			WAIT_ACK_S :
				if (tx_ack == 1'b1)
					rd_nxt_state <= FRAME_S;
				else
					rd_nxt_state <= WAIT_ACK_S;
            FRAME_S : 
            begin
              if (rd_end == 1'b1)
                 rd_nxt_state <= DLY1_S;
              else
                 rd_nxt_state <= FRAME_S;
            end  	
            DLY1_S: rd_nxt_state <= DLY2_S;            
            DLY2_S: rd_nxt_state <= DLY3_S;            
            DLY3_S: rd_nxt_state <= DLY4_S;            
            DLY4_S:	rd_nxt_state <= RD_IDLE_S;		
		default: rd_nxt_state <= RD_IDLE_S;
		endcase
	end

	always @ (rd_nxt_state)
	begin
		case (rd_nxt_state)
			QUEUE1_S	: rd_en <= 1'b1;
			QUEUE2_S	: rd_en <= 1'b1;
			QUEUE3_S	: rd_en <= 1'b1;
			QUEUE4_S	: rd_en <= 1'b1;
			QUEUE5_S	: rd_en <= 1'b1;
			QUEUE6_S	: rd_en <= 1'b1;
			QUEUE7_S	: rd_en <= 1'b1;
			QUEUE8_S	: rd_en <= 1'b1;						
			QUEUE_ACK_S	: rd_en <= 1'b1;	
			WAIT_ACK_S 	: rd_en <= 1'b0;	
            FRAME_S 	: rd_en <= 1'b1;				
		default: rd_en <= 1'b0;
		endcase
	end
	
	      
	always @ (posedge clk_125)   
	begin
		if(rd_nxt_state == QUEUE1_S)
			valid_flag[0] <= 1'b1;
		else if(rd_nxt_state == DLY1_S)
			valid_flag[0] <= 1'b0;
		else
			valid_flag[0] <= valid_flag[0];  		
	end   
	
	always @ (posedge clk_125)
	begin
		valid_flag[1] <= valid_flag[0] ;
		valid_flag[2] <= valid_flag[1] ;
		valid_flag[3] <= valid_flag[2] ;
		valid_flag[4] <= valid_flag[3] ;
		valid_flag[5] <= valid_flag[4] ;
		valid_flag[6] <= valid_flag[5] ;
		valid_flag[7] <= valid_flag[6] ;		
	end
	
	always @ (posedge clk_125)
	begin
		if(valid_flag[7])
		begin
			if(rd_nxt_state == WAIT_ACK_S)	
				tx_data <= tx_data  ;
			else
				tx_data <= pcr_dout ;
		end
		else
			tx_data <= 8'd0;
	end
	
	always @ (posedge clk_125)
	begin
		tx_data_valid <= valid_flag[7];
	end
	
//----------------------------------------------------

	always @ (posedge clk_125 )
  	begin
  		if(rd_nxt_state == FRAME_S)
  			begin 
  			if(cnt < 8'd60)	
  				cnt <= cnt + 1;
  			else
  				cnt <= cnt ;
  			end
  		else
  			cnt <= 0;
  	end 
  	
  	always @ (posedge clk_125)
  	begin
  		if(cnt > 8'd32)	
  		begin
  			if(ts_cnt >= 8'd188)
  				ts_cnt <= 8'd1;
  			else
  				ts_cnt <= ts_cnt + 1;	
  		end
  		else
  		begin
  			ts_cnt <= 8'd0;
  		end
  	end
  	 
	always @ (posedge clk_125 ) 
    begin
        if (reset) 
            pcr_state <= IDLE ;
        else 
        begin
        	if(rd_state == FRAME_S)
        	begin
            	case ( pcr_state )
            	    IDLE: 
            	    	begin
            	    	    if ( ts_cnt == 8'd1 && rd_dout == 8'h47) //cnt == 8'd34
            	    	    pcr_state <= BYTE1 ;
            	    	    else 
            	    	    pcr_state <= IDLE ;
            	    	end
            	    BYTE1:
            	    	pcr_state	<= BYTE2;
            	    BYTE2:
            	    	pcr_state	<= BYTE3;
            	    BYTE3:
            	    	begin
            	    		if(rd_dout[5] == 1'b1)
            	    			pcr_state	<= BYTE4;
            	    		else
            	    			pcr_state	<= IDLE;
            	    	end
            	    BYTE4:
            	    	begin
            	    		if(rd_dout > 0)
            	    			pcr_state	<= BYTE5;
            	    		else
            	    			pcr_state	<= IDLE;
            	    	end
            	    BYTE5:
            	    	begin
            	    		if(rd_dout[4] == 1'b1)
            	    			pcr_state	<= BYTE6;
            	    		else
            	    			pcr_state	<= IDLE;
            	    	end
            	    BYTE6:
            	    	pcr_state	<= BYTE7;
            	    BYTE7:
            	    	pcr_state	<= BYTE8;
            	    BYTE8:
            	    	pcr_state	<= BYTE9;
            	    BYTE9:
            	    	pcr_state	<= BYTE10;
            	    BYTE10:
            	    	pcr_state	<= BYTE11;
            	    BYTE11: 
            	    	pcr_state	<= BYTE12;
            	    BYTE12:
            	    	pcr_state	<= IDLE;
            	    default: 
            	        pcr_state 	<= IDLE ;            	    
            	endcase
           end
           else
            pcr_state 	<= IDLE ;
        end
    end    
  
  always @(posedge clk_125)
	begin
		if (pcr_state == BYTE10)
		begin
			pcr_base_cnt_r	<= pcr_base_cnt;
			pcr_ext_cnt_r		<= pcr_ext_cnt;
		end
		else
		begin
			pcr_base_cnt_r	<= pcr_base_cnt_r;
			pcr_ext_cnt_r	<= pcr_ext_cnt_r;
		end
	end
	
	always @(posedge clk_125)
	begin
		if(pcr_state == BYTE11)// && pcr_din_dvalid == 1'b1)
		begin
			pcr_ext_cnt_r1	<= 300 - pcr_ext_cnt_r;
		end
		else
		begin
			pcr_ext_cnt_r1	<= pcr_ext_cnt_r1;
		end
	end
	
	always @(posedge clk_125)
	begin
        if (rd_nxt_state != WAIT_ACK_S)
	   	begin
		if(pcr_state == BYTE12)
        begin
			if(data_in_r[8:0]  >= pcr_ext_cnt_r1)
			begin 
				{pcr_dout[7:0],data_in_r[47:23]}	<= (data_in_r[47:15] + pcr_base_cnt_r) + 1;
				data_in_r[22:17]					<= 6'b0;
				data_in_r[16:8]						<= data_in_r[8:0] - pcr_ext_cnt_r1;
				data_in_r[7:0]						<= rd_dout;
			end
			else
			begin
				{pcr_dout[7:0],data_in_r[47:23]}	<= data_in_r[47:15] + pcr_base_cnt_r;
				data_in_r[22:17]					<= 6'b0;
				data_in_r[16:8]						<= data_in_r[8:0] + pcr_ext_cnt_r;
				data_in_r[7:0]						<= rd_dout;
			end
		end
        else
              begin
              data_in_r[7:0]	<= rd_dout ;
			  data_in_r[15:8]	<= data_in_r[7:0];
			  data_in_r[23:16]	<= data_in_r[15:8];
              data_in_r[31:24]	<= data_in_r[23:16];
              data_in_r[39:32]	<= data_in_r[31:24];
              data_in_r[47:40]	<= data_in_r[39:32];
              pcr_dout			<= data_in_r[47:40];
              end              
        end
	end       
	
//----------------------------------------------------

 
	tx_fifo_4096 		tx_fifo_4096_init 
	(
		.clk			(clk_125				),
		.rst			(reset					),
		.din			({end_flag,wr_data2fifo}), 
		.wr_en			(wr_data2fifo_en		),
		.rd_en			(rd_en					),
		.dout			(rd_dout				), 
		.empty			(empty					),
		.prog_full		(fifo_p_full			)
	); 

//----------------------------------------------------
 
endmodule