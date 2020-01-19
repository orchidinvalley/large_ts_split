`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:10 03/22/2011 
// Design Name: 
// Module Name:    lut_ip_mac 
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
module	lut_netport_ip_mac(

			tx_ip,
			tx_mac,
			tx_en,
			tx_del_en,
			
			tx_req_ip,
			tx_req_netport,
			tx_req_en,

			rx_wr_ip,
			rx_wr_mac,
			rx_wr_addr,
			rx_wr_en,
			
			rx_seek_ip,
			rx_seek_netport,
			rx_seek_addr,
			rx_seek_en,
			
			//rd_current,
			
			rst,
			clk
          
		);
     
    output		[31:0]		tx_ip;                          
    output     	[47:0]		tx_mac;         
    output	reg				tx_en;
    output	reg				tx_del_en;          
					                
    output		[31:0]		tx_req_ip; 
    output		[23:0]		tx_req_netport;   
    output	reg				tx_req_en;
            	                
    input      	[31:0]  	rx_wr_ip;        
    input		[47:0]		rx_wr_mac;      
    input		[9:0]		rx_wr_addr;     
    input					rx_wr_en;  
    
    input		[23:0]		rx_seek_netport;         
    input		[31:0]		rx_seek_ip;     
	input		[9:0]		rx_seek_addr;
    input                   rx_seek_en;    
                                            
    input                   rst;            
    input                   clk;
                 
	//output		[1:0]	rd_current;
    
    reg			[23:0]		ram_netport;
    reg	  		[31:0]		ram_ip;
    reg   		[47:0]		ram_mac;
          		     		
    reg	  		[2:0]		rd_current;
    reg   		[2:0]		rd_next;
    
    reg			[5:0]		wait_cnt;

	wire		[79:0]		lut_ram_dout;
	
	parameter	WAIT_MAX = 6'd11;
	
	parameter	IDLE = 3'b000,
				COMPARE = 3'b001,
				SEND_MAC = 3'b010,
				SEND_MULTI = 3'b011,
				SEND_F = 3'b100,
				DEL_SEEK = 3'b101,
				REQUEST_MAC = 3'b110;
				
assign	tx_ip = ram_ip;
assign	tx_mac = ram_mac;
assign	tx_req_ip = ram_ip;
assign	tx_req_netport = ram_netport;

always@(posedge clk)
begin
	if(rst)
		rd_current <= IDLE;
	else
		rd_current <= rd_next; 
end

always@(rd_current or ram_ip or lut_ram_dout or rx_seek_en or wait_cnt)
begin
	case(rd_current)
		
		IDLE:			if(rx_seek_en)
							rd_next = COMPARE;
						else
							rd_next = IDLE;
		
		COMPARE:		if(ram_ip == 32'hffffffff)
							rd_next = SEND_F;
						else
							if(ram_ip[31:28] == 4'he)
								rd_next = SEND_MULTI;
							else
								if(ram_ip == lut_ram_dout[79:48] && lut_ram_dout[47:0] != 48'b0)
									rd_next = SEND_MAC;
								else
									if(wait_cnt <= WAIT_MAX && wait_cnt != 6'b0)
										rd_next = DEL_SEEK;
									else
										rd_next = REQUEST_MAC;
						
		SEND_MAC:		rd_next = IDLE;
		
		SEND_F:			rd_next = IDLE;
		
		SEND_MULTI:		rd_next = IDLE;
						
		DEL_SEEK:		rd_next = IDLE;			
		
		REQUEST_MAC:	rd_next = IDLE;
		
		default:		rd_next = IDLE;
		
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		IDLE:			begin
							ram_netport <= 0;
							ram_ip <= 32'b0;
							ram_mac <= 48'b0;
						end
		COMPARE:		begin
							ram_netport <= rx_seek_netport;
							ram_ip <= rx_seek_ip;
							ram_mac <= 48'b0;
						end
		SEND_MAC:		begin
							ram_netport <= ram_netport;
							ram_ip <= ram_ip;
							ram_mac <= lut_ram_dout[47:0];
						end
		SEND_MULTI:		begin
							ram_netport <= ram_netport;
							ram_ip <= ram_ip;
							ram_mac <= {25'b0000_0001_0000_0000_0101_1110_0,ram_ip[22:0]};
						end
		SEND_F:			begin
							ram_netport <= ram_netport;
							ram_ip <= ram_ip;
							ram_mac <= 48'hff_ff_ff_ff_ff_ff;
						end
		REQUEST_MAC:	begin
							ram_netport <= ram_netport;
							ram_ip <= ram_ip;
							ram_mac <= 48'b0;
						end
		default:		begin
							ram_netport <= ram_netport;
							ram_ip <= ram_ip;
							ram_mac <= ram_mac;
						end	
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		SEND_MAC:		begin
							tx_en <= 1'b1;
							tx_req_en <= 1'b0;
							tx_del_en <= 1'b0;
						end
		SEND_MULTI:		begin
							tx_en <= 1'b1;
							tx_req_en <= 1'b0;
							tx_del_en <= 1'b0;
						end
		SEND_F:			begin
							tx_en <= 1'b1;
							tx_req_en <= 1'b0;
							tx_del_en <= 1'b0;
						end
		DEL_SEEK:		begin
							tx_en <= 1'b0;
							tx_req_en <= 1'b0;
							tx_del_en <= 1'b1;
						end
		REQUEST_MAC:	begin
							tx_en <= 1'b0;
							tx_req_en <= 1'b1;
							tx_del_en <= 1'b1;
						end
		default:		begin
							tx_en <= 1'b0;
							tx_req_en <= 1'b0;
							tx_del_en <= 1'b0;
						end
	endcase
end

always@(posedge clk)
begin
	case(rd_next)
		SEND_MAC:		wait_cnt <= 6'd0;			
		SEND_MULTI:		wait_cnt <= 6'd0;
		SEND_F:			wait_cnt <= 6'd0;			
		DEL_SEEK:		wait_cnt <= wait_cnt + 1'b1;
		REQUEST_MAC:	wait_cnt <= 6'd1;			
		default:		wait_cnt <= wait_cnt;
	endcase
end

    
    lut_ram lut_ram (
    
    .doutb(lut_ram_dout),// Bus [79 : 0] ip + mac
	
	.addra(rx_wr_addr), // Bus [9 : 0] 
	.dina({rx_wr_ip,rx_wr_mac}), // Bus [79 : 0] 
	.wea(rx_wr_en), // Bus [0 : 0]
	
	.addrb(rx_seek_addr), // Bus [9 : 0] 
	
	.clka(clk),
	.clkb(clk)
	); 
	
endmodule
