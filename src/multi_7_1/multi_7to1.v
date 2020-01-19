`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:33:41 01/28/2014 
// Design Name: 
// Module Name:    multi_7to1 
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
module multi_7to1(
  input       clk     ,
  input       rst   ,
  input   [63:0]  ts_din  ,//(ip+port)+TS
  input       ts_din_en ,
  
  output   reg     ts_ready,
  input         udp_ack,//每发送一次网络包，来2次ack   第一次ACK 用于发送IP PORT 第二次ACK用来发送TS
                  
  output  reg [63:0]  ts_dout ,//8字节有效数据，不满时 填高位空低位
  output  reg [7:0] ts_mask,//对应8字节，有效为1 
  output  reg     ts_dout_en  
//  output  reg     ts_sof,//帧起始
//  output  reg     ts_eof//帧结束


    );
    
    
   reg  [47:0]  ip_port;
   reg  [4:0]   ts_cnt;
   reg        new_frame;
   reg        new_frame_r;
   reg  [15:0]  length;//8+ts（多个包 每个包188  188*n）长度
   reg  [8:0]   length_adr;
   reg  [8:0]	addr_tmp;
   reg  [47:0]	ip_port_tmp;
   reg  [2:0]   ts_num;//一个网络包最多可包含7个TS包
   
   reg  [63:0]  ts_din_r1,ts_din_r2,ts_din_r3;
   reg 			ts_din_en_r;
   reg  [63:0]  ts_odd;
   reg  [64:0]  ts_even;
   
   reg  [8:0]   addra;
   reg  [63:0]  dina;
   reg        wea;
   reg  [8:0]   addrb;
   
   wire   [63:0]  doutb;
   reg 				doutb_en;
   reg 				doutb_en_r;
   
//   reg  [4:0]   wr_cnt;
   reg  [7:0]   rd_cnt;
   reg [7:0]	rd_num;
   reg 			rd_num_en,rd_num_en_r;
   
   reg 	[2:0]frame_cnt;
   reg 			frame_inc;
   reg			frame_dec;
   reg 			frame_in_ram;
   
   ///////写状态机  
   parameter    WR_IDLE     =0,
                WR_IP_PORT  =1,
                WR_ODD_TS =2,
                WR_ODD_WAIT=3,              
                WR_EVEN_TS  =4,
                WR_EVEN_WAIT=5,                 
                WR_LENGTH =6,
                WR_WAIT   =7;
    reg [3:0]     wr_cstate;
    reg   [3:0]     wr_cstate_r;
    reg   [3:0]     wr_nstate;
                
   reg 	[2:0] rd_cstate;
	reg	[2:0]	rd_nstate;
	parameter 	RD_IDLE		=0,
						RD_WAIT_ACK1	=1,
						RD_IP_PORT	=2,
						RD_WAIT_ACK2	=3,
						RD_TS	=4,
						RD_WAIT		=5;
   

   
   
    always@(posedge clk)
    begin
      if(rst)
      ts_cnt    <=0;
      else if(ts_din_en || ts_din_en_r)
      ts_cnt    <=ts_cnt+1;
      else 
      ts_cnt    <=0;    
    end
    
    always@(posedge clk)
    begin
    if(rst)
    begin
      ts_din_r1 <=0;
      ts_din_r2 <=0;   
      ts_din_r3 <=0; 
      ts_din_en_r <=0;
    end
    else 
    begin
      ts_din_r1 <=ts_din;
      ts_din_r2 <=ts_din_r1;    
      ts_din_r3 <=ts_din_r2;
      ts_din_en_r <=ts_din_en;
   end
   end
    
    
    
    always@(posedge clk)
    begin
      if(rst)
      ip_port <=0;
      else if(ts_cnt==0 && ts_din_en)
      ip_port <=ts_din[47:0];
      else 
      ip_port <=ip_port;
    end
    
    always@(posedge clk)
    begin
      if(rst)
      ts_num    <=0;
      else if(new_frame)
      ts_num    <=0;
      else if(ts_cnt==2)
      ts_num    <=ts_num  +1;
      else 
      ts_num    <=ts_num;
      
    end
    
    
    always@(posedge clk)
    begin
      if(rst)
      new_frame <=0;
      else if(ts_din_en && ts_cnt==0 && ts_din[47:0] != ip_port)//当下一个包的IP PORT 与前一个包不同时 开启新帧
      new_frame <=1;
      else if(ts_din_en && ts_cnt==0  && ts_num==7)
      new_frame <=1;
      else 
      new_frame <=0;
    end
    
    always@(posedge clk)
      new_frame_r <=new_frame;
    /////////////////////////////////////////
    always@(posedge clk)
    begin
      if(rst)
      wr_cstate   <=WR_IDLE;  
      else 
      wr_cstate   <=wr_nstate;
    end
    
    always@(posedge clk)
    if(rst)
      wr_cstate_r <=WR_IDLE;
    else 
      wr_cstate_r <=wr_cstate;
    
    always@(wr_cstate or new_frame or ts_cnt)
    begin
      case(wr_cstate)
      WR_IDLE : 
      if(new_frame_r)
        wr_nstate   =WR_IP_PORT;
      else 
        wr_nstate   =WR_IDLE;
    WR_IP_PORT:
      wr_nstate   =WR_ODD_TS; 
    WR_EVEN_TS:
    if(ts_cnt==26)
      wr_nstate   =WR_EVEN_WAIT;  
    else    
      wr_nstate   =WR_EVEN_TS;
    WR_EVEN_WAIT:
    if( new_frame)
      wr_nstate   =WR_LENGTH; 
    else  if(ts_cnt==3)     
      wr_nstate   =WR_ODD_TS;     
    else 
      wr_nstate   =WR_EVEN_WAIT;
    WR_ODD_TS :
    if(ts_cnt==26)
      wr_nstate   =WR_ODD_WAIT; 
    else    
      wr_nstate   =WR_ODD_TS;
    WR_ODD_WAIT:
    if( new_frame)
      wr_nstate   =WR_LENGTH; 
    else  if(ts_cnt==2)     
      wr_nstate   =WR_EVEN_TS;      
    else 
      wr_nstate   =WR_ODD_WAIT;
    WR_LENGTH:  
      wr_nstate   =WR_IP_PORT;        
    default:
      wr_nstate   =WR_IDLE;
    endcase
    
    end
    
    always@(posedge clk)
    begin
    if(rst)
      ts_odd    <=0;
    else if(wr_cstate==WR_ODD_TS && ts_cnt==24)
      ts_odd    <=ts_din;
    else
      ts_odd    <=ts_odd;    
    end    
    
    always@(posedge clk)
    begin
    if(rst)
    begin
      wea   <=0;
      dina    <=0;
      addra <=0;
    end
    else if(wr_cstate==WR_IP_PORT&& wr_cstate_r==WR_IDLE)
    begin
      wea   <=1;
      dina    <={16'h0,ts_din_r3};
      addra <=0;
    end
    else if(wr_cstate==WR_IP_PORT&& wr_cstate_r!=WR_IDLE)
    begin
      wea   <=1;
      dina    <={16'h0,ts_din_r3};
      addra <=addr_tmp+1;
    end 
    else if(wr_cstate==WR_EVEN_TS)//ts 包 位于帧中的偶位置
    begin
    if(ts_cnt==3)
    begin
       wea    <=1;
     dina   <={ts_odd[63:32],ts_din_r2[63:32]};
     addra  <=addra+1;
    end
    else 
    begin
      wea   <=1;
      dina    <={ts_din_r3[31:0],ts_din_r2[63:32]};
      addra <=addra+1;
  	end
    end
    else if(wr_cstate==WR_ODD_TS)//ts 包 位于帧中的奇位置
    begin
      wea   <=1;
      dina    <={16'h0,ts_din_r3};
      addra <=addra+1;
    end
    else if(wr_cstate== WR_ODD_WAIT && new_frame )
    begin
     wea		<=1;
     dina    <={ts_odd[63:32],32'h0};
     addra <=addra+1;
    end
    else if(wr_cstate==WR_LENGTH)//  写入长度
    begin
    wea		<=1;
    dina		<={length,ip_port_tmp};
    addra	<=length_adr;
    end
    else 
    begin
      wea   <=0;
      dina    <=0;
      addra <=addra;
    end
    end

  always@(posedge clk)
  begin
  if(rst)
  begin
    length_adr    <=0;
    ip_port_tmp	<=0;
   end
  else if(wr_cstate_r==WR_IP_PORT)
  begin
    length_adr    <=addra;
    ip_port_tmp	<=dina;  
   end
  else
  begin
    length_adr    <=length_adr;
    ip_port_tmp	<=ip_port_tmp;
   end
  end

	always@(posedge clk)
	begin
	if(rst)
		addr_tmp		<=0;
	else if(wr_cstate	==WR_LENGTH)
		  addr_tmp		<=addra;
	else 
		  addr_tmp		<=  addr_tmp;
	end

	always@(posedge clk)
	begin
	if(rst)
		length	<=0;
	else if(wr_cstate==WR_IP_PORT)
		length	<=8;
	else if((wr_cstate==WR_ODD_TS || wr_cstate ==WR_EVEN_TS) && ts_cnt==26)
		length	<=length+188;
	else 
		length	<=length;
	end
	
/////////////////////////////////////
	always@(posedge clk)
	begin
	if(rst)
		frame_inc	<=0;
	else if(wr_cstate==WR_LENGTH)
		frame_inc	<=1;
	else 
		frame_inc	<=0;	
	end
	
	always@(posedge clk)
	begin
	if(rst)
		frame_dec	<=0;
	else if(rd_cstate==RD_IP_PORT)
		frame_dec	<=1;
	else 
		frame_dec	<=0;
	end
	
	always@(posedge clk)
	begin
	if(rst)
		frame_cnt		<=0;
	else if(frame_inc &&! frame_dec)
		frame_cnt		<=frame_cnt+1;
	else if(!frame_inc && frame_dec)
		frame_cnt		<=frame_cnt-1;
	else 
		frame_cnt		<=frame_cnt;
	end
	
	always@(posedge clk)
	begin
	if(rst)
		frame_in_ram	<=0;
	else if(frame_cnt ==0)
		frame_in_ram	<=0;
	else 
		frame_in_ram	<=1;
	end
	
	

always@(posedge clk)
begin
	if(rst)
	rd_cstate		<=RD_IDLE;
	else 
	rd_cstate		<=rd_nstate;
end

always@(rd_cstate	or frame_in_ram or rd_cnt or udp_ack)
begin
case(rd_cstate)
RD_IDLE:
	if(frame_in_ram)
	rd_nstate		=	RD_WAIT_ACK1;
	else 
	rd_nstate		=RD_IDLE;
RD_WAIT_ACK1:
	if(udp_ack)		
	rd_nstate	=RD_IP_PORT;
	else 
	rd_nstate	=RD_WAIT_ACK1;
RD_IP_PORT:
	rd_nstate	=RD_WAIT_ACK2;
RD_WAIT_ACK2:
	if(udp_ack)		
	rd_nstate	=RD_TS;
	else 
	rd_nstate	=RD_WAIT_ACK2;
RD_TS:
	if(rd_cnt==rd_num+5)
	rd_nstate	=RD_WAIT;
	else 
	rd_nstate	=RD_TS;
RD_WAIT:
	rd_nstate	=RD_IDLE;
default:
	rd_nstate	=RD_IDLE;
endcase
end

always@(posedge clk)
begin
if(rst)
	ts_ready	<=0;
else if(rd_cstate==RD_WAIT_ACK1 && ~udp_ack)
	ts_ready	<=1;
else 
	ts_ready	<=0;
end

always@(posedge clk)
begin
if(rst)
	rd_num_en	<=0;
else if(rd_cstate==RD_IP_PORT)
	rd_num_en	<=1;
else 
	rd_num_en	<=0;
end

always@(posedge clk)
begin
rd_num_en_r	<=rd_num_en;
end

always@(posedge clk)
begin
	if(rst)
	rd_num	<=0;
	else if(rd_num_en_r)
	begin
	case(doutb[63:48])
	196:
		rd_num	<=24;
	384:
		rd_num	<=47;
	572:
		rd_num	<=71;
	760:
		rd_num	<=94;
	948:
		rd_num	<=118;
	1136:
		rd_num	<=141;
	1324:
		rd_num	<=165;
	default:
		rd_num	<=0;
	endcase
	end
	else 
	rd_num	<=rd_num;
end

always@(posedge clk)
begin
if(rst)
begin
	addrb	<=9'h1ff;
	doutb_en<=0;
end
else if (rd_cstate==RD_IP_PORT)
begin
	addrb	<= addrb+1;
	doutb_en	<=1;
end
else if(rd_cstate==RD_TS && rd_cnt	< rd_num)
begin
	addrb	<=addrb+1;
	doutb_en	<=1;
end
else 
begin
	addrb	<=addrb;
	doutb_en	<=0;
end
end

always@(posedge clk)
doutb_en_r	<=doutb_en;

always@(posedge clk)
begin
	if(rst)
	rd_cnt	<=0;
	else if(rd_cstate==RD_TS)
	rd_cnt	<=rd_cnt+1;
	else 
	rd_cnt	<=0;
end

always@(posedge clk)
begin
if(rst)
begin
 ts_dout 		<=0;
ts_mask		<=0;
ts_dout_en	<=0;
//ts_sof			<=0;
//ts_eof			<=0;
end
else if(doutb_en_r && rd_num_en_r)
begin
 ts_dout 		<=doutb;
ts_mask		<=8'hff;
ts_dout_en	<=1;
//ts_sof			<=1;
//ts_eof			<=0;
end
else if(doutb_en_r && rd_cnt	<rd_num+1)
begin
 ts_dout 		<=doutb;
ts_mask		<=8'hff;
ts_dout_en	<=1;
//ts_sof			<=0;
//ts_eof			<=0;
end
else if(doutb_en_r && rd_cnt==rd_num+1)
begin
 ts_dout 		<=doutb;
ts_dout_en	<=1;
//ts_sof			<=0;
//ts_eof			<=1;
case(rd_num)
24:
	ts_mask		<=8'hf0;
47:
	ts_mask		<=8'hff;
71:
	ts_mask		<=8'hf0;
94:
	ts_mask		<=8'hff;
118:
	ts_mask		<=8'hf0;
141:
	ts_mask		<=8'hff;
165:
	ts_mask		<=8'hff;
default:
	ts_mask		<=8'h00;
endcase
end
else 
begin
ts_dout 		<=0;
ts_mask		<=0;
ts_dout_en	<=0;
//ts_sof			<=0;
//ts_eof			<=0;
end
end


ts_pack_ram uut (
  .clka(clk),
  .wea(wea), // Bus [0 : 0] 
  .addra(addra), // Bus [8 : 0] 
  .dina(dina), // Bus [63 : 0] 
  .clkb(clk),
  .addrb(addrb), // Bus [8 : 0] 
  .doutb(doutb)); // Bus [63 : 0] 

endmodule
