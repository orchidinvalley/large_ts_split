`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:34:06 09/25/2019
// Design Name:   pcie_rd_ram
// Module Name:   E:/FPGA_pro/pcie_4gbe/pcie_rd_ram_test.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pcie_rd_ram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pcie_rd_ram_test;

	// Inputs
	reg clk;
	reg rst;
	reg dma_raddr_en;
	reg [31:0] dma_raddr;
	reg ott_ram_clear;
	reg [511:0] ott_doutb;
	reg [511:0] dvb_doutb;
	reg ts_ram_valid;

	// Outputs
	wire [63:0] dma_rdata;
	wire dma_rdata_rdy;
	wire dma_rdata_busy;
	wire [10:0] ott_raddr;
	wire [5:0] dvb_raddr;
	wire test_flag;

	// Instantiate the Unit Under Test (UUT)
	pcie_rd_ram uut (
		.clk(clk), 
		.rst(rst), 
		.dma_rdata(dma_rdata), 
		.dma_raddr_en(dma_raddr_en), 
		.dma_raddr(dma_raddr), 
		.dma_rdata_rdy(dma_rdata_rdy), 
		.dma_rdata_busy(dma_rdata_busy), 
		.ott_ram_clear(ott_ram_clear), 
		.ott_raddr(ott_raddr), 
		.ott_doutb(ott_doutb), 
		.dvb_raddr(dvb_raddr), 
		.dvb_doutb(dvb_doutb), 
		.ts_ram_valid(ts_ram_valid), 
		.test_flag(test_flag)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		dma_raddr_en = 0;
		dma_raddr = 0;
		ott_ram_clear = 0;
		ott_doutb = 512'h12345678123456781234567812345678123456781234567812345678123456781234567812345678123456781234567812345678123456781234567812345678;
		dvb_doutb = 0;
		ts_ram_valid = 0;

		#3rst =1;
		// Wait 100 ns for global reset to finish
		#100;
		
		rst =0 ;
		
		#1000;
		
		dma_raddr_en=1;
		
		dma_raddr=32'h00000040;
		#10 dma_raddr=32'h00000080;
	
		#10 dma_raddr_en=0;
        
		// Add stimulus here

	end
	
	always #5 clk=~clk;
      
endmodule

