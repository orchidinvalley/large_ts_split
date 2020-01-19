`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:00:30 09/26/2019
// Design Name:   pcie_ts_rd_v2
// Module Name:   E:/FPGA_pro/pcie_4gbe/pcie_rd_ram_v2_test.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pcie_ts_rd_v2
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pcie_rd_ram_v2_test;

	// Inputs
	reg clk_ts;
	reg rst_ts;
	reg ts_ram_wr;
	reg [511:0] ts_ram_wdata;
	reg clk_pcie;
	reg rst_pcie;
	reg dma_write_start;
	reg dma_write_end;
	reg dma_raddr_en;
	reg [31:0] dma_raddr;
	reg [511:0] dvb_doutb;

	// Outputs
	wire dma_rdata_rdy;
	wire dma_rdata_busy;
	wire [63:0] dma_rdata;
	wire [5:0] dvb_raddr;
	wire test_flag;

	// Instantiate the Unit Under Test (UUT)
	pcie_ts_rd_v2 uut (
		.clk_ts(clk_ts), 
		.rst_ts(rst_ts), 
		.ts_ram_wr(ts_ram_wr), 
		.ts_ram_wdata(ts_ram_wdata), 
		.clk_pcie(clk_pcie), 
		.rst_pcie(rst_pcie), 
		.dma_write_start(dma_write_start), 
		.dma_write_end(dma_write_end), 
		.dma_raddr_en(dma_raddr_en), 
		.dma_raddr(dma_raddr), 
		.dma_rdata_rdy(dma_rdata_rdy), 
		.dma_rdata_busy(dma_rdata_busy), 
		.dma_rdata(dma_rdata), 
		.dvb_raddr(dvb_raddr), 
		.dvb_doutb(dvb_doutb), 
		.test_flag(test_flag)
	);
	
	reg	flag=0;
	integer i=0;

	initial begin
		// Initialize Inputs
		clk_ts = 0;
		rst_ts = 0;
		ts_ram_wr = 0;
		ts_ram_wdata = 0;
		clk_pcie = 0;
		rst_pcie = 0;
		dma_write_start = 0;
		dma_write_end = 0;
		dma_raddr_en = 0;
		dma_raddr = 0;
		dvb_doutb = 0;
		
		#7 rst_ts=1;
		rst_pcie=1;
		// Wait 100 ns for global reset to finish
		#100;
     rst_ts=0;
		rst_pcie=0 ;   
		// Add stimulus here
		
		#1000;
		
		ts_send();
		
		#1000;
		
		ts_send();
		
		#10 dma_write_start=1;
		#10 dma_write_start=0;
		
		#50;
			dma_raddr_en=1;
		#10 dma_raddr=32'h40;
		#10 dma_raddr_en=0;
		#160 dma_raddr_en=1;
			dma_raddr=32'h80;
		#10 dma_raddr=32'hc0;
		#10 dma_raddr_en=0;
		#160 dma_raddr_en=1;
			dma_raddr=32'h20000;
		#10 dma_raddr=32'h20040;
		#10 dma_raddr_en=0;
				
		#1000;
		
		ts_send();
		
		#10 dma_write_end=1;
		#10 dma_write_end=0;
		
		
		#1000;
		
		ts_send();
		
		#10 dma_write_start=1;
		#10 dma_write_start=0;
		
		#50;
			dma_raddr_en=1;
		#10 dma_raddr=32'h40;
		#10 dma_raddr_en=0;
		#160 dma_raddr_en=1;
			dma_raddr=32'h80;
		#10 dma_raddr=32'hc0;
		#10 dma_raddr_en=0;
		#160 dma_raddr_en=1;
			dma_raddr=32'h20000;
		#10 dma_raddr=32'h20040;
		#10 dma_raddr_en=0;
		
		
		#1000;	
		#10 dma_write_end=1;
		#10 dma_write_end=0;

	end
	
	always #10 clk_ts=~clk_ts;
	always #5 clk_pcie	=~clk_pcie;
	
	task ts_send();
	begin
		
		if(flag==0)begin
			for(i=0;i<1024;i=i+1)begin
			#20 ts_ram_wr=1;
//			ts_ram_wdata=512'h12345678123456781234567812345678123456781234567812345678123456781234567812345678123456781234567812345678123456781234567812345678;
				ts_ram_wdata=512'h0000000011111111111111111111111111111111111111111111111111111111111111111111111111111111000000000d430200471ffe130000005011111111;
			#20 ts_ram_wdata=512'h9abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef0;
			end
			
		end	
		else	begin
		for(i=0;i<1024;i=i+1)begin
			#20 ts_ram_wr=1;
			ts_ram_wdata=512'h9abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef09abcdef0;
			
			#20 ts_ram_wdata=512'h12345678123456781234567812345678123456781234567812345678123456781234567812345678123456781234567812345678123456781234567812345678;
			end
			
		end
		#20 ts_ram_wdata=0;
		ts_ram_wr=0;
		flag=flag+1;
	end
	endtask
      
endmodule

