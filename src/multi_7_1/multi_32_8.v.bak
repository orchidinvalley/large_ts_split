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
	
	din_32bit_5,
	din_32bit_5_en,
	
	din_32bit_6,
	din_32bit_6_en,
	
	din_32bit_7,
	din_32bit_7_en,
	
	din_32bit_8,
	din_32bit_8_en,
	
	din_32bit_9,
	din_32bit_9_en,
	
	din_32bit_10,
	din_32bit_10_en,
	
	din_32bit_11,
	din_32bit_11_en,
	
	din_32bit_12,
	din_32bit_12_en,
	
	din_32bit_13,
	din_32bit_13_en,
	
	din_32bit_14,
	din_32bit_14_en,
	
	din_32bit_15,
	din_32bit_15_en,
	
	din_32bit_16,
	din_32bit_16_en,
	
	din_32bit_17,
	din_32bit_17_en,
	
	din_32bit_18,
	din_32bit_18_en,
	
	din_32bit_19,
	din_32bit_19_en,
	
	din_32bit_20,
	din_32bit_20_en,
	
	dout_8bit_1,
	dout_8bit_1_en,
	
	dout_8bit_2,
	dout_8bit_2_en,
	
	dout_8bit_3,
	dout_8bit_3_en,
	
	dout_8bit_4,
	dout_8bit_4_en,
	
	dout_8bit_5,
	dout_8bit_5_en,
	
	dout_8bit_6,
	dout_8bit_6_en,
	
	dout_8bit_7,
	dout_8bit_7_en,
	
	dout_8bit_8,
	dout_8bit_8_en,
	
	dout_8bit_9,
	dout_8bit_9_en,
	
	dout_8bit_10,
	dout_8bit_10_en,
	
	dout_8bit_11,
	dout_8bit_11_en,
	
	dout_8bit_12,
	dout_8bit_12_en,
	
	dout_8bit_13,
	dout_8bit_13_en,
	
	dout_8bit_14,
	dout_8bit_14_en,
	
	dout_8bit_15,
	dout_8bit_15_en,
	
	dout_8bit_16,
	dout_8bit_16_en,
	
	dout_32bit_1,
	dout_32bit_1_en,
	
	dout_32bit_2,
	dout_32bit_2_en,
	
	dout_32bit_3,
	dout_32bit_3_en,
	
	dout_32bit_4,
	dout_32bit_4_en
	
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
    
    input		[31:0]	din_32bit_5;
	input				din_32bit_5_en;
    
    input		[31:0]	din_32bit_6;
	input				din_32bit_6_en;
    
    input		[31:0]	din_32bit_7;
	input				din_32bit_7_en;
    
    input		[31:0]	din_32bit_8;
	input				din_32bit_8_en;
    
    input		[31:0]	din_32bit_9;
	input				din_32bit_9_en;
    
    input		[31:0]	din_32bit_10;
	input				din_32bit_10_en;
    
    input		[31:0]	din_32bit_11;
	input				din_32bit_11_en;
    
    input		[31:0]	din_32bit_12;
	input				din_32bit_12_en;
    
    input		[31:0]	din_32bit_13;
	input				din_32bit_13_en;
    
    input		[31:0]	din_32bit_14;
	input				din_32bit_14_en;
    
    input		[31:0]	din_32bit_15;
	input				din_32bit_15_en;
    
    input		[31:0]	din_32bit_16;
	input				din_32bit_16_en;
    
    input		[31:0]	din_32bit_17;
	input				din_32bit_17_en;
    
    input		[31:0]	din_32bit_18;
	input				din_32bit_18_en;
    
    input		[31:0]	din_32bit_19;
	input				din_32bit_19_en;
    
    input		[31:0]	din_32bit_20;
	input				din_32bit_20_en;
	
	output		[7:0]	dout_8bit_1;
	output				dout_8bit_1_en;
	
	output		[7:0]	dout_8bit_2;
	output				dout_8bit_2_en;
	
	output		[7:0]	dout_8bit_3;
	output				dout_8bit_3_en;
	
	output		[7:0]	dout_8bit_4;
	output				dout_8bit_4_en;
	
	output		[7:0]	dout_8bit_5;
	output				dout_8bit_5_en;
    
    output		[7:0]	dout_8bit_6;
	output				dout_8bit_6_en;
    
    output		[7:0]	dout_8bit_7;
	output				dout_8bit_7_en;
    
    output		[7:0]	dout_8bit_8;
	output				dout_8bit_8_en;
    
    output		[7:0]	dout_8bit_9;
	output				dout_8bit_9_en;
    
    output		[7:0]	dout_8bit_10;
	output				dout_8bit_10_en;
    
    output		[7:0]	dout_8bit_11;
	output				dout_8bit_11_en;
    
    output		[7:0]	dout_8bit_12;
	output				dout_8bit_12_en;
    
    output		[7:0]	dout_8bit_13;
	output				dout_8bit_13_en;
    
    output		[7:0]	dout_8bit_14;
	output				dout_8bit_14_en;
    
    output		[7:0]	dout_8bit_15;
	output				dout_8bit_15_en;
    
    output		[7:0]	dout_8bit_16;
	output				dout_8bit_16_en;
	
	output		[31:0]	dout_32bit_1;
	output				dout_32bit_1_en;
    
    output		[31:0]	dout_32bit_2;
	output				dout_32bit_2_en;
    
    output		[31:0]	dout_32bit_3;
	output				dout_32bit_3_en;
    
    output		[31:0]	dout_32bit_4;
	output				dout_32bit_4_en;
 
 
assign	dout_32bit_1 = din_32bit_17;
assign	dout_32bit_1_en = din_32bit_17_en;

assign	dout_32bit_2 = din_32bit_18;
assign	dout_32bit_2_en = din_32bit_18_en;

assign	dout_32bit_3 = din_32bit_19;
assign	dout_32bit_3_en = din_32bit_19_en;

assign	dout_32bit_4 = din_32bit_20;
assign	dout_32bit_4_en = din_32bit_20_en;
    
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

trans_32_8_variable		trans_32_8_variable_inst5
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_5		),
	.din_32bit_en		(din_32bit_5_en		),
	            		             
	.dout_8bit			(dout_8bit_5		),
	.dout_8bit_en		(dout_8bit_5_en		)
		
);

trans_32_8_variable		trans_32_8_variable_inst6
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_6		),
	.din_32bit_en		(din_32bit_6_en		),
	            		             
	.dout_8bit			(dout_8bit_6		),
	.dout_8bit_en		(dout_8bit_6_en		)
		
);

trans_32_8_variable		trans_32_8_variable_inst7
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_7		),
	.din_32bit_en		(din_32bit_7_en		),
	            		             
	.dout_8bit			(dout_8bit_7		),
	.dout_8bit_en		(dout_8bit_7_en		)
		
);

trans_32_8_variable		trans_32_8_variable_inst8
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_8		),
	.din_32bit_en		(din_32bit_8_en		),
	            		             
	.dout_8bit			(dout_8bit_8		),
	.dout_8bit_en		(dout_8bit_8_en		)
		
);

trans_32_8_variable		trans_32_8_variable_inst9
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_9		),
	.din_32bit_en		(din_32bit_9_en		),
	            		             
	.dout_8bit			(dout_8bit_9		),
	.dout_8bit_en		(dout_8bit_9_en		)
		
);

trans_32_8_variable		trans_32_8_variable_inst10
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_10		),
	.din_32bit_en		(din_32bit_10_en	),
	            		             
	.dout_8bit			(dout_8bit_10		),
	.dout_8bit_en		(dout_8bit_10_en	)
		
);

trans_32_8_variable		trans_32_8_variable_inst11
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_11		),
	.din_32bit_en		(din_32bit_11_en	),
	            		             
	.dout_8bit			(dout_8bit_11		),
	.dout_8bit_en		(dout_8bit_11_en	)
		
);

trans_32_8_variable		trans_32_8_variable_inst12
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_12		),
	.din_32bit_en		(din_32bit_12_en	),
	            		             
	.dout_8bit			(dout_8bit_12		),
	.dout_8bit_en		(dout_8bit_12_en	)
		
);

trans_32_8_variable		trans_32_8_variable_inst13
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_13		),
	.din_32bit_en		(din_32bit_13_en	),
	            		             
	.dout_8bit			(dout_8bit_13		),
	.dout_8bit_en		(dout_8bit_13_en	)
		
);

trans_32_8_variable		trans_32_8_variable_inst14
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_14		),
	.din_32bit_en		(din_32bit_14_en	),
	            		             
	.dout_8bit			(dout_8bit_14		),
	.dout_8bit_en		(dout_8bit_14_en	)
		
);

trans_32_8_variable		trans_32_8_variable_inst15
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_15		),
	.din_32bit_en		(din_32bit_15_en	),
	            		             
	.dout_8bit			(dout_8bit_15		),
	.dout_8bit_en		(dout_8bit_15_en	)
		
);

trans_32_8_variable		trans_32_8_variable_inst16
(

	.clk				(clk				),
	.rst				(rst				),
	            		
	.din_32bit			(din_32bit_16		),
	.din_32bit_en		(din_32bit_16_en	),
	            		             
	.dout_8bit			(dout_8bit_16		),
	.dout_8bit_en		(dout_8bit_16_en	)
		
);




endmodule
