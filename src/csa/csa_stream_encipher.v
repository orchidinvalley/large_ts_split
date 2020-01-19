`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:36:48 11/13/2008 
// Design Name: 
// Module Name:    csa_stream_encipher 
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
module csa_stream_encipher(
												clk,
												rst,												
												skip_b,												
												
												en_strm_enc_b,												  
												sb,
												ck_b,																														 
												
												round, 
												en_cb,
												cb
											);
	input				clk, rst;
	input[7:0]	skip_b; 
   
	input				en_strm_enc_b;
	input[7:0]	sb;
	input[63:0]	ck_b;
	

	output			en_cb;
	output[7:0]	cb; 
	output[1:0]	round;
	
	reg					en_cb;
	reg[7:0]		cb;
	
	
//	output 
	reg[3:0]		a0, a1, a2, a3, a4, a5, a6, a7, a8, a9;
	reg[3:0]    b0, b1, b2, b3, b4, b5, b6, b7, b8, b9;
	
	reg[4:0]    d, e, f, x, y, z, r;
	reg					p, q;
	
	reg[1:0]		sbox1[0:31];
	reg[1:0]		sbox2[0:31]; 
	reg[1:0]		sbox3[0:31];
	reg[1:0]		sbox4[0:31];
	reg[1:0]		sbox5[0:31];
	reg[1:0]		sbox6[0:31];
	reg[1:0]		sbox7[0:31];
	
	parameter   IDLE = 1'b0;
	parameter   STRM_ENC = 1'b1;	
	
	reg     		state_strm_enc;
	reg[1:0]		round;
	reg[1:0]		round_copy;
	
	reg[7:0] 		sbi; 
 
	reg init;
	reg init_copy;
	
	reg[7:0]		skip; 
   
	reg  				en_strm_enc;
	
	reg[63:0]		ck;
	always@(posedge clk)
		begin
			if(rst)
				begin
					skip <= 0;
				end
			else
				begin					
				//	skip <= skip_b;
					skip <= 187-skip_b;
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
 					en_strm_enc <= en_strm_enc_b;
 				end
 		end
  	
 	always@(posedge clk)
 		begin
 			if(rst)
 				begin
 					ck <= 0;
 				end
 			else
 				begin
 					ck <= ck_b;
 				end
 		end
 	
	always@(posedge 	clk)	
		begin
			if(rst)
				begin
					a0 <= 0;
					a1 <= 0;
					a2 <= 0;
					a3 <= 0;
					a4 <= 0;
					a5 <= 0;
					a6 <= 0;
					a7 <= 0;
					a8 <= 0;
					a9 <= 0;
					b0 <= 0;
					b1 <= 0;
					b2 <= 0;
					b3 <= 0;
					b4 <= 0;
					b5 <= 0;
					b6 <= 0;
					b7 <= 0;
					b8 <= 0;
					b9 <= 0;					
					
					d <= 0;
					e <= 0;
					f <= 0;
					p <= 0;
					q <= 0;
					r <= 0;
					x <= 0;
					y <= 0;
					z <= 0;					
					 
				end//end of 
			else
				begin
					if(state_strm_enc == STRM_ENC)
						begin
							if(init==0) 
								begin
									a0 <= a9 ^ x;
								end
							else
								begin
									if(round&1)
										begin
											a0 <= a9 ^ x ^ d ^ sbi[3:0];
										end
									else
										begin
											a0 <= a9 ^ x ^ d ^ sbi[7:4];									
										end
								end
							a1 <= a0;
							a2 <= a1;
							a3 <= a2;
							a4 <= a3;
							a5 <= a4;
							a6 <= a5;
							a7 <= a6;
							a8 <= a7;
							a9 <= a8;												
		   
		          if(p==1)
		          	begin
		          		if(init==1)
		          			begin
		          				if(round&1) 
		          					begin
		          						{b0[0], b0[3], b0[2], b0[1]} <= b6 ^ b9 ^ y ^ sbi[7:4];		
		          					end
		          				else
		          					begin
		          						{b0[0], b0[3], b0[2], b0[1]} <= b6 ^ b9 ^ y ^ sbi[3:0];
		          					end          				
		          			end
		          		else
		          			begin
		          				{b0[0], b0[3], b0[2], b0[1]} <= b6 ^ b9 ^ y;
		          			end			
		          	end//end of if(p==1)
		          else
		          	begin
		          		if(init==1)
		          			begin
		          				if(round&1) 
		          					begin
		          						b0 <= b6 ^ b9 ^ y ^ sbi[7:4];		
		          					end
		          				else
		          					begin
		          						b0 <= b6 ^ b9 ^ y ^ sbi[3:0];
		          					end 
		          			end
		          		else
		          			begin
		          				b0 <= b6 ^ b9 ^ y;
		          			end          		
		          	end//end of else matching if(p==1)
		          	          	
							b1 <= b0;
							b2 <= b1;
							b3 <= b2;
							b4 <= b3;
							b5 <= b4;
							b6 <= b5;
							b7 <= b6;
							b8 <= b7;
							b9 <= b8;
							
							
							d <= e ^ z ^ {1'b0 , b2[0]^b5[1]^b6[2]^b8[3], b5[0]^b7[1]^b2[3]^b3[2], b4[3]^b7[2]^b3[0]^b4[1], b8[2]^b5[3]^b2[1]^b7[0]};
							e <= f;
							if(q==0) 
								begin
									f <= e;
								end
							else
								begin
									f <= (z + e + r) &5'hf;
									r <= ((z+e+r)>>4)&5'h1;								 
								end						
							
						
							{x[0], z[2]} <= sbox1[{a3[0], a0[2], a5[1], a6[3], a8[0]}];
							{x[1], z[3]} <= sbox2[{a1[1], a2[2], a5[3], a6[0], a8[1]}];
							{y[0], x[2]} <= sbox3[{a0[3], a1[0], a4[1], a4[3], a5[2]}];
							{y[1], x[3]} <= sbox4[{a2[3], a0[1], a1[3], a3[2], a7[0]}];
							{z[0], y[2]} <= sbox5[{a4[2], a3[3], a5[0], a7[1], a8[2]}];
							{z[1], y[3]} <= sbox6[{a2[1], a3[1], a4[0], a6[2], a8[3]}];
							{p, q}       <= sbox7[{a1[2], a2[0], a6[1], a7[2], a7[3]}];   
							
							 					
						
						end//end of if(state_strm_enc == STRM_ENC)
					else
						begin
							if(state_strm_enc == IDLE)
								begin
									if(en_strm_enc)
										begin
											if(init)
												begin
													a0 <= ck[63:60];
													a1 <= ck[59:56];
													a2 <= ck[55:52];
													a3 <= ck[51:48];
													a4 <= ck[47:44];
													a5 <= ck[43:40];
													a6 <= ck[39:36];
													a7 <= ck[35:32];
													a8 <= 0;
													a9 <= 0;
													
													b0 <= ck[31:28];
													b1 <= ck[27:24];
													b2 <= ck[23:20];
													b3 <= ck[19:16];
													b4 <= ck[15:12];
													b5 <= ck[11:8];
													b6 <= ck[7:4];
													b7 <= ck[3:0];
													b8 <= 0;
													b9 <= 0;
													
													d <= 0;
													e <= 0;
													f <= 0;
													p <= 0;
													q <= 0;
													r <= 0;
													x <= 0;
													y <= 0;
													z <= 0;
													
												end//end of if(init)											
										end//end of if(en_strm_enc)
								end//end of if(state_strm_enc == IDLE)
						end					
				end//end of eles matching if(rst)
		end//end of always.	
 
	always@(posedge clk)
		begin
			if(rst)
				begin
					sbi <= 0;
				end
			else
				begin
					case(state_strm_enc)
						IDLE:
							begin
								sbi <= sb; 
							end
						STRM_ENC:
							begin
								//if(round==2'b11) 
								if(round_copy==2'b11) 
									begin
										sbi <= sb;
									end
								else 
									begin
										sbi <= sbi;
									end 
							end
					endcase
				end
		end	
	
	reg[7:0]	count_strm;
	reg[7:0]	count_strm_copy;
	always@(posedge 	clk)	
		begin
			if(rst)
				begin				 
					state_strm_enc <= IDLE;
				end//end of 
			else
				begin
				  case(state_strm_enc)
				  	IDLE:
				  		begin
				  			if(en_strm_enc)
									begin							
										state_strm_enc <= STRM_ENC; 
									end			
				  		end
				  	STRM_ENC:
				  		begin				  			
				  			//if((count_strm==(187-skip)  && round==2'b11)) 
				  			if((count_strm==skip  && round==2'b11)) 
				  				begin
				  					state_strm_enc <= IDLE;
				  				end
				  		end
				  	default:
				  		begin
				  			state_strm_enc <= IDLE;
				  		end
				  endcase	
				end//end of eles matching if(rst)
		end//end of always.
	
	always@(posedge clk)
		begin
			if(rst)
				begin
					count_strm <= 0;
				end
			else
				begin
					if(state_strm_enc==STRM_ENC)
						begin
							if(round==2'b11)			
								begin
									count_strm <= count_strm + 1;
									//if(count_strm==187-skip)
									/*
									if(count_strm==skip)
										begin
											count_strm <= 0;
										end
									else
										begin
											count_strm <= count_strm + 1;
										end									
									*/
								end		
						end//end of if(state_strm_enc==STRM_ENC)
					else
						begin
							count_strm <= 0;
						end										 
				end
		end	
	
	
	always@(posedge clk)
		begin
			if(rst)
				begin
					init <= 0;
				end
			else
				begin
				//	if(count_strm>=7) 
					if(count_strm>6) 
						begin
							if(round==2'b11)														
								begin
									init <= 0;
								end							
						end
					else
						begin
							init <= 1;
						end
				end
		end
		
	always@(posedge clk)
		begin
			if(rst)
				begin
					init_copy <= 0;
				end
			else
				begin
				//	if(count_strm>=7) 
					if(count_strm_copy>6) 
						begin
							if(round_copy==2'b11)														
								begin
									init_copy <= 0;
								end							
						end
					else
						begin
							init_copy <= 1;
						end
				end
		end	
		
	always @ (posedge clk)	
	begin
		if (rst)
			begin
				count_strm_copy <= 0; 
			end 
		else 
			begin
				if(state_strm_enc==STRM_ENC)
					begin												
						if(round_copy==2'b11)			
							begin
								count_strm_copy <= count_strm_copy + 1;																
							end		
						else 
							begin
								count_strm_copy <= count_strm_copy; 
							end 
					end//end of if(state_strm_enc==STRM_ENC)
				else
					begin
						count_strm_copy <= 0;
					end
			end 
	end 
	
	always@(posedge 	clk)	
		begin
			if(rst)
				begin				 
					round <= 0;
				end//end of 
			else
				begin	 
					if(state_strm_enc == STRM_ENC)
						begin
							if(round==2'b11)
								begin
									round <= 2'b00;
								end
							else
								begin
									round <= round + 1;
								end																	
						end
					else
						begin
							round <= 2'b00;
						end								
				end//end of eles matching if(rst)
		end//end of always.			
	

	always@(posedge 	clk)	
		begin
			if(rst)
				begin				 
					round_copy <= 0;
				end//end of 
			else
				begin	 
					if(state_strm_enc == STRM_ENC)
						begin
							if(round_copy==2'b11)
								begin
									round_copy <= 2'b00;
								end
							else
								begin
									round_copy <= round_copy + 1;
								end																	
						end
					else
						begin
							round_copy <= 2'b00;
						end								
				end//end of eles matching if(rst)
		end//end of always.
	
	
	
	always@(posedge clk)
		begin
			if(rst)
				begin
					en_cb <= 0;
					cb    <= 0;
				end
			else
				begin
					if(state_strm_enc==STRM_ENC)
						begin							 
							//if(count_strm <=7)
							//if(count_strm < 8)
							//if(count_strm_copy < 8)
							if (init_copy==1'b1)
								begin
									cb <= sbi;
								end//
							else
								begin								 
								//	case(round)		
									case(round_copy)		
										0:
											begin
												cb[7:6] <= {sbi[7]^e[3]^z[3]^b2[0]^b5[1]^b6[2]^b8[3]^e[2]^z[2]^b5[0]^b7[1]^b2[3]^b3[2], 
																		sbi[6]^e[1]^z[1]^b4[3]^b7[2]^b3[0]^b4[1]^e[0]^z[0]^b8[2]^b5[3]^b2[1]^b7[0]
																		};
											end
										1:
											begin												
												cb[5:4] <= {sbi[5]^e[3]^z[3]^b2[0]^b5[1]^b6[2]^b8[3]^e[2]^z[2]^b5[0]^b7[1]^b2[3]^b3[2], 
																		sbi[4]^e[1]^z[1]^b4[3]^b7[2]^b3[0]^b4[1]^e[0]^z[0]^b8[2]^b5[3]^b2[1]^b7[0]
																		};														
											end
										2:
											begin												
												cb[3:2] <= {sbi[3]^e[3]^z[3]^b2[0]^b5[1]^b6[2]^b8[3]^e[2]^z[2]^b5[0]^b7[1]^b2[3]^b3[2], 
																		sbi[2]^e[1]^z[1]^b4[3]^b7[2]^b3[0]^b4[1]^e[0]^z[0]^b8[2]^b5[3]^b2[1]^b7[0]
																		};																				
											end
										3:
											begin
												cb[1:0] <= {sbi[1]^e[3]^z[3]^b2[0]^b5[1]^b6[2]^b8[3]^e[2]^z[2]^b5[0]^b7[1]^b2[3]^b3[2], 
																		sbi[0]^e[1]^z[1]^b4[3]^b7[2]^b3[0]^b4[1]^e[0]^z[0]^b8[2]^b5[3]^b2[1]^b7[0]
																		}; 
											end
								endcase
								end//end of else matching if(count_strm <= 7)							
						end						
					else
						begin
							cb <= 8'h0;						
						end						
				//	en_cb <= (round==2'b11);
						if (round_copy==2'b11)
							begin
								en_cb <= 1; 
							end 
						else 
							begin
								en_cb <= 0; 
							end 
				end
		end	
	
		
	always@(posedge 	clk)	
		begin
			if(rst)
				begin
					
				end//end of 
			else
				begin
					sbox1[5'h0] <= 2;
					sbox1[5'h1] <= 0;
					sbox1[5'h2] <= 1;
					sbox1[5'h3] <= 1;
					sbox1[5'h4] <= 2;
					sbox1[5'h5] <= 3;
					sbox1[5'h6] <= 3;
					sbox1[5'h7] <= 0;
					sbox1[5'h8] <= 3;
					sbox1[5'h9] <= 2;
					sbox1[5'ha] <= 2;
					sbox1[5'hb] <= 0;
					sbox1[5'hc] <= 1;
					sbox1[5'hd] <= 1;
					sbox1[5'he] <= 0;
					sbox1[5'hf] <= 3;
					sbox1[5'h10] <= 0;
					sbox1[5'h11] <= 3;
					sbox1[5'h12] <= 3;
					sbox1[5'h13] <= 0;
					sbox1[5'h14] <= 2;
					sbox1[5'h15] <= 2;
					sbox1[5'h16] <= 1;
					sbox1[5'h17] <= 1;
					sbox1[5'h18] <= 2;
					sbox1[5'h19] <= 2;
					sbox1[5'h1a] <= 0;
					sbox1[5'h1b] <= 3;
					sbox1[5'h1c] <= 1;
					sbox1[5'h1d] <= 1;
					sbox1[5'h1e] <= 3;
					sbox1[5'h1f] <= 0;
					
					sbox2[5'h0] <= 3;
					sbox2[5'h1] <= 1;
					sbox2[5'h2] <= 0;
					sbox2[5'h3] <= 2;
					sbox2[5'h4] <= 2;
					sbox2[5'h5] <= 3;
					sbox2[5'h6] <= 3;
					sbox2[5'h7] <= 0;
					sbox2[5'h8] <= 1;
					sbox2[5'h9] <= 3;
					sbox2[5'ha] <= 2;
					sbox2[5'hb] <= 1;
					sbox2[5'hc] <= 0;
					sbox2[5'hd] <= 0;
					sbox2[5'he] <= 1;
					sbox2[5'hf] <= 2;
					sbox2[5'h10] <= 3;
					sbox2[5'h11] <= 1;
					sbox2[5'h12] <= 0;
					sbox2[5'h13] <= 3;
					sbox2[5'h14] <= 3;
					sbox2[5'h15] <= 2;
					sbox2[5'h16] <= 0;
					sbox2[5'h17] <= 2;
					sbox2[5'h18] <= 0;
					sbox2[5'h19] <= 0;
					sbox2[5'h1a] <= 1;
					sbox2[5'h1b] <= 2;
					sbox2[5'h1c] <= 2;
					sbox2[5'h1d] <= 1;
					sbox2[5'h1e] <= 3;
					sbox2[5'h1f] <= 1;
					
					sbox3[5'h0] <= 2;
					sbox3[5'h1] <= 0;
					sbox3[5'h2] <= 1;
					sbox3[5'h3] <= 2;
					sbox3[5'h4] <= 2;
					sbox3[5'h5] <= 3;
					sbox3[5'h6] <= 3;
					sbox3[5'h7] <= 1;
					sbox3[5'h8] <= 1;
					sbox3[5'h9] <= 1;
					sbox3[5'ha] <= 0;
					sbox3[5'hb] <= 3;
					sbox3[5'hc] <= 3;
					sbox3[5'hd] <= 0;
					sbox3[5'he] <= 2;
					sbox3[5'hf] <= 0;
					sbox3[5'h10] <= 1;
					sbox3[5'h11] <= 3;
					sbox3[5'h12] <= 0;
					sbox3[5'h13] <= 1;
					sbox3[5'h14] <= 3;
					sbox3[5'h15] <= 0;
					sbox3[5'h16] <= 2;
					sbox3[5'h17] <= 2;
					sbox3[5'h18] <= 2;
					sbox3[5'h19] <= 0;
					sbox3[5'h1a] <= 1;
					sbox3[5'h1b] <= 2;
					sbox3[5'h1c] <= 0;
					sbox3[5'h1d] <= 3;
					sbox3[5'h1e] <= 3;
					sbox3[5'h1f] <= 1;

					sbox4[5'h0] <= 3;
					sbox4[5'h1] <= 1;
					sbox4[5'h2] <= 2;
					sbox4[5'h3] <= 3;
					sbox4[5'h4] <= 0;
					sbox4[5'h5] <= 2;
					sbox4[5'h6] <= 1;
					sbox4[5'h7] <= 2;
					sbox4[5'h8] <= 1;
					sbox4[5'h9] <= 2;
					sbox4[5'ha] <= 0;
					sbox4[5'hb] <= 1;
					sbox4[5'hc] <= 3;
					sbox4[5'hd] <= 0;
					sbox4[5'he] <= 0;
					sbox4[5'hf] <= 3;
					sbox4[5'h10] <= 1;
					sbox4[5'h11] <= 0;
					sbox4[5'h12] <= 3;
					sbox4[5'h13] <= 1;
					sbox4[5'h14] <= 2;
					sbox4[5'h15] <= 3;
					sbox4[5'h16] <= 0;
					sbox4[5'h17] <= 3;
					sbox4[5'h18] <= 0;
					sbox4[5'h19] <= 3;
					sbox4[5'h1a] <= 2;
					sbox4[5'h1b] <= 0;
					sbox4[5'h1c] <= 1;
					sbox4[5'h1d] <= 2;
					sbox4[5'h1e] <= 2;
					sbox4[5'h1f] <= 1;
					
					sbox5[5'h0] <= 2;
					sbox5[5'h1] <= 0;
					sbox5[5'h2] <= 0;
					sbox5[5'h3] <= 1;
					sbox5[5'h4] <= 3;
					sbox5[5'h5] <= 2;
					sbox5[5'h6] <= 3;
					sbox5[5'h7] <= 2;
					sbox5[5'h8] <= 0;
					sbox5[5'h9] <= 1;
					sbox5[5'ha] <= 3;
					sbox5[5'hb] <= 3;
					sbox5[5'hc] <= 1;
					sbox5[5'hd] <= 0;
					sbox5[5'he] <= 2;
					sbox5[5'hf] <= 1;
					sbox5[5'h10] <= 2;
					sbox5[5'h11] <= 3;
					sbox5[5'h12] <= 2;
					sbox5[5'h13] <= 0;
					sbox5[5'h14] <= 0;
					sbox5[5'h15] <= 3;
					sbox5[5'h16] <= 1;
					sbox5[5'h17] <= 1;
					sbox5[5'h18] <= 1;
					sbox5[5'h19] <= 0;
					sbox5[5'h1a] <= 3;
					sbox5[5'h1b] <= 2;
					sbox5[5'h1c] <= 3;
					sbox5[5'h1d] <= 1;
					sbox5[5'h1e] <= 0;
					sbox5[5'h1f] <= 2;
					
					
					sbox6[5'h0] <= 0;
					sbox6[5'h1] <= 1;
					sbox6[5'h2] <= 2;
					sbox6[5'h3] <= 3;
					sbox6[5'h4] <= 1;
					sbox6[5'h5] <= 2;
					sbox6[5'h6] <= 2;
					sbox6[5'h7] <= 0;
					sbox6[5'h8] <= 0;
					sbox6[5'h9] <= 1;
					sbox6[5'ha] <= 3;
					sbox6[5'hb] <= 0;
					sbox6[5'hc] <= 2;
					sbox6[5'hd] <= 3;
					sbox6[5'he] <= 1;
					sbox6[5'hf] <= 3;
					sbox6[5'h10] <= 2;
					sbox6[5'h11] <= 3;
					sbox6[5'h12] <= 0;
					sbox6[5'h13] <= 2;
					sbox6[5'h14] <= 3;
					sbox6[5'h15] <= 0;
					sbox6[5'h16] <= 1;
					sbox6[5'h17] <= 1;
					sbox6[5'h18] <= 2;
					sbox6[5'h19] <= 1;
					sbox6[5'h1a] <= 1;
					sbox6[5'h1b] <= 2;
					sbox6[5'h1c] <= 0;
					sbox6[5'h1d] <= 3;
					sbox6[5'h1e] <= 3;
					sbox6[5'h1f] <= 0;
					
					
					sbox7[5'h0] <= 0;
					sbox7[5'h1] <= 3;
					sbox7[5'h2] <= 2;
					sbox7[5'h3] <= 2;
					sbox7[5'h4] <= 3;
					sbox7[5'h5] <= 0;
					sbox7[5'h6] <= 0;
					sbox7[5'h7] <= 1;
					sbox7[5'h8] <= 3;
					sbox7[5'h9] <= 0;
					sbox7[5'ha] <= 1;
					sbox7[5'hb] <= 3;
					sbox7[5'hc] <= 1;
					sbox7[5'hd] <= 2;
					sbox7[5'he] <= 2;
					sbox7[5'hf] <= 1;
					sbox7[5'h10] <= 1;
					sbox7[5'h11] <= 0;
					sbox7[5'h12] <= 3;
					sbox7[5'h13] <= 3;
					sbox7[5'h14] <= 0;
					sbox7[5'h15] <= 1;
					sbox7[5'h16] <= 1;
					sbox7[5'h17] <= 2;
					sbox7[5'h18] <= 2;
					sbox7[5'h19] <= 3;
					sbox7[5'h1a] <= 1;
					sbox7[5'h1b] <= 0;
					sbox7[5'h1c] <= 2;
					sbox7[5'h1d] <= 3;
					sbox7[5'h1e] <= 0;
					sbox7[5'h1f] <= 2;
				end//end of eles matching if(rst)
		end//end of always.
endmodule


