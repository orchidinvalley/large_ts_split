`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:46 11/26/2011 
// Design Name: 
// Module Name:    cmd_sfp_ip_new 
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
module cmd_sfp_ip_new(
	input				clk	,
	input				rst	,
	input	[7:0]		rx_data		,
	input				rx_data_en	,
	output	reg	[7:0]	tx_data		,
	output	reg			tx_data_en	,
	output	reg	[31:0]	sfp1_ip		,
	output	reg	[47:0]	sfp1_mac	,
	output	reg	[31:0]	sfp2_ip		,
	output	reg	[47:0]	sfp2_mac	,
	output	reg	[31:0]	sfp3_ip		,
	output	reg	[47:0]	sfp3_mac	,
	output	reg	[31:0]	sfp4_ip		,
	output	reg	[47:0]	sfp4_mac	
//	output	reg	[31:0]	sfp5_ip		,
//	output	reg	[47:0]	sfp5_mac	,
//	output	reg	[31:0]	sfp6_ip		,
//	output	reg	[47:0]	sfp6_mac	,
//	output	reg	[31:0]	sfp7_ip		,
//	output	reg	[47:0]	sfp7_mac	,
//	output	reg	[31:0]	sfp8_ip		,
//	output	reg	[47:0]	sfp8_mac	,
//	output	reg	[31:0]	sfp9_ip		,
//	output	reg	[47:0]	sfp9_mac	,
//	output	reg	[31:0]	sfp10_ip	,
//	output	reg	[47:0]	sfp10_mac	,
//	output	reg	[31:0]	sfp11_ip	,
//	output	reg	[47:0]	sfp11_mac	,
//	output	reg	[31:0]	sfp12_ip	,
//	output	reg	[47:0]	sfp12_mac	,
//	output	reg	[31:0]	sfp13_ip	,
//	output	reg	[47:0]	sfp13_mac	,
//	output	reg	[31:0]	sfp14_ip	,
//	output	reg	[47:0]	sfp14_mac	,
//	output	reg	[31:0]	sfp15_ip	,
//	output	reg	[47:0]	sfp15_mac	,
//	output	reg	[31:0]	sfp16_ip	,
//	output	reg	[47:0]	sfp16_mac	,
//	output	reg	[31:0]	sfp17_ip	,
//	output	reg	[47:0]	sfp17_mac	,
//	output	reg	[31:0]	sfp18_ip	,
//	output	reg	[47:0]	sfp18_mac	,
//	output	reg	[31:0]	sfp19_ip	,
//	output	reg	[47:0]	sfp19_mac	,
//	output	reg	[31:0]	sfp20_ip	,
//	output	reg	[47:0]	sfp20_mac	,

//    output	reg		[11:0]		head_cnt		,
//    output	reg		[1:0]		send_flag		,// 2'b01:read; 2'b10:write
//    output	reg		[3:0]		read_sel		,
//    output	reg		[3:0]		write_sel		,
//    output	reg		[7:0]		local_rocket	,
//    output	reg		[47:0]		local_mac		,
//    output	reg		[31:0]		local_ip		,
//    output	reg		[7:0]		send_cnt	

    );
	reg		[7:0]		data_r[0:7];
	reg		[3:0]		send_flag_cnt;
////////////////////////////////////////
    reg		[11:0]		head_cnt;		
    reg		[1:0]		send_flag;		// 2'b01:read; 2'b10:write
    reg		[3:0]		read_sel;		
    reg		[3:0]		write_sel;		
    reg		[7:0]		local_rocket;	
    reg		[47:0]		local_mac;		
    reg		[31:0]		local_ip;		
    reg		[7:0]		send_cnt;	
////////////////////////////////////////
    
    always @(posedge clk)
    begin
    	if (rx_data_en)
    		head_cnt <= head_cnt + 12'd1;
    	else
    		head_cnt <= 12'd0;
    end
    

    always @(posedge clk)
    begin
    	if (rx_data_en)
    	begin
    		case ({head_cnt,read_sel, rx_data})
    			{12'd0,4'd0, 8'h04}:	read_sel <= 4'd1;
    			{12'd1,4'd1, 8'h0b}:	read_sel <= 4'd2;
    			{12'd2,4'd2, rx_data}:	read_sel <= 4'd3;
    			{12'd3,4'd3, rx_data}:	read_sel <= 4'd4;
    			{12'd4,4'd4, rx_data}:	read_sel <= 4'd5;
    			{12'd5,4'd5, rx_data}:	read_sel <= 4'd6;
    			{12'd6,4'd6, rx_data}:	read_sel <= 4'd7;
    			{12'd7,4'd7, rx_data}:	read_sel <= 4'd8;
    			{12'd8,4'd8, rx_data}:read_sel <= 4'd9;    			
    			default:
    				read_sel <= read_sel;
    		endcase
    	end
    	else
    	begin
    		read_sel <= 4'd0;
    	end
    end

    always @(posedge clk)
    begin
    	if (rx_data_en)
    	begin
    		case ({head_cnt,write_sel, rx_data})
    			{12'd0,4'd0, 8'h40}:	write_sel <= 4'd1;
    			{12'd1,4'd1, 8'h0b}:	write_sel <= 4'd2;
    			{12'd2,4'd2, rx_data}:	write_sel <= 4'd3;
    			{12'd3,4'd3, rx_data}:	write_sel <= 4'd4;
    			{12'd4,4'd4, rx_data}:	write_sel <= 4'd5;
    			{12'd5,4'd5, rx_data}:	write_sel <= 4'd6;
    			{12'd6,4'd6, rx_data}:	write_sel <= 4'd7;
    			{12'd7,4'd7, rx_data}:	write_sel <= 4'd8;
    			{12'd8,4'd8, rx_data}: write_sel <= 4'd9;
    			
    			default:
    				write_sel <= write_sel;
    		endcase
    	end
    	else
    	begin
    		write_sel <= 4'd0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if ((send_flag == 2'b01)&&(send_cnt == 8'd64/*8'd240*/))
    		send_flag <= 2'b00;
    	else if (read_sel == 4'd8)
    		send_flag <= 2'b01;
    	else
    		send_flag <= send_flag;
    end
    
    always @(posedge clk)
    begin
    	if ((send_flag == 2'b01)&&(send_flag_cnt < 4'd8))
    		send_flag_cnt <= send_flag_cnt + 4'd1;
    	else if (send_flag == 2'b01)
    		send_flag_cnt <= send_flag_cnt;
    	else
    		send_flag_cnt <= 4'd0;
    end
    
    always @(posedge clk)
    begin
    	if ((send_flag != 2'b00)&&(send_flag_cnt >= 4'd8))
    		send_cnt <= send_cnt + 8'd1;
    	else
    		send_cnt <= 8'd0;
    end
    
    always @(posedge clk)
    begin
    	if ((head_cnt < 12'd8) && rx_data_en)
    	begin
    		data_r[0]	<= rx_data;
    		data_r[1]	<= data_r[0];
    		data_r[2]	<= data_r[1];
    		data_r[3]	<= data_r[2];
    		data_r[4]	<= data_r[3];
    		data_r[5]	<= data_r[4];
    		data_r[6]	<= data_r[5];
    		data_r[7]	<= data_r[6];
    	end
    end
    
    // output for reply
    always @(posedge clk)
    begin
    	if (send_flag == 2'b01)
    	begin
    		case (send_cnt)
    			8'd13:	begin tx_data <= data_r[7]; tx_data_en <= 1'b1; end
    			8'd14:	begin tx_data <= data_r[6]; tx_data_en <= 1'b1; end
    			8'd15:	begin tx_data <= data_r[5]; tx_data_en <= 1'b1; end
    			8'd16:	begin tx_data <= data_r[4]; tx_data_en <= 1'b1; end
    			8'd17:	begin tx_data <= data_r[3]; tx_data_en <= 1'b1; end
    			8'd18:	begin tx_data <= data_r[2]; tx_data_en <= 1'b1; end
    			8'd19:	begin tx_data <= data_r[1]; tx_data_en <= 1'b1; end
    			8'd20:	begin tx_data <= data_r[0]; tx_data_en <= 1'b1; end

    			8'd21:	begin tx_data <= 8'h01; tx_data_en <= 1'b1; end
    			8'd22:	begin tx_data <= sfp1_mac[47:40]; tx_data_en <= 1'b1; end
    			8'd23:	begin tx_data <= sfp1_mac[39:32]; tx_data_en <= 1'b1; end
    			8'd24:	begin tx_data <= sfp1_mac[31:24]; tx_data_en <= 1'b1; end
    			8'd25:	begin tx_data <= sfp1_mac[23:16]; tx_data_en <= 1'b1; end
    			8'd26:	begin tx_data <= sfp1_mac[15:8]; tx_data_en <= 1'b1; end
    			8'd27:	begin tx_data <= sfp1_mac[7:0]; tx_data_en <= 1'b1; end
    			8'd28:	begin tx_data <= sfp1_ip[31:24]; tx_data_en <= 1'b1; end
    			8'd29:	begin tx_data <= sfp1_ip[23:16]; tx_data_en <= 1'b1; end
    			8'd30:	begin tx_data <= sfp1_ip[15:8]; tx_data_en <= 1'b1; end
    			8'd31:	begin tx_data <= sfp1_ip[7:0]; tx_data_en <= 1'b1; end
    			8'd32:	begin tx_data <= 8'h02; tx_data_en <= 1'b1; end
    			8'd33:	begin tx_data <= sfp2_mac[47:40]; tx_data_en <= 1'b1; end
    			8'd34:	begin tx_data <= sfp2_mac[39:32]; tx_data_en <= 1'b1; end
    			8'd35:	begin tx_data <= sfp2_mac[31:24]; tx_data_en <= 1'b1; end
    			8'd36:	begin tx_data <= sfp2_mac[23:16]; tx_data_en <= 1'b1; end
    			8'd37:	begin tx_data <= sfp2_mac[15:8]; tx_data_en <= 1'b1; end
    			8'd38:	begin tx_data <= sfp2_mac[7:0]; tx_data_en <= 1'b1; end
    			8'd39:	begin tx_data <= sfp2_ip[31:24]; tx_data_en <= 1'b1; end
    			8'd40:	begin tx_data <= sfp2_ip[23:16]; tx_data_en <= 1'b1; end
    			8'd41:	begin tx_data <= sfp2_ip[15:8]; tx_data_en <= 1'b1; end
    			8'd42:	begin tx_data <= sfp2_ip[7:0]; tx_data_en <= 1'b1; end
    			8'd43:	begin tx_data <= 8'h03; tx_data_en <= 1'b1; end
    			8'd44:	begin tx_data <= sfp3_mac[47:40]; tx_data_en <= 1'b1; end
    			8'd45:	begin tx_data <= sfp3_mac[39:32]; tx_data_en <= 1'b1; end
    			8'd46:	begin tx_data <= sfp3_mac[31:24]; tx_data_en <= 1'b1; end
    			8'd47:	begin tx_data <= sfp3_mac[23:16]; tx_data_en <= 1'b1; end
    			8'd48:	begin tx_data <= sfp3_mac[15:8]; tx_data_en <= 1'b1; end
    			8'd49:	begin tx_data <= sfp3_mac[7:0]; tx_data_en <= 1'b1; end
    			8'd50:	begin tx_data <= sfp3_ip[31:24]; tx_data_en <= 1'b1; end
    			8'd51:	begin tx_data <= sfp3_ip[23:16]; tx_data_en <= 1'b1; end
    			8'd52:	begin tx_data <= sfp3_ip[15:8]; tx_data_en <= 1'b1; end
    			8'd53:	begin tx_data <= sfp3_ip[7:0]; tx_data_en <= 1'b1; end
    			8'd54:	begin tx_data <= 8'h04; tx_data_en <= 1'b1; end
    			8'd55:	begin tx_data <= sfp4_mac[47:40]; tx_data_en <= 1'b1; end
    			8'd56:	begin tx_data <= sfp4_mac[39:32]; tx_data_en <= 1'b1; end
    			8'd57:	begin tx_data <= sfp4_mac[31:24]; tx_data_en <= 1'b1; end
    			8'd58:	begin tx_data <= sfp4_mac[23:16]; tx_data_en <= 1'b1; end
    			8'd59:	begin tx_data <= sfp4_mac[15:8]; tx_data_en <= 1'b1; end
    			8'd60:	begin tx_data <= sfp4_mac[7:0]; tx_data_en <= 1'b1; end
    			8'd61:	begin tx_data <= sfp4_ip[31:24]; tx_data_en <= 1'b1; end
    			8'd62:	begin tx_data <= sfp4_ip[23:16]; tx_data_en <= 1'b1; end
    			8'd63:	begin tx_data <= sfp4_ip[15:8]; tx_data_en <= 1'b1; end
    			8'd64:	begin tx_data <= sfp4_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd65:	begin tx_data <= 8'h05; tx_data_en <= 1'b1; end
//    			8'd66:	begin tx_data <= sfp5_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd67:	begin tx_data <= sfp5_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd68:	begin tx_data <= sfp5_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd69:	begin tx_data <= sfp5_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd70:	begin tx_data <= sfp5_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd71:	begin tx_data <= sfp5_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd72:	begin tx_data <= sfp5_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd73:	begin tx_data <= sfp5_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd74:	begin tx_data <= sfp5_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd75:	begin tx_data <= sfp5_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd76:	begin tx_data <= 8'h06; tx_data_en <= 1'b1; end
//    			8'd77:	begin tx_data <= sfp6_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd78:	begin tx_data <= sfp6_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd79:	begin tx_data <= sfp6_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd80:	begin tx_data <= sfp6_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd81:	begin tx_data <= sfp6_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd82:	begin tx_data <= sfp6_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd83:	begin tx_data <= sfp6_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd84:	begin tx_data <= sfp6_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd85:	begin tx_data <= sfp6_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd86:	begin tx_data <= sfp6_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd87:	begin tx_data <= 8'h07; tx_data_en <= 1'b1; end
//    			8'd88:	begin tx_data <= sfp7_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd89:	begin tx_data <= sfp7_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd90:	begin tx_data <= sfp7_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd91:	begin tx_data <= sfp7_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd92:	begin tx_data <= sfp7_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd93:	begin tx_data <= sfp7_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd94:	begin tx_data <= sfp7_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd95:	begin tx_data <= sfp7_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd96:	begin tx_data <= sfp7_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd97:	begin tx_data <= sfp7_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd98:	begin tx_data <= 8'h08; tx_data_en <= 1'b1; end
//    			8'd99:	begin tx_data <= sfp8_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd100:	begin tx_data <= sfp8_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd101:	begin tx_data <= sfp8_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd102:	begin tx_data <= sfp8_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd103:	begin tx_data <= sfp8_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd104:	begin tx_data <= sfp8_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd105:	begin tx_data <= sfp8_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd106:	begin tx_data <= sfp8_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd107:	begin tx_data <= sfp8_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd108:	begin tx_data <= sfp8_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd109:	begin tx_data <= 8'h09; tx_data_en <= 1'b1; end
//    			8'd110:	begin tx_data <= sfp9_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd111:	begin tx_data <= sfp9_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd112:	begin tx_data <= sfp9_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd113:	begin tx_data <= sfp9_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd114:	begin tx_data <= sfp9_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd115:	begin tx_data <= sfp9_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd116:	begin tx_data <= sfp9_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd117:	begin tx_data <= sfp9_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd118:	begin tx_data <= sfp9_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd119:	begin tx_data <= sfp9_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd120:	begin tx_data <= 8'h0a; tx_data_en <= 1'b1; end
//    			8'd121:	begin tx_data <= sfp10_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd122:	begin tx_data <= sfp10_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd123:	begin tx_data <= sfp10_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd124:	begin tx_data <= sfp10_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd125:	begin tx_data <= sfp10_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd126:	begin tx_data <= sfp10_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd127:	begin tx_data <= sfp10_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd128:	begin tx_data <= sfp10_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd129:	begin tx_data <= sfp10_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd130:	begin tx_data <= sfp10_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd131:	begin tx_data <= 8'h0b; tx_data_en <= 1'b1; end
//    			8'd132:	begin tx_data <= sfp11_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd133:	begin tx_data <= sfp11_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd134:	begin tx_data <= sfp11_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd135:	begin tx_data <= sfp11_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd136:	begin tx_data <= sfp11_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd137:	begin tx_data <= sfp11_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd138:	begin tx_data <= sfp11_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd139:	begin tx_data <= sfp11_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd140:	begin tx_data <= sfp11_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd141:	begin tx_data <= sfp11_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd142:	begin tx_data <= 8'h0c; tx_data_en <= 1'b1; end
//    			8'd143:	begin tx_data <= sfp12_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd144:	begin tx_data <= sfp12_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd145:	begin tx_data <= sfp12_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd146:	begin tx_data <= sfp12_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd147:	begin tx_data <= sfp12_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd148:	begin tx_data <= sfp12_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd149:	begin tx_data <= sfp12_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd150:	begin tx_data <= sfp12_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd151:	begin tx_data <= sfp12_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd152:	begin tx_data <= sfp12_ip[7:0]; tx_data_en <= 1'b1; end
//
//    			8'd153:	begin tx_data <= 8'h0d; tx_data_en <= 1'b1; end
//    			8'd154:	begin tx_data <= sfp13_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd155:	begin tx_data <= sfp13_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd156:	begin tx_data <= sfp13_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd157:	begin tx_data <= sfp13_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd158:	begin tx_data <= sfp13_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd159:	begin tx_data <= sfp13_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd160:	begin tx_data <= sfp13_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd161:	begin tx_data <= sfp13_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd162:	begin tx_data <= sfp13_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd163:	begin tx_data <= sfp13_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd164:	begin tx_data <= 8'h0e; tx_data_en <= 1'b1; end
//    			8'd165:	begin tx_data <= sfp14_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd166:	begin tx_data <= sfp14_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd167:	begin tx_data <= sfp14_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd168:	begin tx_data <= sfp14_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd169:	begin tx_data <= sfp14_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd170:	begin tx_data <= sfp14_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd171:	begin tx_data <= sfp14_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd172:	begin tx_data <= sfp14_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd173:	begin tx_data <= sfp14_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd174:	begin tx_data <= sfp14_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd175:	begin tx_data <= 8'h0f; tx_data_en <= 1'b1; end
//    			8'd176:	begin tx_data <= sfp15_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd177:	begin tx_data <= sfp15_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd178:	begin tx_data <= sfp15_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd179:	begin tx_data <= sfp15_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd180:	begin tx_data <= sfp15_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd181:	begin tx_data <= sfp15_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd182:	begin tx_data <= sfp15_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd183:	begin tx_data <= sfp15_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd184:	begin tx_data <= sfp15_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd185:	begin tx_data <= sfp15_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd186:	begin tx_data <= 8'h10; tx_data_en <= 1'b1; end
//    			8'd187:	begin tx_data <= sfp16_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd188:	begin tx_data <= sfp16_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd189:	begin tx_data <= sfp16_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd190:	begin tx_data <= sfp16_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd191:	begin tx_data <= sfp16_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd192:	begin tx_data <= sfp16_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd193:	begin tx_data <= sfp16_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd194:	begin tx_data <= sfp16_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd195:	begin tx_data <= sfp16_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd196:	begin tx_data <= sfp16_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd197:	begin tx_data <= 8'h11; tx_data_en <= 1'b1; end
//    			8'd198:	begin tx_data <= sfp17_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd199:	begin tx_data <= sfp17_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd200:	begin tx_data <= sfp17_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd201:	begin tx_data <= sfp17_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd202:	begin tx_data <= sfp17_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd203:	begin tx_data <= sfp17_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd204:	begin tx_data <= sfp17_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd205:	begin tx_data <= sfp17_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd206:	begin tx_data <= sfp17_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd207:	begin tx_data <= sfp17_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd208:	begin tx_data <= 8'h12; tx_data_en <= 1'b1; end
//    			8'd209:	begin tx_data <= sfp18_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd210:	begin tx_data <= sfp18_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd211:	begin tx_data <= sfp18_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd212:	begin tx_data <= sfp18_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd213:	begin tx_data <= sfp18_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd214:	begin tx_data <= sfp18_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd215:	begin tx_data <= sfp18_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd216:	begin tx_data <= sfp18_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd217:	begin tx_data <= sfp18_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd218:	begin tx_data <= sfp18_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd219:	begin tx_data <= 8'h13; tx_data_en <= 1'b1; end
//    			8'd220:	begin tx_data <= sfp19_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd221:	begin tx_data <= sfp19_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd222:	begin tx_data <= sfp19_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd223:	begin tx_data <= sfp19_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd224:	begin tx_data <= sfp19_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd225:	begin tx_data <= sfp19_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd226:	begin tx_data <= sfp19_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd227:	begin tx_data <= sfp19_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd228:	begin tx_data <= sfp19_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd229:	begin tx_data <= sfp19_ip[7:0]; tx_data_en <= 1'b1; end
//    			8'd230:	begin tx_data <= 8'h14; tx_data_en <= 1'b1; end
//    			8'd231:	begin tx_data <= sfp20_mac[47:40]; tx_data_en <= 1'b1; end
//    			8'd232:	begin tx_data <= sfp20_mac[39:32]; tx_data_en <= 1'b1; end
//    			8'd233:	begin tx_data <= sfp20_mac[31:24]; tx_data_en <= 1'b1; end
//    			8'd234:	begin tx_data <= sfp20_mac[23:16]; tx_data_en <= 1'b1; end
//    			8'd235:	begin tx_data <= sfp20_mac[15:8]; tx_data_en <= 1'b1; end
//    			8'd236:	begin tx_data <= sfp20_mac[7:0]; tx_data_en <= 1'b1; end
//    			8'd237:	begin tx_data <= sfp20_ip[31:24]; tx_data_en <= 1'b1; end
//    			8'd238:	begin tx_data <= sfp20_ip[23:16]; tx_data_en <= 1'b1; end
//    			8'd239:	begin tx_data <= sfp20_ip[15:8]; tx_data_en <= 1'b1; end
//    			8'd240:	begin tx_data <= sfp20_ip[7:0]; tx_data_en <= 1'b1; end
    			
    			default:
    			begin
    				tx_data		<= 8'h00;
    				tx_data_en	<= 1'b0;
    			end
    		endcase
    	end
    	else
    	begin
    		tx_data		<= 8'h00;
    		tx_data_en	<= 1'b0;
    	end
    end
    
    // receive mac & ip
    always @(posedge clk)
    begin
    	if ((write_sel == 4'd8)||(write_sel == 4'd9))
    	begin
    		case (head_cnt)
    			12'd8,
    			12'd19,//2
    			12'd30,
    			12'd41,//4
    			12'd52,
    			12'd63,//6
    			12'd74,
    			12'd85,//8
    			12'd96,
    			12'd107,//10
    			12'd118,
    			12'd129,//12
    			12'd140,
    			12'd151,//14
    			12'd162,
    			12'd173,//16
    			12'd184,
    			12'd195,//18
    			12'd206,
    			12'd217://20
    				begin local_rocket <= rx_data; end
    			12'd9,
    			12'd20, //2
    			12'd31, 
    			12'd42, //4
    			12'd53,    
    			12'd64, //6
    			12'd75,    
    			12'd86, //8
    			12'd97,
    			12'd108,//10
    			12'd119,    
    			12'd130,//12
    			12'd141,
    			12'd152,//14
    			12'd163,
    			12'd174,//16
    			12'd185,
    			12'd196,//18
    			12'd207,
    			12'd218://20
    				begin local_mac[47:40] <= rx_data; end
    			12'd10,
    			12'd21, //2 
    			12'd32,     
    			12'd43, //4 
    			12'd54,     
    			12'd65, //6 
    			12'd76,     
    			12'd87, //8 
    			12'd98,     
    			12'd109,//10
    			12'd120,    
    			12'd131,//12
    			12'd142,
    			12'd153,//14
    			12'd164,
    			12'd175,//16
    			12'd186,
    			12'd197,//18
    			12'd208,
    			12'd219://20
    				begin local_mac[39:32] <= rx_data; end
    			12'd11,
    			12'd22, //2 
    			12'd33,     
    			12'd44, //4 
    			12'd55,     
    			12'd66, //6 
    			12'd77,     
    			12'd88, //8 
    			12'd99,     
    			12'd110,//10
    			12'd121,    
    			12'd132,//12
    			12'd143,
    			12'd154,//14
    			12'd165,
    			12'd176,//16
    			12'd187,
    			12'd198,//18
    			12'd209,
    			12'd220://20
    				begin local_mac[31:24] <= rx_data; end
    			12'd12,
    			12'd23, //2 
    			12'd34,     
    			12'd45, //4 
    			12'd56,     
    			12'd67, //6 
    			12'd78,     
    			12'd89, //8 
    			12'd100,    
    			12'd111,//10
    			12'd122,    
    			12'd133,//12
    			12'd144,
    			12'd155,//14
    			12'd166,
    			12'd177,//16
    			12'd188,
    			12'd199,//18
    			12'd210,
    			12'd221://20
    				begin local_mac[23:16] <= rx_data; end
    			12'd13,
    			12'd24, //2 
    			12'd35,     
    			12'd46, //4 
    			12'd57,     
    			12'd68, //6 
    			12'd79,     
    			12'd90, //8 
    			12'd101,    
    			12'd112,//10
    			12'd123,    
    			12'd134,//12
    			12'd145,
    			12'd156,//14
    			12'd167,
    			12'd178,//16
    			12'd189,
    			12'd200,//18
    			12'd211,
    			12'd222://20
    				begin local_mac[15:8] <= rx_data; end
    			12'd14,
    			12'd25, //2 
    			12'd36,     
    			12'd47, //4 
    			12'd58,     
    			12'd69, //6 
    			12'd80,     
    			12'd91, //8 
    			12'd102,    
    			12'd113,//10
    			12'd124,    
    			12'd135,//12
    			12'd146,
    			12'd157,//14
    			12'd168,
    			12'd179,//16
    			12'd190,
    			12'd201,//18
    			12'd212,
    			12'd223://20
    				begin local_mac[7:0] <= rx_data; end
    			12'd15,
    			12'd26, //2 
    			12'd37,     
    			12'd48, //4 
    			12'd59,     
    			12'd70, //6 
    			12'd81,     
    			12'd92, //8 
    			12'd103,    
    			12'd114,//10
    			12'd125,    
    			12'd136,//12
    			12'd147,
    			12'd158,//14
    			12'd169,
    			12'd180,//16
    			12'd191,
    			12'd202,//18
    			12'd213,
    			12'd224://20
    				begin local_ip[31:24] <= rx_data; end
    			12'd16,
    			12'd27, //2 
    			12'd38,     
    			12'd49, //4 
    			12'd60,     
    			12'd71, //6 
    			12'd82,     
    			12'd93, //8 
    			12'd104,    
    			12'd115,//10
    			12'd126,    
    			12'd137,//12
    			12'd148,
    			12'd159,//14
    			12'd170,
    			12'd181,//16
    			12'd192,
    			12'd203,//18
    			12'd214,
    			12'd225://20
    				begin local_ip[23:16] <= rx_data; end
    			12'd17,
    			12'd28, //2 
    			12'd39,     
    			12'd50, //4 
    			12'd61,     
    			12'd72, //6 
    			12'd83,     
    			12'd94, //8 
    			12'd105,    
    			12'd116,//10
    			12'd127,    
    			12'd138,//12
    			12'd149,
    			12'd160,//14
    			12'd171,
    			12'd182,//16
    			12'd193,
    			12'd204,//18
    			12'd215,
    			12'd226://20
    				begin local_ip[15:8] <= rx_data; end
    			12'd18,
    			12'd29, //2 
    			12'd40,     
    			12'd51, //4 
    			12'd62,     
    			12'd73, //6 
    			12'd84,     
    			12'd95, //8 
    			12'd106,    
    			12'd117,//10
    			12'd128,    
    			12'd139,//12
    			12'd150,
    			12'd161,//14
    			12'd172,
    			12'd183,//16
    			12'd194,
    			12'd205,//18
    			12'd216,
    			12'd227://20
    				begin local_ip[7:0] <= rx_data; end
    			
    			default:
    			begin
    				local_rocket <= local_rocket;
    				local_mac <= local_mac;
    				local_ip <= local_ip;
    			end
    		endcase
    	end
    	else
    	begin
    		local_rocket	<= 8'd0;
    		local_mac		<= 48'd0;
    		local_ip		<= 32'd0;
    	end
    end
    
    always @(posedge clk)
    begin
    	if (rst)
    	begin
    		sfp1_mac	<= {16'h00_12, sfp1_ip};
    		sfp1_ip		<= 32'hC0_12_08_20;
    		sfp2_mac	<= {16'h00_12, sfp2_ip};
    		sfp2_ip		<= 32'hC0_12_08_21;
    		sfp3_mac	<= {16'h00_12, sfp3_ip};
    		sfp3_ip		<= 32'hC0_12_08_22;
    		sfp4_mac	<= {16'h00_12, sfp4_ip};
    		sfp4_ip		<= 32'hC0_12_08_23;
//    		sfp5_mac	<= {16'h00_12, sfp5_ip};
//    		sfp5_ip		<= 32'hC0_12_08_84;
//    		sfp6_mac	<= {16'h00_12, sfp6_ip};
//    		sfp6_ip		<= 32'hC0_12_08_85;
//    		sfp7_mac	<= {16'h00_12, sfp7_ip};
//    		sfp7_ip		<= 32'hC0_12_08_86;
//    		sfp8_mac	<= {16'h00_12, sfp8_ip};
//    		sfp8_ip		<= 32'hC0_12_08_87;
//    		sfp9_mac	<= {16'h00_12, sfp9_ip};
//    		sfp9_ip		<= 32'hC0_12_08_88;
//    		sfp10_mac	<= {16'h00_12, sfp10_ip};
//    		sfp10_ip	<= 32'hC0_12_08_89;
//    		sfp11_mac	<= {16'h00_12, sfp11_ip};
//    		sfp11_ip	<= 32'hC0_12_08_8a;
//    		sfp12_mac	<= {16'h00_12, sfp12_ip};
//    		sfp12_ip	<= 32'hC0_12_08_8b;
//    		sfp13_mac	<= {16'h00_12, sfp13_ip};
//    		sfp13_ip	<= 32'hC0_12_08_8c;
//    		sfp14_mac	<= {16'h00_12, sfp14_ip};
//    		sfp14_ip	<= 32'hC0_12_08_8d;
//    		sfp15_mac	<= {16'h00_12, sfp15_ip};
//    		sfp15_ip	<= 32'hC0_12_08_8e;
//    		sfp16_mac	<= {16'h00_12, sfp16_ip};
//    		sfp16_ip	<= 32'hC0_12_08_8f;
//    		sfp17_mac	<= {16'h00_12, sfp17_ip};
//    		sfp17_ip	<= 32'hC0_12_08_90;
//    		sfp18_mac	<= {16'h00_12, sfp18_ip};
//    		sfp18_ip	<= 32'hC0_12_08_91;
//    		sfp19_mac	<= {16'h00_12, sfp19_ip};
//    		sfp19_ip	<= 32'hC0_12_08_92;
//    		sfp20_mac	<= {16'h00_12, sfp20_ip};
//    		sfp20_ip	<= 32'hC0_12_08_93;
    	end
    	else if (write_sel == 4'd9)
    	begin
    		case (head_cnt)
    			12'd19:
    			begin
    				sfp1_mac	<= local_mac;
    				sfp1_ip		<= local_ip;
    			end
    			12'd30:
    			begin
    				sfp2_mac	<= local_mac;
    				sfp2_ip		<= local_ip;
    			end    
    			12'd41:
    			begin
    				sfp3_mac	<= local_mac;
    				sfp3_ip		<= local_ip;
    			end    
    			12'd52:
    			begin
    				sfp4_mac	<= local_mac;
    				sfp4_ip		<= local_ip;
    			end    
//    			12'd63:
//    			begin
//    				sfp5_mac	<= local_mac;
//    				sfp5_ip		<= local_ip;
//    			end    
//    			12'd74:
//    			begin
//    				sfp6_mac	<= local_mac;
//    				sfp6_ip		<= local_ip;
//    			end    
//    			12'd85:
//    			begin
//    				sfp7_mac	<= local_mac;
//    				sfp7_ip		<= local_ip;
//    			end    
//    			12'd96:
//    			begin
//    				sfp8_mac	<= local_mac;
//    				sfp8_ip		<= local_ip;
//    			end    
//    			12'd107:
//    			begin
//    				sfp9_mac	<= local_mac;
//    				sfp9_ip		<= local_ip;
//    			end    
//    			12'd118:
//    			begin
//    				sfp10_mac	<= local_mac;
//    				sfp10_ip	<= local_ip;
//    			end    
//    			12'd129:
//    			begin
//    				sfp11_mac	<= local_mac;
//    				sfp11_ip	<= local_ip;
//    			end    
//    			12'd140:
//    			begin
//    				sfp12_mac	<= local_mac;
//    				sfp12_ip	<= local_ip;
//    			end    
//    			12'd151:
//    			begin
//    				sfp13_mac	<= local_mac;
//    				sfp13_ip	<= local_ip; 
//    			end                          
//    			12'd162:                      
//    			begin                        
//    				sfp14_mac	<= local_mac;
//    				sfp14_ip	<= local_ip; 
//    			end    
//    			12'd173:
//    			begin
//    				sfp15_mac	<= local_mac;
//    				sfp15_ip	<= local_ip;
//    			end    
//    			12'd184:
//    			begin
//    				sfp16_mac	<= local_mac;
//    				sfp16_ip	<= local_ip;
//    			end    
//    			12'd195:
//    			begin
//    				sfp17_mac	<= local_mac;
//    				sfp17_ip	<= local_ip;
//    			end    
//    			12'd206:
//    			begin
//    				sfp18_mac	<= local_mac;
//    				sfp18_ip	<= local_ip; 
//    			end                          
//    			12'd217:                      
//    			begin                        
//    				sfp19_mac	<= local_mac;
//    				sfp19_ip	<= local_ip; 
//    			end    
//    			12'd228:
//    			begin
//    				sfp20_mac	<= local_mac;
//    				sfp20_ip	<= local_ip;
//    			end    
    		endcase
    	end
    	else
    	begin
    		sfp1_mac	<= sfp1_mac;
    		sfp1_ip		<= sfp1_ip;
    		sfp2_mac	<= sfp2_mac;
    		sfp2_ip		<= sfp2_ip;
    		sfp3_mac	<= sfp3_mac;
    		sfp3_ip		<= sfp3_ip;
    		sfp4_mac	<= sfp4_mac;
    		sfp4_ip		<= sfp4_ip;
//    		sfp5_mac	<= sfp5_mac;
//    		sfp5_ip		<= sfp5_ip;
//    		sfp6_mac	<= sfp6_mac;
//    		sfp6_ip		<= sfp6_ip;
//    		sfp7_mac	<= sfp7_mac;
//    		sfp7_ip		<= sfp7_ip;
//    		sfp8_mac	<= sfp8_mac;
//    		sfp8_ip		<= sfp8_ip;
//    		sfp9_mac	<= sfp9_mac;
//    		sfp9_ip		<= sfp9_ip;
//    		sfp10_mac	<= sfp10_mac;
//    		sfp10_ip	<= sfp10_ip;
//    		sfp11_mac	<= sfp11_mac;
//    		sfp11_ip	<= sfp11_ip;
//    		sfp12_mac	<= sfp12_mac;
//    		sfp12_ip	<= sfp12_ip;
//    		sfp13_mac	<= sfp13_mac;
//    		sfp13_ip	<= sfp13_ip;
//    		sfp14_mac	<= sfp14_mac;
//    		sfp14_ip	<= sfp14_ip;
//    		sfp15_mac	<= sfp15_mac;
//    		sfp15_ip	<= sfp15_ip;
//    		sfp16_mac	<= sfp16_mac;
//    		sfp16_ip	<= sfp16_ip;
//    		sfp17_mac	<= sfp17_mac;
//    		sfp17_ip	<= sfp17_ip;
//    		sfp18_mac	<= sfp18_mac;
//    		sfp18_ip	<= sfp18_ip;
//    		sfp19_mac	<= sfp19_mac;
//    		sfp19_ip	<= sfp19_ip;
//    		sfp20_mac	<= sfp20_mac;
//    		sfp20_ip	<= sfp20_ip;
    	end
    end

endmodule
