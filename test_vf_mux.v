`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:41:12 03/13/2015 
// Design Name: 
// Module Name:    test_vf_mux 
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
module test_vf_mux(
  input clk,
  input rst,
  
  input [31:0]	ts_din,
  input 		ts_din_en,
  
  output flag
  
    );

reg [7:0]cnt;

reg [3:0]cc1;
reg [3:0]cc2;



always@(posedge clk)
begin
if(rst)
	cnt		<=0;
else if(ts_din_en)
	cnt		<=cnt+1;
else 
	cnt		<=0;
end

always@(posedge clk)
begin
if(rst)
begin
cc1	<=0;
cc2	<=0;
end
else if(cnt==3 && ts_din[31:24]==8'h47 && ts_din [4] && ts_din[20:8]==13'h1386)
begin
cc1	<=ts_din[3:0];
cc2	<=ts_din[3:0]-cc1;

end

end

assign flag	=cc2==1?1'b0:1'b1;

endmodule
