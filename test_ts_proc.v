`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:01:44 02/11/2015
// Design Name:   csa_ts_proc
// Module Name:   K:/pcie_4g_gbe/test_ts_proc.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: csa_ts_proc
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_ts_proc;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] ts_din;
	reg ts_din_en;
	reg [7:0] cw_con_din;
	reg cw_con_din_en;
	reg [7:0] pid_con_din;
	reg pid_con_din_en;

	// Outputs
	wire ts1_dout_en;
	wire ts2_dout_en;
	wire ts3_dout_en;
	wire ts4_dout_en;
	wire ts5_dout_en;
	wire ts6_dout_en;
	wire ts7_dout_en;
	wire ts8_dout_en;
	wire ts9_dout_en;
	wire ts10_dout_en;
	wire ts11_dout_en;
	wire ts12_dout_en;
	wire ts13_dout_en;
	wire ts14_dout_en;
	wire ts15_dout_en;
	wire ts16_dout_en;
	wire ts17_dout_en;
	wire ts18_dout_en;
	wire ts19_dout_en;
	wire ts20_dout_en;
	wire ts21_dout_en;
	wire ts22_dout_en;
	wire ts23_dout_en;
	wire ts24_dout_en;
	wire ts25_dout_en;
	wire ts26_dout_en;
	wire ts27_dout_en;
	wire ts28_dout_en;
	wire ts29_dout_en;
	wire ts30_dout_en;
	wire ts31_dout_en;
	wire ts32_dout_en;
	wire [32:0] ts_dout;

	// Instantiate the Unit Under Test (UUT)
	csa_ts_proc uut (
		.clk(clk), 
		.rst(rst), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		.cw_con_din(cw_con_din), 
		.cw_con_din_en(cw_con_din_en), 
		.pid_con_din(pid_con_din), 
		.pid_con_din_en(pid_con_din_en), 
		.ts1_dout_en(ts1_dout_en), 
		.ts2_dout_en(ts2_dout_en), 
		.ts3_dout_en(ts3_dout_en), 
		.ts4_dout_en(ts4_dout_en), 
		.ts5_dout_en(ts5_dout_en), 
		.ts6_dout_en(ts6_dout_en), 
		.ts7_dout_en(ts7_dout_en), 
		.ts8_dout_en(ts8_dout_en), 
		.ts9_dout_en(ts9_dout_en), 
		.ts10_dout_en(ts10_dout_en), 
		.ts11_dout_en(ts11_dout_en), 
		.ts12_dout_en(ts12_dout_en), 
		.ts13_dout_en(ts13_dout_en), 
		.ts14_dout_en(ts14_dout_en), 
		.ts15_dout_en(ts15_dout_en), 
		.ts16_dout_en(ts16_dout_en), 
		.ts17_dout_en(ts17_dout_en), 
		.ts18_dout_en(ts18_dout_en), 
		.ts19_dout_en(ts19_dout_en), 
		.ts20_dout_en(ts20_dout_en), 
		.ts21_dout_en(ts21_dout_en), 
		.ts22_dout_en(ts22_dout_en), 
		.ts23_dout_en(ts23_dout_en), 
		.ts24_dout_en(ts24_dout_en), 
		.ts25_dout_en(ts25_dout_en), 
		.ts26_dout_en(ts26_dout_en), 
		.ts27_dout_en(ts27_dout_en), 
		.ts28_dout_en(ts28_dout_en), 
		.ts29_dout_en(ts29_dout_en), 
		.ts30_dout_en(ts30_dout_en), 
		.ts31_dout_en(ts31_dout_en), 
		.ts32_dout_en(ts32_dout_en), 
		.ts_dout(ts_dout)
	);
integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		ts_din = 0;
		ts_din_en = 0;
		cw_con_din = 0;
		cw_con_din_en = 0;
		pid_con_din = 0;
		pid_con_din_en = 0;

		#3 rst=1;
		#4 rst=0;
		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
		// Add stimulus here

		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000002;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
        
        		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
        
        		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
        
        		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
        
        		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
        		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
        		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
        		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
        		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
        		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
        
        		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        		// Wait 100 ns for global reset to finish
		#100;
        
        ts_din_en=1;
        ts_din=32'h00000001;
        #10 ts_din=32'h00000001;
        #10 ts_din=32'hc0120812;
        #10 ts_din=32'h00004e20;
        #10 ts_din=32'h47401000;
        for(i=0;i<46;i=i+1)
        #10 ts_din=i;
        #10 ts_din_en=0;
        
        
        
	end
      always #5 clk=~clk;
endmodule

