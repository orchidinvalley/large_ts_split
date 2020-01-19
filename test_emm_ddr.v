`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:56:47 02/13/2015
// Design Name:   emm_ddr_8to32
// Module Name:   K:/pcie_4g_gbe/test_emm_ddr.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: emm_ddr_8to32
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_emm_ddr;

	// Inputs
	reg clk;
	reg rst;
	reg emm_head_din_en;
	reg [7:0] emm_head_din;
	reg emm_body_din_en;
	reg [7:0] emm_body_din;
	reg ddr_din_en;
	reg [8:0] ddr_din;

	// Outputs
	wire emm_head_dout_en;
	wire [31:0] emm_head_dout;
	wire emm_body_dout_en;
	wire [31:0] emm_body_dout;
	wire ddr_dout_en;
	wire [32:0] ddr_dout;
	wire [5:0] head_num;

	// Instantiate the Unit Under Test (UUT)
	emm_ddr_8to32 uut (
		.clk(clk), 
		.rst(rst), 
		.emm_head_din_en(emm_head_din_en), 
		.emm_head_din(emm_head_din), 
		.emm_body_din_en(emm_body_din_en), 
		.emm_body_din(emm_body_din), 
		.ddr_din_en(ddr_din_en), 
		.ddr_din(ddr_din), 
		.emm_head_dout_en(emm_head_dout_en), 
		.emm_head_dout(emm_head_dout), 
		.emm_body_dout_en(emm_body_dout_en), 
		.emm_body_dout(emm_body_dout), 
		.ddr_dout_en(ddr_dout_en), 
		.ddr_dout(ddr_dout), 
		.head_num(head_num)
	);
integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		emm_head_din_en = 0;
		emm_head_din = 0;
		emm_body_din_en = 0;
		emm_body_din = 0;
		ddr_din_en = 0;
		ddr_din = 0;

		#3 rst=1;
		#4 rst=0;
	
		// Wait 100 ns for global reset to finish
		#100;
		
		
		#10 emm_body_din_en=1;
		emm_body_din=8'h01;
		#10 emm_body_din=8'h02;
		#10 emm_body_din=8'h00;
		#10 emm_body_din=8'h00;
		#10 emm_body_din=8'h01;
		#10 emm_body_din=8'hc0;
		#10 emm_body_din=8'h12;
		#10 emm_body_din=8'h08;
		#10 emm_body_din=8'h02;
		#10 emm_body_din=8'h4e;
		#10 emm_body_din=8'h20;
		#10 emm_body_din=8'h47;
		#10 emm_body_din=8'h43;
		#10 emm_body_din=8'he8;
		#10 emm_body_din=8'h02;
		for(i=1;i<185;i=i+1)
		#10 emm_body_din=i;
		#10 emm_body_din_en=0;
		

		#10 ddr_din_en=1;
		ddr_din=9'h103;
		#10 ddr_din=9'h002;
		#10 ddr_din=9'h000;
		#10 ddr_din=9'h000;
		#10 ddr_din=9'h001;
		#10 ddr_din_en=0;
		#50 ddr_din_en=1;
		 ddr_din=9'h0c0;
		#10 ddr_din=9'h012;
		#10 ddr_din=9'h008;
		#10 ddr_din=9'h002;
		#10 ddr_din=9'h04e;
		#10 ddr_din=9'h020;
        #10 ddr_din_en=0;
        
        #60 ddr_din_en=1;
        ddr_din=9'h047;
        #10 ddr_din=9'h040;
        #10 ddr_din=9'h000;
        #10 ddr_din=9'h002;
        for(i=1;i<185;i=i+1)
        #10 ddr_din=i;
        #10 ddr_din_en=0;
		// Add stimulus here

	end
      
      
     always #5 clk=~clk; 
endmodule

