`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:11 05/21/2011 
// Design Name: 
// Module Name:    req_mux 
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
module	req_mux(

		tx_req_netport,
		tx_req_ip,
		tx_req_en,
		
		rx_fade_netport,
		rx_fade_ip,
		rx_fade_en,
		
		rx_lut_netport,
		rx_lut_ip,
		rx_lut_en,
		
		rst,
		clk
    );

		output	reg		[3:0]	tx_req_netport;    
		output	reg		[31:0]	tx_req_ip;         
		output	reg				tx_req_en;         
		                   
		input			[3:0]	rx_fade_netport;   
		input			[31:0]	rx_fade_ip;        
		input					rx_fade_en;        
					                   
		input			[3:0]	rx_lut_netport;    
		input			[31:0]	rx_lut_ip;         
		input					rx_lut_en;         
					                   
		input					rst;               
		input					clk;               
		   
		   
always@(posedge clk)
begin
	if(rst)
	begin
		tx_req_netport <= 4'b0;
		tx_req_ip <= 32'b0;  
		tx_req_en <= 1'b0;    
	end
	else	if(rx_lut_en)
	begin
		tx_req_netport <= rx_lut_netport;
		tx_req_ip <= rx_lut_ip;  
		tx_req_en <= 1'b1; 
	end
	else	if(rx_fade_en)
	begin
		tx_req_netport <= rx_fade_netport;
		tx_req_ip <= rx_fade_ip;  
		tx_req_en <= 1'b1; 
	end
	else
	begin
		tx_req_netport <= 4'b0;
		tx_req_ip <= 32'b0;  
		tx_req_en <= 1'b0;    
	end
end		   
		   
endmodule
