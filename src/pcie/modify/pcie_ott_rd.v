// Design Name:
// Module Name:    pcie_ott_rd
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
module pcie_ott_rd(
	clk,
	rst,
	
	
	dma_rdata,						// : out std_logic_vector(63 downto 0);
	dma_raddr_en,					//: in std_logic;
	dma_raddr,						// : in  std_logic_vector(31 downto 0);
	dma_rdata_rdy,				// : out std_logic;
	dma_rdata_busy ,		
	
	ott_ram_addr,
	ott_ram_data
	
);


	input 	clk;
	input 	rst;
	
	input 	dma_raddr_en;
	input	[31:0]dma_raddr;
	
	output 	dma_rdata_rdy;
	output [63:0]	dma_rdata;
	
	reg	[3:0]rcstate;
	reg	[3:0]rnstate;
	
	parameter	IDLE=	0,
						RD_ADDR=1,
	
	always@(posedge clk)begin
		if(rst)
			rcstate	<=	IDLE;
		else
			rcstate	<=	rnstate;
	end
	
	
	always@()


endmodule
