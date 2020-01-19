`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:34:15 02/11/2015
// Design Name:   csa_blk_enc
// Module Name:   K:/pcie_4g_gbe/test_blk.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: csa_blk_enc
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_blk;

	// Inputs
	reg clk;
	reg rst;
	reg en_count_packet;
	reg [7:0] count_packet;
	reg [7:0] pid_num;
	reg en_pid_num;
	reg [7:0] gbe_num;
	reg en_gbe_num;
	reg [7:0] ip_port;
	reg en_ip_port;
	reg en_tsf;
	reg [7:0] tsf;
	reg en_cwr;
	reg [7:0] cwr;

	// Outputs
	wire finish_blk_enc;
	wire en_tsr;
	wire [7:0] tsr;

	// Instantiate the Unit Under Test (UUT)
	csa_blk_enc uut (
		.clk(clk), 
		.rst(rst), 
		.en_count_packet(en_count_packet), 
		.count_packet(count_packet), 
		.pid_num(pid_num), 
		.en_pid_num(en_pid_num), 
		.gbe_num(gbe_num), 
		.en_gbe_num(en_gbe_num), 
		.ip_port(ip_port), 
		.en_ip_port(en_ip_port), 
		.en_tsf(en_tsf), 
		.tsf(tsf), 
		.en_cwr(en_cwr), 
		.cwr(cwr), 
		.finish_blk_enc(finish_blk_enc), 
		.en_tsr(en_tsr), 
		.tsr(tsr)
	);
integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		en_count_packet = 0;
		count_packet = 0;
		pid_num = 0;
		en_pid_num = 0;
		gbe_num = 0;
		en_gbe_num = 0;
		ip_port = 0;
		en_ip_port = 0;
		en_tsf = 0;
		tsf = 0;
		en_cwr = 0;
		cwr = 0;

		#3 rst=1;
		#4 rst=0;
		// Wait 100 ns for global reset to finish
		#100;
        
        
       #10 en_cwr=1;
  		cwr=8'h07;
  		#10 cwr=8'h12;
  		#10 cwr=8'h34;
  		#10 cwr=8'h56;
  		#10 cwr=8'h78;
  		#10 cwr=8'h9a;
  		#10 cwr=8'hbc;
  		#10 cwr=8'hde;
  		#10 cwr=8'hf0;
  		#10 en_cwr=0;
  		
  		#10 en_tsf=1;
  		tsf=8'h47;
  		#10 tsf=8'h40;
  		#10 tsf=8'h01;
  		#10 tsf=8'h00;
  		for(i=1;i<185;i=i+1)
  		#10 tsf=i;
  		#10 en_tsf=0;
  		
		// Add stimulus here

	end
      always #5 clk=~clk;
endmodule

