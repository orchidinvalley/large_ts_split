`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:31:49 09/12/2019
// Design Name:   pcie_ts_rd
// Module Name:   E:/FPGA_pro/pcie_4gbe/pcie_ts_rd_test.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pcie_ts_rd
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pcie_ts_rd_test;

	// Inputs
	reg clk_ts;
	reg rst_ts;
	reg ts_ram_wr;
	reg [63:0]ts_ram_wdata;
	reg clk;
	reg rst;
	reg dma_write_start;
	reg dma_write_end;
	reg dma_raddr_en;
	reg [31:0] dma_raddr;
	wire dma_rdata_busy;
	reg ott_ram_clear;
	reg [63:0] ott_doutb;
	reg [511:0] dvb_doutb;
	reg ts_ram_valid;

	// Outputs
	wire dma_rdata_rdy;
	wire [63:0] dma_rdata;
	wire [13:0] ott_raddr;
	wire [5:0] dvb_raddr;
	wire test_flag;

	// Instantiate the Unit Under Test (UUT)
	pcie_ts_rd uut (
		.clk_ts(clk_ts), 
		.rst_ts(rst_ts), 
		.ts_ram_wr(ts_ram_wr), 
		.ts_ram_wdata(ts_ram_wdata), 
		.clk_pcie(clk), 
		.rst_pcie(rst), 
		.dma_write_start(dma_write_start), 
		.dma_write_end(dma_write_end), 
		.dma_raddr_en(dma_raddr_en), 
		.dma_raddr(dma_raddr), 
		.dma_rdata_rdy(dma_rdata_rdy), 
		.dma_rdata_busy(dma_rdata_busy), 
		.dma_rdata(dma_rdata)

	);

	integer i=0;

initial	begin
	#200260 dma_write_end=1	;
	#20 dma_write_end=0;
	
	
	#1000;
		dma_write_start	=1;
	#10 dma_write_start=0;
	
	
	#1000;
	
	 
    	#10 dma_raddr_en=1;
		dma_raddr=0;
		#10 dma_raddr=32'h40;
		#10 dma_raddr_en=0;
		#100 dma_raddr_en=1;
		dma_raddr=32'h80;
		#10 dma_raddr=32'hc0;
		#10 dma_raddr_en=0;
		
	#200260 dma_write_end=1	;
	#20 dma_write_end=0;
	
	#1000;
		dma_write_start	=1;
	#10 dma_write_start=0;
	
	
		
end

	initial begin
		// Initialize Inputs
		clk_ts = 0;
		rst_ts = 0;
		ts_ram_wr = 0;
		ts_ram_wdata = 0;
		clk = 0;
		rst = 0;
		dma_write_start = 0;
		dma_write_end = 0;
		dma_raddr_en = 0;
		dma_raddr = 0;

		ott_ram_clear = 0;
		ott_doutb = 0;
		dvb_doutb = 0;
		ts_ram_valid = 0;

		#2 rst=1;
		#5 rst_ts=1;
		// Wait 100 ns for global reset to finish
		#200;
		
		#20  rst_ts=0;
			rst=0;
			
			
			
		#200;	
		#10 dma_raddr_en=1;
		dma_raddr=0;
		#10 dma_raddr=32'h40;
		#10 dma_raddr_en=0;
		#100 dma_raddr_en=1;
		dma_raddr=32'h80;
		#10 dma_raddr=32'hc0;
		#10 dma_raddr_en=0;
		
		
		#20  ts_ram_wr=1;
		ts_ram_wdata=64'haaaaaaaa00000000;
		#20 ts_ram_wdata=64'h00000028aaaaaaaa;
		#20
		ts_ram_wdata=1;
    
    for(i=2;i<1024;i=i+1)
    #20  ts_ram_wdata=i;
    #20  ts_ram_wdata=0;
    	ts_ram_wr=0;
    
    
    #200;
    
    dma_write_start	=1;
    #20
    dma_write_start=0;
    
//    #20  ts_ram_wr=1;
//		ts_ram_wdata=1;
//    
//    for(i=2;i<1024;i=i+1)
//    #20  ts_ram_wdata=i;
//    #20  ts_ram_wdata=0;
//    	ts_ram_wr=0;     
//    	
//    	
//    #200;
//    
//    dma_write_end	=1;
//    #20
//    dma_write_end=0;	
//    	
//    #200;
//    
//    dma_write_start	=1;
//    #20
//    dma_write_start=0;
//    
//    #20  ts_ram_wr=1;
//		ts_ram_wdata=1;
//    
//    for(i=2;i<1024;i=i+1)
//    #20  ts_ram_wdata=i;
//    #20  ts_ram_wdata=0;
//    	ts_ram_wr=0;     
//    	
//    	
//    #200;
//    
//    dma_write_start	=1;
//    #20
//    dma_write_start=0;
//    
//    #20  ts_ram_wr=1;
//		ts_ram_wdata=1;
//    
//    for(i=2;i<1024;i=i+1)
//    #20  ts_ram_wdata=i;
//    #20  ts_ram_wdata=0;
//    	ts_ram_wr=0;     
//    	
//    	
//    	#200;
//    
//    dma_write_start	=1;
//    #20
//    dma_write_start=0;
//    
//    #200;
    
    	#10 dma_raddr_en=1;
		dma_raddr=0;
		#10 dma_raddr=32'h40;
		#10 dma_raddr_en=0;
		#100 dma_raddr_en=1;
		dma_raddr=32'h80;
		#10 dma_raddr=32'hc0;
		#10 dma_raddr_en=0;
    
//    #20  ts_ram_wr=1;
//		ts_ram_wdata=1;
//    
//    for(i=2;i<1024;i=i+1)
//    #20  ts_ram_wdata=i;
//    #20  ts_ram_wdata=0;
//    	ts_ram_wr=0;     
    	
    	
//    	#200;
//    
//    dma_write_start	=1;
//    #20
//    dma_write_start=0;
//    
//    #20  ts_ram_wr=1;
//		ts_ram_wdata=1;
//    
//    for(i=2;i<1024;i=i+1)
//    #20  ts_ram_wdata=i;
//    #20  ts_ram_wdata=0;
//    	ts_ram_wr=0;     
//    	
//    	
//    	#200;
//    
//    dma_write_start	=1;
//    #20
//    dma_write_start=0;
//    
//    #20  ts_ram_wr=1;
//		ts_ram_wdata=1;
//    
//    for(i=2;i<1024;i=i+1)
//    #20  ts_ram_wdata=i;
//    #20  ts_ram_wdata=0;
//    	ts_ram_wr=0;     		
//		// Add stimulus here

	end
	
	always #10  clk_ts=~clk_ts;
  always #5 clk=!clk;    
endmodule

