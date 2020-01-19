`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:20:08 02/09/2015
// Design Name:   ts_diff
// Module Name:   K:/pcie_4g_gbe/test_ts_diff.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ts_diff
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_ts_diff;

	// Inputs
	reg clk;
	reg rst;
	reg [32:0] ts_din;
	reg ts_din_en;

	// Outputs
	wire [32:0] ts_dout;
	wire ts_dout_en;

	// Instantiate the Unit Under Test (UUT)
	ts_diff uut (
		.clk(clk), 
		.rst(rst), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		.ts_dout(ts_dout), 
		.ts_dout_en(ts_dout_en)
	);
integer	i=0;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		ts_din = 0;
		ts_din_en = 0;
		# 3 rst =1;
		#4 rst=0;
		// Wait 100 ns for global reset to finish
		#100;
        
        #10 ts_din_en=1;
        	   ts_din= 1;
        #10 ts_din= 32'hc0120801;
        #10 ts_din= 32'h00000021;
        #10 ts_din=	32'h47000000;
      for(i=1;i<47;i=i+1)
      #10  ts_din= i;
      #10 ts_din_en=0;
      
      #100;
      
      
         #10 ts_din_en=1;
        	   ts_din= 1;
        #10 ts_din= 32'hc0120801;
        #10 ts_din= 32'h00000021;
        #10 ts_din=	32'h47000000;
      for(i=1;i<47;i=i+1)
      #10  ts_din= i;
      #10 ts_din_en=0;
		// Add stimulus here

	end
    always # 5  clk=~clk;  
endmodule

