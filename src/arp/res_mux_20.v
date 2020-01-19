`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:23:38 05/21/2011 
// Design Name: 
// Module Name:    res_mux_2 
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
module	res_mux_20(
		
		rx_port1_ip,
		rx_port1_mac,
		rx_port1_en,
		
		rx_port2_ip,
		rx_port2_mac,
		rx_port2_en,
		
		rx_port3_ip,
		rx_port3_mac,
		rx_port3_en,
		
		rx_port4_ip,
		rx_port4_mac,
		rx_port4_en,
		
		rx_port5_ip,
		rx_port5_mac,
		rx_port5_en,
		
		rx_port6_ip,
		rx_port6_mac,
		rx_port6_en,
		
		rx_port7_ip,
		rx_port7_mac,
		rx_port7_en,
		
		rx_port8_ip,
		rx_port8_mac,
		rx_port8_en,
		
		rx_port9_ip,
		rx_port9_mac,
		rx_port9_en,
		
		rx_port10_ip,
		rx_port10_mac,
		rx_port10_en,
		
		rx_port11_ip,
		rx_port11_mac,
		rx_port11_en,
		
		rx_port12_ip,
		rx_port12_mac,
		rx_port12_en,
		
		rx_port13_ip,
		rx_port13_mac,
		rx_port13_en,
		
		rx_port14_ip,
		rx_port14_mac,
		rx_port14_en,
		
		rx_port15_ip,
		rx_port15_mac,
		rx_port15_en,
		
		rx_port16_ip,
		rx_port16_mac,
		rx_port16_en,
		
		rx_port17_ip,
		rx_port17_mac,
		rx_port17_en,
		
		rx_port18_ip,
		rx_port18_mac,
		rx_port18_en,
		
		rx_port19_ip,
		rx_port19_mac,
		rx_port19_en,
		
		rx_port20_ip,
		rx_port20_mac,
		rx_port20_en,
		
		rx_del_ip,
		rx_del_en,
		
		tx_netport,
		tx_ip,
		tx_mac,
		tx_en,
		
		rst,
		clk
		
    );

	output	reg		[23:0]	tx_netport;
	output	reg		[31:0]	tx_ip;
	output	reg		[47:0]	tx_mac;
	output	reg				tx_en;
	
	input			[31:0]	rx_port1_ip;
	input			[47:0]	rx_port1_mac;
	input					rx_port1_en;
	
	input			[31:0]	rx_port2_ip;
	input			[47:0]	rx_port2_mac;
	input					rx_port2_en;
	
	input			[31:0]	rx_port3_ip;
	input			[47:0]	rx_port3_mac;
	input					rx_port3_en;
	
	input			[31:0]	rx_port4_ip;
	input			[47:0]	rx_port4_mac;
	input					rx_port4_en;
	
	input			[31:0]	rx_port5_ip;
	input			[47:0]	rx_port5_mac;
	input					rx_port5_en;
	
	input			[31:0]	rx_port6_ip;
	input			[47:0]	rx_port6_mac;
	input					rx_port6_en;
	
	input			[31:0]	rx_port7_ip;
	input			[47:0]	rx_port7_mac;
	input					rx_port7_en;
	
	input			[31:0]	rx_port8_ip;
	input			[47:0]	rx_port8_mac;
	input					rx_port8_en;
	
	input			[31:0]	rx_port9_ip;
	input			[47:0]	rx_port9_mac;
	input					rx_port9_en;
	
	input			[31:0]	rx_port10_ip;
	input			[47:0]	rx_port10_mac;
	input					rx_port10_en;
	
	input			[31:0]	rx_port11_ip;
	input			[47:0]	rx_port11_mac;
	input					rx_port11_en;
	
	input			[31:0]	rx_port12_ip;
	input			[47:0]	rx_port12_mac;
	input					rx_port12_en;
	
	input			[31:0]	rx_port13_ip;
	input			[47:0]	rx_port13_mac;
	input					rx_port13_en;
	
	input			[31:0]	rx_port14_ip;
	input			[47:0]	rx_port14_mac;
	input					rx_port14_en;
	
	input			[31:0]	rx_port15_ip;
	input			[47:0]	rx_port15_mac;
	input					rx_port15_en;
	
	input			[31:0]	rx_port16_ip;
	input			[47:0]	rx_port16_mac;
	input					rx_port16_en;
	
	input			[31:0]	rx_port17_ip;
	input			[47:0]	rx_port17_mac;
	input					rx_port17_en;
	
	input			[31:0]	rx_port18_ip;
	input			[47:0]	rx_port18_mac;
	input					rx_port18_en;
	
	input			[31:0]	rx_port19_ip;
	input			[47:0]	rx_port19_mac;
	input					rx_port19_en;
	
	input			[31:0]	rx_port20_ip;
	input			[47:0]	rx_port20_mac;
	input					rx_port20_en;
	
	input			[31:0]	rx_del_ip;
	input					rx_del_en;
	
	input					rst;
	input					clk;
	
always@(posedge clk)
begin
	if(rst)
	begin
		tx_netport <= 0;	tx_ip <= 31'b0;	tx_mac <= 48'b0;	tx_en <= 1'b0;
	end
	else	if(rx_del_en)
	begin
		tx_netport <= 0;	tx_ip <= rx_del_ip;	tx_mac <= 48'b0;	tx_en <= 1'b1;
	end
	else	if(rx_port1_en)
	begin
		tx_netport <= 24'h000001;	tx_ip <= rx_port1_ip;	tx_mac <= rx_port1_mac;	tx_en <= 1'b1;  
	end
	else	if(rx_port2_en)
	begin
		tx_netport <= 24'h000002;	tx_ip <= rx_port2_ip;	tx_mac <= rx_port2_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port3_en)
	begin
		tx_netport <= 24'h000004;	tx_ip <= rx_port3_ip;	tx_mac <= rx_port3_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port4_en)
	begin
		tx_netport <= 24'h000008;	tx_ip <= rx_port4_ip;	tx_mac <= rx_port4_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port5_en)
	begin
		tx_netport <= 24'h000010;	tx_ip <= rx_port5_ip;	tx_mac <= rx_port5_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port6_en)
	begin
		tx_netport <= 24'h000020;	tx_ip <= rx_port6_ip;	tx_mac <= rx_port6_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port7_en)
	begin
		tx_netport <= 24'h000040;	tx_ip <= rx_port7_ip;	tx_mac <= rx_port7_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port8_en)
	begin
		tx_netport <= 24'h000080;	tx_ip <= rx_port8_ip;	tx_mac <= rx_port8_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port9_en)
	begin
		tx_netport <= 24'h000100;	tx_ip <= rx_port9_ip;	tx_mac <= rx_port9_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port10_en)
	begin
		tx_netport <= 24'h000200;	tx_ip <= rx_port10_ip;	tx_mac <= rx_port10_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port11_en)
	begin
		tx_netport <= 24'h000400;	tx_ip <= rx_port11_ip;	tx_mac <= rx_port11_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port12_en)
	begin
		tx_netport <= 24'h000800;	tx_ip <= rx_port12_ip;	tx_mac <= rx_port12_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port13_en)
	begin
		tx_netport <= 24'h001000;	tx_ip <= rx_port13_ip;	tx_mac <= rx_port13_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port14_en)
	begin
		tx_netport <= 24'h002000;	tx_ip <= rx_port14_ip;	tx_mac <= rx_port14_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port15_en)
	begin
		tx_netport <= 24'h004000;	tx_ip <= rx_port15_ip;	tx_mac <= rx_port15_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port16_en)
	begin
		tx_netport <= 24'h008000;	tx_ip <= rx_port16_ip;	tx_mac <= rx_port16_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port7_en)
	begin
		tx_netport <= 24'h010000;	tx_ip <= rx_port17_ip;	tx_mac <= rx_port17_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port18_en)
	begin
		tx_netport <= 24'h020000;	tx_ip <= rx_port18_ip;	tx_mac <= rx_port18_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port19_en)
	begin
		tx_netport <= 24'h040000;	tx_ip <= rx_port19_ip;	tx_mac <= rx_port19_mac;	tx_en <= 1'b1;   
	end
	else	if(rx_port20_en)
	begin
		tx_netport <= 24'h080000;	tx_ip <= rx_port20_ip;	tx_mac <= rx_port20_mac;	tx_en <= 1'b1;   
	end
	else
	begin
		tx_netport <= 0;	tx_ip <= 31'b0;	tx_mac <= 48'b0;	tx_en <= 1'b0; 
	end
end
	
endmodule
