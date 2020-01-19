`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:55:44 11/11/2008 
// Design Name: 
// Module Name:    csa_block_encipher 
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
module csa_block_encipher
										(
											clk,
											rst,					 
											ck,											
											en_blk_enc,											
											db0, db1, db2, db3, db4, db5, db6, db7,													
											 
											//valid output										
											en_round,
											en_ib,
											ib0, ib1, ib2, ib3, ib4, ib5, ib6, ib7 			
										);
				
	input					clk, rst;
	input     		en_blk_enc;			 
  input[7:0]		db0, db1, db2, db3, db4, db5, db6, db7; 
	input[63:0]   ck;	
	
	
	output				en_ib; 
	output[7:0]		ib0, ib1, ib2, ib3, ib4, ib5, ib6, ib7; 
  output				en_round;
  
	reg           en_ib; 
	reg[7:0]			ib0, ib1, ib2, ib3, ib4, ib5, ib6, ib7;	
	reg						en_round;
	reg[7:0] 			db0_btl, db1_btl, db2_btl, db3_btl, db4_btl, db5_btl, db6_btl, db7_btl;	
	reg[63:0]			ck_b;
	
	 
	reg[7:0]      kk0, kk1, kk2, kk3, kk4, kk5, kk6, kk7;
	reg[5:0]			round;
	reg[5:0]			round_2add;
	reg[3:0]			state_blk_enc;
	
	parameter    IDLE     = 4'b0000;
	parameter    PRE_0 = 4'b1000;
	parameter    PRE_1  = 4'b0001;
	parameter    PRE_2 = 4'b0010;	 
	parameter    BLK_ENC	  = 4'b0100; 
	//8 bytes of block data is inputted after 8 clocks, so is ck. After 56 times transformation, 
	//ib is gotten and next block encipher starts.
	//The expanded keys cannot be prepared for transformation of next round when transformation of 
	//current round  is going.	  
	//process 4	
	always@(posedge clk)
		begin
			if(rst)
				begin
					state_blk_enc <= IDLE;				
				end//end of rst
			else
				begin
					case(state_blk_enc)
						IDLE:
							begin
								if(en_blk_enc)
									begin
										state_blk_enc <= PRE_0;
									end								
							end//end IDLE							
						PRE_0:
							begin
								state_blk_enc <= PRE_1;
							end
						PRE_1:
							begin
								state_blk_enc <= PRE_2;
							end//end sbox_in;
						PRE_2:
							begin
								state_blk_enc <= BLK_ENC;
							end						
						BLK_ENC:
							begin
								if(round == 55)
									begin
										state_blk_enc <= IDLE;
									end
								else
									begin
										state_blk_enc <= BLK_ENC;
									end
							end
						default:
							begin
								state_blk_enc <= IDLE;
							end
					endcase//end case state_trans
				end//end of else matching if(rst)
		end//end of always@...
		
		//process 3		         
	always@(posedge clk)   
		begin                
			if(rst)            
				begin            
					round <= 0;    
				end//end of rst  
			else               
				begin
					if(state_blk_enc == BLK_ENC)
						begin
							if(round == 55)
								begin
									round <= 0;
								end
							else
								begin
									round <= round + 1;		 						
								end							
					  end	
				end//end of else matching if(rst)
		end//end of always@...
	
	always @(posedge clk)
		begin
			if(rst)
				begin
					round_2add <= 0;
				end
			else
				begin
					if(state_blk_enc == BLK_ENC)
						begin
							round_2add <= round_2add + 1;
						end
					else
						begin
							round_2add <= 6'd2;
						end
				end
		end
	
	always@(posedge clk)
		begin
			if(rst)
				begin
					en_ib <= 0;
				end
			else
				begin
					if(round==55)
						begin
							en_ib <= 1;
						end
					else
						begin
							en_ib <= 0;
						end
				end
		end	
	
	
	reg[7:0]	in_sbox;
	reg[7:0]	out_sbox;
 
	 
	reg[7:0]  block_sbox[0:255];
	
	always @(posedge clk)
	begin		
		ck_b <= ck;
	end
	
	always@(posedge clk)
		begin
			if(rst)
				begin
					en_round <= 0;
				end
			else
				begin
					if(round==53)
						begin
							en_round <= 1;
						end
					else
						begin
							en_round <= 0;
						end
				end
		end
	
	always @(posedge clk)
		begin			
			db0_btl <= db0;
			db1_btl <= db1;
			db2_btl <= db2;
			db3_btl <= db3;
			db4_btl <= db4;
			db5_btl <= db5;
			db6_btl <= db6;
			db7_btl <= db7;
		end
	
	//process 5	
	always@(posedge clk)
		begin
			if(rst)
				begin				 
					ib0 <= 8'd0;
					ib1 <= 8'd0;
					ib2 <= 8'd0;
					ib3 <= 8'd0;
					ib4 <= 8'd0;
					ib5 <= 8'd0;
					ib6 <= 8'd0;
					ib7 <= 8'd0;
					in_sbox <= 0;
					out_sbox <= 0;  							
				end//end of rst
			else
				begin
					case(state_blk_enc)
						IDLE:
							begin
								if(en_blk_enc)
									begin									 										
										ib0 <= ib0;
										ib1 <= ib1;
										ib2 <= ib2;
										ib3 <= ib3;
										ib4 <= ib4;
										ib5 <= ib5;
										ib6 <= ib6;
										ib7 <= ib7;											 						
									end
								else
									begin									 
										ib0 <= 8'd0;
										ib1 <= 8'd0;
										ib2 <= 8'd0;
										ib3 <= 8'd0;
										ib4 <= 8'd0;
										ib5 <= 8'd0;
										ib6 <= 8'd0;
										ib7 <= 8'd0;			
									end		
								in_sbox <= 0;   
								out_sbox <= 0;
							end
						PRE_0:
							begin					
								ib0 <= db0_btl ^ ib0;
								ib1 <= db1_btl ^ ib1;
								ib2 <= db2_btl ^ ib2;
								ib3 <= db3_btl ^ ib3;
								ib4 <= db4_btl ^ ib4;
								ib5 <= db5_btl ^ ib5;
								ib6 <= db6_btl ^ ib6;
								ib7 <= db7_btl ^ ib7;
								in_sbox <= 0;
								out_sbox <= 0;	
							end
						PRE_1:
							begin																								 					 																							
								in_sbox <= kk0 ^ ib7;
							end
						PRE_2:
							begin
							  out_sbox <= block_sbox[in_sbox];  							   																									 							 																	
								in_sbox  <= kk1 ^ ib0 ^ block_sbox[in_sbox];																										
							end
						BLK_ENC:
							begin								
								out_sbox  <= block_sbox[in_sbox];
								
								ib0 <= ib1;
								ib1 <= ib2 ^ ib0;
								ib2 <= ib3 ^ ib0;
								ib3 <= ib4 ^ ib0;
								ib4 <= ib5;								 							 
						    ib5 <= ib6 ^ {out_sbox[1], out_sbox[5], out_sbox[2], out_sbox[3], out_sbox[7], out_sbox[4], out_sbox[0], out_sbox[6]};	             
								ib6 <= ib7;
								ib7 <= ib0 ^ out_sbox;								 																			
								
								case(round_2add[2:0])
									0:
										begin
										in_sbox <= kk0 ^ ({5'd0, round_2add[5:3]}) ^ ib1 ^ block_sbox[in_sbox]; 								 
										end                              
									1:                                 
										begin                             
										in_sbox <= kk1 ^ ({5'd0, round_2add[5:3]}) ^ ib1 ^ block_sbox[in_sbox]; 								 
										end                               
									2:                                  
										begin                             
										in_sbox <= kk2 ^ ({5'd0, round_2add[5:3]}) ^ ib1 ^ block_sbox[in_sbox]; 								 
										end                               
									3:                                  
										begin                             
										in_sbox <= kk3 ^ ({5'd0, round_2add[5:3]}) ^ ib1 ^ block_sbox[in_sbox]; 								 
										end                               
									4:                                  
										begin                             
										in_sbox <= kk4 ^ ({5'd0, round_2add[5:3]}) ^ ib1 ^ block_sbox[in_sbox]; 								 
										end                               
									5:                                  
										begin                             
										in_sbox <= kk5 ^ ({5'd0, round_2add[5:3]}) ^ ib1 ^ block_sbox[in_sbox]; 									 
										end                               
									6:                                  
										begin                             
										in_sbox <= kk6 ^ ({5'd0, round_2add[5:3]}) ^ ib1 ^ block_sbox[in_sbox]; 									 
										end                               
									7:                                  
										begin                             
										in_sbox <= kk7  ^ ({5'd0, round_2add[5:3]}) ^ib1 ^ block_sbox[in_sbox]; 									 
										end
								endcase 								
							end						
							
					endcase//end case state_blk_enc
				end//end of else matching if(rst)
		end//end of always@...
			
	//process 1
	always@(posedge clk)
		begin
			if(rst)
				begin			 				 
				 kk0 <= 0;
				 kk1 <= 0;
				 kk2 <= 0;
				 kk3 <= 0;
				 kk4 <= 0;
				 kk5 <= 0;
				 kk6 <= 0;
				 kk7 <= 0;
				end//end of rst
			else
				begin
					if(state_blk_enc == IDLE)
						begin															
							kk0  <= 0;									
							kk1  <= 0;									
							kk2  <= 0;									
							kk3  <= 0;									
							kk4  <= 0;
							kk5  <= 0;
							kk6  <= 0;
							kk7  <= 0;								
						end//end if state_blk_enc == IDLE;
					else if(state_blk_enc == PRE_0)
						begin
							kk0  <= {ck_b[53], ck_b[30], ck_b[4] , ck_b[52], ck_b[56], ck_b[1] , ck_b[14], ck_b[20]};									
							kk1  <= {ck_b[49], ck_b[24], ck_b[37], ck_b[12], ck_b[7] , ck_b[18], ck_b[9] , ck_b[44]};									
							kk2  <= {ck_b[42], ck_b[2] , ck_b[32], ck_b[26], ck_b[39], ck_b[19], ck_b[57], ck_b[11]};									
							kk3  <= {ck_b[36], ck_b[28], ck_b[35], ck_b[5] , ck_b[59], ck_b[47], ck_b[62], ck_b[33]};									
							kk4  <= {ck_b[17], ck_b[50], ck_b[31], ck_b[29], ck_b[23], ck_b[45], ck_b[16], ck_b[40]};
							kk5  <= {ck_b[38], ck_b[43], ck_b[8] , ck_b[55], ck_b[60], ck_b[10], ck_b[58], ck_b[27]};
							kk6  <= {ck_b[48], ck_b[21], ck_b[3] , ck_b[13], ck_b[41], ck_b[6] , ck_b[34], ck_b[61]};
							kk7  <= {ck_b[22], ck_b[63], ck_b[54], ck_b[0] , ck_b[15], ck_b[51], ck_b[46], ck_b[25]};			
						end
					else
						begin
							if(state_blk_enc == BLK_ENC)
								begin
									case(round)
										5://  change only when round is equal to 5!!!
											begin
												kk0 <= {ck_b[2] , ck_b[29], ck_b[49], ck_b[14], ck_b[43], ck_b[48], ck_b[59], ck_b[39]};
												kk1 <= {ck_b[5] , ck_b[6] , ck_b[51], ck_b[21], ck_b[32], ck_b[17], ck_b[54], ck_b[25]};
												kk2 <= {ck_b[11], ck_b[26], ck_b[23], ck_b[16], ck_b[30], ck_b[41], ck_b[35], ck_b[53]};
												kk3 <= {ck_b[50], ck_b[52], ck_b[7] , ck_b[18], ck_b[22], ck_b[40], ck_b[28], ck_b[38]};
												kk4 <= {ck_b[3] , ck_b[31], ck_b[13], ck_b[12], ck_b[19], ck_b[27], ck_b[47], ck_b[63]};
												kk5 <= {ck_b[60], ck_b[62], ck_b[20], ck_b[36], ck_b[57], ck_b[58], ck_b[15], ck_b[42]};
												kk6 <= {ck_b[0] , ck_b[56], ck_b[61], ck_b[8] , ck_b[37], ck_b[1] , ck_b[24], ck_b[55]};
												kk7 <= {ck_b[33], ck_b[46], ck_b[10], ck_b[9] , ck_b[4] , ck_b[45], ck_b[44], ck_b[34]};					
											end//end 0
										13://
											begin
												kk0 <= {ck_b[26], ck_b[12], ck_b[5] , ck_b[59], ck_b[62], ck_b[0] , ck_b[22], ck_b[30]};
												kk1 <= {ck_b[18], ck_b[1] , ck_b[45], ck_b[56], ck_b[23], ck_b[3] , ck_b[10], ck_b[34]};
												kk2 <= {ck_b[53], ck_b[16], ck_b[19], ck_b[47], ck_b[29], ck_b[37], ck_b[7] , ck_b[2] };
												kk3 <= {ck_b[31], ck_b[14], ck_b[32], ck_b[17], ck_b[33], ck_b[63], ck_b[52], ck_b[60]};
												kk4 <= {ck_b[61], ck_b[13], ck_b[8] , ck_b[21], ck_b[41], ck_b[42], ck_b[40], ck_b[46]};
												kk5 <= {ck_b[57], ck_b[28], ck_b[39], ck_b[50], ck_b[35], ck_b[15], ck_b[4] , ck_b[11]};
												kk6 <= {ck_b[9] , ck_b[43], ck_b[55], ck_b[20], ck_b[51], ck_b[48], ck_b[6] , ck_b[36]};
												kk7 <= {ck_b[38], ck_b[44], ck_b[58], ck_b[54], ck_b[49], ck_b[27], ck_b[25], ck_b[24]};					
											end//end 8
										21://
											begin
												kk0 <= {ck_b[16], ck_b[21], ck_b[18], ck_b[22], ck_b[28], ck_b[9] , ck_b[33], ck_b[29]};
												kk1 <= {ck_b[17], ck_b[48], ck_b[27], ck_b[43], ck_b[19], ck_b[61], ck_b[58], ck_b[24]};
												kk2 <= {ck_b[2] , ck_b[47], ck_b[41], ck_b[40], ck_b[12], ck_b[51], ck_b[32], ck_b[26]};
												kk3 <= {ck_b[13], ck_b[59], ck_b[23], ck_b[3] , ck_b[38], ck_b[46], ck_b[14], ck_b[57]};
												kk4 <= {ck_b[55], ck_b[8] , ck_b[20], ck_b[56], ck_b[37], ck_b[11], ck_b[63], ck_b[44]};
												kk5 <= {ck_b[35], ck_b[52], ck_b[30], ck_b[31], ck_b[7] , ck_b[4] , ck_b[49], ck_b[53]};
												kk6 <= {ck_b[54], ck_b[62], ck_b[36], ck_b[39], ck_b[45], ck_b[0] , ck_b[1] , ck_b[50]};
												kk7 <= {ck_b[60], ck_b[25], ck_b[15], ck_b[10], ck_b[5] , ck_b[42], ck_b[34], ck_b[6] };												
											end//end 16
										29://
											begin
												kk0 <= {ck_b[47], ck_b[56], ck_b[17], ck_b[33], ck_b[52], ck_b[54], ck_b[38], ck_b[12]};
												kk1 <= {ck_b[3] , ck_b[0] , ck_b[42], ck_b[62], ck_b[41], ck_b[55], ck_b[15], ck_b[6] };
												kk2 <= {ck_b[26], ck_b[40], ck_b[37], ck_b[63], ck_b[21], ck_b[45], ck_b[23], ck_b[16]};
												kk3 <= {ck_b[8] , ck_b[22], ck_b[19], ck_b[61], ck_b[60], ck_b[44], ck_b[59], ck_b[35]};
												kk4 <= {ck_b[36], ck_b[20], ck_b[39], ck_b[43], ck_b[51], ck_b[53], ck_b[46], ck_b[25]};
												kk5 <= {ck_b[7] , ck_b[14], ck_b[29], ck_b[13], ck_b[32], ck_b[49], ck_b[5] , ck_b[2] };
												kk6 <= {ck_b[10], ck_b[28], ck_b[50], ck_b[30], ck_b[27], ck_b[9] , ck_b[48], ck_b[31]};
												kk7 <= {ck_b[57], ck_b[34], ck_b[4] , ck_b[58], ck_b[18], ck_b[11], ck_b[24], ck_b[1] };												  
											end//end 24
										37://
											begin
												kk0 <= {ck_b[40], ck_b[43], ck_b[3] , ck_b[38], ck_b[14], ck_b[10], ck_b[60], ck_b[21]};
												kk1 <= {ck_b[61], ck_b[9] , ck_b[11], ck_b[28], ck_b[37], ck_b[36], ck_b[4] , ck_b[1] };
												kk2 <= {ck_b[16], ck_b[63], ck_b[51], ck_b[46], ck_b[56], ck_b[27], ck_b[19], ck_b[47]};
												kk3 <= {ck_b[20], ck_b[33], ck_b[41], ck_b[55], ck_b[57], ck_b[25], ck_b[22], ck_b[7] };
												kk4 <= {ck_b[50], ck_b[39], ck_b[30], ck_b[62], ck_b[45], ck_b[2] , ck_b[44], ck_b[34]};
												kk5 <= {ck_b[32], ck_b[59], ck_b[12], ck_b[8] , ck_b[23], ck_b[5] , ck_b[18], ck_b[26]};
												kk6 <= {ck_b[58], ck_b[52], ck_b[31], ck_b[29], ck_b[42], ck_b[54], ck_b[0] , ck_b[13]};
												kk7 <= {ck_b[35], ck_b[24], ck_b[49], ck_b[15], ck_b[17], ck_b[53], ck_b[6] , ck_b[48]};												 
											end//end 32
										45://
											begin
												 {kk0, kk1, kk2, kk3, kk4, kk5, kk6, kk7} <= ck_b;
											end//end 40															
									endcase//end case round
								end//end of if(state_blk_enc==PRE_2)							
						end//end of else matching if(state_blk_enc==IDLE)					
				end//end of else matching if(rst)
		end//end of always@...		
	
	                  
	
		
	//process 6	
	always@(posedge clk)
		begin
			if(rst)
				begin
					block_sbox[8'h0] <= 8'h3a;
					block_sbox[8'h1] <= 8'hea;
					block_sbox[8'h2] <= 8'h68;
					block_sbox[8'h3] <= 8'hfe;
					block_sbox[8'h4] <= 8'h33;
					block_sbox[8'h5] <= 8'he9;
					block_sbox[8'h6] <= 8'h88;
					block_sbox[8'h7] <= 8'h1a;
					block_sbox[8'h8] <= 8'h83;
					block_sbox[8'h9] <= 8'hcf;
					block_sbox[8'ha] <= 8'he1;
					block_sbox[8'hb] <= 8'h7f;
					block_sbox[8'hc] <= 8'hba;
					block_sbox[8'hd] <= 8'he2;
					block_sbox[8'he] <= 8'h38;
					block_sbox[8'hf] <= 8'h12;
					block_sbox[8'h10] <= 8'he8;
					block_sbox[8'h11] <= 8'h27;
					block_sbox[8'h12] <= 8'h61;
					block_sbox[8'h13] <= 8'h95;
					block_sbox[8'h14] <= 8'hc;
					block_sbox[8'h15] <= 8'h36;
					block_sbox[8'h16] <= 8'he5;
					block_sbox[8'h17] <= 8'h70;
					block_sbox[8'h18] <= 8'ha2;
					block_sbox[8'h19] <= 8'h6;
					block_sbox[8'h1a] <= 8'h82;
					block_sbox[8'h1b] <= 8'h7c;
					block_sbox[8'h1c] <= 8'h17;
					block_sbox[8'h1d] <= 8'ha3;
					block_sbox[8'h1e] <= 8'h26;
					block_sbox[8'h1f] <= 8'h49;
					block_sbox[8'h20] <= 8'hbe;
					block_sbox[8'h21] <= 8'h7a;
					block_sbox[8'h22] <= 8'h6d;
					block_sbox[8'h23] <= 8'h47;
					block_sbox[8'h24] <= 8'hc1;
					block_sbox[8'h25] <= 8'h51;
					block_sbox[8'h26] <= 8'h8f;
					block_sbox[8'h27] <= 8'hf3;
					block_sbox[8'h28] <= 8'hcc;
					block_sbox[8'h29] <= 8'h5b;
					block_sbox[8'h2a] <= 8'h67;
					block_sbox[8'h2b] <= 8'hbd;
					block_sbox[8'h2c] <= 8'hcd;
					block_sbox[8'h2d] <= 8'h18;
					block_sbox[8'h2e] <= 8'h8;
					block_sbox[8'h2f] <= 8'hc9;
					block_sbox[8'h30] <= 8'hff;
					block_sbox[8'h31] <= 8'h69;
					block_sbox[8'h32] <= 8'hef;
					block_sbox[8'h33] <= 8'h3;
					block_sbox[8'h34] <= 8'h4e;
					block_sbox[8'h35] <= 8'h48;
					block_sbox[8'h36] <= 8'h4a;
					block_sbox[8'h37] <= 8'h84;
					block_sbox[8'h38] <= 8'h3f;
					block_sbox[8'h39] <= 8'hb4;
					block_sbox[8'h3a] <= 8'h10;
					block_sbox[8'h3b] <= 8'h4;
					block_sbox[8'h3c] <= 8'hdc;
					block_sbox[8'h3d] <= 8'hf5;
					block_sbox[8'h3e] <= 8'h5c;
					block_sbox[8'h3f] <= 8'hc6;
					block_sbox[8'h40] <= 8'h16;
					block_sbox[8'h41] <= 8'hab;
					block_sbox[8'h42] <= 8'hac;
					block_sbox[8'h43] <= 8'h4c;
					block_sbox[8'h44] <= 8'hf1;
					block_sbox[8'h45] <= 8'h6a;
					block_sbox[8'h46] <= 8'h2f;
					block_sbox[8'h47] <= 8'h3c;
					block_sbox[8'h48] <= 8'h3b;
					block_sbox[8'h49] <= 8'hd4;
					block_sbox[8'h4a] <= 8'hd5;
					block_sbox[8'h4b] <= 8'h94;
					block_sbox[8'h4c] <= 8'hd0;
					block_sbox[8'h4d] <= 8'hc4;
					block_sbox[8'h4e] <= 8'h63;
					block_sbox[8'h4f] <= 8'h62;
					block_sbox[8'h50] <= 8'h71;
					block_sbox[8'h51] <= 8'ha1;
					block_sbox[8'h52] <= 8'hf9;
					block_sbox[8'h53] <= 8'h4f;
					block_sbox[8'h54] <= 8'h2e;
					block_sbox[8'h55] <= 8'haa;
					block_sbox[8'h56] <= 8'hc5;
					block_sbox[8'h57] <= 8'h56;
					block_sbox[8'h58] <= 8'he3;
					block_sbox[8'h59] <= 8'h39;
					block_sbox[8'h5a] <= 8'h93;
					block_sbox[8'h5b] <= 8'hce;
					block_sbox[8'h5c] <= 8'h65;
					block_sbox[8'h5d] <= 8'h64;
					block_sbox[8'h5e] <= 8'he4;
					block_sbox[8'h5f] <= 8'h58;
					block_sbox[8'h60] <= 8'h6c;
					block_sbox[8'h61] <= 8'h19;
					block_sbox[8'h62] <= 8'h42;
					block_sbox[8'h63] <= 8'h79;
					block_sbox[8'h64] <= 8'hdd;
					block_sbox[8'h65] <= 8'hee;
					block_sbox[8'h66] <= 8'h96;
					block_sbox[8'h67] <= 8'hf6;
					block_sbox[8'h68] <= 8'h8a;
					block_sbox[8'h69] <= 8'hec;
					block_sbox[8'h6a] <= 8'h1e;
					block_sbox[8'h6b] <= 8'h85;
					block_sbox[8'h6c] <= 8'h53;
					block_sbox[8'h6d] <= 8'h45;
					block_sbox[8'h6e] <= 8'hde;
					block_sbox[8'h6f] <= 8'hbb;
					block_sbox[8'h70] <= 8'h7e;
					block_sbox[8'h71] <= 8'ha;
					block_sbox[8'h72] <= 8'h9a;
					block_sbox[8'h73] <= 8'h13;
					block_sbox[8'h74] <= 8'h2a;
					block_sbox[8'h75] <= 8'h9d;
					block_sbox[8'h76] <= 8'hc2;
					block_sbox[8'h77] <= 8'h5e;
					block_sbox[8'h78] <= 8'h5a;
					block_sbox[8'h79] <= 8'h1f;
					block_sbox[8'h7a] <= 8'h32;
					block_sbox[8'h7b] <= 8'h35;
					block_sbox[8'h7c] <= 8'h9c;
					block_sbox[8'h7d] <= 8'ha8;
					block_sbox[8'h7e] <= 8'h73;
					block_sbox[8'h7f] <= 8'h30;
					block_sbox[8'h80] <= 8'h29;
					block_sbox[8'h81] <= 8'h3d;
					block_sbox[8'h82] <= 8'he7;
					block_sbox[8'h83] <= 8'h92;
					block_sbox[8'h84] <= 8'h87;
					block_sbox[8'h85] <= 8'h1b;
					block_sbox[8'h86] <= 8'h2b;
					block_sbox[8'h87] <= 8'h4b;
					block_sbox[8'h88] <= 8'ha5;
					block_sbox[8'h89] <= 8'h57;
					block_sbox[8'h8a] <= 8'h97;
					block_sbox[8'h8b] <= 8'h40;
					block_sbox[8'h8c] <= 8'h15;
					block_sbox[8'h8d] <= 8'he6;
					block_sbox[8'h8e] <= 8'hbc;
					block_sbox[8'h8f] <= 8'he;
					block_sbox[8'h90] <= 8'heb;
					block_sbox[8'h91] <= 8'hc3;
					block_sbox[8'h92] <= 8'h34;
					block_sbox[8'h93] <= 8'h2d;
					block_sbox[8'h94] <= 8'hb8;
					block_sbox[8'h95] <= 8'h44;
					block_sbox[8'h96] <= 8'h25;
					block_sbox[8'h97] <= 8'ha4;
					block_sbox[8'h98] <= 8'h1c;
					block_sbox[8'h99] <= 8'hc7;
					block_sbox[8'h9a] <= 8'h23;
					block_sbox[8'h9b] <= 8'hed;
					block_sbox[8'h9c] <= 8'h90;
					block_sbox[8'h9d] <= 8'h6e;
					block_sbox[8'h9e] <= 8'h50;
					block_sbox[8'h9f] <= 8'h0;
					block_sbox[8'ha0] <= 8'h99;
					block_sbox[8'ha1] <= 8'h9e;
					block_sbox[8'ha2] <= 8'h4d;
					block_sbox[8'ha3] <= 8'hd9;
					block_sbox[8'ha4] <= 8'hda;
					block_sbox[8'ha5] <= 8'h8d;
					block_sbox[8'ha6] <= 8'h6f;
					block_sbox[8'ha7] <= 8'h5f;
					block_sbox[8'ha8] <= 8'h3e;
					block_sbox[8'ha9] <= 8'hd7;
					block_sbox[8'haa] <= 8'h21;
					block_sbox[8'hab] <= 8'h74;
					block_sbox[8'hac] <= 8'h86;
					block_sbox[8'had] <= 8'hdf;
					block_sbox[8'hae] <= 8'h6b;
					block_sbox[8'haf] <= 8'h5;
					block_sbox[8'hb0] <= 8'h8e;
					block_sbox[8'hb1] <= 8'h5d;
					block_sbox[8'hb2] <= 8'h37;
					block_sbox[8'hb3] <= 8'h11;
					block_sbox[8'hb4] <= 8'hd2;
					block_sbox[8'hb5] <= 8'h28;
					block_sbox[8'hb6] <= 8'h75;
					block_sbox[8'hb7] <= 8'hd6;
					block_sbox[8'hb8] <= 8'ha7;
					block_sbox[8'hb9] <= 8'h77;
					block_sbox[8'hba] <= 8'h24;
					block_sbox[8'hbb] <= 8'hbf;
					block_sbox[8'hbc] <= 8'hf0;
					block_sbox[8'hbd] <= 8'hb0;
					block_sbox[8'hbe] <= 8'h2;
					block_sbox[8'hbf] <= 8'hb7;
					block_sbox[8'hc0] <= 8'hf8;
					block_sbox[8'hc1] <= 8'hfc;
					block_sbox[8'hc2] <= 8'h81;
					block_sbox[8'hc3] <= 8'h9;
					block_sbox[8'hc4] <= 8'hb1;
					block_sbox[8'hc5] <= 8'h1;
					block_sbox[8'hc6] <= 8'h76;
					block_sbox[8'hc7] <= 8'h91;
					block_sbox[8'hc8] <= 8'h7d;
					block_sbox[8'hc9] <= 8'hf;
					block_sbox[8'hca] <= 8'hc8;
					block_sbox[8'hcb] <= 8'ha0;
					block_sbox[8'hcc] <= 8'hf2;
					block_sbox[8'hcd] <= 8'hcb;
					block_sbox[8'hce] <= 8'h78;
					block_sbox[8'hcf] <= 8'h60;
					block_sbox[8'hd0] <= 8'hd1;
					block_sbox[8'hd1] <= 8'hf7;
					block_sbox[8'hd2] <= 8'he0;
					block_sbox[8'hd3] <= 8'hb5;
					block_sbox[8'hd4] <= 8'h98;
					block_sbox[8'hd5] <= 8'h22;
					block_sbox[8'hd6] <= 8'hb3;
					block_sbox[8'hd7] <= 8'h20;
					block_sbox[8'hd8] <= 8'h1d;
					block_sbox[8'hd9] <= 8'ha6;
					block_sbox[8'hda] <= 8'hdb;
					block_sbox[8'hdb] <= 8'h7b;
					block_sbox[8'hdc] <= 8'h59;
					block_sbox[8'hdd] <= 8'h9f;
					block_sbox[8'hde] <= 8'hae;
					block_sbox[8'hdf] <= 8'h31;
					block_sbox[8'he0] <= 8'hfb;
					block_sbox[8'he1] <= 8'hd3;
					block_sbox[8'he2] <= 8'hb6;
					block_sbox[8'he3] <= 8'hca;
					block_sbox[8'he4] <= 8'h43;
					block_sbox[8'he5] <= 8'h72;
					block_sbox[8'he6] <= 8'h7;
					block_sbox[8'he7] <= 8'hf4;
					block_sbox[8'he8] <= 8'hd8;
					block_sbox[8'he9] <= 8'h41;
					block_sbox[8'hea] <= 8'h14;
					block_sbox[8'heb] <= 8'h55;
					block_sbox[8'hec] <= 8'hd;
					block_sbox[8'hed] <= 8'h54;
					block_sbox[8'hee] <= 8'h8b;
					block_sbox[8'hef] <= 8'hb9;
					block_sbox[8'hf0] <= 8'had;
					block_sbox[8'hf1] <= 8'h46;
					block_sbox[8'hf2] <= 8'hb;
					block_sbox[8'hf3] <= 8'haf;
					block_sbox[8'hf4] <= 8'h80;
					block_sbox[8'hf5] <= 8'h52;
					block_sbox[8'hf6] <= 8'h2c;
					block_sbox[8'hf7] <= 8'hfa;
					block_sbox[8'hf8] <= 8'h8c;
					block_sbox[8'hf9] <= 8'h89;
					block_sbox[8'hfa] <= 8'h66;
					block_sbox[8'hfb] <= 8'hfd;
					block_sbox[8'hfc] <= 8'hb2;
					block_sbox[8'hfd] <= 8'ha9;
					block_sbox[8'hfe] <= 8'h9b;
					block_sbox[8'hff] <= 8'hc0;
				
				end//end of rst
			else
				begin
					block_sbox[8'h0] <= 8'h3a;
					block_sbox[8'h1] <= 8'hea;
					block_sbox[8'h2] <= 8'h68;
					block_sbox[8'h3] <= 8'hfe;
					block_sbox[8'h4] <= 8'h33;
					block_sbox[8'h5] <= 8'he9;
					block_sbox[8'h6] <= 8'h88;
					block_sbox[8'h7] <= 8'h1a;
					block_sbox[8'h8] <= 8'h83;
					block_sbox[8'h9] <= 8'hcf;
					block_sbox[8'ha] <= 8'he1;
					block_sbox[8'hb] <= 8'h7f;
					block_sbox[8'hc] <= 8'hba;
					block_sbox[8'hd] <= 8'he2;
					block_sbox[8'he] <= 8'h38;
					block_sbox[8'hf] <= 8'h12;
					block_sbox[8'h10] <= 8'he8;
					block_sbox[8'h11] <= 8'h27;
					block_sbox[8'h12] <= 8'h61;
					block_sbox[8'h13] <= 8'h95;
					block_sbox[8'h14] <= 8'hc;
					block_sbox[8'h15] <= 8'h36;
					block_sbox[8'h16] <= 8'he5;
					block_sbox[8'h17] <= 8'h70;
					block_sbox[8'h18] <= 8'ha2;
					block_sbox[8'h19] <= 8'h6;
					block_sbox[8'h1a] <= 8'h82;
					block_sbox[8'h1b] <= 8'h7c;
					block_sbox[8'h1c] <= 8'h17;
					block_sbox[8'h1d] <= 8'ha3;
					block_sbox[8'h1e] <= 8'h26;
					block_sbox[8'h1f] <= 8'h49;
					block_sbox[8'h20] <= 8'hbe;
					block_sbox[8'h21] <= 8'h7a;
					block_sbox[8'h22] <= 8'h6d;
					block_sbox[8'h23] <= 8'h47;
					block_sbox[8'h24] <= 8'hc1;
					block_sbox[8'h25] <= 8'h51;
					block_sbox[8'h26] <= 8'h8f;
					block_sbox[8'h27] <= 8'hf3;
					block_sbox[8'h28] <= 8'hcc;
					block_sbox[8'h29] <= 8'h5b;
					block_sbox[8'h2a] <= 8'h67;
					block_sbox[8'h2b] <= 8'hbd;
					block_sbox[8'h2c] <= 8'hcd;
					block_sbox[8'h2d] <= 8'h18;
					block_sbox[8'h2e] <= 8'h8;
					block_sbox[8'h2f] <= 8'hc9;
					block_sbox[8'h30] <= 8'hff;
					block_sbox[8'h31] <= 8'h69;
					block_sbox[8'h32] <= 8'hef;
					block_sbox[8'h33] <= 8'h3;
					block_sbox[8'h34] <= 8'h4e;
					block_sbox[8'h35] <= 8'h48;
					block_sbox[8'h36] <= 8'h4a;
					block_sbox[8'h37] <= 8'h84;
					block_sbox[8'h38] <= 8'h3f;
					block_sbox[8'h39] <= 8'hb4;
					block_sbox[8'h3a] <= 8'h10;
					block_sbox[8'h3b] <= 8'h4;
					block_sbox[8'h3c] <= 8'hdc;
					block_sbox[8'h3d] <= 8'hf5;
					block_sbox[8'h3e] <= 8'h5c;
					block_sbox[8'h3f] <= 8'hc6;
					block_sbox[8'h40] <= 8'h16;
					block_sbox[8'h41] <= 8'hab;
					block_sbox[8'h42] <= 8'hac;
					block_sbox[8'h43] <= 8'h4c;
					block_sbox[8'h44] <= 8'hf1;
					block_sbox[8'h45] <= 8'h6a;
					block_sbox[8'h46] <= 8'h2f;
					block_sbox[8'h47] <= 8'h3c;
					block_sbox[8'h48] <= 8'h3b;
					block_sbox[8'h49] <= 8'hd4;
					block_sbox[8'h4a] <= 8'hd5;
					block_sbox[8'h4b] <= 8'h94;
					block_sbox[8'h4c] <= 8'hd0;
					block_sbox[8'h4d] <= 8'hc4;
					block_sbox[8'h4e] <= 8'h63;
					block_sbox[8'h4f] <= 8'h62;
					block_sbox[8'h50] <= 8'h71;
					block_sbox[8'h51] <= 8'ha1;
					block_sbox[8'h52] <= 8'hf9;
					block_sbox[8'h53] <= 8'h4f;
					block_sbox[8'h54] <= 8'h2e;
					block_sbox[8'h55] <= 8'haa;
					block_sbox[8'h56] <= 8'hc5;
					block_sbox[8'h57] <= 8'h56;
					block_sbox[8'h58] <= 8'he3;
					block_sbox[8'h59] <= 8'h39;
					block_sbox[8'h5a] <= 8'h93;
					block_sbox[8'h5b] <= 8'hce;
					block_sbox[8'h5c] <= 8'h65;
					block_sbox[8'h5d] <= 8'h64;
					block_sbox[8'h5e] <= 8'he4;
					block_sbox[8'h5f] <= 8'h58;
					block_sbox[8'h60] <= 8'h6c;
					block_sbox[8'h61] <= 8'h19;
					block_sbox[8'h62] <= 8'h42;
					block_sbox[8'h63] <= 8'h79;
					block_sbox[8'h64] <= 8'hdd;
					block_sbox[8'h65] <= 8'hee;
					block_sbox[8'h66] <= 8'h96;
					block_sbox[8'h67] <= 8'hf6;
					block_sbox[8'h68] <= 8'h8a;
					block_sbox[8'h69] <= 8'hec;
					block_sbox[8'h6a] <= 8'h1e;
					block_sbox[8'h6b] <= 8'h85;
					block_sbox[8'h6c] <= 8'h53;
					block_sbox[8'h6d] <= 8'h45;
					block_sbox[8'h6e] <= 8'hde;
					block_sbox[8'h6f] <= 8'hbb;
					block_sbox[8'h70] <= 8'h7e;
					block_sbox[8'h71] <= 8'ha;
					block_sbox[8'h72] <= 8'h9a;
					block_sbox[8'h73] <= 8'h13;
					block_sbox[8'h74] <= 8'h2a;
					block_sbox[8'h75] <= 8'h9d;
					block_sbox[8'h76] <= 8'hc2;
					block_sbox[8'h77] <= 8'h5e;
					block_sbox[8'h78] <= 8'h5a;
					block_sbox[8'h79] <= 8'h1f;
					block_sbox[8'h7a] <= 8'h32;
					block_sbox[8'h7b] <= 8'h35;
					block_sbox[8'h7c] <= 8'h9c;
					block_sbox[8'h7d] <= 8'ha8;
					block_sbox[8'h7e] <= 8'h73;
					block_sbox[8'h7f] <= 8'h30;
					block_sbox[8'h80] <= 8'h29;
					block_sbox[8'h81] <= 8'h3d;
					block_sbox[8'h82] <= 8'he7;
					block_sbox[8'h83] <= 8'h92;
					block_sbox[8'h84] <= 8'h87;
					block_sbox[8'h85] <= 8'h1b;
					block_sbox[8'h86] <= 8'h2b;
					block_sbox[8'h87] <= 8'h4b;
					block_sbox[8'h88] <= 8'ha5;
					block_sbox[8'h89] <= 8'h57;
					block_sbox[8'h8a] <= 8'h97;
					block_sbox[8'h8b] <= 8'h40;
					block_sbox[8'h8c] <= 8'h15;
					block_sbox[8'h8d] <= 8'he6;
					block_sbox[8'h8e] <= 8'hbc;
					block_sbox[8'h8f] <= 8'he;
					block_sbox[8'h90] <= 8'heb;
					block_sbox[8'h91] <= 8'hc3;
					block_sbox[8'h92] <= 8'h34;
					block_sbox[8'h93] <= 8'h2d;
					block_sbox[8'h94] <= 8'hb8;
					block_sbox[8'h95] <= 8'h44;
					block_sbox[8'h96] <= 8'h25;
					block_sbox[8'h97] <= 8'ha4;
					block_sbox[8'h98] <= 8'h1c;
					block_sbox[8'h99] <= 8'hc7;
					block_sbox[8'h9a] <= 8'h23;
					block_sbox[8'h9b] <= 8'hed;
					block_sbox[8'h9c] <= 8'h90;
					block_sbox[8'h9d] <= 8'h6e;
					block_sbox[8'h9e] <= 8'h50;
					block_sbox[8'h9f] <= 8'h0;
					block_sbox[8'ha0] <= 8'h99;
					block_sbox[8'ha1] <= 8'h9e;
					block_sbox[8'ha2] <= 8'h4d;
					block_sbox[8'ha3] <= 8'hd9;
					block_sbox[8'ha4] <= 8'hda;
					block_sbox[8'ha5] <= 8'h8d;
					block_sbox[8'ha6] <= 8'h6f;
					block_sbox[8'ha7] <= 8'h5f;
					block_sbox[8'ha8] <= 8'h3e;
					block_sbox[8'ha9] <= 8'hd7;
					block_sbox[8'haa] <= 8'h21;
					block_sbox[8'hab] <= 8'h74;
					block_sbox[8'hac] <= 8'h86;
					block_sbox[8'had] <= 8'hdf;
					block_sbox[8'hae] <= 8'h6b;
					block_sbox[8'haf] <= 8'h5;
					block_sbox[8'hb0] <= 8'h8e;
					block_sbox[8'hb1] <= 8'h5d;
					block_sbox[8'hb2] <= 8'h37;
					block_sbox[8'hb3] <= 8'h11;
					block_sbox[8'hb4] <= 8'hd2;
					block_sbox[8'hb5] <= 8'h28;
					block_sbox[8'hb6] <= 8'h75;
					block_sbox[8'hb7] <= 8'hd6;
					block_sbox[8'hb8] <= 8'ha7;
					block_sbox[8'hb9] <= 8'h77;
					block_sbox[8'hba] <= 8'h24;
					block_sbox[8'hbb] <= 8'hbf;
					block_sbox[8'hbc] <= 8'hf0;
					block_sbox[8'hbd] <= 8'hb0;
					block_sbox[8'hbe] <= 8'h2;
					block_sbox[8'hbf] <= 8'hb7;
					block_sbox[8'hc0] <= 8'hf8;
					block_sbox[8'hc1] <= 8'hfc;
					block_sbox[8'hc2] <= 8'h81;
					block_sbox[8'hc3] <= 8'h9;
					block_sbox[8'hc4] <= 8'hb1;
					block_sbox[8'hc5] <= 8'h1;
					block_sbox[8'hc6] <= 8'h76;
					block_sbox[8'hc7] <= 8'h91;
					block_sbox[8'hc8] <= 8'h7d;
					block_sbox[8'hc9] <= 8'hf;
					block_sbox[8'hca] <= 8'hc8;
					block_sbox[8'hcb] <= 8'ha0;
					block_sbox[8'hcc] <= 8'hf2;
					block_sbox[8'hcd] <= 8'hcb;
					block_sbox[8'hce] <= 8'h78;
					block_sbox[8'hcf] <= 8'h60;
					block_sbox[8'hd0] <= 8'hd1;
					block_sbox[8'hd1] <= 8'hf7;
					block_sbox[8'hd2] <= 8'he0;
					block_sbox[8'hd3] <= 8'hb5;
					block_sbox[8'hd4] <= 8'h98;
					block_sbox[8'hd5] <= 8'h22;
					block_sbox[8'hd6] <= 8'hb3;
					block_sbox[8'hd7] <= 8'h20;
					block_sbox[8'hd8] <= 8'h1d;
					block_sbox[8'hd9] <= 8'ha6;
					block_sbox[8'hda] <= 8'hdb;
					block_sbox[8'hdb] <= 8'h7b;
					block_sbox[8'hdc] <= 8'h59;
					block_sbox[8'hdd] <= 8'h9f;
					block_sbox[8'hde] <= 8'hae;
					block_sbox[8'hdf] <= 8'h31;
					block_sbox[8'he0] <= 8'hfb;
					block_sbox[8'he1] <= 8'hd3;
					block_sbox[8'he2] <= 8'hb6;
					block_sbox[8'he3] <= 8'hca;
					block_sbox[8'he4] <= 8'h43;
					block_sbox[8'he5] <= 8'h72;
					block_sbox[8'he6] <= 8'h7;
					block_sbox[8'he7] <= 8'hf4;
					block_sbox[8'he8] <= 8'hd8;
					block_sbox[8'he9] <= 8'h41;
					block_sbox[8'hea] <= 8'h14;
					block_sbox[8'heb] <= 8'h55;
					block_sbox[8'hec] <= 8'hd;
					block_sbox[8'hed] <= 8'h54;
					block_sbox[8'hee] <= 8'h8b;
					block_sbox[8'hef] <= 8'hb9;
					block_sbox[8'hf0] <= 8'had;
					block_sbox[8'hf1] <= 8'h46;
					block_sbox[8'hf2] <= 8'hb;
					block_sbox[8'hf3] <= 8'haf;
					block_sbox[8'hf4] <= 8'h80;
					block_sbox[8'hf5] <= 8'h52;
					block_sbox[8'hf6] <= 8'h2c;
					block_sbox[8'hf7] <= 8'hfa;
					block_sbox[8'hf8] <= 8'h8c;
					block_sbox[8'hf9] <= 8'h89;
					block_sbox[8'hfa] <= 8'h66;
					block_sbox[8'hfb] <= 8'hfd;
					block_sbox[8'hfc] <= 8'hb2;
					block_sbox[8'hfd] <= 8'ha9;
					block_sbox[8'hfe] <= 8'h9b;
					block_sbox[8'hff] <= 8'hc0;

				end//end of else matching if(rst)
		end//end of always@...					
	        
endmodule 
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          