`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:17 09/25/2019 
// Design Name: 
// Module Name:    pcie_ts_rd_v2 
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
module pcie_ts_rd_v2(
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

		dvb_raddr,
		dvb_doutb,
		test_flag

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
   
	output 	[5:0]			dvb_raddr;
	input 	[511:0]		dvb_doutb;

	output test_flag;
	
//	reg 	dma_rdata_rdy;
//  reg 	[63:0]dma_rdata;

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
   wire	[10:0]ram_raddr1;
   wire	[511:0]ram_dout1;
   	
   reg	ram2_clear;
   reg	ram2_full;
   reg	ram_wr2;
   reg	[10:0]ram_waddr2;
   reg	[511:0]ram_din2;
   wire	[10:0]ram_raddr2;
   wire	[511:0]ram_dout2;
   
   
   
	reg	[4:0]rcstate;
	reg	[4:0]rnstate;
	
	
	reg	clear1;
	reg	clear2;
	reg	clear1_r1,clear1_r2,clear1_r3;
	reg	clear2_r1,clear2_r2,clear2_r3;
	

		
   
   
		parameter	RD_IDLE=0,
		
							RD_START_1=1,
							RD_ADDR_WAIT_1=2,							
							RD_ADDR_1=3,
   						RD_WR_PCIE_1=4,
   						
   						RD_EMPTY_WAIT_1=5,
   						RD_EMPTY_1=6,
   						RD_WR_EMPTY_1=7,
   						RD_EMPTY_END_1=8,   						
   						
   						RD_SWTICH=9,
   						
   						RD_START_2=10,
							RD_ADDR_WAIT_2=11,							
							RD_ADDR_2=12,
   						RD_WR_PCIE_2=13,
   						
   						RD_EMPTY_WAIT_2=14,
   						RD_EMPTY_2=15,
   						RD_WR_EMPTY_2=16,
   						RD_EMPTY_END_2=17 ;
   						
   	wire	rd_en;
   	wire	[15:0]dout;
   	wire 	empty;		
   	reg		ts_cmd_en;
   	
   	
   	reg		pcie_wr;
   	reg		[511:0]pcie_wdata;
   	wire 	pcie_empty;
   	wire 	pcie_prog_empty;
   	wire 	[63:0]pcie_rdata;
   
   
   
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
   	clear1_r1	<=	clear1;
   	clear1_r2	<=	clear1_r1;
   	clear1_r3	<=	clear1_r2;
   	
   	ram1_clear	<=	clear1_r2	&&!clear1_r3;
   end
   
   
   always@(posedge clk_ts)begin
   	clear2_r1	<=	clear2;
   	clear2_r2	<=	clear2_r1;
   	clear2_r3	<=	clear2_r2;
   	
   	ram2_clear	<=	clear2_r2	&&!clear2_r3;
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
   
   pcie_ts_ram pcie_ts_ram_uut_1 (
	  .clka(clk_ts), // input clka
	  .wea(ram_wr1), // input [0 : 0] wea
	  .addra(ram_waddr1), // input [10 : 0] addra
	  .dina(ram_din1), // input [511 : 0] dina
	  .clkb(clk_pcie), // input clkb
	  .addrb(ram_raddr1), // input [10 : 0] addrb
	  .doutb(ram_dout1) // output [511 : 0] doutb
	);
	
	
	pcie_ts_ram pcie_ts_ram_uut_2 (
	  .clka(clk_ts), // input clka
	  .wea(ram_wr2), // input [0 : 0] wea
	  .addra(ram_waddr2), // input [10 : 0] addra
	  .dina(ram_din2), // input [511 : 0] dina
	  .clkb(clk_pcie), // input clkb
	  .addrb(ram_raddr2), // input [10 : 0] addrb
	  .doutb(ram_dout2) // output [511 : 0] doutb
	);
   
   
   
   				
   						
   	pcie_addr pcie_addr_uut (
	  .clk(clk_pcie), // input clk
	  .rst(rst_pcie), // input rst
	  .din(dma_raddr[21:6]), // input [15 : 0] din
	  .wr_en(dma_raddr_en), // input wr_en
	  .rd_en(rd_en), // input rd_en
	  .dout(dout), // output [15 : 0] dout
	  .full(), // output full
	  .empty(empty) // output empty
	);					
   
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
						rnstate	=RD_ADDR_WAIT_1;	
					else
						rnstate	=RD_EMPTY_WAIT_1;
				RD_ADDR_WAIT_1:
					if(!empty)
						rnstate	=	RD_ADDR_1;
					else if(dma_write_end)
						rnstate	=	RD_SWTICH;
					else
						rnstate	=	RD_ADDR_WAIT_1;
				RD_ADDR_1:
					rnstate	=	RD_WR_PCIE_1;
				RD_WR_PCIE_1:
					rnstate	=	RD_ADDR_WAIT_1;
				
				RD_EMPTY_WAIT_1:
					if(!empty)
						rnstate	=	RD_EMPTY_1;
					else if(dma_write_end)
						rnstate	=	RD_EMPTY_END_1;
					else
						rnstate	=	RD_EMPTY_WAIT_1;
				RD_EMPTY_1:
					rnstate	=	RD_WR_EMPTY_1;
				RD_WR_EMPTY_1:
					rnstate	=	RD_EMPTY_WAIT_1;	
				RD_EMPTY_END_1:
					if(dma_write_start)
						rnstate	=	RD_START_1;
					else
						rnstate	= RD_EMPTY_END_1;
					
					
					
				RD_SWTICH:
					if(dma_write_start)
						rnstate	=	RD_START_2;
					else
						rnstate	=	RD_SWTICH;
				RD_START_2:
					if(ram2_full)
						rnstate	=RD_ADDR_WAIT_2;	
					else
						rnstate	=RD_EMPTY_WAIT_2;
				RD_ADDR_WAIT_2:
					if(!empty)
						rnstate	=	RD_ADDR_2;
					else if(dma_write_end)
						rnstate	=	RD_IDLE;
					else
						rnstate	=	RD_ADDR_WAIT_2;
				RD_ADDR_2:
					rnstate	=	RD_WR_PCIE_2;
				RD_WR_PCIE_2:
					rnstate	=	RD_ADDR_WAIT_2;
				
				RD_EMPTY_WAIT_2:
					if(!empty)
						rnstate	=	RD_EMPTY_2;
					else if(dma_write_end)
						rnstate	=	RD_EMPTY_END_2;
					else
						rnstate	=	RD_EMPTY_WAIT_2;
				RD_EMPTY_2:
					rnstate	=	RD_WR_EMPTY_2;
				RD_WR_EMPTY_2:
					rnstate	=	RD_EMPTY_WAIT_2;	
				RD_EMPTY_END_2:
					if(dma_write_start)
						rnstate	=	RD_START_2;
					else
						rnstate	= RD_EMPTY_END_2;
				default:
					rnstate	=	RD_IDLE;
			endcase
		end
		
		
		assign rd_en	=	(rnstate==RD_ADDR_1||rnstate==RD_ADDR_2||rnstate==RD_EMPTY_1 ||rnstate==RD_EMPTY_2)?1'b1:1'b0;
		assign ram_raddr1	=	((rcstate==RD_ADDR_1 ) && (dout[11]==0))?dout[10:0]:11'b0;
		assign ram_raddr2	=	((rcstate==RD_ADDR_2 ) && (dout[11]==0))?dout[10:0]:11'b0;
		assign dvb_raddr	=	(dout[11]==1)?dout[5:0]:6'b0;


		always@(posedge clk_pcie)begin
			if(rcstate==RD_IDLE)
				clear1	<=0;
			else if(rcstate==RD_SWTICH)
				clear1	<=0;
			else if(rcstate==RD_ADDR_WAIT_1&&ts_cmd_en)
				clear1	<=1;
			else
				clear1	<=clear1;
		end
		
		always@(posedge clk_pcie)begin
			if(rcstate==RD_IDLE)
				clear2	<=0;
			else if(rcstate==RD_ADDR_WAIT_2&&ts_cmd_en)
				clear2	<=1;
			else
				clear2	<=clear2;
		end

		always@(posedge clk_pcie)begin
			if(rcstate==RD_ADDR_1||rcstate==RD_ADDR_2||rcstate==RD_EMPTY_1||rcstate==RD_EMPTY_2)
				ts_cmd_en	<=	dout[11];
			else if(rcstate==RD_START_1 ||rcstate==RD_START_2)
				ts_cmd_en	<=0;
			else
				ts_cmd_en	<=ts_cmd_en;
			
			if(rst_pcie)begin
				pcie_wr	<=0;
				pcie_wdata	<=0;
			end
			else if(rcstate==RD_WR_PCIE_1)begin
				if(ts_cmd_en)
					pcie_wdata	<=	{dvb_doutb[31:0],dvb_doutb[63:32],dvb_doutb[95:64],dvb_doutb[127:96],
													dvb_doutb[159:128],dvb_doutb[191:160],dvb_doutb[223:192],dvb_doutb[255:224],
													dvb_doutb[287:256],dvb_doutb[319:288],dvb_doutb[351:320],dvb_doutb[383:352],
													dvb_doutb[415:384],dvb_doutb[447:416],dvb_doutb[479:448],dvb_doutb[511:480]};
				else
					pcie_wdata	<=	{ram_dout1[31:0],ram_dout1[63:32],ram_dout1[95:64],ram_dout1[127:96],
													ram_dout1[159:128],ram_dout1[191:160],ram_dout1[223:192],ram_dout1[255:224],
													ram_dout1[287:256],ram_dout1[319:288],ram_dout1[351:320],ram_dout1[383:352],
													ram_dout1[415:384],ram_dout1[447:416],ram_dout1[479:448],ram_dout1[511:480]};
				pcie_wr	<=1;
			end
			else if(rcstate==RD_WR_EMPTY_1||rcstate	==RD_WR_EMPTY_2)begin
				if(ts_cmd_en)
					pcie_wdata	<=	{dvb_doutb[31:0],dvb_doutb[63:32],dvb_doutb[95:64],dvb_doutb[127:96],
													dvb_doutb[159:128],dvb_doutb[191:160],dvb_doutb[223:192],dvb_doutb[255:224],
													dvb_doutb[287:256],dvb_doutb[319:288],dvb_doutb[351:320],dvb_doutb[383:352],
													dvb_doutb[415:384],dvb_doutb[447:416],dvb_doutb[479:448],dvb_doutb[511:480]};
				else				
					pcie_wdata	<=0;
				pcie_wr	<=1;
			end
			else if(rcstate==RD_WR_PCIE_2)begin
				if(ts_cmd_en)
					pcie_wdata	<=	{dvb_doutb[31:0],dvb_doutb[63:32],dvb_doutb[95:64],dvb_doutb[127:96],
													dvb_doutb[159:128],dvb_doutb[191:160],dvb_doutb[223:192],dvb_doutb[255:224],
													dvb_doutb[287:256],dvb_doutb[319:288],dvb_doutb[351:320],dvb_doutb[383:352],
													dvb_doutb[415:384],dvb_doutb[447:416],dvb_doutb[479:448],dvb_doutb[511:480]};
				else
					pcie_wdata	<=	{ram_dout2[31:0],ram_dout2[63:32],ram_dout2[95:64],ram_dout2[127:96],
													ram_dout2[159:128],ram_dout2[191:160],ram_dout2[223:192],ram_dout2[255:224],
													ram_dout2[287:256],ram_dout2[319:288],ram_dout2[351:320],ram_dout2[383:352],
													ram_dout2[415:384],ram_dout2[447:416],ram_dout2[479:448],ram_dout2[511:480]};
					pcie_wr	<=1;
			end			
			else begin
				pcie_wr	<=0;
				pcie_wdata	<=0;
			end
		end
		
		
		
		pcie_data pcie_data_uut (
	  .rst(rst_pcie), // input rst
	  .wr_clk(clk_pcie), // input wr_clk
	  .rd_clk(clk_pcie), // input rd_clk
	  .din(pcie_wdata), // input [511 : 0] din
	  .wr_en(pcie_wr), // input wr_en
	  .rd_en(dma_rdata_rdy), // input rd_en
	  .dout(pcie_rdata), // output [63 : 0] dout
	  .full(), // output full
	  .empty(pcie_empty), // output empty
	  .prog_empty(pcie_prog_empty) // output prog_empty
	);
	
	reg	pcie_rcstate;
	reg	pcie_rnstate;
	
	parameter	PCIE_RD_IDLE=0,
						PCIE_SEND_DATA=1;
						
	always@(posedge clk_pcie)begin
		if(rst_pcie)
			pcie_rcstate	<=	PCIE_RD_IDLE;
		else
			pcie_rcstate	<=	pcie_rnstate;	
	end
			
	always@(*)begin
		case(pcie_rcstate)
			PCIE_RD_IDLE:	
				if(!pcie_prog_empty)
					pcie_rnstate	=	PCIE_SEND_DATA;
				else	
					pcie_rnstate	=	PCIE_RD_IDLE;
			PCIE_SEND_DATA:
				if(pcie_empty)
					pcie_rnstate	=	PCIE_RD_IDLE;
				else
					pcie_rnstate	=	PCIE_SEND_DATA;
			default:
				pcie_rnstate	=	PCIE_RD_IDLE;
		endcase
	end		
	
	assign	dma_rdata_rdy	=pcie_rnstate==PCIE_SEND_DATA?1'b1:1'b0;
	assign	dma_rdata	=	{pcie_rdata[39:32],pcie_rdata[47:40],pcie_rdata[55:48],pcie_rdata[63:56],
										pcie_rdata[7:0],pcie_rdata[15:8],pcie_rdata[23:16],pcie_rdata[31:24]
				};
				
	reg	[3:0]tsmf_cc;
	reg	[3:0]tsmf_cnt;	
				
	always@(posedge clk_pcie)begin
		if(rst_pcie)
			tsmf_cnt	<=0;
		else if(dma_rdata_rdy && dma_rdata[55:0]==56'hfe1f470002430d )
			tsmf_cnt	<=dma_rdata[59:56];
		else
			tsmf_cnt		<=tsmf_cnt;
	end

	always@(posedge clk_pcie)begin
		if(rst_pcie)
			tsmf_cc	<=0;
		else if(dma_rdata_rdy && dma_rdata[55:0]==56'hfe1f470002430d)
				tsmf_cc	<=dma_rdata[59:56]-tsmf_cnt;
		else
			tsmf_cc	<=	tsmf_cc;
	end		
	
	
	assign test_flag=tsmf_cc==1?1'b0:1'b1;
		
endmodule
