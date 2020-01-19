`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:33:44 02/11/2015
// Design Name:   csa_tx
// Module Name:   K:/pcie_4g_gbe/test_csa_tx.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: csa_tx
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_csa_tx;

	// Inputs
	reg clk_main;
	reg rst;
	reg [32:0] ts_in_csa;
	reg en_in_csa;

	// Outputs
	wire ts_out_csa_en_64;
	wire [32:0] ts_out_csa_64;

	// Instantiate the Unit Under Test (UUT)
	csa_tx uut (
		.clk_main(clk_main), 
		.rst(rst), 
		.ts_in_csa(ts_in_csa), 
		.en_in_csa(en_in_csa), 
		.ts_out_csa_en_64(ts_out_csa_en_64), 
		.ts_out_csa_64(ts_out_csa_64)
	);
integer i;
reg [7:0]tmp1,tmp2,tmp3,tmp4;
	initial begin
		// Initialize Inputs
		clk_main = 0;
		rst = 0;
		ts_in_csa = 0;
		en_in_csa = 0;

		#3 rst=1;
		#4 rst=0;
		// Wait 100 ns for global reset to finish
		#100;
		
//		#10 en_in_csa=1;
//			ts_in_csa=33'h10000_0001;
//			#10 ts_in_csa=33'h00000_0007;
//			#10 ts_in_csa=33'h01234_5678;
//			#10 ts_in_csa=33'h09abc_def0;
//			#10 ts_in_csa=33'h00000_0010;
//			#10 ts_in_csa=33'h00000_0001;
//			#10 ts_in_csa=33'h0c012_0801;
//			#10 ts_in_csa=33'h00000_4e20;
//			#10 ts_in_csa=33'h04740_0100;
//				for(i=1;i<185;i=i+4)
//		       	begin
//		       	tmp1		=i;
//		       	tmp2	=i+1;
//		       	tmp3	=i+2;
//		       	tmp4	=i+3;
//       			#10 ts_in_csa={tmp1,tmp2,tmp3,tmp4};
//       			end
//        #10 en_in_csa=0;
		// Add stimulus here
		#10 en_in_csa=1;
			ts_in_csa=33'h10000_0001;
			#10 ts_in_csa=33'h00000_0000;
			#10 ts_in_csa=33'h01234_5678;
			#10 ts_in_csa=33'h09abc_def0;
			#10 ts_in_csa=33'h00000_0010;
			#10 ts_in_csa=33'h00000_0001;
			#10 ts_in_csa=33'h0c012_0801;
			#10 ts_in_csa=33'h00000_4e20;
			#10 ts_in_csa=33'h04740_0100;
				for(i=1;i<185;i=i+4)
		       	begin
		       	tmp1		=i;
		       	tmp2	=i+1;
		       	tmp3	=i+2;
		       	tmp4	=i+3;
       			#10 ts_in_csa={tmp1,tmp2,tmp3,tmp4};
       			end
        #10 en_in_csa=0;

	end
      
      always #5 clk_main=~clk_main;
endmodule

