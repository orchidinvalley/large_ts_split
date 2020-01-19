`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:38:53 05/21/2011 
// Design Name: 
// Module Name:    res_req_tx_mux 
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
module res_req_tx_mux(
		
		tx_rr,
		tx_rr_en_n,
		tx_rr_sof_n,
		tx_rr_eof_n,
		
		rx_req,
		rx_req_en_n,
		rx_req_sof_n,
		rx_req_eof_n,
		
		rx_res,
		rx_res_en_n,
		rx_res_sof_n,
		rx_res_eof_n,
		
		rst,
		clk
    );

	output	reg		[7:0]	tx_rr;
	output	reg				tx_rr_en_n;
	output	reg				tx_rr_sof_n;
	output	reg				tx_rr_eof_n;
	
	input			[7:0]	rx_req;
	input					rx_req_en_n;
	input					rx_req_sof_n;
	input					rx_req_eof_n;
					
	input			[7:0]	rx_res;
	input					rx_res_en_n;
	input					rx_res_sof_n;
	input					rx_res_eof_n;
					
	input					rst;
	input					clk;
	
always@(posedge clk)
begin
	if(rst)
	begin
		tx_rr <= 8'b0;
		tx_rr_en_n <= 1'b1;
		tx_rr_sof_n <= 1'b1;
		tx_rr_eof_n <= 1'b1;
	end
	else	if(rx_res_en_n == 1'b0)
	begin
		tx_rr <= rx_res;
		tx_rr_en_n <= 1'b0;
		tx_rr_sof_n <= rx_res_sof_n;
		tx_rr_eof_n <= rx_res_eof_n;
	end
	else	if(rx_req_en_n == 1'b0)
	begin
		tx_rr <= rx_req;
		tx_rr_en_n <= 1'b0;
		tx_rr_sof_n <= rx_req_sof_n;
		tx_rr_eof_n <= rx_req_eof_n;
	end
	else
	begin
		tx_rr <= 8'b0;
		tx_rr_en_n <= 1'b1;
		tx_rr_sof_n <= 1'b1;
		tx_rr_eof_n <= 1'b1;
	end
end

endmodule
