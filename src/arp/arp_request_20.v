`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:42:59 03/22/2011 
// Design Name: 
// Module Name:    arp_request 
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
module arp_request_20(
	
	tx_data,
	tx_data1_en,
	tx_data2_en,
	tx_data3_en,
	tx_data4_en,
	tx_data5_en,
	tx_data6_en,
	tx_data7_en,
	tx_data8_en,
	tx_data9_en,
	tx_data10_en,
	tx_data11_en,
	tx_data12_en,
	tx_data13_en,
	tx_data14_en,
	tx_data15_en,
	tx_data16_en,
	tx_data17_en,
	tx_data18_en,
	tx_data19_en,
	tx_data20_en,
	
	req1_ready,
	req2_ready,
	req3_ready,
	req4_ready,
	req5_ready,
	req6_ready,
	req7_ready,
	req8_ready,
	req9_ready,
	req10_ready,
	req11_ready,
	req12_ready,
	req13_ready,
	req14_ready,
	req15_ready,
	req16_ready,
	req17_ready,
	req18_ready,
	req19_ready,
	req20_ready,
	
	req1_ack,
	req2_ack,
	req3_ack,
	req4_ack,
	req5_ack,
	req6_ack,
	req7_ack,
	req8_ack,
	req9_ack,
	req10_ack,
	req11_ack,
	req12_ack,
	req13_ack,
	req14_ack,
	req15_ack,
	req16_ack,
	req17_ack,
	req18_ack,
	req19_ack,
	req20_ack,
	
	local1_ip,
	local1_mac,
	
	local2_ip,
	local2_mac,
	
	local3_ip,
	local3_mac,
	
	local4_ip,
	local4_mac,
	
	local5_ip,
	local5_mac,
	
	local6_ip,
	local6_mac,
	
	local7_ip,
	local7_mac,
	
	local8_ip,
	local8_mac,
	
	local9_ip,
	local9_mac,
	
	local10_ip,
	local10_mac,
	
	local11_ip,
	local11_mac,
	
	local12_ip,
	local12_mac,
	
	local13_ip, 
	local13_mac,
	            
	local14_ip, 
	local14_mac,
	            
	local15_ip, 
	local15_mac,
	            
	local16_ip, 
	local16_mac,
	            
	local17_ip, 
	local17_mac,
	            
	local18_ip, 
	local18_mac,
	            
	local19_ip, 
	local19_mac,
	            
	local20_ip, 
	local20_mac,
	
	rx_lut_netport,
	rx_lut_ip,
	rx_lut_ip_en,
	
	rx_fade_netport,
	rx_fade_ip,
	rx_fade_ip_en,
	
//	state,
	
	rst,
	clk
	
    );
    
    output	reg	[7:0]	tx_data;
	output	reg			tx_data1_en;
	output	reg			tx_data2_en;
	output	reg			tx_data3_en;
	output	reg			tx_data4_en;
	output	reg			tx_data5_en;
	output	reg			tx_data6_en;
	output	reg			tx_data7_en;
	output	reg			tx_data8_en;
	output	reg			tx_data9_en;
	output	reg			tx_data10_en;
	output	reg			tx_data11_en;
	output	reg			tx_data12_en;
	output	reg			tx_data13_en;
	output	reg			tx_data14_en;
	output	reg			tx_data15_en;
	output	reg			tx_data16_en;
	output	reg			tx_data17_en;
	output	reg			tx_data18_en;
	output	reg			tx_data19_en;
	output	reg			tx_data20_en;
    
    output				req1_ready;
	output				req2_ready;
	output				req3_ready;
	output				req4_ready;
	output				req5_ready;
	output				req6_ready;
	output				req7_ready;
	output				req8_ready;
	output				req9_ready;
	output				req10_ready;
	output				req11_ready;
	output				req12_ready;
	output				req13_ready;
	output				req14_ready;
	output				req15_ready;
	output				req16_ready;
	output				req17_ready;
	output				req18_ready;
	output				req19_ready;
	output				req20_ready;
    
    input				req1_ack;
	input				req2_ack;
	input				req3_ack;
	input				req4_ack;
	input				req5_ack;
	input				req6_ack;
	input				req7_ack;
	input				req8_ack;
	input				req9_ack;
	input				req10_ack;
	input				req11_ack;
	input				req12_ack;
	input				req13_ack;
	input				req14_ack;
	input				req15_ack;
	input				req16_ack;
	input				req17_ack;
	input				req18_ack;
	input				req19_ack;
	input				req20_ack;
  
    input		[31:0]	local1_ip;
    input		[47:0]	local1_mac;
            	
    input		[31:0]	local2_ip;
    input		[47:0]	local2_mac;
            	
    input		[31:0]	local3_ip;
    input		[47:0]	local3_mac;
            	
    input		[31:0]	local4_ip;
    input		[47:0]	local4_mac;
            	
    input		[31:0]	local5_ip;
    input		[47:0]	local5_mac;
            	
    input		[31:0]	local6_ip;
    input		[47:0]	local6_mac;
            	
    input		[31:0]	local7_ip;
    input		[47:0]	local7_mac;
            	
    input		[31:0]	local8_ip;
    input		[47:0]	local8_mac;
    
    input		[31:0]	local9_ip;
    input		[47:0]	local9_mac;
            	
    input		[31:0]	local10_ip;
    input		[47:0]	local10_mac;
            	
    input		[31:0]	local11_ip;
    input		[47:0]	local11_mac;
            	
    input		[31:0]	local12_ip;
    input		[47:0]	local12_mac;
    
    input		[31:0]	local13_ip;
    input		[47:0]	local13_mac;
            	
    input		[31:0]	local14_ip;
    input		[47:0]	local14_mac;
            	
    input		[31:0]	local15_ip;
    input		[47:0]	local15_mac;
            	
    input		[31:0]	local16_ip;
    input		[47:0]	local16_mac;
    
    input		[31:0]	local17_ip;
    input		[47:0]	local17_mac;
            	
    input		[31:0]	local18_ip;
    input		[47:0]	local18_mac;
            	
    input		[31:0]	local19_ip;
    input		[47:0]	local19_mac;
            	
    input		[31:0]	local20_ip;
    input		[47:0]	local20_mac;
            	
    input		[23:0]	rx_fade_netport;	
    input		[31:0]	rx_fade_ip;
    input				rx_fade_ip_en;
            	
    input		[23:0]	rx_lut_netport;	
    input		[31:0]	rx_lut_ip;
    input				rx_lut_ip_en;
            	
    input				rst;
    input				clk;
            	
//    output		[1:0]	state;
            	
    reg			[31:0]	local_ip;
    reg			[47:0]	local_mac;
            	
    reg			[31:0]	read_ip;
    reg			[23:0]	read_netport;
            	
    reg			[6:0]	cnt;
    reg			[1:0]	state;
    
    parameter	DATA_LEN = 7'd63;
    
    parameter	IDLE_S = 2'b00,
    			HOLD_S = 2'b01,
    			SEND_S = 2'b10;
    
	assign	req1_ready = ((state == HOLD_S) && (read_netport == 24'h000001));
	assign	req2_ready = ((state == HOLD_S) && (read_netport == 24'h000002));
	assign	req3_ready = ((state == HOLD_S) && (read_netport == 24'h000004));
	assign	req4_ready = ((state == HOLD_S) && (read_netport == 24'h000008));
	assign	req5_ready = ((state == HOLD_S) && (read_netport == 24'h000010));
	assign	req6_ready = ((state == HOLD_S) && (read_netport == 24'h000020));
	assign	req7_ready = ((state == HOLD_S) && (read_netport == 24'h000040));
	assign	req8_ready = ((state == HOLD_S) && (read_netport == 24'h000080));
	assign	req9_ready = ((state == HOLD_S) && (read_netport == 24'h000100));
	assign	req10_ready = ((state == HOLD_S) && (read_netport == 24'h000200));
	assign	req11_ready = ((state == HOLD_S) && (read_netport == 24'h000400));
	assign	req12_ready = ((state == HOLD_S) && (read_netport == 24'h000800));
	assign	req13_ready = ((state == HOLD_S) && (read_netport == 24'h001000));
	assign	req14_ready = ((state == HOLD_S) && (read_netport == 24'h002000));
	assign	req15_ready = ((state == HOLD_S) && (read_netport == 24'h004000));
	assign	req16_ready = ((state == HOLD_S) && (read_netport == 24'h008000));
	assign	req17_ready = ((state == HOLD_S) && (read_netport == 24'h010000));
	assign	req18_ready = ((state == HOLD_S) && (read_netport == 24'h020000));
	assign	req19_ready = ((state == HOLD_S) && (read_netport == 24'h040000));
	assign	req20_ready = ((state == HOLD_S) && (read_netport == 24'h080000));
    
    // state machine -----------------------------
    always @(posedge clk)
    begin
    	if (rst == 1'b1)
    		state	<= IDLE_S;
    	else
    		case (state)
    		
    			IDLE_S:		if (rx_fade_ip_en || rx_lut_ip_en)
    							state	<= HOLD_S;
    						else
    							state	<= IDLE_S;
    							
    			HOLD_S:		case(read_netport)
    							24'h000001:		if(req1_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h000002:		if(req2_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h000004:		if(req3_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h000008:		if(req4_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h000010:		if(req5_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h000020:		if(req6_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h000040:		if(req7_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h000080:		if(req8_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h000100:		if(req9_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h000200:		if(req10_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h000400:		if(req11_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h000800:		if(req12_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h001000:		if(req13_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h002000:		if(req14_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h004000:		if(req15_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h008000:		if(req16_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h010000:		if(req17_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h020000:		if(req18_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h040000:		if(req19_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							24'h080000:		if(req20_ack == 1'b1)
    												state	<= SEND_S;
    											else
    												state	<= HOLD_S;
    							default:		state	<= IDLE_S;
    						endcase
    						
    			SEND_S:		if (cnt == DATA_LEN)
    							state	<= IDLE_S;
    						else
    							state	<= SEND_S;
    			
    			default:	state	<= IDLE_S;
    			
    		endcase
    end

    // counter -----------------------------
    always @(posedge clk)
    begin
    	if (state == SEND_S)
    		cnt	<= cnt + 1'b1;
    	else
    		cnt	<= 0;
    end

    // record -----------------------------
    always @(posedge clk)
   	begin
   		case(state)
   			IDLE_S:		case({rx_fade_ip_en,rx_lut_ip_en})
   							2'b00:		begin	read_ip <= 32'b0;		read_netport <= 0;					end
   							2'b01:		begin	read_ip <= rx_lut_ip;	read_netport <= rx_lut_netport;		end
   							2'b10:		begin	read_ip <= rx_fade_ip;	read_netport <= rx_fade_netport;	end
   							2'b11:		begin	read_ip <= rx_lut_ip;	read_netport <= rx_lut_netport;		end
   						endcase
   			default:	begin	read_ip <= read_ip;	read_netport <= read_netport;	end
   		endcase
   	end
   	
   	always@(posedge clk)
   	begin
   		if(state == SEND_S)
   			case(cnt)
   				7'd0:		case(read_netport)
    							24'h000001: 	begin	
    												local_ip <= local1_ip;
    												local_mac <= local1_mac;
    											end
    							24'h000002: 	begin
    												local_ip <= local2_ip;
    												local_mac <= local2_mac;
    											end
    							24'h000004: 	begin
    												local_ip <= local3_ip;
    												local_mac <= local3_mac;
    											end
    							24'h000008: 	begin
    												local_ip <= local4_ip;
    												local_mac <= local4_mac;
    											end
    							24'h000010: 	begin
    												local_ip <= local5_ip;
    												local_mac <= local5_mac;
    											end
    							24'h000020: 	begin
    												local_ip <= local6_ip;
    												local_mac <= local6_mac;
    											end
    							24'h000040: 	begin
    												local_ip <= local7_ip;
    												local_mac <= local7_mac;
    											end
    							24'h000080: 	begin
    												local_ip <= local8_ip;
    												local_mac <= local8_mac;
    											end
    							24'h000100: 	begin
    												local_ip <= local9_ip;
    												local_mac <= local9_mac;
    											end
    							24'h000200: 	begin
    												local_ip <= local10_ip;
    												local_mac <= local10_mac;
    											end
    							24'h000400: 	begin
    												local_ip <= local11_ip;
    												local_mac <= local11_mac;
    											end
    							24'h000800: 	begin
    												local_ip <= local12_ip;
    												local_mac <= local12_mac;
    											end
    							24'h001000: 	begin
    												local_ip <= local13_ip;
    												local_mac <= local13_mac;
    											end
    							24'h002000: 	begin
    												local_ip <= local14_ip;
    												local_mac <= local14_mac;
    											end
    							24'h004000: 	begin
    												local_ip <= local15_ip;
    												local_mac <= local15_mac;
    											end
    							24'h008000: 	begin
    												local_ip <= local16_ip;
    												local_mac <= local16_mac;
    											end
    							24'h010000: 	begin
    												local_ip <= local17_ip;
    												local_mac <= local17_mac;
    											end
    							24'h020000: 	begin
    												local_ip <= local18_ip;
    												local_mac <= local18_mac;
    											end
    							24'h040000: 	begin
    												local_ip <= local19_ip;
    												local_mac <= local19_mac;
    											end
    							24'h080000: 	begin
    												local_ip <= local20_ip;
    												local_mac <= local20_mac;
    											end
    							default:	begin
    											local_ip <= 0;
    											local_mac <= 0;
    										end
    						endcase	
    			default:	begin
    							local_ip <= local_ip;
    							local_mac <= local_mac;
    						end
    		endcase
    	else
    		begin
    			local_ip <= 0;
    			local_mac <= 0;
    		end
   	end

    // output -----------------------------
    always @(posedge clk)
    begin
    	case(state)
    		SEND_S:		case (cnt)
    						7'd0:		tx_data <= 8'hff;
    						7'd1:		tx_data <= 8'hff;
    						7'd2:		tx_data <= 8'hff;
    						7'd3:		tx_data <= 8'hff;
    						7'd4:		tx_data <= 8'hff;
    						7'd5:		tx_data <= 8'hff;
	    					7'd6:		tx_data <= local_mac[47:40];
	    					7'd7:		tx_data <= local_mac[39:32];
	    					7'd8:		tx_data <= local_mac[31:24];
	    					7'd9:		tx_data <= local_mac[23:16];
	    					7'd10:		tx_data <= local_mac[15:8];
	    					7'd11:		tx_data <= local_mac[7:0];
	    					7'd12:		tx_data <= 8'h08;
	    					7'd13:		tx_data <= 8'h06;
	    					7'd14:		tx_data <= 8'h00;
	    					7'd15:		tx_data <= 8'h01;
	    					7'd16:		tx_data <= 8'h08;
	    					7'd17:		tx_data <= 8'h00;
	    					7'd18:		tx_data <= 8'h06;
	    					7'd19:		tx_data <= 8'h04;
	    					7'd20:		tx_data <= 8'h00;
	    					7'd21:		tx_data <= 8'h01;
	    					7'd22:		tx_data <= local_mac[47:40];                                                               
	    					7'd23:      tx_data <= local_mac[39:32];                                                               
	    					7'd24:      tx_data <= local_mac[31:24];                                                               
	    					7'd25:      tx_data <= local_mac[23:16];                                                              
	    					7'd26:      tx_data <= local_mac[15:8];                                                               
	    					7'd27:      tx_data <= local_mac[7:0];                                                              
	    					7'd28:		tx_data <= local_ip[31:24];
	    					7'd29:		tx_data <= local_ip[23:16];
	    					7'd30:		tx_data <= local_ip[15:8];
	    					7'd31:		tx_data <= local_ip[7:0];
	    					7'd38:		tx_data <= read_ip[31:24];
	    					7'd39:		tx_data <= read_ip[23:16];
	    					7'd40:		tx_data <= read_ip[15:8]; 
	    					7'd41:		tx_data <= read_ip[7:0];
    						default:	tx_data	<= 8'h00;
    					endcase
    		default:	tx_data	<= 8'h00;
    	endcase
    end
    
    always@(posedge clk)
    begin
    	case(state)
    		SEND_S:		case(read_netport)
    						24'h000001:		begin	tx_data1_en <= 1'b1;	end
    						24'h000002:		begin	tx_data2_en <= 1'b1;	end
    						24'h000004:		begin	tx_data3_en <= 1'b1;	end
    						24'h000008:		begin	tx_data4_en <= 1'b1;	end
    						24'h000010:		begin	tx_data5_en <= 1'b1;	end
    						24'h000020:		begin	tx_data6_en <= 1'b1;	end
    						24'h000040:		begin	tx_data7_en <= 1'b1;	end
    						24'h000080:		begin	tx_data8_en <= 1'b1;	end
    						24'h000100:		begin	tx_data9_en <= 1'b1;	end
    						24'h000200:		begin	tx_data10_en <= 1'b1;	end
    						24'h000400:		begin	tx_data11_en <= 1'b1;	end
    						24'h000800:		begin	tx_data12_en <= 1'b1;	end
    						24'h001000:		begin	tx_data13_en <= 1'b1;	end
    						24'h002000:		begin	tx_data14_en <= 1'b1;	end
    						24'h004000:		begin	tx_data15_en <= 1'b1;	end
    						24'h008000:		begin	tx_data16_en <= 1'b1;	end
    						24'h010000:		begin	tx_data17_en <= 1'b1;	end
    						24'h020000:		begin	tx_data18_en <= 1'b1;	end
    						24'h040000:		begin	tx_data19_en <= 1'b1;	end
    						24'h080000:		begin	tx_data20_en <= 1'b1;	end
    						default:	begin	
    										tx_data1_en <= 1'b0;
    			            			    tx_data2_en <= 1'b0;
    			            			    tx_data3_en <= 1'b0;
    			            			    tx_data4_en <= 1'b0;
    			            			    tx_data5_en <= 1'b0;
    			            			    tx_data6_en <= 1'b0;
    			            			    tx_data7_en <= 1'b0;
    			            			    tx_data8_en <= 1'b0;
    			            			    tx_data9_en <= 1'b0;
    			            			    tx_data10_en <= 1'b0;
    			            			    tx_data11_en <= 1'b0;
    			            			    tx_data12_en <= 1'b0;
    			            			    tx_data13_en <= 1'b0;
    			            			    tx_data14_en <= 1'b0;
    			            			    tx_data15_en <= 1'b0;
    			            			    tx_data16_en <= 1'b0;
    			            			    tx_data17_en <= 1'b0;
    			            			    tx_data18_en <= 1'b0;
    			            			    tx_data19_en <= 1'b0;
    			            			    tx_data20_en <= 1'b0;
    			            			end
    					endcase
    		default:	begin	
    						tx_data1_en <= 1'b0;
    			            tx_data2_en <= 1'b0;
    			            tx_data3_en <= 1'b0;
    			            tx_data4_en <= 1'b0;
    			            tx_data5_en <= 1'b0;
    			            tx_data6_en <= 1'b0;
    			            tx_data7_en <= 1'b0;
    			            tx_data8_en <= 1'b0;
    			            tx_data9_en <= 1'b0;
    			            tx_data10_en <= 1'b0;
    			            tx_data11_en <= 1'b0;
    			            tx_data12_en <= 1'b0;
    			            tx_data13_en <= 1'b0;
    			            tx_data14_en <= 1'b0;
    			            tx_data15_en <= 1'b0;
    			            tx_data16_en <= 1'b0;
    			            tx_data17_en <= 1'b0;
    			            tx_data18_en <= 1'b0;
    			            tx_data19_en <= 1'b0;
    			            tx_data20_en <= 1'b0;
    			        end
    	endcase
    end

endmodule
