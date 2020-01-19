`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:33:56 06/20/2011 
// Design Name: 
// Module Name:    udp_public 
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
module udp_public(
	input	[31:0]		local_ip	,
	input	[47:0]		local_mac	,

	input				clk	,
	input				rst	,
	input	[7:0]		rx_data			,
	input				rx_data_valid	,
	
	output	reg	[7:0]	tx_data			,
	output	reg			tx_data_valid	,


    
    output	reg		[47:0]		src_mac

    );
    
    parameter		IDLE_S	= 3'b000,
    				FRAME_S	= 3'b001,
    				END_S	= 3'b010;
    				
    reg		[2:0]		state		;
    reg		[2:0]		next_state	;
    				
    reg		[7:0]		rx_data_r		;
    reg					rx_data_valid_r	;
    reg					data_start_en	;
    reg					data_end_en		;
    
    reg		[5:0]		cnt				;
    reg		[31:0]		src_ip			;
    reg		[15:0]		src_port		;
	reg		[47:0]		frame_content	;
    reg					data_process_en	;
    
    
    always @(posedge clk)
    begin
    	if ((cnt >= 6'd6)&&(cnt <= 6'd11))
    		src_mac	<= {src_mac[39:0], rx_data_r};
    	else
    		src_mac	<= src_mac;
    end
    
    initial
    begin
    	src_ip		  = 0;
    	frame_content = 0;
    	data_process_en = 0;
    end

    always @(posedge clk)
    begin
    	rx_data_r		<= rx_data	;
    	rx_data_valid_r	<= rx_data_valid;
    	data_start_en	<= (rx_data_valid & (!rx_data_valid_r));
    	data_end_en		<= ((!rx_data_valid) & rx_data_valid_r);
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
    			if (data_start_en)
    				next_state	= FRAME_S;
    			else
    				next_state	= IDLE_S;
    		end
    		FRAME_S:
    		begin
    			if (data_end_en)
    				next_state	= END_S;
    			else if (data_process_en)
    				next_state	= IDLE_S;
    			else
    				next_state	= FRAME_S;
    		end
    		
    		default:
    			next_state	= IDLE_S;
    	endcase
    end
   
    // counter -----------------------------
    always @(posedge clk)
    begin
    	if (next_state == FRAME_S)
    	begin
    		if (cnt > 6'd42)
    			cnt	<= cnt;
    		else
	    		cnt	<= cnt + 6'd1;
	    end
    	else
    	begin
    		cnt	<= 6'd0;
    	end
    end
   
    // record -----------------------------
    always @(posedge clk)
    begin
//    	if ((cnt >= 6'd26) && (cnt <= 6'd29))
    	if ((cnt >= 6'd30) && (cnt <= 6'd33))
    		src_ip	<= {src_ip[23:0], rx_data_r};
    	else
    		src_ip	<= src_ip;
    end
    
    always @(posedge clk)
    begin
//    	if ((cnt >= 6'd34) && (cnt <= 6'd35))
    	if ((cnt >= 6'd36) && (cnt <= 6'd37))
    		src_port	<= {src_port[7:0], rx_data_r};
    	else
    		src_port	<= src_port;
    end
    
	always @(posedge clk)
	begin
		if (next_state == FRAME_S)
			frame_content	<= {frame_content[39:0], rx_data_r};
		else
			frame_content	<= 48'd0;
	end
	
	always @(posedge clk)
	begin
		if (data_process_en)
		begin
			data_process_en <= 1'b0;
		end
		else if (cnt == 6'd6)
		begin
			if ((frame_content[47:40] < 8'h01)&&(frame_content != local_mac))
				data_process_en	<= 1'b1;
		end
		else if ((cnt == 6'd14)&&(frame_content[15:0] != 16'h0800))
		begin
			data_process_en <= 1'b1;
		end
		else if ((cnt == 6'd24)&&(frame_content[7:0] != 8'h11))
		begin
			data_process_en <= 1'b1;
		end
		else if (cnt == 6'd34)	// ip
		begin
			if (frame_content[31:24] >= 8'hE0)
				data_process_en <= 1'b0;
			else if (frame_content[31:0] != local_ip)
				data_process_en	<= 1'b1;
		end
	end
    
    // output -------------------------------
    always @(posedge clk)
    begin
    	if (next_state == FRAME_S)
    	begin
    		if (cnt < 6'd42)
    		begin
    			case (cnt)
    				6'd36:begin tx_data <= src_ip[31:24]; tx_data_valid <= 1'b1;	end
    				6'd37:begin tx_data <= src_ip[23:16]; tx_data_valid <= 1'b1;	end
    				6'd38:begin tx_data <= src_ip[15:8]; tx_data_valid <= 1'b1;	end
    				6'd39:begin tx_data <= src_ip[7:0]; tx_data_valid <= 1'b1;	end
    				6'd40:begin tx_data <= src_port[15:8]; tx_data_valid <= 1'b1;	end
    				6'd41:begin tx_data <= src_port[7:0]; tx_data_valid <= 1'b1;	end
    				
    				default:
    				begin
    					tx_data	<= 8'h00;
    					tx_data_valid <= 1'b0;
    				end
    			endcase
    		end
    		else
    		begin
    			tx_data			<= rx_data_r;
    			tx_data_valid	<= 1'b1;
    		end
    	end
    	else
    	begin
    		tx_data			<= 8'h00;
    		tx_data_valid	<= 1'b0;
    	end
    end
    
endmodule
