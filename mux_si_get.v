`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:52:52 02/09/2015 
// Design Name: 
// Module Name:    mux_si_get 
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
module mux_si_get(
clk,
rst,

ts_din,
ts_din_en,

con_din,
con_din_en,

si_dout,
si_dout_en

    );

 parameter	ONE_SECOND_CNT = 28'h9502F90;
 parameter	TIME_SET_INIT  = 10;

input					clk;
input					rst;

input [32:0]		ts_din;
input					ts_din_en;

input [7:0]			con_din;
input 				con_din_en;


output [7:0]		si_dout;
output				si_dout_en;

reg 	 [7:0]		si_dout;
reg					si_dout_en;

///////////////////////////internal varible

	reg 	[7:0]			con_cnt;
	reg    [15:0] reply_head1; //命令头中的1B命令序号+1B是否回复
    reg    [31:0] reply_head2; //2B当前包序号+2B包总个数
    reg    [7:0]  con_sfp_num; //1B光口序号
    reg    [31:0] con_ip;      //4B ip
    reg    [15:0] con_port;    //2B port  
    reg    [12:0] con_pid;     //13bit的pid
    reg    [7:0]  con_table_id;//1B的Table id
    reg    [7:0]  con_sec_num; //1B的Section_index
    reg    [7:0]  con_over_time;//1B的overtime
    
    
    reg 			 si_get_en;
    reg    [27:0] second_cnt;
    reg    [7:0]  second_num;
    reg    null_en;
    
    
        wire   sfp_num_ok;
    wire   ip_ok;
    wire   port_ok; 
    wire   check_ok;
    
      reg    [31:0]  ts_r1;
    reg    ts_en_r1;
    reg    [31:0]  ts_r2;
    
    reg    [2:0]   si_state;
    reg    [2:0]   nxt_state;
    
    reg    [31:0]  ts_reg;
    reg    wea;
    reg    [8:0]   addra;
    reg    [31:0]  dina;
    reg    [11:0]  addrb;
    wire   [7:0]   doutb;
    
    reg    [4:0]   si_cnt; 
    reg    rd_flag_lose;//可以读,去掉最末尾四个字节
    reg    rd_flag;//可以读
    reg    [11:0]  rd_num;
   
    
    reg    [2:0]   rd_state;
    reg    [2:0]   nxt_rstate;
    
    reg    [1:0]   nop_cnt;
    
////////////////////////////////////////
    parameter  IDLE = 3'b000,
               PID_CHECK = 3'b001,
               TS_WRITE_ODD = 3'b010,  
               SFP_IP_PORT_CK = 3'b011,
               PID_CHECK_EVEN = 3'b100,
               TS_WRITE_ENEN = 3'b101,
               WR_DONE_LOSE = 3'b110,
               WR_DONE = 3'b111;
               
    parameter  RD_IDLE = 3'b000,
               RD_HEAD1 = 3'b001,
               RD_HEAD2 = 3'b010,
               RD_DATA_LOSE = 3'b011,
               RD_DATA = 3'b100,
               RD_NULL = 3'b101;
    
////////////////////////////////////////////////////////////////////////////////
    assign sfp_num_ok = (con_sfp_num == iv_ts[55:48]) ? 1'b1: 1'b0;
    assign ip_ok      = (con_ip == iv_ts[47:16]) ? 1'b1 : 1'b0;
    assign port_ok    = (con_port == iv_ts[15:0]) ? 1'b1 : 1'b0;
    assign check_ok   =  sfp_num_ok & ip_ok & port_ok;
    

//////////////////////////////cmd treat

always@(posedge clk)
begin
	if(rst)
		con_cnt			<=0;
	else if(con_din_en)
		con_cnt			<=con_cnt	+1;
	else 
		con_cnt			<=0;
end

 //命令头中的1B命令序号+1B是否回复
    always @ (posedge clk)
    begin
 		if(rst)
    		reply_head1 <= 16'b0;
    	else if(i_con_en && con_cnt == 5'd0)
    		reply_head1[15:8] <= con_din;
    	else if(con_cnt == 5'd1)
    		reply_head1[7:0] <= con_din;
    	else
    		reply_head1 <= reply_head1;
    end
    
    
    //2B当前包序号+2B包总个数
    always @ (posedge clk)
    begin
    	if(rst)
    		reply_head2 <= 32'b0;
    	else if(con_cnt == 5'd2)
    		reply_head2[31:24] <= con_din;
    	else if(con_cnt == 5'd3)
    		reply_head2[23:16] <= con_din;
    	else if(con_cnt == 5'd4)
    		reply_head2[15:8] <= con_din;
    	else if(con_cnt == 5'd5)
    		reply_head2[7:0] <= con_din;
    	else
    		reply_head2 <= reply_head2;
    end
    
    
    
    //1B 光口序号
    always @ (posedge clk)
    begin
    	if(rst)
    		con_sfp_num <= 8'b0;
    	else if(con_cnt == 5'd6)
    		con_sfp_num <= con_din;
    	else
    		con_sfp_num <= con_sfp_num;
    end
    
    
    //4B ip
    always @ (posedge clk)
    begin
    	if(rst)
    		con_ip <= 32'b0;
    	else if(con_cnt == 5'd7)
    		con_ip[31:24] <= con_din;
    	else if(con_cnt == 5'd8)
    		con_ip[23:16] <= con_din;
    	else if(con_cnt == 5'd9)
    		con_ip[15:8] <= con_din;
    	else if(con_cnt == 5'd10)
    		con_ip[7:0] <= con_din;
    	else
    		con_ip <= con_ip;
    end
    
    
    //2B port
    always @ (posedge clk)
    begin
    	if(rst)
    		con_port <= 16'b0;
    	else if(con_cnt == 5'd11)
    		con_port[15:8] <= con_din;
    	else if(con_cnt == 5'd12)
    		con_port[7:0] <= con_din;
    	else
    		con_port <= con_port;
    end
    
    
    //13bit的pid
    always @ (posedge clk)
    begin
    	if(rst)
    		con_pid <= 13'b0;
    	else if(con_cnt == 5'd13)
    		con_pid[12:8] <= con_din[4:0];
    	else if(con_cnt == 5'd14)
    		con_pid[7:0] <= con_din;
    	else
    		con_pid <= con_pid;
    end
    
    //1B table id
    always @ (posedge clk)
    begin
    	if(rst)
    		con_table_id <= 8'b0;
    	else if(con_cnt == 5'd15)
    		con_table_id <= con_din;
    	else
    		con_table_id <= con_table_id;
    end
    
    
    //1B ssection_index
    always @ (posedge clk)
    begin
    	if(rst)
    		con_sec_num <= 8'b0;
    	else if(con_cnt == 5'd16)
    		con_sec_num <= con_din;
    	else
    		con_sec_num <= con_sec_num;
    end
    
    
    //1B overtime
    always @ (posedge clk)
    begin
    	if(rst)
    		con_over_time <= TIME_SET_INIT;
    	else if(con_cnt == 5'd17)
    		con_over_time <= con_din;
    	else
    		con_over_time <= con_over_time;
    end



   always @ (posedge clk)
    begin
    	if(rst)
    		si_get_en <= 1'b0;
    	else if(con_cnt == 5'd16)
    		si_get_en <= 1'b1;
    	else if(si_state == WR_DONE)
    		si_get_en <= 1'b0;
    	else if(second_num == con_over_time)
    		si_get_en	<= 1'b0;
    	else
    		si_get_en	<= si_get_en;
    end
    
    always @ (posedge clk)
    begin
    	if(rst)
    		second_cnt <= 28'b0;
    	else if(si_get_en)
    		begin
    			if(second_cnt == ONE_SECOND_CNT)//1秒
    				second_cnt <= 28'b0;
    			else
    				second_cnt <= second_cnt + 28'b1;
    		end
    	else
    		second_cnt <= 28'b0;   
    end
    
    always @ (posedge clk)
    begin
    	if(rst)
    		second_num <= 8'b0;
    	else if(si_get_en)
    		begin
    			if(second_cnt == ONE_SECOND_CNT)
    				second_num <= second_num + 8'b1;
    			else
    				second_num <= second_num;
    		end
    	else
    		second_num <= 8'b0;
    end


    always @ (posedge clk)
    begin
    	if(rst)
    		null_en <= 1'b0;
    	else if(second_num == con_over_time)//超时回复4Byte的0xff
    		null_en <= 1'b1;
    	else if(rd_state == RD_NULL)
    		null_en <= 1'b0;
    	else
    		null_en <= null_en;	
    end
    
    
 
    
    
    
    
    
    
    
    
    
    endmodule
