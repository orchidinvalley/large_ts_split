`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    17:46:28 02/25/2014
// Design Name:
// Module Name:    pcie_rd_ram
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
module pcie_rd_ram(
clk,
rst,

//dma_write_start,
//dma_rdata_en,					// : out std_logic;
dma_rdata,						// : in std_logic_vector(63 downto 0);
dma_raddr_en,					//: out std_logic;
dma_raddr,						// : out std_logic_vector(31 downto 0);
dma_rdata_rdy,				// : in std_logic;
dma_rdata_busy ,				//: in std_logic;

ott_ram_clear,
ott_raddr,
ott_doutb,
dvb_raddr,
dvb_doutb,

ts_ram_valid,
test_flag
    );

input						clk;
input						rst;

//input 					dma_write_start;
//input						dma_rdata_en;					// : out std_logic;
output	[63:0]		dma_rdata;						// : in std_logic_vector(63 downto 0);
input						dma_raddr_en;					//: out std_logic;
input		[31:0]				dma_raddr;						// : out std_logic_vector(31 downto 0);///�ֽڵ�ַ
output						dma_rdata_rdy;				// : in std_logic;
output						dma_rdata_busy ;				//: in std_logic;

input							ott_ram_clear;
output 	[10:0]		ott_raddr;
input 	[511:0]		ott_doutb;
output 	[5:0]			dvb_raddr;
input 	[511:0]		dvb_doutb;

input 	ts_ram_valid;


output test_flag;


wire 					dma_rdata_rdy;
wire	[63:0]		dma_rdata;

wire 	[10:0]		ott_raddr;

wire 	[5:0]			dvb_raddr;

wire 					empty;
wire					prog_full;
wire 					rd_en;
wire 	[11:0]		dout;
reg 					ott_dvb_en;//0 ott 1dvb


wire 		prog_empty;
reg 		data_wr;
reg	[511:0]	data_din;
wire 		data_rd;
wire 		data_empty;


reg 	[1:0]			cstate;
reg	[1:0]			nstate;

parameter 		IDLE	=0,
						RD_ADDR=1,
						WR_DATA=2;


reg rd_cstate;
reg rd_nstate;

parameter		RD_IDLE=0,
					SEND_DATA=1;

assign  dma_rdata_busy=prog_full;


reg	[3:0]tsmf_cc;
	reg	[3:0]tsmf_cnt;
//	reg test_flag;

reg	[63:0]switch_reg;
wire [63:0]fifo_dout;

assign dma_rdata=fifo_dout&switch_reg;
reg	[63:0]dma_rdata_r;

always@(posedge clk)
	dma_rdata_r	<=	dma_rdata;


	always@(posedge clk)begin
		if(rst)
			tsmf_cnt	<=0;
		else if(dma_raddr_en && dma_raddr==32'h0000c0 && dma_rdata[55:32]==24'hfe1f47 && dma_rdata_r==64'haaaaaaaa28000000)
			tsmf_cnt	<=dma_rdata[59:56];
		else
			tsmf_cnt		<=tsmf_cnt;
	end

	always@(posedge clk)begin
		if(rst)
			tsmf_cc	<=0;
		else if(dma_raddr_en && dma_raddr==32'h0000c0 && dma_rdata[55:32]==24'hfe1f47 && dma_rdata_r==64'haaaaaaaa28000000)
				tsmf_cc	<=dma_rdata[59:56]-tsmf_cnt;
		else
			tsmf_cc	<=	tsmf_cc;
	end

//	always@(posedge clk)begin
//		if(rst)
//			test_flag	<=0;
//		else if(dma_raddr_en && dma_raddr==32'h000100)
//			test_flag	<=tsmf_cc==1;
//		else
//			test_flag	<=test_flag;
//	end

	assign test_flag=tsmf_cc==1?1'b0:1'b1;


always@(posedge clk)
begin
	if(rst)
	cstate		<=IDLE;
	else
	cstate		<=nstate;
end

always@(cstate or empty )
begin
	case(cstate)
	IDLE:
		if(!empty)
		nstate		=	RD_ADDR;
		else
		nstate		=	IDLE;
	RD_ADDR:
		nstate		=	WR_DATA;
	WR_DATA:
		nstate		=	IDLE;
	default:
		nstate		=	IDLE;
	endcase
end

assign rd_en=nstate==RD_ADDR?1'b1:1'b0;

assign ott_raddr=(dout[11]==0)?dout[10:0]:11'b0;
assign dvb_raddr=(dout[11]==1)?dout[5:0]:6'b0;

reg	ts_ram_v1,ts_ram_v2,ts_ram_v3;
wire 	ott_ram_set=ts_ram_v2&!ts_ram_v3;
reg		ott_ram_clear_r;

wire 	ott_ram_clr=ott_ram_clear&!ott_ram_clear_r;


always@(posedge clk)begin
	if(rst)
		switch_reg	<=64'h0000000000000000;
	else 	if(ott_ram_set)
		switch_reg	<=64'hffffffffffffffff;
//	else	if(dma_raddr_en && dma_raddr==32'h00020fc0)
	else if(ott_ram_clr && !ott_ram_set)
		switch_reg	<=64'h0000000000000000;	
	else
		switch_reg	<=switch_reg;
end

always@(posedge clk)begin
	ts_ram_v1	<=	ts_ram_valid;
	ts_ram_v2	<=	ts_ram_v1;
	ts_ram_v3	<=	ts_ram_v2;
	ott_ram_clear_r	<=	ott_ram_clear;
end

always@(posedge clk)
begin
if(rst)
	ott_dvb_en	<=0;
else
	ott_dvb_en	<=dout[11];
end

always@(posedge clk)
begin
if(rst)
begin
	data_wr	<=0;
	data_din	<=0;
end
else if(cstate==WR_DATA)
begin
	data_wr	<=1;
	if(ott_dvb_en)
	data_din	<={dvb_doutb[31:0],dvb_doutb[63:32],dvb_doutb[95:64],dvb_doutb[127:96],
	dvb_doutb[159:128],dvb_doutb[191:160],dvb_doutb[223:192],dvb_doutb[255:224],
	dvb_doutb[287:256],dvb_doutb[319:288],dvb_doutb[351:320],dvb_doutb[383:352],
	dvb_doutb[415:384],dvb_doutb[447:416],dvb_doutb[479:448],dvb_doutb[511:480]};
	else
	data_din	<={ott_doutb[31:0],ott_doutb[63:32],ott_doutb[95:64],ott_doutb[127:96],
	ott_doutb[159:128],ott_doutb[191:160],ott_doutb[223:192],ott_doutb[255:224],
	ott_doutb[287:256],ott_doutb[319:288],ott_doutb[351:320],ott_doutb[383:352],
	ott_doutb[415:384],ott_doutb[447:416],ott_doutb[479:448],ott_doutb[511:480]};
end
else
begin
	data_wr	<=0;
	data_din	<=0;
end
end




always@(posedge clk)
begin
if(rst)
	rd_cstate	<=RD_IDLE;
else
	rd_cstate	<=rd_nstate;
end


always@(rd_cstate or prog_empty or data_empty)
begin
case(rd_cstate)
RD_IDLE:
	if(!prog_empty)
	rd_nstate		=	SEND_DATA;
	else
	rd_nstate		=	RD_IDLE;
SEND_DATA:
	if(data_empty)
	rd_nstate		=	RD_IDLE;
	else
	rd_nstate		=	SEND_DATA;
default:
	rd_nstate		=	RD_IDLE;
endcase
end


assign dma_rdata_rdy	=rd_nstate==SEND_DATA?1'b1:1'b0;

fifo_addr		addr_buffer
 (
    .clk( clk),
    .rst( rst),
    .din( dma_raddr[17:6]),
    .wr_en( dma_raddr_en),
    .rd_en( rd_en),
    .dout( dout),
    .full( ),
    .empty( empty),
    .prog_full( prog_full),
    .prog_empty() // output prog_empty
  );

data_fifo  fifo_data (
  .rst(rst), // input rst
  .wr_clk(clk), // input wr_clk
  .rd_clk(clk), // input rd_clk
  .din(data_din), // input [511 : 0] din
  .wr_en(data_wr), // input wr_en
  .rd_en(dma_rdata_rdy), // input rd_en
  .dout(fifo_dout), // output [63 : 0] dout
  .full(), // output full
  .empty(data_empty), // output empty
  .prog_empty(prog_empty) // output prog_empty
);



endmodule
