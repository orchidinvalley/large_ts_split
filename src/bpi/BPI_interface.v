`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:48:06 09/23/2011 
// Design Name: 
// Module Name:    BPI_interface 
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
module BPI_interface(
	clk,	
	rst,
	
	BPI_din,//编程命令/数据输入
	BPI_dout,//校验数据输出
	read_valid,//输出数据有效
	write_start,//输入数据持续信号
	
	ACTION_EN,
	ADDR,
	
	flash_addr,
	data_in,
	data_out,
	data_en,
	
	flash_rst,
	flash_we,
	flash_oe,
	flash_ce,
	
	
	bpi_idle,
	fpga_rst,
	
	led,
	
	FPGA_EOS
	
	// systerm_power_up

    );
	
	
input	clk;	
input	rst;
	
input	[15:0]BPI_din;//数据输入
output	[15:0]BPI_dout;//数据输出
output	read_valid;
output write_start;

input		[26:0]ADDR;
input		[2:0]ACTION_EN;
	
output	[25:0]	flash_addr;

input 	[15:0]	data_in;
output 	[15:0]	data_out;
output 	 data_en;
	
output	flash_rst;
output	flash_we;
output	flash_oe;
output	flash_ce;


output bpi_idle;
input 	fpga_rst;

output led;
output FPGA_EOS;
// output systerm_power_up;

wire led =&data_in_reg;

// reg systerm_power_up;
reg FPGA_EOS;

reg	[25:0]	flash_addr;

reg  [15:0]data_in_reg;	


reg	flash_we;
reg	flash_oe;
reg	flash_ce;
reg 	fpga_cclk;

reg	[15:0]BPI_dout;//数据输出
reg	read_valid;
reg write_start;
reg write_start_r;

assign	flash_rst=FPGA_EOS;

///////////////end of configuration/////////////////////
	wire			v6_eof;
	reg 			bpi_sck_c;
	
	wire 	[15:0]data_in;
	reg 	[15:0]data;
	reg	[15:0]data_out;
	reg data_en;
	
	reg	[3:0]currentstate;
	reg	[3:0]nextstate;
	
	reg	[30:0]bpi_dly;
	reg	bpi_rdy;
	
	reg 	[5:0]count_bit;
	reg 	count_en;
	reg  bpi_idle;
	reg 	idle_c;
	
	
	reg [15:0]count;
	reg	[25:0]	rd_addr_tmp;
	reg 	[25:0]	wr_addr_tmp;
	reg 	[15:0]	wr_data_tmp;
	reg 	flash_ce_tmp;
	reg	flash_we_tmp;
	reg	flash_oe_tmp;
	reg 	[15:0]data_out_tmp;
	reg	rd_addr_en;
	
	reg	wr_data_en;
	reg	wr_addr_en;

	
	/////////////read/////
	reg [1:0]read_byte_cnt;
	reg [25:0]read_addr;
	////////////write/////
	reg [1:0]write_byte_cnt;
	reg [25:0]write_addr;
	
	

	parameter IDLE=0,
			  READ_DATA_WAIT=1,
			  READ_DATA=2,
			  BLOCK_UNLOCK=3,
			  BLOCK_ERASE=4,					
			  WORD_PROGRAM=5,
			  READ_STATUS_WAIT=6,
			  READ_STATUS=7,
			  READ_RCR	=8,
			  SET_RCR	=9;
					
	parameter BLOCK_BYTE=32;		
	parameter READ_CNT=1024;
	
	reg set_rcr_reg;
	reg set_rcr_reg_r;
	reg set_rcr_reg_start;
	
	
	
	always@(posedge clk)begin
	if(rst)
		data_in_reg<=16'h0;
	else 
		data_in_reg<=data_in;
	end 
	always@(posedge clk)begin
		if(rst)
			bpi_idle<=1'b0;
		else
			bpi_idle<=idle_c;
	end
	
	//////////////////////////////////////系统上电在加载flash代码成功指示
	// always@(posedge clk )begin 
		// if(rst)
			// systerm_power_up<=0;
		// else 
			// systerm_power_up<=v6_eof;
	// end
	
//	always@(posedge clk)
//	begin
//	if(rst)
//		set_rcr_reg		<=0;
//	else if(bpi_dly>30'h1000000)
//		set_rcr_reg		<=1;
//	else 
//		set_rcr_reg	<=set_rcr_reg;
//	end
//	
//	always@(posedge clk)
//	begin
//	set_rcr_reg_r		<=set_rcr_reg &fpga_rst;
//	set_rcr_reg_start	<=set_rcr_reg && !set_rcr_reg_r;
//	end
//	
//	
	always@(posedge clk)begin
		if(rst)
			FPGA_EOS<=0;
		else
			FPGA_EOS<=bpi_rdy& fpga_rst;
	end 
	
	//////////////////////////////////////
	always @(posedge clk)
	begin
		if(rst)
			bpi_dly	<=	0;
		else if(!bpi_dly[30] && v6_eof)
			bpi_dly	<=	bpi_dly + 11'b1;
		else
			bpi_dly	<=	bpi_dly;
	end	
	always @(posedge clk)
	begin
		if(bpi_dly[30])
			bpi_rdy	<=	1'b1;
		else
			bpi_rdy	<=	1'b0;
	end

	always @(posedge clk)
	begin
		if(rst)
			currentstate	<=	IDLE;
		else
			currentstate	<=	nextstate;
	end

	
	always@(posedge clk)begin
		if(rst)
			count_bit<=1;
		else if(count_en)
			count_bit<={count_bit[4:0],count_bit[5]};
		else	
			count_bit<=1;
	end
	
	always@(posedge clk)begin
		if(rst)
			count<=0;
		else if(!count_en)
			count<=0;
		else if(count_bit[5]==1)
			count<=count+16'h1;
	end
	
always@(*)
begin
	count_en=1'b0;		
	if(bpi_rdy)
		case(currentstate)
		IDLE:
		begin
			
			flash_ce_tmp=1'b0;
			flash_we_tmp=1'b0;
			flash_oe_tmp=1'b0;	
			rd_addr_en=1'b0;
			bpi_sck_c=1'b0;
			wr_data_en=1'b0;
			wr_addr_en=1'b0;
			write_start=1'b0;	
			idle_c=1'b1;
			
//			if(set_rcr_reg_start)
//				nextstate=READ_RCR;
//			else	
			if(ACTION_EN==3'b100)
//				nextstate=READ_DATA_WAIT;
				nextstate=READ_RCR;
			else if(ACTION_EN==3'b010)
				nextstate=BLOCK_UNLOCK;
			else if(ACTION_EN==3'b011)
				nextstate=WORD_PROGRAM;
			else
				nextstate=IDLE;
		end
		
		READ_DATA_WAIT:begin
			idle_c=1'b0;
			if(count==10)begin
				nextstate=READ_DATA;
			end
			else begin 
				count_en=1;				
				nextstate=READ_DATA_WAIT;				
				if(count ==1)
				begin 
					wr_addr_tmp=read_addr;				
					wr_data_tmp=16'h00FF;
					wr_addr_en=1'b1;
					wr_data_en=1'b1;
					flash_we_tmp=1'b1;
					flash_ce_tmp=1'b1;					
				end 
				else if(count==2)
				begin
					wr_addr_tmp=read_addr;				
					wr_data_tmp=16'h00FF;
					wr_addr_en=1'b1;
					wr_data_en=1'b1;
					flash_we_tmp=1'b1;
					flash_ce_tmp=1'b1;					
				end	
				else if(count ==3)
				begin				
					wr_addr_tmp=read_addr;				
					wr_data_tmp=16'h00FF;	
					wr_addr_en=1'b1;
					wr_data_en=1'b1;
					flash_we_tmp=1'b0;
					flash_ce_tmp=1'b1;
				end
				else if(count==4)
				begin 
					wr_addr_en=1'b0;
					wr_data_en=1'b0;
					flash_we_tmp=1'b0;
					flash_ce_tmp=1'b0;
				end
				else begin
					wr_addr_en=1'b0;
					wr_data_en=1'b0;
					flash_we_tmp=1'b0;
					flash_ce_tmp=1'b1;
				end							
			end 
		end 
		
		READ_DATA:
		begin
		wr_addr_en=1'b0;
		wr_data_en=1'b0;
		idle_c=1'b0;
		if(count==511)
			nextstate=IDLE;
		else begin
		 bpi_sck_c=1'b1;
		 count_en=1;
		 nextstate=READ_DATA;
		 if(read_byte_cnt==0)begin			 	
				flash_oe_tmp=1'b0;
			if(count_bit[0])begin
				rd_addr_en=1'b0;
				flash_ce_tmp=1'b1;
			end 
			else if(|count_bit[5:1] )
			begin
				rd_addr_en=1'b1;
				flash_ce_tmp=1'b1;
			end
		end		
		else if(read_byte_cnt==1)
			begin
				flash_ce_tmp=1'b1;
				rd_addr_en=1'b1;
				flash_oe_tmp=1'b1;
			end 
			else if(read_byte_cnt==2)begin
				flash_ce_tmp=1'b1;
				rd_addr_en=1'b1;
				flash_oe_tmp=1'b1;
			end
			else begin
				flash_ce_tmp=1'b0;
				rd_addr_en=1'b0;
				flash_oe_tmp=1'b0;
			end
			end 
		end
		
		
		BLOCK_UNLOCK:
		begin	
			idle_c=1'b0;		
			flash_ce_tmp=1'b1;
			flash_oe_tmp=1'b0;				
			if(count==11)begin
				nextstate=BLOCK_ERASE;							
			end 
			else begin 
			count_en=1'b1;				
			nextstate=BLOCK_UNLOCK;			
			if(count==1 ||count==2)begin 			
				wr_addr_tmp=write_addr;
				wr_data_tmp=16'h0060;		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				flash_we_tmp=1'b1;			
			end 
			else  if(count==3 )
		    begin					
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				wr_addr_tmp=write_addr;
				wr_data_tmp=16'h0060;
				flash_we_tmp=1'b0;
			end
			else if(count==6 ||count==7)begin
				wr_addr_tmp=write_addr;
				wr_data_tmp=16'h00D0;		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				flash_we_tmp=1'b1;
			end 
			else if( count ==8)
			begin		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				wr_addr_tmp=write_addr;
				wr_data_tmp=16'h00D0;
				flash_we_tmp=1'b0;
			end			
			else
			 begin			
				wr_addr_tmp=26'h0;
				wr_data_tmp=16'h0;		
				wr_addr_en=1'b0;
				wr_data_en=1'b0;
				flash_we_tmp=1'b0;
			end 
		end	
		end
		
		
		
		BLOCK_ERASE:
		begin	
			idle_c=1'b0;		
			flash_ce_tmp=1'b1;
			flash_oe_tmp=1'b0;				
			if(count==11)begin
				nextstate=READ_STATUS_WAIT;							
			end 
			else begin 
			count_en=1'b1;				
			nextstate=BLOCK_ERASE;			
			if(count==1 ||count==2)begin 			
				wr_addr_tmp=write_addr;
				wr_data_tmp=16'h0020;		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				flash_we_tmp=1'b1;			
			end 
			else  if(count==3 )
		    begin					
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				wr_addr_tmp=write_addr;
				wr_data_tmp=16'h0020;
				flash_we_tmp=1'b0;
			end
			else if(count==6 ||count==7)begin
				wr_addr_tmp=write_addr;
				wr_data_tmp=16'h00D0;		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				flash_we_tmp=1'b1;
			end 
			else if( count ==8)
			begin		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				wr_addr_tmp=write_addr;
				wr_data_tmp=16'h00D0;
				flash_we_tmp=1'b0;
			end
			// else if(count==10)begin	
				// wr_addr_tmp=24'h0;
				// wr_data_tmp=16'h0;		
				// wr_addr_en=1'b0;
				// wr_data_en=1'b0;
				// flash_we_tmp=1'b0;
			// end 
			else
			 begin			
				wr_addr_tmp=26'h0;
				wr_data_tmp=16'h0;		
				wr_addr_en=1'b0;
				wr_data_en=1'b0;
				flash_we_tmp=1'b0;
			end 
		end	
		end
		
		WORD_PROGRAM:begin		
		idle_c=1'b0;	
		flash_ce_tmp=1'b1;
		flash_oe_tmp=1'b0;	
		if(count==11)begin
			nextstate=READ_STATUS_WAIT;			
		end
		else begin
			count_en=1;
			nextstate=WORD_PROGRAM;
			
			if((count==5)&&count_bit[3])
				 write_start=1;
				else
				 write_start=0;
				 
			 if(count ==1 ||count==2)
			begin 
				wr_addr_tmp=write_addr;						
				wr_data_tmp=16'h0040;
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				flash_we_tmp=1'b1;			
			end
			else 	 if(count==3)begin
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				wr_addr_tmp=write_addr;
				wr_data_tmp=16'h0040;
				flash_we_tmp=1'b0;		
			end 	
			else	if(count==6||count==7)begin 
				wr_addr_tmp=write_addr;			
				wr_data_tmp=BPI_din;					
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				flash_we_tmp=1'b1;
			end
			else if(count ==8)
			begin
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				wr_addr_tmp=write_addr;
				wr_data_tmp=BPI_din;
				flash_we_tmp=1'b0;				
			end			
			else begin				
				wr_addr_tmp=26'h0;
				wr_data_tmp=16'h0;		
				wr_addr_en=1'b0;
				wr_data_en=1'b0;
				flash_we_tmp=1'b0;
			end 			
			end 			
		end

		READ_STATUS_WAIT:begin
			idle_c=1'b0;
			flash_oe_tmp=1'b0;	
			flash_ce_tmp=1'b1;	
			if(count==5)begin
				nextstate=READ_STATUS;					
			end 
			else begin 
			count_en=1'b1;				
			nextstate=READ_STATUS_WAIT;			
			if(count==1 ||count==2)begin 			
				wr_addr_tmp=write_addr;
				wr_data_tmp=16'h0070;		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				flash_we_tmp=1'b1;	
			end 
			else  if(count==3 )
		    begin		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				wr_addr_tmp=write_addr;
				wr_data_tmp=16'h0070;
				flash_we_tmp=1'b0;
			end
			else begin
				wr_addr_en=1'b0;
				wr_data_en=1'b0;
				wr_addr_tmp=26'h0;
				wr_data_tmp=16'h0;
				flash_we_tmp=1'b0;
			end
		end
		end 
		
		READ_STATUS:
		begin
			idle_c=1'b0;
			count_en=1'b1;	
			bpi_sck_c=1'b1;	
			flash_ce_tmp=1'b1;	
			flash_oe_tmp=1'b1;	
			if(count>0)begin
			 if(data_in[7])			
				nextstate	=IDLE;	
			 else 
				nextstate=READ_STATUS_WAIT;			 
			end
			else 
				nextstate=READ_STATUS;	
		end
		
		READ_RCR:
		begin
			idle_c=1'b0;
			flash_oe_tmp=1'b0;	
			flash_ce_tmp=1'b1;	
			if(count==11)begin
				nextstate=SET_RCR;					
			end 
			else begin 
			count_en=1'b1;				
			nextstate=READ_RCR;			
			if(count==1 ||count==2)begin 			
				wr_addr_tmp=26'H0;
				wr_data_tmp=16'h0090;		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				flash_we_tmp=1'b1;	
			end 
			else  if(count==3 )
		    begin		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				wr_addr_tmp=26'H0;
				wr_data_tmp=16'h0090;
				flash_we_tmp=1'b0;
			end
				else	if(count==6||count==7)begin 
				wr_addr_tmp=26'h05;			
				wr_data_tmp=26'h0;					
				wr_addr_en=1'b1;
				wr_data_en=1'b0;
				flash_we_tmp=1'b0;
				flash_oe_tmp=1'b1;
			end
			else if(count ==8)
			begin
				wr_addr_en=1'b1;
				wr_data_en=1'b0;
				wr_addr_tmp=26'h05;
				wr_data_tmp=BPI_din;
				flash_we_tmp=1'b0;
				flash_oe_tmp=1'b1;				
			end	
			else begin
				wr_addr_en=1'b0;
				wr_data_en=1'b0;
				wr_addr_tmp=26'h0;
				wr_data_tmp=16'h0;
				flash_we_tmp=1'b0;
				flash_oe_tmp=1'b0;
			end
		end
		
		
		end
		
		SET_RCR:
		begin
		 idle_c=1'b0;		
			flash_ce_tmp=1'b1;
			flash_oe_tmp=1'b0;				
			if(count==11)begin
//				nextstate=IDLE;	
				nextstate=READ_DATA_WAIT;						
			end 
			else begin 
			count_en=1'b1;				
			nextstate=SET_RCR;			
			if(count==1 ||count==2)begin 			
				wr_addr_tmp={10'H0,16'Hf94F};
				wr_data_tmp=16'h0060;		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				flash_we_tmp=1'b1;			
			end 
			else  if(count==3 )
		    begin					
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				wr_addr_tmp={10'H0,16'Hf94F};
				wr_data_tmp=16'h0060;
				flash_we_tmp=1'b0;
			end
			else if(count==6 ||count==7)begin
				wr_addr_tmp={10'H0,16'Hf94F};
				wr_data_tmp=16'h0003;		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				flash_we_tmp=1'b1;
			end 
			else if( count ==8)
			begin		
				wr_addr_en=1'b1;
				wr_data_en=1'b1;
				wr_addr_tmp={10'H0,16'Hf94F};
				wr_data_tmp=16'h0003;
				flash_we_tmp=1'b0;
			end			
			else
			 begin			
				wr_addr_tmp=26'h0;
				wr_data_tmp=16'h0;		
				wr_addr_en=1'b0;
				wr_data_en=1'b0;
				flash_we_tmp=1'b0;
			end 
		end		
	 	
		
		end
		
		default:
		 begin
			 count_en=1'b0;	
			 flash_ce_tmp=1'b0;	
			 flash_we_tmp=1'b0;
			 flash_oe_tmp=1'b0;	
			 rd_addr_en=1'b0;
			 idle_c=1'b1;
			 wr_data_en=1'b0;
			 wr_addr_en=1'b0;
			 write_start=1'b0;
			 nextstate= IDLE;			 
		
		 end
		endcase		
	end
/////////////////////////////////

always@(posedge clk )begin
	if(rst)
		fpga_cclk<=1'b0;
	else if(bpi_sck_c &&(count_bit[0]||count_bit[3]))
		fpga_cclk<=!fpga_cclk;
	else 
		fpga_cclk<=fpga_cclk;
end 







/////////////////////////////
	always@(posedge clk)begin
		if(rst)begin
			write_addr<=26'h0;
			read_addr<=26'h0;
		end
		else   if(ACTION_EN == 3'b100)
		begin
			read_addr	<=	ADDR;
			write_addr	<=	write_addr;
		end else if((ACTION_EN == 3'b010) || (ACTION_EN == 3'b011))
		begin
			write_addr	<=	ADDR;
			read_addr	<=	read_addr;
		end
		else begin
				write_addr	<=	write_addr;
				read_addr	<=	read_addr;
		end 
	end 
	
	
	
///////////////////////READ DATA	
	always@(posedge clk)begin
		if(rst)
			read_byte_cnt<=0;
		else if(currentstate==READ_DATA)begin
			if(count_bit[5])
				read_byte_cnt<=read_byte_cnt+2'b1;
			else 
				read_byte_cnt<=read_byte_cnt;
		end
		else	
			read_byte_cnt<=0;
	end

  
   
   always@(posedge clk )begin 
	if(rst)begin
		BPI_dout<=0;
		read_valid<=0;		
	end 
	else if(currentstate==READ_DATA) begin 
		if((read_byte_cnt==2)&&count_bit[3])begin 
			BPI_dout<=data_in ;
			read_valid<=1;	
		end 
		else begin 
			BPI_dout<=0;
			read_valid<=0;	
		end 
	end
	else begin 
		BPI_dout<=0;
		read_valid<=0;	
	end 		
   end 
   
   
 ////////////////////////////////BLOCK ERASE  
   
   
   
   
   
   
   
   
   
   //////////////////////////BPI interface
   
   always@(posedge clk)begin ////s输出到BPI 
	if(rst)begin
		data_out<=16'h0;
		data_en<=1'b0;
	end
	else if(wr_data_en)
	begin
		data_out<=wr_data_tmp;
		data_en<=1'b1;
	end
	else begin 	
		data_en<=1'b0;
		data_out<=0;
	end
   end 
   
   always@(posedge clk )begin 
		if(rst)
			rd_addr_tmp<=26'h0;
		else if(currentstate==READ_DATA)begin
		if(read_byte_cnt==0)			
			begin
				if(count_bit[0])begin
					if(count ==0)
					rd_addr_tmp<=read_addr;
					else	
					rd_addr_tmp<=rd_addr_tmp+26'b1;
				end
				else 
					rd_addr_tmp<=rd_addr_tmp;
			end	
		else 
				rd_addr_tmp<=rd_addr_tmp;
		end
		else 
			rd_addr_tmp<=26'h0;
  end 
   
   
   
    always@(posedge clk )begin
		if(rst)
			flash_addr<=26'h0;
		else if(rd_addr_en)
			flash_addr<=rd_addr_tmp;
		else if(wr_addr_en)
			flash_addr<=wr_addr_tmp;
		else 
		//flash_addr<=24'h0;	
		flash_addr<=flash_addr;		
   end
   
   always@(posedge clk )begin 
	if(rst)begin
		flash_ce<=1'b1;
		flash_we<=1'b1;
		flash_oe<=1'b1;
	end 
	else begin 
		flash_ce<= !flash_ce_tmp;
		flash_we<=!flash_we_tmp;
		flash_oe<=!flash_oe_tmp;
	end 	
   end 
   
   

   
   STARTUP_VIRTEX6 #(
      .PROG_USR("FALSE")  // Activate program event security feature
   )
   STARTUP_VIRTEX6_inst (
      .CFGCLK(),       // 1-bit Configuration main clock output
      .CFGMCLK(),     // 1-bit Configuration internal oscillator clock output
      .DINSPI(),       // 1-bit DIN SPI PROM access output
      .EOS(v6_eof),             // 1-bit Active high output signal indicating the End Of Configuration.
      .PREQ(),           // 1-bit PROGRAM request to fabric output
      .TCKSPI(),       // 1-bit TCK configuration pin access output
      .CLK(),             // 1-bit User start-up clock input
      .GSR(1'b0),             // 1-bit Global Set/Reset input (GSR cannot be used for the port name)
      .GTS(1'b0),             // 1-bit Global 3-state input (GTS cannot be used for the port name)
      .KEYCLEARB(), // 1-bit Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
      .PACK(),           // 1-bit PROGRAM acknowledge input
      .USRCCLKO(fpga_cclk),   // 1-bit User CCLK input
      .USRCCLKTS(), // 1-bit User CCLK 3-state enable input
      .USRDONEO(),   // 1-bit User DONE pin output control
      .USRDONETS()  // 1-bit User DONE 3-state enable output
   );
   
   
   
//   STARTUPE2 #(
//      .PROG_USR("FALSE"),  // Activate program event security feature. Requires encrypted bitstreams.
//      .SIM_CCLK_FREQ(0.0)  // Set the Configuration Clock Frequency(ns) for simulation.
//   )
//   STARTUPE2_inst (
//      .CFGCLK(),       // 1-bit output: Configuration main clock output
//      .CFGMCLK(),     // 1-bit output: Configuration internal oscillator clock output
//      .EOS(v6_eof),             // 1-bit output: Active high output signal indicating the End Of Startup.
//      .PREQ(),           // 1-bit output: PROGRAM request to fabric output
//      .CLK(),             // 1-bit input: User start-up clock input
//      .GSR(1'b0),             // 1-bit input: Global Set/Reset input (GSR cannot be used for the port name)
//      .GTS(1'b0),             // 1-bit input: Global 3-state input (GTS cannot be used for the port name)
//      .KEYCLEARB(), // 1-bit input: Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
//      .PACK(),           // 1-bit input: PROGRAM acknowledge input
//      .USRCCLKO(fpga_cclk),   // 1-bit input: User CCLK input
//      .USRCCLKTS(1'b0), // 1-bit input: User CCLK 3-state enable input
//      .USRDONEO(),   // 1-bit input: User DONE pin output control
//      .USRDONETS()  // 1-bit input: User DONE 3-state enable output
//   );
//
//   
endmodule
