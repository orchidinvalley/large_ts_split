`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:18:15 02/10/2015
// Design Name:   mux_ip_rej
// Module Name:   K:/pcie_4g_gbe/test_ip_rej.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mux_ip_rej
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_ip_rej;

	// Inputs
	reg clk;
	reg rst;
	reg [32:0] ts_din;
	reg ts_din_en;
	reg [7:0] con_din;
	reg con_din_en;

	// Outputs
	wire [32:0] ts_dout;
	wire ts_dout_en;

	// Instantiate the Unit Under Test (UUT)
	mux_ip_rej uut (
		.clk(clk), 
		.rst(rst), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		.con_din(con_din), 
		.con_din_en(con_din_en), 
		.ts_dout(ts_dout), 
		.ts_dout_en(ts_dout_en)
	);
integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		ts_din = 0;
		ts_din_en = 0;
		con_din = 0;
		con_din_en = 0;

		#3 rst=1;
		#4 rst=0;
		
		#20 con_din_en=1;
		con_din	=0;
		#10  con_din=01;
		#10  con_din=0;
		#10  con_din=01;

		#10  con_din=0;
		#10  con_din=01;
		
		#10  con_din=0;	
		#10  con_din=0;
		#10  con_din=0;
		#10  con_din=0;
		#10  con_din=8'hc0;
		#10  con_din=8'h12;
		#10  con_din=8'h08;
		#10  con_din=8'h08;
		#10  con_din=8'h4e;
		#10  con_din=8'h20;
		#10  con_din=8'h00;
		#10  con_din=8'h00;
		#10  con_din=8'h00;
		#10  con_din=8'h00;
		#10  con_din=8'h08;
		#10 con_din_en=0;
		
		
		
		// Wait 100 ns for global reset to finish
		#100;
        
       #10 ts_din_en=1;
       ts_din=33'h100000000;
       #10 ts_din=33'h0c0120808;
       #10 ts_din=33'h000004e20;
       #10 ts_din=33'h047403000;
       for(i=0;i<46;i=i+1)
       #10 ts_din=i;
       #10 ts_din_en=0;
       
       	#100;
        
       #10 ts_din_en=1;
       ts_din=33'h100000000;
       #10 ts_din=33'h0c0120808;
       #10 ts_din=33'h000004e20;
       #10 ts_din=33'h047403001;
       for(i=0;i<46;i=i+1)
       #10 ts_din=i;
       #10 ts_din_en=0;
		// Add stimulus here

	end
      
      
      always # 5 clk=~clk;
endmodule

