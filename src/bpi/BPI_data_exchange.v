`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:48:06 09/23/2011 
// Design Name: 
// Module Name:    BPI_data_exchange 
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
module BPI_data_exchange(
	clk,
	rst,
	
	///////////////////
	config_reset,
	update_flag,//升级数据标志
	reconfig_flag,//重配置数据标志
	reconfig_read_start,//上电读取配置数据启动标志
	reconfig_read_continue,
	reconfig_read_end,//读取配置结束标志
	pack_cnt,
	pack_num,
	icap_start_r,//FPGA重配置
	
	
	////BPI_interface///////////////
	ACTION_EN,
	ADDR,
	
	BPI_data_out,
	BPI_data_in,
	read_valid,
	write_start,
	
	bpi_idle,
	
	///////////// 和缓存RAM的交互信号    ////////////////
	wr_ram_end,
	wr_ram_ack_o,

////////////////// RAM 的读使能，读地址及读出数据               //////////
	wr_ram_en,
	wr_ram_rdata,
	wr_ram_raddr,
	///////////////////////////网管命令回复
	con_dout,
	con_dout_en,
	reconfig_data,
	reconfig_data_en

);


input	clk;
input	rst;
	
	///
input 			config_reset;
input update_flag;//升级命令标志
input reconfig_flag;//重配置命令标志
input reconfig_read_start;//上电读取配置数据启动标志
input reconfig_read_continue;
input	reconfig_read_end;
	
input			[15:0]pack_cnt; 
input			 [15:0]pack_num;
output			icap_start_r;

	
	////BPI_interface///////////////
output	[2:0]ACTION_EN;
output	[25:0]ADDR;
	
output 	[15:0]BPI_data_out;
input	[15:0]BPI_data_in;
input	read_valid;
input write_start;
	
input	bpi_idle;

///////////// 和缓存RAM的交互信号    ////////////////
input	wr_ram_end;
output	wr_ram_ack_o;

////////////////// RAM 的读使能，读地址及读出数据               //////////
output	wr_ram_en;
input	[15:0]wr_ram_rdata;
output 	[6:0]wr_ram_raddr;
////////////////////////////////////网管命令回复
output	[7:0]con_dout;
output	con_dout_en;

output 		[15:0]reconfig_data;
output		reconfig_data_en;
	

reg write_start_r;

reg	[7:0]con_dout;
reg	con_dout_en;
reg 	[15:0]reconfig_data;
reg		reconfig_data_en;

reg  icap_start_r,icap_start_rr;




parameter  BLOCK_WORD=129;
parameter	 BLOCK_BYTE=26'h010000;

parameter IDLE=0,
				   WR_WAIT=1,
				   BLOCK_ERASE=2,
				   PROG_WAIT=3,
				   PROG_WORD=4,				
				   READ_VERIFY=5,
				   READ_VERIFY_END=6,
				   ERASE_AFTER_VERIFY=7,
				   ERASE_AFTER_WAIT=8,
				   READ_CONFIG_WAIT=9,
				   READ_CONFIG=10;
reg  [7:0]block_cnt;//128个16位数据，网管下发256个8位数据
reg  erase_flag;
reg  [25:0]erase_addr;

reg wr_ram_end_r;
wire wr_ram=wr_ram_end&&!wr_ram_end_r;

reg	wr_ram_ack;


reg wr_ram_en;
reg wr_rdata_valid;
reg [6:0]wr_ram_raddr;

reg 	[15:0]BPI_data_out;

reg	wr_ram_ack_o;


reg	[2:0]ACTION_EN;
reg	[25:0]ADDR;
	
reg  [25:0]addr_tmp;
reg  [2:0]action_en_tmp;
reg  [25:0]wr_addr_reg;	
reg  [25:0]rd_addr_reg;

reg [25:0]verify_addr_reg;
reg  read_to_verif;
reg wr_ram_verify;

reg  [8:0]page_cnt;//每个BLOCK为128KB,每次编程256B,共512次

/////////////////////////////////////////////////////////////////////////
	reg rd,rd_r;
	reg [4:0]rom_addr;
	wire [7:0]rom_dout;
	reg [3:0]cnt;
	
	reg  [4:0] icap_cnt;
/////////////////////////////////////////////////////////////////////////
			   

reg error_clear;
reg [9:0]error_cnt;

reg [15:0]rd_ram_wdata;
reg [15:0]rd_ram_wdata_reg;

reg  [3:0]currentstate;
reg 	[3:0]nextstate;
				   
always@(posedge clk)begin
	if(rst)
		currentstate<=IDLE;
	else 
		currentstate<=nextstate;
end				   
				   
always@(*)begin
	action_en_tmp	=	3'h0;
	addr_tmp	=	26'h0;
	error_clear		=	1'b0;
//	action_en_tmp	=	3'h0;
//	addr_tmp		=	26'h0;
	read_to_verif	=1'b0;	
	wr_ram_ack		=	1'b0;
	
//	nextstate=IDLE;
	
	case(currentstate)
		IDLE:begin
			if (bpi_idle)
				nextstate=WR_WAIT;
			else	
				nextstate=IDLE;
		end 
		WR_WAIT:
		begin
			if(wr_ram_end_r)
			begin
				wr_ram_ack	=	1'b1;
				 if(erase_flag)
					  nextstate=BLOCK_ERASE;				
				 else	
					 nextstate=PROG_WAIT;					
			end 
			else if(reconfig_read_start)
					nextstate=READ_CONFIG_WAIT;
			else 
				nextstate=WR_WAIT;
		end 
		BLOCK_ERASE:
		begin
			if(!bpi_idle)
				nextstate	= PROG_WAIT;			
			else 
			begin
				action_en_tmp	=3'b010;
				error_clear		=	1'b1;
				addr_tmp	=	erase_addr;
				nextstate	=BLOCK_ERASE;
			end
			end			
			PROG_WAIT:
			begin
				if(bpi_idle)
				begin				
					if(block_cnt==BLOCK_WORD)
					nextstate=READ_VERIFY;
					else 
					nextstate=PROG_WORD;
				end 
				else	
					nextstate=PROG_WAIT;
			end
			PROG_WORD:
			begin
				if(!bpi_idle)
					nextstate=PROG_WAIT;
				else
				begin
					action_en_tmp=3'b011;
					addr_tmp	= wr_addr_reg;
					nextstate	=PROG_WORD;
				end
			end
			READ_VERIFY:begin
				if(!bpi_idle)
					nextstate=READ_VERIFY_END;
				else begin
					action_en_tmp=3'b100;
					addr_tmp	=verify_addr_reg;
					nextstate=READ_VERIFY;
				end 
			end 
			READ_VERIFY_END:begin
				 if(bpi_idle&&(	error_cnt==0))begin
					 nextstate=WR_WAIT;
					 read_to_verif	=	1'b1;
				 end
				 else if(bpi_idle)begin
					 nextstate=ERASE_AFTER_VERIFY;
					 read_to_verif	=	1'b1;
				 end				
				else begin 
					nextstate=READ_VERIFY_END;
					read_to_verif	=	1'b1;
				end 
			end 
			ERASE_AFTER_VERIFY:begin
				if(!bpi_idle)
				nextstate	= ERASE_AFTER_WAIT;
			else 
			begin
				action_en_tmp	=3'b010;
				error_clear		=	1'b1;
				addr_tmp	=	erase_addr;
				nextstate	=ERASE_AFTER_VERIFY;
			end
			end
			ERASE_AFTER_WAIT:begin
				if(bpi_idle)
					nextstate	=	WR_WAIT;
				else
					nextstate	=	ERASE_AFTER_WAIT;
				end 
			READ_CONFIG_WAIT:
			begin
				if(!bpi_idle)
					nextstate	=	READ_CONFIG;
				else
				begin
					action_en_tmp	=	3'b100;//read page0 of the last sector
					addr_tmp		=	rd_addr_reg;					
					nextstate	=	READ_CONFIG_WAIT;
				end
			end
			READ_CONFIG:
			begin
				if(bpi_idle)begin
					if(reconfig_read_end)
						nextstate=IDLE;
					else	if(reconfig_read_continue)
						nextstate=READ_CONFIG_WAIT;
					else 
						nextstate=READ_CONFIG;
				end
				else 
					nextstate=READ_CONFIG;
			end 	
				
				
			default:begin
				nextstate=IDLE;
				action_en_tmp	=	3'h0;
				addr_tmp	=	26'h0;
				error_clear		=	1'b0;
				action_en_tmp	=	3'h0;
				addr_tmp		=	24'h0;
				read_to_verif	=1'b0;	
				wr_ram_ack		=	1'b0;	
			end
			endcase
	end				   
	

always@(posedge clk )begin
	wr_ram_end_r<=wr_ram_end;
end 
	
	always@(posedge clk )begin
			if(rst)
				block_cnt<=0;
			else if(wr_ram)
				block_cnt<=8'h1;
			else if((currentstate==PROG_WORD)&&(nextstate==PROG_WAIT))
				block_cnt<=block_cnt+8'h1;
			else
				block_cnt<=block_cnt;
			
	end
				   
		always@(posedge clk)begin
			if(rst)
				wr_addr_reg<=0;
			else if(config_reset & update_flag)
				wr_addr_reg <= 26'h800000;			
			else if(config_reset & reconfig_flag)
				wr_addr_reg<=26'hD00000;	
			else if((currentstate==PROG_WORD)&&(nextstate==PROG_WAIT))
				wr_addr_reg <= wr_addr_reg+26'b1;
			else if((currentstate==READ_VERIFY_END)&&bpi_idle&&(error_cnt!=0))///验证128个16位数据，出错时地址回退128KB
				wr_addr_reg<=erase_addr;
			else 
				wr_addr_reg<=wr_addr_reg;
		end		
		
		always@(posedge clk)begin 
			if(rst)
				verify_addr_reg<=26'h0;			
			else if(wr_ram)
				verify_addr_reg<=wr_addr_reg;
			else if((currentstate==READ_VERIFY_END)&&bpi_idle&&(error_cnt!=0))//验证数据出错
				verify_addr_reg<=erase_addr;
			else 
				verify_addr_reg<=verify_addr_reg;
		end 
		
		always@(posedge clk)begin
		if(rst)
			rd_addr_reg<=0;
		else  if(reconfig_read_start)
			rd_addr_reg<=26'hD00000;
		else if(currentstate==READ_CONFIG &&nextstate==READ_CONFIG_WAIT)
			rd_addr_reg	<=	rd_addr_reg+26'h80;
		else 
			rd_addr_reg  <=rd_addr_reg;
	end 

		
		always@(posedge clk )begin
			if(rst)
				page_cnt<=0;
			else if(config_reset)
				page_cnt<=0;
			else if(wr_ram)
				page_cnt<=page_cnt+9'h1;
			else	if((currentstate==READ_VERIFY_END)&&bpi_idle&&(error_cnt!=0))//验证数据出错
				page_cnt<=0;
			else	
				page_cnt <=page_cnt;
		end 
		
		
		always@(posedge clk )begin 
			if(rst)begin 
				erase_addr<=26'h0;
				erase_flag<=1'b0;
			end 		
			else if(config_reset& update_flag)begin
				erase_addr<=26'h800000;
				erase_flag<=1'b1;
			end		 	
			else if(config_reset & reconfig_flag)begin
				erase_addr<=26'hD00000;
				erase_flag<=1'b1;
			end 
			else if(page_cnt==511&&wr_ram)begin 
				erase_addr<=erase_addr+BLOCK_BYTE;
				erase_flag<=1'b1;
			end 
			else begin 
				erase_addr<=erase_addr;
				erase_flag<=1'b0;
			end
		end 

	/////////////////////////////////////////编程成功与否网管回复
	
	always@(posedge clk)begin
	if(rst)begin
		icap_start_rr<=0;
		con_dout<=0;
		con_dout_en<=0;
	end
	else if((currentstate==READ_VERIFY_END)&&(nextstate==WR_WAIT))begin
		icap_start_rr<=1;		
		con_dout<=0;
		con_dout_en<=1;
	end
	else if((currentstate==READ_VERIFY_END)&&(nextstate==ERASE_AFTER_VERIFY))begin
		con_dout<=8'hFF;
		con_dout_en<=1;
		icap_start_rr<=0;
	end 
	else begin
		con_dout<=0;
		con_dout_en<=0;
		icap_start_rr<=0;
	end
	
end		
	
		
/////////////iprog after upgrade succeed/////////////////
	
	
	always@(posedge clk)begin
		if(rst)
			icap_start_r<=0;
		else if(pack_cnt==pack_num)begin
			if(icap_start_rr)
				if(wr_addr_reg<26'hD00000)
				icap_start_r<=1;
				else 
				icap_start_r<=0;
			else 
				icap_start_r<=0;
		end
		else 
			icap_start_r<=0;
	end 


	

///////////////write acknowledge output////////////////////////////
	always @(posedge clk)
	begin
	    if(rst)
	    begin
	        wr_ram_ack_o    <=  0;
	    end else
	    begin
	        wr_ram_ack_o    <=  wr_ram_ack;
	  
		end
	end
	
	always@(posedge clk)begin 
		if(rst)
			wr_ram_en<=1'b0;
		else if(write_start || read_valid)
			wr_ram_en<=1'b1;
		else 
			wr_ram_en<=1'b0;
	end 
		
	always@(posedge clk )begin 
	if(rst)begin
		wr_rdata_valid<=0;
		write_start_r<=1'b0;
	end 
	else begin 
		write_start_r<=write_start;
		wr_rdata_valid<=write_start_r;
	end 
	end 	
		
	always@(posedge clk)begin
		if(rst)
			wr_ram_raddr<=7'h0;
		else if(wr_ram_raddr==7'h7f && wr_ram_en)
			wr_ram_raddr<=7'h0;
//		else if(currentstate==READ_VERIFY)	
//			wr_ram_raddr<=7'h0;
		else if(wr_ram_ack_o)
			wr_ram_raddr<=7'h0;
		else if(wr_ram_en)
			wr_ram_raddr<=wr_ram_raddr+7'h1;
		else
			wr_ram_raddr<=wr_ram_raddr;
	end	
		
		
		always@(posedge clk)begin
			if(rst)
				BPI_data_out<=16'h0;
			else if(wr_rdata_valid)
				BPI_data_out<=wr_ram_rdata;
			else
				BPI_data_out<=BPI_data_out;
		end
		
		//////////////bpi instruction&address&count/////////////////////////////
	
	always @(posedge clk)
	begin
		if(rst)
		begin
			ACTION_EN	<=	3'b0;
			ADDR		<=	24'b0;		
		end else
		begin
			ACTION_EN	<=	action_en_tmp;
			ADDR		<=	addr_tmp;
		end
	end
		
	/////////////数据验证
	always@(posedge  clk)begin
		if(rst)		
			wr_ram_verify<=0;
		else if(read_to_verif)
			wr_ram_verify<=wr_ram_en;
	end 
	
	always@(posedge clk)begin 
		if(rst)
			rd_ram_wdata_reg<=16'h0;
		else if(read_valid)
			rd_ram_wdata_reg<=BPI_data_in;
	end 
	
	always@(posedge clk )
		rd_ram_wdata<=rd_ram_wdata_reg;
	
	always @(posedge clk)
	begin
		if(rst)
			error_cnt	<=	0;
		else if(error_clear)
			error_cnt	<=	0;
		else if(wr_ram_verify && (rd_ram_wdata != wr_ram_rdata))
			error_cnt	<=	error_cnt + 10'h1;
	end	
	
	always@(posedge clk)begin 
		if(rst)begin
			reconfig_data<=0;
			reconfig_data_en<=0;
		end
		else if(currentstate==READ_CONFIG)begin
			if(read_valid)begin 
				reconfig_data<=BPI_data_in;
				reconfig_data_en<=1;
			end 
			else begin 
				reconfig_data<=0;
			reconfig_data_en<=0;
			end
		end 
		else begin
			reconfig_data<=0;
			reconfig_data_en<=0;
		end
	end 
	
	
	
	
	

	
	
		
		// always@(posedge clk)begin
		// rd_r<=rd;
		// con_dout_en<=rd_r;
		// con_dout<=rom_dout;
	// end
	
	// always@(posedge clk)begin
		// if(rst)begin
			// rd<=0;
			// rom_addr<=5'h0;
			// cnt<=4'hf;
		// end
		// else  if((currentstate==READ_VERIFY_END)&&(nextstate==WR_WAIT))
		// begin
			// rd<=1;
				// rom_addr<=0;
				// cnt<=0;
		// end 
		// else if((currentstate==READ_VERIFY_END)&&(nextstate==ERASE_AFTER_VERIFY))
		// begin
			// rd<=1;
				// rom_addr<=5'b10000;
				// cnt<=0;
		// end
		// if((currentstate==READ_VERIFY_END)&&bpi_idle)begin
			// if(error_cnt==0)begin
				// rd<=1;
				// rom_addr<=0;
				// cnt<=0;
			// end
			// else begin
				// rd<=1;
				// rom_addr<=5'b10000;
				// cnt<=0;
			// end
		// end
		// else if(cnt<12)begin
				// rd<=rd;
				// rom_addr<=rom_addr+5'h1;
				// cnt<=cnt+4'h1;
		// end 
		// else begin
				// rd<=0;
				// rom_addr<=5'h0;
				// cnt<=4'hf;
		// end
	// end
	
	
	// net_ack net (
	// .clka(clk),
	// .ena(rd),
	// .addra(rom_addr), // Bus [4 : 0] 
	// .douta(rom_dout)); // Bus [7 : 0] 
	
		
		
		endmodule


