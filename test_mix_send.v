`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:16:17 02/13/2015
// Design Name:   mix_data_send
// Module Name:   K:/pcie_4g_gbe/test_mix_send.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mix_data_send
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_mix_send;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] emm_head_din;
	reg emm_head_din_en;
	reg [7:0] emm_din;
	reg emm_din_en;
	reg [32:0] ts_din;
	reg ts_din_en;
	reg [8:0] ddr_din;
	reg ddr_din_en;

	// Outputs
	wire [31:0] ts_dout;
	wire ts_dout_en;

	// Instantiate the Unit Under Test (UUT)
	mix_data_send uut (
		.clk(clk), 
		.rst(rst), 
		.emm_head_din(emm_head_din), 
		.emm_head_din_en(emm_head_din_en), 
		.emm_din(emm_din), 
		.emm_din_en(emm_din_en), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		.ddr_din(ddr_din), 
		.ddr_din_en(ddr_din_en), 
		.ts_dout(ts_dout), 
		.ts_dout_en(ts_dout_en)
	);
integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		emm_head_din = 0;
		emm_head_din_en = 0;
		emm_din = 0;
		emm_din_en = 0;
		ts_din = 0;
		ts_din_en = 0;
		ddr_din = 0;
		ddr_din_en = 0;


		#3 rst=1;
		#4 rst=0;
		// Wait 100 ns for global reset to finish
		#100;
		
		#10 emm_head_din_en=1;
		emm_head_din=8'h03;
		#10 emm_head_din=8'h01;
		#10 emm_head_din=8'h01;
		#10 emm_head_din=8'h00;
		#10 emm_head_din=8'h00;
		#10 emm_head_din=8'h01;
		#10 emm_head_din=8'hc0;
		#10 emm_head_din=8'h12;
		#10 emm_head_din=8'h08;
		#10 emm_head_din=8'h01;
		#10 emm_head_din=8'h4e;
		#10 emm_head_din=8'h21;
		
		#10 emm_head_din=8'h01;
		#10 emm_head_din=8'h02;
		#10 emm_head_din=8'h00;
		#10 emm_head_din=8'h00;
		#10 emm_head_din=8'h02;
		#10 emm_head_din=8'hc0;
		#10 emm_head_din=8'h12;
		#10 emm_head_din=8'h08;
		#10 emm_head_din=8'h02;
		#10 emm_head_din=8'h4e;
		#10 emm_head_din=8'h22;
		
		#10 emm_head_din=8'h01;
		#10 emm_head_din=8'h03;
		#10 emm_head_din=8'h00;
		#10 emm_head_din=8'h00;
		#10 emm_head_din=8'h03;
		#10 emm_head_din=8'hc0;
		#10 emm_head_din=8'h12;
		#10 emm_head_din=8'h08;
		#10 emm_head_din=8'h01;
		#10 emm_head_din=8'h4e;
		#10 emm_head_din=8'h23;
		#10 emm_head_din_en=0;
		
		
		# 10 emm_din_en=1;
		 emm_din=8'h00;
		#10 emm_din=8'h00;
		#10 emm_din=8'h00;
		#10 emm_din=8'h00;
		#10 emm_din=8'h00;
		#10 emm_din=8'h00;
		#10 emm_din=8'h00;
		#10 emm_din=8'h00;
		#10 emm_din=8'h00;
		#10 emm_din=8'h00;
		#10 emm_din=8'h00;
		#10 emm_din=8'h47;
		#10 emm_din=8'h43;
		#10 emm_din=8'he8;
		#10 emm_din=8'h00;
		for(i=1;i<185;i=i+1)
		#10 emm_din=i;
		#10 emm_din_en=0;
        
        
        #1000;
        #10 ts_din_en=1;
        ts_din=33'h10000_0011;
        #10 ts_din=33'h00000_0001;
        #10 ts_din=33'h0c0120802;
        #10 ts_din=33'h00000_4e20;
        #10 ts_din=33'h047402001;
        for(i=1;i<47;i=i+1)
        #10 ts_din=i;
       
       
             #10 ts_din_en=0;
		// Add stimulus here
#1000;

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
	end
	
	always  #5 clk=~clk;
      
endmodule

