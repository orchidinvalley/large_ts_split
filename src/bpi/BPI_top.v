`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:29:24 09/26/2011 
// Design Name: 
// Module Name:    ngb_BPI_top 
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
module BPI_top(
	clk,
	rst,	
	//////////////////////BPI interface
	BPI_RST,
	BPI_CE,
	BPI_WE,
	BPI_OE,
	
	BPI_ADDR,
	BPI_DATA_in,
	BPI_DATA_out,
	BPI_DATA_en,

	con_din ,
	con_din_en,
	
	con_dout,
	con_dout_en,
	led,
	fpga_rst,
//	icap_start,
//	mcu_tx,
//	mcu_rx,
	
	con_reconfig,
	con_reconfig_en
	
	
	
	
	

);


input	clk;
input	rst;
	

	
	//////////////////////BPI interface
output	BPI_RST;
output	BPI_CE;
output	BPI_WE;
output	BPI_OE;
	
output	[25:0]BPI_ADDR;
input	[15:0]BPI_DATA_in;
output [15:0]BPI_DATA_out;
output	BPI_DATA_en;

	
input		[7:0]con_din;
input	con_din_en;

output	[7:0]con_dout;
output 	con_dout_en;	

output led;
input fpga_rst;
//output icap_start;
//output mcu_tx;
//input mcu_rx;

output [7:0]con_reconfig;
output  con_reconfig_en;


reg [7:0]con_reconfig;
reg  con_reconfig_en;


wire [7:0]con_reconfig_tmp;
wire  con_reconfig_tmp_en;
	///////////////////////RAM interface
wire led0;	



reg [15:0] bpi_data_io;
wire flash_we_r;


wire	wr_ram_en;
wire	[15:0]wr_ram_rdata;
wire	[6:0]wr_ram_raddr;

wire  wr_ram_end;
	
wire	wr_ram_ack_o	;

	
	
wire [15:0]BPI_din;
wire [15:0]BPI_dout;	
wire  write_start;
wire read_valid;	

wire bpi_idle;

wire [2:0]ACTION_EN;
wire [23:0]ADDR;


wire  [7:0]con_cfg_din;
wire con_cfg_din_en;


    wire 		config_reset;
    wire  	icap_start_r;	
	wire  [15:0]pack_cnt; 
    wire [15:0]pack_num;

reg	[7:0]con_dout;
reg 	con_dout_en;	

wire [7:0]reconfig_version;
wire  [7:0]reconfig_status;

wire	[7:0]reconfig_info;
wire 	reconfig_info_en;	

wire	[7:0]net_cmd;
wire 	net_cmd_en;	


wire	[7:0]con_bpi;
wire 	con_bpi_en;	



wire 	[15:0]reconfig_data;
wire 	reconfig_data_en;

cmd_pretreat cmd_pre (
    .clk(clk), 
    .rst(rst), 
    .con_din(con_din), 
    .con_din_en(con_din_en), 
    .con_bpi_en(con_bpi_en), 
    .update_flag(update_flag), 
    .reconfig_flag(reconfig_flag), 
    .con_dout(con_cfg_din), 
    .con_dout_en(con_cfg_din_en)
    );


BPI_interface bpi_interface (
    .clk(clk), 
    .rst(rst), 
    .BPI_din(BPI_din), 
    .BPI_dout(BPI_dout), 
    .read_valid(read_valid), 
    .write_start(write_start), 
    .ACTION_EN(ACTION_EN), 
    .ADDR(ADDR), 
    .flash_addr(BPI_ADDR), 
    .data_in(BPI_DATA_in), 
    .data_out(BPI_DATA_out), 
    .data_en(BPI_DATA_en), 
    .flash_rst(BPI_RST), 
    .flash_we(BPI_WE), 
    .flash_oe(BPI_OE), 
    .flash_ce(BPI_CE),
    .bpi_idle(bpi_idle),
    .fpga_rst(fpga_rst),
	.led (led),	
	.FPGA_EOS(FPGA_EOS)
    );
	
	
	BPI_data_exchange data_exchange (
    .clk(clk), 
    .rst(rst), 
    .ACTION_EN(ACTION_EN), 
    .ADDR(ADDR), 
    .BPI_data_out(BPI_din), 
    .BPI_data_in(BPI_dout), 
    .read_valid(read_valid), 
    .write_start(write_start), 
    .bpi_idle(bpi_idle), 
	.config_reset(config_reset), 
	.update_flag(update_flag), 
    .reconfig_flag(reconfig_flag), 
    .reconfig_read_start(reconfig_read_start), 
    .reconfig_read_continue(reconfig_read_continue), 
    .reconfig_read_end(reconfig_read_end), 
    .pack_cnt(pack_cnt), 
    .pack_num(pack_num), 
    .icap_start_r(icap_start_r), 	
	
    .wr_ram_end(wr_ram_end), 
    .wr_ram_ack_o(wr_ram_ack_o), 
    .wr_ram_en(wr_ram_en), 
    .wr_ram_rdata(wr_ram_rdata), 
    .wr_ram_raddr(wr_ram_raddr),
	.con_dout(con_bpi),
	.con_dout_en(con_bpi_en),
	.reconfig_data(reconfig_data), 
    .reconfig_data_en(reconfig_data_en)
    );


flash_cfg_ram_wr config_ram (
    .clk_166m(clk), 
    .reset(rst), 
    .con_din(con_cfg_din), 
    .con_din_valid(con_cfg_din_en), 
    .clkb(clk), 
    .addrb(wr_ram_raddr), 
    .enb(wr_ram_en), 
    .doutb(wr_ram_rdata), 
    .config_reset(config_reset), 
    .wr_flash_flag(wr_ram_end), 
    .flag_clr(wr_ram_ack_o), 
    .pack_cnt(pack_cnt), 
    .pack_num(pack_num)
    );



  
    
    
    net_cmd_treat net_cmd_tre (
    .clk(clk), 
    .rst(rst), 
    .con_din_en(con_din_en), 
    .con_din(con_din), 
    .update_flag(update_flag), 
    .reconfig_flag(reconfig_flag),
    .con_dout_en_bpi(con_bpi_en), 
    .con_dout_bpi(con_bpi), 
    .con_dout(net_cmd), 
    .con_dout_en(net_cmd_en)
    );
    
    
    reconfig_flag reconfig_flag_gen (
    .clk(clk), 
    .rst(rst), 
    .con_din(con_din), 
    .con_din_en(con_din_en), 
    .reconfig_status(reconfig_status), 
    .reconfig_version(reconfig_version),
//    .mcu_rx(mcu_rx), 
//    .config_valid(config_valid),
//    .reconfig_flag_set(reconfig_flag_set), 
//    .reconfig_flag_clr(reconfig_flag_clr),
    .con_dout(reconfig_info), 
    .con_dout_en(reconfig_info_en)
    );
    
     reconfig_powerup reconfig (
     .clk(clk), 
     .rst(rst), 
     .reconfig_data(reconfig_data), 
     .reconfig_data_en(reconfig_data_en),  
     .config_valid(FPGA_EOS),
     .bpi_idle(bpi_idle),
     .reconfig_status(reconfig_status), 
     .reconfig_version(reconfig_version),
     .reconfig_read_start(reconfig_read_start), 
     .reconfig_read_continue(reconfig_read_continue), 
     .reconfig_read_end(reconfig_read_end), 
     .con_dout(con_reconfig_tmp), 
     .con_dout_en(con_reconfig_tmp_en)
     );
    
    
   
   
   always@(posedge clk)begin 
		if(net_cmd_en)begin
			con_dout<=net_cmd;
			con_dout_en<=1;
		end				
		else begin 
			con_dout<=reconfig_info;
			con_dout_en<=reconfig_info_en;
		end 	
   end
   
   
   reg [15:0]cnt;
   reg 	send_flag;
   reg [7:0]con_reconfig_tmp_r;
   reg 	con_reconfig_tmp_en_r;
   
   
   always@(posedge clk)
   begin
   con_reconfig_tmp_r	<=con_reconfig_tmp;
   con_reconfig_tmp_en_r	<=con_reconfig_tmp_en;
   end
   
   
   always@(posedge clk)
   begin
   	  	if(con_reconfig_tmp_en)
  		cnt<=cnt+1;
  	else
  		cnt<=0;
   end
   
   always@(posedge clk)
   begin
   if(rst)
   	send_flag	<=0;
   else if(cnt==0 &&  con_reconfig_tmp_en)
   begin
   if((con_reconfig_tmp==8'h04 ||con_reconfig_tmp==8'h40))
   	send_flag	<=1;
   else 
   	send_flag	<=0;
   end
   else 
   	send_flag	<=send_flag;
   end
   
   
   always@(posedge clk)
   begin
   if(rst)
   begin
   	con_reconfig	<=0;
   	con_reconfig_en<=0;
   end
   else if(send_flag)
   begin
   	con_reconfig	<=con_reconfig_tmp_r;
   	con_reconfig_en<=con_reconfig_tmp_en_r;
  end
  else 
  begin
  	con_reconfig	<=0;
   	con_reconfig_en<=0;
  end
   end
   
endmodule
