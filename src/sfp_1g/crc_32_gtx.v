`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:38:12 06/27/2011 
// Design Name: 
// Module Name:    crc_32 
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
module crc_32_gtx(
	input				clk,
	input				rst,
	input	[7:0]		rx_data,
	input				rx_data_valid,
	input				rx_ack,
	
	output	reg	[7:0]	tx_data,
	output	reg			tx_data_valid,


    output	reg		[1:0]		next_state,
	output	reg		[5:0]		cnt			,
    output	reg		[31:0]		newcrc		
    );
    
    parameter		IDLE_S = 2'b00,
    				READ_S = 2'b01,
    				SEND_S = 2'b10,
    				DLY_S  = 2'b11;
    				
    reg		[1:0]		state		;
//    reg		[1:0]		next_state	;
    
    reg		[2:0]		send_cnt		;
//    reg		[7:0]		d;
//    reg		[31:0]		c;
//	reg		[5:0]		cnt		;
//    reg		[31:0]		newcrc;
    
    initial
    begin
    	send_cnt = 0;
    end
    
    // state machine ------------------------
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
    			if (rx_ack)
    				next_state	<= READ_S;
    			else
    				next_state	<= IDLE_S;
    		end
    		READ_S:
    		begin
    			if (rx_data_valid == 1'b0)
    				if (cnt < 6'd60)
    					next_state <= DLY_S;
    				else
	    				next_state	<= SEND_S;
    			else
    				next_state	<= READ_S;
    		end
    		DLY_S:
    		begin
    			if (cnt == 6'd60)
    				next_state	<= SEND_S;
    			else
    				next_state	<= DLY_S;
    		end
    		SEND_S:
    		begin
    			if (send_cnt == 3'd4)
    				next_state	<= IDLE_S;
    			else
    				next_state	<= SEND_S;
    		end
    		
    		default:
    			next_state	<= IDLE_S;
    	endcase
    end
    
    always @(posedge clk)
    begin
    	if (next_state == IDLE_S)
    		cnt	<= 6'd0;
    	else if (cnt == 6'd62)
    		cnt <= cnt;
    	else if ((next_state == READ_S)||(next_state == DLY_S))
    		cnt	<= cnt + 6'd1;
    	else
    		cnt <= 6'd0;
    end

    // counter -----------------------------------
//    always @(posedge clk)
//    begin
//    	if (next_state == SEND_S)
//    		send_cnt	<= send_cnt + 3'd1;
//    	else
//    		send_cnt	<= 3'd0;
//    end
    
    // crc-32 -----------------------------------
//	always @(posedge clk) 
//	begin
//	if(rst)
//		d	<= 8'd0;
//	else if(rx_data_valid)
//		d	<= rx_data;
//	else
//		d	<= 8'd0 ;
//	end
//    
	always @(posedge clk)
	if(rst)
		newcrc<=32'hffffffff;
	else if (next_state == READ_S)
	begin
		newcrc[0]  <= rx_data[2] ^  newcrc[2] ^ newcrc[8];
		newcrc[1]  <= rx_data[0] ^  rx_data[3] ^ newcrc[0] ^ newcrc[3]  ^ newcrc[9];
		newcrc[2]  <= rx_data[0] ^  rx_data[1] ^ rx_data[4] ^ newcrc[0]  ^ newcrc[1] ^ newcrc[4] ^ newcrc[10];
		newcrc[3]  <= rx_data[1] ^  rx_data[2] ^ rx_data[5] ^ newcrc[1]  ^ newcrc[2] ^ newcrc[5] ^ newcrc[11];
		newcrc[4]  <= rx_data[0] ^  rx_data[2] ^ rx_data[3] ^ rx_data[6]  ^ newcrc[0] ^ newcrc[2] ^ newcrc[3] ^ newcrc[6] ^ newcrc[12];
		newcrc[5]  <= rx_data[1] ^  rx_data[3] ^ rx_data[4] ^ rx_data[7]  ^ newcrc[1] ^ newcrc[3] ^ newcrc[4] ^ newcrc[7] ^ newcrc[13];
		newcrc[6]  <= rx_data[4] ^  rx_data[5] ^ newcrc[4] ^ newcrc[5]  ^ newcrc[14];
		newcrc[7]  <= rx_data[0] ^  rx_data[5] ^ rx_data[6] ^ newcrc[0] ^ newcrc[5] ^ newcrc[6] ^ newcrc[15];
		newcrc[8]  <= rx_data[1] ^  rx_data[6] ^ rx_data[7] ^ newcrc[1] ^ newcrc[6] ^ newcrc[7]^newcrc[16] ;
		newcrc[9]  <= rx_data[7] ^  newcrc[7] ^ newcrc[17] ;
		newcrc[10] <= rx_data[2] ^  newcrc[2] ^ newcrc[18] ;
		newcrc[11] <= rx_data[3] ^  newcrc[3] ^ newcrc[19] ;
		newcrc[12] <= rx_data[0] ^  rx_data[4] ^ newcrc[0] ^ newcrc[4] ^ newcrc[20] ;
		newcrc[13] <= rx_data[0] ^  rx_data[1] ^ rx_data[5] ^ newcrc[0] ^ newcrc[1] ^ newcrc[5] ^ newcrc[21];
		newcrc[14] <= rx_data[1] ^  rx_data[2] ^ rx_data[6] ^ newcrc[1] ^ newcrc[2] ^ newcrc[6] ^ newcrc[22];
		newcrc[15] <= rx_data[2] ^  rx_data[7] ^ rx_data[3] ^ newcrc[7] ^ newcrc[2] ^ newcrc[3] ^ newcrc[23];
		newcrc[16] <= rx_data[0] ^  rx_data[2] ^ rx_data[3] ^ rx_data[4] ^ newcrc[0] ^ newcrc[2] ^ newcrc[3] ^ newcrc[4] ^ newcrc[24];
		newcrc[17] <= rx_data[0] ^  rx_data[1] ^ rx_data[3] ^ rx_data[4] ^ rx_data[5] ^ newcrc[0] ^ newcrc[1] ^ newcrc[3] ^ newcrc[4] ^ newcrc[5] ^ newcrc[25];
		newcrc[18] <= rx_data[0] ^  rx_data[1] ^ rx_data[2] ^ rx_data[4] ^ rx_data[5] ^ rx_data[6] ^ newcrc[0] ^ newcrc[1] ^ newcrc[2] ^ newcrc[5] ^ newcrc[4] ^ newcrc[6] ^ newcrc[26];
		newcrc[19] <= rx_data[1] ^  rx_data[2] ^ rx_data[3] ^ rx_data[5] ^ rx_data[6] ^ rx_data[7] ^ newcrc[1] ^ newcrc[2] ^ newcrc[3] ^ newcrc[5] ^ newcrc[6] ^ newcrc[7] ^ newcrc[27];
		newcrc[20] <= rx_data[3] ^  rx_data[4] ^ rx_data[6] ^ rx_data[7] ^ newcrc[3] ^ newcrc[4] ^ newcrc[6] ^ newcrc[7] ^ newcrc[28];
		newcrc[21] <= rx_data[2] ^  rx_data[4] ^ rx_data[5] ^ rx_data[7] ^ newcrc[2] ^ newcrc[4] ^ newcrc[5] ^ newcrc[7] ^ newcrc[29];
		newcrc[22] <= rx_data[2] ^  rx_data[3] ^ rx_data[5] ^ rx_data[6] ^ newcrc[2] ^ newcrc[3] ^ newcrc[5] ^ newcrc[6] ^ newcrc[30];
		newcrc[23] <= rx_data[3] ^  rx_data[4] ^ rx_data[6] ^ rx_data[7] ^ newcrc[3] ^ newcrc[4] ^ newcrc[6] ^ newcrc[7] ^ newcrc[31];
		newcrc[24] <= rx_data[0] ^  rx_data[2] ^ rx_data[4] ^ rx_data[5] ^ rx_data[7] ^ newcrc[0] ^ newcrc[2] ^ newcrc[4] ^ newcrc[5] ^ newcrc[7];
		newcrc[25] <= rx_data[0] ^  rx_data[1] ^ rx_data[2] ^ rx_data[3] ^ rx_data[5] ^ rx_data[6] ^ newcrc[0] ^ newcrc[1] ^ newcrc[2] ^ newcrc[3] ^ newcrc[5] ^ newcrc[6];
		newcrc[26] <= rx_data[0] ^  rx_data[1] ^ rx_data[2] ^ rx_data[3] ^ rx_data[4] ^ rx_data[6] ^ rx_data[7] ^ newcrc[0] ^ newcrc[1] ^ newcrc[2] ^ newcrc[3] ^ newcrc[4] ^ newcrc[6] ^ newcrc[7];
		newcrc[27] <= rx_data[1] ^  rx_data[3] ^ rx_data[4] ^ rx_data[5] ^ rx_data[7] ^ newcrc[1] ^ newcrc[4] ^ newcrc[3] ^ newcrc[5] ^ newcrc[7];
		newcrc[28] <= rx_data[0] ^  rx_data[4] ^ rx_data[5] ^ rx_data[6] ^ newcrc[0] ^ newcrc[4] ^ newcrc[5] ^ newcrc[6];
		newcrc[29] <= rx_data[0] ^  rx_data[1] ^ rx_data[5] ^ rx_data[6] ^ rx_data[7] ^ newcrc[0] ^ newcrc[1] ^ newcrc[5] ^ newcrc[6] ^ newcrc[7];
		newcrc[30] <= rx_data[0] ^  rx_data[1] ^ rx_data[6] ^ rx_data[7] ^ newcrc[0] ^ newcrc[1] ^ newcrc[6] ^newcrc[7];
		newcrc[31] <= rx_data[1] ^  rx_data[7] ^ newcrc[1] ^ newcrc[7];
	end
	else if (next_state == DLY_S)
	begin
		newcrc[0]  <= newcrc[2] ^ newcrc[8];
		newcrc[1]  <= newcrc[0] ^ newcrc[3]  ^ newcrc[9];
		newcrc[2]  <= newcrc[0]  ^ newcrc[1] ^ newcrc[4] ^ newcrc[10];
		newcrc[3]  <= newcrc[1]  ^ newcrc[2] ^ newcrc[5] ^ newcrc[11];
		newcrc[4]  <= newcrc[0] ^ newcrc[2] ^ newcrc[3] ^ newcrc[6] ^ newcrc[12];
		newcrc[5]  <= newcrc[1] ^ newcrc[3] ^ newcrc[4] ^ newcrc[7] ^ newcrc[13];
		newcrc[6]  <= newcrc[4] ^ newcrc[5]  ^ newcrc[14];
		newcrc[7]  <= newcrc[0] ^ newcrc[5] ^ newcrc[6] ^ newcrc[15];
		newcrc[8]  <= newcrc[1] ^ newcrc[6] ^ newcrc[7]^newcrc[16] ;
		newcrc[9]  <= newcrc[7] ^ newcrc[17] ;
		newcrc[10] <= newcrc[2] ^ newcrc[18] ;
		newcrc[11] <= newcrc[3] ^ newcrc[19] ;
		newcrc[12] <= newcrc[0] ^ newcrc[4] ^ newcrc[20] ;
		newcrc[13] <= newcrc[0] ^ newcrc[1] ^ newcrc[5] ^ newcrc[21];
		newcrc[14] <= newcrc[1] ^ newcrc[2] ^ newcrc[6] ^ newcrc[22];
		newcrc[15] <= newcrc[7] ^ newcrc[2] ^ newcrc[3] ^ newcrc[23];
		newcrc[16] <= newcrc[0] ^ newcrc[2] ^ newcrc[3] ^ newcrc[4] ^ newcrc[24];
		newcrc[17] <= newcrc[0] ^ newcrc[1] ^ newcrc[3] ^ newcrc[4] ^ newcrc[5] ^ newcrc[25];
		newcrc[18] <= newcrc[0] ^ newcrc[1] ^ newcrc[2] ^ newcrc[5] ^ newcrc[4] ^ newcrc[6] ^ newcrc[26];
		newcrc[19] <= newcrc[1] ^ newcrc[2] ^ newcrc[3] ^ newcrc[5] ^ newcrc[6] ^ newcrc[7] ^ newcrc[27];
		newcrc[20] <= newcrc[3] ^ newcrc[4] ^ newcrc[6] ^ newcrc[7] ^ newcrc[28];
		newcrc[21] <= newcrc[2] ^ newcrc[4] ^ newcrc[5] ^ newcrc[7] ^ newcrc[29];
		newcrc[22] <= newcrc[2] ^ newcrc[3] ^ newcrc[5] ^ newcrc[6] ^ newcrc[30];
		newcrc[23] <= newcrc[3] ^ newcrc[4] ^ newcrc[6] ^ newcrc[7] ^ newcrc[31];
		newcrc[24] <= newcrc[0] ^ newcrc[2] ^ newcrc[4] ^ newcrc[5] ^ newcrc[7];
		newcrc[25] <= newcrc[0] ^ newcrc[1] ^ newcrc[2] ^ newcrc[3] ^ newcrc[5] ^ newcrc[6];
		newcrc[26] <= newcrc[0] ^ newcrc[1] ^ newcrc[2] ^ newcrc[3] ^ newcrc[4] ^ newcrc[6] ^ newcrc[7];
		newcrc[27] <= newcrc[1] ^ newcrc[4] ^ newcrc[3] ^ newcrc[5] ^ newcrc[7];
		newcrc[28] <= newcrc[0] ^ newcrc[4] ^ newcrc[5] ^ newcrc[6];
		newcrc[29] <= newcrc[0] ^ newcrc[1] ^ newcrc[5] ^ newcrc[6] ^ newcrc[7];
		newcrc[30] <= newcrc[0] ^ newcrc[1] ^ newcrc[6] ^newcrc[7];
		newcrc[31] <= newcrc[1] ^ newcrc[7];
	end
	else if((next_state == SEND_S)||(state == SEND_S))
		newcrc   <=   newcrc;
	else
		newcrc   <=   32'hffffffff;

//	always @(*)
//	if(rst)
//		c	<= 32'hffffffff;
//	else
//		c	<= newcrc;
//		
	// output ----------------------------------------------
	always @(posedge clk)
	if(rst)
	begin
		tx_data 	<=   8'd0;
		send_cnt    <=   3'd0;
		tx_data_valid	<= 1'b0;
	end
	else if(next_state == SEND_S)
	begin
		send_cnt      <=   send_cnt+1;
		tx_data_valid <= 1'b1;
		
		if (send_cnt==3'd0)
			tx_data <=  ~newcrc[7:0];
		else if(send_cnt==3'd1)
			tx_data <=  ~newcrc[15:8];
		else if(send_cnt==3'd2)
			tx_data <=  ~newcrc[23:16];
		else if(send_cnt==3'd3)
			tx_data <=  ~newcrc[31:24];
	end
	else
	begin
		tx_data <=  8'd0;
		send_cnt      <=  3'd0;
		tx_data_valid <= 1'b0;
	end
	
	

endmodule
