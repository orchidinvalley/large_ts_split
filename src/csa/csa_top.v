`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:35:07 03/18/2010 
// Design Name: 
// Module Name:    csa_top 
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
module csa_top(
    	clk_main,
    
		rst,
		
		ts_din,//ts流输入，Pid序号+gbe+4IP+4PORT+188包，PORT高2字节无实际意义只为凑数,32位并行输入
		ts_din_en,
		
		con_din,//命令输入
		con_din_en,
		
		ts_dout,//加扰流输出，32位并行输出
		ts_dout_en,
		ecm_addr_dout,//ECM内存地址
		ecm_addr_dout_en,
		ecm_ddr_dout,//ECM包送往内存，4字节地址+ECM包内容
		ecm_ddr_dout_en,
		emm_dout,//EMM包输出，每次到来后立即发送，不进行存储
		emm_dout_en,
		emm_send,
		emm_send_en,
		
		erro_flag
		);

	input			clk_main, rst;	
	input	[31:0]	ts_din;
	input			ts_din_en;
	
	input	[7:0]	con_din;
	input			con_din_en;
	
	output	[32:0]	ts_dout;
	output			ts_dout_en;
	output	[35:0]	ecm_addr_dout;
	output			ecm_addr_dout_en;
	output	[7:0]	ecm_ddr_dout;
	output			ecm_ddr_dout_en;
	output	[8:0]	emm_dout;
	output			emm_dout_en;
	output	[8:0]	emm_send;
	output			emm_send_en;
	
	output			erro_flag;
	
	wire	[7:0]	cw_con_dout;
	wire	[7:0]	pid_con_dout;
	wire	[7:0]	ecm_con_dout;
	wire	[15:0]	ecm_con_addr;
	
	wire	[32:0]	pre_ts_dout;
	wire	[32:0]	tx_ts1_dout;
	wire	[32:0]	tx_ts2_dout;
	wire	[32:0]	tx_ts3_dout;
	wire	[32:0]	tx_ts4_dout;
	wire	[32:0]	tx_ts5_dout;
	wire	[32:0]	tx_ts6_dout;
	wire	[32:0]	tx_ts7_dout;
	wire	[32:0]	tx_ts8_dout;
	wire	[32:0]	tx_ts9_dout;
	wire	[32:0]	tx_ts10_dout;
	wire	[32:0]	tx_ts11_dout;
	wire	[32:0]	tx_ts12_dout;
	wire	[32:0]	tx_ts13_dout;
	wire	[32:0]	tx_ts14_dout;
	wire	[32:0]	tx_ts15_dout;
	wire	[32:0]	tx_ts16_dout;
	wire	[32:0]	tx_ts17_dout;
	wire	[32:0]	tx_ts18_dout;
	wire	[32:0]	tx_ts19_dout;
	wire	[32:0]	tx_ts20_dout;
	wire	[32:0]	tx_ts21_dout;
	wire	[32:0]	tx_ts22_dout;
	wire	[32:0]	tx_ts23_dout;
	wire	[32:0]	tx_ts24_dout;
	wire	[32:0]	tx_ts25_dout;
	wire	[32:0]	tx_ts26_dout;
	wire	[32:0]	tx_ts27_dout;
	wire	[32:0]	tx_ts28_dout;
	wire	[32:0]	tx_ts29_dout;
	wire	[32:0]	tx_ts30_dout;
	wire	[32:0]	tx_ts31_dout;
	wire	[32:0]	tx_ts32_dout;
//	wire	[32:0]	tx_ts33_dout;
//	wire	[32:0]	tx_ts34_dout;
//	wire	[32:0]	tx_ts35_dout;
//	wire	[32:0]	tx_ts36_dout;
//	wire	[32:0]	tx_ts37_dout;
//	wire	[32:0]	tx_ts38_dout;
//	wire	[32:0]	tx_ts39_dout;
//	wire	[32:0]	tx_ts40_dout;
//	wire	[32:0]	tx_ts41_dout;
//	wire	[32:0]	tx_ts42_dout;
//	wire	[32:0]	tx_ts43_dout;
//	wire	[32:0]	tx_ts44_dout;
//	wire	[32:0]	tx_ts45_dout;
//	wire	[32:0]	tx_ts46_dout;
//	wire	[32:0]	tx_ts47_dout;
//	wire	[32:0]	tx_ts48_dout;
//	wire	[32:0]	tx_ts49_dout;
//	wire	[32:0]	tx_ts50_dout;
//	wire	[32:0]	tx_ts51_dout;
//	wire	[32:0]	tx_ts52_dout;
//	wire	[32:0]	tx_ts53_dout;
//	wire	[32:0]	tx_ts54_dout;



	                        
	
	                        
	csa_command_contrl	cmd_ctrl(
                          
		.clk							(clk_main),
		.rst							(rst),
		
		.con_din						(con_din),
		.con_din_en						(con_din_en),
		
		.pid_con_dout					(pid_con_dout),
		.pid_con_dout_en				(pid_con_dout_en),
		.cw_con_dout					(cw_con_dout),
		.cw_con_dout_en                 (cw_con_dout_en),
		.ecm_ddr_dout					(ecm_ddr_dout),
		.ecm_ddr_dout_en				(ecm_ddr_dout_en),
		.ecm_con_dout					(ecm_con_dout),
		.ecm_con_addr					(ecm_con_addr),
		.ecm_con_dout_en				(ecm_con_dout_en),
		.emm_dout						(emm_dout),
		.emm_dout_en					(emm_dout_en),
		.emm_send						(emm_send),
		.emm_send_en					(emm_send_en)
    	);
    
	csa_ts_proc	ts_proc(
    	.clk						(clk_main),
		.rst						(rst),
		
		.ts_din						(ts_din[31:0]),
		.ts_din_en					(ts_din_en),	
					
		.cw_con_din					(cw_con_dout),
		.cw_con_din_en				(cw_con_dout_en),
		.pid_con_din				(pid_con_dout),
		.pid_con_din_en				(pid_con_dout_en),
		
		.ts1_dout_en				(pre_ts1_dout_en),
		.ts2_dout_en				(pre_ts2_dout_en),	    	
		.ts3_dout_en				(pre_ts3_dout_en),	    	
		.ts4_dout_en				(pre_ts4_dout_en),	    	
		.ts5_dout_en				(pre_ts5_dout_en),	    	
		.ts6_dout_en				(pre_ts6_dout_en),	    	
		.ts7_dout_en				(pre_ts7_dout_en),	    	
		.ts8_dout_en				(pre_ts8_dout_en),	    	
		.ts9_dout_en				(pre_ts9_dout_en),	    	
		.ts10_dout_en				(pre_ts10_dout_en),	    	
		.ts11_dout_en				(pre_ts11_dout_en),	    	
		.ts12_dout_en				(pre_ts12_dout_en),	    	
		.ts13_dout_en				(pre_ts13_dout_en),	    	
		.ts14_dout_en				(pre_ts14_dout_en),	    	
		.ts15_dout_en				(pre_ts15_dout_en),
		.ts16_dout_en				(pre_ts16_dout_en),	    	
		.ts17_dout_en				(pre_ts17_dout_en),	    	
		.ts18_dout_en				(pre_ts18_dout_en),	    	
		.ts19_dout_en				(pre_ts19_dout_en),	    	 
		.ts20_dout_en				(pre_ts20_dout_en),
		.ts21_dout_en				(pre_ts21_dout_en),
		.ts22_dout_en				(pre_ts22_dout_en),	    	
		.ts23_dout_en				(pre_ts23_dout_en),	    	
		.ts24_dout_en				(pre_ts24_dout_en),	    	
		.ts25_dout_en				(pre_ts25_dout_en),   	
		.ts26_dout_en				(pre_ts26_dout_en),	    	
		.ts27_dout_en				(pre_ts27_dout_en),	    	
		.ts28_dout_en				(pre_ts28_dout_en),	    	
		.ts29_dout_en				(pre_ts29_dout_en),	    	 
		.ts30_dout_en				(pre_ts30_dout_en),
		.ts31_dout_en				(pre_ts31_dout_en),
		.ts32_dout_en				(pre_ts32_dout_en),	    	
//		.ts33_dout_en				(pre_ts33_dout_en),	 
//		.ts34_dout_en				(pre_ts34_dout_en),	 
//		.ts35_dout_en				(pre_ts35_dout_en),  
//		.ts36_dout_en				(pre_ts36_dout_en),	 
//		.ts37_dout_en				(pre_ts37_dout_en),	 
//		.ts38_dout_en				(pre_ts38_dout_en),	 
//		.ts39_dout_en				(pre_ts39_dout_en),	 
//		.ts40_dout_en				(pre_ts40_dout_en),  
//		.ts41_dout_en				(pre_ts41_dout_en),  
//		.ts42_dout_en				(pre_ts42_dout_en),	 
//		.ts43_dout_en				(pre_ts43_dout_en),	 
//		.ts44_dout_en				(pre_ts44_dout_en),	 
//		.ts45_dout_en				(pre_ts45_dout_en),  
//		.ts46_dout_en				(pre_ts46_dout_en),	 
//		.ts47_dout_en				(pre_ts47_dout_en),	 
//		.ts48_dout_en				(pre_ts48_dout_en),	 
//		.ts49_dout_en				(pre_ts49_dout_en),	 
//		.ts50_dout_en				(pre_ts50_dout_en),  
//		.ts51_dout_en				(pre_ts51_dout_en),  
//		.ts52_dout_en				(pre_ts52_dout_en),	 
//		.ts53_dout_en				(pre_ts53_dout_en),
//		.ts54_dout_en				(pre_ts54_dout_en),	

   		
		.ts_dout					(pre_ts_dout)
    	);
    	
    csa_tx	csa1_tx(
		.clk_main					(clk_main),		
		.rst						(rst),									  							
		.ts_in_csa					(pre_ts_dout),
		.en_in_csa					(pre_ts1_dout_en),			
				
	
		.ts_out_csa_en_64			(tx_ts1_dout_en),
		.ts_out_csa_64 				(tx_ts1_dout)			 
		);
		
	csa_tx	csa2_tx(
		.clk_main					(clk_main),		
		.rst						(rst),	
		.ts_in_csa					(pre_ts_dout),
		.en_in_csa					(pre_ts2_dout_en),			
				

		.ts_out_csa_en_64			(tx_ts2_dout_en),
		.ts_out_csa_64 				(tx_ts2_dout)			 
		);
		
	csa_tx	csa3_tx(
		.clk_main					(clk_main),	
		.rst						(rst),						  							
		.ts_in_csa					(pre_ts_dout),
		.en_in_csa					(pre_ts3_dout_en),			
				
	
		.ts_out_csa_en_64			(tx_ts3_dout_en),
		.ts_out_csa_64 				(tx_ts3_dout)			 
		);
		
	csa_tx	csa4_tx(
		.clk_main					(clk_main),
		
		.rst						(rst),						
		      							
		.ts_in_csa					(pre_ts_dout),
		.en_in_csa					(pre_ts4_dout_en),			
				
	
		.ts_out_csa_en_64			(tx_ts4_dout_en),
		.ts_out_csa_64 				(tx_ts4_dout)			 
		);
		
	csa_tx	csa5_tx(
		.clk_main					(clk_main),
		
		.rst						(rst),				
		    		  							
		.ts_in_csa					(pre_ts_dout),
		.en_in_csa					(pre_ts5_dout_en),			
	
		.ts_out_csa_en_64			(tx_ts5_dout_en),
		.ts_out_csa_64 				(tx_ts5_dout)			 
		);
		
	csa_tx	csa6_tx(
		.clk_main					(clk_main),
		
		.rst						(rst),				
		    		  							
		.ts_in_csa					(pre_ts_dout),
		.en_in_csa					(pre_ts6_dout_en),			
	
		.ts_out_csa_en_64			(tx_ts6_dout_en),
		.ts_out_csa_64 				(tx_ts6_dout)			 
		);
		
	csa_tx	csa7_tx(
		.clk_main					(clk_main),
		
		.rst						(rst),				
		    		  							
		.ts_in_csa					(pre_ts_dout),
		.en_in_csa					(pre_ts7_dout_en),			
				

		.ts_out_csa_en_64			(tx_ts7_dout_en),
		.ts_out_csa_64 				(tx_ts7_dout)			 
		);
		
	csa_tx	csa8_tx(
		.clk_main					(clk_main),
		
		.rst						(rst),				
		    		  							
		.ts_in_csa					(pre_ts_dout),
		.en_in_csa					(pre_ts8_dout_en),			
				
	
		.ts_out_csa_en_64			(tx_ts8_dout_en),
		.ts_out_csa_64 				(tx_ts8_dout)			 
		);
		
	csa_tx	csa9_tx(
		.clk_main					(clk_main),		
		.rst						(rst),	 		  					
		.ts_in_csa					(pre_ts_dout),
		.en_in_csa					(pre_ts9_dout_en),			
				
	
		.ts_out_csa_en_64			(tx_ts9_dout_en),
		.ts_out_csa_64 				(tx_ts9_dout)			 
		);
		
		
	csa_tx	csa10_tx(                         
		.clk_main					(clk_main),    
		             
		.rst						(rst),							  	
		.ts_in_csa					(pre_ts_dout),     
		.en_in_csa					(pre_ts10_dout_en),	
				                                   
	           
		.ts_out_csa_en_64			(tx_ts10_dout_en),  
		.ts_out_csa_64 				(tx_ts10_dout)			 
		);                                     

	csa_tx	csa11_tx(                         
		.clk_main					(clk_main),    
		             
		.rst						(rst),							  	
		.ts_in_csa					(pre_ts_dout),     
		.en_in_csa					(pre_ts11_dout_en),	
				                                   
	         
		.ts_out_csa_en_64			(tx_ts11_dout_en),  
		.ts_out_csa_64 				(tx_ts11_dout)			 
		);                                     

	csa_tx	csa12_tx(                         
		.clk_main					(clk_main),
		                 
		.rst						(rst),							  	
		.ts_in_csa					(pre_ts_dout),     
		.en_in_csa					(pre_ts12_dout_en),	
				                                   
	           
		.ts_out_csa_en_64			(tx_ts12_dout_en),  
		.ts_out_csa_64 				(tx_ts12_dout)			 
		);                                     

	csa_tx	csa13_tx(                         
		.clk_main					(clk_main),   
		              
		.rst						(rst),							  	
		.ts_in_csa					(pre_ts_dout),     
		.en_in_csa					(pre_ts13_dout_en),	
				                                   
		           
		.ts_out_csa_en_64			(tx_ts13_dout_en),  
		.ts_out_csa_64 				(tx_ts13_dout)			 
		);                                     

 csa_tx	csa14_tx(                         
		 .clk_main					(clk_main),    
		              
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts14_dout_en),	
			                                   
	         
		 .ts_out_csa_en_64			(tx_ts14_dout_en),  
		 .ts_out_csa_64 			(tx_ts14_dout)			 
		 );                                     


	csa_tx	csa15_tx(                         
		 .clk_main					(clk_main),
		                  
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts15_dout_en),	
			                                   
	           
		 .ts_out_csa_en_64			(tx_ts15_dout_en),  
		 .ts_out_csa_64 			(tx_ts15_dout)			 
		 );                                     


	csa_tx	csa16_tx(                         
		 .clk_main					(clk_main),   
		               
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts16_dout_en),	
			                                   
	            
		 .ts_out_csa_en_64			(tx_ts16_dout_en),  
		 .ts_out_csa_64 			(tx_ts16_dout)			 
		 );     

	csa_tx	csa17_tx(                         
		 .clk_main					(clk_main),   
		               
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts17_dout_en),	
	            
		 .ts_out_csa_en_64			(tx_ts17_dout_en),  
		 .ts_out_csa_64 			(tx_ts17_dout)			 
		 );     


	csa_tx	csa18_tx(                         
		 .clk_main					(clk_main),   
		               
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts18_dout_en),	
			                                   
		             
		 .ts_out_csa_en_64			(tx_ts18_dout_en),  
		 .ts_out_csa_64 			(tx_ts18_dout)			 
		 );     


		csa_tx	csa19_tx(                         
		 .clk_main					(clk_main),   
		               
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts19_dout_en),	
	             
		 .ts_out_csa_en_64			(tx_ts19_dout_en),  
		 .ts_out_csa_64 			(tx_ts19_dout)			 
		 );     
		
		
		csa_tx	csa20_tx(                         
		 .clk_main					(clk_main),   
		               
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts20_dout_en),	
			                                   
		            
		 .ts_out_csa_en_64			(tx_ts20_dout_en),  
		 .ts_out_csa_64 			(tx_ts20_dout)			 
		 );     
		
		
		
		csa_tx	csa21_tx(                         
		 .clk_main					(clk_main),  
		                
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts21_dout_en),	
			                                   
		              
		 .ts_out_csa_en_64			(tx_ts21_dout_en),  
		 .ts_out_csa_64 			(tx_ts21_dout)			 
		 );     
		
		
		
		csa_tx	csa22_tx(                         
		 .clk_main					(clk_main),      
		                
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts22_dout_en),	
			                                   
		             
		 .ts_out_csa_en_64			(tx_ts22_dout_en),  
		 .ts_out_csa_64 			(tx_ts22_dout)			 
		 );     
		
		csa_tx	csa23_tx(                         
		 .clk_main					(clk_main),      
		            
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts23_dout_en),	
			                                   
		           
		 .ts_out_csa_en_64			(tx_ts23_dout_en),  
		 .ts_out_csa_64 			(tx_ts23_dout)			 
		 );     
		
		
		csa_tx	csa24_tx(                         
		 .clk_main					(clk_main),  
		                
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts24_dout_en),	
		            
		 .ts_out_csa_en_64			(tx_ts24_dout_en),  
		 .ts_out_csa_64 			(tx_ts24_dout)			 
		 );     
		
		
		csa_tx	csa25_tx(                         
		 .clk_main					(clk_main),     
		               
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts25_dout_en),	
			                                   
	          
		 .ts_out_csa_en_64			(tx_ts25_dout_en),  
		 .ts_out_csa_64 			(tx_ts25_dout)			 
		 );     
		
		
		csa_tx	csa26_tx(                         
		 .clk_main					(clk_main),     
		               
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts26_dout_en),	
			                                   
		             
		 .ts_out_csa_en_64			(tx_ts26_dout_en),  
		 .ts_out_csa_64 			(tx_ts26_dout)			 
		 );     
		
		
		csa_tx	csa27_tx(                         
		 .clk_main					(clk_main),     
		               
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts27_dout_en),	
			                                   
		             
		 .ts_out_csa_en_64			(tx_ts27_dout_en),  
		 .ts_out_csa_64 			(tx_ts27_dout)			 
		 );     
		
		
		csa_tx	csa28_tx(                         
		 .clk_main					(clk_main),     
		               
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts28_dout_en),	
			                                   
	            
		 .ts_out_csa_en_64			(tx_ts28_dout_en),  
		 .ts_out_csa_64 			(tx_ts28_dout)			 
		 );     
		
		
		csa_tx	csa29_tx(                         
		 .clk_main					(clk_main),     
		               
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts29_dout_en),	
			                                   
	         
		 .ts_out_csa_en_64			(tx_ts29_dout_en),  
		 .ts_out_csa_64 			(tx_ts29_dout)			 
		 );     
		
		
		csa_tx	csa30_tx(                         
		 .clk_main					(clk_main),     
		               
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts30_dout_en),				                                   
		            
		 .ts_out_csa_en_64			(tx_ts30_dout_en),  
		 .ts_out_csa_64 			(tx_ts30_dout)			 
		 );     
		
		
		csa_tx	csa31_tx(                         
		 .clk_main					(clk_main),     
		               
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts31_dout_en),				                                   
	             
		 .ts_out_csa_en_64			(tx_ts31_dout_en),  
		 .ts_out_csa_64 			(tx_ts31_dout)			 
		 );     
		
		
		csa_tx	csa32_tx(                         
		 .clk_main					(clk_main),     
		              
		 .rst						(rst),							  	
		 .ts_in_csa					(pre_ts_dout),     
		 .en_in_csa					(pre_ts32_dout_en),	
		          
		 .ts_out_csa_en_64			(tx_ts32_dout_en),  
		 .ts_out_csa_64 			(tx_ts32_dout)			 
		 );     
		
//		
//		csa_tx	csa33_tx(                         
//		 .clk_main					(clk_main),     
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts33_dout_en),		
//		 .ts_out_csa_en_64			(tx_ts33_dout_en),  
//		 .ts_out_csa_64 			(tx_ts33_dout)			 
//		 );     
//		
//		csa_tx	csa34_tx(                         
//		 .clk_main					(clk_main),    
//		              
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts34_dout_en),	
//			                                   
//	         
//		 .ts_out_csa_en_64			(tx_ts34_dout_en),  
//		 .ts_out_csa_64 			(tx_ts34_dout)			 
//		 );                                     
//
//
//	csa_tx	csa35_tx(                         
//		 .clk_main					(clk_main),
//		                  
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts35_dout_en),	
//			                                   
//	           
//		 .ts_out_csa_en_64			(tx_ts35_dout_en),  
//		 .ts_out_csa_64 			(tx_ts35_dout)			 
//		 );                                     
//
//
//	csa_tx	csa36_tx(                         
//		 .clk_main					(clk_main),   
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts36_dout_en),	
//			                                   
//	            
//		 .ts_out_csa_en_64			(tx_ts36_dout_en),  
//		 .ts_out_csa_64 			(tx_ts36_dout)			 
//		 );     
//
//	csa_tx	csa37_tx(                         
//		 .clk_main					(clk_main),   
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts37_dout_en),	
//	            
//		 .ts_out_csa_en_64			(tx_ts37_dout_en),  
//		 .ts_out_csa_64 			(tx_ts37_dout)			 
//		 );     
//
//
//	csa_tx	csa38_tx(                         
//		 .clk_main					(clk_main),   
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts38_dout_en),	
//			                                   
//		             
//		 .ts_out_csa_en_64			(tx_ts38_dout_en),  
//		 .ts_out_csa_64 			(tx_ts38_dout)			 
//		 );     
//
//
//		csa_tx	csa39_tx(                         
//		 .clk_main					(clk_main),   
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts39_dout_en),	
//	             
//		 .ts_out_csa_en_64			(tx_ts39_dout_en),  
//		 .ts_out_csa_64 			(tx_ts39_dout)			 
//		 );     
//		
//		
//		csa_tx	csa40_tx(                         
//		 .clk_main					(clk_main),   
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts40_dout_en),	
//			                                   
//		            
//		 .ts_out_csa_en_64			(tx_ts40_dout_en),  
//		 .ts_out_csa_64 			(tx_ts40_dout)			 
//		 );     
//		
//		
//		
//		csa_tx	csa41_tx(                         
//		 .clk_main					(clk_main),  
//		                
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts41_dout_en),	
//			                                   
//		              
//		 .ts_out_csa_en_64			(tx_ts41_dout_en),  
//		 .ts_out_csa_64 			(tx_ts41_dout)			 
//		 );     
//		
//		
//		
//		csa_tx	csa42_tx(                         
//		 .clk_main					(clk_main),      
//		                
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts42_dout_en),	
//			                                   
//		             
//		 .ts_out_csa_en_64			(tx_ts42_dout_en),  
//		 .ts_out_csa_64 			(tx_ts42_dout)			 
//		 );     
//		
//		csa_tx	csa43_tx(                         
//		 .clk_main					(clk_main),      
//		            
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts43_dout_en),	
//			                                   
//		           
//		 .ts_out_csa_en_64			(tx_ts43_dout_en),  
//		 .ts_out_csa_64 			(tx_ts43_dout)			 
//		 );     
//		
//		
//		csa_tx	csa44_tx(                         
//		 .clk_main					(clk_main),  
//		                
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts44_dout_en),	
//		            
//		 .ts_out_csa_en_64			(tx_ts44_dout_en),  
//		 .ts_out_csa_64 			(tx_ts44_dout)			 
//		 );     
//		
//		
//		csa_tx	csa45_tx(                         
//		 .clk_main					(clk_main),     
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts45_dout_en),	
//			                                   
//	          
//		 .ts_out_csa_en_64			(tx_ts45_dout_en),  
//		 .ts_out_csa_64 			(tx_ts45_dout)			 
//		 );     
//		
//		
//		csa_tx	csa46_tx(                         
//		 .clk_main					(clk_main),     
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts46_dout_en),	
//			                                   
//		             
//		 .ts_out_csa_en_64			(tx_ts46_dout_en),  
//		 .ts_out_csa_64 			(tx_ts46_dout)			 
//		 );     
//		
//		
//		csa_tx	csa47_tx(                         
//		 .clk_main					(clk_main),     
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts47_dout_en),	
//			                                   
//		             
//		 .ts_out_csa_en_64			(tx_ts47_dout_en),  
//		 .ts_out_csa_64 			(tx_ts47_dout)			 
//		 );     
//		
//		
//		csa_tx	csa48_tx(                         
//		 .clk_main					(clk_main),     
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts48_dout_en),	
//			                                   
//	            
//		 .ts_out_csa_en_64			(tx_ts48_dout_en),  
//		 .ts_out_csa_64 			(tx_ts48_dout)			 
//		 );     
//		
//		
//		csa_tx	csa49_tx(                         
//		 .clk_main					(clk_main),     
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts49_dout_en),	
//			                                   
//	         
//		 .ts_out_csa_en_64			(tx_ts49_dout_en),  
//		 .ts_out_csa_64 			(tx_ts49_dout)			 
//		 );     
//		
//		
//		csa_tx	csa50_tx(                         
//		 .clk_main					(clk_main),     
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts50_dout_en),				                                   
//		            
//		 .ts_out_csa_en_64			(tx_ts50_dout_en),  
//		 .ts_out_csa_64 			(tx_ts50_dout)			 
//		 );     
//		
//		
//		csa_tx	csa51_tx(                         
//		 .clk_main					(clk_main),     
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts51_dout_en),				                                   
//	             
//		 .ts_out_csa_en_64			(tx_ts51_dout_en),  
//		 .ts_out_csa_64 			(tx_ts51_dout)			 
//		 );     
//		
//		
//		csa_tx	csa52_tx(                         
//		 .clk_main					(clk_main),     
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts52_dout_en),	
//		          
//		 .ts_out_csa_en_64			(tx_ts52_dout_en),  
//		 .ts_out_csa_64 			(tx_ts52_dout)			 
//		 );     
//		
//		
//		csa_tx	csa53_tx(                         
//		 .clk_main					(clk_main),     
//		               
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts53_dout_en),		
//		 .ts_out_csa_en_64			(tx_ts53_dout_en),  
//		 .ts_out_csa_64 			(tx_ts53_dout)			 
//		 );     
//		
//		
//		csa_tx	csa54_tx(                         
//		 .clk_main					(clk_main),  
//		                
//		 .rst						(rst),							  	
//		 .ts_in_csa					(pre_ts_dout),     
//		 .en_in_csa					(pre_ts54_dout_en),	
//		            
//		 .ts_out_csa_en_64			(tx_ts54_dout_en),  
//		 .ts_out_csa_64 			(tx_ts54_dout)			 
//		 );     
//		

		
	csa_ts_combo	ts_combo(

		.clk						(clk_main),
        .rst						(rst),
        
        .csa1_din					  (tx_ts1_dout),
        .csa1_din_en				(tx_ts1_dout_en),
        .csa2_din					  (tx_ts2_dout),
        .csa2_din_en				(tx_ts2_dout_en),
        .csa3_din				  	(tx_ts3_dout),
        .csa3_din_en				(tx_ts3_dout_en),
        .csa4_din					  (tx_ts4_dout),
        .csa4_din_en			 	(tx_ts4_dout_en),
        .csa5_din					  (tx_ts5_dout),
        .csa5_din_en				(tx_ts5_dout_en),
        .csa6_din					  (tx_ts6_dout),
        .csa6_din_en				(tx_ts6_dout_en),
        .csa7_din					  (tx_ts7_dout),
        .csa7_din_en				(tx_ts7_dout_en),
        .csa8_din					  (tx_ts8_dout),
        .csa8_din_en				(tx_ts8_dout_en),
        .csa9_din					  (tx_ts9_dout),
        .csa9_din_en				(tx_ts9_dout_en),	 
        .csa10_din					(tx_ts10_dout),
        .csa10_din_en				(tx_ts10_dout_en),
        .csa11_din					(tx_ts11_dout),
        .csa11_din_en				(tx_ts11_dout_en),
        .csa12_din					(tx_ts12_dout),
        .csa12_din_en				(tx_ts12_dout_en),
        .csa13_din					(tx_ts13_dout),
        .csa13_din_en				(tx_ts13_dout_en),
        .csa14_din					(tx_ts14_dout),
        .csa14_din_en				(tx_ts14_dout_en),
        .csa15_din					(tx_ts15_dout),
        .csa15_din_en				(tx_ts15_dout_en),	
        .csa16_din					(tx_ts16_dout),
        .csa16_din_en				(tx_ts16_dout_en),
        .csa17_din					(tx_ts17_dout),
        .csa17_din_en				(tx_ts17_dout_en),
        .csa18_din					(tx_ts18_dout),
        .csa18_din_en				(tx_ts18_dout_en),
        .csa19_din					(tx_ts19_dout),
        .csa19_din_en				(tx_ts19_dout_en),	 
        .csa20_din					(tx_ts20_dout),
        .csa20_din_en				(tx_ts20_dout_en),
        .csa21_din					(tx_ts21_dout),
        .csa21_din_en				(tx_ts21_dout_en),
        .csa22_din					(tx_ts22_dout),
        .csa22_din_en				(tx_ts22_dout_en),
        .csa23_din				  	(tx_ts23_dout),
        .csa23_din_en				(tx_ts23_dout_en),
        .csa24_din					(tx_ts24_dout),
        .csa24_din_en			 	(tx_ts24_dout_en),
        .csa25_din					(tx_ts25_dout),
        .csa25_din_en				(tx_ts25_dout_en),
        .csa26_din					(tx_ts26_dout),
        .csa26_din_en				(tx_ts26_dout_en),
        .csa27_din					(tx_ts27_dout),
        .csa27_din_en				(tx_ts27_dout_en),
        .csa28_din					(tx_ts28_dout),
        .csa28_din_en				(tx_ts28_dout_en),
        .csa29_din					(tx_ts29_dout),
        .csa29_din_en				(tx_ts29_dout_en),	 
        .csa30_din					(tx_ts30_dout),
        .csa30_din_en				(tx_ts30_dout_en),
        .csa31_din					(tx_ts31_dout),
        .csa31_din_en				(tx_ts31_dout_en),
        .csa32_din					(tx_ts32_dout),
        .csa32_din_en				(tx_ts32_dout_en),
//        .csa33_din				  	(tx_ts33_dout),
//        .csa33_din_en				(tx_ts33_dout_en), 
//        .csa34_din					(tx_ts34_dout),
//        .csa34_din_en				(tx_ts34_dout_en),
//        .csa35_din					(tx_ts35_dout),
//        .csa35_din_en				(tx_ts35_dout_en),	
//        .csa36_din					(tx_ts36_dout),
//        .csa36_din_en				(tx_ts36_dout_en),
//        .csa37_din					(tx_ts37_dout),
//        .csa37_din_en				(tx_ts37_dout_en),
//        .csa38_din					(tx_ts38_dout),
//        .csa38_din_en				(tx_ts38_dout_en),
//        .csa39_din					(tx_ts39_dout),
//        .csa39_din_en				(tx_ts39_dout_en),	 
//        .csa40_din					(tx_ts40_dout),
//        .csa40_din_en				(tx_ts40_dout_en),
//        .csa41_din					(tx_ts41_dout),
//        .csa41_din_en				(tx_ts41_dout_en),
//        .csa42_din					(tx_ts42_dout),
//        .csa42_din_en				(tx_ts42_dout_en),
//        .csa43_din				  	(tx_ts43_dout),
//        .csa43_din_en				(tx_ts43_dout_en),
//        .csa44_din					(tx_ts44_dout),
//        .csa44_din_en			 	(tx_ts44_dout_en),
//        .csa45_din					(tx_ts45_dout),
//        .csa45_din_en				(tx_ts45_dout_en),
//        .csa46_din					(tx_ts46_dout),
//        .csa46_din_en				(tx_ts46_dout_en),
//        .csa47_din					(tx_ts47_dout),
//        .csa47_din_en				(tx_ts47_dout_en),
//        .csa48_din					(tx_ts48_dout),
//        .csa48_din_en				(tx_ts48_dout_en),
//        .csa49_din					(tx_ts49_dout),
//        .csa49_din_en				(tx_ts49_dout_en),	 
//        .csa50_din					(tx_ts50_dout),
//        .csa50_din_en				(tx_ts50_dout_en),
//        .csa51_din					(tx_ts51_dout),
//        .csa51_din_en				(tx_ts51_dout_en),
//        .csa52_din					(tx_ts52_dout),
//        .csa52_din_en				(tx_ts52_dout_en),
//        .csa53_din				  	(tx_ts53_dout),
//        .csa53_din_en				(tx_ts53_dout_en), 
//        .csa54_din					(tx_ts54_dout),   
//		.csa54_din_en			 	(tx_ts54_dout_en),
//
//       
//        
//     
        .csa_dout					(ts_dout),
        .csa_dout_en                (ts_dout_en)
        );
		


	csa_ecm_ctrl	ecm_ctrl(
		.clk						(clk_main),
		.rst						(rst),										
		.con_din					(ecm_con_dout),
		.con_addr					(ecm_con_addr),
		.con_din_en					(ecm_con_dout_en),
		
		.ecm_addr_dout				(ecm_addr_dout),							
		.ecm_addr_dout_en	        (ecm_addr_dout_en),
		.erro_flag					(erro_flag)
		);	
  
  


  
endmodule