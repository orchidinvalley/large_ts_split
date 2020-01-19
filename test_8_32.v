`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:52:33 02/12/2015
// Design Name:   ts_8to64
// Module Name:   K:/pcie_4g_gbe/test_8_32.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ts_8to64
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_8_32;

	// Inputs
	reg clk_main;
	reg rst;
	reg [8:0] ts_din;
	reg ts_din_en;

	// Outputs
	wire [32:0] ts_dout;
	wire ts_dout_en;

	// Instantiate the Unit Under Test (UUT)
	ts_8to64 uut (
		.clk_main(clk_main), 
		.rst(rst), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		.ts_dout(ts_dout), 
		.ts_dout_en(ts_dout_en)
	);
integer i;
	initial begin
		// Initialize Inputs
		clk_main = 0;
		rst = 0;
		ts_din = 0;
		ts_din_en = 0;


		#3 rst=1;
		#4 rst=0;
		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=9'h101;
        #10 ts_din=9'h000;
        #10 ts_din=9'h010;
        #10 ts_din=9'h001;
        #10 ts_din=9'h0c0;
        #10 ts_din=9'h012;
        #10 ts_din=9'h008;
        #10 ts_din=9'h002;
        #10 ts_din_en=0;
        
        #100 ts_din_en=1;
       		ts_din=9'h04e;
        #10 ts_din=9'h020;
        #10 ts_din_en=0;
        
        
        #50 ts_din_en=1;
        ts_din=9'h047;
        #10 ts_din=9'h040;
        #10 ts_din=9'h001;
        #10 ts_din=9'h000;
        for(i=1;i<185;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
        
        
		// Add stimulus here

	end
	
	always # 5 clk_main=~clk_main;
      
endmodule

