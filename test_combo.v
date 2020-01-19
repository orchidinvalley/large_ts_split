`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:22:04 02/12/2015
// Design Name:   csa_ts_combo
// Module Name:   K:/pcie_4g_gbe/test_combo.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: csa_ts_combo
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_combo;

	// Inputs
	reg clk;
	reg rst;
	reg [32:0] csa1_din;
	reg csa1_din_en;
	reg [32:0] csa2_din;
	reg csa2_din_en;
	reg [32:0] csa3_din;
	reg csa3_din_en;
	reg [32:0] csa4_din;
	reg csa4_din_en;
	reg [32:0] csa5_din;
	reg csa5_din_en;
	reg [32:0] csa6_din;
	reg csa6_din_en;
	reg [32:0] csa7_din;
	reg csa7_din_en;
	reg [32:0] csa8_din;
	reg csa8_din_en;
	reg [32:0] csa9_din;
	reg csa9_din_en;
	reg [32:0] csa10_din;
	reg csa10_din_en;
	reg [32:0] csa11_din;
	reg csa11_din_en;
	reg [32:0] csa12_din;
	reg csa12_din_en;
	reg [32:0] csa13_din;
	reg csa13_din_en;
	reg [32:0] csa14_din;
	reg csa14_din_en;
	reg [32:0] csa15_din;
	reg csa15_din_en;
	reg [32:0] csa16_din;
	reg csa16_din_en;
	reg [32:0] csa17_din;
	reg csa17_din_en;
	reg [32:0] csa18_din;
	reg csa18_din_en;
	reg [32:0] csa19_din;
	reg csa19_din_en;
	reg [32:0] csa20_din;
	reg csa20_din_en;
	reg [32:0] csa21_din;
	reg csa21_din_en;
	reg [32:0] csa22_din;
	reg csa22_din_en;
	reg [32:0] csa23_din;
	reg csa23_din_en;
	reg [32:0] csa24_din;
	reg csa24_din_en;
	reg [32:0] csa25_din;
	reg csa25_din_en;
	reg [32:0] csa26_din;
	reg csa26_din_en;
	reg [32:0] csa27_din;
	reg csa27_din_en;
	reg [32:0] csa28_din;
	reg csa28_din_en;
	reg [32:0] csa29_din;
	reg csa29_din_en;
	reg [32:0] csa30_din;
	reg csa30_din_en;
	reg [32:0] csa31_din;
	reg csa31_din_en;
	reg [32:0] csa32_din;
	reg csa32_din_en;

	// Outputs
	wire [32:0] csa_dout;
	wire csa_dout_en;

	// Instantiate the Unit Under Test (UUT)
	csa_ts_combo uut (
		.clk(clk), 
		.rst(rst), 
		.csa1_din(csa1_din), 
		.csa1_din_en(csa1_din_en), 
		.csa2_din(csa2_din), 
		.csa2_din_en(csa2_din_en), 
		.csa3_din(csa3_din), 
		.csa3_din_en(csa3_din_en), 
		.csa4_din(csa4_din), 
		.csa4_din_en(csa4_din_en), 
		.csa5_din(csa5_din), 
		.csa5_din_en(csa5_din_en), 
		.csa6_din(csa6_din), 
		.csa6_din_en(csa6_din_en), 
		.csa7_din(csa7_din), 
		.csa7_din_en(csa7_din_en), 
		.csa8_din(csa8_din), 
		.csa8_din_en(csa8_din_en), 
		.csa9_din(csa9_din), 
		.csa9_din_en(csa9_din_en), 
		.csa10_din(csa10_din), 
		.csa10_din_en(csa10_din_en), 
		.csa11_din(csa11_din), 
		.csa11_din_en(csa11_din_en), 
		.csa12_din(csa12_din), 
		.csa12_din_en(csa12_din_en), 
		.csa13_din(csa13_din), 
		.csa13_din_en(csa13_din_en), 
		.csa14_din(csa14_din), 
		.csa14_din_en(csa14_din_en), 
		.csa15_din(csa15_din), 
		.csa15_din_en(csa15_din_en), 
		.csa16_din(csa16_din), 
		.csa16_din_en(csa16_din_en), 
		.csa17_din(csa17_din), 
		.csa17_din_en(csa17_din_en), 
		.csa18_din(csa18_din), 
		.csa18_din_en(csa18_din_en), 
		.csa19_din(csa19_din), 
		.csa19_din_en(csa19_din_en), 
		.csa20_din(csa20_din), 
		.csa20_din_en(csa20_din_en), 
		.csa21_din(csa21_din), 
		.csa21_din_en(csa21_din_en), 
		.csa22_din(csa22_din), 
		.csa22_din_en(csa22_din_en), 
		.csa23_din(csa23_din), 
		.csa23_din_en(csa23_din_en), 
		.csa24_din(csa24_din), 
		.csa24_din_en(csa24_din_en), 
		.csa25_din(csa25_din), 
		.csa25_din_en(csa25_din_en), 
		.csa26_din(csa26_din), 
		.csa26_din_en(csa26_din_en), 
		.csa27_din(csa27_din), 
		.csa27_din_en(csa27_din_en), 
		.csa28_din(csa28_din), 
		.csa28_din_en(csa28_din_en), 
		.csa29_din(csa29_din), 
		.csa29_din_en(csa29_din_en), 
		.csa30_din(csa30_din), 
		.csa30_din_en(csa30_din_en), 
		.csa31_din(csa31_din), 
		.csa31_din_en(csa31_din_en), 
		.csa32_din(csa32_din), 
		.csa32_din_en(csa32_din_en), 
		.csa_dout(csa_dout), 
		.csa_dout_en(csa_dout_en)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		csa1_din = 0;
		csa1_din_en = 0;
		csa2_din = 0;
		csa2_din_en = 0;
		csa3_din = 0;
		csa3_din_en = 0;
		csa4_din = 0;
		csa4_din_en = 0;
		csa5_din = 0;
		csa5_din_en = 0;
		csa6_din = 0;
		csa6_din_en = 0;
		csa7_din = 0;
		csa7_din_en = 0;
		csa8_din = 0;
		csa8_din_en = 0;
		csa9_din = 0;
		csa9_din_en = 0;
		csa10_din = 0;
		csa10_din_en = 0;
		csa11_din = 0;
		csa11_din_en = 0;
		csa12_din = 0;
		csa12_din_en = 0;
		csa13_din = 0;
		csa13_din_en = 0;
		csa14_din = 0;
		csa14_din_en = 0;
		csa15_din = 0;
		csa15_din_en = 0;
		csa16_din = 0;
		csa16_din_en = 0;
		csa17_din = 0;
		csa17_din_en = 0;
		csa18_din = 0;
		csa18_din_en = 0;
		csa19_din = 0;
		csa19_din_en = 0;
		csa20_din = 0;
		csa20_din_en = 0;
		csa21_din = 0;
		csa21_din_en = 0;
		csa22_din = 0;
		csa22_din_en = 0;
		csa23_din = 0;
		csa23_din_en = 0;
		csa24_din = 0;
		csa24_din_en = 0;
		csa25_din = 0;
		csa25_din_en = 0;
		csa26_din = 0;
		csa26_din_en = 0;
		csa27_din = 0;
		csa27_din_en = 0;
		csa28_din = 0;
		csa28_din_en = 0;
		csa29_din = 0;
		csa29_din_en = 0;
		csa30_din = 0;
		csa30_din_en = 0;
		csa31_din = 0;
		csa31_din_en = 0;
		csa32_din = 0;
		csa32_din_en = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

