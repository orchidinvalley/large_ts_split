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

library work;

entity pcie_app_v6 is

generic (
  EP_ID	: integer := 0 
    );
port  (
  -- PCIe interface
  trn_clk                   : in std_logic;
  trn_reset_n               : in std_logic;
  trn_td                    : out std_logic_vector(63 downto 0);
  trn_trem_n                : out std_logic;
  trn_tsof_n                : out std_logic;
  trn_teof_n                : out std_logic;
  trn_tsrc_rdy_n            : out std_logic;
  trn_tdst_rdy_n            : in std_logic;
  trn_tsrc_dsc_n            : out std_logic;
  trn_terrfwd_n             : out std_logic;
  trn_tcfg_req_n            : in std_logic;
  trn_tcfg_gnt_n            : out std_logic;
  trn_terr_drop_n           : in std_logic;
  trn_tstr_n                : out std_logic;
  trn_rd                    : in std_logic_vector(63 downto 0);
  trn_rrem_n                : in std_logic;
  trn_rsof_n                : in std_logic;
  trn_reof_n                : in std_logic;
  trn_rsrc_rdy_n            : in std_logic;
  trn_rsrc_dsc_n            : in std_logic;
  trn_rdst_rdy_n            : out std_logic;
  trn_rerrfwd_n             : in std_logic;
  trn_rnp_ok_n              : out std_logic;
  trn_rbar_hit_n            : in std_logic_vector(6 downto 0);
  trn_fc_nph                : in std_logic_vector(7 downto 0);
  trn_fc_npd                : in std_logic_vector(11 downto 0);
  trn_fc_ph                 : in std_logic_vector(7 downto 0);
  trn_fc_pd                 : in std_logic_vector(11 downto 0);
  trn_fc_cplh               : in std_logic_vector(7 downto 0);
  trn_fc_cpld               : in std_logic_vector(11 downto 0);
  trn_fc_sel                : out std_logic_vector(2 downto 0);
  cfg_do                    : in std_logic_vector(31 downto 0);
  cfg_di                    : out std_logic_vector(31 downto 0);
  cfg_byte_en_n             : out std_logic_vector(3 downto 0);
  cfg_dwaddr                : out std_logic_vector(9 downto 0);
  cfg_rd_wr_done_n          : in std_logic;
  cfg_wr_en_n               : out std_logic;
  cfg_rd_en_n               : out std_logic;
  cfg_err_cor_n             : out std_logic;
  cfg_err_ur_n              : out std_logic;
  cfg_err_cpl_rdy_n         : in std_logic;
  cfg_err_ecrc_n            : out std_logic;
  cfg_err_cpl_timeout_n     : out std_logic;
  cfg_err_cpl_abort_n       : out std_logic;
  cfg_err_cpl_unexpect_n    : out std_logic;
  cfg_err_posted_n          : out std_logic;
  cfg_err_locked_n          : out std_logic;
  cfg_interrupt_n           : out std_logic;
  cfg_interrupt_rdy_n       : in std_logic;
  cfg_interrupt_assert_n    : out std_logic;
  cfg_interrupt_di          : out std_logic_vector(7 downto 0);
  cfg_interrupt_do          : in  std_logic_vector(7 downto 0);
  cfg_interrupt_mmenable    : in  std_logic_vector(2 downto 0);
  cfg_interrupt_msienable   : in  std_logic;
  cfg_interrupt_msixenable  : in  std_logic;
  cfg_interrupt_msixfm      : in  std_logic;
  cfg_turnoff_ok_n          : out std_logic;
  cfg_to_turnoff_n          : in std_logic;
  cfg_pm_wake_n             : out std_logic;
  cfg_pcie_link_state_n     : in std_logic_vector(2 downto 0);
  cfg_trn_pending_n         : out std_logic;
  cfg_err_tlp_cpl_header    : out std_logic_vector(47 downto 0);
  cfg_bus_number            : in std_logic_vector(7 downto 0);
  cfg_device_number         : in std_logic_vector(4 downto 0);
  cfg_function_number       : in std_logic_vector(2 downto 0);
  cfg_status                : in std_logic_vector(15 downto 0);
  cfg_command               : in std_logic_vector(15 downto 0);
  cfg_dstatus               : in std_logic_vector(15 downto 0);
  cfg_dcommand              : in std_logic_vector(15 downto 0);
  cfg_lstatus               : in std_logic_vector(15 downto 0);
  cfg_lcommand              : in std_logic_vector(15 downto 0);
  cfg_dcommand2             : in std_logic_vector(15 downto 0);
  cfg_dsn                   : out std_logic_vector(63 downto 0);
  pl_directed_link_change   : out std_logic_vector(1 downto 0);
  pl_ltssm_state            : in std_logic_vector(5 downto 0);
  pl_directed_link_width    : out std_logic_vector(1 downto 0);
  pl_directed_link_speed    : out std_logic;
  pl_directed_link_auton    : out std_logic;
  pl_upstream_prefer_deemph : out std_logic;
  pl_sel_link_width         : in std_logic_vector(1 downto 0);
  pl_sel_link_rate          : in std_logic;
  pl_link_gen2_capable      : in std_logic;
  pl_link_partner_gen2_supported : in std_logic;
  pl_initial_link_width     : in std_logic_vector(2 downto 0);
  pl_link_upcfg_capable     : in std_logic;
  pl_lane_reversal_mode     : in std_logic_vector(1 downto 0);
  pl_received_hot_rst       : in std_logic;  
  
  --descriptors interface
  descriptors_buffers_addr_portb : out std_logic_vector(9 downto 0);
  descriptors_buffers_dout_portb : in std_logic_vector(31 downto 0);
  descriptors_buffers_din_portb : out std_logic_vector(31 downto 0);
  descriptors_buffers_we_portb : out std_logic;
  
  -- mailbox interface
  mailbox_wen_dout_portb : in std_logic_vector(31 downto 0);
  mailbox_wen_din_portb : out std_logic_vector(31 downto 0);
  mailbox_wen_portb : out std_logic;
  mailbox_wen_addr_portb : out std_logic_vector(10 downto 0);
  
  --interface with MPMC
  --write port
  dma_waddr_en : out std_logic;
  dma_waddr : out std_logic_vector(31 downto 0);
  dma_wdata_en : out std_logic;
  dma_wdata : out std_logic_vector(63 downto 0);
  dma_wdata_rdy : in std_logic;
  -- read port
  dma_rdata_en : out std_logic;
  dma_rdata : in std_logic_vector(63 downto 0);
  dma_raddr_en : out std_logic;
  dma_raddr : out std_logic_vector(31 downto 0);
  dma_rdata_rdy : in std_logic;
  dma_rdata_busy : in std_logic;
  
  -- clock, reset, debug signals
  dma_reset 	: in std_logic;  
  debug	  		: out std_logic_vector(7 downto 0);

  -- unused
  soft_rst_ep 	: in std_logic;
  dma_write_start : out std_logic;
  dma_write_end : out std_logic;
  dma_read_start : out std_logic;
  dma_read_end : out std_logic;

  dma_start: in std_logic;
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
  
  logic_int_en : in std_logic;
  logic_int_en_ack : out std_logic 
  
);
end pcie_app_v6;

architecture v6_pcie of pcie_app_v6 is

component dma_engine
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
  
  descriptors_buffers_addr_portb : out std_logic_vector(9 downto 0);
  descriptors_buffers_dout_portb : in std_logic_vector(31 downto 0);
  descriptors_buffers_din_portb : out std_logic_vector(31 downto 0);
  descriptors_buffers_we_portb : out std_logic;
  
  mailbox_wen_dout_portb : in std_logic_vector(31 downto 0);
  mailbox_wen_din_portb : out std_logic_vector(31 downto 0);
  mailbox_wen_portb : out std_logic;
  mailbox_wen_addr_portb : out std_logic_vector(10 downto 0);
  
  dma_reset : in std_logic;
  debug	    : out std_logic_vector(7 downto 0);
  
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

-- Local wires 

signal cfg_completer_id       : std_logic_vector(15 downto 0);
signal cfg_bus_mstr_enable    : std_logic;
signal trn_trem_n_out         : std_logic_vector(7 downto 0);
signal trn_rrem_n_in          : std_logic_vector(7 downto 0);
begin 

  -- Core input tie-offs

  trn_rnp_ok_n              <= '0';
  trn_terrfwd_n             <= '1';
  trn_fc_sel                <= "000";
  trn_tcfg_gnt_n            <= '0';
  trn_tstr_n                <= '0';

  pl_directed_link_change   <= "00";
  pl_directed_link_width    <= "00";
  pl_directed_link_speed    <= '0';
  pl_directed_link_auton    <= '0';
  pl_upstream_prefer_deemph <= '1';

  cfg_err_cor_n             <= '1';
  cfg_err_ur_n              <= '1';
  cfg_err_ecrc_n            <= '1';
  cfg_err_cpl_timeout_n     <= '1';
  cfg_err_cpl_abort_n       <= '1';
  cfg_err_cpl_unexpect_n    <= '1';
  cfg_err_posted_n          <= '0';
  cfg_err_locked_n          <= '1';

  
  cfg_pm_wake_n             <= '1';
  cfg_trn_pending_n         <= '1';
  cfg_dwaddr                <= (others => '0');
  cfg_err_tlp_cpl_header    <= (others => '0');
  cfg_di                    <= (others => '0');
  cfg_byte_en_n             <= X"F"; -- 4-bit bus
  cfg_wr_en_n               <= '1';
  cfg_rd_en_n               <= '1';
  cfg_dsn                   <= X"0000000101000A35";

  cfg_completer_id          <= (cfg_bus_number &
                                cfg_device_number &
                                cfg_function_number);
  cfg_bus_mstr_enable       <= cfg_command(2);

  trn_trem_n                <= '1' when (trn_trem_n_out = X"0F") else
                               '0';
  trn_rrem_n_in             <= X"0F" when (trn_rrem_n = '1') else
                               X"00";

-- Programmable I/O Module

PCIE_DMA : dma_engine 
port map (

  trn_clk  =>  trn_clk,                       -- I
  trn_reset_n  =>  trn_reset_n,               -- I
  trn_td  => trn_td,                          -- O (63:0)
  trn_tsof_n  => trn_tsof_n,
  trn_trem_n  => trn_trem_n_out,
  trn_teof_n  => trn_teof_n,                  -- O
  trn_tsrc_rdy_n  => trn_tsrc_rdy_n,          -- O
  trn_tsrc_dsc_n  => trn_tsrc_dsc_n,          -- O
  trn_tdst_rdy_n  => trn_tdst_rdy_n,          -- I
  trn_tdst_dsc_n  => '1',                     -- I
  trn_rd  => trn_rd ,                         -- I (63:0)
  trn_rrem_n  => trn_rrem_n_in,
  trn_rsof_n  => trn_rsof_n,                  -- I
  trn_reof_n  => trn_reof_n,                  -- I
  trn_rsrc_rdy_n  => trn_rsrc_rdy_n,          -- I
  trn_rsrc_dsc_n  => trn_rsrc_dsc_n,          -- I
  trn_rbar_hit_n => trn_rbar_hit_n,           -- I (6:0)
  trn_rdst_rdy_n  => trn_rdst_rdy_n,          -- O
  cfg_to_turnoff_n  => cfg_to_turnoff_n,      -- I
  cfg_turnoff_ok_n => cfg_turnoff_ok_n,    -- O
  cfg_completer_id  => cfg_completer_id,      -- I (15:0)
  cfg_bus_mstr_enable => cfg_bus_mstr_enable,  -- I
  cfg_interrupt_msienable => cfg_interrupt_msienable,
  cfg_interrupt_mmenable => cfg_interrupt_mmenable,
  cfg_interrupt_do => cfg_interrupt_do,
  cfg_interrupt_n => cfg_interrupt_n,
  cfg_interrupt_rdy_n => cfg_interrupt_rdy_n,
  cfg_interrupt_assert_n => cfg_interrupt_assert_n,
  cfg_interrupt_di => cfg_interrupt_di,  
  
  descriptors_buffers_addr_portb => descriptors_buffers_addr_portb,
  descriptors_buffers_dout_portb => descriptors_buffers_dout_portb,
  descriptors_buffers_din_portb => descriptors_buffers_din_portb,
  descriptors_buffers_we_portb => descriptors_buffers_we_portb,
  
   -- mailbox interface 
  mailbox_wen_addr_portb => mailbox_wen_addr_portb,
  mailbox_wen_din_portb => mailbox_wen_din_portb,
  mailbox_wen_portb => mailbox_wen_portb,
  mailbox_wen_dout_portb => mailbox_wen_dout_portb,  
  
  dma_reset => dma_reset,
  debug 		=> debug,
  
  -- this is the memory controller interface
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
  
  -- unused
  soft_rst_ep => soft_rst_ep,
  dma_start => dma_start,	
  dma_end => dma_end,
  dma_cmd_addr => dma_cmd_addr,
  dma_cmd_din => dma_cmd_din,
  dma_cmd_wen => dma_cmd_wen,
  dma_cmd_ren => dma_cmd_ren,
  dma_cmd_rdy => dma_cmd_rdy,
  dma_cmd_dout => dma_cmd_dout,
 
  user_cmd_to_rp_wen => user_cmd_to_rp_wen,
  user_cmd_to_rp_wdata => user_cmd_to_rp_wdata,
  user_cmd_to_rp_wack => user_cmd_to_rp_wack,
  user_cmd_to_rp_addr => user_cmd_to_rp_addr,
  user_cmd_to_rp_ren => user_cmd_to_rp_ren,
  user_cmd_to_rp_rdata => user_cmd_to_rp_rdata,
  user_cmd_to_rp_rdy => user_cmd_to_rp_rdy,
  
  user_cmd_from_rp_wen => user_cmd_from_rp_wen,
  user_cmd_from_rp_wdata => user_cmd_from_rp_wdata,
  user_cmd_from_rp_addr => user_cmd_from_rp_addr,
  user_cmd_from_rp_ren => user_cmd_from_rp_ren,
  user_cmd_from_rp_rdy => user_cmd_from_rp_rdy,
  user_cmd_from_rp_rdata => user_cmd_from_rp_rdata,
  
  dma_write_start => dma_write_start,
  dma_write_end => dma_write_end,
  dma_read_start => dma_read_start,
  dma_read_end => dma_read_end,
  
  logic_int_en => logic_int_en,
  logic_int_en_ack => logic_int_en_ack
  
  );

end; -- pcie_app_v6
