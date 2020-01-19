`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:24:64 05/08/2009 
// Design Name: 
// Module Name:    ts_combo 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module csa_ts_combo(

		clk,
        rst,
        
        csa1_din,//1���(8�ֽ�)+2pid��ţ�8�ֽڣ�+1gbe+4ip+2port��8�ֽڣ�+188/8  3+24=27
        csa1_din_en,
        csa2_din,
        csa2_din_en,
        csa3_din,
        csa3_din_en,
        csa4_din,
        csa4_din_en,
        csa5_din,
        csa5_din_en,
        csa6_din,
        csa6_din_en,
        csa7_din,
        csa7_din_en,
        csa8_din,
        csa8_din_en,
        csa9_din,
        csa9_din_en, 
        csa10_din,
        csa10_din_en,
        csa11_din,
        csa11_din_en,
        csa12_din,
        csa12_din_en,
        csa13_din,
        csa13_din_en,
        csa14_din,
        csa14_din_en,
        csa15_din,
        csa15_din_en, 
        csa16_din,
        csa16_din_en,
        csa17_din,
        csa17_din_en,
        csa18_din,
        csa18_din_en,
        csa19_din,
        csa19_din_en, 
        csa20_din,
        csa20_din_en,
        csa21_din,//1���(4�ֽ�)+2pid��ţ�4�ֽڣ�+1gbe��4�ֽڣ�+4ip��4�ֽڣ�+2port��4�ֽڣ�+188=208   /4=52
        csa21_din_en,
        csa22_din,
        csa22_din_en,
        csa23_din,
        csa23_din_en,
        csa24_din,
        csa24_din_en,
        csa25_din,
        csa25_din_en,
        csa26_din,
        csa26_din_en,
        csa27_din,
        csa27_din_en,
        csa28_din,
        csa28_din_en,
        csa29_din,
        csa29_din_en, 
        csa30_din,
        csa30_din_en,
        csa31_din,//1���(4�ֽ�)+2pid��ţ�4�ֽڣ�+1gbe��4�ֽڣ�+4ip��4�ֽڣ�+2port��4�ֽڣ�+188=208   /4=52
        csa31_din_en,
        csa32_din,
        csa32_din_en,
//        csa33_din,
//        csa33_din_en,   
//        csa34_din,   
//		csa34_din_en,
//		csa35_din,   
//		csa35_din_en,
//		csa36_din,   
//		csa36_din_en,
//		csa37_din,   
//		csa37_din_en,
//		csa38_din,   
//		csa38_din_en,
//		csa39_din,   
//		csa39_din_en,
//		csa40_din,   
//		csa40_din_en,
//		csa41_din,
//		csa41_din_en,
//		csa42_din,   
//		csa42_din_en,
//		csa43_din,   
//		csa43_din_en,
//		csa44_din,   
//		csa44_din_en,
//		csa45_din,   
//		csa45_din_en,
//		csa46_din,   
//		csa46_din_en,
//		csa47_din,   
//		csa47_din_en,
//		csa48_din,   
//		csa48_din_en,
//		csa49_din,   
//		csa49_din_en,
//		csa50_din,   
//		csa50_din_en,
//		csa51_din,
//		csa51_din_en,
//		csa52_din,   
//		csa52_din_en,
//		csa53_din,   
//		csa53_din_en,
//		csa54_din,   
//		csa54_din_en,
		

        
       // csa_combo_ram_full,       
        csa_dout,
        csa_dout_en                 
        );
        
	input			clk, rst; 
	input	[32:0]	csa1_din;
	input			csa1_din_en;
	input	[32:0]	csa2_din;
	input			csa2_din_en;
	input	[32:0]	csa3_din;
	input			csa3_din_en;
	input	[32:0]	csa4_din;
	input			csa4_din_en;
	input	[32:0]	csa5_din;
	input			csa5_din_en;
	input	[32:0]	csa6_din;
	input			csa6_din_en;
	input	[32:0]	csa7_din;
	input			csa7_din_en;
	input	[32:0]	csa8_din;
	input			csa8_din_en;
	input	[32:0]	csa9_din;
	input			csa9_din_en;
	input	[32:0]	csa10_din;
	input			csa10_din_en;
	input	[32:0]	csa11_din;
	input			csa11_din_en;
	input	[32:0]	csa12_din;
	input			csa12_din_en;
	input	[32:0]	csa13_din;
	input			csa13_din_en;
	input	[32:0]	csa14_din;
	input			csa14_din_en;
	input	[32:0]	csa15_din;
	input			csa15_din_en;
	input	[32:0]	csa16_din;
	input			csa16_din_en;
	input	[32:0]	csa17_din;
	input			csa17_din_en;
	input	[32:0]	csa18_din;
	input			csa18_din_en;
	input	[32:0]	csa19_din;
	input			csa19_din_en;	
	input	[32:0]	csa20_din;
	input			csa20_din_en;
	input	[32:0]	csa21_din;
	input			csa21_din_en;
	input	[32:0]	csa22_din;
	input			csa22_din_en;
	input	[32:0]	csa23_din;
	input			csa23_din_en;
	input	[32:0]	csa24_din;
	input			csa24_din_en;
	input	[32:0]	csa25_din;
	input			csa25_din_en;
	input	[32:0]	csa26_din;
	input			csa26_din_en;
	input	[32:0]	csa27_din;
	input			csa27_din_en;
	input	[32:0]	csa28_din;
	input			csa28_din_en;
	input	[32:0]	csa29_din;
	input			csa29_din_en;	
	input	[32:0]	csa30_din;
	input			csa30_din_en;
	input	[32:0]	csa31_din;
	input			csa31_din_en;
	input	[32:0]	csa32_din;
	input			csa32_din_en;
//	input	[64:0]	csa33_din;
//	input			csa33_din_en;
//	input	[64:0]	csa34_din;
//	input			csa34_din_en;
//	input	[64:0]	csa35_din;
//	input			csa35_din_en;
//	input	[64:0]	csa36_din;
//	input			csa36_din_en;
//	input	[64:0]	csa37_din;
//	input			csa37_din_en;
//	input	[64:0]	csa38_din;
//	input			csa38_din_en;
//	input	[64:0]	csa39_din;
//	input			csa39_din_en;	
//	input	[64:0]	csa40_din;
//	input			csa40_din_en;
//	input	[64:0]	csa41_din;
//	input			csa41_din_en;
//	input	[64:0]	csa42_din;
//	input			csa42_din_en;
//	input	[64:0]	csa43_din;
//	input			csa43_din_en;
//	input	[64:0]	csa44_din;
//	input			csa44_din_en;
//	input	[64:0]	csa45_din;
//	input			csa45_din_en;
//	input	[64:0]	csa46_din;
//	input			csa46_din_en;
//	input	[64:0]	csa47_din;
//	input			csa47_din_en;
//	input	[64:0]	csa48_din;
//	input			csa48_din_en;
//	input	[64:0]	csa49_din;
//	input			csa49_din_en;	
//	input	[64:0]	csa50_din;
//	input			csa50_din_en;
//	input	[64:0]	csa51_din;
//	input			csa51_din_en;
//	input	[64:0]	csa52_din;
//	input			csa52_din_en;
//	input	[64:0]	csa53_din;
//	input			csa53_din_en;  
//	input	[64:0]	csa54_din;   
//	input			csa54_din_en;																						
																										

	
	

	output	[32:0]	csa_dout;
	output			csa_dout_en;
		
	reg		[32:0]	csa_dout;
	reg				csa_dout_en;
	

	
	reg		[15:0]	csa1_ram_flag;
	reg		[15:0]	csa2_ram_flag;
	reg		[15:0]	csa3_ram_flag;
	reg		[15:0]	csa4_ram_flag;
	reg		[15:0]	csa5_ram_flag;
	reg		[15:0]	csa6_ram_flag;
	reg		[15:0]	csa7_ram_flag;
	reg		[15:0]	csa8_ram_flag;
	reg		[15:0]	csa9_ram_flag;	 
	reg		[15:0]	csa10_ram_flag;
	reg		[15:0]	csa11_ram_flag;
	reg		[15:0]	csa12_ram_flag;
	reg		[15:0]	csa13_ram_flag;
	reg		[15:0]	csa14_ram_flag;
	reg		[15:0]	csa15_ram_flag;
	reg		[15:0]	csa16_ram_flag;
	reg		[15:0]	csa17_ram_flag;
	reg		[15:0]	csa18_ram_flag;
	reg		[15:0]	csa19_ram_flag;	 
	reg		[15:0]	csa20_ram_flag;
	reg		[15:0]	csa21_ram_flag;
	reg		[15:0]	csa22_ram_flag;
	reg		[15:0]	csa23_ram_flag;
	reg		[15:0]	csa24_ram_flag;
	reg		[15:0]	csa25_ram_flag;
	reg		[15:0]	csa26_ram_flag;
	reg		[15:0]	csa27_ram_flag;
	reg		[15:0]	csa28_ram_flag;
	reg		[15:0]	csa29_ram_flag;	 
	reg		[15:0]	csa30_ram_flag;
	reg		[15:0]	csa31_ram_flag;
	reg		[15:0]	csa32_ram_flag;
//	reg		[15:0]	csa33_ram_flag;
//	reg		[15:0]	csa34_ram_flag;
//	reg		[15:0]	csa35_ram_flag;
//	reg		[15:0]	csa36_ram_flag;
//	reg		[15:0]	csa37_ram_flag;
//	reg		[15:0]	csa38_ram_flag;
//	reg		[15:0]	csa39_ram_flag;	 
//	reg		[15:0]	csa40_ram_flag;
//	reg		[15:0]	csa41_ram_flag;
//	reg		[15:0]	csa42_ram_flag;
//	reg		[15:0]	csa43_ram_flag;
//	reg		[15:0]	csa44_ram_flag;
//	reg		[15:0]	csa45_ram_flag;
//	reg		[15:0]	csa46_ram_flag;
//	reg		[15:0]	csa47_ram_flag;
//	reg		[15:0]	csa48_ram_flag;
//	reg		[15:0]	csa49_ram_flag;	 
//	reg		[15:0]	csa50_ram_flag;
//	reg		[15:0]	csa51_ram_flag;
//	reg		[15:0]	csa52_ram_flag;
//	reg		[15:0]	csa53_ram_flag;
//	reg		[15:0]	csa54_ram_flag;
	
	
	
	
	
	
	
	
		
	reg						csa1_ram_wr;
	reg		[31:0]	csa1_ram_din;
	reg		[9:0]		csa1_ram_addra;
	reg		[9:0]		csa1_ram_addrb;
	wire	[31:0]	csa1_ram_dout;
	reg						csa2_ram_wr;
	reg		[31:0]	csa2_ram_din;
	reg		[9:0]		csa2_ram_addra;
	reg		[9:0]		csa2_ram_addrb;
	wire	[31:0]	csa2_ram_dout;
	reg						csa3_ram_wr;
	reg		[31:0]	csa3_ram_din;
	reg		[9:0]		csa3_ram_addra;
	reg		[9:0]		csa3_ram_addrb;
	wire	[31:0]	csa3_ram_dout;
	reg						csa4_ram_wr;
	reg		[31:0]	csa4_ram_din;
	reg		[9:0]		csa4_ram_addra;
	reg		[9:0]		csa4_ram_addrb;
	wire	[31:0]	csa4_ram_dout;
	reg						csa5_ram_wr;
	reg		[31:0]	csa5_ram_din;
	reg		[9:0]		csa5_ram_addra;
	reg		[9:0]		csa5_ram_addrb;
	wire	[31:0]	csa5_ram_dout;
	
	reg						csa6_ram_wr;
	reg		[31:0]	csa6_ram_din;
	reg		[9:0]		csa6_ram_addra;
	reg		[9:0]		csa6_ram_addrb;
	wire	[31:0]	csa6_ram_dout;
	reg						csa7_ram_wr;
	reg		[31:0]	csa7_ram_din;
	reg		[9:0]		csa7_ram_addra;
	reg		[9:0]		csa7_ram_addrb;
	wire	[31:0]	csa7_ram_dout;
	reg						csa8_ram_wr;
	reg		[31:0]	csa8_ram_din;
	reg		[9:0]		csa8_ram_addra;
	reg		[9:0]		csa8_ram_addrb;
	wire	[31:0]	csa8_ram_dout;
	reg						csa9_ram_wr;
	reg		[31:0]	csa9_ram_din;
	reg		[9:0]		csa9_ram_addra;
	reg		[9:0]		csa9_ram_addrb;
	wire	[31:0]	csa9_ram_dout;
	
	reg						csa10_ram_wr;
	reg		[31:0]	csa10_ram_din; 
	reg		[9:0]		csa10_ram_addra;
	reg		[9:0]		csa10_ram_addrb;
	wire	[31:0]	csa10_ram_dout;
	
	reg							csa11_ram_wr;
	reg		[31:0]		csa11_ram_din; 
	reg		[9:0]			csa11_ram_addra;
	reg		[9:0]			csa11_ram_addrb;
	wire	[31:0]		csa11_ram_dout;
	
	reg							csa12_ram_wr;
	reg		[31:0]		csa12_ram_din; 
	reg		[9:0]			csa12_ram_addra;
	reg		[9:0]			csa12_ram_addrb;
	wire	[31:0]		csa12_ram_dout;
	
	reg							csa13_ram_wr;
	reg		[31:0]		csa13_ram_din; 
	reg		[9:0]			csa13_ram_addra;
	reg		[9:0]			csa13_ram_addrb;
	wire	[31:0]		csa13_ram_dout;
	
	reg							csa14_ram_wr;
	reg		[31:0]			csa14_ram_din; 
	reg		[9:0]			csa14_ram_addra;
	reg		[9:0]			csa14_ram_addrb;
	wire	[31:0]		csa14_ram_dout;
	
	reg							csa15_ram_wr;
	reg		[31:0]			csa15_ram_din; 
	reg		[9:0]			csa15_ram_addra;
	reg		[9:0]			csa15_ram_addrb;
	wire	[31:0]		csa15_ram_dout;
	
	
	reg						csa16_ram_wr;
	reg		[31:0]	csa16_ram_din;
	reg		[9:0]		csa16_ram_addra;
	reg		[9:0]		csa16_ram_addrb;
	wire	[31:0]	csa16_ram_dout;
	reg						csa17_ram_wr;
	reg		[31:0]	csa17_ram_din;
	reg		[9:0]		csa17_ram_addra;
	reg		[9:0]		csa17_ram_addrb;
	wire	[31:0]	csa17_ram_dout;
	reg						csa18_ram_wr;
	reg		[31:0]	csa18_ram_din;
	reg		[9:0]		csa18_ram_addra;
	reg		[9:0]		csa18_ram_addrb;
	wire	[31:0]	csa18_ram_dout;
	reg						csa19_ram_wr;
	reg		[31:0]	csa19_ram_din;
	reg		[9:0]		csa19_ram_addra;
	reg		[9:0]		csa19_ram_addrb;
	wire	[31:0]	csa19_ram_dout;
	
	reg							csa20_ram_wr;
	reg		[31:0]		csa20_ram_din; 
	reg		[9:0]			csa20_ram_addra;
	reg		[9:0]			csa20_ram_addrb;
	wire	[31:0]		csa20_ram_dout;
	                   
	reg							csa21_ram_wr;
	reg		[31:0]		csa21_ram_din; 
	reg		[9:0]			csa21_ram_addra;
	reg		[9:0]			csa21_ram_addrb;
	wire	[31:0]		csa21_ram_dout;
	                  
	reg							csa22_ram_wr;
	reg		[31:0]		csa22_ram_din; 
	reg		[9:0]			csa22_ram_addra;
	reg		[9:0]			csa22_ram_addrb;
	wire	[31:0]		csa22_ram_dout;
	                   
	reg							csa23_ram_wr;
	reg		[31:0]		csa23_ram_din; 
	reg		[9:0]			csa23_ram_addra;
	reg		[9:0]			csa23_ram_addrb;
	wire	[31:0]		csa23_ram_dout;
	                  
	reg							csa24_ram_wr;
	reg		[31:0]			csa24_ram_din; 
	reg		[9:0]			csa24_ram_addra;
	reg		[9:0]			csa24_ram_addrb;
	wire	[31:0]		csa24_ram_dout;
	                  
	reg							csa25_ram_wr;
	reg		[31:0]			csa25_ram_din; 
	reg		[9:0]			csa25_ram_addra;
	reg		[9:0]			csa25_ram_addrb;
	wire	[31:0]		csa25_ram_dout;
	
	reg						csa26_ram_wr;
	reg		[31:0]	csa26_ram_din;
	reg		[9:0]		csa26_ram_addra;
	reg		[9:0]		csa26_ram_addrb;
	wire	[31:0]	csa26_ram_dout;
	reg						csa27_ram_wr;
	reg		[31:0]	csa27_ram_din;
	reg		[9:0]		csa27_ram_addra;
	reg		[9:0]		csa27_ram_addrb;
	wire	[31:0]	csa27_ram_dout;
	reg						csa28_ram_wr;
	reg		[31:0]	csa28_ram_din;
	reg		[9:0]		csa28_ram_addra;
	reg		[9:0]		csa28_ram_addrb;
	wire	[31:0]	csa28_ram_dout;
	reg						csa29_ram_wr;
	reg		[31:0]	csa29_ram_din;
	reg		[9:0]		csa29_ram_addra;
	reg		[9:0]		csa29_ram_addrb;
	wire	[31:0]	csa29_ram_dout;
	
	reg							csa30_ram_wr;
	reg		[31:0]		csa30_ram_din; 
	reg		[9:0]			csa30_ram_addra;
	reg		[9:0]			csa30_ram_addrb;
	wire	[31:0]		csa30_ram_dout;
	                   
	reg							csa31_ram_wr;
	reg		[31:0]		csa31_ram_din; 
	reg		[9:0]			csa31_ram_addra;
	reg		[9:0]			csa31_ram_addrb;
	wire	[31:0]		csa31_ram_dout;
	                  
	reg							csa32_ram_wr;
	reg		[31:0]		csa32_ram_din; 
	reg		[9:0]			csa32_ram_addra;
	reg		[9:0]			csa32_ram_addrb;
	wire	[31:0]		csa32_ram_dout;
	                   
//	reg							csa33_ram_wr;
//	reg		[31:0]		csa33_ram_din; 
//	reg		[8:0]			csa33_ram_addra;
//	reg		[8:0]			csa33_ram_addrb;
//	wire	[31:0]		csa33_ram_dout;
//	
//	reg							csa34_ram_wr;
//	reg		[31:0]			csa34_ram_din; 
//	reg		[8:0]			csa34_ram_addra;
//	reg		[8:0]			csa34_ram_addrb;
//	wire	[31:0]		csa34_ram_dout;
//	                  
//	reg							csa35_ram_wr;
//	reg		[31:0]			csa35_ram_din; 
//	reg		[8:0]			csa35_ram_addra;
//	reg		[8:0]			csa35_ram_addrb;
//	wire	[31:0]		csa35_ram_dout;
//	
//	reg						csa36_ram_wr;
//	reg		[31:0]	csa36_ram_din;
//	reg		[8:0]		csa36_ram_addra;
//	reg		[8:0]		csa36_ram_addrb;
//	wire	[31:0]	csa36_ram_dout;
//	reg						csa37_ram_wr;
//	reg		[31:0]	csa37_ram_din;
//	reg		[8:0]		csa37_ram_addra;
//	reg		[8:0]		csa37_ram_addrb;
//	wire	[31:0]	csa37_ram_dout;
//	reg						csa38_ram_wr;
//	reg		[31:0]	csa38_ram_din;
//	reg		[8:0]		csa38_ram_addra;
//	reg		[8:0]		csa38_ram_addrb;
//	wire	[31:0]	csa38_ram_dout;
//	reg						csa39_ram_wr;
//	reg		[31:0]	csa39_ram_din;
//	reg		[8:0]		csa39_ram_addra;
//	reg		[8:0]		csa39_ram_addrb;
//	wire	[31:0]	csa39_ram_dout;
//	
//	
//	reg							csa40_ram_wr;
//	reg		[31:0]		csa40_ram_din; 
//	reg		[8:0]			csa40_ram_addra;
//	reg		[8:0]			csa40_ram_addrb;
//	wire	[31:0]		csa40_ram_dout;
//	                   
//	reg							csa41_ram_wr;
//	reg		[31:0]		csa41_ram_din; 
//	reg		[8:0]			csa41_ram_addra;
//	reg		[8:0]			csa41_ram_addrb;
//	wire	[31:0]		csa41_ram_dout;
//	                  
//	reg							csa42_ram_wr;
//	reg		[31:0]		csa42_ram_din; 
//	reg		[8:0]			csa42_ram_addra;
//	reg		[8:0]			csa42_ram_addrb;
//	wire	[31:0]		csa42_ram_dout;
//	                   
//	reg							csa43_ram_wr;
//	reg		[31:0]		csa43_ram_din; 
//	reg		[8:0]			csa43_ram_addra;
//	reg		[8:0]			csa43_ram_addrb;
//	wire	[31:0]		csa43_ram_dout;
//	                  
//	reg							csa44_ram_wr;
//	reg		[31:0]			csa44_ram_din; 
//	reg		[8:0]			csa44_ram_addra;
//	reg		[8:0]			csa44_ram_addrb;
//	wire	[31:0]		csa44_ram_dout;
//	                  
//	reg							csa45_ram_wr;
//	reg		[31:0]			csa45_ram_din; 
//	reg		[8:0]			csa45_ram_addra;
//	reg		[8:0]			csa45_ram_addrb;
//	wire	[31:0]		csa45_ram_dout;
//	
//	reg						csa46_ram_wr;
//	reg		[31:0]	csa46_ram_din;
//	reg		[8:0]		csa46_ram_addra;
//	reg		[8:0]		csa46_ram_addrb;
//	wire	[31:0]	csa46_ram_dout;
//	reg						csa47_ram_wr;
//	reg		[31:0]	csa47_ram_din;
//	reg		[8:0]		csa47_ram_addra;
//	reg		[8:0]		csa47_ram_addrb;
//	wire	[31:0]	csa47_ram_dout;
//	reg						csa48_ram_wr;
//	reg		[31:0]	csa48_ram_din;
//	reg		[8:0]		csa48_ram_addra;
//	reg		[8:0]		csa48_ram_addrb;
//	wire	[31:0]	csa48_ram_dout;
//	reg						csa49_ram_wr;
//	reg		[31:0]	csa49_ram_din;
//	reg		[8:0]		csa49_ram_addra;
//	reg		[8:0]		csa49_ram_addrb;
//	wire	[31:0]	csa49_ram_dout;
//	
//	reg							csa50_ram_wr;
//	reg		[31:0]		csa50_ram_din; 
//	reg		[8:0]			csa50_ram_addra;
//	reg		[8:0]			csa50_ram_addrb;
//	wire	[31:0]		csa50_ram_dout;
//	                   
//	reg							csa51_ram_wr;
//	reg		[31:0]		csa51_ram_din; 
//	reg		[8:0]			csa51_ram_addra;
//	reg		[8:0]			csa51_ram_addrb;
//	wire	[31:0]		csa51_ram_dout;
//	                  
//	reg							csa52_ram_wr;
//	reg		[31:0]		csa52_ram_din; 
//	reg		[8:0]			csa52_ram_addra;
//	reg		[8:0]			csa52_ram_addrb;
//	wire	[31:0]		csa52_ram_dout;
//	                   
//	reg							csa53_ram_wr;
//	reg		[31:0]		csa53_ram_din; 
//	reg		[8:0]			csa53_ram_addra;
//	reg		[8:0]			csa53_ram_addrb;
//	wire	[31:0]		csa53_ram_dout;
//	                  
//	reg							csa54_ram_wr;
//	reg		[31:0]			csa54_ram_din; 
//	reg		[8:0]			csa54_ram_addra;
//	reg		[8:0]			csa54_ram_addrb;
//	wire	[31:0]		csa54_ram_dout;
	                  


	
	reg		[6:0]	send_state;
	reg		[6:0]	rd_cnt;	
	reg		[3:0]	counter, counter_next, counter_prev;
	reg		[31:0]	csa_ram_dout_r;
	
	parameter	IDLE		= 0,
				CSA1_WAIT	= 1,
				CSA1_RD 	= 2,
				CSA2_WAIT	= 3,
				CSA2_RD		= 4,
				CSA3_WAIT	= 5,
				CSA3_RD		= 6,
				CSA4_WAIT	= 7,
				CSA4_RD		= 8,
				CSA5_WAIT	= 9,
				CSA5_RD		= 10,
				CSA6_WAIT	= 11,
				CSA6_RD		= 12,
				CSA7_WAIT	= 13,
				CSA7_RD		= 14,
				CSA8_WAIT	= 15,
				CSA8_RD		= 16,
				CSA9_WAIT	= 17,
				CSA9_RD		= 18,
				CSA10_WAIT	= 19,
				CSA10_RD		= 20,
				CSA11_WAIT	= 21,
				CSA11_RD		= 22,
				CSA12_WAIT	= 23,
				CSA12_RD		= 24,
				CSA13_WAIT	= 25,
				CSA13_RD		= 26,
				CSA14_WAIT	= 27,
				CSA14_RD		= 28,
				CSA15_WAIT	= 29,
				CSA15_RD		= 30,
				CSA16_WAIT	= 31,  
				CSA16_RD		= 32,  
				CSA17_WAIT	= 33,  
				CSA17_RD		= 34,  
				CSA18_WAIT	= 35,  
				CSA18_RD		= 36,  
				CSA19_WAIT	= 37,  
				CSA19_RD		= 38,  
				CSA20_WAIT	= 39,
				CSA20_RD		= 40,
				CSA21_WAIT	= 41,
				CSA21_RD		= 42,
				CSA22_WAIT	= 43,
				CSA22_RD		= 44,
				CSA23_WAIT	= 45,
				CSA23_RD		= 46,
				CSA24_WAIT	= 47,
				CSA24_RD		= 48,
				CSA25_WAIT	= 49,
				CSA25_RD		= 50,
				CSA26_WAIT	= 51,  
				CSA26_RD		= 52,  
				CSA27_WAIT	= 53,  
				CSA27_RD		= 54,  
				CSA28_WAIT	= 55,  
				CSA28_RD		= 56,  
				CSA29_WAIT	= 57,  
				CSA29_RD		= 58,  
				CSA30_WAIT	= 59,
				CSA30_RD		= 60,
				CSA31_WAIT	= 61,
				CSA31_RD		= 62,
				CSA32_WAIT	= 63,
				CSA32_RD		= 64;
//				CSA33_WAIT	= 65,
//				CSA33_RD		= 66,
//				CSA34_WAIT	= 67,
//				CSA34_RD		= 68,
//				CSA35_WAIT	= 69,
//				CSA35_RD		= 70,
//				CSA36_WAIT	= 71,  
//				CSA36_RD		= 72,  
//				CSA37_WAIT	= 73,  
//				CSA37_RD		= 74,  
//				CSA38_WAIT	= 75,  
//				CSA38_RD		= 76,  
//				CSA39_WAIT	= 77,  
//				CSA39_RD		= 78,  
//				CSA40_WAIT	= 79,
//				CSA40_RD		= 80,
//				CSA41_WAIT	= 81,
//				CSA41_RD		= 82,
//				CSA42_WAIT	= 83,
//				CSA42_RD		= 84,
//				CSA43_WAIT	= 85,
//				CSA43_RD		= 86,
//				CSA44_WAIT	= 87,
//				CSA44_RD		= 88,
//				CSA45_WAIT	= 89,
//				CSA45_RD		= 90,
//				CSA46_WAIT	= 91,  
//				CSA46_RD		= 92,  
//				CSA47_WAIT	= 93,  
//				CSA47_RD		= 94,  
//				CSA48_WAIT	= 95,  
//				CSA48_RD		= 96,  
//				CSA49_WAIT	= 97,  
//				CSA49_RD		= 98,  
//				CSA50_WAIT	= 99,
//				CSA50_RD		= 100,
//				CSA51_WAIT	= 101,
//				CSA51_RD		= 102,
//				CSA52_WAIT	= 103,
//				CSA52_RD		= 104,
//				CSA53_WAIT	= 105,
//				CSA53_RD		= 106,
//				CSA54_WAIT	= 107,    
//				CSA54_RD		= 108;
				

				

				
				
	      
	parameter   READ_COUNT = 58; 			
	      
	always @(posedge clk)
	begin 
		if(send_state == CSA1_RD  || send_state == CSA2_RD 	 || send_state == CSA3_RD   || send_state == CSA4_RD || 
		   send_state == CSA5_RD  || send_state == CSA6_RD 	 || send_state == CSA7_RD   || send_state == CSA8_RD ||
		   send_state == CSA9_RD  || send_state == CSA10_RD  || send_state == CSA11_RD  || send_state == CSA12_RD  ||
		   send_state == CSA13_RD || send_state == CSA14_RD  || send_state == CSA15_RD	|| send_state == CSA16_RD  ||
		   send_state == CSA17_RD || send_state == CSA18_RD  || send_state == CSA19_RD	|| send_state == CSA20_RD  ||
		   send_state == CSA21_RD || send_state == CSA22_RD  || send_state == CSA23_RD	|| send_state == CSA24_RD	||
		   send_state == CSA25_RD || send_state == CSA26_RD  || send_state == CSA27_RD  || send_state == CSA28_RD  || 
		   send_state == CSA29_RD || send_state == CSA30_RD  || send_state == CSA31_RD  || send_state == CSA32_RD  //|| 
//		   send_state == CSA33_RD || send_state == CSA34_RD  || send_state == CSA35_RD	|| send_state == CSA36_RD  ||
//		   send_state == CSA37_RD || send_state == CSA38_RD  || send_state == CSA39_RD	|| send_state == CSA40_RD  ||
//		   send_state == CSA41_RD || send_state == CSA42_RD  || send_state == CSA43_RD	|| send_state == CSA44_RD	||
//		   send_state == CSA45_RD || send_state == CSA46_RD  || send_state == CSA47_RD  || send_state == CSA48_RD  || 
//		   send_state == CSA49_RD || send_state == CSA50_RD  || send_state == CSA51_RD  || send_state == CSA52_RD  || 
//		   send_state == CSA53_RD || send_state == CSA54_RD	 
)
		begin
			rd_cnt	<= rd_cnt + 6'b1;
		end 
		else
		begin
			rd_cnt	<= 0;
		end 
	end   
	      
	always @(posedge clk)
	begin
		if(rst)
		begin
			counter	<= 0;		
		end	
		//else if ((send_state==CSA54_RD) && (rd_cnt==READ_COUNT))  
		else if ((send_state==CSA32_RD) && (rd_cnt==READ_COUNT))
		begin			
			counter	<= counter + 4'b1;						
		end
	end
	
	always @ (posedge clk)
	begin		
		if (send_state==IDLE) 
			begin				
				counter_next <= counter + 4'b1; 				
			end 
		else 
			begin
				counter_next <= counter_next; 
			end 
	end 	
	
	always @ (posedge clk)
	begin
	//		if ((send_state==CSA54_RD) && (rd_cnt==READ_COUNT))     
	if ((send_state==CSA32_RD) && (rd_cnt==READ_COUNT)) 
			begin				
				counter_prev <= counter; 				
			end 
		else 
			begin
				counter_prev <= counter_prev;
			end 
	end	 
		
	always @(posedge clk)
	begin
		if(rst)
		begin
			send_state	<= IDLE;		
		end
		else
		begin
			case(send_state)
				IDLE:
					begin
						send_state	<= CSA1_WAIT;
					end
				CSA1_WAIT:
					begin
						if(csa1_ram_flag[counter_next])
						begin
							send_state	<= CSA1_RD;
						end
						else
						begin
							send_state	<= CSA1_WAIT;
						end
					end
				CSA1_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA2_WAIT;
						end
						else
						begin
							send_state	<= CSA1_RD;
						end
					end
				CSA2_WAIT:
					begin
						if(csa2_ram_flag[counter_next])
						begin
							send_state	<= CSA2_RD;
						end
						else
						begin
							send_state	<= CSA2_WAIT;
						end
					end
				CSA2_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA3_WAIT;
						end
						else
						begin
							send_state	<= CSA2_RD;
						end
					end
				CSA3_WAIT:
					begin
						if(csa3_ram_flag[counter_next])
						begin
							send_state	<= CSA3_RD;
						end
						else
						begin
							send_state	<= CSA3_WAIT;
						end
					end
				CSA3_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA4_WAIT;
						end
						else
						begin
							send_state	<= CSA3_RD;
						end
					end
				CSA4_WAIT:
					begin
						if(csa4_ram_flag[counter_next])
						begin
							send_state	<= CSA4_RD;
						end
						else
						begin
							send_state	<= CSA4_WAIT;
						end
					end
				CSA4_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA5_WAIT;
						end
						else
						begin
							send_state	<= CSA4_RD;
						end
					end
				CSA5_WAIT:
					begin
						if(csa5_ram_flag[counter_next])
						begin
							send_state	<= CSA5_RD;
						end
						else
						begin
							send_state	<= CSA5_WAIT;
						end
					end
				CSA5_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
						    send_state	<= CSA6_WAIT;
						//send_state	<= IDLE;
						end
						else
						begin
							send_state	<= CSA5_RD;
						end
					end
				CSA6_WAIT:
					begin
						if(csa6_ram_flag[counter_next])
						begin
							send_state	<= CSA6_RD;
						end
						else
						begin
							send_state	<= CSA6_WAIT;
						end
					end
				CSA6_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA7_WAIT;
						end
						else
						begin
							send_state	<= CSA6_RD;
						end
					end
				CSA7_WAIT:
					begin
						if(csa7_ram_flag[counter_next])
						begin
							send_state	<= CSA7_RD;
						end
						else
						begin
							send_state	<= CSA7_WAIT;
						end
					end
				CSA7_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA8_WAIT;
						end
						else
						begin
							send_state	<= CSA7_RD;
						end
					end
				CSA8_WAIT:
					begin
						if(csa8_ram_flag[counter_next])
						begin
							send_state	<= CSA8_RD;
						end
						else
						begin
							send_state	<= CSA8_WAIT;
						end
					end
				CSA8_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA9_WAIT;
						end
						else
						begin
							send_state	<= CSA8_RD;
						end
					end
				CSA9_WAIT:
					begin
						if(csa9_ram_flag[counter_next])
						begin
							send_state	<= CSA9_RD;
						end
						else
						begin
							send_state	<= CSA9_WAIT;
						end
					end
				CSA9_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA10_WAIT;
						end
						else
						begin
							send_state	<= CSA9_RD;
						end
					end
					CSA10_WAIT:
					begin
						if(csa10_ram_flag[counter_next])
						begin
							send_state	<= CSA10_RD;
						end
						else
						begin
							send_state	<= CSA10_WAIT;
						end
					end
				CSA10_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA11_WAIT;
						end
						else
						begin
							send_state	<= CSA10_RD;
						end
					end
					CSA11_WAIT:
					begin
						if(csa11_ram_flag[counter_next])
						begin
							send_state	<= CSA11_RD;
						end
						else
						begin
							send_state	<= CSA11_WAIT;
						end
					end
				CSA11_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA12_WAIT;
						end
						else
						begin
							send_state	<= CSA11_RD;
						end
					end
					CSA12_WAIT:
					begin
						if(csa12_ram_flag[counter_next])
						begin
							send_state	<= CSA12_RD;
						end
						else
						begin
							send_state	<= CSA12_WAIT;
						end
					end
				CSA12_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA13_WAIT;
						end
						else
						begin
							send_state	<= CSA12_RD;
						end
					end
					CSA13_WAIT:
					begin
						if(csa13_ram_flag[counter_next])
						begin
							send_state	<= CSA13_RD;
						end
						else
						begin
							send_state	<= CSA13_WAIT;
						end
					end
				CSA13_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA14_WAIT;
						end
						else
						begin
							send_state	<= CSA13_RD;
						end
					end
					CSA14_WAIT:
					begin
						if(csa14_ram_flag[counter_next])
						begin
							send_state	<= CSA14_RD;
						end
						else
						begin
							send_state	<= CSA14_WAIT;
						end
					end
				CSA14_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA15_WAIT;
						end
						else
						begin
							send_state	<= CSA14_RD;
						end
					end
				CSA15_WAIT:
					begin
						if(csa15_ram_flag[counter_next])
						begin
							send_state	<= CSA15_RD;
						end
						else
						begin
							send_state	<= CSA15_WAIT;
						end
					end
				CSA15_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA16_WAIT;
						end
						else
						begin
							send_state	<= CSA15_RD;
						end
					end
				CSA16_WAIT:
					begin
						if(csa16_ram_flag[counter_next])
						begin
							send_state	<= CSA16_RD;
						end
						else
						begin
							send_state	<= CSA16_WAIT;
						end
					end
				CSA16_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA17_WAIT;
						end
						else
						begin
							send_state	<= CSA16_RD;
						end
					end
					CSA17_WAIT:
					begin
						if(csa17_ram_flag[counter_next])
						begin
							send_state	<= CSA17_RD;
						end
						else
						begin
							send_state	<= CSA17_WAIT;
						end
					end
				CSA17_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA18_WAIT;
						end
						else
						begin
							send_state	<= CSA17_RD;
						end
					end
					CSA18_WAIT:
					begin
						if(csa18_ram_flag[counter_next])
						begin
							send_state	<= CSA18_RD;
						end
						else
						begin
							send_state	<= CSA18_WAIT;
						end
					end
				CSA18_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA19_WAIT;
						end
						else
						begin
							send_state	<= CSA18_RD;
						end
					end
					CSA19_WAIT:
					begin
						if(csa19_ram_flag[counter_next])
						begin
							send_state	<= CSA19_RD;
						end
						else
						begin
							send_state	<= CSA19_WAIT;
						end
					end
				CSA19_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA20_WAIT;
						end
						else
						begin
							send_state	<= CSA19_RD;
						end
					end
					CSA20_WAIT:
					begin
						if(csa20_ram_flag[counter_next])
						begin
							send_state	<= CSA20_RD;
						end
						else
						begin
							send_state	<= CSA20_WAIT;
						end
					end
				CSA20_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA21_WAIT;
						end
						else
						begin
							send_state	<= CSA20_RD;
						end
					end
					CSA21_WAIT:
					begin
						if(csa21_ram_flag[counter_next])
						begin
							send_state	<= CSA21_RD;
						end
						else
						begin
							send_state	<= CSA21_WAIT;
						end
					end
				CSA21_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA22_WAIT;
						end
						else
						begin
							send_state	<= CSA21_RD;
						end
					end
					CSA22_WAIT:
					begin
						if(csa22_ram_flag[counter_next])
						begin
							send_state	<= CSA22_RD;
						end
						else
						begin
							send_state	<= CSA22_WAIT;
						end
					end
				CSA22_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA23_WAIT;
						end
						else
						begin
							send_state	<= CSA22_RD;
						end
					end
					CSA23_WAIT:
					begin
						if(csa23_ram_flag[counter_next])
						begin
							send_state	<= CSA23_RD;
						end
						else
						begin
							send_state	<= CSA23_WAIT;
						end
					end
				CSA23_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA24_WAIT;
						end
						else
						begin
							send_state	<= CSA23_RD;
						end
					end
					CSA24_WAIT:
					begin
						if(csa24_ram_flag[counter_next])
						begin
							send_state	<= CSA24_RD;
						end
						else
						begin
							send_state	<= CSA24_WAIT;
						end
					end
				CSA24_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA25_WAIT;
						end
						else
						begin
							send_state	<= CSA24_RD;
						end
					end
				CSA25_WAIT:
					begin
						if(csa25_ram_flag[counter_next])
						begin
							send_state	<= CSA25_RD;
						end
						else
						begin
							send_state	<= CSA25_WAIT;
						end
					end
				CSA25_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA26_WAIT;
						end
						else
						begin
							send_state	<= CSA25_RD;
						end
					end	
					CSA26_WAIT:
					begin
						if(csa26_ram_flag[counter_next])
						begin
							send_state	<= CSA26_RD;
						end
						else
						begin
							send_state	<= CSA26_WAIT;
						end
					end
				CSA26_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA27_WAIT;
						end
						else
						begin
							send_state	<= CSA26_RD;
						end
					end
					CSA27_WAIT:
					begin
						if(csa27_ram_flag[counter_next])
						begin
							send_state	<= CSA27_RD;
						end
						else
						begin
							send_state	<= CSA27_WAIT;
						end
					end
				CSA27_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA28_WAIT;
						end
						else
						begin
							send_state	<= CSA27_RD;
						end
					end
					CSA28_WAIT:
					begin
						if(csa28_ram_flag[counter_next])
						begin
							send_state	<= CSA28_RD;
						end
						else
						begin
							send_state	<= CSA28_WAIT;
						end
					end
				CSA28_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA29_WAIT;
						end
						else
						begin
							send_state	<= CSA28_RD;
						end
					end
					CSA29_WAIT:
					begin
						if(csa29_ram_flag[counter_next])
						begin
							send_state	<= CSA29_RD;
						end
						else
						begin
							send_state	<= CSA29_WAIT;
						end
					end
				CSA29_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA30_WAIT;
						end
						else
						begin
							send_state	<= CSA29_RD;
						end
					end
					CSA30_WAIT:
					begin
						if(csa30_ram_flag[counter_next])
						begin
							send_state	<= CSA30_RD;
						end
						else
						begin
							send_state	<= CSA30_WAIT;
						end
					end
				CSA30_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA31_WAIT;
						end
						else
						begin
							send_state	<= CSA30_RD;
						end
					end
					CSA31_WAIT:
					begin
						if(csa31_ram_flag[counter_next])
						begin
							send_state	<= CSA31_RD;
						end
						else
						begin
							send_state	<= CSA31_WAIT;
						end
					end
				CSA31_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= CSA32_WAIT;
						end
						else
						begin
							send_state	<= CSA31_RD;
						end
					end
					CSA32_WAIT:
					begin
						if(csa32_ram_flag[counter_next])
						begin
							send_state	<= CSA32_RD;
						end
						else
						begin
							send_state	<= CSA32_WAIT;
						end
					end
				CSA32_RD:
					begin
						if(rd_cnt == READ_COUNT)
						begin
							send_state	<= IDLE;
						end
						else
						begin
							send_state	<= CSA32_RD;
						end
					end
//					CSA33_WAIT:
//					begin
//						if(csa33_ram_flag[counter_next])
//						begin
//							send_state	<= CSA33_RD;
//						end
//						else
//						begin
//							send_state	<= CSA33_WAIT;
//						end
//					end
//				CSA33_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA34_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA33_RD;
//						end
//					end	
//				CSA34_WAIT:
//					begin
//						if(csa34_ram_flag[counter_next])
//						begin
//							send_state	<= CSA34_RD;
//						end
//						else
//						begin
//							send_state	<= CSA34_WAIT;
//						end
//					end
//				CSA34_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA35_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA34_RD;
//						end
//					end
//				CSA35_WAIT:
//					begin
//						if(csa35_ram_flag[counter_next])
//						begin
//							send_state	<= CSA35_RD;
//						end
//						else
//						begin
//							send_state	<= CSA35_WAIT;
//						end
//					end
//				CSA35_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA36_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA35_RD;
//						end
//					end
//				CSA36_WAIT:
//					begin
//						if(csa36_ram_flag[counter_next])
//						begin
//							send_state	<= CSA36_RD;
//						end
//						else
//						begin
//							send_state	<= CSA36_WAIT;
//						end
//					end
//				CSA36_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA37_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA36_RD;
//						end
//					end
//					CSA37_WAIT:
//					begin
//						if(csa37_ram_flag[counter_next])
//						begin
//							send_state	<= CSA37_RD;
//						end
//						else
//						begin
//							send_state	<= CSA37_WAIT;
//						end
//					end
//				CSA37_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA38_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA37_RD;
//						end
//					end
//					CSA38_WAIT:
//					begin
//						if(csa38_ram_flag[counter_next])
//						begin
//							send_state	<= CSA38_RD;
//						end
//						else
//						begin
//							send_state	<= CSA38_WAIT;
//						end
//					end
//				CSA38_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA39_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA38_RD;
//						end
//					end
//					CSA39_WAIT:
//					begin
//						if(csa39_ram_flag[counter_next])
//						begin
//							send_state	<= CSA39_RD;
//						end
//						else
//						begin
//							send_state	<= CSA39_WAIT;
//						end
//					end
//				CSA39_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA40_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA39_RD;
//						end
//					end
//					
//					
//					CSA40_WAIT:
//					begin
//						if(csa40_ram_flag[counter_next])
//						begin
//							send_state	<= CSA40_RD;
//						end
//						else
//						begin
//							send_state	<= CSA40_WAIT;
//						end
//					end
//				CSA40_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA41_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA40_RD;
//						end
//					end
//					CSA41_WAIT:
//					begin
//						if(csa41_ram_flag[counter_next])
//						begin
//							send_state	<= CSA41_RD;
//						end
//						else
//						begin
//							send_state	<= CSA41_WAIT;
//						end
//					end
//				CSA41_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA42_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA41_RD;
//						end
//					end
//					CSA42_WAIT:
//					begin
//						if(csa42_ram_flag[counter_next])
//						begin
//							send_state	<= CSA42_RD;
//						end
//						else
//						begin
//							send_state	<= CSA42_WAIT;
//						end
//					end
//				CSA42_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA43_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA42_RD;
//						end
//					end
//					CSA43_WAIT:
//					begin
//						if(csa43_ram_flag[counter_next])
//						begin
//							send_state	<= CSA43_RD;
//						end
//						else
//						begin
//							send_state	<= CSA43_WAIT;
//						end
//					end
//				CSA43_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA44_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA43_RD;
//						end
//					end	
//				CSA44_WAIT:
//					begin
//						if(csa44_ram_flag[counter_next])
//						begin
//							send_state	<= CSA44_RD;
//						end
//						else
//						begin
//							send_state	<= CSA44_WAIT;
//						end
//					end
//				CSA44_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA45_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA44_RD;
//						end
//					end
//				CSA45_WAIT:
//					begin
//						if(csa45_ram_flag[counter_next])
//						begin
//							send_state	<= CSA45_RD;
//						end
//						else
//						begin
//							send_state	<= CSA45_WAIT;
//						end
//					end
//				CSA45_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA46_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA45_RD;
//						end
//					end
//				CSA46_WAIT:
//					begin
//						if(csa46_ram_flag[counter_next])
//						begin
//							send_state	<= CSA46_RD;
//						end
//						else
//						begin
//							send_state	<= CSA46_WAIT;
//						end
//					end
//				CSA46_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA47_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA46_RD;
//						end
//					end
//					CSA47_WAIT:
//					begin
//						if(csa47_ram_flag[counter_next])
//						begin
//							send_state	<= CSA47_RD;
//						end
//						else
//						begin
//							send_state	<= CSA47_WAIT;
//						end
//					end
//				CSA47_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA48_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA47_RD;
//						end
//					end
//					CSA48_WAIT:
//					begin
//						if(csa48_ram_flag[counter_next])
//						begin
//							send_state	<= CSA48_RD;
//						end
//						else
//						begin
//							send_state	<= CSA48_WAIT;
//						end
//					end
//				CSA48_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA49_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA48_RD;
//						end
//					end
//					CSA49_WAIT:
//					begin
//						if(csa49_ram_flag[counter_next])
//						begin
//							send_state	<= CSA49_RD;
//						end
//						else
//						begin
//							send_state	<= CSA49_WAIT;
//						end
//					end
//				CSA49_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA50_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA49_RD;
//						end
//					end
//					CSA50_WAIT:
//					begin
//						if(csa50_ram_flag[counter_next])
//						begin
//							send_state	<= CSA50_RD;
//						end
//						else
//						begin
//							send_state	<= CSA50_WAIT;
//						end
//					end
//				CSA50_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA51_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA50_RD;
//						end
//					end
//					CSA51_WAIT:
//					begin
//						if(csa51_ram_flag[counter_next])
//						begin
//							send_state	<= CSA51_RD;
//						end
//						else
//						begin
//							send_state	<= CSA51_WAIT;
//						end
//					end
//				CSA51_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA52_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA51_RD;
//						end
//					end
//					CSA52_WAIT:
//					begin
//						if(csa52_ram_flag[counter_next])
//						begin
//							send_state	<= CSA52_RD;
//						end
//						else
//						begin
//							send_state	<= CSA52_WAIT;
//						end
//					end
//				CSA52_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA53_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA52_RD;
//						end
//					end
//					CSA53_WAIT:
//					begin
//						if(csa53_ram_flag[counter_next])
//						begin
//							send_state	<= CSA53_RD;
//						end
//						else
//						begin
//							send_state	<= CSA53_WAIT;
//						end
//					end
//				CSA53_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= CSA54_WAIT;
//						end
//						else
//						begin
//							send_state	<= CSA53_RD;
//						end
//					end
//					CSA54_WAIT:
//					begin
//						if(csa54_ram_flag[counter_next])
//						begin
//							send_state	<= CSA54_RD;
//						end
//						else
//						begin
//							send_state	<= CSA54_WAIT;
//						end
//					end
//				CSA54_RD:
//					begin
//						if(rd_cnt == READ_COUNT)
//						begin
//							send_state	<= IDLE;
//						end
//						else
//						begin
//							send_state	<= CSA54_RD;
//						end
//					end
				
						
					
				default:
					begin
						send_state	<= IDLE;
					end
			endcase
		end
	end			
				
	always @(posedge clk)
	begin
		if(csa1_din_en)
		begin
			if(csa1_din[32] == 1'b1)
			begin
				case(csa1_din[3:0])
					4'd0:csa1_ram_flag[0]	<= 1'b1;
					4'd1:csa1_ram_flag[1]	<= 1'b1;					
					4'd2:csa1_ram_flag[2]	<= 1'b1;
					4'd3:csa1_ram_flag[3]	<= 1'b1;
					4'd4:csa1_ram_flag[4]	<= 1'b1;
					4'd5:csa1_ram_flag[5]	<= 1'b1;
					4'd6:csa1_ram_flag[6]	<= 1'b1;
					4'd7:csa1_ram_flag[7]	<= 1'b1;
					4'd8:csa1_ram_flag[8]	<= 1'b1;
					4'd9:csa1_ram_flag[9]	<= 1'b1;
					4'd10:csa1_ram_flag[10]	<= 1'b1;
					4'd11:csa1_ram_flag[11]	<= 1'b1;
					4'd12:csa1_ram_flag[12]	<= 1'b1;
					4'd13:csa1_ram_flag[13]	<= 1'b1;
					4'd14:csa1_ram_flag[14]	<= 1'b1;
					4'd15:csa1_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa1_ram_flag	<= csa1_ram_flag;
			end
		end
		else if(send_state == CSA1_RD)
		begin
			csa1_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa1_ram_flag	<= csa1_ram_flag;
		end
	end
	
	
	
	always @(posedge clk)
	begin
		if(csa2_din_en)
		begin
			if(csa2_din[32] == 1'b1)
			begin
				case(csa2_din[3:0])
					4'd0:csa2_ram_flag[0]	<= 1'b1;
					4'd1:csa2_ram_flag[1]	<= 1'b1;					
					4'd2:csa2_ram_flag[2]	<= 1'b1;
					4'd3:csa2_ram_flag[3]	<= 1'b1;
					4'd4:csa2_ram_flag[4]	<= 1'b1;
					4'd5:csa2_ram_flag[5]	<= 1'b1;
					4'd6:csa2_ram_flag[6]	<= 1'b1;
					4'd7:csa2_ram_flag[7]	<= 1'b1;
					4'd8:csa2_ram_flag[8]	<= 1'b1;
					4'd9:csa2_ram_flag[9]	<= 1'b1;
					4'd10:csa2_ram_flag[10]	<= 1'b1;
					4'd11:csa2_ram_flag[11]	<= 1'b1;
					4'd12:csa2_ram_flag[12]	<= 1'b1;
					4'd13:csa2_ram_flag[13]	<= 1'b1;
					4'd14:csa2_ram_flag[14]	<= 1'b1;
					4'd15:csa2_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa2_ram_flag	<= csa2_ram_flag;
			end
		end
		else if(send_state == CSA2_RD)
		begin
			csa2_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa2_ram_flag	<= csa2_ram_flag;
		end
	end
	
	
	
	always @(posedge clk)
	begin
		if(csa3_din_en)
		begin
			if(csa3_din[32] == 1'b1)
			begin
				case(csa3_din[3:0])
					4'd0:csa3_ram_flag[0]	<= 1'b1;
					4'd1:csa3_ram_flag[1]	<= 1'b1;					
					4'd2:csa3_ram_flag[2]	<= 1'b1;
					4'd3:csa3_ram_flag[3]	<= 1'b1;
					4'd4:csa3_ram_flag[4]	<= 1'b1;
					4'd5:csa3_ram_flag[5]	<= 1'b1;
					4'd6:csa3_ram_flag[6]	<= 1'b1;
					4'd7:csa3_ram_flag[7]	<= 1'b1;
					4'd8:csa3_ram_flag[8]	<= 1'b1;
					4'd9:csa3_ram_flag[9]	<= 1'b1;
					4'd10:csa3_ram_flag[10]	<= 1'b1;
					4'd11:csa3_ram_flag[11]	<= 1'b1;
					4'd12:csa3_ram_flag[12]	<= 1'b1;
					4'd13:csa3_ram_flag[13]	<= 1'b1;
					4'd14:csa3_ram_flag[14]	<= 1'b1;
					4'd15:csa3_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa3_ram_flag	<= csa3_ram_flag;
			end
		end
		else if(send_state == CSA3_RD)
		begin
			csa3_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa3_ram_flag	<= csa3_ram_flag;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(csa4_din_en)
		begin
			if(csa4_din[32] == 1'b1)
			begin
				case(csa4_din[3:0])
					4'd0:csa4_ram_flag[0]	<= 1'b1;
					4'd1:csa4_ram_flag[1]	<= 1'b1;					
					4'd2:csa4_ram_flag[2]	<= 1'b1;
					4'd3:csa4_ram_flag[3]	<= 1'b1;
					4'd4:csa4_ram_flag[4]	<= 1'b1;
					4'd5:csa4_ram_flag[5]	<= 1'b1;
					4'd6:csa4_ram_flag[6]	<= 1'b1;
					4'd7:csa4_ram_flag[7]	<= 1'b1;
					4'd8:csa4_ram_flag[8]	<= 1'b1;
					4'd9:csa4_ram_flag[9]	<= 1'b1;
					4'd10:csa4_ram_flag[10]	<= 1'b1;
					4'd11:csa4_ram_flag[11]	<= 1'b1;
					4'd12:csa4_ram_flag[12]	<= 1'b1;
					4'd13:csa4_ram_flag[13]	<= 1'b1;
					4'd14:csa4_ram_flag[14]	<= 1'b1;
					4'd15:csa4_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa4_ram_flag	<= csa4_ram_flag;
			end
		end
		else if(send_state == CSA4_RD)
		begin
			csa4_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa4_ram_flag	<= csa4_ram_flag;
		end
	end
	
	
	
	always @(posedge clk)
	begin
		if(csa5_din_en)
		begin
			if(csa5_din[32] == 1'b1)
			begin
				case(csa5_din[3:0])
					4'd0:csa5_ram_flag[0]	<= 1'b1;
					4'd1:csa5_ram_flag[1]	<= 1'b1;					
					4'd2:csa5_ram_flag[2]	<= 1'b1;
					4'd3:csa5_ram_flag[3]	<= 1'b1;
					4'd4:csa5_ram_flag[4]	<= 1'b1;
					4'd5:csa5_ram_flag[5]	<= 1'b1;
					4'd6:csa5_ram_flag[6]	<= 1'b1;
					4'd7:csa5_ram_flag[7]	<= 1'b1;
					4'd8:csa5_ram_flag[8]	<= 1'b1;
					4'd9:csa5_ram_flag[9]	<= 1'b1;
					4'd10:csa5_ram_flag[10]	<= 1'b1;
					4'd11:csa5_ram_flag[11]	<= 1'b1;
					4'd12:csa5_ram_flag[12]	<= 1'b1;
					4'd13:csa5_ram_flag[13]	<= 1'b1;
					4'd14:csa5_ram_flag[14]	<= 1'b1;
					4'd15:csa5_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa5_ram_flag	<= csa5_ram_flag;
			end
		end
		else if(send_state == CSA5_RD)
		begin
			csa5_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa5_ram_flag	<= csa5_ram_flag;
		end
	end
	
	
	
	always @(posedge clk)
	begin
		if(csa6_din_en)
		begin
			if(csa6_din[32] == 1'b1)
			begin
				case(csa6_din[3:0])
					4'd0:csa6_ram_flag[0]	<= 1'b1;
					4'd1:csa6_ram_flag[1]	<= 1'b1;					
					4'd2:csa6_ram_flag[2]	<= 1'b1;
					4'd3:csa6_ram_flag[3]	<= 1'b1;
					4'd4:csa6_ram_flag[4]	<= 1'b1;
					4'd5:csa6_ram_flag[5]	<= 1'b1;
					4'd6:csa6_ram_flag[6]	<= 1'b1;
					4'd7:csa6_ram_flag[7]	<= 1'b1;
					4'd8:csa6_ram_flag[8]	<= 1'b1;
					4'd9:csa6_ram_flag[9]	<= 1'b1;
					4'd10:csa6_ram_flag[10]	<= 1'b1;
					4'd11:csa6_ram_flag[11]	<= 1'b1;
					4'd12:csa6_ram_flag[12]	<= 1'b1;
					4'd13:csa6_ram_flag[13]	<= 1'b1;
					4'd14:csa6_ram_flag[14]	<= 1'b1;
					4'd15:csa6_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa6_ram_flag	<= csa6_ram_flag;
			end
		end
		else if(send_state == CSA6_RD)
		begin
			csa6_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa6_ram_flag	<= csa6_ram_flag;
		end
	end
	
	
	
	always @(posedge clk)
	begin
		if(csa7_din_en)
		begin
			if(csa7_din[32] == 1'b1)
			begin
				case(csa7_din[3:0])
					4'd0:csa7_ram_flag[0]	<= 1'b1;
					4'd1:csa7_ram_flag[1]	<= 1'b1;					
					4'd2:csa7_ram_flag[2]	<= 1'b1;
					4'd3:csa7_ram_flag[3]	<= 1'b1;
					4'd4:csa7_ram_flag[4]	<= 1'b1;
					4'd5:csa7_ram_flag[5]	<= 1'b1;
					4'd6:csa7_ram_flag[6]	<= 1'b1;
					4'd7:csa7_ram_flag[7]	<= 1'b1;
					4'd8:csa7_ram_flag[8]	<= 1'b1;
					4'd9:csa7_ram_flag[9]	<= 1'b1;
					4'd10:csa7_ram_flag[10]	<= 1'b1;
					4'd11:csa7_ram_flag[11]	<= 1'b1;
					4'd12:csa7_ram_flag[12]	<= 1'b1;
					4'd13:csa7_ram_flag[13]	<= 1'b1;
					4'd14:csa7_ram_flag[14]	<= 1'b1;
					4'd15:csa7_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa7_ram_flag	<= csa7_ram_flag;
			end
		end
		else if(send_state == CSA7_RD)
		begin
			csa7_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa7_ram_flag	<= csa7_ram_flag;
		end
	end
	
	
	
	always @(posedge clk)
	begin
		if(csa8_din_en)
		begin
			if(csa8_din[32] == 1'b1)
			begin
				case(csa8_din[3:0])
					4'd0:csa8_ram_flag[0]	<= 1'b1;
					4'd1:csa8_ram_flag[1]	<= 1'b1;					
					4'd2:csa8_ram_flag[2]	<= 1'b1;
					4'd3:csa8_ram_flag[3]	<= 1'b1;
					4'd4:csa8_ram_flag[4]	<= 1'b1;
					4'd5:csa8_ram_flag[5]	<= 1'b1;
					4'd6:csa8_ram_flag[6]	<= 1'b1;
					4'd7:csa8_ram_flag[7]	<= 1'b1;
					4'd8:csa8_ram_flag[8]	<= 1'b1;
					4'd9:csa8_ram_flag[9]	<= 1'b1;
					4'd10:csa8_ram_flag[10]	<= 1'b1;
					4'd11:csa8_ram_flag[11]	<= 1'b1;
					4'd12:csa8_ram_flag[12]	<= 1'b1;
					4'd13:csa8_ram_flag[13]	<= 1'b1;
					4'd14:csa8_ram_flag[14]	<= 1'b1;
					4'd15:csa8_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa8_ram_flag	<= csa8_ram_flag;
			end
		end
		else if(send_state == CSA8_RD)
		begin
			csa8_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa8_ram_flag	<= csa8_ram_flag;
		end
	end
	
	
	
	always @(posedge clk)
	begin
		if(csa9_din_en)
		begin
			if(csa9_din[32] == 1'b1)
			begin
				case(csa9_din[3:0])
					4'd0:csa9_ram_flag[0]	<= 1'b1;
					4'd1:csa9_ram_flag[1]	<= 1'b1;					
					4'd2:csa9_ram_flag[2]	<= 1'b1;
					4'd3:csa9_ram_flag[3]	<= 1'b1;
					4'd4:csa9_ram_flag[4]	<= 1'b1;
					4'd5:csa9_ram_flag[5]	<= 1'b1;
					4'd6:csa9_ram_flag[6]	<= 1'b1;
					4'd7:csa9_ram_flag[7]	<= 1'b1;
					4'd8:csa9_ram_flag[8]	<= 1'b1;
					4'd9:csa9_ram_flag[9]	<= 1'b1;
					4'd10:csa9_ram_flag[10]	<= 1'b1;
					4'd11:csa9_ram_flag[11]	<= 1'b1;
					4'd12:csa9_ram_flag[12]	<= 1'b1;
					4'd13:csa9_ram_flag[13]	<= 1'b1;
					4'd14:csa9_ram_flag[14]	<= 1'b1;
					4'd15:csa9_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa9_ram_flag	<= csa9_ram_flag;
			end
		end
		else if(send_state == CSA9_RD)
		begin
			csa9_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa9_ram_flag	<= csa9_ram_flag;
		end
	end
	
	
	
		always @(posedge clk)
	begin
		if(csa10_din_en)
		begin
			if(csa10_din[32] == 1'b1)
			begin
				case(csa10_din[3:0])
					4'd0:csa10_ram_flag[0]	<= 1'b1;
					4'd1:csa10_ram_flag[1]	<= 1'b1;					
					4'd2:csa10_ram_flag[2]	<= 1'b1;
					4'd3:csa10_ram_flag[3]	<= 1'b1;
					4'd4:csa10_ram_flag[4]	<= 1'b1;
					4'd5:csa10_ram_flag[5]	<= 1'b1;
					4'd6:csa10_ram_flag[6]	<= 1'b1;
					4'd7:csa10_ram_flag[7]	<= 1'b1;
					4'd8:csa10_ram_flag[8]	<= 1'b1;
					4'd9:csa10_ram_flag[9]	<= 1'b1;
					4'd10:csa10_ram_flag[10]	<= 1'b1;
					4'd11:csa10_ram_flag[11]	<= 1'b1;
					4'd12:csa10_ram_flag[12]	<= 1'b1;
					4'd13:csa10_ram_flag[13]	<= 1'b1;
					4'd14:csa10_ram_flag[14]	<= 1'b1;
					4'd15:csa10_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa10_ram_flag	<= csa10_ram_flag;
			end
		end
		else if(send_state == CSA10_RD)
		begin
			csa10_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa10_ram_flag	<= csa10_ram_flag;
		end
	end
	
		always @(posedge clk)
	begin
		if(csa11_din_en)
		begin
			if(csa11_din[32] == 1'b1)
			begin
				case(csa11_din[3:0])
					4'd0:csa11_ram_flag[0]	<= 1'b1;
					4'd1:csa11_ram_flag[1]	<= 1'b1;					
					4'd2:csa11_ram_flag[2]	<= 1'b1;
					4'd3:csa11_ram_flag[3]	<= 1'b1;
					4'd4:csa11_ram_flag[4]	<= 1'b1;
					4'd5:csa11_ram_flag[5]	<= 1'b1;
					4'd6:csa11_ram_flag[6]	<= 1'b1;
					4'd7:csa11_ram_flag[7]	<= 1'b1;
					4'd8:csa11_ram_flag[8]	<= 1'b1;
					4'd9:csa11_ram_flag[9]	<= 1'b1;
					4'd10:csa11_ram_flag[10]	<= 1'b1;
					4'd11:csa11_ram_flag[11]	<= 1'b1;
					4'd12:csa11_ram_flag[12]	<= 1'b1;
					4'd13:csa11_ram_flag[13]	<= 1'b1;
					4'd14:csa11_ram_flag[14]	<= 1'b1;
					4'd15:csa11_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa11_ram_flag	<= csa11_ram_flag;
			end
		end
		else if(send_state == CSA11_RD)
		begin
			csa11_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa11_ram_flag	<= csa11_ram_flag;
		end
	end
	
	
		always @(posedge clk)
	begin
		if(csa12_din_en)
		begin
			if(csa12_din[32] == 1'b1)
			begin
				case(csa12_din[3:0])
					4'd0:csa12_ram_flag[0]	<= 1'b1;
					4'd1:csa12_ram_flag[1]	<= 1'b1;					
					4'd2:csa12_ram_flag[2]	<= 1'b1;
					4'd3:csa12_ram_flag[3]	<= 1'b1;
					4'd4:csa12_ram_flag[4]	<= 1'b1;
					4'd5:csa12_ram_flag[5]	<= 1'b1;
					4'd6:csa12_ram_flag[6]	<= 1'b1;
					4'd7:csa12_ram_flag[7]	<= 1'b1;
					4'd8:csa12_ram_flag[8]	<= 1'b1;
					4'd9:csa12_ram_flag[9]	<= 1'b1;
					4'd10:csa12_ram_flag[10]	<= 1'b1;
					4'd11:csa12_ram_flag[11]	<= 1'b1;
					4'd12:csa12_ram_flag[12]	<= 1'b1;
					4'd13:csa12_ram_flag[13]	<= 1'b1;
					4'd14:csa12_ram_flag[14]	<= 1'b1;
					4'd15:csa12_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa12_ram_flag	<= csa12_ram_flag;
			end
		end
		else if(send_state == CSA12_RD)
		begin
			csa12_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa12_ram_flag	<= csa12_ram_flag;
		end
	end
	
		always @(posedge clk)
	begin
		if(csa13_din_en)
		begin
			if(csa13_din[32] == 1'b1)
			begin
				case(csa13_din[3:0])
					4'd0:csa13_ram_flag[0]	<= 1'b1;
					4'd1:csa13_ram_flag[1]	<= 1'b1;					
					4'd2:csa13_ram_flag[2]	<= 1'b1;
					4'd3:csa13_ram_flag[3]	<= 1'b1;
					4'd4:csa13_ram_flag[4]	<= 1'b1;
					4'd5:csa13_ram_flag[5]	<= 1'b1;
					4'd6:csa13_ram_flag[6]	<= 1'b1;
					4'd7:csa13_ram_flag[7]	<= 1'b1;
					4'd8:csa13_ram_flag[8]	<= 1'b1;
					4'd9:csa13_ram_flag[9]	<= 1'b1;
					4'd10:csa13_ram_flag[10]	<= 1'b1;
					4'd11:csa13_ram_flag[11]	<= 1'b1;
					4'd12:csa13_ram_flag[12]	<= 1'b1;
					4'd13:csa13_ram_flag[13]	<= 1'b1;
					4'd14:csa13_ram_flag[14]	<= 1'b1;
					4'd15:csa13_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa13_ram_flag	<= csa13_ram_flag;
			end
		end
		else if(send_state == CSA13_RD)
		begin
			csa13_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa13_ram_flag	<= csa13_ram_flag;
		end
	end
	
	
		always @(posedge clk)
	begin
		if(csa14_din_en)
		begin
			if(csa14_din[32] == 1'b1)
			begin
				case(csa14_din[3:0])
					4'd0:csa14_ram_flag[0]	<= 1'b1;
					4'd1:csa14_ram_flag[1]	<= 1'b1;					
					4'd2:csa14_ram_flag[2]	<= 1'b1;
					4'd3:csa14_ram_flag[3]	<= 1'b1;
					4'd4:csa14_ram_flag[4]	<= 1'b1;
					4'd5:csa14_ram_flag[5]	<= 1'b1;
					4'd6:csa14_ram_flag[6]	<= 1'b1;
					4'd7:csa14_ram_flag[7]	<= 1'b1;
					4'd8:csa14_ram_flag[8]	<= 1'b1;
					4'd9:csa14_ram_flag[9]	<= 1'b1;
					4'd10:csa14_ram_flag[10]	<= 1'b1;
					4'd11:csa14_ram_flag[11]	<= 1'b1;
					4'd12:csa14_ram_flag[12]	<= 1'b1;
					4'd13:csa14_ram_flag[13]	<= 1'b1;
					4'd14:csa14_ram_flag[14]	<= 1'b1;
					4'd15:csa14_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa14_ram_flag	<= csa14_ram_flag;
			end
		end
		else if(send_state == CSA14_RD)
		begin
			csa14_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa14_ram_flag	<= csa14_ram_flag;
		end
	end
	
		always @(posedge clk)
	begin
		if(csa15_din_en)
		begin
			if(csa15_din[32] == 1'b1)
			begin
				case(csa15_din[3:0])
					4'd0:csa15_ram_flag[0]	<= 1'b1;
					4'd1:csa15_ram_flag[1]	<= 1'b1;					
					4'd2:csa15_ram_flag[2]	<= 1'b1;
					4'd3:csa15_ram_flag[3]	<= 1'b1;
					4'd4:csa15_ram_flag[4]	<= 1'b1;
					4'd5:csa15_ram_flag[5]	<= 1'b1;
					4'd6:csa15_ram_flag[6]	<= 1'b1;
					4'd7:csa15_ram_flag[7]	<= 1'b1;
					4'd8:csa15_ram_flag[8]	<= 1'b1;
					4'd9:csa15_ram_flag[9]	<= 1'b1;
					4'd10:csa15_ram_flag[10]	<= 1'b1;
					4'd11:csa15_ram_flag[11]	<= 1'b1;
					4'd12:csa15_ram_flag[12]	<= 1'b1;
					4'd13:csa15_ram_flag[13]	<= 1'b1;
					4'd14:csa15_ram_flag[14]	<= 1'b1;
					4'd15:csa15_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa15_ram_flag	<= csa15_ram_flag;
			end
		end
		else if(send_state == CSA15_RD)
		begin
			csa15_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa15_ram_flag	<= csa15_ram_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(csa16_din_en)
		begin
			if(csa16_din[32] == 1'b1)
			begin
				case(csa16_din[3:0])
					4'd0:csa16_ram_flag[0]	<= 1'b1;
					4'd1:csa16_ram_flag[1]	<= 1'b1;					
					4'd2:csa16_ram_flag[2]	<= 1'b1;
					4'd3:csa16_ram_flag[3]	<= 1'b1;
					4'd4:csa16_ram_flag[4]	<= 1'b1;
					4'd5:csa16_ram_flag[5]	<= 1'b1;
					4'd6:csa16_ram_flag[6]	<= 1'b1;
					4'd7:csa16_ram_flag[7]	<= 1'b1;
					4'd8:csa16_ram_flag[8]	<= 1'b1;
					4'd9:csa16_ram_flag[9]	<= 1'b1;
					4'd10:csa16_ram_flag[10]	<= 1'b1;
					4'd11:csa16_ram_flag[11]	<= 1'b1;
					4'd12:csa16_ram_flag[12]	<= 1'b1;
					4'd13:csa16_ram_flag[13]	<= 1'b1;
					4'd14:csa16_ram_flag[14]	<= 1'b1;
					4'd15:csa16_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa16_ram_flag	<= csa16_ram_flag;
			end
		end
		else if(send_state == CSA16_RD)
		begin
			csa16_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa16_ram_flag	<= csa16_ram_flag;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(csa17_din_en)
		begin
			if(csa17_din[32] == 1'b1)
			begin
				case(csa17_din[3:0])
					4'd0:csa17_ram_flag[0]	<= 1'b1;
					4'd1:csa17_ram_flag[1]	<= 1'b1;					
					4'd2:csa17_ram_flag[2]	<= 1'b1;
					4'd3:csa17_ram_flag[3]	<= 1'b1;
					4'd4:csa17_ram_flag[4]	<= 1'b1;
					4'd5:csa17_ram_flag[5]	<= 1'b1;
					4'd6:csa17_ram_flag[6]	<= 1'b1;
					4'd7:csa17_ram_flag[7]	<= 1'b1;
					4'd8:csa17_ram_flag[8]	<= 1'b1;
					4'd9:csa17_ram_flag[9]	<= 1'b1;
					4'd10:csa17_ram_flag[10]	<= 1'b1;
					4'd11:csa17_ram_flag[11]	<= 1'b1;
					4'd12:csa17_ram_flag[12]	<= 1'b1;
					4'd13:csa17_ram_flag[13]	<= 1'b1;
					4'd14:csa17_ram_flag[14]	<= 1'b1;
					4'd15:csa17_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa17_ram_flag	<= csa17_ram_flag;
			end
		end
		else if(send_state == CSA17_RD)
		begin
			csa17_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa17_ram_flag	<= csa17_ram_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(csa18_din_en)
		begin
			if(csa18_din[32] == 1'b1)
			begin
				case(csa18_din[3:0])
					4'd0:csa18_ram_flag[0]	<= 1'b1;
					4'd1:csa18_ram_flag[1]	<= 1'b1;					
					4'd2:csa18_ram_flag[2]	<= 1'b1;
					4'd3:csa18_ram_flag[3]	<= 1'b1;
					4'd4:csa18_ram_flag[4]	<= 1'b1;
					4'd5:csa18_ram_flag[5]	<= 1'b1;
					4'd6:csa18_ram_flag[6]	<= 1'b1;
					4'd7:csa18_ram_flag[7]	<= 1'b1;
					4'd8:csa18_ram_flag[8]	<= 1'b1;
					4'd9:csa18_ram_flag[9]	<= 1'b1;
					4'd10:csa18_ram_flag[10]	<= 1'b1;
					4'd11:csa18_ram_flag[11]	<= 1'b1;
					4'd12:csa18_ram_flag[12]	<= 1'b1;
					4'd13:csa18_ram_flag[13]	<= 1'b1;
					4'd14:csa18_ram_flag[14]	<= 1'b1;
					4'd15:csa18_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa18_ram_flag	<= csa18_ram_flag;
			end
		end
		else if(send_state == CSA18_RD)
		begin
			csa18_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa18_ram_flag	<= csa18_ram_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(csa19_din_en)
		begin
			if(csa19_din[32] == 1'b1)
			begin
				case(csa19_din[3:0])
					4'd0:csa19_ram_flag[0]	<= 1'b1;
					4'd1:csa19_ram_flag[1]	<= 1'b1;					
					4'd2:csa19_ram_flag[2]	<= 1'b1;
					4'd3:csa19_ram_flag[3]	<= 1'b1;
					4'd4:csa19_ram_flag[4]	<= 1'b1;
					4'd5:csa19_ram_flag[5]	<= 1'b1;
					4'd6:csa19_ram_flag[6]	<= 1'b1;
					4'd7:csa19_ram_flag[7]	<= 1'b1;
					4'd8:csa19_ram_flag[8]	<= 1'b1;
					4'd9:csa19_ram_flag[9]	<= 1'b1;
					4'd10:csa19_ram_flag[10]	<= 1'b1;
					4'd11:csa19_ram_flag[11]	<= 1'b1;
					4'd12:csa19_ram_flag[12]	<= 1'b1;
					4'd13:csa19_ram_flag[13]	<= 1'b1;
					4'd14:csa19_ram_flag[14]	<= 1'b1;
					4'd15:csa19_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa19_ram_flag	<= csa19_ram_flag;
			end
		end
		else if(send_state == CSA19_RD)
		begin
			csa19_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa19_ram_flag	<= csa19_ram_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(csa20_din_en)
		begin
			if(csa20_din[32] == 1'b1)
			begin
				case(csa20_din[3:0])
					4'd0:csa20_ram_flag[0]	<= 1'b1;
					4'd1:csa20_ram_flag[1]	<= 1'b1;					
					4'd2:csa20_ram_flag[2]	<= 1'b1;
					4'd3:csa20_ram_flag[3]	<= 1'b1;
					4'd4:csa20_ram_flag[4]	<= 1'b1;
					4'd5:csa20_ram_flag[5]	<= 1'b1;
					4'd6:csa20_ram_flag[6]	<= 1'b1;
					4'd7:csa20_ram_flag[7]	<= 1'b1;
					4'd8:csa20_ram_flag[8]	<= 1'b1;
					4'd9:csa20_ram_flag[9]	<= 1'b1;
					4'd10:csa20_ram_flag[10]	<= 1'b1;
					4'd11:csa20_ram_flag[11]	<= 1'b1;
					4'd12:csa20_ram_flag[12]	<= 1'b1;
					4'd13:csa20_ram_flag[13]	<= 1'b1;
					4'd14:csa20_ram_flag[14]	<= 1'b1;
					4'd15:csa20_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa20_ram_flag	<= csa20_ram_flag;
			end
		end
		else if(send_state == CSA20_RD)
		begin
			csa20_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa20_ram_flag	<= csa20_ram_flag;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(csa21_din_en)
		begin
			if(csa21_din[32] == 1'b1)
			begin
				case(csa21_din[3:0])
					4'd0:csa21_ram_flag[0]	<= 1'b1;
					4'd1:csa21_ram_flag[1]	<= 1'b1;					
					4'd2:csa21_ram_flag[2]	<= 1'b1;
					4'd3:csa21_ram_flag[3]	<= 1'b1;
					4'd4:csa21_ram_flag[4]	<= 1'b1;
					4'd5:csa21_ram_flag[5]	<= 1'b1;
					4'd6:csa21_ram_flag[6]	<= 1'b1;
					4'd7:csa21_ram_flag[7]	<= 1'b1;
					4'd8:csa21_ram_flag[8]	<= 1'b1;
					4'd9:csa21_ram_flag[9]	<= 1'b1;
					4'd10:csa21_ram_flag[10]	<= 1'b1;
					4'd11:csa21_ram_flag[11]	<= 1'b1;
					4'd12:csa21_ram_flag[12]	<= 1'b1;
					4'd13:csa21_ram_flag[13]	<= 1'b1;
					4'd14:csa21_ram_flag[14]	<= 1'b1;
					4'd15:csa21_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa21_ram_flag	<= csa21_ram_flag;
			end
		end
		else if(send_state == CSA21_RD)
		begin
			csa21_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa21_ram_flag	<= csa21_ram_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(csa22_din_en)
		begin
			if(csa22_din[32] == 1'b1)
			begin
				case(csa22_din[3:0])
					4'd0:csa22_ram_flag[0]	<= 1'b1;
					4'd1:csa22_ram_flag[1]	<= 1'b1;					
					4'd2:csa22_ram_flag[2]	<= 1'b1;
					4'd3:csa22_ram_flag[3]	<= 1'b1;
					4'd4:csa22_ram_flag[4]	<= 1'b1;
					4'd5:csa22_ram_flag[5]	<= 1'b1;
					4'd6:csa22_ram_flag[6]	<= 1'b1;
					4'd7:csa22_ram_flag[7]	<= 1'b1;
					4'd8:csa22_ram_flag[8]	<= 1'b1;
					4'd9:csa22_ram_flag[9]	<= 1'b1;
					4'd10:csa22_ram_flag[10]	<= 1'b1;
					4'd11:csa22_ram_flag[11]	<= 1'b1;
					4'd12:csa22_ram_flag[12]	<= 1'b1;
					4'd13:csa22_ram_flag[13]	<= 1'b1;
					4'd14:csa22_ram_flag[14]	<= 1'b1;
					4'd15:csa22_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa22_ram_flag	<= csa22_ram_flag;
			end
		end
		else if(send_state == CSA22_RD)
		begin
			csa22_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa22_ram_flag	<= csa22_ram_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(csa23_din_en)
		begin
			if(csa23_din[32] == 1'b1)
			begin
				case(csa23_din[3:0])
					4'd0:csa23_ram_flag[0]	<= 1'b1;
					4'd1:csa23_ram_flag[1]	<= 1'b1;					
					4'd2:csa23_ram_flag[2]	<= 1'b1;
					4'd3:csa23_ram_flag[3]	<= 1'b1;
					4'd4:csa23_ram_flag[4]	<= 1'b1;
					4'd5:csa23_ram_flag[5]	<= 1'b1;
					4'd6:csa23_ram_flag[6]	<= 1'b1;
					4'd7:csa23_ram_flag[7]	<= 1'b1;
					4'd8:csa23_ram_flag[8]	<= 1'b1;
					4'd9:csa23_ram_flag[9]	<= 1'b1;
					4'd10:csa23_ram_flag[10]	<= 1'b1;
					4'd11:csa23_ram_flag[11]	<= 1'b1;
					4'd12:csa23_ram_flag[12]	<= 1'b1;
					4'd13:csa23_ram_flag[13]	<= 1'b1;
					4'd14:csa23_ram_flag[14]	<= 1'b1;
					4'd15:csa23_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa23_ram_flag	<= csa23_ram_flag;
			end
		end
		else if(send_state == CSA23_RD)
		begin
			csa23_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa23_ram_flag	<= csa23_ram_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(csa24_din_en)
		begin
			if(csa24_din[32] == 1'b1)
			begin
				case(csa24_din[3:0])
					4'd0:csa24_ram_flag[0]	<= 1'b1;
					4'd1:csa24_ram_flag[1]	<= 1'b1;					
					4'd2:csa24_ram_flag[2]	<= 1'b1;
					4'd3:csa24_ram_flag[3]	<= 1'b1;
					4'd4:csa24_ram_flag[4]	<= 1'b1;
					4'd5:csa24_ram_flag[5]	<= 1'b1;
					4'd6:csa24_ram_flag[6]	<= 1'b1;
					4'd7:csa24_ram_flag[7]	<= 1'b1;
					4'd8:csa24_ram_flag[8]	<= 1'b1;
					4'd9:csa24_ram_flag[9]	<= 1'b1;
					4'd10:csa24_ram_flag[10]	<= 1'b1;
					4'd11:csa24_ram_flag[11]	<= 1'b1;
					4'd12:csa24_ram_flag[12]	<= 1'b1;
					4'd13:csa24_ram_flag[13]	<= 1'b1;
					4'd14:csa24_ram_flag[14]	<= 1'b1;
					4'd15:csa24_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa24_ram_flag	<= csa24_ram_flag;
			end
		end
		else if(send_state == CSA24_RD)
		begin
			csa24_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa24_ram_flag	<= csa24_ram_flag;
		end
	end
	
	
	
	always @(posedge clk)
	begin
		if(csa25_din_en)
		begin
			if(csa25_din[32] == 1'b1)
			begin
				case(csa25_din[3:0])
					4'd0:csa25_ram_flag[0]	<= 1'b1;
					4'd1:csa25_ram_flag[1]	<= 1'b1;					
					4'd2:csa25_ram_flag[2]	<= 1'b1;
					4'd3:csa25_ram_flag[3]	<= 1'b1;
					4'd4:csa25_ram_flag[4]	<= 1'b1;
					4'd5:csa25_ram_flag[5]	<= 1'b1;
					4'd6:csa25_ram_flag[6]	<= 1'b1;
					4'd7:csa25_ram_flag[7]	<= 1'b1;
					4'd8:csa25_ram_flag[8]	<= 1'b1;
					4'd9:csa25_ram_flag[9]	<= 1'b1;
					4'd10:csa25_ram_flag[10]	<= 1'b1;
					4'd11:csa25_ram_flag[11]	<= 1'b1;
					4'd12:csa25_ram_flag[12]	<= 1'b1;
					4'd13:csa25_ram_flag[13]	<= 1'b1;
					4'd14:csa25_ram_flag[14]	<= 1'b1;
					4'd15:csa25_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa25_ram_flag	<= csa25_ram_flag;
			end
		end
		else if(send_state == CSA25_RD)
		begin
			csa25_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa25_ram_flag	<= csa25_ram_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(csa26_din_en)
		begin
			if(csa26_din[32] == 1'b1)
			begin
				case(csa26_din[3:0])
					4'd0:csa26_ram_flag[0]	<= 1'b1;
					4'd1:csa26_ram_flag[1]	<= 1'b1;					
					4'd2:csa26_ram_flag[2]	<= 1'b1;
					4'd3:csa26_ram_flag[3]	<= 1'b1;
					4'd4:csa26_ram_flag[4]	<= 1'b1;
					4'd5:csa26_ram_flag[5]	<= 1'b1;
					4'd6:csa26_ram_flag[6]	<= 1'b1;
					4'd7:csa26_ram_flag[7]	<= 1'b1;
					4'd8:csa26_ram_flag[8]	<= 1'b1;
					4'd9:csa26_ram_flag[9]	<= 1'b1;
					4'd10:csa26_ram_flag[10]	<= 1'b1;
					4'd11:csa26_ram_flag[11]	<= 1'b1;
					4'd12:csa26_ram_flag[12]	<= 1'b1;
					4'd13:csa26_ram_flag[13]	<= 1'b1;
					4'd14:csa26_ram_flag[14]	<= 1'b1;
					4'd15:csa26_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa26_ram_flag	<= csa26_ram_flag;
			end
		end
		else if(send_state == CSA26_RD)
		begin
			csa26_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa26_ram_flag	<= csa26_ram_flag;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(csa27_din_en)
		begin
			if(csa27_din[32] == 1'b1)
			begin
				case(csa27_din[3:0])
					4'd0:csa27_ram_flag[0]	<= 1'b1;
					4'd1:csa27_ram_flag[1]	<= 1'b1;					
					4'd2:csa27_ram_flag[2]	<= 1'b1;
					4'd3:csa27_ram_flag[3]	<= 1'b1;
					4'd4:csa27_ram_flag[4]	<= 1'b1;
					4'd5:csa27_ram_flag[5]	<= 1'b1;
					4'd6:csa27_ram_flag[6]	<= 1'b1;
					4'd7:csa27_ram_flag[7]	<= 1'b1;
					4'd8:csa27_ram_flag[8]	<= 1'b1;
					4'd9:csa27_ram_flag[9]	<= 1'b1;
					4'd10:csa27_ram_flag[10]	<= 1'b1;
					4'd11:csa27_ram_flag[11]	<= 1'b1;
					4'd12:csa27_ram_flag[12]	<= 1'b1;
					4'd13:csa27_ram_flag[13]	<= 1'b1;
					4'd14:csa27_ram_flag[14]	<= 1'b1;
					4'd15:csa27_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa27_ram_flag	<= csa27_ram_flag;
			end
		end
		else if(send_state == CSA27_RD)
		begin
			csa27_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa27_ram_flag	<= csa27_ram_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(csa28_din_en)
		begin
			if(csa28_din[32] == 1'b1)
			begin
				case(csa28_din[3:0])
					4'd0:csa28_ram_flag[0]	<= 1'b1;
					4'd1:csa28_ram_flag[1]	<= 1'b1;					
					4'd2:csa28_ram_flag[2]	<= 1'b1;
					4'd3:csa28_ram_flag[3]	<= 1'b1;
					4'd4:csa28_ram_flag[4]	<= 1'b1;
					4'd5:csa28_ram_flag[5]	<= 1'b1;
					4'd6:csa28_ram_flag[6]	<= 1'b1;
					4'd7:csa28_ram_flag[7]	<= 1'b1;
					4'd8:csa28_ram_flag[8]	<= 1'b1;
					4'd9:csa28_ram_flag[9]	<= 1'b1;
					4'd10:csa28_ram_flag[10]	<= 1'b1;
					4'd11:csa28_ram_flag[11]	<= 1'b1;
					4'd12:csa28_ram_flag[12]	<= 1'b1;
					4'd13:csa28_ram_flag[13]	<= 1'b1;
					4'd14:csa28_ram_flag[14]	<= 1'b1;
					4'd15:csa28_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa28_ram_flag	<= csa28_ram_flag;
			end
		end
		else if(send_state == CSA28_RD)
		begin
			csa28_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa28_ram_flag	<= csa28_ram_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(csa29_din_en)
		begin
			if(csa29_din[32] == 1'b1)
			begin
				case(csa29_din[3:0])
					4'd0:csa29_ram_flag[0]	<= 1'b1;
					4'd1:csa29_ram_flag[1]	<= 1'b1;					
					4'd2:csa29_ram_flag[2]	<= 1'b1;
					4'd3:csa29_ram_flag[3]	<= 1'b1;
					4'd4:csa29_ram_flag[4]	<= 1'b1;
					4'd5:csa29_ram_flag[5]	<= 1'b1;
					4'd6:csa29_ram_flag[6]	<= 1'b1;
					4'd7:csa29_ram_flag[7]	<= 1'b1;
					4'd8:csa29_ram_flag[8]	<= 1'b1;
					4'd9:csa29_ram_flag[9]	<= 1'b1;
					4'd10:csa29_ram_flag[10]	<= 1'b1;
					4'd11:csa29_ram_flag[11]	<= 1'b1;
					4'd12:csa29_ram_flag[12]	<= 1'b1;
					4'd13:csa29_ram_flag[13]	<= 1'b1;
					4'd14:csa29_ram_flag[14]	<= 1'b1;
					4'd15:csa29_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa29_ram_flag	<= csa29_ram_flag;
			end
		end
		else if(send_state == CSA29_RD)
		begin
			csa29_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa29_ram_flag	<= csa29_ram_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(csa30_din_en)
		begin
			if(csa30_din[32] == 1'b1)
			begin
				case(csa30_din[3:0])
					4'd0:csa30_ram_flag[0]	<= 1'b1;
					4'd1:csa30_ram_flag[1]	<= 1'b1;					
					4'd2:csa30_ram_flag[2]	<= 1'b1;
					4'd3:csa30_ram_flag[3]	<= 1'b1;
					4'd4:csa30_ram_flag[4]	<= 1'b1;
					4'd5:csa30_ram_flag[5]	<= 1'b1;
					4'd6:csa30_ram_flag[6]	<= 1'b1;
					4'd7:csa30_ram_flag[7]	<= 1'b1;
					4'd8:csa30_ram_flag[8]	<= 1'b1;
					4'd9:csa30_ram_flag[9]	<= 1'b1;
					4'd10:csa30_ram_flag[10]	<= 1'b1;
					4'd11:csa30_ram_flag[11]	<= 1'b1;
					4'd12:csa30_ram_flag[12]	<= 1'b1;
					4'd13:csa30_ram_flag[13]	<= 1'b1;
					4'd14:csa30_ram_flag[14]	<= 1'b1;
					4'd15:csa30_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa30_ram_flag	<= csa30_ram_flag;
			end
		end
		else if(send_state == CSA30_RD)
		begin
			csa30_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa30_ram_flag	<= csa30_ram_flag;
		end
	end
	
	
	always @(posedge clk)
	begin
		if(csa31_din_en)
		begin
			if(csa31_din[32] == 1'b1)
			begin
				case(csa31_din[3:0])
					4'd0:csa31_ram_flag[0]	<= 1'b1;
					4'd1:csa31_ram_flag[1]	<= 1'b1;					
					4'd2:csa31_ram_flag[2]	<= 1'b1;
					4'd3:csa31_ram_flag[3]	<= 1'b1;
					4'd4:csa31_ram_flag[4]	<= 1'b1;
					4'd5:csa31_ram_flag[5]	<= 1'b1;
					4'd6:csa31_ram_flag[6]	<= 1'b1;
					4'd7:csa31_ram_flag[7]	<= 1'b1;
					4'd8:csa31_ram_flag[8]	<= 1'b1;
					4'd9:csa31_ram_flag[9]	<= 1'b1;
					4'd10:csa31_ram_flag[10]	<= 1'b1;
					4'd11:csa31_ram_flag[11]	<= 1'b1;
					4'd12:csa31_ram_flag[12]	<= 1'b1;
					4'd13:csa31_ram_flag[13]	<= 1'b1;
					4'd14:csa31_ram_flag[14]	<= 1'b1;
					4'd15:csa31_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa31_ram_flag	<= csa31_ram_flag;
			end
		end
		else if(send_state == CSA31_RD)
		begin
			csa31_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa31_ram_flag	<= csa31_ram_flag;
		end
	end
	
	always @(posedge clk)
	begin
		if(csa32_din_en)
		begin
			if(csa32_din[32] == 1'b1)
			begin
				case(csa32_din[3:0])
					4'd0:csa32_ram_flag[0]	<= 1'b1;
					4'd1:csa32_ram_flag[1]	<= 1'b1;					
					4'd2:csa32_ram_flag[2]	<= 1'b1;
					4'd3:csa32_ram_flag[3]	<= 1'b1;
					4'd4:csa32_ram_flag[4]	<= 1'b1;
					4'd5:csa32_ram_flag[5]	<= 1'b1;
					4'd6:csa32_ram_flag[6]	<= 1'b1;
					4'd7:csa32_ram_flag[7]	<= 1'b1;
					4'd8:csa32_ram_flag[8]	<= 1'b1;
					4'd9:csa32_ram_flag[9]	<= 1'b1;
					4'd10:csa32_ram_flag[10]	<= 1'b1;
					4'd11:csa32_ram_flag[11]	<= 1'b1;
					4'd12:csa32_ram_flag[12]	<= 1'b1;
					4'd13:csa32_ram_flag[13]	<= 1'b1;
					4'd14:csa32_ram_flag[14]	<= 1'b1;
					4'd15:csa32_ram_flag[15]	<= 1'b1;
				endcase
			end
			else
			begin
				csa32_ram_flag	<= csa32_ram_flag;
			end
		end
		else if(send_state == CSA32_RD)
		begin
			csa32_ram_flag[counter_prev]	<= 1'b0;
		end
		else
		begin
			csa32_ram_flag	<= csa32_ram_flag;
		end
	end
//	
//	always @(posedge clk)
//	begin
//		if(csa33_din_en)
//		begin
//			if(csa33_din[32] == 1'b1)
//			begin
//				case(csa33_din[3:0])
//					4'd0:csa33_ram_flag[0]	<= 1'b1;
//					4'd1:csa33_ram_flag[1]	<= 1'b1;					
//					4'd2:csa33_ram_flag[2]	<= 1'b1;
//					4'd3:csa33_ram_flag[3]	<= 1'b1;
//					4'd4:csa33_ram_flag[4]	<= 1'b1;
//					4'd5:csa33_ram_flag[5]	<= 1'b1;
//					4'd6:csa33_ram_flag[6]	<= 1'b1;
//					4'd7:csa33_ram_flag[7]	<= 1'b1;
//					4'd8:csa33_ram_flag[8]	<= 1'b1;
//					4'd9:csa33_ram_flag[9]	<= 1'b1;
//					4'd10:csa33_ram_flag[10]	<= 1'b1;
//					4'd11:csa33_ram_flag[11]	<= 1'b1;
//					4'd12:csa33_ram_flag[12]	<= 1'b1;
//					4'd13:csa33_ram_flag[13]	<= 1'b1;
//					4'd14:csa33_ram_flag[14]	<= 1'b1;
//					4'd15:csa33_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa33_ram_flag	<= csa33_ram_flag;
//			end
//		end
//		else if(send_state == CSA33_RD)
//		begin
//			csa33_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa33_ram_flag	<= csa33_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa34_din_en)
//		begin
//			if(csa34_din[32] == 1'b1)
//			begin
//				case(csa34_din[3:0])
//					4'd0:csa34_ram_flag[0]	<= 1'b1;
//					4'd1:csa34_ram_flag[1]	<= 1'b1;					
//					4'd2:csa34_ram_flag[2]	<= 1'b1;
//					4'd3:csa34_ram_flag[3]	<= 1'b1;
//					4'd4:csa34_ram_flag[4]	<= 1'b1;
//					4'd5:csa34_ram_flag[5]	<= 1'b1;
//					4'd6:csa34_ram_flag[6]	<= 1'b1;
//					4'd7:csa34_ram_flag[7]	<= 1'b1;
//					4'd8:csa34_ram_flag[8]	<= 1'b1;
//					4'd9:csa34_ram_flag[9]	<= 1'b1;
//					4'd10:csa34_ram_flag[10]	<= 1'b1;
//					4'd11:csa34_ram_flag[11]	<= 1'b1;
//					4'd12:csa34_ram_flag[12]	<= 1'b1;
//					4'd13:csa34_ram_flag[13]	<= 1'b1;
//					4'd14:csa34_ram_flag[14]	<= 1'b1;
//					4'd15:csa34_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa34_ram_flag	<= csa34_ram_flag;
//			end
//		end
//		else if(send_state == CSA34_RD)
//		begin
//			csa34_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa34_ram_flag	<= csa34_ram_flag;
//		end
//	end
//	
//	
//	always @(posedge clk)
//	begin
//		if(csa35_din_en)
//		begin
//			if(csa35_din[32] == 1'b1)
//			begin
//				case(csa35_din[3:0])
//					4'd0:csa35_ram_flag[0]	<= 1'b1;
//					4'd1:csa35_ram_flag[1]	<= 1'b1;					
//					4'd2:csa35_ram_flag[2]	<= 1'b1;
//					4'd3:csa35_ram_flag[3]	<= 1'b1;
//					4'd4:csa35_ram_flag[4]	<= 1'b1;
//					4'd5:csa35_ram_flag[5]	<= 1'b1;
//					4'd6:csa35_ram_flag[6]	<= 1'b1;
//					4'd7:csa35_ram_flag[7]	<= 1'b1;
//					4'd8:csa35_ram_flag[8]	<= 1'b1;
//					4'd9:csa35_ram_flag[9]	<= 1'b1;
//					4'd10:csa35_ram_flag[10]	<= 1'b1;
//					4'd11:csa35_ram_flag[11]	<= 1'b1;
//					4'd12:csa35_ram_flag[12]	<= 1'b1;
//					4'd13:csa35_ram_flag[13]	<= 1'b1;
//					4'd14:csa35_ram_flag[14]	<= 1'b1;
//					4'd15:csa35_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa35_ram_flag	<= csa35_ram_flag;
//			end
//		end
//		else if(send_state == CSA35_RD)
//		begin
//			csa35_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa35_ram_flag	<= csa35_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa36_din_en)
//		begin
//			if(csa36_din[32] == 1'b1)
//			begin
//				case(csa36_din[3:0])
//					4'd0:csa36_ram_flag[0]	<= 1'b1;
//					4'd1:csa36_ram_flag[1]	<= 1'b1;					
//					4'd2:csa36_ram_flag[2]	<= 1'b1;
//					4'd3:csa36_ram_flag[3]	<= 1'b1;
//					4'd4:csa36_ram_flag[4]	<= 1'b1;
//					4'd5:csa36_ram_flag[5]	<= 1'b1;
//					4'd6:csa36_ram_flag[6]	<= 1'b1;
//					4'd7:csa36_ram_flag[7]	<= 1'b1;
//					4'd8:csa36_ram_flag[8]	<= 1'b1;
//					4'd9:csa36_ram_flag[9]	<= 1'b1;
//					4'd10:csa36_ram_flag[10]	<= 1'b1;
//					4'd11:csa36_ram_flag[11]	<= 1'b1;
//					4'd12:csa36_ram_flag[12]	<= 1'b1;
//					4'd13:csa36_ram_flag[13]	<= 1'b1;
//					4'd14:csa36_ram_flag[14]	<= 1'b1;
//					4'd15:csa36_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa36_ram_flag	<= csa36_ram_flag;
//			end
//		end
//		else if(send_state == CSA36_RD)
//		begin
//			csa36_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa36_ram_flag	<= csa36_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa37_din_en)
//		begin
//			if(csa37_din[32] == 1'b1)
//			begin
//				case(csa37_din[3:0])
//					4'd0:csa37_ram_flag[0]	<= 1'b1;
//					4'd1:csa37_ram_flag[1]	<= 1'b1;					
//					4'd2:csa37_ram_flag[2]	<= 1'b1;
//					4'd3:csa37_ram_flag[3]	<= 1'b1;
//					4'd4:csa37_ram_flag[4]	<= 1'b1;
//					4'd5:csa37_ram_flag[5]	<= 1'b1;
//					4'd6:csa37_ram_flag[6]	<= 1'b1;
//					4'd7:csa37_ram_flag[7]	<= 1'b1;
//					4'd8:csa37_ram_flag[8]	<= 1'b1;
//					4'd9:csa37_ram_flag[9]	<= 1'b1;
//					4'd10:csa37_ram_flag[10]	<= 1'b1;
//					4'd11:csa37_ram_flag[11]	<= 1'b1;
//					4'd12:csa37_ram_flag[12]	<= 1'b1;
//					4'd13:csa37_ram_flag[13]	<= 1'b1;
//					4'd14:csa37_ram_flag[14]	<= 1'b1;
//					4'd15:csa37_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa37_ram_flag	<= csa37_ram_flag;
//			end
//		end
//		else if(send_state == CSA37_RD)
//		begin
//			csa37_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa37_ram_flag	<= csa37_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa38_din_en)
//		begin
//			if(csa38_din[32] == 1'b1)
//			begin
//				case(csa38_din[3:0])
//					4'd0:csa38_ram_flag[0]	<= 1'b1;
//					4'd1:csa38_ram_flag[1]	<= 1'b1;					
//					4'd2:csa38_ram_flag[2]	<= 1'b1;
//					4'd3:csa38_ram_flag[3]	<= 1'b1;
//					4'd4:csa38_ram_flag[4]	<= 1'b1;
//					4'd5:csa38_ram_flag[5]	<= 1'b1;
//					4'd6:csa38_ram_flag[6]	<= 1'b1;
//					4'd7:csa38_ram_flag[7]	<= 1'b1;
//					4'd8:csa38_ram_flag[8]	<= 1'b1;
//					4'd9:csa38_ram_flag[9]	<= 1'b1;
//					4'd10:csa38_ram_flag[10]	<= 1'b1;
//					4'd11:csa38_ram_flag[11]	<= 1'b1;
//					4'd12:csa38_ram_flag[12]	<= 1'b1;
//					4'd13:csa38_ram_flag[13]	<= 1'b1;
//					4'd14:csa38_ram_flag[14]	<= 1'b1;
//					4'd15:csa38_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa38_ram_flag	<= csa38_ram_flag;
//			end
//		end
//		else if(send_state == CSA38_RD)
//		begin
//			csa38_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa38_ram_flag	<= csa38_ram_flag;
//		end
//	end
//	
//	
//	always @(posedge clk)
//	begin
//		if(csa39_din_en)
//		begin
//			if(csa39_din[32] == 1'b1)
//			begin
//				case(csa39_din[3:0])
//					4'd0:csa39_ram_flag[0]	<= 1'b1;
//					4'd1:csa39_ram_flag[1]	<= 1'b1;					
//					4'd2:csa39_ram_flag[2]	<= 1'b1;
//					4'd3:csa39_ram_flag[3]	<= 1'b1;
//					4'd4:csa39_ram_flag[4]	<= 1'b1;
//					4'd5:csa39_ram_flag[5]	<= 1'b1;
//					4'd6:csa39_ram_flag[6]	<= 1'b1;
//					4'd7:csa39_ram_flag[7]	<= 1'b1;
//					4'd8:csa39_ram_flag[8]	<= 1'b1;
//					4'd9:csa39_ram_flag[9]	<= 1'b1;
//					4'd10:csa39_ram_flag[10]	<= 1'b1;
//					4'd11:csa39_ram_flag[11]	<= 1'b1;
//					4'd12:csa39_ram_flag[12]	<= 1'b1;
//					4'd13:csa39_ram_flag[13]	<= 1'b1;
//					4'd14:csa39_ram_flag[14]	<= 1'b1;
//					4'd15:csa39_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa39_ram_flag	<= csa39_ram_flag;
//			end
//		end
//		else if(send_state == CSA39_RD)
//		begin
//			csa39_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa39_ram_flag	<= csa39_ram_flag;
//		end
//	end
//	
//	
//	always @(posedge clk)
//	begin
//		if(csa40_din_en)
//		begin
//			if(csa40_din[32] == 1'b1)
//			begin
//				case(csa40_din[3:0])
//					4'd0:csa40_ram_flag[0]	<= 1'b1;
//					4'd1:csa40_ram_flag[1]	<= 1'b1;					
//					4'd2:csa40_ram_flag[2]	<= 1'b1;
//					4'd3:csa40_ram_flag[3]	<= 1'b1;
//					4'd4:csa40_ram_flag[4]	<= 1'b1;
//					4'd5:csa40_ram_flag[5]	<= 1'b1;
//					4'd6:csa40_ram_flag[6]	<= 1'b1;
//					4'd7:csa40_ram_flag[7]	<= 1'b1;
//					4'd8:csa40_ram_flag[8]	<= 1'b1;
//					4'd9:csa40_ram_flag[9]	<= 1'b1;
//					4'd10:csa40_ram_flag[10]	<= 1'b1;
//					4'd11:csa40_ram_flag[11]	<= 1'b1;
//					4'd12:csa40_ram_flag[12]	<= 1'b1;
//					4'd13:csa40_ram_flag[13]	<= 1'b1;
//					4'd14:csa40_ram_flag[14]	<= 1'b1;
//					4'd15:csa40_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa40_ram_flag	<= csa40_ram_flag;
//			end
//		end
//		else if(send_state == CSA40_RD)
//		begin
//			csa40_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa40_ram_flag	<= csa40_ram_flag;
//		end
//	end
//	
//	
//	always @(posedge clk)
//	begin
//		if(csa41_din_en)
//		begin
//			if(csa41_din[32] == 1'b1)
//			begin
//				case(csa41_din[3:0])
//					4'd0:csa41_ram_flag[0]	<= 1'b1;
//					4'd1:csa41_ram_flag[1]	<= 1'b1;					
//					4'd2:csa41_ram_flag[2]	<= 1'b1;
//					4'd3:csa41_ram_flag[3]	<= 1'b1;
//					4'd4:csa41_ram_flag[4]	<= 1'b1;
//					4'd5:csa41_ram_flag[5]	<= 1'b1;
//					4'd6:csa41_ram_flag[6]	<= 1'b1;
//					4'd7:csa41_ram_flag[7]	<= 1'b1;
//					4'd8:csa41_ram_flag[8]	<= 1'b1;
//					4'd9:csa41_ram_flag[9]	<= 1'b1;
//					4'd10:csa41_ram_flag[10]	<= 1'b1;
//					4'd11:csa41_ram_flag[11]	<= 1'b1;
//					4'd12:csa41_ram_flag[12]	<= 1'b1;
//					4'd13:csa41_ram_flag[13]	<= 1'b1;
//					4'd14:csa41_ram_flag[14]	<= 1'b1;
//					4'd15:csa41_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa41_ram_flag	<= csa41_ram_flag;
//			end
//		end
//		else if(send_state == CSA41_RD)
//		begin
//			csa41_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa41_ram_flag	<= csa41_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa42_din_en)
//		begin
//			if(csa42_din[32] == 1'b1)
//			begin
//				case(csa42_din[3:0])
//					4'd0:csa42_ram_flag[0]	<= 1'b1;
//					4'd1:csa42_ram_flag[1]	<= 1'b1;					
//					4'd2:csa42_ram_flag[2]	<= 1'b1;
//					4'd3:csa42_ram_flag[3]	<= 1'b1;
//					4'd4:csa42_ram_flag[4]	<= 1'b1;
//					4'd5:csa42_ram_flag[5]	<= 1'b1;
//					4'd6:csa42_ram_flag[6]	<= 1'b1;
//					4'd7:csa42_ram_flag[7]	<= 1'b1;
//					4'd8:csa42_ram_flag[8]	<= 1'b1;
//					4'd9:csa42_ram_flag[9]	<= 1'b1;
//					4'd10:csa42_ram_flag[10]	<= 1'b1;
//					4'd11:csa42_ram_flag[11]	<= 1'b1;
//					4'd12:csa42_ram_flag[12]	<= 1'b1;
//					4'd13:csa42_ram_flag[13]	<= 1'b1;
//					4'd14:csa42_ram_flag[14]	<= 1'b1;
//					4'd15:csa42_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa42_ram_flag	<= csa42_ram_flag;
//			end
//		end
//		else if(send_state == CSA42_RD)
//		begin
//			csa42_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa42_ram_flag	<= csa42_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa43_din_en)
//		begin
//			if(csa43_din[32] == 1'b1)
//			begin
//				case(csa43_din[3:0])
//					4'd0:csa43_ram_flag[0]	<= 1'b1;
//					4'd1:csa43_ram_flag[1]	<= 1'b1;					
//					4'd2:csa43_ram_flag[2]	<= 1'b1;
//					4'd3:csa43_ram_flag[3]	<= 1'b1;
//					4'd4:csa43_ram_flag[4]	<= 1'b1;
//					4'd5:csa43_ram_flag[5]	<= 1'b1;
//					4'd6:csa43_ram_flag[6]	<= 1'b1;
//					4'd7:csa43_ram_flag[7]	<= 1'b1;
//					4'd8:csa43_ram_flag[8]	<= 1'b1;
//					4'd9:csa43_ram_flag[9]	<= 1'b1;
//					4'd10:csa43_ram_flag[10]	<= 1'b1;
//					4'd11:csa43_ram_flag[11]	<= 1'b1;
//					4'd12:csa43_ram_flag[12]	<= 1'b1;
//					4'd13:csa43_ram_flag[13]	<= 1'b1;
//					4'd14:csa43_ram_flag[14]	<= 1'b1;
//					4'd15:csa43_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa43_ram_flag	<= csa43_ram_flag;
//			end
//		end
//		else if(send_state == CSA43_RD)
//		begin
//			csa43_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa43_ram_flag	<= csa43_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa44_din_en)
//		begin
//			if(csa44_din[32] == 1'b1)
//			begin
//				case(csa44_din[3:0])
//					4'd0:csa44_ram_flag[0]	<= 1'b1;
//					4'd1:csa44_ram_flag[1]	<= 1'b1;					
//					4'd2:csa44_ram_flag[2]	<= 1'b1;
//					4'd3:csa44_ram_flag[3]	<= 1'b1;
//					4'd4:csa44_ram_flag[4]	<= 1'b1;
//					4'd5:csa44_ram_flag[5]	<= 1'b1;
//					4'd6:csa44_ram_flag[6]	<= 1'b1;
//					4'd7:csa44_ram_flag[7]	<= 1'b1;
//					4'd8:csa44_ram_flag[8]	<= 1'b1;
//					4'd9:csa44_ram_flag[9]	<= 1'b1;
//					4'd10:csa44_ram_flag[10]	<= 1'b1;
//					4'd11:csa44_ram_flag[11]	<= 1'b1;
//					4'd12:csa44_ram_flag[12]	<= 1'b1;
//					4'd13:csa44_ram_flag[13]	<= 1'b1;
//					4'd14:csa44_ram_flag[14]	<= 1'b1;
//					4'd15:csa44_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa44_ram_flag	<= csa44_ram_flag;
//			end
//		end
//		else if(send_state == CSA44_RD)
//		begin
//			csa44_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa44_ram_flag	<= csa44_ram_flag;
//		end
//	end
//	
//	
//	always @(posedge clk)
//	begin
//		if(csa45_din_en)
//		begin
//			if(csa45_din[32] == 1'b1)
//			begin
//				case(csa45_din[3:0])
//					4'd0:csa45_ram_flag[0]	<= 1'b1;
//					4'd1:csa45_ram_flag[1]	<= 1'b1;					
//					4'd2:csa45_ram_flag[2]	<= 1'b1;
//					4'd3:csa45_ram_flag[3]	<= 1'b1;
//					4'd4:csa45_ram_flag[4]	<= 1'b1;
//					4'd5:csa45_ram_flag[5]	<= 1'b1;
//					4'd6:csa45_ram_flag[6]	<= 1'b1;
//					4'd7:csa45_ram_flag[7]	<= 1'b1;
//					4'd8:csa45_ram_flag[8]	<= 1'b1;
//					4'd9:csa45_ram_flag[9]	<= 1'b1;
//					4'd10:csa45_ram_flag[10]	<= 1'b1;
//					4'd11:csa45_ram_flag[11]	<= 1'b1;
//					4'd12:csa45_ram_flag[12]	<= 1'b1;
//					4'd13:csa45_ram_flag[13]	<= 1'b1;
//					4'd14:csa45_ram_flag[14]	<= 1'b1;
//					4'd15:csa45_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa45_ram_flag	<= csa45_ram_flag;
//			end
//		end
//		else if(send_state == CSA45_RD)
//		begin
//			csa45_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa45_ram_flag	<= csa45_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa46_din_en)
//		begin
//			if(csa46_din[32] == 1'b1)
//			begin
//				case(csa46_din[3:0])
//					4'd0:csa46_ram_flag[0]	<= 1'b1;
//					4'd1:csa46_ram_flag[1]	<= 1'b1;					
//					4'd2:csa46_ram_flag[2]	<= 1'b1;
//					4'd3:csa46_ram_flag[3]	<= 1'b1;
//					4'd4:csa46_ram_flag[4]	<= 1'b1;
//					4'd5:csa46_ram_flag[5]	<= 1'b1;
//					4'd6:csa46_ram_flag[6]	<= 1'b1;
//					4'd7:csa46_ram_flag[7]	<= 1'b1;
//					4'd8:csa46_ram_flag[8]	<= 1'b1;
//					4'd9:csa46_ram_flag[9]	<= 1'b1;
//					4'd10:csa46_ram_flag[10]	<= 1'b1;
//					4'd11:csa46_ram_flag[11]	<= 1'b1;
//					4'd12:csa46_ram_flag[12]	<= 1'b1;
//					4'd13:csa46_ram_flag[13]	<= 1'b1;
//					4'd14:csa46_ram_flag[14]	<= 1'b1;
//					4'd15:csa46_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa46_ram_flag	<= csa46_ram_flag;
//			end
//		end
//		else if(send_state == CSA46_RD)
//		begin
//			csa46_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa46_ram_flag	<= csa46_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa47_din_en)
//		begin
//			if(csa47_din[32] == 1'b1)
//			begin
//				case(csa47_din[3:0])
//					4'd0:csa47_ram_flag[0]	<= 1'b1;
//					4'd1:csa47_ram_flag[1]	<= 1'b1;					
//					4'd2:csa47_ram_flag[2]	<= 1'b1;
//					4'd3:csa47_ram_flag[3]	<= 1'b1;
//					4'd4:csa47_ram_flag[4]	<= 1'b1;
//					4'd5:csa47_ram_flag[5]	<= 1'b1;
//					4'd6:csa47_ram_flag[6]	<= 1'b1;
//					4'd7:csa47_ram_flag[7]	<= 1'b1;
//					4'd8:csa47_ram_flag[8]	<= 1'b1;
//					4'd9:csa47_ram_flag[9]	<= 1'b1;
//					4'd10:csa47_ram_flag[10]	<= 1'b1;
//					4'd11:csa47_ram_flag[11]	<= 1'b1;
//					4'd12:csa47_ram_flag[12]	<= 1'b1;
//					4'd13:csa47_ram_flag[13]	<= 1'b1;
//					4'd14:csa47_ram_flag[14]	<= 1'b1;
//					4'd15:csa47_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa47_ram_flag	<= csa47_ram_flag;
//			end
//		end
//		else if(send_state == CSA47_RD)
//		begin
//			csa47_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa47_ram_flag	<= csa47_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa48_din_en)
//		begin
//			if(csa48_din[32] == 1'b1)
//			begin
//				case(csa48_din[3:0])
//					4'd0:csa48_ram_flag[0]	<= 1'b1;
//					4'd1:csa48_ram_flag[1]	<= 1'b1;					
//					4'd2:csa48_ram_flag[2]	<= 1'b1;
//					4'd3:csa48_ram_flag[3]	<= 1'b1;
//					4'd4:csa48_ram_flag[4]	<= 1'b1;
//					4'd5:csa48_ram_flag[5]	<= 1'b1;
//					4'd6:csa48_ram_flag[6]	<= 1'b1;
//					4'd7:csa48_ram_flag[7]	<= 1'b1;
//					4'd8:csa48_ram_flag[8]	<= 1'b1;
//					4'd9:csa48_ram_flag[9]	<= 1'b1;
//					4'd10:csa48_ram_flag[10]	<= 1'b1;
//					4'd11:csa48_ram_flag[11]	<= 1'b1;
//					4'd12:csa48_ram_flag[12]	<= 1'b1;
//					4'd13:csa48_ram_flag[13]	<= 1'b1;
//					4'd14:csa48_ram_flag[14]	<= 1'b1;
//					4'd15:csa48_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa48_ram_flag	<= csa48_ram_flag;
//			end
//		end
//		else if(send_state == CSA48_RD)
//		begin
//			csa48_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa48_ram_flag	<= csa48_ram_flag;
//		end
//	end
//	
//	
//	always @(posedge clk)
//	begin
//		if(csa49_din_en)
//		begin
//			if(csa49_din[32] == 1'b1)
//			begin
//				case(csa49_din[3:0])
//					4'd0:csa49_ram_flag[0]	<= 1'b1;
//					4'd1:csa49_ram_flag[1]	<= 1'b1;					
//					4'd2:csa49_ram_flag[2]	<= 1'b1;
//					4'd3:csa49_ram_flag[3]	<= 1'b1;
//					4'd4:csa49_ram_flag[4]	<= 1'b1;
//					4'd5:csa49_ram_flag[5]	<= 1'b1;
//					4'd6:csa49_ram_flag[6]	<= 1'b1;
//					4'd7:csa49_ram_flag[7]	<= 1'b1;
//					4'd8:csa49_ram_flag[8]	<= 1'b1;
//					4'd9:csa49_ram_flag[9]	<= 1'b1;
//					4'd10:csa49_ram_flag[10]	<= 1'b1;
//					4'd11:csa49_ram_flag[11]	<= 1'b1;
//					4'd12:csa49_ram_flag[12]	<= 1'b1;
//					4'd13:csa49_ram_flag[13]	<= 1'b1;
//					4'd14:csa49_ram_flag[14]	<= 1'b1;
//					4'd15:csa49_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa49_ram_flag	<= csa49_ram_flag;
//			end
//		end
//		else if(send_state == CSA49_RD)
//		begin
//			csa49_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa49_ram_flag	<= csa49_ram_flag;
//		end
//	end
//	
//	
//	always @(posedge clk)
//	begin
//		if(csa50_din_en)
//		begin
//			if(csa50_din[32] == 1'b1)
//			begin
//				case(csa50_din[3:0])
//					4'd0:csa50_ram_flag[0]	<= 1'b1;
//					4'd1:csa50_ram_flag[1]	<= 1'b1;					
//					4'd2:csa50_ram_flag[2]	<= 1'b1;
//					4'd3:csa50_ram_flag[3]	<= 1'b1;
//					4'd4:csa50_ram_flag[4]	<= 1'b1;
//					4'd5:csa50_ram_flag[5]	<= 1'b1;
//					4'd6:csa50_ram_flag[6]	<= 1'b1;
//					4'd7:csa50_ram_flag[7]	<= 1'b1;
//					4'd8:csa50_ram_flag[8]	<= 1'b1;
//					4'd9:csa50_ram_flag[9]	<= 1'b1;
//					4'd10:csa50_ram_flag[10]	<= 1'b1;
//					4'd11:csa50_ram_flag[11]	<= 1'b1;
//					4'd12:csa50_ram_flag[12]	<= 1'b1;
//					4'd13:csa50_ram_flag[13]	<= 1'b1;
//					4'd14:csa50_ram_flag[14]	<= 1'b1;
//					4'd15:csa50_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa50_ram_flag	<= csa50_ram_flag;
//			end
//		end
//		else if(send_state == CSA50_RD)
//		begin
//			csa50_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa50_ram_flag	<= csa50_ram_flag;
//		end
//	end
//	
//	
//	always @(posedge clk)
//	begin
//		if(csa51_din_en)
//		begin
//			if(csa51_din[32] == 1'b1)
//			begin
//				case(csa51_din[3:0])
//					4'd0:csa51_ram_flag[0]	<= 1'b1;
//					4'd1:csa51_ram_flag[1]	<= 1'b1;					
//					4'd2:csa51_ram_flag[2]	<= 1'b1;
//					4'd3:csa51_ram_flag[3]	<= 1'b1;
//					4'd4:csa51_ram_flag[4]	<= 1'b1;
//					4'd5:csa51_ram_flag[5]	<= 1'b1;
//					4'd6:csa51_ram_flag[6]	<= 1'b1;
//					4'd7:csa51_ram_flag[7]	<= 1'b1;
//					4'd8:csa51_ram_flag[8]	<= 1'b1;
//					4'd9:csa51_ram_flag[9]	<= 1'b1;
//					4'd10:csa51_ram_flag[10]	<= 1'b1;
//					4'd11:csa51_ram_flag[11]	<= 1'b1;
//					4'd12:csa51_ram_flag[12]	<= 1'b1;
//					4'd13:csa51_ram_flag[13]	<= 1'b1;
//					4'd14:csa51_ram_flag[14]	<= 1'b1;
//					4'd15:csa51_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa51_ram_flag	<= csa51_ram_flag;
//			end
//		end
//		else if(send_state == CSA51_RD)
//		begin
//			csa51_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa51_ram_flag	<= csa51_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa52_din_en)
//		begin
//			if(csa52_din[32] == 1'b1)
//			begin
//				case(csa52_din[3:0])
//					4'd0:csa52_ram_flag[0]	<= 1'b1;
//					4'd1:csa52_ram_flag[1]	<= 1'b1;					
//					4'd2:csa52_ram_flag[2]	<= 1'b1;
//					4'd3:csa52_ram_flag[3]	<= 1'b1;
//					4'd4:csa52_ram_flag[4]	<= 1'b1;
//					4'd5:csa52_ram_flag[5]	<= 1'b1;
//					4'd6:csa52_ram_flag[6]	<= 1'b1;
//					4'd7:csa52_ram_flag[7]	<= 1'b1;
//					4'd8:csa52_ram_flag[8]	<= 1'b1;
//					4'd9:csa52_ram_flag[9]	<= 1'b1;
//					4'd10:csa52_ram_flag[10]	<= 1'b1;
//					4'd11:csa52_ram_flag[11]	<= 1'b1;
//					4'd12:csa52_ram_flag[12]	<= 1'b1;
//					4'd13:csa52_ram_flag[13]	<= 1'b1;
//					4'd14:csa52_ram_flag[14]	<= 1'b1;
//					4'd15:csa52_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa52_ram_flag	<= csa52_ram_flag;
//			end
//		end
//		else if(send_state == CSA52_RD)
//		begin
//			csa52_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa52_ram_flag	<= csa52_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa53_din_en)
//		begin
//			if(csa53_din[32] == 1'b1)
//			begin
//				case(csa53_din[3:0])
//					4'd0:csa53_ram_flag[0]	<= 1'b1;
//					4'd1:csa53_ram_flag[1]	<= 1'b1;					
//					4'd2:csa53_ram_flag[2]	<= 1'b1;
//					4'd3:csa53_ram_flag[3]	<= 1'b1;
//					4'd4:csa53_ram_flag[4]	<= 1'b1;
//					4'd5:csa53_ram_flag[5]	<= 1'b1;
//					4'd6:csa53_ram_flag[6]	<= 1'b1;
//					4'd7:csa53_ram_flag[7]	<= 1'b1;
//					4'd8:csa53_ram_flag[8]	<= 1'b1;
//					4'd9:csa53_ram_flag[9]	<= 1'b1;
//					4'd10:csa53_ram_flag[10]	<= 1'b1;
//					4'd11:csa53_ram_flag[11]	<= 1'b1;
//					4'd12:csa53_ram_flag[12]	<= 1'b1;
//					4'd13:csa53_ram_flag[13]	<= 1'b1;
//					4'd14:csa53_ram_flag[14]	<= 1'b1;
//					4'd15:csa53_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa53_ram_flag	<= csa53_ram_flag;
//			end
//		end
//		else if(send_state == CSA53_RD)
//		begin
//			csa53_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa53_ram_flag	<= csa53_ram_flag;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		if(csa54_din_en)
//		begin
//			if(csa54_din[32] == 1'b1)
//			begin
//				case(csa54_din[3:0])
//					4'd0:csa54_ram_flag[0]	<= 1'b1;
//					4'd1:csa54_ram_flag[1]	<= 1'b1;					
//					4'd2:csa54_ram_flag[2]	<= 1'b1;
//					4'd3:csa54_ram_flag[3]	<= 1'b1;
//					4'd4:csa54_ram_flag[4]	<= 1'b1;
//					4'd5:csa54_ram_flag[5]	<= 1'b1;
//					4'd6:csa54_ram_flag[6]	<= 1'b1;
//					4'd7:csa54_ram_flag[7]	<= 1'b1;
//					4'd8:csa54_ram_flag[8]	<= 1'b1;
//					4'd9:csa54_ram_flag[9]	<= 1'b1;
//					4'd10:csa54_ram_flag[10]	<= 1'b1;
//					4'd11:csa54_ram_flag[11]	<= 1'b1;
//					4'd12:csa54_ram_flag[12]	<= 1'b1;
//					4'd13:csa54_ram_flag[13]	<= 1'b1;
//					4'd14:csa54_ram_flag[14]	<= 1'b1;
//					4'd15:csa54_ram_flag[15]	<= 1'b1;
//				endcase
//			end
//			else
//			begin
//				csa54_ram_flag	<= csa54_ram_flag;
//			end
//		end
//		else if(send_state == CSA54_RD)
//		begin
//			csa54_ram_flag[counter_prev]	<= 1'b0;
//		end
//		else
//		begin
//			csa54_ram_flag	<= csa54_ram_flag;
//		end
//	end
	
	
		
	always @(posedge clk)
	begin
		if(send_state == CSA1_RD)
		begin
			csa_ram_dout_r	<= csa1_ram_dout;
		end
		else if(send_state == CSA2_RD)
		begin
			csa_ram_dout_r	<= csa2_ram_dout;
		end
		else if(send_state == CSA3_RD)
		begin
			csa_ram_dout_r	<= csa3_ram_dout;
		end
		else if(send_state == CSA4_RD)
		begin
			csa_ram_dout_r	<= csa4_ram_dout;
		end
		else if(send_state == CSA5_RD)
		begin
			csa_ram_dout_r	<= csa5_ram_dout;
		end
		else if(send_state == CSA6_RD)
		begin
			csa_ram_dout_r	<= csa6_ram_dout;
		end
		else if(send_state == CSA7_RD)
		begin
			csa_ram_dout_r	<= csa7_ram_dout;
		end
		else if(send_state == CSA8_RD)
		begin
			csa_ram_dout_r	<= csa8_ram_dout;
		end
		else if(send_state == CSA9_RD)
		begin
			csa_ram_dout_r	<= csa9_ram_dout;
		end
		else if(send_state == CSA10_RD)
		begin
			csa_ram_dout_r	<= csa10_ram_dout;
		end
		else if(send_state == CSA11_RD)
		begin
			csa_ram_dout_r	<= csa11_ram_dout;
		end
		else if(send_state == CSA12_RD)
		begin
			csa_ram_dout_r	<= csa12_ram_dout;
		end
		else if(send_state == CSA13_RD)
		begin
			csa_ram_dout_r	<= csa13_ram_dout;
		end
		else if(send_state == CSA14_RD)
		begin
			csa_ram_dout_r	<= csa14_ram_dout;
		end
		else if(send_state == CSA15_RD)
		begin
			csa_ram_dout_r	<= csa15_ram_dout;
		end
		else if(send_state == CSA16_RD)
		begin
			csa_ram_dout_r	<= csa16_ram_dout;
		end
		else if(send_state == CSA17_RD)
		begin
			csa_ram_dout_r	<= csa17_ram_dout;
		end
		else if(send_state == CSA18_RD)
		begin
			csa_ram_dout_r	<= csa18_ram_dout;
		end
		else if(send_state == CSA19_RD)
		begin
			csa_ram_dout_r	<= csa19_ram_dout;
		end
		else if(send_state == CSA20_RD)
		begin
			csa_ram_dout_r	<= csa20_ram_dout;
		end
		else if(send_state == CSA21_RD)
		begin
			csa_ram_dout_r	<= csa21_ram_dout;
		end
		else if(send_state == CSA22_RD)
		begin
			csa_ram_dout_r	<= csa22_ram_dout;
		end
		else if(send_state == CSA23_RD)
		begin
			csa_ram_dout_r	<= csa23_ram_dout;
		end
		else if(send_state == CSA24_RD)
		begin
			csa_ram_dout_r	<= csa24_ram_dout;
		end
		else if(send_state == CSA25_RD)
		begin
			csa_ram_dout_r	<= csa25_ram_dout;
		end
		else if(send_state == CSA26_RD)
		begin
			csa_ram_dout_r	<= csa26_ram_dout;
		end
		else if(send_state == CSA27_RD)
		begin
			csa_ram_dout_r	<= csa27_ram_dout;
		end
		else if(send_state == CSA28_RD)
		begin
			csa_ram_dout_r	<= csa28_ram_dout;
		end
		else if(send_state == CSA29_RD)
		begin
			csa_ram_dout_r	<= csa29_ram_dout;
		end
		else if(send_state == CSA30_RD)
		begin
			csa_ram_dout_r	<= csa30_ram_dout;
		end
		else if(send_state == CSA31_RD)
		begin
			csa_ram_dout_r	<= csa31_ram_dout;
		end
		else if(send_state == CSA32_RD)
		begin
			csa_ram_dout_r	<= csa32_ram_dout;
		end
//		else if(send_state == CSA33_RD)
//		begin
//			csa_ram_dout_r	<= csa33_ram_dout;
//		end
//		else if(send_state == CSA34_RD)
//		begin
//			csa_ram_dout_r	<= csa34_ram_dout;
//		end
//		else if(send_state == CSA35_RD)
//		begin
//			csa_ram_dout_r	<= csa35_ram_dout;
//		end
//		else if(send_state == CSA36_RD)
//		begin
//			csa_ram_dout_r	<= csa36_ram_dout;
//		end
//		else if(send_state == CSA37_RD)
//		begin
//			csa_ram_dout_r	<= csa37_ram_dout;
//		end
//		else if(send_state == CSA38_RD)
//		begin
//			csa_ram_dout_r	<= csa38_ram_dout;
//		end
//		else if(send_state == CSA39_RD)
//		begin
//			csa_ram_dout_r	<= csa39_ram_dout;
//		end
//		else if(send_state == CSA40_RD)
//		begin
//			csa_ram_dout_r	<= csa40_ram_dout;
//		end
//		else if(send_state == CSA41_RD)
//		begin
//			csa_ram_dout_r	<= csa41_ram_dout;
//		end
//		else if(send_state == CSA42_RD)
//		begin
//			csa_ram_dout_r	<= csa42_ram_dout;
//		end
//		else if(send_state == CSA43_RD)
//		begin
//			csa_ram_dout_r	<= csa43_ram_dout;
//		end
//		else if(send_state == CSA44_RD)
//		begin
//			csa_ram_dout_r	<= csa44_ram_dout;
//		end
//		else if(send_state == CSA45_RD)
//		begin
//			csa_ram_dout_r	<= csa45_ram_dout;
//		end
//		else if(send_state == CSA46_RD)
//		begin
//			csa_ram_dout_r	<= csa46_ram_dout;
//		end
//		else if(send_state == CSA47_RD)
//		begin
//			csa_ram_dout_r	<= csa47_ram_dout;
//		end
//		else if(send_state == CSA48_RD)
//		begin
//			csa_ram_dout_r	<= csa48_ram_dout;
//		end
//		else if(send_state == CSA49_RD)
//		begin
//			csa_ram_dout_r	<= csa49_ram_dout;
//		end
//		else if(send_state == CSA50_RD)
//		begin
//			csa_ram_dout_r	<= csa50_ram_dout;
//		end
//		else if(send_state == CSA51_RD)
//		begin
//			csa_ram_dout_r	<= csa51_ram_dout;
//		end
//		else if(send_state == CSA52_RD)
//		begin
//			csa_ram_dout_r	<= csa52_ram_dout;
//		end
//		else if(send_state == CSA53_RD)
//		begin
//			csa_ram_dout_r	<= csa53_ram_dout;
//		end
//		else if(send_state == CSA54_RD)
//		begin
//			csa_ram_dout_r	<= csa54_ram_dout;
//		end	
		else
		begin
			csa_ram_dout_r	<= 0;
		end
	end
	

	
	always @(posedge clk)
	begin
		if(rd_cnt == 4)
			csa_dout	<= {1'b1, csa_ram_dout_r};
		else   
			csa_dout	<= {1'b0, csa_ram_dout_r};
	end
	
	always @(posedge clk)
	begin		
		if(rd_cnt > 3 && rd_cnt < 55)
		begin
			csa_dout_en	<= 1'b1;
		end
		else
		begin
			csa_dout_en	<= 1'b0;
		end
	end
	
	always @(posedge clk)
	begin
		if(send_state == CSA1_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa1_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa1_ram_addrb	<= csa1_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa1_ram_addrb	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(send_state == CSA2_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa2_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa2_ram_addrb	<= csa2_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa2_ram_addrb	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(send_state == CSA3_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa3_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa3_ram_addrb	<= csa3_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa3_ram_addrb	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(send_state == CSA4_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa4_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa4_ram_addrb	<= csa4_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa4_ram_addrb	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(send_state == CSA5_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa5_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa5_ram_addrb	<= csa5_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa5_ram_addrb	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(send_state == CSA6_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa6_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa6_ram_addrb	<= csa6_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa6_ram_addrb	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(send_state == CSA7_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa7_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa7_ram_addrb	<= csa7_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa7_ram_addrb	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(send_state == CSA8_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa8_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa8_ram_addrb	<= csa8_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa8_ram_addrb	<= 0;
		end
	end
	
	always @(posedge clk)
	begin
		if(send_state == CSA9_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa9_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa9_ram_addrb	<= csa9_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa9_ram_addrb	<= 0;
		end
	end
	
		always @(posedge clk)
	begin
		if(send_state == CSA10_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa10_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa10_ram_addrb	<= csa10_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa10_ram_addrb	<= 0;
		end
	end
	
		always @(posedge clk)
	begin
		if(send_state == CSA11_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa11_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa11_ram_addrb	<= csa11_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa11_ram_addrb	<= 0;
		end
	end
	
		always @(posedge clk)
	begin
		if(send_state == CSA12_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa12_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa12_ram_addrb	<= csa12_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa12_ram_addrb	<= 0;
		end
	end
	
		always @(posedge clk)
	begin
		if(send_state == CSA13_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa13_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa13_ram_addrb	<= csa13_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa13_ram_addrb	<= 0;
		end
	end
	
		always @(posedge clk)
	begin
		if(send_state == CSA14_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa14_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa14_ram_addrb	<= csa14_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa14_ram_addrb	<= 0;
		end
	end
	
		always @(posedge clk)
	begin
		if(send_state == CSA15_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa15_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa15_ram_addrb	<= csa15_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa15_ram_addrb	<= 0;
		end
	end
	
		
			always @(posedge clk)
	begin
		if(send_state == CSA16_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa16_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa16_ram_addrb	<= csa16_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa16_ram_addrb	<= 0;
		end
	end
		
			always @(posedge clk)
	begin
		if(send_state == CSA17_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa17_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa17_ram_addrb	<= csa17_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa17_ram_addrb	<= 10'b0;
		end
	end
		
			always @(posedge clk)
	begin
		if(send_state == CSA18_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa18_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa18_ram_addrb	<= csa18_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa18_ram_addrb	<= 10'b0;
		end
	end
		
			always @(posedge clk)
	begin
		if(send_state == CSA19_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa19_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa19_ram_addrb	<= csa19_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa19_ram_addrb	<= 10'b0;
		end
	end
		
		always @(posedge clk)
	begin
		if(send_state == CSA20_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa20_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa20_ram_addrb	<= csa20_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa20_ram_addrb	<= 10'b0;
		end
	end

			always @(posedge clk)
	begin
		if(send_state == CSA21_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa21_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa21_ram_addrb	<= csa21_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa21_ram_addrb	<= 10'b0;
		end
	end
		
			always @(posedge clk)
	begin
		if(send_state == CSA22_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa22_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa22_ram_addrb	<= csa22_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa22_ram_addrb	<= 10'b0;
		end
	end
		
		always @(posedge clk)
	begin
		if(send_state == CSA23_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa23_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa23_ram_addrb	<= csa23_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa23_ram_addrb	<= 10'b0;
		end
	end	
		
		always @(posedge clk)
	begin
		if(send_state == CSA24_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa24_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa24_ram_addrb	<= csa24_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa24_ram_addrb	<= 10'b0;
		end
	end	
		
		always @(posedge clk)
	begin
		if(send_state == CSA25_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa25_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa25_ram_addrb	<= csa25_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa25_ram_addrb	<= 10'b0;
		end
	end	
		
	
		always @(posedge clk)
	begin
		if(send_state == CSA26_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa26_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa26_ram_addrb	<= csa26_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa26_ram_addrb	<= 0;
		end
	end
		
			always @(posedge clk)
	begin
		if(send_state == CSA27_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa27_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa27_ram_addrb	<= csa27_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa27_ram_addrb	<= 10'b0;
		end
	end
		
			always @(posedge clk)
	begin
		if(send_state == CSA28_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa28_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa28_ram_addrb	<= csa28_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa28_ram_addrb	<= 10'b0;
		end
	end
		
			always @(posedge clk)
	begin
		if(send_state == CSA29_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa29_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa29_ram_addrb	<= csa29_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa29_ram_addrb	<= 10'b0;
		end
	end
		
		always @(posedge clk)
	begin
		if(send_state == CSA30_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa30_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa30_ram_addrb	<= csa30_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa30_ram_addrb	<= 10'b0;
		end
	end

			always @(posedge clk)
	begin
		if(send_state == CSA31_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa31_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa31_ram_addrb	<= csa31_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa31_ram_addrb	<= 10'b0;
		end
	end
		
			always @(posedge clk)
	begin
		if(send_state == CSA32_RD)
		begin
			if(rd_cnt == 0)
			begin
				csa32_ram_addrb	<= {counter,6'b0};
			end
			else
			begin
				csa32_ram_addrb	<= csa32_ram_addrb + 10'b1;
			end
		end
		else
		begin
			csa32_ram_addrb	<= 10'b0;
		end
	end
		
//		always @(posedge clk)
//	begin
//		if(send_state == CSA33_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa33_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa33_ram_addrb	<= csa33_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa33_ram_addrb	<= 10'b0;
//		end
//	end		
//	
//			
//			always @(posedge clk)
//	begin
//		if(send_state == CSA34_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa34_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa34_ram_addrb	<= csa34_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa34_ram_addrb	<= 10'b0;
//		end
//	end		
//		
//				
//		always @(posedge clk)
//	begin
//		if(send_state == CSA35_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa35_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa35_ram_addrb	<= csa35_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa35_ram_addrb	<= 10'b0;
//		end
//	end		
//		
//		
//				
//		always @(posedge clk)
//	begin
//		if(send_state == CSA36_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa36_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa36_ram_addrb	<= csa36_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa36_ram_addrb	<= 10'b0;
//		end
//	end		
//		
//				
//		always @(posedge clk)
//	begin
//		if(send_state == CSA37_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa37_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa37_ram_addrb	<= csa37_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa37_ram_addrb	<= 10'b0;
//		end
//	end		
//		
//				
//		always @(posedge clk)
//	begin
//		if(send_state == CSA38_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa38_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa38_ram_addrb	<= csa38_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa38_ram_addrb	<= 10'b0;
//		end
//	end		
//		
//				
//		always @(posedge clk)
//	begin
//		if(send_state == CSA39_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa39_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa39_ram_addrb	<= csa39_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa39_ram_addrb	<= 10'b0;
//		end
//	end		
//		
//	always @(posedge clk)
//	begin
//		if(send_state == CSA40_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa40_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa40_ram_addrb	<= csa40_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa40_ram_addrb	<= 10'b0;
//		end
//	end
//
//			always @(posedge clk)
//	begin
//		if(send_state == CSA41_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa41_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa41_ram_addrb	<= csa41_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa41_ram_addrb	<= 10'b0;
//		end
//	end
//		
//			always @(posedge clk)
//	begin
//		if(send_state == CSA42_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa42_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa42_ram_addrb	<= csa42_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa42_ram_addrb	<= 10'b0;
//		end
//	end
//		
//		always @(posedge clk)
//	begin
//		if(send_state == CSA43_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa43_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa43_ram_addrb	<= csa43_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa43_ram_addrb	<= 10'b0;
//		end
//	end		
//	
//			
//			always @(posedge clk)
//	begin
//		if(send_state == CSA44_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa44_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa44_ram_addrb	<= csa44_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa44_ram_addrb	<= 10'b0;
//		end
//	end		
//		
//				
//		always @(posedge clk)
//	begin
//		if(send_state == CSA45_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa45_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa45_ram_addrb	<= csa45_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa45_ram_addrb	<= 10'b0;
//		end
//	end		
//		
//		
//				
//		always @(posedge clk)
//	begin
//		if(send_state == CSA46_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa46_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa46_ram_addrb	<= csa46_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa46_ram_addrb	<= 10'b0;
//		end
//	end		
//		
//				
//		always @(posedge clk)
//	begin
//		if(send_state == CSA47_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa47_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa47_ram_addrb	<= csa47_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa47_ram_addrb	<= 10'b0;
//		end
//	end		
//		
//				
//		always @(posedge clk)
//	begin
//		if(send_state == CSA48_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa48_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa48_ram_addrb	<= csa48_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa48_ram_addrb	<= 10'b0;
//		end
//	end		
//		
//				
//		always @(posedge clk)
//	begin
//		if(send_state == CSA49_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa49_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa49_ram_addrb	<= csa49_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa49_ram_addrb	<= 10'b0;
//		end
//	end		
//			
//		
//always @(posedge clk)
//	begin
//		if(send_state == CSA50_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa50_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa50_ram_addrb	<= csa50_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa50_ram_addrb	<= 10'b0;
//		end
//	end
//
//			always @(posedge clk)
//	begin
//		if(send_state == CSA51_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa51_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa51_ram_addrb	<= csa51_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa51_ram_addrb	<= 10'b0;
//		end
//	end
//		
//			always @(posedge clk)
//	begin
//		if(send_state == CSA52_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa52_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa52_ram_addrb	<= csa52_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa52_ram_addrb	<= 10'b0;
//		end
//	end
//		
//		always @(posedge clk)
//	begin
//		if(send_state == CSA53_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa53_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa53_ram_addrb	<= csa53_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa53_ram_addrb	<= 10'b0;
//		end
//	end		
//	
//			
//			always @(posedge clk)
//	begin
//		if(send_state == CSA54_RD)
//		begin
//			if(rd_cnt == 0)
//			begin
//				csa54_ram_addrb	<= {counter,6'b0};
//			end
//			else
//			begin
//				csa54_ram_addrb	<= csa54_ram_addrb + 10'b1;
//			end
//		end
//		else
//		begin
//			csa54_ram_addrb	<= 10'b0;
//		end
//	end		
	
		
	always @(posedge clk)
	begin
		if(csa1_din_en)
		begin
			if(csa1_din[32] == 1'b1)
			begin
				csa1_ram_addra	<= {csa1_din[3:0],6'b0};
			end
			else
			begin
				csa1_ram_addra	<= csa1_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa1_ram_addra	<= csa1_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa1_ram_din	<= csa1_din[31:0];
		csa1_ram_wr		<= csa1_din_en;
	end
	
	always @(posedge clk)
	begin
		if(csa2_din_en)
		begin
			if(csa2_din[32] == 1'b1)
			begin
				csa2_ram_addra	<= {csa2_din[3:0],6'b0};
			end
			else
			begin
				csa2_ram_addra	<= csa2_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa2_ram_addra	<= csa2_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa2_ram_din	<= csa2_din[31:0];
		csa2_ram_wr		<= csa2_din_en;
	end
	
	always @(posedge clk)
	begin
		if(csa3_din_en)
		begin
			if(csa3_din[32] == 1'b1)
			begin
				csa3_ram_addra	<= {csa3_din[3:0],6'b0};
			end
			else
			begin
				csa3_ram_addra	<= csa3_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa3_ram_addra	<= csa3_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa3_ram_din	<= csa3_din[31:0];
		csa3_ram_wr		<= csa3_din_en;
	end
	
	always @(posedge clk)
	begin
		if(csa4_din_en)
		begin
			if(csa4_din[32] == 1'b1)
			begin
				csa4_ram_addra	<= {csa4_din[3:0],6'b0};
			end
			else
			begin
				csa4_ram_addra	<= csa4_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa4_ram_addra	<= csa4_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa4_ram_din	<= csa4_din[31:0];
		csa4_ram_wr		<= csa4_din_en;
	end
	
	always @(posedge clk)
	begin
		if(csa5_din_en)
		begin
			if(csa5_din[32] == 1'b1)
			begin
				csa5_ram_addra	<= {csa5_din[3:0],6'b0};
			end
			else
			begin
				csa5_ram_addra	<= csa5_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa5_ram_addra	<= csa5_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa5_ram_din	<= csa5_din[31:0];
		csa5_ram_wr		<= csa5_din_en;
	end
	
	always @(posedge clk)
	begin
		if(csa6_din_en)
		begin
			if(csa6_din[32] == 1'b1)
			begin
				csa6_ram_addra	<= {csa6_din[3:0],6'b0};
			end
			else
			begin
				csa6_ram_addra	<= csa6_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa6_ram_addra	<= csa6_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa6_ram_din	<= csa6_din[31:0];
		csa6_ram_wr		<= csa6_din_en;
	end
	
	always @(posedge clk)
	begin
		if(csa7_din_en)
		begin
			if(csa7_din[32] == 1'b1)
			begin
				csa7_ram_addra	<= {csa7_din[3:0],6'b0};
			end
			else
			begin
				csa7_ram_addra	<= csa7_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa7_ram_addra	<= csa7_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa7_ram_din	<= csa7_din[31:0];
		csa7_ram_wr		<= csa7_din_en;
	end
	
	always @(posedge clk)
	begin
		if(csa8_din_en)
		begin
			if(csa8_din[32] == 1'b1)
			begin
				csa8_ram_addra	<= {csa8_din[3:0],6'b0};
			end
			else
			begin
				csa8_ram_addra	<= csa8_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa8_ram_addra	<= csa8_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa8_ram_din	<= csa8_din[31:0];
		csa8_ram_wr		<= csa8_din_en;
	end
	
	always @(posedge clk)
	begin
		if(csa9_din_en)
		begin
			if(csa9_din[32] == 1'b1)
			begin
				csa9_ram_addra	<= {csa9_din[3:0],6'b0};
			end
			else
			begin
				csa9_ram_addra	<= csa9_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa9_ram_addra	<= csa9_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa9_ram_din	<= csa9_din[31:0];
		csa9_ram_wr		<= csa9_din_en;
	end
	
	
		always @(posedge clk)
	begin
		if(csa10_din_en)
		begin
			if(csa10_din[32] == 1'b1)
			begin
				csa10_ram_addra	<= {csa10_din[3:0],6'b0};
			end
			else
			begin
				csa10_ram_addra	<= csa10_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa10_ram_addra	<= csa10_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa10_ram_din	<= csa10_din[31:0];
		csa10_ram_wr		<= csa10_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa11_din_en)
		begin
			if(csa11_din[32] == 1'b1)
			begin
				csa11_ram_addra	<= {csa11_din[3:0],6'b0};
			end
			else
			begin
				csa11_ram_addra	<= csa11_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa11_ram_addra	<= csa11_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa11_ram_din	<= csa11_din[31:0];
		csa11_ram_wr		<= csa11_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa12_din_en)
		begin
			if(csa12_din[32] == 1'b1)
			begin
				csa12_ram_addra	<= {csa12_din[3:0],6'b0};
			end
			else
			begin
				csa12_ram_addra	<= csa12_ram_addra +10'b 1;
			end
		end
		else
		begin
			csa12_ram_addra	<= csa12_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa12_ram_din	<= csa12_din[31:0];
		csa12_ram_wr		<= csa12_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa13_din_en)
		begin
			if(csa13_din[32] == 1'b1)
			begin
				csa13_ram_addra	<= {csa13_din[3:0],6'b0};
			end
			else
			begin
				csa13_ram_addra	<= csa13_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa13_ram_addra	<= csa13_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa13_ram_din	<= csa13_din[31:0];
		csa13_ram_wr		<= csa13_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa14_din_en)
		begin
			if(csa14_din[32] == 1'b1)
			begin
				csa14_ram_addra	<= {csa14_din[3:0],6'b0};
			end
			else
			begin
				csa14_ram_addra	<= csa14_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa14_ram_addra	<= csa14_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa14_ram_din	<= csa14_din[31:0];
		csa14_ram_wr		<= csa14_din_en;
	end
	
	
		always @(posedge clk)
	begin
		if(csa15_din_en)
		begin
			if(csa15_din[32] == 1'b1)
			begin
				csa15_ram_addra	<= {csa15_din[3:0],6'b0};
			end
			else
			begin
				csa15_ram_addra	<= csa15_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa15_ram_addra	<= csa15_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa15_ram_din	<= csa15_din[31:0];
		csa15_ram_wr		<= csa15_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa16_din_en)
		begin
			if(csa16_din[32] == 1'b1)
			begin
				csa16_ram_addra	<= {csa16_din[3:0],6'b0};
			end
			else
			begin
				csa16_ram_addra	<= csa16_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa16_ram_addra	<= csa16_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa16_ram_din	<= csa16_din[31:0];
		csa16_ram_wr		<= csa16_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa17_din_en)
		begin
			if(csa17_din[32] == 1'b1)
			begin
				csa17_ram_addra	<= {csa17_din[3:0],6'b0};
			end
			else
			begin
				csa17_ram_addra	<= csa17_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa17_ram_addra	<= csa17_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa17_ram_din	<= csa17_din[31:0];
		csa17_ram_wr		<= csa17_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa18_din_en)
		begin
			if(csa18_din[32] == 1'b1)
			begin
				csa18_ram_addra	<= {csa18_din[3:0],6'b0};
			end
			else
			begin
				csa18_ram_addra	<= csa18_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa18_ram_addra	<= csa18_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa18_ram_din	<= csa18_din[31:0];
		csa18_ram_wr		<= csa18_din_en;
	end
	
	
		always @(posedge clk)
	begin
		if(csa19_din_en)
		begin
			if(csa19_din[32] == 1'b1)
			begin
				csa19_ram_addra	<= {csa19_din[3:0],6'b0};
			end
			else
			begin
				csa19_ram_addra	<= csa19_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa19_ram_addra	<= csa19_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa19_ram_din	<= csa19_din[31:0];
		csa19_ram_wr		<= csa19_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa20_din_en)
		begin
			if(csa20_din[32] == 1'b1)
			begin
				csa20_ram_addra	<= {csa20_din[3:0],6'b0};
			end
			else
			begin
				csa20_ram_addra	<= csa20_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa20_ram_addra	<= csa20_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa20_ram_din	<= csa20_din[31:0];
		csa20_ram_wr		<= csa20_din_en;
	end
	
	
		always @(posedge clk)
	begin
		if(csa21_din_en)
		begin
			if(csa21_din[32] == 1'b1)
			begin
				csa21_ram_addra	<= {csa21_din[3:0],6'b0};
			end
			else
			begin
				csa21_ram_addra	<= csa21_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa21_ram_addra	<= csa21_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa21_ram_din	<= csa21_din[31:0];
		csa21_ram_wr		<= csa21_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa22_din_en)
		begin
			if(csa22_din[32] == 1'b1)
			begin
				csa22_ram_addra	<= {csa22_din[3:0],6'b0};
			end
			else
			begin
				csa22_ram_addra	<= csa22_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa22_ram_addra	<= csa22_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa22_ram_din	<= csa22_din[31:0];
		csa22_ram_wr		<= csa22_din_en;
	end
	
	
		always @(posedge clk)
	begin
		if(csa23_din_en)
		begin
			if(csa23_din[32] == 1'b1)
			begin
				csa23_ram_addra	<= {csa23_din[3:0],6'b0};
			end
			else
			begin
				csa23_ram_addra	<= csa23_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa23_ram_addra	<= csa23_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa23_ram_din	<= csa23_din[31:0];
		csa23_ram_wr		<= csa23_din_en;
	end
	
	
		always @(posedge clk)
	begin
		if(csa24_din_en)
		begin
			if(csa24_din[32] == 1'b1)
			begin
				csa24_ram_addra	<= {csa24_din[3:0],6'b0};
			end
			else
			begin
				csa24_ram_addra	<= csa24_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa24_ram_addra	<= csa24_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa24_ram_din	<= csa24_din[31:0];
		csa24_ram_wr		<= csa24_din_en;
	end
	
	
		always @(posedge clk)
	begin
		if(csa25_din_en)
		begin
			if(csa25_din[32] == 1'b1)
			begin
				csa25_ram_addra	<= {csa25_din[3:0],6'b0};
			end
			else
			begin
				csa25_ram_addra	<= csa25_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa25_ram_addra	<= csa25_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa25_ram_din	<= csa25_din[31:0];
		csa25_ram_wr		<= csa25_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa26_din_en)
		begin
			if(csa26_din[32] == 1'b1)
			begin
				csa26_ram_addra	<= {csa26_din[3:0],6'b0};
			end
			else
			begin
				csa26_ram_addra	<= csa26_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa26_ram_addra	<= csa26_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa26_ram_din	<= csa26_din[31:0];
		csa26_ram_wr		<= csa26_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa27_din_en)
		begin
			if(csa27_din[32] == 1'b1)
			begin
				csa27_ram_addra	<= {csa27_din[3:0],6'b0};
			end
			else
			begin
				csa27_ram_addra	<= csa27_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa27_ram_addra	<= csa27_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa27_ram_din	<= csa27_din[31:0];
		csa27_ram_wr		<= csa27_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa28_din_en)
		begin
			if(csa28_din[32] == 1'b1)
			begin
				csa28_ram_addra	<= {csa28_din[3:0],6'b0};
			end
			else
			begin
				csa28_ram_addra	<= csa28_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa28_ram_addra	<= csa28_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa28_ram_din	<= csa28_din[31:0];
		csa28_ram_wr		<= csa28_din_en;
	end
	
	
		always @(posedge clk)
	begin
		if(csa29_din_en)
		begin
			if(csa29_din[32] == 1'b1)
			begin
				csa29_ram_addra	<= {csa29_din[3:0],6'b0};
			end
			else
			begin
				csa29_ram_addra	<= csa29_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa29_ram_addra	<= csa29_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa29_ram_din	<= csa29_din[31:0];
		csa29_ram_wr		<= csa29_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa30_din_en)
		begin
			if(csa30_din[32] == 1'b1)
			begin
				csa30_ram_addra	<= {csa30_din[3:0],6'b0};
			end
			else
			begin
				csa30_ram_addra	<= csa30_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa30_ram_addra	<= csa30_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa30_ram_din	<= csa30_din[31:0];
		csa30_ram_wr		<= csa30_din_en;
	end
	
	
		always @(posedge clk)
	begin
		if(csa31_din_en)
		begin
			if(csa31_din[32] == 1'b1)
			begin
				csa31_ram_addra	<= {csa31_din[3:0],6'b0};
			end
			else
			begin
				csa31_ram_addra	<= csa31_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa31_ram_addra	<= csa31_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa31_ram_din	<= csa31_din[31:0];
		csa31_ram_wr		<= csa31_din_en;
	end
	
		always @(posedge clk)
	begin
		if(csa32_din_en)
		begin
			if(csa32_din[32] == 1'b1)
			begin
				csa32_ram_addra	<= {csa32_din[3:0],6'b0};
			end
			else
			begin
				csa32_ram_addra	<= csa32_ram_addra + 10'b1;
			end
		end
		else
		begin
			csa32_ram_addra	<= csa32_ram_addra;
		end
	end
	
	always @(posedge clk)
	begin
		csa32_ram_din	<= csa32_din[31:0];
		csa32_ram_wr		<= csa32_din_en;
	end
	
//	
//		always @(posedge clk)
//	begin
//		if(csa33_din_en)
//		begin
//			if(csa33_din[32] == 1'b1)
//			begin
//				csa33_ram_addra	<= {csa33_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa33_ram_addra	<= csa33_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa33_ram_addra	<= csa33_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa33_ram_din	<= csa33_din[31:0];
//		csa33_ram_wr		<= csa33_din_en;
//	end
//	
//		always @(posedge clk)
//	begin
//		if(csa34_din_en)
//		begin
//			if(csa34_din[32] == 1'b1)
//			begin
//				csa34_ram_addra	<= {csa34_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa34_ram_addra	<= csa34_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa34_ram_addra	<= csa34_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa34_ram_din	<= csa34_din[31:0];
//		csa34_ram_wr		<= csa34_din_en;
//	end
//	
//	
//		always @(posedge clk)
//	begin
//		if(csa35_din_en)
//		begin
//			if(csa35_din[32] == 1'b1)
//			begin
//				csa35_ram_addra	<= {csa35_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa35_ram_addra	<= csa35_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa35_ram_addra	<= csa35_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa35_ram_din	<= csa35_din[31:0];
//		csa35_ram_wr		<= csa35_din_en;
//	end
//	
//		always @(posedge clk)
//	begin
//		if(csa36_din_en)
//		begin
//			if(csa36_din[32] == 1'b1)
//			begin
//				csa36_ram_addra	<= {csa36_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa36_ram_addra	<= csa36_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa36_ram_addra	<= csa36_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa36_ram_din	<= csa36_din[31:0];
//		csa36_ram_wr		<= csa36_din_en;
//	end
//	
//		always @(posedge clk)
//	begin
//		if(csa37_din_en)
//		begin
//			if(csa37_din[32] == 1'b1)
//			begin
//				csa37_ram_addra	<= {csa37_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa37_ram_addra	<= csa37_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa37_ram_addra	<= csa37_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa37_ram_din	<= csa37_din[31:0];
//		csa37_ram_wr		<= csa37_din_en;
//	end
//	
//		always @(posedge clk)
//	begin
//		if(csa38_din_en)
//		begin
//			if(csa38_din[32] == 1'b1)
//			begin
//				csa38_ram_addra	<= {csa38_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa38_ram_addra	<= csa38_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa38_ram_addra	<= csa38_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa38_ram_din	<= csa38_din[31:0];
//		csa38_ram_wr		<= csa38_din_en;
//	end
//	
//	
//		always @(posedge clk)
//	begin
//		if(csa39_din_en)
//		begin
//			if(csa39_din[32] == 1'b1)
//			begin
//				csa39_ram_addra	<= {csa39_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa39_ram_addra	<= csa39_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa39_ram_addra	<= csa39_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa39_ram_din	<= csa39_din[31:0];
//		csa39_ram_wr		<= csa39_din_en;
//	end
//		
//	
//		always @(posedge clk)
//	begin
//		if(csa40_din_en)
//		begin
//			if(csa40_din[32] == 1'b1)
//			begin
//				csa40_ram_addra	<= {csa40_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa40_ram_addra	<= csa40_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa40_ram_addra	<= csa40_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa40_ram_din	<= csa40_din[31:0];
//		csa40_ram_wr		<= csa40_din_en;
//	end
//	
//	
//		always @(posedge clk)
//	begin
//		if(csa41_din_en)
//		begin
//			if(csa41_din[32] == 1'b1)
//			begin
//				csa41_ram_addra	<= {csa41_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa41_ram_addra	<= csa41_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa41_ram_addra	<= csa41_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa41_ram_din	<= csa41_din[31:0];
//		csa41_ram_wr		<= csa41_din_en;
//	end
//	
//		always @(posedge clk)
//	begin
//		if(csa42_din_en)
//		begin
//			if(csa42_din[32] == 1'b1)
//			begin
//				csa42_ram_addra	<= {csa42_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa42_ram_addra	<= csa42_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa42_ram_addra	<= csa42_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa42_ram_din	<= csa42_din[31:0];
//		csa42_ram_wr		<= csa42_din_en;
//	end
//	
//	
//		always @(posedge clk)
//	begin
//		if(csa43_din_en)
//		begin
//			if(csa43_din[32] == 1'b1)
//			begin
//				csa43_ram_addra	<= {csa43_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa43_ram_addra	<= csa43_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa43_ram_addra	<= csa43_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa43_ram_din	<= csa43_din[31:0];
//		csa43_ram_wr		<= csa43_din_en;
//	end
//	
//	
//		always @(posedge clk)
//	begin
//		if(csa44_din_en)
//		begin
//			if(csa44_din[32] == 1'b1)
//			begin
//				csa44_ram_addra	<= {csa44_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa44_ram_addra	<= csa44_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa44_ram_addra	<= csa44_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa44_ram_din	<= csa44_din[31:0];
//		csa44_ram_wr		<= csa44_din_en;
//	end
//	
//	
//		always @(posedge clk)
//	begin
//		if(csa45_din_en)
//		begin
//			if(csa45_din[32] == 1'b1)
//			begin
//				csa45_ram_addra	<= {csa45_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa45_ram_addra	<= csa45_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa45_ram_addra	<= csa45_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa45_ram_din	<= csa45_din[31:0];
//		csa45_ram_wr		<= csa45_din_en;
//	end
//	
//		always @(posedge clk)
//	begin
//		if(csa46_din_en)
//		begin
//			if(csa46_din[32] == 1'b1)
//			begin
//				csa46_ram_addra	<= {csa46_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa46_ram_addra	<= csa46_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa46_ram_addra	<= csa46_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa46_ram_din	<= csa46_din[31:0];
//		csa46_ram_wr		<= csa46_din_en;
//	end
//	
//		always @(posedge clk)
//	begin
//		if(csa47_din_en)
//		begin
//			if(csa47_din[32] == 1'b1)
//			begin
//				csa47_ram_addra	<= {csa47_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa47_ram_addra	<= csa47_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa47_ram_addra	<= csa47_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa47_ram_din	<= csa47_din[31:0];
//		csa47_ram_wr		<= csa47_din_en;
//	end
//	
//		always @(posedge clk)
//	begin
//		if(csa48_din_en)
//		begin
//			if(csa48_din[32] == 1'b1)
//			begin
//				csa48_ram_addra	<= {csa48_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa48_ram_addra	<= csa48_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa48_ram_addra	<= csa48_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa48_ram_din	<= csa48_din[31:0];
//		csa48_ram_wr		<= csa48_din_en;
//	end
//	
//	
//		always @(posedge clk)
//	begin
//		if(csa49_din_en)
//		begin
//			if(csa49_din[32] == 1'b1)
//			begin
//				csa49_ram_addra	<= {csa49_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa49_ram_addra	<= csa49_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa49_ram_addra	<= csa49_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa49_ram_din	<= csa49_din[31:0];
//		csa49_ram_wr		<= csa49_din_en;
//	end
//	
//		always @(posedge clk)
//	begin
//		if(csa50_din_en)
//		begin
//			if(csa50_din[32] == 1'b1)
//			begin
//				csa50_ram_addra	<= {csa50_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa50_ram_addra	<= csa50_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa50_ram_addra	<= csa50_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa50_ram_din	<= csa50_din[31:0];
//		csa50_ram_wr		<= csa50_din_en;
//	end
//	
//	
//		always @(posedge clk)
//	begin
//		if(csa51_din_en)
//		begin
//			if(csa51_din[32] == 1'b1)
//			begin
//				csa51_ram_addra	<= {csa51_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa51_ram_addra	<= csa51_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa51_ram_addra	<= csa51_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa51_ram_din	<= csa51_din[31:0];
//		csa51_ram_wr		<= csa51_din_en;
//	end
//	
//		always @(posedge clk)
//	begin
//		if(csa52_din_en)
//		begin
//			if(csa52_din[32] == 1'b1)
//			begin
//				csa52_ram_addra	<= {csa52_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa52_ram_addra	<= csa52_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa52_ram_addra	<= csa52_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa52_ram_din	<= csa52_din[31:0];
//		csa52_ram_wr		<= csa52_din_en;
//	end
//	
//	
//		always @(posedge clk)
//	begin
//		if(csa53_din_en)
//		begin
//			if(csa53_din[32] == 1'b1)
//			begin
//				csa53_ram_addra	<= {csa53_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa53_ram_addra	<= csa53_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa53_ram_addra	<= csa53_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa53_ram_din	<= csa53_din[31:0];
//		csa53_ram_wr		<= csa53_din_en;
//	end
//	
//	
//		always @(posedge clk)
//	begin
//		if(csa54_din_en)
//		begin
//			if(csa54_din[32] == 1'b1)
//			begin
//				csa54_ram_addra	<= {csa54_din[3:0],6'b0};
//			end
//			else
//			begin
//				csa54_ram_addra	<= csa54_ram_addra + 10'b1;
//			end
//		end
//		else
//		begin
//			csa54_ram_addra	<= csa54_ram_addra;
//		end
//	end
//	
//	always @(posedge clk)
//	begin
//		csa54_ram_din	<= csa54_din[31:0];
//		csa54_ram_wr		<= csa54_din_en;
//	end
//	
//	
	
	csa_combo_ram	csa1_ram(
		.clka				(clk),
		.dina				(csa1_ram_din),
		.addra				(csa1_ram_addra),
		.wea				(csa1_ram_wr),
		.clkb				(clk),
		.addrb				(csa1_ram_addrb),
		.doutb              (csa1_ram_dout)
		);
		
	csa_combo_ram	csa2_ram(
		.clka				(clk),
		.dina				(csa2_ram_din),
		.addra				(csa2_ram_addra),
		.wea				(csa2_ram_wr),
		.clkb				(clk),
		.addrb				(csa2_ram_addrb),
		.doutb              (csa2_ram_dout)
		);
		
	csa_combo_ram	csa3_ram(
		.clka				(clk),
		.dina				(csa3_ram_din),
		.addra				(csa3_ram_addra),
		.wea				(csa3_ram_wr),
		.clkb				(clk),
		.addrb				(csa3_ram_addrb),
		.doutb              (csa3_ram_dout)
		);
		
	csa_combo_ram	csa4_ram(
		.clka				(clk),
		.dina				(csa4_ram_din),
		.addra				(csa4_ram_addra),
		.wea				(csa4_ram_wr),
		.clkb				(clk),
		.addrb				(csa4_ram_addrb),
		.doutb              (csa4_ram_dout)
		);
		
	csa_combo_ram	csa5_ram(
		.clka				(clk),
		.dina				(csa5_ram_din),
		.addra				(csa5_ram_addra),
		.wea				(csa5_ram_wr),
		.clkb				(clk),
		.addrb				(csa5_ram_addrb),
		.doutb              (csa5_ram_dout)
		);
		
	csa_combo_ram	csa6_ram(
		.clka				(clk),
		.dina				(csa6_ram_din),
		.addra				(csa6_ram_addra),
		.wea				(csa6_ram_wr),
		.clkb				(clk),
		.addrb				(csa6_ram_addrb),
		.doutb              (csa6_ram_dout)
		);
		
	csa_combo_ram	csa7_ram(
		.clka				(clk),
		.dina				(csa7_ram_din),
		.addra				(csa7_ram_addra),
		.wea				(csa7_ram_wr),
		.clkb				(clk),
		.addrb				(csa7_ram_addrb),
		.doutb              (csa7_ram_dout)
		);
		
	csa_combo_ram	csa8_ram(
		.clka				(clk),
		.dina				(csa8_ram_din),
		.addra				(csa8_ram_addra),
		.wea				(csa8_ram_wr),
		.clkb				(clk),
		.addrb				(csa8_ram_addrb),
		.doutb              (csa8_ram_dout)
		);
		
	csa_combo_ram	csa9_ram(
		.clka				(clk),
		.dina				(csa9_ram_din),
		.addra			(csa9_ram_addra),
		.wea				(csa9_ram_wr),
		.clkb				(clk),
		.addrb			(csa9_ram_addrb),
		.doutb      (csa9_ram_dout)
		);
		
		
		csa_combo_ram	csa10_ram(
		.clka				(clk),
		.dina				(csa10_ram_din),
		.addra			(csa10_ram_addra),
		.wea				(csa10_ram_wr),
		.clkb				(clk),
		.addrb			(csa10_ram_addrb),
		.doutb      (csa10_ram_dout)
		);
		
		csa_combo_ram	csa11_ram(
		.clka				(clk),
		.dina				(csa11_ram_din),
		.addra			(csa11_ram_addra),
		.wea				(csa11_ram_wr),
		.clkb				(clk),
		.addrb			(csa11_ram_addrb),
		.doutb      (csa11_ram_dout)
		);
		
		csa_combo_ram	csa12_ram(
		.clka				(clk),
		.dina				(csa12_ram_din),
		.addra			(csa12_ram_addra),
		.wea				(csa12_ram_wr),
		.clkb				(clk),
		.addrb			(csa12_ram_addrb),
		.doutb      (csa12_ram_dout)
		);
		
		csa_combo_ram	csa13_ram(
		.clka				(clk),
		.dina				(csa13_ram_din),
		.addra			(csa13_ram_addra),
		.wea				(csa13_ram_wr),
		.clkb				(clk),
		.addrb			(csa13_ram_addrb),
		.doutb      (csa13_ram_dout)
		);
		
		csa_combo_ram	csa14_ram(
		.clka				(clk),
		.dina				(csa14_ram_din),
		.addra			(csa14_ram_addra),
		.wea				(csa14_ram_wr),
		.clkb				(clk),
		.addrb			(csa14_ram_addrb),
		.doutb      (csa14_ram_dout)
		);
		
		csa_combo_ram	csa15_ram(
		.clka				(clk),
		.dina				(csa15_ram_din),
		.addra			(csa15_ram_addra),
		.wea				(csa15_ram_wr),
		.clkb				(clk),
		.addrb			(csa15_ram_addrb),
		.doutb      (csa15_ram_dout)
		);
	
		
		csa_combo_ram	csa16_ram(
		.clka				(clk),
		.dina				(csa16_ram_din),
		.addra			(csa16_ram_addra),
		.wea				(csa16_ram_wr),
		.clkb				(clk),
		.addrb			(csa16_ram_addrb),
		.doutb      (csa16_ram_dout)
		);
		
		csa_combo_ram	csa17_ram(
		.clka				(clk),
		.dina				(csa17_ram_din),
		.addra			(csa17_ram_addra),
		.wea				(csa17_ram_wr),
		.clkb				(clk),
		.addrb			(csa17_ram_addrb),
		.doutb      (csa17_ram_dout)
		);
	
		
		csa_combo_ram	csa18_ram(
		.clka				(clk),
		.dina				(csa18_ram_din),
		.addra			(csa18_ram_addra),
		.wea				(csa18_ram_wr),
		.clkb				(clk),
		.addrb			(csa18_ram_addrb),
		.doutb      (csa18_ram_dout)
		);
	
		
		csa_combo_ram	csa19_ram(
		.clka				(clk),
		.dina				(csa19_ram_din),
		.addra			(csa19_ram_addra),
		.wea				(csa19_ram_wr),
		.clkb				(clk),
		.addrb			(csa19_ram_addrb),
		.doutb      (csa19_ram_dout)
		);
		
		
			
		csa_combo_ram	csa20_ram(
		.clka				(clk),
		.dina				(csa20_ram_din),
		.addra			(csa20_ram_addra),
		.wea				(csa20_ram_wr),
		.clkb				(clk),
		.addrb			(csa20_ram_addrb),
		.doutb      (csa20_ram_dout)
		);
		
			
		csa_combo_ram	csa21_ram(
		.clka				(clk),
		.dina				(csa21_ram_din),
		.addra			(csa21_ram_addra),
		.wea				(csa21_ram_wr),
		.clkb				(clk),
		.addrb			(csa21_ram_addrb),
		.doutb      (csa21_ram_dout)
		);
		
		
			
		csa_combo_ram	csa22_ram(
		.clka				(clk),
		.dina				(csa22_ram_din),
		.addra			(csa22_ram_addra),
		.wea				(csa22_ram_wr),
		.clkb				(clk),
		.addrb			(csa22_ram_addrb),
		.doutb      (csa22_ram_dout)
		);
		
		
			
		csa_combo_ram	csa23_ram(
		.clka				(clk),
		.dina				(csa23_ram_din),
		.addra			(csa23_ram_addra),
		.wea				(csa23_ram_wr),
		.clkb				(clk),
		.addrb			(csa23_ram_addrb),
		.doutb      (csa23_ram_dout)
		);
		
		
			
		csa_combo_ram	csa24_ram(
		.clka				(clk),
		.dina				(csa24_ram_din),
		.addra			(csa24_ram_addra),
		.wea				(csa24_ram_wr),
		.clkb				(clk),
		.addrb			(csa24_ram_addrb),
		.doutb      (csa24_ram_dout)
		);
		
	
		
		csa_combo_ram	csa25_ram(
		.clka				(clk),
		.dina				(csa25_ram_din),
		.addra			(csa25_ram_addra),
		.wea				(csa25_ram_wr),
		.clkb				(clk),
		.addrb			(csa25_ram_addrb),
		.doutb      (csa25_ram_dout)
		);
	
	csa_combo_ram	csa26_ram(
		.clka				(clk),
		.dina				(csa26_ram_din),
		.addra			(csa26_ram_addra),
		.wea				(csa26_ram_wr),
		.clkb				(clk),
		.addrb			(csa26_ram_addrb),
		.doutb      (csa26_ram_dout)
		);
		
		csa_combo_ram	csa27_ram(
		.clka				(clk),
		.dina				(csa27_ram_din),
		.addra			(csa27_ram_addra),
		.wea				(csa27_ram_wr),
		.clkb				(clk),
		.addrb			(csa27_ram_addrb),
		.doutb      (csa27_ram_dout)
		);
	
		
		csa_combo_ram	csa28_ram(
		.clka				(clk),
		.dina				(csa28_ram_din),
		.addra			(csa28_ram_addra),
		.wea				(csa28_ram_wr),
		.clkb				(clk),
		.addrb			(csa28_ram_addrb),
		.doutb      (csa28_ram_dout)
		);
	
		
		csa_combo_ram	csa29_ram(
		.clka				(clk),
		.dina				(csa29_ram_din),
		.addra			(csa29_ram_addra),
		.wea				(csa29_ram_wr),
		.clkb				(clk),
		.addrb			(csa29_ram_addrb),
		.doutb      (csa29_ram_dout)
		);
		
		
			
		csa_combo_ram	csa30_ram(
		.clka				(clk),
		.dina				(csa30_ram_din),
		.addra			(csa30_ram_addra),
		.wea				(csa30_ram_wr),
		.clkb				(clk),
		.addrb			(csa30_ram_addrb),
		.doutb      (csa30_ram_dout)
		);
		
			
		csa_combo_ram	csa31_ram(
		.clka				(clk),
		.dina				(csa31_ram_din),
		.addra			(csa31_ram_addra),
		.wea				(csa31_ram_wr),
		.clkb				(clk),
		.addrb			(csa31_ram_addrb),
		.doutb      (csa31_ram_dout)
		);
		
		
			
		csa_combo_ram	csa32_ram(
		.clka				(clk),
		.dina				(csa32_ram_din),
		.addra			(csa32_ram_addra),
		.wea				(csa32_ram_wr),
		.clkb				(clk),
		.addrb			(csa32_ram_addrb),
		.doutb      (csa32_ram_dout)
		);
		
//		
//			
//		csa_combo_ram	csa33_ram(
//		.clka				(clk),
//		.dina				(csa33_ram_din),
//		.addra			(csa33_ram_addra),
//		.wea				(csa33_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa33_ram_addrb),
//		.doutb      (csa33_ram_dout)
//		);
//		
//		csa_combo_ram	csa34_ram(
//		.clka				(clk),
//		.dina				(csa34_ram_din),
//		.addra			(csa34_ram_addra),
//		.wea				(csa34_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa34_ram_addrb),
//		.doutb      (csa34_ram_dout)
//		);
//		
//	
//		
//		csa_combo_ram	csa35_ram(
//		.clka				(clk),
//		.dina				(csa35_ram_din),
//		.addra			(csa35_ram_addra),
//		.wea				(csa35_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa35_ram_addrb),
//		.doutb      (csa35_ram_dout)
//		);
//	
//	csa_combo_ram	csa36_ram(
//		.clka				(clk),
//		.dina				(csa36_ram_din),
//		.addra			(csa36_ram_addra),
//		.wea				(csa36_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa36_ram_addrb),
//		.doutb      (csa36_ram_dout)
//		);
//		
//		csa_combo_ram	csa37_ram(
//		.clka				(clk),
//		.dina				(csa37_ram_din),
//		.addra			(csa37_ram_addra),
//		.wea				(csa37_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa37_ram_addrb),
//		.doutb      (csa37_ram_dout)
//		);
//	
//		
//		csa_combo_ram	csa38_ram(
//		.clka				(clk),
//		.dina				(csa38_ram_din),
//		.addra			(csa38_ram_addra),
//		.wea				(csa38_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa38_ram_addrb),
//		.doutb      (csa38_ram_dout)
//		);
//	
//		
//		csa_combo_ram	csa39_ram(
//		.clka				(clk),
//		.dina				(csa39_ram_din),
//		.addra			(csa39_ram_addra),
//		.wea				(csa39_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa39_ram_addrb),
//		.doutb      (csa39_ram_dout)
//		);
//		
//		
//		csa_combo_ram	csa40_ram(
//		.clka				(clk),
//		.dina				(csa40_ram_din),
//		.addra			(csa40_ram_addra),
//		.wea				(csa40_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa40_ram_addrb),
//		.doutb      (csa40_ram_dout)
//		);
//		
//			
//		csa_combo_ram	csa41_ram(
//		.clka				(clk),
//		.dina				(csa41_ram_din),
//		.addra			(csa41_ram_addra),
//		.wea				(csa41_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa41_ram_addrb),
//		.doutb      (csa41_ram_dout)
//		);
//		
//		
//			
//		csa_combo_ram	csa42_ram(
//		.clka				(clk),
//		.dina				(csa42_ram_din),
//		.addra			(csa42_ram_addra),
//		.wea				(csa42_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa42_ram_addrb),
//		.doutb      (csa42_ram_dout)
//		);
//		
//		
//			
//		csa_combo_ram	csa43_ram(
//		.clka				(clk),
//		.dina				(csa43_ram_din),
//		.addra			(csa43_ram_addra),
//		.wea				(csa43_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa43_ram_addrb),
//		.doutb      (csa43_ram_dout)
//		);
//		
//		
//			
//		csa_combo_ram	csa44_ram(
//		.clka				(clk),
//		.dina				(csa44_ram_din),
//		.addra			(csa44_ram_addra),
//		.wea				(csa44_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa44_ram_addrb),
//		.doutb      (csa44_ram_dout)
//		);
//		
//	
//		
//		csa_combo_ram	csa45_ram(
//		.clka				(clk),
//		.dina				(csa45_ram_din),
//		.addra			(csa45_ram_addra),
//		.wea				(csa45_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa45_ram_addrb),
//		.doutb      (csa45_ram_dout)
//		);
//	
//	csa_combo_ram	csa46_ram(
//		.clka				(clk),
//		.dina				(csa46_ram_din),
//		.addra			(csa46_ram_addra),
//		.wea				(csa46_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa46_ram_addrb),
//		.doutb      (csa46_ram_dout)
//		);
//		
//		csa_combo_ram	csa47_ram(
//		.clka				(clk),
//		.dina				(csa47_ram_din),
//		.addra			(csa47_ram_addra),
//		.wea				(csa47_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa47_ram_addrb),
//		.doutb      (csa47_ram_dout)
//		);
//	
//		
//		csa_combo_ram	csa48_ram(
//		.clka				(clk),
//		.dina				(csa48_ram_din),
//		.addra			(csa48_ram_addra),
//		.wea				(csa48_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa48_ram_addrb),
//		.doutb      (csa48_ram_dout)
//		);
//	
//		
//		csa_combo_ram	csa49_ram(
//		.clka				(clk),
//		.dina				(csa49_ram_din),
//		.addra			(csa49_ram_addra),
//		.wea				(csa49_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa49_ram_addrb),
//		.doutb      (csa49_ram_dout)
//		);
//		
//		csa_combo_ram	csa50_ram(
//		.clka				(clk),
//		.dina				(csa50_ram_din),
//		.addra			(csa50_ram_addra),
//		.wea				(csa50_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa50_ram_addrb),
//		.doutb      (csa50_ram_dout)
//		);
//		
//			
//		csa_combo_ram	csa51_ram(
//		.clka				(clk),
//		.dina				(csa51_ram_din),
//		.addra			(csa51_ram_addra),
//		.wea				(csa51_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa51_ram_addrb),
//		.doutb      (csa51_ram_dout)
//		);
//		
//		
//			
//		csa_combo_ram	csa52_ram(
//		.clka				(clk),
//		.dina				(csa52_ram_din),
//		.addra			(csa52_ram_addra),
//		.wea				(csa52_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa52_ram_addrb),
//		.doutb      (csa52_ram_dout)
//		);
//		
//		
//			
//		csa_combo_ram	csa53_ram(
//		.clka				(clk),
//		.dina				(csa53_ram_din),
//		.addra			(csa53_ram_addra),
//		.wea				(csa53_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa53_ram_addrb),
//		.doutb      (csa53_ram_dout)
//		);
//		
//		
//			
//		csa_combo_ram	csa54_ram(
//		.clka				(clk),
//		.dina				(csa54_ram_din),
//		.addra			(csa54_ram_addra),
//		.wea				(csa54_ram_wr),
//		.clkb				(clk),
//		.addrb			(csa54_ram_addrb),
//		.doutb      (csa54_ram_dout)
//		);
//		
//	
//		
	
endmodule

