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


entity dma_engine is
port (
	
  trn_clk                : in std_logic;         
  trn_reset_n            : in std_logic;
  trn_td                 : out std_logic_vector(63 downto 0);
  trn_trem_n             : out std_logic_vector(7 downto 0);
  trn_tsof_n             : out std_logic;
  trn_teof_n             : out std_logic;
  trn_tsrc_rdy_n         : out std_logic;
  trn_tsrc_dsc_n         : out std_logic;
  trn_tdst_rdy_n         : in std_logic;
  trn_tdst_dsc_n         : in std_logic;
  trn_rd                 : in std_logic_vector(63 downto 0);
  trn_rrem_n             : in std_logic_vector(7 downto 0);
  trn_rsof_n             : in std_logic;
  trn_reof_n             : in std_logic;
  trn_rsrc_rdy_n         : in std_logic;
  trn_rsrc_dsc_n         : in std_logic;
  trn_rbar_hit_n         : in std_logic_vector(6 downto 0);
  trn_rdst_rdy_n         : out std_logic;
  cfg_to_turnoff_n       : in std_logic;
  cfg_turnoff_ok_n       : out std_logic;
  cfg_completer_id       : in std_logic_vector(15 downto 0);
  cfg_bus_mstr_enable    : in std_logic;
   -- interrupt configuration for EP
  cfg_interrupt_msienable : in std_logic;
  cfg_interrupt_mmenable : in std_logic_vector(2 downto 0);
  cfg_interrupt_do : in std_logic_vector(7 downto 0);
  cfg_interrupt_n : out std_logic;
  cfg_interrupt_rdy_n : in std_logic;
  cfg_interrupt_assert_n : out std_logic;
  cfg_interrupt_di : out std_logic_vector(7 downto 0);
  -- interrupt configuration for EP
  
  debug	    : out std_logic_vector(7 downto 0);
  dma_reset : in std_logic;
  
  mailbox_wen_dout_portb : in std_logic_vector(31 downto 0);
  mailbox_wen_din_portb : out std_logic_vector(31 downto 0);
  mailbox_wen_portb : out std_logic;
  mailbox_wen_addr_portb : out std_logic_vector(10 downto 0);
  
  descriptors_buffers_addr_portb : out std_logic_vector(9 downto 0);
  descriptors_buffers_dout_portb : in std_logic_vector(31 downto 0);
  descriptors_buffers_din_portb : out std_logic_vector(31 downto 0);
  descriptors_buffers_we_portb : out std_logic;
    
  -- this is the memory controller interface
  dma_waddr_en : out std_logic;
  dma_waddr : out std_logic_vector(31 downto 0);
  dma_wdata_en : out std_logic;
  dma_wdata : out std_logic_vector(63 downto 0);
  dma_wdata_rdy : in std_logic;
  dma_rdata_en : out std_logic;
  dma_rdata : in std_logic_vector(63 downto 0);
  dma_raddr_en : out std_logic;
  dma_raddr : out std_logic_vector(31 downto 0);
  dma_rdata_rdy : in std_logic;
  dma_rdata_busy : in std_logic;
  
  -- unused   
  dma_start : in std_logic;	
  dma_end : out std_logic;
  soft_rst_ep : in std_logic;
  
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

end dma_engine;

architecture rtl of dma_engine is	 

begin

end;  -- dma_engine
