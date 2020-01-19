`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:58:18 07/10/2011 
// Design Name: 
// Module Name:    emac_recv 
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
module emac_recv_gtx(
	input				clk	,
	input				rst	,
	input	[7:0]		gmii_rxd	,
	input				gmii_rx_dv	,
	input				gmii_rx_er	,
	input				crc_en		,
	input				crc_err		,
	output	reg	[7:0]	rx_data		,
	output	reg			rx_data_valid	,
	output	reg			rx_good		,
	output	reg			rx_bad		,
	
	
    output	reg		[2:0]		next_state		,
    output	reg		[7:0]		gmii_rxd0_r		,
    output	reg		[7:0]		gmii_rxd1_r		,
    output	reg		[7:0]		gmii_rxd2_r		,
    output	reg		[7:0]		gmii_rxd3_r		,
    output	reg					gmii_rx_en0_r	,
    output	reg					gmii_rx_en1_r	,
    output	reg					gmii_rx_en2_r	,
    output	reg					gmii_rx_en3_r	,
    output	reg					rx_start_en		
//    output	reg		[3:0]		pre_cnt			
	
    );
    
    parameter	IDLE_S	= 3'b000,
    			PRE_S	= 3'b001,
    			FRAME_S	= 3'b010,
    			END_S	= 3'b011,
    			GF_S	= 3'b100,
    			BF_S	= 3'b101;
    			
    reg		[2:0]		state		;
//    reg		[1:0]		next_state	;
    
//    reg		[7:0]		gmii_rxd0_r	;
//    reg		[7:0]		gmii_rxd1_r	;
//    reg		[7:0]		gmii_rxd2_r	;
//    reg		[7:0]		gmii_rxd3_r	;
//    reg					gmii_rx_en0_r	;
//    reg					gmii_rx_en1_r	;
//    reg					gmii_rx_en2_r	;
//    reg					gmii_rx_en3_r	;
//    reg					rx_start_en		;
//    reg		[3:0]		pre_cnt		;
	reg						pre_sel		;
    
    // async -------------------------------------
    always @(posedge clk)
    begin
    	gmii_rxd0_r		<= gmii_rxd		;
    	gmii_rxd1_r		<= gmii_rxd0_r	;
    	gmii_rxd2_r		<= gmii_rxd1_r	;
    	gmii_rxd3_r		<= gmii_rxd2_r	;
    	
    	gmii_rx_en0_r	<= gmii_rx_dv		;
    	gmii_rx_en1_r   <= gmii_rx_en0_r    ;
    	gmii_rx_en2_r   <= gmii_rx_en1_r    ;
    	gmii_rx_en3_r   <= gmii_rx_en2_r    ;
    	
    	rx_start_en		<= (gmii_rx_en2_r && (!gmii_rx_en3_r));
    end
    
    // state machine ---------------------------
    always @(posedge clk)
    begin
    	if (rst)
    		state	<= IDLE_S		;
    	else
    		state	<= next_state	;
    end
    
    always @(*)
    begin
    	case (state)
    		IDLE_S:
    		begin
    			if (rx_start_en)
    				next_state	= PRE_S;
    			else
    				next_state	= IDLE_S;
    		end
    		PRE_S:
    		begin
    			if (gmii_rx_er)
    				next_state	= IDLE_S;
    			else if (pre_sel)
    				next_state	= FRAME_S;
    			else
    				next_state	= PRE_S;
    		end
    		FRAME_S:
    		begin
//    			if (gmii_rx_er)
//    				next_state	= BF_S;
//    			else if (gmii_rx_dv == 1'b0)
//    				next_state	= END_S;
/////////////////////pcs/PMa EXTENSION 模式无法处理，故作如下修改
				if (gmii_rx_dv == 1'b0)
    				next_state	= END_S;
				else if (gmii_rx_er)
    				next_state	= BF_S;    			
    			else
    				next_state	= FRAME_S;
    		end
    		END_S:
    		begin
    			if (crc_en && crc_err)
    				next_state	=	BF_S;
    			else if (crc_en)
    				next_state	= 	GF_S;
    			else
    				next_state	= END_S;
    		end
    		
    		default:
    			next_state	= IDLE_S;
    	endcase
    end
    
    // counter ---------------------------------
//    always @(posedge clk)
//    begin
//    	if (next_state == PRE_S)
//    		pre_cnt	<= pre_cnt + 4'd1;
//    	else
//    		pre_cnt	<= 4'd0;
//    end
    
    always @(posedge clk)
    begin
    	if (next_state == PRE_S)
    	begin
    		if /*(pre_cnt <= 4'd7)&&*/(gmii_rxd3_r == 8'hD5)
    			pre_sel	<= 1'b1;
    		else
    			pre_sel	<= 1'b0;
    	end
    	else
    	begin
    		pre_sel	<= 1'b0;
    	end
    end
    
    // output ---------------------------------
    always @(posedge clk)
    begin
    	if (next_state == FRAME_S)
    	begin
    		rx_data			<= gmii_rxd3_r;
    		rx_data_valid	<= gmii_rx_en3_r;
    	end
    	else
    	begin
    		rx_data			<= 8'h00;
    		rx_data_valid	<= 1'b0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if (next_state == GF_S)
    		rx_good	<= 1'b1;
    	else
    		rx_good	<= 1'b0;
    end

    always @(posedge clk)
    begin
    	if (next_state == BF_S)
    		rx_bad	<= 1'b1;
    	else
    		rx_bad	<= 1'b0;
    end

endmodule
