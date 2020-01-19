`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:59:32 02/15/2015
// Design Name:   dis_32bit_variable
// Module Name:   K:/pcie_4g_gbe/test_dis32.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dis_32bit_variable
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_dis32;

	// Inputs
	reg [31:0] din_32bit;
	reg din_32bit_en;
	reg [47:0] arp_mac_din;
	reg arp_mac_din_en;
	reg arp_del_din_en;
	reg rst;
	reg clk;

	// Outputs
	wire [31:0] dout_32bit;
	wire dout_port1_en;
	wire dout_port2_en;
	wire dout_port3_en;
	wire dout_port4_en;
	wire find_mac_dout;
	wire dis_fifo_empty_dout;
	wire [31:0] arp_ip_dout;
	wire [23:0] arp_netport_dout;
	wire arp_dout_en;

	// Instantiate the Unit Under Test (UUT)
	dis_32bit_variable uut (
		.dout_32bit(dout_32bit), 
		.dout_port1_en(dout_port1_en), 
		.dout_port2_en(dout_port2_en), 
		.dout_port3_en(dout_port3_en), 
		.dout_port4_en(dout_port4_en), 
		.find_mac_dout(find_mac_dout), 
		.dis_fifo_empty_dout(dis_fifo_empty_dout), 
		.arp_ip_dout(arp_ip_dout), 
		.arp_netport_dout(arp_netport_dout), 
		.arp_dout_en(arp_dout_en), 
		.din_32bit(din_32bit), 
		.din_32bit_en(din_32bit_en), 
		.arp_mac_din(arp_mac_din), 
		.arp_mac_din_en(arp_mac_din_en), 
		.arp_del_din_en(arp_del_din_en), 
		.rst(rst), 
		.clk(clk)
	);

integer i;
	initial begin
		// Initialize Inputs
		din_32bit = 0;
		din_32bit_en = 0;
		arp_mac_din = 0;
		arp_mac_din_en = 0;
		arp_del_din_en = 0;
		rst = 0;
		clk = 0;

			#3 rst=1;
		#4 rst=0;
		// Wait 100 ns for global reset to finish
		#100;
        
        #10	din_32bit_en=1;
        din_32bit=32'h0000_0001;
        #10 din_32bit=32'hc012_0802;
        #10 din_32bit=32'h0000_4e20;
        #10 din_32bit=32'h47400100;
        for(i=1;i<47;i=i+1)
        #10 din_32bit=i;
        #10 din_32bit_en=0;
		// Add stimulus here
		#10 arp_mac_din_en=1;
		#100 arp_mac_din_en=0;
	end
      always  #5 clk=~clk;
endmodule

