`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:27 09/10/2019 
// Design Name: 
// Module Name:    pcie_ts_rd 
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
module pcie_ts_rd(

		clk_ts,
		rst_ts,
		
		ts_ram_wr,
		ts_ram_wdata,




		clk_pcie,
		rst_pcie,


		
		dma_write_start,			//pcie ->server  
		dma_write_end,
		dma_raddr_en,					//: in std_logic;
		dma_raddr,						// : in std_logic_vector(31 downto 0);
		dma_rdata_rdy,				// : out std_logic;
		dma_rdata_busy, 				//: out std_logic;
		dma_rdata		,				// : out std_logic_vector(63 downto 0);
//		
//		ott_ram_clear,
//		
////		dvb_raddr,
////		dvb_doutb,
//
//		
		test_flag,
		ram_full_1,
		ram_full_2

    );
    
    
   	input		clk_ts;
		input 	rst_ts;
		
		input 	ts_ram_wr;
		input		[511:0]ts_ram_wdata;
    
    
   input		clk_pcie;
   input		rst_pcie;
   
   input 		dma_write_start;
   input 		dma_write_end;
   
   input  	dma_raddr_en;
   input		[31:0]dma_raddr;
   
   
   output 	dma_rdata_rdy;
   output 	[63:0]dma_rdata;
   output		dma_rdata_busy;
   
   output 	ram_full_1;
   output 	ram_full_2;
   
   
//	input							ott_ram_clear;
	
//	output 	[5:0]			dvb_raddr;
//	input 	[511:0]		dvb_doutb;

//	input 	ts_ram_valid;


	output test_flag;
	
	 reg 	dma_rdata_rdy;
   reg 	[63:0]dma_rdata;	
   
   reg 	[13:0]		ott_raddr;
	 reg 	[5:0]			dvb_raddr; 
	 reg	ts_ram_wr_r;  
   
   reg	[2:0]wcstate;
   reg	[2:0]wnstate;
   
   
   
   parameter	WR_IDLE=0,
   						WR_RAM_WAIT1=1,
   						WR_RAM1=2,
   						WR_FULL_1=3,
   						WR_SWITCH=4,
   						WR_RAM_WAIT2=5,
   						WR_RAM2=6,
   						WR_FULL_2=7;
   
   reg	ram1_clear;
   reg	ram1_full;
   reg	ram_wr1;
   reg	[10:0]ram_waddr1;
   reg	[511:0]ram_din1;
   reg	[13:0]ram_raddr1;
   wire	[63:0]ram_dout1;
   	
   reg	ram2_clear;
   reg	ram2_full;
   reg	ram_wr2;
   reg	[10:0]ram_waddr2;
   reg	[511:0]ram_din2;
   reg	[13:0]ram_raddr2;
   wire	[63:0]ram_dout2;
   
   
   reg	[4:0]rcstate;
		reg	[4:0]rnstate;
   
		wire	addr_rd;
		wire	[14:0]addr_dout;
		wire 	empty;
		reg		[14:0]ts_cnt;
		reg		[9:0]cmd_cnt;
		reg		[3:0]interval;
		reg		[14:0]empty_cnt;
		
   
   
		parameter	RD_IDLE=0,
							RD_START_1=1,
							RD_ADDR_1=2,
							RD_TS_EMPTY_1=3,
							SEND_TS_1=4,
							RD_TS_WAIT_1=5,
   						SEND_CMD_1=6,   						
   						SEND_TS_END_1_1=7,
   						SEND_TS_END_1_2=8,
   						SEND_TS_END_1_3=9,
   						RD_SWTICH=10,
   						RD_START_2=11,
							RD_ADDR_2=12,
							RD_TS_EMPTY_2=13,
							SEND_TS_2=14,
							RD_TS_WAIT_2=15,   						
   						SEND_CMD_2=16,   						
   						SEND_TS_END_2_1=17,
   						SEND_TS_END_2_2=18,
   						SEND_TS_END_2_3=19,
   						SEND_EMPTY_START_1=20,
   						SEND_EMPTY_WAIT_1=21,
   						SEND_EMPTY_DATA_1=22,
   						SEND_EMPTY_END_1_1=23,
   						SEND_EMPTY_END_1_2=24,
   						SEND_EMPTY_START_2=25,
   						SEND_EMPTY_WAIT_2=26,
   						SEND_EMPTY_DATA_2=27,
   						SEND_EMPTY_END_2_1=28,
   						SEND_EMPTY_END_2_2=29;
   						
   						
   assign	ram_full_1=	ram1_full;
   assign	ram_full_2=	ram2_full;		
   						
   always@(posedge clk_ts)begin
   	ts_ram_wr_r	<=	ts_ram_wr;	
   end						
   
   always@(posedge clk_ts)begin
   	if(rst_ts)	
   		wcstate	<=	WR_IDLE;
   	else
   		wcstate	<=	wnstate;	
   end
   
   
   always@(*)begin
   	case(wcstate)
   		WR_IDLE:
   			if(!ram1_full)
   				wnstate	=	WR_RAM_WAIT1;
   			else
   				wnstate	=	WR_IDLE;
   		WR_RAM_WAIT1:
   			if(ts_ram_wr&!ts_ram_wr_r)
   				wnstate	=	WR_RAM1;
   			else
   				wnstate	=	WR_RAM_WAIT1;   			
   		WR_RAM1:
   			if(!ts_ram_wr)
   				wnstate	=	WR_FULL_1;
   			else
   				wnstate	=	WR_RAM1;
   		WR_FULL_1:
   				wnstate	=	WR_SWITCH;
   		WR_SWITCH:
   			if(!ram2_full)
   				wnstate	=	WR_RAM_WAIT2;
   			else
   				wnstate	=	WR_SWITCH;
   		WR_RAM_WAIT2:
   			if(ts_ram_wr&!ts_ram_wr_r)
   				wnstate	=	WR_RAM2;
   			else
   				wnstate	=	WR_RAM_WAIT2;   			
   		WR_RAM2:
   			if(!ts_ram_wr)
   				wnstate	=	WR_FULL_2;
   			else
   				wnstate	=	WR_RAM2;
   		WR_FULL_2:
   			wnstate	=	WR_IDLE;
   		default:
   			wnstate	=	WR_IDLE;
   	endcase
   end
   
   
   always@(posedge clk_ts)begin
   	if(rst_ts)
   		ram1_full	<=0;
   	else if(wcstate==WR_FULL_1)
   		ram1_full	<=1;
   	else if(ram1_clear)
   		ram1_full	<=0;
   	else
   		ram1_full	<=ram1_full;
   end
   
   
    always@(posedge clk_ts)begin
   	if(rst_ts)
   		ram2_full	<=0;
   	else if(wcstate==WR_FULL_2)
   		ram2_full	<=1;
   	else if(ram2_clear)
   		ram2_full	<=0;
   	else
   		ram2_full	<=ram2_full;
   end
   
   always@(posedge clk_ts)begin
   	if(rst_ts)begin
   		ram_wr1			<=0;
   		ram_waddr1	<=0;
   		ram_din1		<=0;
   	end
   	else if(wcstate==WR_RAM_WAIT1 && wnstate==WR_RAM1)begin
   		ram_wr1			<=1;
   		ram_waddr1	<=0;
   		ram_din1		<=ts_ram_wdata;	
   	end
   	else if(wcstate==WR_RAM1)begin
   		ram_wr1			<=ts_ram_wr;
   		ram_waddr1	<=ram_waddr1+1;
   		ram_din1		<=ts_ram_wdata;
   	end
   	else begin
   		ram_wr1			<=0;
   		ram_waddr1	<=0;
   		ram_din1		<=0;
   	end
   end
   
   
   always@(posedge clk_ts)begin
   	if(rst_ts)begin
   		ram_wr2			<=0;
   		ram_waddr2	<=0;
   		ram_din2		<=0;
   	end
   	else if(wcstate==WR_RAM_WAIT2 && wnstate==WR_RAM2)begin
   		ram_wr2			<=1;
   		ram_waddr2	<=0;
   		ram_din2		<=ts_ram_wdata;	
   	end
   	else if(wcstate==WR_RAM2)begin
   		ram_wr2			<=ts_ram_wr;
   		ram_waddr2	<=ram_waddr2+1;
   		ram_din2		<=ts_ram_wdata;
   	end
   	else begin
   		ram_wr2			<=0;
   		ram_waddr2	<=0;
   		ram_din2		<=0;
   	end
   end
   
   
   
   
  
   		
   	
   	ts_ram_pcie ts_ram_1 (
		  .clka(clk_ts), // input clka
		  .wea(ram_wr1), // input [0 : 0] wea
		  .addra(ram_waddr1), // input [13 : 0] addra
		  .dina(ram_din1), // input [63 : 0] dina
		  .clkb(clk_pcie), // input clkb
		  .addrb(ram_raddr1), // input [13 : 0] addrb
		  .doutb(ram_dout1) // output [63 : 0] doutb
		);
		
		ts_ram_pcie ts_ram_2 (
		  .clka(clk_ts), // input clka
		  .wea(ram_wr2), // input [0 : 0] wea
		  .addra(ram_waddr2), // input [13 : 0] addra
		  .dina(ram_din2), // input [63 : 0] dina
		  .clkb(clk_pcie), // input clkb
		  .addrb(ram_raddr2), // input [13 : 0] addrb
		  .doutb(ram_dout2) // output [63 : 0] doutb
		);
   		
   		
   		
   						
   						
//   	ts_addr_fifo addr_fifo (
//		  .clk(clk_pcie), // input clk_pcie
//		  .rst(rst_pcie), // input rst_pcie
//		  .din(dma_raddr[17:3]), // input [14 : 0] din
//		  .wr_en(dma_raddr_en), // input wr_en
//		  .rd_en(addr_rd), // input rd_en
//		  .dout(addr_dout), // output [31 : 0] dout
//		  .full(), // output full
//		  .empty(empty) // output empty
//		);					
//    
    
		
    
    
    
    always@(posedge clk_pcie)begin
    	if(rst_pcie)
    		rcstate	<=	RD_IDLE;
    	else
    		rcstate	<=	rnstate;
    end	
    
    
    
    always@(*)begin
    	case(rcstate)
    		RD_IDLE:
    			if(dma_write_start)	
    				rnstate	=	RD_START_1;
    			else
    				rnstate	=	RD_IDLE;
    		RD_START_1:
    			if(ram1_full)
    				rnstate	=	RD_ADDR_1;
    			else
    				rnstate	=	SEND_EMPTY_START_1;
    		SEND_EMPTY_START_1:
    			if(dma_raddr_en)
    				rnstate	= SEND_EMPTY_WAIT_1;
    			else
    				rnstate	=	SEND_EMPTY_START_1; 		
    		SEND_EMPTY_WAIT_1:
    			if(interval==11)
    				rnstate	=	SEND_EMPTY_DATA_1;
    			else
    				rnstate	=	SEND_EMPTY_WAIT_1;	
    		SEND_EMPTY_DATA_1:
    			if(empty_cnt==15'd16895)
    				rnstate	=	SEND_EMPTY_END_1_1;
    			else
    				rnstate	=	SEND_EMPTY_DATA_1;
    		SEND_EMPTY_END_1_1:
    			if(dma_write_end)
    				rnstate	=	SEND_EMPTY_END_1_2;
    			else
    				rnstate	=	SEND_EMPTY_END_1_1;
    		SEND_EMPTY_END_1_2:
    			if(dma_write_start)	
    				rnstate	=	RD_START_1;
    			else
    				rnstate	=	 SEND_EMPTY_END_1_2;    		
    		RD_ADDR_1:
    			if(dma_raddr_en)
    				rnstate	= RD_TS_EMPTY_1;
    			else
    				rnstate	=	RD_ADDR_1; 
    		RD_TS_EMPTY_1:
    			if(interval==11)
    				rnstate	=	SEND_TS_1;
    			else
    				rnstate	=	RD_TS_EMPTY_1;
    		SEND_TS_1:
    			if(ts_cnt==15'h3fff)
    				rnstate	=	RD_TS_WAIT_1;
    			else
    				rnstate	=	SEND_TS_1;  
    		RD_TS_WAIT_1:
    			rnstate	=	SEND_CMD_1;
    		SEND_CMD_1:
    			if(cmd_cnt==10'h1ff)
    				rnstate	=	SEND_TS_END_1_1;
    			else
    				rnstate	=	SEND_CMD_1;
    		SEND_TS_END_1_1:    			
						rnstate	=	SEND_TS_END_1_2;
				SEND_TS_END_1_2:
						rnstate	=	SEND_TS_END_1_3;
				SEND_TS_END_1_3:
				if(dma_write_end)
						rnstate	=	RD_SWTICH;
					else
						rnstate	=	SEND_TS_END_1_3;
				RD_SWTICH:
					if(dma_write_start)
						rnstate	=	RD_START_2;
					else
						rnstate	=	RD_SWTICH;			
				RD_START_2:
    			if(ram2_full)
    				rnstate	=	RD_ADDR_2;
    			else
    				rnstate	=	SEND_EMPTY_START_2;
    		SEND_EMPTY_START_2:
    			if(dma_raddr_en)
    				rnstate	= SEND_EMPTY_WAIT_2;
    			else
    				rnstate	=	SEND_EMPTY_START_2; 		
    		SEND_EMPTY_WAIT_2:
    			if(interval==11)
    				rnstate	=	SEND_EMPTY_DATA_2;
    			else
    				rnstate	=	SEND_EMPTY_WAIT_2;	
    		SEND_EMPTY_DATA_2:
    			if(empty_cnt==15'd16895)
    				rnstate	=	SEND_EMPTY_END_2_1;
    			else
    				rnstate	=	SEND_EMPTY_DATA_2;
    		SEND_EMPTY_END_2_1:
    			if(dma_write_end)
    				rnstate	=	SEND_EMPTY_END_2_2;
    			else
    				rnstate	=	SEND_EMPTY_END_2_1;
    		SEND_EMPTY_END_2_2:
    			if(dma_write_start)	
    				rnstate	=	RD_START_2;
    			else
    				rnstate	=	SEND_EMPTY_END_2_2;   		
    		RD_ADDR_2:
    			if(dma_raddr_en)
    				rnstate	= RD_TS_EMPTY_2;
    			else
    				rnstate	=	RD_ADDR_2; 
    		RD_TS_EMPTY_2:
    			if(interval==11)
    				rnstate	=	SEND_TS_2;
    			else
    				rnstate	=	RD_TS_EMPTY_2;		
    		SEND_TS_2:
    			if(ts_cnt==15'h3fff)
    				rnstate	=	RD_TS_WAIT_2;
    			else
    				rnstate	=	SEND_TS_2;
    		RD_TS_WAIT_2:
    			rnstate	=	SEND_CMD_2;
    		SEND_CMD_2:
    			if(cmd_cnt==10'h1ff)
    				rnstate	=	SEND_TS_END_2_1;
    			else
    				rnstate	=	SEND_CMD_2;
    		SEND_TS_END_2_1:    			
						rnstate	=	SEND_TS_END_2_2;
				SEND_TS_END_2_2:
						rnstate	=	SEND_TS_END_2_3;
				SEND_TS_END_2_3:
				if(dma_write_end)
						rnstate	=	RD_IDLE;
					else
						rnstate	=	SEND_TS_END_2_3;
    		default:
    				rnstate	=	RD_IDLE;	
    	endcase
    end
    
    
    
/////先不考虑  CMD 读取的问题 ，只处理 TS流的上传问题。
//		always@(*)begin
//			case(rcstate)
//				RD_IDLE:
//					if(dma_write_start)
//						rnstate	=	RD_START_1;
//					else
//						rnstate	=	RD_IDLE;					
//				RD_START_1:	
//					if(ram1_full)
//						rnstate	=	RD_TS_WAIT_1;
//					else
//						rnstate	=	RD_START_1;
//				RD_TS_WAIT_1:
//					if(!empty)
//						rnstate	=	RD_ADDR_1;
//					else if(dma_write_end)
//						rnstate	=	SEND_TS_END_1_1;
//					else
//						rnstate	=	RD_TS_WAIT_1;
//				RD_ADDR_1:
//					if(addr_dout[14])
//						rnstate	=	SEND_CMD_1;
//					else
//						rnstate	=	SEND_TS_1;
//				SEND_CMD_1:
//					if(ts_cnt==8)
//						rnstate	=	RD_TS_WAIT_1;
//					else
//						rnstate	=	SEND_CMD_1;
//				SEND_TS_1:
//					if(ts_cnt==8)
//						rnstate	=	RD_TS_WAIT_1;
//					else
//						rnstate	=	SEND_TS_1;
//				SEND_TS_END_1_1:
//						rnstate	=	SEND_TS_END_1_2;
//				SEND_TS_END_1_2:
//						rnstate	=	SEND_TS_END_1_3;
//				SEND_TS_END_1_3:
//						rnstate	=	RD_SWTICH;
//				RD_SWTICH:
//					if(dma_write_start)
//						rnstate	=	RD_START_2;
//					else
//						rnstate	=	RD_SWTICH;						
//				RD_START_2:	
//					if(ram2_full)
//						rnstate	=	RD_TS_WAIT_2;
//					else
//						rnstate	=	RD_START_2;
//				RD_TS_WAIT_2:
//					if(!empty)
//						rnstate	=	RD_ADDR_2;
//					else if(dma_write_end)
//						rnstate	=	SEND_TS_END_2_1;
//					else
//						rnstate	=	RD_TS_WAIT_2;
//				RD_ADDR_2:
//					if(addr_dout[14])
//						rnstate	=	SEND_CMD_2;
//					else
//						rnstate	=	SEND_TS_2;
//				SEND_CMD_2:
//					if(ts_cnt==8)
//						rnstate	=	RD_TS_WAIT_2;
//					else
//						rnstate	=	SEND_CMD_2;
//				SEND_TS_2:
//					if(ts_cnt==8)
//						rnstate	=	RD_TS_WAIT_2;
//					else
//						rnstate	=	SEND_TS_2;		
//				SEND_TS_END_2_1:
//						rnstate	=	SEND_TS_END_2_2;
//				SEND_TS_END_2_2:
//						rnstate	=	SEND_TS_END_2_3;
//				SEND_TS_END_2_3:
//						rnstate	=	RD_IDLE;		
//			endcase
//		end
//
//		assign addr_rd	=	(rnstate	== RD_ADDR_1||rnstate==RD_ADDR_2)?1'b1:1'b0;
//		
		always@(posedge clk_pcie)begin
			if( rcstate==SEND_TS_1||rcstate==SEND_TS_2)
				ts_cnt	<=	ts_cnt+1;
			else
				ts_cnt	<=0;
		end
		
		always@(posedge clk_pcie)begin
			if(rcstate	==	SEND_CMD_1 || rcstate==SEND_CMD_2)
				cmd_cnt	<=	cmd_cnt+1;
			else
				cmd_cnt	<=0;
		end
		
		always@(posedge clk_pcie)begin
			if(rcstate	==	RD_TS_EMPTY_2 ||rcstate	==	RD_TS_EMPTY_1||rcstate==SEND_EMPTY_WAIT_1 ||rcstate==SEND_EMPTY_WAIT_2)
				interval	<=	interval+1;
			else
				interval	<=	0;
		end
		
		always@(posedge clk_pcie)begin
			if(rcstate	==	SEND_EMPTY_DATA_1 || rcstate==	SEND_EMPTY_DATA_2)
				empty_cnt	<=	empty_cnt+1;
			else
				empty_cnt	<=0;
		end
		
		always@(posedge clk_pcie)begin
			if(rst_pcie)
				ram_raddr1	<=0;
			else if(rcstate==SEND_TS_1)
				ram_raddr1	<=ram_raddr1+1;			
			else
				ram_raddr1	<=ram_raddr1;
		end
		
		always@(posedge clk_pcie)begin
			if(rst_pcie)
				ram_raddr2	<=0;
			else if(rcstate==SEND_TS_2)
				ram_raddr2	<=ram_raddr2+1;			
			else
				ram_raddr2	<=ram_raddr2;
		end
		

		
		always@(posedge clk_pcie)begin
			if(rst_pcie)
				dma_rdata		<=0;
			else if((rcstate==SEND_TS_1 && ts_cnt>0)||rcstate==RD_TS_WAIT_1)
				dma_rdata		<=	{ram_dout1[7:0],ram_dout1[15:8],ram_dout1[23:16],ram_dout1[31:24],
				ram_dout1[39:32],ram_dout1[47:40],ram_dout1[55:48],ram_dout1[63:56]
				};
			else if((rcstate==SEND_TS_2 && ts_cnt>0)||rcstate==RD_TS_WAIT_2)
				dma_rdata		<=	{ram_dout2[7:0],ram_dout2[15:8],ram_dout2[23:16],ram_dout2[31:24],
				ram_dout2[39:32],ram_dout2[47:40],ram_dout2[55:48],ram_dout2[63:56]};
			else 
				dma_rdata	<=0;
		end
		
		always@(posedge clk_pcie)begin
			if((rcstate	==	SEND_CMD_1||rcstate==SEND_CMD_2) ||((rcstate	==	SEND_TS_1||rcstate==SEND_TS_2))||(rcstate==SEND_EMPTY_DATA_1)||(rcstate==SEND_EMPTY_DATA_2))
				dma_rdata_rdy	<=1;
			else
				dma_rdata_rdy	<=0;
		end
//		
//		
		always@(posedge clk_pcie)begin
			if(rst_pcie)
				ram1_clear	<=	0;
			else if(rcstate==SEND_TS_END_1_2||rcstate==SEND_TS_END_1_1)
				ram1_clear	<=	1;
			else
				ram1_clear	<=	0;		
		end
		
		always@(posedge clk_pcie)begin
			if(rst_pcie)
				ram2_clear	<=	0;
			else if(rcstate==SEND_TS_END_2_2||rcstate==SEND_TS_END_2_1)
				ram2_clear	<=	1;
			else
				ram2_clear	<=	0;		
		end
		
		
		reg	[3:0]tsmf_cc;
	reg	[3:0]tsmf_cnt;
	wire test_flag;
	wire test_interval;



	always@(posedge clk_pcie)begin
		if(rst_pcie)
			tsmf_cnt	<=0;
		else if(dma_rdata_rdy && ts_cnt==3 && dma_rdata[55:32]==24'hfe1f47)
			tsmf_cnt	<=dma_rdata[59:56];
		else
			tsmf_cnt		<=tsmf_cnt;
	end

	always@(posedge clk_pcie)begin
		if(rst_pcie)
			tsmf_cc	<=0;
		else if(dma_rdata_rdy && ts_cnt==3 && dma_rdata[55:32]==24'hfe1f47)
			tsmf_cc	<=dma_rdata[59:56]-tsmf_cnt;
		else
			tsmf_cc	<=	tsmf_cc;
	end


	assign			test_flag	=(tsmf_cc==1?1'b0:1'b1)||test_interval;


	reg	[32:0]read_cnt;	
	reg	[32:0]read_interval;
	reg	[32:0]read_cnt_max;	
	reg	[32:0]read_interval_max;
	
	
	reg	[1:0]	time_cstate;
	reg	[1:0]	time_nstate;
	
	parameter	T_IDLE=0,
						T_READ=1,
						T_INTERVAL=2;
	
	
	always@(posedge clk_pcie)begin
		if(rst_pcie)
			time_cstate	<=	T_IDLE;
		else
			time_cstate	<=	time_nstate;
	end


	always@(*)begin
		case(time_cstate)
				T_IDLE:
					if(dma_write_start)
						time_nstate	=	T_READ;
					else
						time_nstate	=	T_IDLE;
				T_READ:
					if(dma_write_end)
						time_nstate	=	T_INTERVAL;
					else
						time_nstate	=	T_READ;	
				T_INTERVAL:
					if(dma_write_start)	
						time_nstate	=	T_READ;
					else
						time_nstate	=	T_INTERVAL;
				default:
					time_nstate	=	T_IDLE;
		endcase
	end

	always@(posedge clk_pcie)begin
		if(time_cstate==	T_READ)
			read_cnt	<=	read_cnt+1;
		else
			read_cnt	<=0;
	end

	always@(posedge clk_pcie)begin
		if(time_cstate==	T_INTERVAL)
			read_interval	<=	read_interval+1;
		else
			read_interval	<=0;
	end
	
	always@(posedge clk_pcie)begin
		if(rst_pcie)
			read_cnt_max	<=0;
		else if(dma_write_end)begin
			if(read_cnt>read_cnt_max)
				read_cnt_max	<=	read_cnt;
			else
				read_cnt_max	<=	read_cnt_max;
		end
		else
			read_cnt_max	<=	read_cnt_max;
	end
	
	always@(posedge clk_pcie)begin
		if(rst_pcie)
			read_interval_max	<=0;
		else if(dma_write_start && time_cstate==T_INTERVAL)begin
			if(read_interval>read_interval_max)
				read_interval_max	<=	read_interval;
			else
				read_interval_max	<=	read_interval_max;
		end
		else
			read_interval_max	<=	read_interval_max;
	end
	
	
	
	assign test_interval=read_cnt_max==0 && read_interval_max==0;
endmodule
