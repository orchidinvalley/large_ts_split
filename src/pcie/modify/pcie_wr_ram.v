`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:32:08 02/25/2014 
// Design Name: 
// Module Name:    pcie_wr_ram 
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
module pcie_wr_ram(
clk,
rst,

dma_read_start,

//dma_waddr_en ,               
//dma_waddr ,
dma_wdata_en,        
dma_wdata ,
dma_wdata_rdy,

ott_ram_wr,
ott_ram_waddr,
ott_ram_dina,
ott_ram_clear,

dvb_cmd_dout,
dvb_cmd_sof,
dvb_cmd_eof,
dvb_cmd_dout_en            


    );

input 	clk;
input 	rst;

input				dma_read_start;

//input				dma_waddr_en ;
//input	[31:0]	dma_waddr;//字节地址
input				dma_wdata_en;    
input	[63:0]	dma_wdata;
output 			dma_wdata_rdy;

output				ott_ram_wr;
output 	[12:0]	ott_ram_waddr;//16字节为单位的地址
output 	[127:0]	ott_ram_dina;
output				ott_ram_clear;
reg						ott_ram_clear;

output	[63:0]	dvb_cmd_dout;
output 				dvb_cmd_dout_en;
output 				dvb_cmd_sof;
output 				dvb_cmd_eof;

assign	 			dma_wdata_rdy=1;

//reg				ott_ram_wr;
//reg 	[12:0]	ott_ram_waddr;
//reg 	[127:0]	ott_ram_dina;

reg	[63:0]	dvb_cmd_dout;
reg 				dvb_cmd_dout_en;
reg 				dvb_cmd_sof;
reg 				dvb_cmd_eof;


reg 	[127:0]		key;
reg 	[127:0]		aes_in;
reg 					aes_in_en;
wire 					aes_out_en;
wire 	[127:0]		aes_out;

//reg	[12:0]	waddr_tmp;
reg				wdata_en;
reg 	[14:0]	dma_len;//DMA 传输数据长度，8字节为单位
reg 	[14:0]	dma_cnt;

reg [8:0]	cmd_cnt;
reg [8:0]	cmd_len;
wire [12:0]  len_tmp;


reg	[1:0]		cstate;
reg	[1:0]		nstate;

parameter	IDLE=0,
					TS_CMD_DIFF=1,
					TS_AES_DO=2,
					CMD_SEND=3;
					
//always@(posedge clk)
//begin
//	if(rst)
//	waddr_tmp	<=0;
//	else if(dma_waddr_en)
//	waddr_tmp	<=dma_waddr;
//	else
//	waddr_tmp	<=waddr_tmp;	
//end					
					
always@(posedge clk)
begin
	if(rst)
	cstate	<=IDLE;
	else 
	cstate	<=nstate;	
end					
					
always@(cstate	or		dma_read_start	or dma_wdata_en  or dma_wdata or dma_cnt or dma_len or cmd_cnt)
begin
case(cstate)
	IDLE:
	if(dma_read_start)
		nstate	=	TS_CMD_DIFF;
	else 
		nstate	=	IDLE;		
	TS_CMD_DIFF:
	if(dma_wdata_en)
	begin
	if(dma_wdata[7:0]==8'h50)
		nstate	=	TS_AES_DO;
	else if(dma_wdata[7:0]==8'h05)
		nstate	=	CMD_SEND;
	else
		nstate	=	IDLE;
	end
	else 
		nstate	=	TS_CMD_DIFF;
//	TS_AES_DO:
//	if(dma_cnt==dma_len)
//		nstate	=	IDLE;
//	else 
//		nstate	=TS_AES_DO;
	CMD_SEND:
	if(cmd_cnt==dma_len)
		nstate	=	IDLE;
	else 
		nstate	=CMD_SEND;
	default:
		nstate	=	IDLE;
endcase
end					


always@(posedge clk)
begin
	if(rst)
	dma_len	<=0;
	else if(cstate==TS_CMD_DIFF&& dma_wdata_en)
	dma_len	<={dma_wdata[31:24],dma_wdata[39:32]};
	else 
	dma_len	<=dma_len;
end

always@(posedge clk)begin
	if(rst)	
		ott_ram_clear	<=0;
	else if((cstate==TS_CMD_DIFF && nstate==TS_AES_DO)||cstate==TS_AES_DO)
		ott_ram_clear	<=1;
	else
		ott_ram_clear	<=0;
end


//always@(posedge clk)
//begin
//	if(rst)
//	dma_cnt	<=0;	
//	else if(cstate==TS_CMD_DIFF || cstate==TS_AES_DO)
//	begin
//	if(dma_wdata_en)
//	dma_cnt	<=dma_cnt+1;
//	else 
//	dma_cnt	<=dma_cnt;
//	end
//	else 
//	dma_cnt	<=0;
//end

//always@(posedge clk)
//begin
//	if(rst)
//	key	<=0;
//	else if(dma_cnt==2 && dma_wdata_en)
//	key	<={dma_wdata[7:0],dma_wdata[15:8],dma_wdata[23:16],dma_wdata[31:24],
//				dma_wdata[39:32],dma_wdata[47:40],dma_wdata[55:48],dma_wdata[63:56],
//				64'h0};
//	else if(dma_cnt==3 && dma_wdata_en)
//	key	<={key[127:64],
//				dma_wdata[7:0],dma_wdata[15:8],dma_wdata[23:16],dma_wdata[31:24],
//				dma_wdata[39:32],dma_wdata[47:40],dma_wdata[55:48],dma_wdata[63:56]};
//	else 
//	key	<=key;
//end
//
//always@(posedge clk)
//begin
//	if(rst)
//	begin
//	aes_in_en	<=0;
//	aes_in		<=0;
//	end
//	else if(cstate==TS_AES_DO && dma_wdata_en && dma_cnt>3)
//	begin	
//	if(dma_cnt[0])	
//	begin
//	aes_in		<={aes_in[127:64],
//				dma_wdata[7:0],dma_wdata[15:8],dma_wdata[23:16],dma_wdata[31:24],
//				dma_wdata[39:32],dma_wdata[47:40],dma_wdata[55:48],dma_wdata[63:56]};
//	aes_in_en	<=1;
//	end
//	else 
//	begin
//	aes_in		<={dma_wdata[7:0],dma_wdata[15:8],dma_wdata[23:16],dma_wdata[31:24],
//				dma_wdata[39:32],dma_wdata[47:40],dma_wdata[55:48],dma_wdata[63:56],
//				64'h0};
//	aes_in_en	<=0;
//	end
//	end
//	else 
//	begin
//	aes_in_en	<=0;
//	aes_in		<=0;	
//	end
//end

//aes_out_shift	out_shift
//	(
//	.clk				(clk),
//	.d					(aes_in_en),
//	.q					(aes_out_en)
//	);
//
////aes_nec
////  		u (
////    .d 		(aes_in),		
////    .clk 	(clk),
////    .q 		(aes_out)
////  );
//
//aes_128		u_aes
//	(
//	.clk				(clk), 
//	.state			(aes_in), 
//	.key				(key), 
//	.out				(aes_out)
//	);


//Top_PipelinedCipher u_aes (
//    .clk(clk), 
//    .reset(!rst), 
//    .data_valid_in(aes_in_en), 
//    .cipherkey_valid_in(aes_in_en), 
//    .cipher_key(key), 
//    .plain_text(aes_in), 
//    .valid_out(aes_out_en), 
//    .cipher_text(aes_out)
//    );
//
//
//always@(posedge clk)
//begin
//	if(rst)
//	begin	
//	ott_ram_wr		<=0;
//	ott_ram_waddr	<=0;
//	ott_ram_dina	<=0;
//	end
//	else if(nstate==TS_AES_DO && dma_wdata_en && (dma_cnt==0|| dma_cnt==2))
//	begin
//	ott_ram_wr		<=0;
//	ott_ram_waddr	<=0;
//	ott_ram_dina	<={dma_wdata[7:0],dma_wdata[15:8],dma_wdata[23:16],dma_wdata[31:24],
//				dma_wdata[39:32],dma_wdata[47:40],dma_wdata[55:48],dma_wdata[63:56],
//				64'h0};
//	end
//	else if(nstate==TS_AES_DO && dma_wdata_en && dma_cnt==1)
//	begin
//	ott_ram_wr		<=1;
//	ott_ram_waddr	<=0;
//	ott_ram_dina	<={ott_ram_dina[127:64],
//				dma_wdata[7:0],dma_wdata[15:8],dma_wdata[23:16],dma_wdata[31:24],
//				dma_wdata[39:32],dma_wdata[47:40],dma_wdata[55:48],dma_wdata[63:56]};
//	end
//	else if(dma_wdata_en && dma_cnt==3)
//	begin
//	ott_ram_wr		<=1;
//	ott_ram_waddr	<=ott_ram_waddr+1;
//	ott_ram_dina	<={ott_ram_dina[127:64],
//				dma_wdata[7:0],dma_wdata[15:8],dma_wdata[23:16],dma_wdata[31:24],
//				dma_wdata[39:32],dma_wdata[47:40],dma_wdata[55:48],dma_wdata[63:56]};
//	end
//	else if(aes_out_en)
//	begin
//	ott_ram_wr		<=1;
//	ott_ram_waddr	<=ott_ram_waddr+1;
//	ott_ram_dina	<={aes_out[7:0],aes_out[15:8],aes_out[23:16],aes_out[31:24],
//								aes_out[39:32],aes_out[47:40],aes_out[55:48],aes_out[63:56],
//								aes_out[71:64],aes_out[79:72],aes_out[87:80],aes_out[95:88],
//								aes_out[103:96],aes_out[111:104],aes_out[119:112],aes_out[127:120]};
//	end
//	else
//	begin
//	ott_ram_wr		<=0;
//	ott_ram_waddr	<=ott_ram_waddr;
//	ott_ram_dina	<=0;	
//	end
//end

////////////////////////////////////////////////DVB 命令处理




always@(posedge clk)
begin
	if(rst)
	cmd_cnt	<=0;	
	else if(cstate==TS_CMD_DIFF || cstate==CMD_SEND)
	begin
	if(dma_wdata_en)
	cmd_cnt	<=cmd_cnt+1;
	else 
	cmd_cnt	<=cmd_cnt;
	end
	else 
	cmd_cnt	<=0;
end

assign	len_tmp	=({dma_wdata[4:0],dma_wdata[15:8]}+13'h2);

always@(posedge clk)
begin
	if(rst)
	cmd_len	<=0;
	else if(cstate==IDLE)
	cmd_len	<=2;
	else if(cmd_cnt==2 && dma_wdata_en)
	if(len_tmp[2:0])
	cmd_len	<=len_tmp[12:3]+3;
	else 
	cmd_len	<=len_tmp[12:3]+2;
	else 
	cmd_len	<=cmd_len;
end


always@(posedge	clk )
begin
	if(rst)
	begin
	dvb_cmd_dout			<=0;
	dvb_cmd_dout_en	<=0;
	dvb_cmd_sof			<=0;	
	dvb_cmd_eof			<=0;
	end
	else if(cstate==CMD_SEND && dma_wdata_en &&cmd_cnt>1 )
	begin	
	dvb_cmd_dout			<=dma_wdata;
	if(cmd_cnt==2)
	dvb_cmd_dout_en	<=1;
	else if(cmd_cnt<cmd_len)
	dvb_cmd_dout_en	<=1;
	else
	dvb_cmd_dout_en	<=0;
	if(cmd_cnt==2 )// 因为DVB 的命令固定为8个，命令 有效部分最小为1字节，DVB命令的长度最小为9，再加2长度字节大于8 
	dvb_cmd_sof			<=1;	
	else 
	dvb_cmd_sof			<=0;	
	if(cmd_cnt+1==cmd_len)
	dvb_cmd_eof			<=1;
	else 
	dvb_cmd_eof			<=0;	
	end
	else 
	begin
	dvb_cmd_dout			<=0;
	dvb_cmd_dout_en	<=0;
	dvb_cmd_sof			<=0;	
	dvb_cmd_eof			<=0;		
	end
end

endmodule
