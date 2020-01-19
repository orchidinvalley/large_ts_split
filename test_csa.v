`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:48:00 02/12/2015
// Design Name:   csa_top
// Module Name:   K:/pcie_4g_gbe/test_csa.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: csa_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_csa;

	// Inputs
	reg clk_main;
	reg rst;
	reg [31:0] ts_din;
	reg ts_din_en;
	reg [7:0] con_din;
	reg con_din_en;

	// Outputs
	wire [32:0] ts_dout;
	wire ts_dout_en;
	wire [35:0] ecm_addr_dout;
	wire ecm_addr_dout_en;
	wire [7:0] ecm_ddr_dout;
	wire ecm_ddr_dout_en;
	wire [8:0] emm_dout;
	wire emm_dout_en;
	wire [8:0] emm_send;
	wire emm_send_en;
	wire erro_flag;

	// Instantiate the Unit Under Test (UUT)
	csa_top uut (
		.clk_main(clk_main), 
		.rst(rst), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		.con_din(con_din), 
		.con_din_en(con_din_en), 
		.ts_dout(ts_dout), 
		.ts_dout_en(ts_dout_en), 
		.ecm_addr_dout(ecm_addr_dout), 
		.ecm_addr_dout_en(ecm_addr_dout_en), 
		.ecm_ddr_dout(ecm_ddr_dout), 
		.ecm_ddr_dout_en(ecm_ddr_dout_en), 
		.emm_dout(emm_dout), 
		.emm_dout_en(emm_dout_en), 
		.emm_send(emm_send), 
		.emm_send_en(emm_send_en), 
		.erro_flag(erro_flag)
	);

integer i,j;
reg [7:0]tmp1,tmp2,tmp3,tmp4;
	initial begin
		// Initialize Inputs
		clk_main = 0;
		rst = 0;
		ts_din = 0;
		ts_din_en = 0;
		con_din = 0;
		con_din_en = 0;

		#3 rst=1;
		#4 rst=0;
		// Wait 100 ns for global reset to finish
		#100;
		for(i=1;i<100;i=i+1)
		begin
	 	#10 ts_din_en=1;
	 	tmp1=i;
	 	ts_din={24'b0,tmp1};
	 	#10 ts_din=32'h00000_0002;
	 	#10 ts_din=32'h0c012_0802;
	 	#10 ts_din=32'h00000_4e20;
	 	#10 ts_din={24'h0474001,4'b0,tmp1[3:0]};
	 	for(j=1;j<185;j=j+4)
	 	begin
	 		tmp1=j;
	 		tmp2=j+1;
	 		tmp3=j+2;
	 		tmp4=j+3;
	 	#10 ts_din={tmp1,tmp2,tmp3,tmp4};
	 	end
	 	#10 ts_din_en=0;
	 	
	 	#60;
	 	
      end
        
		// Add stimulus here

	end
      always #5 clk_main=~clk_main;
endmodule

