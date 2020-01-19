`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:45:31 12/06/2008 
// Design Name: 
// Module Name:    csa_strm_enc 
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
module csa_strm_enc(
											clk,
											rst,																						
											en_tsr,
											tsr,							
										
											en_out_csa,
											ts_out_csa																																																			
										);
	input					clk, rst;	
	input					en_tsr;
	input[7:0]		tsr;
	
	//output				full_etsf;
	output				en_out_csa;
	output[8:0]		ts_out_csa;  	 	
	
	reg						en_out_csa;
	reg[8:0]			ts_out_csa;	
	
  
  wire					en_cb;
	wire[7:0]			cb; 	
	
	reg					  wr_etsf;
	reg[8:0]			din_etsf;		
	reg[7:0]		  count_wr_etsf;
	
	parameter     IDLE                  = 0,
								SEND_CW_DATA          = 1,
								SEND_TS_HEADER        = 2,
								SEND_TS_DATA_NO_SCRAM = 3,								
								SEND_TS_DATA_SCRAM    = 4;
	                                 
  reg[2:0]			state_strm_ctrl;                                        
  
	reg						rd_etsf;
	reg[7:0]			count_rd_etsf;	
	reg						en_dout_etsf_b;
	wire[8:0]			dout_etsf_b;		
	
	wire					pfull_etsf;
	
	
	reg[7:0]			count_valid;	
	reg						en_valid;
	reg[8:0]			ts_valid;
	
	reg[7:0]			count_out_csa;
	reg						en_ck;
	reg[7:0]			idx_ck;
	reg[7:0]			ts_valid_ck;	
	reg[63:0]		  ck;	
	reg     		  scram_ctrl;		
	reg[1:0]			round;
	reg						en_adap;
	reg[7:0]			adap_len;	
	reg[8:0]			skip;
	reg[8:0]			skip_9add;
	reg[7:0]			sb;
	reg						en_strm_enc;
	
	parameter     WATCH_DOG_AGE = 4000; 
	reg[11:0]     count_state; 
 
// 	reg           miss_sync_etsf; 
// 	reg[7:0]      idx_etsf; 
 
	always@(posedge clk)
		begin
			if(rst)
				begin
					count_wr_etsf <= 0;
				end
			else
				begin
					if(en_tsr)
						begin
					//	if(count_wr_etsf==196)
							if(count_wr_etsf==206)//10+9+188
								begin
									count_wr_etsf <= 0;
								end
							else
								begin
									count_wr_etsf <= count_wr_etsf + 1;
								end
						end
					else
						begin
							count_wr_etsf <= count_wr_etsf;
						end					
				end
		end
	
	always@(posedge clk)
		begin
			if(rst)
				begin
					wr_etsf  <= 0;
					din_etsf <= 0;									
				end
			else
				begin					
					if(en_tsr)					
						begin
							wr_etsf <= 1;
					//	if(count_wr_etsf==0 || count_wr_etsf==9)
							if(count_wr_etsf==0 || count_wr_etsf==19)
								begin
									din_etsf[8] <= 1;
								end
							else
								begin
									din_etsf[8] <= 0;
								end
							din_etsf[7:0] <= tsr;								
						end
					else
						begin
							wr_etsf <= 0;
							din_etsf <= 0;							
						end					
				end
		end	
	
	csa_fifo_ets					 m_csa_fifo_ets
	(                      
		.wr_clk							(clk),
		.rd_clk							(clk),		
		.rst							(rst),			
		.prog_full					 	(pfull_etsf),
		.wr_en						 	(wr_etsf),
		.din							(din_etsf),
	  
	  	.full                     		(),
	  	.empty							(empty),
		.rd_en						   	(rd_etsf),		
		.dout		             		(dout_etsf_b)		
	);		
	
	always @(posedge clk)
	begin
		if(rst)
			begin
				state_strm_ctrl <= IDLE;					
			end
		else
			begin
				case(state_strm_ctrl)				
				IDLE:
				begin
					if (pfull_etsf && !empty)
						begin
							state_strm_ctrl <= SEND_CW_DATA;
						end
					else
						begin
							state_strm_ctrl <= state_strm_ctrl;
						end
				end				
				SEND_CW_DATA:
				begin					
					if (count_valid==19)					
						begin
							state_strm_ctrl <= SEND_TS_HEADER;
						end
					else
						begin
							state_strm_ctrl <= state_strm_ctrl;				
						end
				end	
				SEND_TS_HEADER:
				begin
					if (count_valid==23)
						begin
							if (scram_ctrl==1'b0)
								begin									
									state_strm_ctrl <= SEND_TS_DATA_NO_SCRAM;
								end
							else
								begin
									state_strm_ctrl <= SEND_TS_DATA_SCRAM;
								end
						end
					else
						begin
							state_strm_ctrl <= state_strm_ctrl;
						end
				end				
				SEND_TS_DATA_NO_SCRAM:
				begin
					if ((count_out_csa==184) || (count_state > WATCH_DOG_AGE))
						begin
							state_strm_ctrl <= IDLE;
						end
					else
						begin
							state_strm_ctrl <= state_strm_ctrl;
						end
				end							
				SEND_TS_DATA_SCRAM:
				begin
					if ((count_out_csa==184) || (count_state > WATCH_DOG_AGE))
						begin
							state_strm_ctrl <= IDLE;
						end
					else
						begin
							state_strm_ctrl <= state_strm_ctrl;
						end
				end			
				default:
				begin
					state_strm_ctrl <= IDLE;
				end					
				endcase
			end		
	end		
	
	always @ (posedge clk)
	begin
		if (rst)
			begin
				count_state <= 0; 
			end 
		else 
			begin
				if ((state_strm_ctrl==SEND_TS_DATA_SCRAM) || (state_strm_ctrl==SEND_TS_DATA_NO_SCRAM))
					begin
						if (count_state > WATCH_DOG_AGE)
							begin
								count_state <= 0; 						
							end 						
						else 
							begin
								count_state <= count_state + 1; 						
							end 
					end 
				else 
					begin
						count_state <= 0; 
					end 
			end 
	end 
	 
	always @ (posedge clk)
		begin
			if (rst)
				begin
					round <= 0;
				end
			else
				begin
					if (state_strm_ctrl==SEND_TS_DATA_SCRAM)
						begin						
							if (count_rd_etsf==184)
								begin
									round <= 0;
								end
							else
								begin
									if (round==2'b11)
										begin
											round <= 0;
										end
									else
										begin
											round <= round + 1;
										end	
								end													
						end
					else
						begin
							round <= 0;
						end
				end
		end
	 
	always @ (posedge clk)
	begin
		if(rst)
			begin	
				count_rd_etsf <= 0;
				rd_etsf       <= 0;
			end
		else
			begin
				if(state_strm_ctrl==IDLE)
					begin
						count_rd_etsf <= 0;
						rd_etsf       <= 0;
					end
				else if(state_strm_ctrl==SEND_CW_DATA)//read frame header from fifo including 10 + 9cw
					begin												
						if (count_valid < 16)										
							begin
								rd_etsf <= 1;
							end
						else
							begin
								rd_etsf <= 0;
							end													
					end				
				else if(state_strm_ctrl==SEND_TS_HEADER)
					begin
						if (count_valid < 20)
							begin
								rd_etsf <= 1;
							end
						else
							begin
								rd_etsf <= 0;
							end
					end														
				else if(state_strm_ctrl==SEND_TS_DATA_NO_SCRAM)		
					begin
						if (count_rd_etsf==184)		
							begin
								count_rd_etsf <= count_rd_etsf;
								rd_etsf       <= 0;
							end
						else
							begin
								count_rd_etsf <= count_rd_etsf + 1;
								rd_etsf       <= 1;
							end
					end
				else if (state_strm_ctrl==SEND_TS_DATA_SCRAM)
					begin
						if (count_rd_etsf==184)
							begin								
								count_rd_etsf <= count_rd_etsf;
								rd_etsf       <= 0;
							end
						else
							begin																	
								if (round==2'b00)
									begin
										count_rd_etsf <= count_rd_etsf + 1;
										rd_etsf       <= 1;
									end
								else
									begin
										count_rd_etsf <= count_rd_etsf;
										rd_etsf       <= 0;
									end									
							end						
					end
				else
					begin
						count_rd_etsf <= 0;
						rd_etsf       <= 0;
					end
			end
	end		 			
	
	always @ (posedge clk)
		begin
			en_dout_etsf_b <= rd_etsf;
		end
//	
//	always @ (posedge clk)
//	begin
//		if (rst)
//		begin
//			idx_etsf <= 0; 
//		end 
//		else 
//		begin
//			if (state_strm_ctrl==SEND_CW_DATA)
//				begin
//					if (en_dout_etsf_b==1'b1)
//						begin
//							idx_etsf <= idx_etsf + 1; 
//						end 
//					else 
//						begin
//							idx_etsf <= idx_etsf; 
//						end 
//				end 
//			else 
//				begin
//					idx_etsf <= 0; 
//				end 
//		end 
//	end 
//		
//	always @ (posedge clk)	
//	begin 
//	  if (rst)
//	  begin
//	  	miss_sync_etsf <= 0; 
//	  end 
//	 	else 
//	 	begin
//	 		if (state_strm_ctrl==SEND_CW_DATA)
//	 		begin
//	 			if (dout_etsf_b[8]==1'b1)
//	 				begin
//	 					if (idx_etsf>0)
//	 						begin
//	 							miss_sync_etsf <= 1'b1; 
//	 						end 
//	 					else 
//	 						begin
//	 							miss_sync_etsf <= 1'b0; 
//	 						end 
//	 				end 
//	 			else 
//	 				begin
//	 					miss_sync_etsf <= 0; 
//	 				end 
//	 		end 
//	 		else 
//	 		begin
//	 			miss_sync_etsf <= 0;
//	 		end 
//	 	end 
//	end 
//	
	
	always @ (posedge clk)
	begin	
		if (rst)
			begin
				en_valid <= 0;
			end
		else
			begin
				if (state_strm_ctrl==SEND_CW_DATA)
					begin
						if (dout_etsf_b[8]==1'b1)
							begin
								en_valid <= 1;
							end
						else
							begin
								if (count_valid==18)
									begin
										en_valid <= 0;
									end
								else
									begin
										en_valid <= en_valid;
									end								
							end						
					end
				else if (state_strm_ctrl==SEND_TS_HEADER)
					begin			
						if (dout_etsf_b==9'h147)
							begin
								en_valid <= 1;
							end
						else
							begin
								if (count_valid==22)
									begin
										en_valid <= 0;
									end
								else
									begin
										en_valid <= en_valid;
									end								
							end						
					end
				else
					begin
						en_valid <= en_dout_etsf_b;
					end
			end				
	end	
	
	always @ (posedge clk)
	begin									
		ts_valid  <= dout_etsf_b;		
	end			
	
	always @ (posedge clk)
		begin		
			if(rst)	
				count_valid    <= 0;										
			else if (state_strm_ctrl==IDLE)
				count_valid <= 0; 
			else if(en_valid)
				count_valid <= count_valid + 1;		
		end	
	
/////////get signal of scrambling////////////////////
	always @ (posedge clk)
		begin
			if(rst)
			begin
				scram_ctrl <= 0;
			end else if(en_valid && (count_valid==1))				
			begin
				scram_ctrl <= ts_valid[0];
			end
		end
		
	always @ (posedge clk)	
		begin
			if(rst)
				begin
					en_ck <= 0;
					idx_ck <= 0;
					ts_valid_ck <= 0;
				end
			else
				begin
					if(en_valid && count_valid >= 2 && count_valid <= 9)
						begin
							en_ck <= 1;
							idx_ck <= count_valid - 2;
							ts_valid_ck <= ts_valid;
						end
					else
						begin
							en_ck <= 0;
							idx_ck <= 0;
							ts_valid_ck <= ts_valid_ck;
						end
				end				
		end

/////////////get cw/////////////////////////////////////		
	always@(posedge clk)
  	begin
  		if(rst)
  			begin  				
  				ck <= 64'd0;
  			end
  		else
  			begin
  				if(en_ck)
 						begin
 							case(idx_ck)						 		
						 		0:
						 			begin						 				
						 				ck[63:56] <= ts_valid_ck[7:0];						 				 
						 			end
						 		1:
						 			begin
						 				ck[55:48] <= ts_valid_ck[7:0];						 				 
						 			end
						 		2:
						 			begin
						 				ck[47:40] <= ts_valid_ck[7:0];						 				 
						 			end
						 		3:
						 			begin
						 				ck[39:32] <= ts_valid_ck[7:0];						 				 
						 			end
						 		4:
						 			begin
						 				ck[31:24] <= ts_valid_ck[7:0];						 				 
						 			end 						
						 		5:
						 			begin
						 				ck[23:16] <= ts_valid_ck[7:0];						 				 
						 			end
						 		6:
						 			begin
						 				ck[15:8] <= ts_valid_ck[7:0];						 				 
						 			end
						 		7:
						 			begin
						 				ck[7:0]  <= ts_valid_ck[7:0];										 				 
						 			end 
						 		default:
						 			begin
						 				ck <= ck;
						 			end						
						 	endcase
 						end//end of if(en_fifo_cw)
 					else
 						begin 							 
 							ck <= ck; 							
 						end
  			end
  	end		
  
   always@(posedge clk)
		begin
			if(rst)
				begin
					en_adap <= 0;
				end
			else
				begin
					if (state_strm_ctrl==IDLE)
						begin
							en_adap <= 0; 
						end 
					else 
						begin
							if(count_valid==22)
								begin
									if (en_valid==1'b1)
										begin
											en_adap <= ts_valid[5];																									
										end 
									else 
										begin
											en_adap <= en_adap; 
										end 									
								end														
							else if (count_valid>23)
								begin
									if (adap_len==0)
										begin
											en_adap <= 0; 
										end 																		
								end	
							else 
								begin
									en_adap <= en_adap; 
								end 
						end 						 	
				end
		end 
		
	always@(posedge clk)
  	begin
  		if(rst)
  			begin
  				adap_len <= 0;
  			end
  		else
  			begin
  				if (state_strm_ctrl==IDLE)
  					begin
  						adap_len <= 0; 
  					end 
  				else 
  					begin
  						if ((en_adap==1'b1) && (en_valid==1'b1) && (count_valid==23))
  							begin
  								adap_len <= ts_valid[7:0];
  							end 
  						else 
  							begin
  								if ((adap_len>0) && (en_valid==1'b1))
  									begin
  										adap_len <= adap_len - 1; 
  									end 
  								else 
  									begin
  										adap_len <= adap_len; 
  									end 
  							end
  					end   				
  			end
  	end 	
  
  always@(posedge clk)
		begin
			if(rst)
				begin				 				 
					skip <= 0;					 				 				 
					skip_9add <= 0;
				end
			else
				begin				 
					if(count_valid==22 && en_valid)						 
						begin
							skip <= 4;
							skip_9add <= 23;
						end
					else if(count_valid==23 && en_valid)
						begin
   						if(en_adap)	
								begin
									skip     <= 5 + ts_valid[7:0]; 
									skip_9add <= 24 + ts_valid[7:0];
								end
							else
								begin
									skip     <= 4;									
									skip_9add <= 23;									
								end
						end
					else
						begin
							skip <= skip;
							skip_9add <= skip_9add;
						end			 
				end
		end				
	
	
	always @ (posedge clk)
		begin
			if(rst)
				begin
					en_out_csa <= 0;
					ts_out_csa <= 0;				
				end
			else
				begin								
						if (state_strm_ctrl==SEND_CW_DATA)
						begin
							if (count_valid == 0)
								begin
									en_out_csa <= en_valid; 
									ts_out_csa <= {1'b1, ts_valid[7:0]}; 
								end 
					/*		else if (count_valid <= 6)
							begin
								en_out_csa <= en_valid; 
								ts_out_csa <= {1'b0, ts_valid[7:0]}; 
							end else if (count_valid==7)
								begin
									en_out_csa <= en_valid;
									ts_out_csa <= {2'b0, ts_valid[7:1]};									
								end	*/		
							else if (count_valid >= 10 && count_valid <= 18)
							begin
								en_out_csa <= en_valid; 
								ts_out_csa <= {1'b0, ts_valid[7:0]}; 
							end							
							else 
								begin
									en_out_csa <= 0;
									ts_out_csa <= 0;
								end
						end
					else if (state_strm_ctrl==SEND_TS_HEADER)
						begin
							// if(count_valid == 16)
							// begin
								en_out_csa <= en_valid;
								ts_out_csa <= {1'b0, ts_valid[7:0]};
							// end else 
							// begin
								// en_out_csa <= en_valid;
								// ts_out_csa <= ts_valid;
							// end
						end
					else if(state_strm_ctrl==SEND_TS_DATA_NO_SCRAM)	
						begin							
							en_out_csa <= en_valid;
							ts_out_csa <= ts_valid;						
						end
					else if (state_strm_ctrl==SEND_TS_DATA_SCRAM)
						begin
							if ((en_adap==1'b1) || (skip>180))
								begin
									en_out_csa <= en_valid;
									ts_out_csa <= ts_valid;
								end
							else 
								begin
									en_out_csa <= en_cb;
									ts_out_csa <= {1'b0, cb};																
								end							
						end
					else
						begin
							en_out_csa <= 0;
							ts_out_csa <= 0;
						end
				end				
		end				
	
	always @ (posedge clk)
		begin		
			if(rst)	
				begin
					count_out_csa  <= 0;					
				end
			else
				begin				
					if (state_strm_ctrl==IDLE)
						begin
							count_out_csa <= 0; 
						end 
					else if ( (state_strm_ctrl==SEND_TS_DATA_NO_SCRAM) ||
					          (state_strm_ctrl==SEND_TS_DATA_SCRAM)
					        )
						begin
							if (en_out_csa)
								begin
									count_out_csa <= count_out_csa + 1;
								end
							else	
								begin
									count_out_csa <= count_out_csa;
								end
						end 							
				end			
		end
	
	always @ (posedge clk)
		begin
			if (rst)
			begin
				sb <= 0;
			end
			else
			begin
				sb <= dout_etsf_b;
			end			
		end						
	 
	always@(posedge clk)
		begin
			if(rst)
				begin
					en_strm_enc <= 0;
				end
			else
				begin	
					if (scram_ctrl==1'b1)	
						begin
							if (skip>180)
								begin
									en_strm_enc <= 0;
								end
							else
								begin
								/*流加密模块的启动当且仅当读数时钟控制变量 round==2'b11
								或者是说当en_valid==1'b1时才可以发生. 或者是说当恰好得到
								第一个需要加密的字节时. 以后就是流加密时钟控制变量
								和读数时钟控制同步但不同样变化.可以将流加密模块启动控制看成是流加密
								处理过程的一部分.
								round: 0,  1,   2,  3,  0, 1, 2, 3, 0....
								                    sb           sb....   
								                       sbi,         sbi....
					  round_strm:                    0, 1, 2, 3,                         
								
								*/								
									if ((en_adap==1'b0) && count_valid==skip_9add && en_valid)	
										begin
											en_strm_enc <= 1;
										end
									else
										begin
											en_strm_enc <= 0;
										end								
								end
						end
					else
						begin
							en_strm_enc <= 0;
						end					
				end
		end			
				
  csa_stream_encipher   m_csa_stream_encipher
	(
		.clk						   (clk				),
		.rst						   (rst				),		                 
		.skip_b					   (skip[7:0]      ),
		                   
		                   
		.en_strm_enc_b	   (en_strm_enc),
		.sb						     (sb),
		.ck_b						   (ck),							                   
  	
		.en_cb					   (en_cb			),
		.cb							   (cb				)
	);					
		
endmodule
