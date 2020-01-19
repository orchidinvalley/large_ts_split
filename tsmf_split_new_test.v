`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:47:13 09/19/2019
// Design Name:   tsmf_split_new
// Module Name:   E:/FPGA_pro/pcie_4gbe/tsmf_split_new_test.v
// Project Name:  pcie_4g_gbe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: tsmf_split_new
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tsmf_split_new_test;

	// Inputs
	reg clk_ts;
	reg rst_ts;
	reg [31:0] ts_din;
	reg ts_din_en;
	reg [7:0] freq_con_din;
	reg freq_con_din_en;
	reg [7:0] channel_din;
	reg channel_din_en;
	reg clk_pcie;
	reg	ram_full_1;
	reg	ram_full_2;
	wire	ts_ram_wr;
	wire	[31:0]ts_ram_wdata;

	// Instantiate the Unit Under Test (UUT)
	tsmf_split_new uut (
		.clk_ts(clk_ts), 
		.rst_ts(rst_ts), 
		.ts_din(ts_din), 
		.ts_din_en(ts_din_en), 
		.freq_con_din(freq_con_din), 
		.freq_con_din_en(freq_con_din_en), 
		.channel_din(channel_din), 
		.channel_din_en(channel_din_en), 
		.clk_pcie(clk_pcie),
		.ram_full_1(ram_full_1), 
    .ram_full_2(ram_full_2), 
    .ts_ram_wr(ts_ram_wr), 
    .ts_ram_wdata(ts_ram_wdata)
	);

reg[31:0]i;

  reg[3:0]cnt=0;

	initial begin
		// Initialize Inputs
		clk_ts = 0;
		rst_ts = 0;
		ts_din = 0;
		ts_din_en = 0;
		freq_con_din = 0;
		freq_con_din_en = 0;
		channel_din = 0;
		channel_din_en = 0;
		clk_pcie = 0;
		
		ram_full_1=0;
		ram_full_2=0;
		
		#2 rst_ts=1;
		// Wait 100 ns for global reset to finish
		#100;
		
		#10 rst_ts=0;
    
    
    #10 freq_con_din_en=1;
		freq_con_din=00;
		#10 freq_con_din=00;
		#10 freq_con_din=1;
		#10 freq_con_din=0;
		#10 freq_con_din=8;
		#10 freq_con_din=1;
		#10 freq_con_din=0;
		#10 freq_con_din=1;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=1;
		#10 freq_con_din=0;
		#10 freq_con_din=3;
		#10 freq_con_din_en=0;
		
		#200;
		
		
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
			#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
			#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
    
    
    
    #500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		
		
		#10 freq_con_din_en=1;
		freq_con_din=00;
		#10 freq_con_din=00;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=1;
		#10 freq_con_din=0;
		#10 freq_con_din=1;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=1;
		#10 freq_con_din=0;
		#10 freq_con_din=4;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din=0;
		#10 freq_con_din_en=0;
		
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		
		ts_send();
			#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
			#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
		ts_send();
		cnt=cnt+1;
		#500;
		
        
		// Add stimulus here

	end
	
	always # 5 clk_ts=!clk_ts;
	always # 3	clk_pcie	=~clk_pcie;
  
  task ts_send;
  begin
  
  #10 ts_din_en=1;
  ts_din=2;
  #10 ts_din={28'h4710010,cnt};
  
  for(i=1;i<47;i=i+1)
  #10 ts_din=i;
 	#10 ts_din_en=0;
 	ts_din=0;
 	
 	#100;
 	
 	
  	
  end
	endtask     
     
      
endmodule

