`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:20:58 01/12/2012 
// Design Name: 
// Module Name:    multi_32_8 
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
module multi_32_8_variable(

	clk,
	rst,
	
	din_32bit_1,
	din_32bit_1_en,
	
	din_32bit_2,
	din_32bit_2_en,
	
	din_32bit_3,
	din_32bit_3_en,
	
	din_32bit_4,
	din_32bit_4_en,
	
	
	
	dout_8bit_1,
	dout_8bit_1_en,
	
	dout_8bit_2,
	dout_8bit_2_en,
	
	dout_8bit_3,
	dout_8bit_3_en,
	
	dout_8bit_4,
	dout_8bit_4_en
	
    );
    
    input				clk;
	input				rst;
	
	input		[31:0]	din_32bit_1;
	input				din_32bit_1_en;
    
    input		[31:0]	din_32bit_2;
	input				din_32bit_2_en;
    
    input		[31:0]	din_32bit_3;
	input				din_32bit_3_en;
    
    input		[31:0]	din_32bit_4;
	input				din_32bit_4_en;
    
	
	output		[7:0]	dout_8bit_1;
	output				dout_8bit_1_en;
	
	output		[7:0]	dout_8bit_2;
	output				dout_8bit_2_en;
	
	output		[7:0]	dout_8bit_3;
	output				dout_8bit_3_en;
	
	output		[7:0]	dout_8bit_4;
	output				dout_8bit_4_en;
	
	
 

    
trans_32_8_variable		trans_32_8_variable_inst1
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_1		),
	.din_32bit_en		(din_32bit_1_en		),
	            		             
	.dout_8bit			(dout_8bit_1		),
	.dout_8bit_en		(dout_8bit_1_en		)
		
);

trans_32_8_variable		trans_32_8_variable_inst2
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_2		),
	.din_32bit_en		(din_32bit_2_en		),
	            		             
	.dout_8bit			(dout_8bit_2		),
	.dout_8bit_en		(dout_8bit_2_en		)
		
);

trans_32_8_variable		trans_32_8_variable_inst3
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_3		),
	.din_32bit_en		(din_32bit_3_en		),
	            		             
	.dout_8bit			(dout_8bit_3		),
	.dout_8bit_en		(dout_8bit_3_en		)
		
);

trans_32_8_variable		trans_32_8_variable_inst4
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_4		),
	.din_32bit_en		(din_32bit_4_en		),
	            		             
	.dout_8bit			(dout_8bit_4		),
	.dout_8bit_en		(dout_8bit_4_en		)
		
);




endmodule
