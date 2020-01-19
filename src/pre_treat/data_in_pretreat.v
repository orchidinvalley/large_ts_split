`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:21:41 04/22/2011 
// Design Name: 
// Module Name:    data_in_pretreat 
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
module data_in_pretreat
(
	input				clk					,
	input				reset				,
	input		[7:0]	data_in_sfp1		,
	input				data_in_sfp1_valid	,
	input		[7:0]	data_in_sfp2		,
	input				data_in_sfp2_valid	,
	input		[7:0]	data_in_sfp3		,
	input				data_in_sfp3_valid	,
	input		[7:0]	data_in_sfp4		,
	input				data_in_sfp4_valid	,

	output  	[32:0]	data_out			,
	output				data_out_valid	    ,
	output				test_flag       

);

//-----------------------------------------------------

    wire	[32:0] data_sfp1		    ;
    wire		   data_sfp1_valid	    ;
    wire	[32:0] data_sfp2		    ;
    wire		   data_sfp2_valid	    ; 
    wire	[32:0] data_sfp3		    ; 
	wire		   data_sfp3_valid	    ; 
	wire	[32:0] data_sfp4		    ; 
	wire		   data_sfp4_valid	    ; 

	

                    
    wire		   rd_ack1				;		    
    wire		   rd_ack2		        ;
    wire		   rd_ack3		        ;
    wire		   rd_ack4		    	;
   
    
                   
//-----------------------------------------------------        
        
sfp_rec_8to32 #
(
	.SFP_IN_NUM (0)
)
sfp_rec_8to32_init1
(
	.clk				(clk				),
	.reset				(reset				),
	.data_in_sfp		(data_in_sfp1		),
	.data_in_sfp_valid	(data_in_sfp1_valid	),
	.rd_ack				(rd_ack1			),
	.data_out			(data_sfp1		    ),
	.data_out_valid	    (data_sfp1_valid	)
);  

sfp_rec_8to32#
(
	.SFP_IN_NUM (1)
)
sfp_rec_8to32_init2
(
	.clk				(clk				),
	.reset				(reset				),
	.data_in_sfp		(data_in_sfp2		),
	.data_in_sfp_valid	(data_in_sfp2_valid	),
	.rd_ack				(rd_ack2			),
	.data_out			(data_sfp2		    ),
	.data_out_valid	    (data_sfp2_valid	)
);  

sfp_rec_8to32#
(
	.SFP_IN_NUM (2)
)
sfp_rec_8to32_init3
(
	.clk				(clk				),
	.reset				(reset				),
	.data_in_sfp		(data_in_sfp3		),
	.data_in_sfp_valid	(data_in_sfp3_valid ),
	.rd_ack				(rd_ack3			),
	.data_out			(data_sfp3		    ),
	.data_out_valid	    (data_sfp3_valid	)
);  

sfp_rec_8to32#
(
	.SFP_IN_NUM (3)
)
sfp_rec_8to32_init4
(
	.clk				(clk				),
	.reset				(reset				),
	.data_in_sfp		(data_in_sfp4		),
	.data_in_sfp_valid	(data_in_sfp4_valid ),
	.rd_ack				(rd_ack4			),
	.data_out			(data_sfp4		    ),
	.data_out_valid	    (data_sfp4_valid	)
);  



channel_8t1_33b			channel_8t1_33b_init
(
	.clk				(clk				),
	.reset				(reset				),
	.data_in1			(data_sfp1		    ),
	.data_in1_valid		(data_sfp1_valid	),
	.data_in2			(data_sfp2		    ),
	.data_in2_valid		(data_sfp2_valid	),
	.data_in3			(data_sfp3		    ),
	.data_in3_valid		(data_sfp3_valid	),
	.data_in4			(data_sfp4		    ),
	.data_in4_valid		(data_sfp4_valid	),
	
		                
	.rd_ack1			(rd_ack1			),
	.rd_ack2			(rd_ack2			),
	.rd_ack3			(rd_ack3			),
	.rd_ack4			(rd_ack4			),

                  
	.data_out			(data_out			),
	.data_out_valid		(data_out_valid		),
	.test_flag			(test_flag			)
);

endmodule