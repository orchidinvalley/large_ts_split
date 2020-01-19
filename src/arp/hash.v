`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:16:12 06/22/2010 
// Design Name: 
// Module Name:    hash 
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
module hash(
            input 			reset,
            input	[31:0]	data,
            input      		dvald,
            output  [9:0]	addr
            );
            
            reg [15:0]crc;
            //reg [15:0]new_crc; 
            reg crc_feedback;
            integer i;
            
   always @(*) begin
   if(reset)begin
   crc=0;
   crc_feedback=0;
   end
   else if(dvald)begin  
    crc=0;
   for(i=0;i<32;i=i+1)begin
    crc_feedback = crc[0]^data[i];
    
    crc[0]   =  crc[1]               ; 
    crc[1]   =  crc[2]               ;
    crc[2]   =  crc[3]               ;
    crc[3]   =  crc[4]^crc_feedback  ; 
    crc[4]   =  crc[5]               ;
    crc[5]   =  crc[6]               ;
    crc[6]   =  crc[7]               ;
    crc[7]   =  crc[8]               ;
    crc[8]   =  crc[9]               ;
    crc[9]   =  crc[10]              ;
    crc[10]  =  crc[11]^crc_feedback ;
    crc[11]  =  crc[12]              ;
    crc[12]  =  crc[13]              ;
    crc[13]  =  crc[14]              ;
    crc[14]  =  crc[15]              ;
    crc[15]  =  crc_feedback         ;
    
   end
   end
   else
    crc=0;
    crc_feedback=0;
 end
 
 assign addr = crc[9:0];
  /*always@(posedge clk)begin
    if(reset)begin
     addr_vald<=0; 
     addr     <=0;
     end
    else if(dvald)begin
     addr_vald<=1; 
     addr     <=crc[9:0];
     end
    else begin
     addr_vald<=0; 
     addr     <=addr;
     end
   end  */ 
  
endmodule
     
     
     
     
     
     
     
     
     
     
     
     
     