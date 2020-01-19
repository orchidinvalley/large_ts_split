`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:38:33 02/11/2015
// Design Name:   csa_pretreatment
// Module Name:   K:/pcie_4g_gbe/test_csa_pre.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: csa_pretreatment
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_csa_pre;

	// Inputs
	reg clk_main;
	reg rst;
	reg [32:0] ts_din;
	reg ts_din_en;
	reg finish_blk_enc;

	// Outputs
	wire en_count_packet;
	wire [7:0] count_packet;
	wire [7:0] ts_dout;
	wire en_ts_dout;
	wire [7:0] pid_num;
	wire en_pid_num;
	wire [7:0] gbe_num;
	wire en_gbe_num;
	wire [7:0] ip_port;
	wire en_ip_port;
	wire [7:0] cw_data;
	wire en_cw_data;

	// Instantiate the Unit Under Test (UUT)
	csa_pretreatment uut (
		.clk_main(clk_main), 
		.rst(rst), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		.finish_blk_enc(finish_blk_enc), 
		.en_count_packet(en_count_packet), 
		.count_packet(count_packet), 
		.ts_dout(ts_dout), 
		.en_ts_dout(en_ts_dout), 
		.pid_num(pid_num), 
		.en_pid_num(en_pid_num), 
		.gbe_num(gbe_num), 
		.en_gbe_num(en_gbe_num), 
		.ip_port(ip_port), 
		.en_ip_port(en_ip_port), 
		.cw_data(cw_data), 
		.en_cw_data(en_cw_data)
	);
integer i;
reg [7:0]tmp1,tmp2,tmp3,tmp4;
	initial begin
		// Initialize Inputs
		clk_main = 0;
		rst = 0;
		ts_din = 0;
		ts_din_en = 0;
		finish_blk_enc = 0;


		#3 rst=1;
		#4 rst=0;
		// Wait 100 ns for global reset to finish
		#100;
        
        # 10 ts_din_en=1;
        ts_din=33'h10000_0001;
        #10 ts_din=33'h00000_0007;
        #10 ts_din=33'h01234_5678;
        #10 ts_din=33'h09abc_def0;
        #10 ts_din=33'h00000_0010;
        #10 ts_din=33'h00000_0001;
        #10 ts_din=33'h0c012_0801;
        #10 ts_din=33'h00000_4e20;
       	#10 ts_din=33'h04740_0100;
       	for(i=1;i<185;i=i+4)
       	begin
       	tmp1		=i;
       	tmp2	=i+1;
       	tmp3	=i+2;
       	tmp4	=i+3;
       	#10 ts_din={tmp1,tmp2,tmp3,tmp4};
       	end
       	#10 ts_din_en=0;
		// Add stimulus here

	end
      always #5 clk_main=~clk_main;
endmodule

