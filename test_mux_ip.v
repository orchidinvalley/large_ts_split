`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:41:50 03/19/2015 
// Design Name: 
// Module Name:    test_mux_ip 
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
module test_mux_ip(

clk,
rst,

ts_din,
ts_din_en,

flag

    );
    
    
input  clk;
input rst;

input [31:0]ts_din;
input 	ts_din_en;

output 	flag;

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
else if(cnt==1 && ts_din[31:24]==8'h47 && ts_din [4] && ts_din[20:8]==13'h1386)
begin
cc1	<=ts_din[3:0];
cc2	<=ts_din[3:0]-cc1;

end

end

assign flag	=cc2==1?1'b0:1'b1;


endmodule