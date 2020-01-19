----------------------------------------------------------------------------------------
-- This file is owned and controlled by Avnet and must be used solely
-- for design, simulation, implementation and creation of design files
-- limited to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and immediately
-- terminates your license.
--
--            **************************************
--            ** Copyright (C) 2013, Avnet **
--            ** All Rights Reserved.             **
--            **************************************
----------------------------------------------------------------------------------------
--Created by Avnet HKADS.
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

entity pcie_dma_ep_top is
  generic (
  SIM_BYPASS_INIT_CAL						 : string := "OFF";
  PL_FAST_TRAIN                              : string := "FALSE";
  EP_ID   : integer := 0
    );
  port (
  pci_exp_txp                   : out std_logic_vector(3 downto 0);
  pci_exp_txn                   : out std_logic_vector(3 downto 0);
  pci_exp_rxp                   : in std_logic_vector(3 downto 0);
  pci_exp_rxn                   : in std_logic_vector(3 downto 0);
  
  cmd_dvb_dout					: out std_logic_vector(7 downto 0);
  cmd_dvb_dout_en				: out std_logic;
  cmd_dvb_din						: in std_logic_vector(7 downto 0);
  cmd_dvb_din_en				: in std_logic;

	
	test_flag			:	OUT 	std_logic;
	test_interval	:	OUT	std_logic;
	
	ts_ram_valid				:	in	std_logic;
	ts_ram_waddr				:	in	std_logic_vector(12	downto 0);
	ts_ram_wr						:	in	std_logic;
	ts_ram_wdata				:	in	std_logic_vector(511	downto 0);
	ts_ram_clear				:	OUT	std_logic;

  sys_clk_p                     : in std_logic;
  sys_clk_n                     : in std_logic;
  sys_reset_n                   : in std_logic;
  clk_main						: in std_logic;
  
  trn_clk							:out std_logic;
  ram_full_1					:OUT	std_logic;
  ram_full_2					:out std_logic;
  
 
  
--  clk200_p		: in std_logic;
--  clk200_n 		: in std_logic;
--  debug			: out std_logic_vector(7 downto 0);
  emclk 			: in std_logic
  --clk27 : in std_logic;
  --ch1 : out std_logic;
  --ch2 : out std_logic
  );
end pcie_dma_ep_top;

architecture rtl of pcie_dma_ep_top is 
   
   
   

  -- this is the PCIE DMA Core 
  component pcie_dma_core_ep is
  generic (
  SIM_BYPASS_INIT_CAL						 : string := "OFF";
  PL_FAST_TRAIN                              : string := "FALSE";
  EP_ID   : integer
    );
  port (
  pci_exp_txp                   : out std_logic_vector(3 downto 0);
  pci_exp_txn                   : out std_logic_vector(3 downto 0);
  pci_exp_rxp                   : in std_logic_vector(3 downto 0);
  pci_exp_rxn                   : in std_logic_vector(3 downto 0);

  sys_clk_c						: in std_logic;
 -- clk200						: in std_logic;
  sys_reset_n                   : in std_logic;
  
  phy_init_doneout : out std_logic;
  
  -- clock, reset, debug signals
  trn_clkout : out std_logic;
  dma_resetout : out std_logic;
  debug			: out std_logic_vector(7 downto 0);
  
  -- descriptors interface
  descriptors_buffers_addr_portb : out std_logic_vector(9 downto 0);
  descriptors_buffers_dout_portb : in std_logic_vector(31 downto 0);
  descriptors_buffers_din_portb : out std_logic_vector(31 downto 0);
  descriptors_buffers_we_portb : out std_logic;

  --Mailbox interface
  mailbox_wen_dout_portb : in std_logic_vector(31 downto 0);
  mailbox_wen_din_portb : out std_logic_vector(31 downto 0);
  mailbox_wen_portb : out std_logic;
  mailbox_wen_addr_portb : out std_logic_vector(10 downto 0);
  
  --interface with data generators
  -- connect to MPMC   
  user_waddr_en : in std_logic; -- 
  user_waddr : in std_logic_vector(31 downto 0); -- 
  user_wdata_en : in std_logic; -- 
  user_wdata : in std_logic_vector(63 downto 0); -- 
  user_wdata_rdy : out std_logic; 
	
  --interface with data_check	
  -- connect to MPMC 
  user_raddr_en : in std_logic; -- read address enable, user must set the address to read 1Kbytes data 
  user_raddr : in std_logic_vector(31 downto 0); -- read address in bytes 
  user_rdata_busy : out std_logic; -- user must check this busy signal before sending "user_raddr_en". If "user_rdata_busy" is high in busy, "data_check" is not ready to receive read request.
  user_rdata_rdy : out std_logic; -- data ready from "data_check", set high when data is stored in buffer and ready for read. User must check with this signal before read out the data from buffer
  user_rdata_en : in std_logic; -- read data enable, set high to read out 1 data per cycle from "data_check" buffer
  user_rdata : out std_logic_vector(63 downto 0); -- read data  
  
  -- to BRAM data
--  bram_wea0 : out std_logic;
--  bram_wea1 : out std_logic;
--  bram_waddr : out std_logic_vector(12 downto 0);
--  bram_dina : out std_logic_vector(511 downto 0);
--  bram_raddr : out std_logic_vector(12 downto 0);
--  bram_doutb0 : in std_logic_vector(511 downto 0);
--  bram_doutb1 : in std_logic_vector(511 downto 0);
--  

		dma_waddr_en : OUT std_logic;
		dma_waddr : OUT std_logic_vector(31 downto 0);
		dma_wdata_en : OUT std_logic;
		dma_wdata : OUT std_logic_vector(63 downto 0);
		dma_wdata_rdy : IN std_logic;
		
		dma_rdata_en : OUT std_logic;
		dma_raddr_en : OUT std_logic;
		dma_raddr : OUT std_logic_vector(31 downto 0);			
		dma_rdata : IN std_logic_vector(63 downto 0);
		dma_rdata_rdy : IN std_logic;
		dma_rdata_busy : IN std_logic;

  --unused  
  soft_rst_ep : in std_logic;  
  dma_start : in std_logic;
  dma_end : out std_logic;
  dma_cmd_addr : in std_logic_vector(15 downto 0);
  dma_cmd_din : in std_logic_vector(31 downto 0);
  dma_cmd_wen : in std_logic;
  dma_cmd_ren : in std_logic;
  dma_cmd_rdy : out std_logic;
  dma_cmd_dout : out std_logic_vector(31 downto 0);
  
  user_cmd_from_rp_wen : out std_logic;
  user_cmd_from_rp_addr : out std_logic_vector(31 downto 0);
  user_cmd_from_rp_wdata : out std_logic_vector(31 downto 0);	
  user_cmd_from_rp_ren : out std_logic;
  user_cmd_from_rp_rdy : in std_logic;
  user_cmd_from_rp_rdata : in std_logic_vector(31 downto 0);

  user_cmd_to_rp_wen : in std_logic;
  user_cmd_to_rp_addr : in std_logic_vector(31 downto 0);
  user_cmd_to_rp_wdata : in std_logic_vector(31 downto 0);	  
  user_cmd_to_rp_wack : out std_logic;
  user_cmd_to_rp_ren : in std_logic;
  user_cmd_to_rp_rdata : out std_logic_vector(31 downto 0);
  user_cmd_to_rp_rdy : out std_logic;
  
  dma_write_start : out std_logic;
  dma_write_end : out std_logic;
  dma_read_start : out std_logic;
  dma_read_end : out std_logic;
  
  logic_int_en : in std_logic;
  logic_int_en_ack : out std_logic
  
);
end component; 

COMPONENT dma_time_test
	PORT(
		clk_pcie : IN std_logic;
		rst_pcie : IN std_logic;
		dma_write_start : IN std_logic;
		dma_write_end : IN std_logic;          
		test_interval : OUT std_logic
		);
	END COMPONENT;

--COMPONENT ott_ts_ram
--  PORT (
--    clka : IN STD_LOGIC;
--    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
--    dina : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
--    clkb : IN STD_LOGIC;
--    addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
--    doutb : OUT STD_LOGIC_VECTOR(511 DOWNTO 0)
--  );
--END COMPONENT;


COMPONENT dvb_cmd_ram
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(511 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(511 DOWNTO 0)
  );
END COMPONENT;
  
  COMPONENT pcie_wr_ram
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		dma_read_start : IN std_logic;
		dma_wdata_en : IN std_logic;
		dma_wdata : IN std_logic_vector(63 downto 0);          
		dma_wdata_rdy : OUT std_logic;
		ott_ram_clear	:	OUT std_logic;
		ott_ram_wr : OUT std_logic;
		ott_ram_waddr : OUT std_logic_vector(12 downto 0);
		ott_ram_dina : OUT std_logic_vector(127 downto 0);
		dvb_cmd_dout : OUT std_logic_vector(63 downto 0);
		dvb_cmd_sof : OUT std_logic;
		dvb_cmd_eof : OUT std_logic;
		dvb_cmd_dout_en : OUT std_logic
		);
	END COMPONENT;    
  
  
--COMPONENT pcie_rd_ram
--PORT(
--	clk : IN std_logic;
--	rst : IN std_logic;
--	--dma_write_start : IN std_logic;
--	--dma_rdata_en : IN std_logic;
--	dma_raddr_en : IN std_logic;
--	dma_raddr : IN std_logic_vector(31 downto 0);
--	ott_ram_clear:IN std_logic;
--	ott_doutb : IN std_logic_vector(511 downto 0);
--	dvb_doutb : IN std_logic_vector(511 downto 0);          
--	dma_rdata : OUT std_logic_vector(63 downto 0);
--	dma_rdata_rdy : OUT std_logic;
--	dma_rdata_busy : OUT std_logic;
--	ott_raddr : OUT std_logic_vector(10 downto 0);
--	dvb_raddr : OUT std_logic_vector(5 downto 0);
--	ts_ram_valid : IN std_logic;
--	test_flag	:	OUT std_logic
--	);
--END COMPONENT;
	
--COMPONENT pcie_ts_rd
--PORT(
--	clk_ts					:	IN	std_logic;
--	rst_ts					:	IN	std_logic;		
--	ts_ram_wr				:	IN	std_logic;
--	ts_ram_wdata		:	IN std_logic_vector(511 downto 0);
--	clk_pcie				:	IN	std_logic;
--	rst_pcie				:	IN	std_logic;	
--	dma_write_start	:	IN	std_logic;	
--	dma_write_end		:	IN	std_logic;	
--	dma_raddr_en		:	IN	std_logic;				
--	dma_raddr				:	IN	std_logic_vector(31 downto 0);				
--	dma_rdata_rdy		:	OUT	std_logic;				
--	dma_rdata_busy	:	OUT	std_logic;	 		
--	dma_rdata				:	OUT	std_logic_vector(63 downto 0);
--	test_flag				:	OUT	std_logic	;
--	ram_full_1			:OUT	std_logic;
--	ram_full_2			:out	std_logic
--);
--END COMPONENT  ;
	
	COMPONENT	pcie_ts_rd_v2  
	PORT(
    clk_ts					:	IN	std_logic;
		rst_ts					:	IN	std_logic;		
		ts_ram_wr				:	IN	std_logic;
		ts_ram_wdata		:	IN std_logic_vector(511 downto 0);
		clk_pcie				:	IN	std_logic;
		rst_pcie				:	IN	std_logic;	
		dma_write_start	:	IN	std_logic;	
		dma_write_end		:	IN	std_logic;	
		dma_raddr_en		:	IN	std_logic;				
		dma_raddr				:	IN	std_logic_vector(31 downto 0);				
		dma_rdata_rdy		:	OUT	std_logic;				
		dma_rdata_busy	:	OUT	std_logic;	 		
		dma_rdata				:	OUT	std_logic_vector(63 downto 0);
		test_flag				:	OUT	std_logic	;
    dvb_raddr				:	OUT	std_logic_vector(5 downto 0);
    dvb_doutb				:	OUT	std_logic_vector(511 downto 0)
   
    );
    END COMPONENT;

	
	
	
  	
	COMPONENT cmd_pcie_dvb
	PORT(
		trn_clk : IN std_logic;
		clk_main : IN std_logic;
		rst : IN std_logic;
		cmd_dma_din : IN std_logic_vector(63 downto 0);
		cmd_dma_sof : IN std_logic;
		cmd_dma_eof : IN std_logic;
		cmd_dma_din_en : IN std_logic;
		cmd_dvb_din : IN std_logic_vector(7 downto 0);
		cmd_dvb_din_en : IN std_logic;          
		cmd_dma_dout : OUT std_logic_vector(63 downto 0);
		cmd_dma_dout_en : OUT std_logic;
		cmd_dma_addr : OUT std_logic_vector(8 downto 0);
		cmd_dvb_dout : OUT std_logic_vector(7 downto 0);
		cmd_dvb_dout_en : OUT std_logic
		);
	END COMPONENT; 
 -- this is the descritpors FIFO
  component mailbox_buffer IS
   PORT (
     clka : IN STD_LOGIC;
     wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
     addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
     dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
     douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
     clkb : IN STD_LOGIC;
     web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
     addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
     dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
     doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
   );
   END component;  
  component descriptors_buffers IS
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
  END component;  
   

  -- reserved for user own defined usage
  component data_generators is port 
	(
		clk	: in std_logic; 
		rst : in std_logic;
	
		-- user interface
		user_waddr_en : out std_logic; -- write address enable, user must program the address to "data_generators" before sending data.
		user_waddr : out std_logic_vector(31 downto 0); -- write address in bytes
		user_wdata_en : out std_logic; -- write enable for the write data, set high to inidicate the data is "user_wdata" is ready at current clock cycle 
		user_wdata : out std_logic_vector(63 downto 0); -- write data 
		user_wdata_rdy : in std_logic -- ready signal of "data_generators", user must check with this signal for "user_wdata_en". Set high when "data_generators" is ready to recieve data.				
	);
  end component;
  
   -- reserved for user own defined usage
  component data_check 
    port(
    clk : in std_logic;
    reset : in std_logic;
    
    --user interface
    user_raddr_en : out std_logic; -- read address enable, user must set the address to read data 
    user_raddr : out std_logic_vector(31 downto 0); -- read address in bytes 
    user_rdata_busy : in std_logic; -- user must check this busy signal before sending "user_raddr_en". If "user_rdata_busy" is high in busy, "data_check" is not ready to receive read request.
    user_rdata_rdy : in std_logic; -- data ready from "data_check", set high when data is stored in buffer and ready for read. User must check with this signal before read out the data from buffer
    user_rdata_en : out std_logic; -- read data enable, set high to read out 1 data per cycle from "data_check" buffer
    user_rdata : in std_logic_vector(63 downto 0) -- read data 
    );
  end component;
  
  
   -- reserved for user own defined usage
  component user_generators_ep
  generic (
  EP_ID   : integer
    );
	port (
	 clk                : in std_logic;
         rst                : in std_logic;
	 
	 dma_cmd_addr : out std_logic_vector(15 downto 0);
	 dma_cmd_din : out std_logic_vector(31 downto 0);
	 dma_cmd_wen : out std_logic;
	 dma_cmd_ren : out std_logic;
	 dma_cmd_rdy : in std_logic;
	 dma_cmd_dout : in std_logic_vector(31 downto 0);
	 
	 descriptors_buffers_wea : out std_logic_vector( 0 downto 0);
	 descriptors_buffers_waddr : out std_logic_vector(9 downto 0);
	 descriptors_buffers_din : out std_logic_vector(31 downto 0)
	);
  end component;

   -- reserved for user own defined usage
  component ep_rp_cmd_pcie 
  generic (
    EP_ID	: integer := 0
    );
  port (
	clk : in std_logic;
	reset : in std_logic;
	
	mailbox_wen_porta : out std_logic;
	mailbox_wen_addr_porta : out std_logic_vector(10 downto 0);
	mailbox_wen_dout_porta : in std_logic_vector(31 downto 0);
	mailbox_wen_din_porta : out std_logic_vector(31 downto 0)	
  );
  end component;
signal clk200_ibufg, clk200 : std_logic;
signal sys_clk_c : std_logic;
signal sys_reset_n_c : std_logic;
signal debug_c : std_logic_vector(7 downto 0);

signal dma_config_size_enout : std_logic;
signal dma_config_sizeout : std_logic_vector(29 downto 0);
signal descriptors_buffers_wea : std_logic_vector(0 downto 0);
signal descriptors_buffers_waddr : std_logic_vector(9 downto 0);
signal descriptors_buffers_din : std_logic_vector(31 downto 0);
 
signal trn_clkout : std_logic; 
 
 
signal phy_init_doneout :  std_logic;
signal dma_write_start : std_logic;
signal dma_write_end : std_logic;
signal dma_read_start : std_logic;
signal dma_read_end : std_logic;

signal user_wdata_en : std_logic;
signal user_wdata : std_logic_vector(63 downto 0);
signal user_wdata_rdy : std_logic;
signal user_waddr_en : std_logic;
signal user_waddr : std_logic_vector(31 downto 0);
		
signal user_raddr_en : std_logic;
signal user_raddr : std_logic_vector(31 downto 0);
signal user_rdata_busy : std_logic;
signal user_rdata_en : std_logic;
signal user_rdata : std_logic_vector(63 downto 0);
signal user_rdata_rdy : std_logic;
signal dma_start : std_logic;
signal dma_resetout : std_logic;
signal dma_end : std_logic;

signal descriptors_buffers_addr_portb : std_logic_vector(9 downto 0);
signal descriptors_buffers_dout_portb : std_logic_vector(31 downto 0);
signal descriptors_buffers_din_portb :  std_logic_vector(31 downto 0);
signal descriptors_buffers_we_portb :   std_logic;
    
signal descriptors_buffers_addr_porta : std_logic_vector(9 downto 0);
signal descriptors_buffers_dout_porta : std_logic_vector(31 downto 0);
signal descriptors_buffers_din_porta :  std_logic_vector(31 downto 0);
signal descriptors_buffers_we_porta :   std_logic;	

signal dma_cmd_addr : std_logic_vector(15 downto 0);
signal dma_cmd_din :  std_logic_vector(31 downto 0);
signal dma_cmd_wen :  std_logic;
signal dma_cmd_ren :  std_logic;
signal dma_cmd_rdy :  std_logic;
signal dma_cmd_dout :  std_logic_vector(31 downto 0);

signal mailbox_wen_dout_portb : std_logic_vector(31 downto 0);
signal mailbox_wen_din_portb : std_logic_vector(31 downto 0);
signal mailbox_wen_portb : std_logic;
signal mailbox_wen_addr_portb : std_logic_vector(10 downto 0);

signal mailbox_wen_dout_porta : std_logic_vector(31 downto 0);
signal mailbox_wen_din_porta : std_logic_vector(31 downto 0);
signal mailbox_wen_porta : std_logic;
signal mailbox_wen_addr_porta : std_logic_vector(10 downto 0);


signal logic_int_en : std_logic;
signal logic_int_en_ack : std_logic;
signal debug_c_int : std_logic_vector(7 downto 0);



		signal dma_waddr_en : std_logic;
		signal dma_waddr : std_logic_vector(31 downto 0);
		signal dma_wdata_en : std_logic;
		signal dma_wdata : std_logic_vector(63 downto 0);
		signal dma_wdata_rdy : std_logic;
		
		signal dma_rdata_en : std_logic;
		signal dma_rdata : std_logic_vector(63 downto 0);
		signal dma_raddr_en : std_logic;
		signal dma_raddr : std_logic_vector(31 downto 0);
		signal dma_rdata_rdy : std_logic;
		signal dma_rdata_busy : std_logic;

		signal cmd_dout_en	:std_logic;	
		signal cmd_dout		:std_logic_vector (63 downto 0);
		signal cmd_sof		:std_logic;
		signal cmd_eof		:std_logic;
		signal cmd_dma_dout_en	:std_logic;	
		signal cmd_dma_dout		:std_logic_vector (63 downto 0);
		signal cmd_dma_addr		:std_logic_vector (8 downto 0);	
		
		signal ott_raddr : std_logic_vector(10 downto 0);
		signal dvb_raddr : std_logic_vector(5 downto 0);
		
		signal ott_doutb, dvb_doutb : std_logic_vector(511 downto 0);
		signal dvb_douta	: std_logic_vector(63 downto 0);
		signal dvb_web		: std_logic_vector(0 downto 0);
		signal dvb_dinb		: std_logic_vector(511 downto 0);
		signal cmd_wea		: std_logic_vector(0 downto 0);
		signal ott_wea		: std_logic_vector(0 downto 0);
		
		
		signal ott_web	: std_logic_vector(0 downto 0);
		signal ott_dinb	: std_logic_vector(511 downto 0);
		signal ott_douta:	std_logic_vector(127 downto 0);
		
		signal ott_ram_wr:std_logic;
		signal ott_ram_waddr:std_logic_vector(12 downto 0);
		signal ott_ram_dina:std_logic_vector(127 downto 0);
		signal ott_ram_clear:std_logic;
		signal rst	:std_logic;
--		signal cmd_dvb_dout	:std_logic_vector(7 downto 0);
--		signal cmd_dvb_dout_en	:std_logic;
--	signal cmd_dvb_din	:std_logic_vector(7 downto 0);
--	signal cmd_dvb_din_en	:std_logic;
	begin
 
	
  refclk_ibuf : IBUFDS_GTE2 
     port map(
       O       => sys_clk_c,
       ODIV2   => open,
       I       => sys_clk_p,
       IB      => sys_clk_n,
       CEB     => '0');

 
  ---------------------------
  
  -- this is the PCIe DMA Core 	   
  xpcie_dma_core_ep : pcie_dma_core_ep
  generic map (
  SIM_BYPASS_INIT_CAL   => SIM_BYPASS_INIT_CAL,
  PL_FAST_TRAIN	        => PL_FAST_TRAIN,
  EP_ID   => EP_ID
    )
  port map (  
  pci_exp_txp                  => pci_exp_txp,
  pci_exp_txn                  => pci_exp_txn,
  pci_exp_rxp                  => pci_exp_rxp,
  pci_exp_rxn                  => pci_exp_rxn,

  sys_clk_c		       => sys_clk_c,
--  clk200		       => clk200,
  sys_reset_n                  => sys_reset_n_c,
  
  phy_init_doneout => phy_init_doneout,

  
  --clock, debug, reset signals
  trn_clkout => trn_clkout,
  dma_resetout => dma_resetout,
  debug	       => debug_c,
  
  --descriptors interface
  descriptors_buffers_addr_portb => descriptors_buffers_addr_portb,
  descriptors_buffers_dout_portb => descriptors_buffers_dout_portb,
  descriptors_buffers_din_portb => descriptors_buffers_din_portb,
  descriptors_buffers_we_portb => descriptors_buffers_we_portb,
  
  -- mailbox interface 
  mailbox_wen_addr_portb => mailbox_wen_addr_portb,
  mailbox_wen_din_portb => mailbox_wen_din_portb,
  mailbox_wen_portb => mailbox_wen_portb,
  mailbox_wen_dout_portb => mailbox_wen_dout_portb,  
  
  user_wdata_en => user_wdata_en,
  user_wdata => user_wdata,
  user_wdata_rdy => user_wdata_rdy,	
  user_waddr_en => user_waddr_en,
  user_waddr => user_waddr,
	
  user_raddr_en => user_raddr_en,
  user_raddr => user_raddr,
  user_rdata_busy => user_rdata_busy,
  user_rdata_en => user_rdata_en,
  user_rdata => user_rdata,
  user_rdata_rdy => user_rdata_rdy,
  
		dma_waddr_en => dma_waddr_en,
		dma_waddr => dma_waddr,
		dma_wdata_en => dma_wdata_en,
		dma_wdata => dma_wdata,
		dma_wdata_rdy => dma_wdata_rdy,
		dma_rdata_en => dma_rdata_en,
		dma_rdata => dma_rdata,
		dma_raddr_en => dma_raddr_en,
		dma_raddr => dma_raddr,
		dma_rdata_rdy => dma_rdata_rdy,
		dma_rdata_busy => dma_rdata_busy,
  
  --unused
  soft_rst_ep => '0',
  dma_start => '0',
  dma_end => dma_end,
  dma_cmd_addr => dma_cmd_addr,
  dma_cmd_din => dma_cmd_din,
  dma_cmd_wen => dma_cmd_wen,
  dma_cmd_ren => dma_cmd_ren,
  dma_cmd_rdy => dma_cmd_rdy,
  dma_cmd_dout => dma_cmd_dout,
 
  dma_write_start => dma_write_start,
  dma_write_end => dma_write_end,
  dma_read_start => dma_read_start,
  dma_read_end => dma_read_end,
  
  user_cmd_to_rp_wen => '0',
  user_cmd_to_rp_wdata => (others => '0'),
  user_cmd_to_rp_addr => (others => '0'),
  user_cmd_to_rp_ren => '0',  
  user_cmd_from_rp_rdy => '0',
  user_cmd_from_rp_rdata => (others => '0'),
  
  logic_int_en => logic_int_en,
  logic_int_en_ack => logic_int_en_ack

);


 xmailbox_buffer : mailbox_buffer
  port map (
	clka 	=> trn_clkout, 
    wea(0) 	=> mailbox_wen_porta,	
    addra 	=> mailbox_wen_addr_porta,
    dina 	=> mailbox_wen_din_porta,
    douta 	=> mailbox_wen_dout_porta,
    clkb 	=> trn_clkout,
    web(0) 	=> mailbox_wen_portb,
    addrb 	=> mailbox_wen_addr_portb,
    dinb 	=> mailbox_wen_din_portb,
    doutb 	=> mailbox_wen_dout_portb
  );
  
  -- this is the descriptors buffers
  xdescriptors_buffers : descriptors_buffers
  port map (
	clka 	=> trn_clkout, 
    wea(0) 	=> descriptors_buffers_we_porta,	
    addra 	=> descriptors_buffers_addr_porta,
    dina 	=> descriptors_buffers_din_porta,
    douta 	=> descriptors_buffers_dout_porta,
    clkb 	=> trn_clkout,
    web(0) 	=> descriptors_buffers_we_portb,
    addrb 	=> descriptors_buffers_addr_portb,
    dinb 	=> descriptors_buffers_din_portb,
    doutb 	=> descriptors_buffers_dout_portb
  );	


	dvb_web	<="0";
	ott_web	<="0";
	dvb_dinb	<=(others =>'0');
	ott_dinb	<=(others=>'0');
	cmd_wea	<= conv_std_logic_vector(cmd_dma_dout_en,1);
	ott_wea	<= conv_std_logic_vector(ts_ram_wr,1);
	ts_ram_clear	<=ott_ram_clear;
	trn_clk <=trn_clkout;

sys_reset_n_ibuf : IBUF
     port map(
       O       => sys_reset_n_c,
       I       => sys_reset_n);	
	
		rst<= not phy_init_doneout;
----------------------------
	
	
	
	u_pcie_wr_ram: pcie_wr_ram PORT MAP(
		clk 							=>trn_clkout,
		rst 							=> dma_resetout,
		dma_read_start	    => dma_read_start,
		dma_wdata_en 		=> dma_wdata_en,
		dma_wdata				=> dma_wdata,
		dma_wdata_rdy 		=> dma_wdata_rdy,
		ott_ram_wr 				=>ott_ram_wr ,
		ott_ram_waddr 		=>ott_ram_waddr ,
		ott_ram_dina			=> ott_ram_dina,
		ott_ram_clear			=>	ott_ram_clear,
		dvb_cmd_dout 		=> cmd_dout,
		dvb_cmd_sof 			=> cmd_sof,
		dvb_cmd_eof 			=>cmd_eof ,
		dvb_cmd_dout_en 	=>cmd_dout_en 
	);
	
	
	
	u_cmd_pcie_dvb: cmd_pcie_dvb PORT MAP(		
		trn_clk => trn_clkout,
		clk_main => clk_main,
		rst => rst,
		cmd_dma_din => cmd_dout,
		cmd_dma_sof => cmd_sof,
		cmd_dma_eof => cmd_eof,
		cmd_dma_din_en => cmd_dout_en,
		cmd_dma_dout => cmd_dma_dout,
		cmd_dma_dout_en => cmd_dma_dout_en,
		cmd_dma_addr => cmd_dma_addr,
		cmd_dvb_din => cmd_dvb_din,----»·»Ø ²âÊÔ
		cmd_dvb_din_en => cmd_dvb_din_en,
		cmd_dvb_dout => cmd_dvb_dout,
		cmd_dvb_dout_en => cmd_dvb_dout_en
	);
	
	--	u_pcie_rd_ram: pcie_rd_ram PORT MAP(
	--	clk => trn_clkout,
	--	rst => rst,		
	--	dma_rdata =>dma_rdata ,
	--	dma_raddr_en =>dma_raddr_en ,
	--	dma_raddr =>dma_raddr ,
	--	dma_rdata_rdy => dma_rdata_rdy,
	--	dma_rdata_busy =>dma_rdata_busy ,
	--	ott_ram_clear	=>ott_ram_clear,
	--	ott_raddr =>ott_raddr ,
	--	ott_doutb =>ott_doutb ,
	--	dvb_raddr => dvb_raddr,
	--	dvb_doutb => dvb_doutb,
	--	ts_ram_valid	=>	ts_ram_valid,
	--	test_flag		=>	test_flag
	--);
	
	
--ts_pcie_rd: pcie_ts_rd
--PORT MAP(
--	clk_ts					=>clk_main,
--	rst_ts					=>rst,
--	ts_ram_wr				=>ts_ram_wr,
--	ts_ram_wdata		=>ts_ram_wdata,
--	clk_pcie				=>trn_clkout,
--	rst_pcie				=>rst,
--	dma_write_start	=>dma_write_start,
--	dma_write_end		=>dma_write_end,
--	dma_raddr_en		=>dma_raddr_en,			
--	dma_raddr				=>dma_raddr,				
--	dma_rdata_rdy		=>dma_rdata_rdy,				
--	dma_rdata_busy	=>dma_rdata_busy,
--	dma_rdata				=>dma_rdata,
--	test_flag				=>test_flag	,
--	ram_full_1			=>ram_full_1,
--	ram_full_2			=>ram_full_2		
--	
--	
--);
	
	ts_pcie_rd: pcie_ts_rd_v2
	PORT MAP(
		clk_ts					=>clk_main,
		rst_ts					=>rst,
		ts_ram_wr				=>ts_ram_wr,
		ts_ram_wdata		=>ts_ram_wdata,
		clk_pcie				=>trn_clkout,
		rst_pcie				=>rst,
		dma_write_start	=>dma_write_start,
		dma_write_end		=>dma_write_end,
		dma_raddr_en		=>dma_raddr_en,			
		dma_raddr				=>dma_raddr,				
		dma_rdata_rdy		=>dma_rdata_rdy,				
		dma_rdata_busy	=>dma_rdata_busy,
		dma_rdata				=>dma_rdata,
		test_flag				=>test_flag,
		dvb_raddr 			=>dvb_raddr,
		dvb_doutb 			=>dvb_doutb
		
		
	);


	Inst_dma_time_test: dma_time_test PORT MAP(
		clk_pcie => trn_clkout,
		rst_pcie => dma_resetout,
		dma_write_start => dma_write_start,
		dma_write_end => dma_write_end,
		test_interval =>	test_interval
	);	

--	ott_ts : ott_ts_ram
--	PORT MAP (
--	  clka => clk_main,
--	  wea => ott_wea,
--	  addra => ts_ram_waddr,
--	  dina => ts_ram_wdata,
--	  clkb => trn_clkout,
--	  addrb => ott_raddr,
--	  doutb => ott_doutb
--	);


	
	dvb_cmd : dvb_cmd_ram
  PORT MAP (
    clka => clk_main,
    wea => cmd_wea,
    addra => cmd_dma_addr,
    dina => cmd_dma_dout,
    douta => dvb_douta,
    clkb => trn_clkout,
    web => dvb_web ,
    addrb => dvb_raddr,
    dinb => dvb_dinb,
    doutb => dvb_doutb
  );
 -- user defined modules
  xdata_generators : data_generators 
	port map(
		clk	=> trn_clkout,
		rst => dma_resetout,
		
		-- user interface
		user_wdata_en => user_wdata_en,
		user_wdata => user_wdata,
		user_wdata_rdy => user_wdata_rdy,	
		user_waddr_en => user_waddr_en,
		user_waddr => user_waddr
	);
   xdata_check : data_check port map(
		clk => trn_clkout, 
		reset => dma_resetout,
		
		--user interface
		user_raddr_en => user_raddr_en,
		user_raddr => user_raddr,
		user_rdata_busy => user_rdata_busy,
		user_rdata_en => user_rdata_en,
		user_rdata => user_rdata,
		user_rdata_rdy => user_rdata_rdy
	); 
   xuser_generators_ep : user_generators_ep
   generic map (
  	EP_ID   => EP_ID 
     )
   port map
    (
   	 clk => trn_clkout,
   	 rst => dma_resetout,
   	 
  	 dma_cmd_addr => dma_cmd_addr,
  	 dma_cmd_din => dma_cmd_din,
  	 dma_cmd_wen => dma_cmd_wen,
  	 dma_cmd_ren => dma_cmd_ren,
  	 dma_cmd_rdy => dma_cmd_rdy,
   	 dma_cmd_dout => dma_cmd_dout,
   	 descriptors_buffers_wea(0) => descriptors_buffers_we_porta, -- this is the write enable of the descriptors buffer (BRAM) 
   	 descriptors_buffers_waddr => descriptors_buffers_addr_porta, -- this is the address of the descriptors buffer 
   	 descriptors_buffers_din => descriptors_buffers_din_porta -- this is the datain of the descriptors buffer
   ); 	
   
   xep_rp_cmd_pcie : ep_rp_cmd_pcie
  generic map(
	EP_ID => EP_ID
	)
  port map 
  (
	clk => trn_clkout,
	reset => dma_resetout,
	
	mailbox_wen_porta => mailbox_wen_porta,
	mailbox_wen_addr_porta => mailbox_wen_addr_porta,
	mailbox_wen_dout_porta => mailbox_wen_dout_porta,
	mailbox_wen_din_porta => mailbox_wen_din_porta
  );
  
  -- example on how to generate an interrupt 
	-- using Mailbox for demo in this example
	-- when mailbox 16'h2010 is received and its data is x"ffff_ffff"
	-- then generate an interrupt to PC
	process (trn_clkout)
	begin
		if trn_clkout 'event and trn_clkout = '1' then
			if dma_resetout = '1' then
				logic_int_en <= '0';
			elsif (logic_int_en = '1' and logic_int_en_ack = '1') then
				logic_int_en <= '0';
			elsif mailbox_wen_portb = '1' and mailbox_wen_addr_portb = b"000_0000_0100" and mailbox_wen_din_portb = x"ffff_ffff" then
				logic_int_en <= '1';
			else
				logic_int_en <= logic_int_en;
			end if;
		end if;
	end process;
    		
	   


end rtl;
