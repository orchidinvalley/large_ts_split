`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:31:33 07/13/2010 
// Design Name: 
// Module Name:    mux_con_treat 
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
module mux_con_treat
(

	clk,
	rst,
	
	con_din,
	con_din_en,
	
	con_dout,
	con_dout_en,
	
	replay_dout,
	replay_dout_en
);
    
    input			clk;
    input			rst;
    
    input	[7:0]	con_din;
    input			con_din_en;
    
    output	[7:0]	con_dout;
    output			con_dout_en;
    
    output	[7:0]	replay_dout;
    output			replay_dout_en ;
    
    reg		[7:0]	con_dout;
    reg				con_dout_en;
    
    reg	    [7:0]	replay_dout;
    reg			    replay_dout_en ;
    
  //------------------------------------------------------------
  
  	reg		[7:0]	con_din_r1,con_din_r2,con_din_r3,con_din_r4,con_din_r5,con_din_r6,con_din_r7,con_din_r8,con_din_r9,con_din_r10,con_din_r11,con_din_r12;
  
    reg				con_din_en_r1,con_din_en_r2,con_din_en_r3,con_din_en_r4,con_din_en_r5,con_din_en_r6,con_din_en_r7,con_din_en_r8,con_din_en_r9,con_din_en_r10,con_din_en_r11,con_din_en_r12;
    				
  	reg				send_flag	;
  //-------------------------------------------
  
  
  	always @ (posedge clk) 
  	begin
  		con_din_r1  <= con_din    ;
  		con_din_r2  <= con_din_r1  ;
  		con_din_r3  <= con_din_r2  ;
  		con_din_r4  <= con_din_r3  ;
  		con_din_r5  <= con_din_r4  ;
  		con_din_r6  <= con_din_r5  ;
  		con_din_r7  <= con_din_r6  ;
  		con_din_r8  <= con_din_r7  ;
  		con_din_r9  <= con_din_r8  ;
  		con_din_r10 <= con_din_r9  ;
  		con_din_r11 <= con_din_r10 ;
  		con_din_r12 <= con_din_r11 ;
  		con_dout    <= con_din_r12 ;
  	end 
  
  
  	always @ (posedge clk) 
  	begin
  		con_din_en_r1  <= con_din_en     ;
  		con_din_en_r2  <= con_din_en_r1  ;
  		con_din_en_r3  <= con_din_en_r2  ;
  		con_din_en_r4  <= con_din_en_r3  ;
  		con_din_en_r5  <= con_din_en_r4  ;
  		con_din_en_r6  <= con_din_en_r5  ;
  		con_din_en_r7  <= con_din_en_r6  ;
  		con_din_en_r8  <= con_din_en_r7  ;
  		con_din_en_r9  <= con_din_en_r8  ;
  		con_din_en_r10 <= con_din_en_r9  ;
  		con_din_en_r11 <= con_din_en_r10 ;
  		con_din_en_r12 <= con_din_en_r11 ;
  		con_dout_en    <= con_din_en_r12 ;
  	end 
  
 	always @ (posedge clk)
 	begin
 		if(con_din_en_r4 == 0 && con_din_en_r3 == 1)
 		begin
 			if(con_din[0] == 1)
 				send_flag <= 1 ;
 			else 
 				send_flag <= 0 ;
 		end
 		else if(con_din_en_r12 == 0 && con_din_en_r11 == 1)
 			send_flag <= 0;
 		else 
 			send_flag <= send_flag ;
 	end
  
  
  	always @ (posedge clk)
  	begin
  		if(send_flag)
  		begin
  			replay_dout    <= con_din_r4;
  			replay_dout_en <= 1;
  		end
  		else
  		begin
  			replay_dout    <= 0;
  			replay_dout_en <= 0;
  		end  	
  	end
  
  
  
endmodule
