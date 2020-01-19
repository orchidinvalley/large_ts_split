`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:15:49 12/06/2008 
// Design Name: 
// Module Name:    csa_blk_enc 
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
// output data packet frame header
// {count_packet[7:0]}
// {ip_packet[31:24]}
// {ip_packet[23:16]}
// {ip_packet[15:8]}
// {ip_packet[7:0]}
// {port[15:8]}
// {port[7:0]}
// ts data from msb to lsb
//
//////////////////////////////////////////////////////////////////////////////////
module csa_blk_enc(
										clk,
										rst,						
						
										en_count_packet,
										count_packet, 								
										pid_num,
										en_pid_num,
										gbe_num,
										en_gbe_num,
										ip_port,
										en_ip_port,
										en_tsf,
										tsf,		
										en_cwr,
										cwr, 						
									
										//miss_sync_blkr, 
										finish_blk_enc,																				
										en_tsr,
										tsr 
									);

	input					clk, rst;		
	input         	en_count_packet; 
	input	[7:0]   count_packet; 	
	input		[7:0]pid_num;
	input			en_pid_num;
	input		[7:0]	gbe_num;
	input			en_gbe_num;
	input		[7:0]	ip_port;
	input			en_ip_port;
	input 		en_tsf;
	input	[7:0]	tsf;
	input			en_cwr;
	input	[7:0]	cwr;
	
	
	output				finish_blk_enc;

	output				en_tsr;
	output[7:0]		tsr;
	//output        miss_sync_blkr;   
  
	reg           en_blk_enc;
	reg[63:0]			ck;
	reg[1:0]		  scram_ctrl;
	reg[8:0]	    skip;
	reg						finish_blk_enc;
	reg						en_tsr;
	reg[7:0]			tsr;		
	
	reg[7:0]			i; 	
  reg[3:0]      count_dout_cwr; 
  
 
  //write ts ram..
	reg				    wr_tsr;
	reg[7:0]	    din_tsr;
	reg[7:0]	    addr_tsr;	
 	reg				    rd_tsr;
	wire[7:0]	    dout_tsr_b;
	reg[7:0]			dout_tsr;
	reg[7:0]	    count_op_tsr;		
	reg				    en_dout_tsr;
	reg				    en_dout_tsr_b;
	
	reg[2:0]      offset_rd;
	reg[2:0]		  state_op_tsr;
			
	reg				    state_blk_enc;
	reg[7:0]	    idx_cur_blk; 
	reg[7:0]	    idx_cur_blk_first, idx_cur_blk_second, idx_cur_blk_third; 
	
	wire		      en_ib;
	wire          en_round;
	reg						en_round_b;	         
	wire[7:0]		  ib0, ib1, ib2, ib3, ib4, ib5, ib6, ib7;	
	reg[7:0]      db0, db1, db2, db3, db4, db5, db6, db7;		
	reg[7:0]		  ib0_btl, ib1_btl, ib2_btl, ib3_btl, ib4_btl, ib5_btl, ib6_btl, ib7_btl;	
	
		
	parameter		  FREE = 1'b0;
	parameter     BUSY = 1'b1;		 
	
	parameter     WATCH_DOG_AGE = 8000; 
	reg[12:0]     count_state_blk, count_state_op; 
	
	//reg           miss_sync_blkr; 
 
  always@(posedge clk)
  	begin
  		if(rst)
  			begin
  				count_dout_cwr <= 0;
  				ck <= 64'd0;
  				scram_ctrl <= 0;
  			end
  		else
  			begin  				
  				if(en_cwr)
 						begin
 							case(count_dout_cwr)
						 		0:
						 			begin
						 				scram_ctrl[1]<= cwr[1];
						 				scram_ctrl[0]	<= cwr[1] & cwr[0];						 						           
				            			count_dout_cwr <= count_dout_cwr + 1;
						 			end
						 		1:
						 			begin						 				
						 				ck[63:56] <= cwr;
						 				count_dout_cwr <= count_dout_cwr + 1;
						 			end
						 		2:
						 			begin
						 				ck[55:48] <= cwr;
						 				count_dout_cwr <= count_dout_cwr + 1;
						 			end
						 		3:
						 			begin
						 				ck[47:40] <= cwr;
						 				count_dout_cwr <= count_dout_cwr + 1;
						 			end
						 		4:
						 			begin
						 				ck[39:32] <= cwr;
						 				count_dout_cwr <= count_dout_cwr + 1;
						 			end
						 		5:
						 			begin
						 				ck[31:24] <= cwr;
						 				count_dout_cwr <= count_dout_cwr + 1;
						 			end 						
						 		6:
						 			begin
						 				ck[23:16] <= cwr;
						 				count_dout_cwr <= count_dout_cwr + 1;
						 			end
						 		7:
						 			begin
						 				ck[15:8] <= cwr;
						 				count_dout_cwr <= count_dout_cwr + 1;
						 			end
						 		8:
						 			begin
						 				ck[7:0] <= cwr;				
						 				count_dout_cwr <= 0;
						 			end 						
						 	endcase
 						end//end of if(en_fifo_cw)
 					else
 						begin
 							count_dout_cwr <= count_dout_cwr;
 							ck <= ck; 							
 							scram_ctrl <= scram_ctrl; 								 
 						end
  			end
  	end     
  
  always@(posedge clk)
  	begin
  		if(rst)
  			begin  				 
  				finish_blk_enc <= 0;  				 
  			end
  		else
  			begin  				 
  				finish_blk_enc  <=  (state_op_tsr==5 && count_op_tsr==190);
  			end
  	end
  
//  csa_ram_ts	 m_csa_ram_ts
//	(
//		.clka			(clk),
//		.addra		(addr_tsr),
//		.wea			(wr_tsr),
//		.dina			(din_tsr),	
//	
//		.douta		(dout_tsr_b)				 
//	);
 
 	csa_ram_ts_dis 		m_csa_ram_ts_dis_init 
 	(
	.a(addr_tsr), // Bus [7 : 0] 
	.d(din_tsr), // Bus [7 : 0] 
	.clk(clk),
	.we(wr_tsr),
	.qspo(dout_tsr_b)
	); // Bus [7 : 0]
 	
 	
 	
 	
 always@(posedge clk)
	begin
		if(rst)
			begin
				i <= 0;					 
			end
		else
			begin				
				if(en_tsf)
					begin
						if(i==187)
							begin
								i <= 0;
							end
						else
							begin
								i <= i + 1;
							end
					end	
				else
					begin
						i <= i;
					end							 			
			end
	end
	
	reg				en_adap;		 
	
	always@(posedge clk)
		begin
			if(rst)
				begin
					en_adap <= 0;
				end
			else
				begin											 
					if(i==3 && en_tsf)
						begin
							en_adap <= tsf[5];
						end//end of if(i==3)
					else  
						begin
							en_adap <= en_adap;									
						end//end of else matching if(i==3)													 
				end
		end
	
	 
	always@(posedge clk)
		begin
			if(rst)
				begin				 				 
					skip <= 0;					 				 				 
				end
			else
				begin						 
					if(i==4 && en_tsf)
						begin
   						if(en_adap)	
								begin
									skip <= 5 + tsf; 
								end
							else
								begin
									skip <= 4;
								end
						end
					else
						begin
							skip <= skip;
						end			 
				end
		end
	
	always@(posedge clk)
  	begin
  		if(rst)
  			begin
  				state_op_tsr <= 0;  				
  			end
  		else
  			begin
  				case(state_op_tsr)
  				0:
  					begin
  						if(state_blk_enc==BUSY)
  							begin
  								if(scram_ctrl[1]==1'b1)
  									begin
  										if(skip>180)
  										  begin
  										    state_op_tsr <= 5;
  										  end
  										 else
  										   begin
  										     state_op_tsr <= 1;
  										   end
  									end
  								else
  									begin
  										state_op_tsr <= 5;
  									end  							
  							end	
  						else
  							begin			
  								state_op_tsr <= state_op_tsr; 								
  							end
  					end  				
  				1:
  					begin
  						if(count_op_tsr==9)
  							begin
  								state_op_tsr <= state_op_tsr + 1;
  							end
  						else
  							begin
  								state_op_tsr <= state_op_tsr;
  							end  					 
  					end
  				2:
  					begin  						 
  						if(count_op_tsr==9)					  						 
  							begin
  								state_op_tsr <= state_op_tsr + 1;
  							end
  						else
  							begin			 
  								state_op_tsr <= state_op_tsr;  									 
  							end
  					end  				
  				3:
  					begin
  						if(en_ib)
  							begin
  								state_op_tsr <= state_op_tsr + 1;
  							end
  						else
  							begin  								
  								if (count_state_op > WATCH_DOG_AGE)
  									begin
  										state_op_tsr <= 0; 
  									end 
  								else 
  									begin
  										state_op_tsr <= state_op_tsr;
  									end   								
  							end
  					end
  				4:
  					begin  						 		  					 		  				 
		  				if(count_op_tsr==8)					  						 
				  			begin				  						
				  				if(idx_cur_blk==0)
				  					begin
				  						state_op_tsr <= 5;				  								  								
				  					end
				  				else if(idx_cur_blk==skip)
				  					begin
				  						state_op_tsr <= 3;				  								  								
				  					end				  				
				  				else 
				  					begin
				  						state_op_tsr <= 2;
				  					end
				  			end
				  		else
				  			begin
				  				state_op_tsr <= state_op_tsr;
				  			end		  								  			
  					end  				
  				5:
  					begin
  						if(count_op_tsr==192)
  							begin
  								state_op_tsr <= 0;				 
  							end
  						else
  							begin
  								state_op_tsr <= state_op_tsr;
  							end
  					end
  				default:
  					begin
  						state_op_tsr <= 0;
  					end
  				endcase//
  			end//end of else matching if(rst)
  	end  
		
	always @ (posedge clk)	
		begin
			if (rst)
				begin
					count_state_op <= 0; 
				end 
			else 
				begin
					if ((state_op_tsr>1) && (state_op_tsr<5))
						begin
							count_state_op <= count_state_op + 1; 
						end 
					else 
						begin
							count_state_op <= 0; 
						end 
				end 
		end 
	
	always @ (posedge clk)	
		begin
			if (rst)
				begin
					count_state_blk <= 0; 
				end 
			else 
				begin
					if (state_blk_enc==BUSY)
						begin
							count_state_blk <= count_state_blk + 1; 
						end 
					else 
						begin
							count_state_blk <= 0; 
						end 
				end 
		end
		
  always@(posedge clk)
  	begin
  		if(rst)
  			begin
					wr_tsr   <= 0;
					addr_tsr <= 0;
					din_tsr  <= 0; 				
					en_dout_tsr_b <= 0;
					rd_tsr <= 0;	 		
					count_op_tsr <= 0;		
  			end
  		else
  			begin  		
  			 case(state_op_tsr)
  				0:
  					begin
  						rd_tsr <= 0;
  						wr_tsr <= en_tsf;		
  						din_tsr  <= tsf[7:0];  			  				
		  				addr_tsr <= i;
		  				count_op_tsr <= 0;  						
  					end
  				1:
  					begin
  						wr_tsr <= 0;
  						din_tsr <= 0;
  						if(count_op_tsr==9)
  							begin
  								count_op_tsr <= 0;
  							end
  						else
  							begin
  								count_op_tsr <= count_op_tsr + 1;
  							end
  							
  						if(count_op_tsr>7)  						
  							begin  								
  								rd_tsr <= 0;
  								addr_tsr <= 0;  								
  							end
  						else
  							begin  								
		  						rd_tsr <= 1;
		  						addr_tsr <= idx_cur_blk + count_op_tsr; 
  							end  						
  					end//end 1
  				2:       
  					begin  
  						wr_tsr <= 0;
  						din_tsr <= 0; 						
  						if(count_op_tsr==9)
  							begin
  								count_op_tsr <= 0;
  							end
  						else
  							begin
  								count_op_tsr <= count_op_tsr + 1;
  							end
  							
  						if(count_op_tsr>7)  						
  							begin  								
  								rd_tsr <= 0;
  								addr_tsr <= 0;  								
  							end
  						else
  							begin  								
		  						rd_tsr <= 1;
		  						addr_tsr <= idx_cur_blk - 8 + count_op_tsr; 
  							end 										 
  					end 	
  				3:
  					begin
  						wr_tsr <= 0;
  						din_tsr <= 0;
  						count_op_tsr <= 0;
  						rd_tsr <= 0;
  						addr_tsr <= 0;
  					end
  				4:
  					begin
  						rd_tsr <= 0;								 
  						if(count_op_tsr==8)  						
  							begin
  								count_op_tsr <= 0;
  								wr_tsr <= 0;
  								addr_tsr <= 0;  								
  							end
  						else
  							begin  								
  								count_op_tsr <= count_op_tsr + 1;
		  						wr_tsr <= 1;		  						 
								 	if(idx_cur_blk==0)								   
								 		begin
								 			addr_tsr <= skip + count_op_tsr;
								 		end
								 	else
								 		begin
								 			addr_tsr <= idx_cur_blk + 8 + count_op_tsr;
								 		end					 
									case(count_op_tsr)
									 0:	din_tsr <= ib0_btl;
									 1:	din_tsr <= ib1_btl;							 
									 2:	din_tsr <= ib2_btl;			 
									 3:	din_tsr <= ib3_btl; 							 
									 4:	din_tsr <= ib4_btl; 							 	
									 5: din_tsr <= ib5_btl; 							 
									 6:	din_tsr <= ib6_btl; 
									 7: din_tsr <= ib7_btl; 
									endcase										
  							end  						
  					end//end 4 
					5:
						begin
							wr_tsr <= 0;
							din_tsr <= 0;
							
							if(count_op_tsr==192)
								begin
									count_op_tsr <= 0;									 
								end
							else
								begin
									count_op_tsr <= count_op_tsr + 1;
								end							
								
							if(count_op_tsr>=188)
								begin
									rd_tsr <= 0;										
								end
							else
								begin
									rd_tsr <= 1;
									addr_tsr <= count_op_tsr;									
								end
						end						  					 				  				  				     				
  				endcase// 				
  				en_dout_tsr_b <= rd_tsr; 
  			end//end of else matching if(rst)
  	end  
  
  
  always@(posedge clk)
  	begin
  		if(rst)
  			begin
					state_blk_enc <= 0;						 					
  			end
  		else
  			begin
  				case(state_blk_enc)
  				FREE:
  					begin
  						if(i==187)
  							begin
  								state_blk_enc <= BUSY;		
  							end
  						else
  							begin
  								state_blk_enc <= state_blk_enc;
  							end  						 
  					end
  				BUSY:
  					begin
  						if((scram_ctrl[1]==1'b0)||(skip>180) )
  							begin
  								state_blk_enc <= FREE;  								 
  							end//end of if(scram_ctrl[1]==1'b0)
  						else
  							begin
  								if(state_op_tsr==4 && count_op_tsr==8 && idx_cur_blk==0) 
  									begin
  										state_blk_enc <= FREE;
  									end
  								else
  									begin
  										if (count_state_blk > WATCH_DOG_AGE)
  											begin
  												state_blk_enc <= FREE; 
  											end 
  										else 
  											begin
  												state_blk_enc <= state_blk_enc;
  											end   										
  									end
  							end //end of else matching if(scram_ctrl[1]==1'b0)
  					end
  				default:
  					begin
  						state_blk_enc <= FREE;
  					end
  				endcase
  			end
  	end       	     	
  
  reg[7:0]	idx_tsr;
  
  always@(posedge clk)  
  	begin
  		if(rst)
  			begin
  				idx_tsr <= 0;
  			end
  		else
  			begin
  				if(state_op_tsr==5)
  					begin
  						if(en_dout_tsr)
  							begin
  								idx_tsr <= idx_tsr + 1;
  							end  						
  					end
  				else
  					begin
  						idx_tsr <= 0;
  					end
  			end
  	end
      	
      	
	  always@(posedge clk)
	  begin
	  	en_dout_tsr <= en_dout_tsr_b;  	
	  	dout_tsr    <= dout_tsr_b;
	  end
	  
//  always @ (posedge clk)
//  begin
//  	if (rst)
//  	begin
//  		miss_sync_blkr <= 0; 
//  	end 
//  	else 
//  	begin
//  		if (state_op_tsr==5)
//  			begin
//  				if ((en_dout_tsr==1'b1) && (idx_tsr==0) && (dout_tsr != 8'h47))
//  					begin
//  						miss_sync_blkr <= 1'b1; 
//  					end 
//  				else 
//  					begin
//  						miss_sync_blkr <= 0; 
//  					end 
//  			end 
//  		else 
//  			begin
//  				miss_sync_blkr <= 1'b0;
//  			end 
//  	end
//  end 

//output data: 9 header + 9 cw + 192 ts  
  always@(posedge clk)
  	begin
  		if(rst)
  		begin
  			en_tsr <= 0;
  			tsr    <= 0;
  		end else if(state_op_tsr==5)  				
  		begin
  			if(en_dout_tsr)
  			begin
  				en_tsr <= 1;
  				if(idx_tsr==3 && scram_ctrl[1])
  				begin
  					tsr[7:6] <= scram_ctrl[1:0];		
  					tsr[5:0] <= dout_tsr[5:0];
  				end else
  				begin
  					tsr    <= dout_tsr;		
  				end
  								
  			end else
  			begin
  				en_tsr <= 0;
  				tsr <= 0;
  			end  						
  		end else if (en_count_packet)
  		begin
  			en_tsr  <= 1'b1; 
  			tsr		<= count_packet; 
  		end else if(en_pid_num)
		begin	
			en_tsr  <= 1'b1; 
  			tsr		<= pid_num;
		end else if(en_gbe_num)
		begin
			en_tsr  <= 1'b1; 
  			tsr		<= gbe_num;		
		end else if(en_ip_port)
		begin
			en_tsr  <= 1'b1; 
  			tsr		<= ip_port;
		end
		else if(en_cwr && count_dout_cwr == 0)
  		begin
  			en_tsr	<=	1'b1;
  			tsr		<= {7'b0, cwr[1]};
  		end else if(en_cwr)
  		begin
  			en_tsr	<=	1'b1;
  			tsr		<=	cwr;
  		end else
		begin
		  	en_tsr <= 0;
		  	tsr    <= tsr;
		end		
  	end	
 
 	always @ (posedge clk)
 	begin
 		if (rst)
 			begin
 				idx_cur_blk_first <= 0; 
 			end 
 		else 
 			begin
 				if (state_blk_enc==FREE)
 					begin
 						idx_cur_blk_first <= 188 - skip; 
 					end 
 				else 
 					begin
 						idx_cur_blk_first <= idx_cur_blk_first; 
 					end  				
 			end  		
 	end 
 		
 always @ (posedge clk)		
 begin
 	if (rst)
 		begin
 			idx_cur_blk_second <= 0; 
 		end 
 	else 
 		begin
 			if (state_blk_enc==FREE)
 				begin
 					idx_cur_blk_second <= idx_cur_blk_first & 8'hf8; 
 				end 
 			else 
 				begin
 					idx_cur_blk_second <= idx_cur_blk_second; 
 				end
 		end 
 end 
 
 always @ (posedge clk)		
 begin
 	if (rst)
 		begin
 			idx_cur_blk_third <= 0; 
 		end 
 	else 
 		begin
 			if (state_blk_enc==FREE)
 				begin
 					idx_cur_blk_third <= skip + idx_cur_blk_second; 
 				end 
 			else 
 				begin
 					idx_cur_blk_third <= idx_cur_blk_third; 
 				end
 		end 
 end
 
 
	always@(posedge clk)
		begin
			if(rst)
				begin
					idx_cur_blk <= 0;
				end
			else
				begin
					if(state_blk_enc==FREE)
						begin						 
						//	idx_cur_blk <= skip + ((188-skip)&8'hf8) - 8;						 
							idx_cur_blk <= idx_cur_blk_third - 8;						 
						end
					else 
						begin
							if(en_ib)	
								begin
									if(idx_cur_blk>skip)
										begin
											idx_cur_blk <= idx_cur_blk - 8;
										end			
									else
										begin
											idx_cur_blk <= 0;
										end													
								end
							else
								begin
									idx_cur_blk <= idx_cur_blk;
								end
						end
				end			
		end
	/*	
	always@(posedge clk)
		begin
			if(rst)
				begin
					idx_cur_blk <= 0;
				end
			else
				begin
					if(state_blk_enc==FREE)
						begin						 
							idx_cur_blk <= skip + ((188-skip)&8'hf8) - 8;						 
						end
					else 
						begin
							if(en_ib)	
								begin
									if(idx_cur_blk>skip)
										begin
											idx_cur_blk <= idx_cur_blk - 8;
										end			
									else
										begin
											idx_cur_blk <= 0;
										end													
								end
							else
								begin
									idx_cur_blk <= idx_cur_blk;
								end
						end
				end			
		end	
	*/
	//read ts ram.	
	
	always@(posedge clk)
		begin
			if(rst)
				begin
					db0 <= 0;
					db1 <= 0;
					db2 <= 0;
					db3 <= 0;
					db4 <= 0;
					db5 <= 0;
					db6 <= 0;
					db7 <= 0;
					offset_rd <= 0;
				end
			else
				begin					
					if(state_blk_enc==BUSY)
 						begin 							
 							if(en_dout_tsr)
 								begin
 									case(offset_rd)
								 		0:
								 			begin
								 				db0 <= dout_tsr;						 						           
						            offset_rd <= offset_rd + 1;
								 			end
								 		1:
								 			begin						 				
								 				db1 <= dout_tsr;
								 				offset_rd <= offset_rd + 1;
								 			end
								 		2:
								 			begin
								 				db2 <= dout_tsr;
								 				offset_rd <= offset_rd + 1;
								 			end
								 		3:
								 			begin
								 				db3 <= dout_tsr;
								 				offset_rd <= offset_rd + 1;
								 			end
								 		4:
								 			begin
								 				db4 <= dout_tsr;
								 				offset_rd <= offset_rd + 1;
								 			end
								 		5:
								 			begin
								 				db5 <= dout_tsr;
								 				offset_rd <= offset_rd + 1;
								 			end 						
								 		6:
								 			begin
								 				db6 <= dout_tsr;
								 				offset_rd <= offset_rd + 1;
								 			end
								 		7:
								 			begin
								 				db7 <= dout_tsr;
								 				offset_rd   <= 0;
								 			end						 		 			
								 	endcase
 								end//end of if(en_dout_tsr) 	
 							else
 								begin
 									db0 <= db0;
		 					 		db1 <= db1;
		 					 		db2 <= db2;
		 					 		db3 <= db3;
		 					 		db4 <= db4;
		 					 		db5 <= db5;
		 					 		db6 <= db6;
		 					 		db7 <= db7;
 								end											 					
 					 end//end of else if(state_enc==1)
 					else  
 					 begin
 					 		db0 <= 0;
 					 		db1 <= 0;
 					 		db2 <= 0;
 					 		db3 <= 0;
 					 		db4 <= 0;
 					 		db5 <= 0;
 					 		db6 <= 0;
 					 		db7 <= 0;
 					 end
				end
		end		
	
	always @(posedge clk)
		begin
			en_round_b <= en_round;
		end
	
	always@(posedge clk)
		begin
			if(rst)
				begin
					en_blk_enc <= 0;
				end
			else
				begin						
					en_blk_enc <= (state_op_tsr==2) ||
												((en_round_b==1'b1) && (idx_cur_blk>skip));					            
					              					
				end
		end
	
 
	always@(posedge clk)
		begin
			if(rst)
				begin
					ib0_btl <= 0;
					ib1_btl <= 0;
					ib2_btl <= 0;
					ib3_btl <= 0;
					ib4_btl <= 0;
					ib5_btl <= 0;
					ib6_btl <= 0;
					ib7_btl <= 0;	
				end
			else
				begin
					if(count_op_tsr==7)
						begin
							ib0_btl <= 0;
							ib1_btl <= 0;
							ib2_btl <= 0;
							ib3_btl <= 0;
							ib4_btl <= 0;
							ib5_btl <= 0;
							ib6_btl <= 0;
							ib7_btl <= 0;	
						end
					else
						begin
							if(en_ib)
								begin
									ib0_btl <= ib0;
									ib1_btl <= ib1;
									ib2_btl <= ib2;
									ib3_btl <= ib3;
									ib4_btl <= ib4;
									ib5_btl <= ib5;
									ib6_btl <= ib6;
									ib7_btl <= ib7;							 									 
								end
							else
								begin
									ib0_btl <= ib0_btl;
									ib1_btl <= ib1_btl;
									ib2_btl <= ib2_btl;
									ib3_btl <= ib3_btl;
									ib4_btl <= ib4_btl;
									ib5_btl <= ib5_btl;
									ib6_btl <= ib6_btl;
									ib7_btl <= ib7_btl;
								end
						end//end of else matching if count_op_tsr==7															
				end
		end

	
	csa_block_encipher    m_csa_block_encipher
	(
		.clk					 (clk),
		.rst					 (rst),				
	 
		.ck						 (ck),											
		.en_blk_enc		 (en_blk_enc),
		.db0					 (db0), 
		.db1					 (db1), 
		.db2					 (db2), 
		.db3					 (db3), 
		.db4					 (db4), 
		.db5					 (db5), 
		.db6					 (db6), 
		.db7					 (db7),		 
		//valid  output		 
		.en_round			 (en_round),
		.en_ib				 (en_ib),
		.ib0					 (ib0), 
		.ib1					 (ib1), 
		.ib2					 (ib2), 
		.ib3					 (ib3), 
		.ib4					 (ib4), 
		.ib5					 (ib5), 
		.ib6					 (ib6), 
		.ib7					 (ib7) 		
	);	 	
endmodule
