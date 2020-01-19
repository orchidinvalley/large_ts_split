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

library unisim;
use unisim.vcomponents.all;

entity pcie_dma_core_ep is
  generic (
  SIM_BYPASS_INIT_CAL 	: string := "OFF";
  PL_FAST_TRAIN                              : string := "FALSE";
  BRAM_MODE 			: integer := 0;
  PCIE_EXT_CLK          : string := "TRUE";  -- Use External Clocking Module
  C_DATA_WIDTH			: integer range 64 to 128 := 64;
  EP_ID	: integer
    );
  port (
  pci_exp_txp                   : out std_logic_vector(3 downto 0);
  pci_exp_txn                   : out std_logic_vector(3 downto 0);
  pci_exp_rxp                   : in std_logic_vector(3 downto 0);
  pci_exp_rxn                   : in std_logic_vector(3 downto 0);

  sys_clk_c						: in std_logic;
  --clk200						: in std_logic;
  sys_reset_n                   : in std_logic;
  
  -- timer for throughput calculation
  dma_write_start : out std_logic;
  dma_write_end : out std_logic;
  dma_read_start : out std_logic;
  dma_read_end : out std_logic;
  
  --descriptors interface
  descriptors_buffers_addr_portb : out std_logic_vector(9 downto 0);
  descriptors_buffers_dout_portb : in std_logic_vector(31 downto 0);
  descriptors_buffers_din_portb : out std_logic_vector(31 downto 0);
  descriptors_buffers_we_portb : out std_logic;
  
  --Mailbox interface
  mailbox_wen_dout_portb : in std_logic_vector(31 downto 0);
  mailbox_wen_din_portb : out std_logic_vector(31 downto 0);
  mailbox_wen_portb : out std_logic;
  mailbox_wen_addr_portb : out std_logic_vector(10 downto 0);
  
  --clock, reset, debug signals
  dma_resetout : out std_logic;
  trn_clkout : out std_logic;  
  phy_init_doneout : out std_logic;
  debug			: out std_logic_vector(7 downto 0);
  
  user_waddr_en : in std_logic; -- 
  user_waddr : in std_logic_vector(31 downto 0); -- 
  user_wdata_en : in std_logic; -- 
  user_wdata : in std_logic_vector(63 downto 0); -- 
  user_wdata_rdy : out std_logic; 
	
  user_raddr_en : in std_logic; -- read address enable, user must set the address to read data 
  user_raddr : in std_logic_vector(31 downto 0); -- read address in bytes 
  user_rdata_busy : out std_logic; -- user must check this busy signal before sending "user_raddr_en". If "user_rdata_busy" is high in busy, "data_read" is not ready to receive read request.
  user_rdata_rdy : out std_logic; -- data ready from "data_read", set high when data is stored in buffer and ready for read. User must check with this signal before read out the data from buffer
  user_rdata_en : in std_logic; -- read data enable, set high to read out 1 data per cycle from "data_read" buffer
  user_rdata : out std_logic_vector(63 downto 0); -- read data  
  
--  bram_wea0 : out std_logic;
--  bram_wea1 : out std_logic;
--  bram_waddr : out std_logic_vector(12 downto 0);
--  bram_dina : out std_logic_vector(511 downto 0);
--  bram_raddr : out std_logic_vector(12 downto 0);
--  bram_doutb0 : in std_logic_vector(511 downto 0);
--  bram_doutb1 : in std_logic_vector(511 downto 0);
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

--  
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
  
  logic_int_en : in std_logic;
  logic_int_en_ack : out std_logic
);
end pcie_dma_core_ep;

architecture rtl of pcie_dma_core_ep is 
   
component pcie_app_v6 is generic (
      EP_ID : integer);
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
  
  -- clock, reset, debug signals
  dma_reset : in std_logic;
  debug	  		: out std_logic_vector(7 downto 0);

  --descriptors interface
  descriptors_buffers_addr_portb : out std_logic_vector(9 downto 0);
  descriptors_buffers_dout_portb : in std_logic_vector(31 downto 0);
  descriptors_buffers_din_portb : out std_logic_vector(31 downto 0);
  descriptors_buffers_we_portb : out std_logic;
  
  --Mailbox interface
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
  dma_write_start : out std_logic;
  dma_write_end : out std_logic;
  dma_read_start : out std_logic;
  dma_read_end : out std_logic;
  
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
end component;

component mpmc is port 
(
	clk : in std_logic;
	rst : in std_logic;
	
	port0_wdata_en : in std_logic;
	port0_wdata : in std_logic_vector(63 downto 0);
	port0_wdata_rdy : out std_logic;
	port0_waddr_en : in std_logic;
	port0_waddr : in std_logic_vector(31 downto 0);
	
	port0_raddr_en : in std_logic;
	port0_raddr : in std_logic_vector(31 downto 0);
	port0_rdata_busy : out std_logic;
	port0_rdata_en : in std_logic;
	port0_rdata : out std_logic_vector(63 downto 0);
	port0_rdata_rdy : out std_logic;
	
	port1_wdata_en : in std_logic;
	port1_wdata : in std_logic_vector(63 downto 0);
	port1_wdata_rdy : out std_logic;
	port1_waddr_en : in std_logic;
	port1_waddr : in std_logic_vector(31 downto 0);
	
	port1_raddr_en : in std_logic;
	port1_raddr : in std_logic_vector(31 downto 0);
	port1_rdata_busy : out std_logic;
	port1_rdata_en : in std_logic;
	port1_rdata : out std_logic_vector(63 downto 0);
	port1_rdata_rdy : out std_logic;
	
	app_wdf_wren  : out std_logic;
	app_wdf_data  : out std_logic_vector(255 downto 0);
	app_wdf_mask : out std_logic_vector(31 downto 0);
	app_wdf_end  : out std_logic;
	app_addr     : out std_logic_vector(26 downto 0);
	app_cmd      : out std_logic_vector(2 downto 0);
	app_en       : out std_logic;
    
	app_rdy       : in std_logic;
	app_wdf_rdy   : in std_logic;
	app_rd_data   : in std_logic_vector(255 downto 0);
	app_rd_data_end : in std_logic;
	app_rd_data_valid : in std_logic;
	ui_clk_sync_rst : in std_logic;
	ui_clk       : in std_logic	
);
end component; 

component bram_ctr
 port (
	clk : in std_logic;
	rst : in std_logic;
	
	app_wdf_wren  : in    std_logic;
        app_wdf_data  : in    std_logic_vector((4*64)-1 downto 0);
        app_wdf_mask  : in    std_logic_vector((4*64)/8-1 downto 0);
        app_wdf_end   : in    std_logic;
        app_addr      : in    std_logic_vector(28-1 downto 0);
        app_cmd       : in    std_logic_vector(2 downto 0);
        app_en        : in    std_logic;
        app_rdy       : out   std_logic;
        app_wdf_rdy   : out   std_logic;
        app_rd_data   : out   std_logic_vector((4*64)-1 downto 0);
        app_rd_data_end : out   std_logic;
        app_rd_data_valid : out   std_logic;
	
	bram_wea0 : out std_logic;
	bram_wea1 : out std_logic;
	bram_waddr : out std_logic_vector(12 downto 0);
	bram_dina : out std_logic_vector(511 downto 0);
	bram_raddr : out std_logic_vector(12 downto 0);
	bram_doutb0 : in std_logic_vector(511 downto 0);
	bram_doutb1 : in std_logic_vector(511 downto 0)
	
 );
 end component;


 component pcie_7x_v1_10    generic (
           PL_FAST_TRAIN                              : string := "FALSE";
      PCIE_EXT_CLK                               : string := "FALSE";
      UPSTREAM_FACING                            : string := "TRUE"
    );
    port (
     -------------------------------------------------------------------------------------------------------------------
     -- 1. PCI Express (pci_exp) Interface                                                                            --
     -------------------------------------------------------------------------------------------------------------------
      pci_exp_txp                                : out std_logic_vector(3 downto 0);
      pci_exp_txn                                : out std_logic_vector(3 downto 0);
      pci_exp_rxp                                : in std_logic_vector(3 downto 0);
      pci_exp_rxn                                : in std_logic_vector(3 downto 0);

     -------------------------------------------------------------------------------------------------------------------
     -- 2. Clocking Interface                                                                                         --
     -------------------------------------------------------------------------------------------------------------------
      PIPE_PCLK_IN                               : in std_logic;
      PIPE_RXUSRCLK_IN                           : in std_logic;
      PIPE_RXOUTCLK_IN                           : in std_logic_vector(3 downto 0);
      PIPE_DCLK_IN                               : in std_logic;
      PIPE_USERCLK1_IN                           : in std_logic;
      PIPE_USERCLK2_IN                           : in std_logic;
      PIPE_OOBCLK_IN                             : in std_logic;
      PIPE_MMCM_LOCK_IN                          : in std_logic;

      PIPE_TXOUTCLK_OUT                          : out std_logic;
      PIPE_RXOUTCLK_OUT                          : out std_logic_vector(3 downto 0);
      PIPE_PCLK_SEL_OUT                          : out std_logic_vector(3 downto 0);
      PIPE_GEN3_OUT                              : out std_logic;

     -------------------------------------------------------------------------------------------------------------------
     -- 3. AXI-S Interface                                                                                            --
     -------------------------------------------------------------------------------------------------------------------
      -- Common
      user_clk_out                               : out std_logic;
      user_reset_out                             : out std_logic;
      user_lnk_up                                : out std_logic;

      -- TX
      tx_buf_av                                  : out std_logic_vector(5 downto 0);
      tx_cfg_req                                 : out std_logic;
      tx_err_drop                                : out std_logic;
      s_axis_tx_tready                           : out std_logic;
      s_axis_tx_tdata                            : in std_logic_vector((C_DATA_WIDTH - 1) downto 0);
      s_axis_tx_tkeep                            : in std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
      s_axis_tx_tlast                            : in std_logic;
      s_axis_tx_tvalid                           : in std_logic;
      s_axis_tx_tuser                            : in std_logic_vector(3 downto 0);
      tx_cfg_gnt                                 : in std_logic;

      -- RX
      m_axis_rx_tdata                            : out std_logic_vector((C_DATA_WIDTH - 1) downto 0);
      m_axis_rx_tkeep                            : out std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
      m_axis_rx_tlast                            : out std_logic;
      m_axis_rx_tvalid                           : out std_logic;
      m_axis_rx_tready                           : in std_logic;
      m_axis_rx_tuser                            : out std_logic_vector(21 downto 0);
      rx_np_ok                                   : in std_logic;
      rx_np_req                                  : in std_logic;

      -- Flow Control
      fc_cpld                                    : out std_logic_vector(11 downto 0);
      fc_cplh                                    : out std_logic_vector(7 downto 0);
      fc_npd                                     : out std_logic_vector(11 downto 0);
      fc_nph                                     : out std_logic_vector(7 downto 0);
      fc_pd                                      : out std_logic_vector(11 downto 0);
      fc_ph                                      : out std_logic_vector(7 downto 0);
      fc_sel                                     : in std_logic_vector(2 downto 0);

     -------------------------------------------------------------------------------------------------------------------
     -- 4. Configuration (CFG) Interface                                                                              --
     -------------------------------------------------------------------------------------------------------------------
     ---------------------------------------------------------------------
      -- EP and RP                                                      --
     ---------------------------------------------------------------------
      cfg_mgmt_do                                : out std_logic_vector (31 downto 0);
      cfg_mgmt_rd_wr_done                        : out std_logic;

      cfg_status                                 : out std_logic_vector(15 downto 0);
      cfg_command                                : out std_logic_vector(15 downto 0);
      cfg_dstatus                                : out std_logic_vector(15 downto 0);
      cfg_dcommand                               : out std_logic_vector(15 downto 0);
      cfg_lstatus                                : out std_logic_vector(15 downto 0);
      cfg_lcommand                               : out std_logic_vector(15 downto 0);
      cfg_dcommand2                              : out std_logic_vector(15 downto 0);
      cfg_pcie_link_state                        : out std_logic_vector(2 downto 0);

      cfg_pmcsr_pme_en                           : out std_logic;
      cfg_pmcsr_powerstate                       : out std_logic_vector(1 downto 0);
      cfg_pmcsr_pme_status                       : out std_logic;
      cfg_received_func_lvl_rst                  : out std_logic;

      -- Management Interface
      cfg_mgmt_di                                : in std_logic_vector (31 downto 0);
      cfg_mgmt_byte_en                           : in std_logic_vector (3 downto 0);
      cfg_mgmt_dwaddr                            : in std_logic_vector (9 downto 0);
      cfg_mgmt_wr_en                             : in std_logic;
      cfg_mgmt_rd_en                             : in std_logic;
      cfg_mgmt_wr_readonly                       : in std_logic;

      -- Error Reporting Interface
      cfg_err_ecrc                               : in std_logic;
      cfg_err_ur                                 : in std_logic;
      cfg_err_cpl_timeout                        : in std_logic;
      cfg_err_cpl_unexpect                       : in std_logic;
      cfg_err_cpl_abort                          : in std_logic;
      cfg_err_posted                             : in std_logic;
      cfg_err_cor                                : in std_logic;
      cfg_err_atomic_egress_blocked              : in std_logic;
      cfg_err_internal_cor                       : in std_logic;
      cfg_err_malformed                          : in std_logic;
      cfg_err_mc_blocked                         : in std_logic;
      cfg_err_poisoned                           : in std_logic;
      cfg_err_norecovery                         : in std_logic;
      cfg_err_tlp_cpl_header                     : in std_logic_vector(47 downto 0);
      cfg_err_cpl_rdy                            : out std_logic;
      cfg_err_locked                             : in std_logic;
      cfg_err_acs                                : in std_logic;
      cfg_err_internal_uncor                     : in std_logic;
      cfg_trn_pending                            : in std_logic;
      cfg_pm_halt_aspm_l0s                       : in std_logic;
      cfg_pm_halt_aspm_l1                        : in std_logic;
      cfg_pm_force_state_en                      : in std_logic;
      cfg_pm_force_state                         : std_logic_vector(1 downto 0);
      cfg_dsn                                    : std_logic_vector(63 downto 0);

     ---------------------------------------------------------------------
      -- EP Only                                                        --
     ---------------------------------------------------------------------
      cfg_interrupt                              : in std_logic;
      cfg_interrupt_rdy                          : out std_logic;
      cfg_interrupt_assert                       : in std_logic;
      cfg_interrupt_di                           : in std_logic_vector(7 downto 0);
      cfg_interrupt_do                           : out std_logic_vector(7 downto 0);
      cfg_interrupt_mmenable                     : out std_logic_vector(2 downto 0);
      cfg_interrupt_msienable                    : out std_logic;
      cfg_interrupt_msixenable                   : out std_logic;
      cfg_interrupt_msixfm                       : out std_logic;
      cfg_interrupt_stat                         : in std_logic;
      cfg_pciecap_interrupt_msgnum               : in std_logic_vector(4 downto 0);
      cfg_to_turnoff                             : out std_logic;
      cfg_turnoff_ok                             : in std_logic;
      cfg_bus_number                             : out std_logic_vector(7 downto 0);
      cfg_device_number                          : out std_logic_vector(4 downto 0);
      cfg_function_number                        : out std_logic_vector(2 downto 0);
      cfg_pm_wake                                : in std_logic;

     ---------------------------------------------------------------------
      -- RP Only                                                        --
     ---------------------------------------------------------------------
      cfg_pm_send_pme_to                         : in std_logic;
      cfg_ds_bus_number                          : in std_logic_vector(7 downto 0);
      cfg_ds_device_number                       : in std_logic_vector(4 downto 0);
      cfg_ds_function_number                     : in std_logic_vector(2 downto 0);

      cfg_mgmt_wr_rw1c_as_rw                     : in std_logic;
      cfg_msg_received                           : out std_logic;
      cfg_msg_data                               : out std_logic_vector(15 downto 0);

      cfg_bridge_serr_en                         : out std_logic;
      cfg_slot_control_electromech_il_ctl_pulse  : out std_logic;
      cfg_root_control_syserr_corr_err_en        : out std_logic;
      cfg_root_control_syserr_non_fatal_err_en   : out std_logic;
      cfg_root_control_syserr_fatal_err_en       : out std_logic;
      cfg_root_control_pme_int_en                : out std_logic;
      cfg_aer_rooterr_corr_err_reporting_en      : out std_logic;
      cfg_aer_rooterr_non_fatal_err_reporting_en : out std_logic;
      cfg_aer_rooterr_fatal_err_reporting_en     : out std_logic;
      cfg_aer_rooterr_corr_err_received          : out std_logic;
      cfg_aer_rooterr_non_fatal_err_received     : out std_logic;
      cfg_aer_rooterr_fatal_err_received         : out std_logic;

      cfg_msg_received_err_cor                   : out std_logic;
      cfg_msg_received_err_non_fatal             : out std_logic;
      cfg_msg_received_err_fatal                 : out std_logic;
      cfg_msg_received_pm_as_nak                 : out std_logic;
      cfg_msg_received_pm_pme                    : out std_logic;
      cfg_msg_received_pme_to_ack                : out std_logic;
      cfg_msg_received_assert_int_a              : out std_logic;
      cfg_msg_received_assert_int_b              : out std_logic;
      cfg_msg_received_assert_int_c              : out std_logic;
      cfg_msg_received_assert_int_d              : out std_logic;
      cfg_msg_received_deassert_int_a            : out std_logic;
      cfg_msg_received_deassert_int_b            : out std_logic;
      cfg_msg_received_deassert_int_c            : out std_logic;
      cfg_msg_received_deassert_int_d            : out std_logic;
      cfg_msg_received_setslotpowerlimit         : out std_logic;

     -------------------------------------------------------------------------------------------------------------------
     -- 5. Physical Layer Control and Status (PL) Interface                                                           --
     -------------------------------------------------------------------------------------------------------------------
      pl_directed_link_change                    : in std_logic_vector(1 downto 0);
      pl_directed_link_width                     : in std_logic_vector(1 downto 0);
      pl_directed_link_speed                     : in std_logic;
      pl_directed_link_auton                     : in std_logic;
      pl_upstream_prefer_deemph                  : in std_logic;

      pl_sel_lnk_rate                            : out std_logic;
      pl_sel_lnk_width                           : out std_logic_vector(1 downto 0);
      pl_ltssm_state                             : out std_logic_vector(5 downto 0);
      pl_lane_reversal_mode                      : out std_logic_vector(1 downto 0);

      pl_phy_lnk_up                              : out std_logic;
      pl_tx_pm_state                             : out std_logic_vector(2 downto 0);
      pl_rx_pm_state                             : out std_logic_vector(1 downto 0);

      pl_link_upcfg_cap                          : out std_logic;
      pl_link_gen2_cap                           : out std_logic;
      pl_link_partner_gen2_supported             : out std_logic;
      pl_initial_link_width                      : out std_logic_vector(2 downto 0);

      pl_directed_change_done                    : out std_logic;

     ---------------------------------------------------------------------
      -- EP Only                                                        --
     ---------------------------------------------------------------------
      pl_received_hot_rst                        : out std_logic;
     ---------------------------------------------------------------------
      -- RP Only                                                        --
     ---------------------------------------------------------------------
      pl_transmit_hot_rst                        : in std_logic;
      pl_downstream_deemph_source                : in std_logic;
     -------------------------------------------------------------------------------------------------------------------
     -- 6. AER interface                                                                                              --
     -------------------------------------------------------------------------------------------------------------------
      cfg_err_aer_headerlog                      : in std_logic_vector(127 downto 0);
      cfg_aer_interrupt_msgnum                   : in std_logic_vector(4 downto 0);
      cfg_err_aer_headerlog_set                  : out std_logic;
      cfg_aer_ecrc_check_en                      : out std_logic;
      cfg_aer_ecrc_gen_en                        : out std_logic;
     -------------------------------------------------------------------------------------------------------------------
     -- 7. VC interface                                                                                               --
     -------------------------------------------------------------------------------------------------------------------
      cfg_vc_tcvc_map                            : out std_logic_vector(6 downto 0);

     -------------------------------------------------------------------------------------------------------------------
     -- 8. System(SYS) Interface                                                                                      --
     -------------------------------------------------------------------------------------------------------------------
      PIPE_MMCM_RST_N                            : in std_logic;   --     // Async      | Async
      sys_clk                                    : in std_logic;
      sys_rst_n                                  : in std_logic);
  end component;

 component v7_pcie_conv    
 generic (
	C_DATA_WIDTH				  : integer := 64;
	PL_FAST_TRAIN                 : string := "FALSE";
	PCIE_EXT_CLK                  : string := "TRUE"  -- Use External Clocking Module
 );
 port (
	--------------------------------------------------------------------------------------
	  --------------------------------------------------------------------------------------
	  ------------------------------- V6 ---------------------------------------------------
	  v6_trn_clk                                   : out std_logic;
      v6_trn_reset_n                               : out std_logic;
      v6_trn_lnk_up_n                              : out std_logic;
      v6_trn_tbuf_av                               : out std_logic_vector(5 downto 0);
      v6_trn_tcfg_req_n                            : out std_logic;
      v6_trn_terr_drop_n                           : out std_logic;
      v6_trn_tdst_rdy_n                            : out std_logic;
      v6_trn_td                                    : in std_logic_vector(63 downto 0);
      v6_trn_trem_n                                : in std_logic;
      v6_trn_tsof_n                                : in std_logic;
      v6_trn_teof_n                                : in std_logic;
      v6_trn_tsrc_rdy_n                            : in std_logic;
      v6_trn_tsrc_dsc_n                            : in std_logic;
      v6_trn_terrfwd_n                             : in std_logic;
      v6_trn_tcfg_gnt_n                            : in std_logic;
      v6_trn_tstr_n                                : in std_logic;
      v6_trn_rd                                    : out std_logic_vector(63 downto 0);
      v6_trn_rrem_n                                : out std_logic;
      v6_trn_rsof_n                                : out std_logic;
      v6_trn_reof_n                                : out std_logic;
      v6_trn_rsrc_rdy_n                            : out std_logic;
      v6_trn_rsrc_dsc_n                            : out std_logic;
      v6_trn_rerrfwd_n                             : out std_logic;
      v6_trn_rbar_hit_n                            : out std_logic_vector(6 downto 0);
      v6_trn_rdst_rdy_n                            : in std_logic;
      v6_trn_rnp_ok_n                              : in std_logic;
      v6_trn_fc_cpld                               : out std_logic_vector(11 downto 0);
      v6_trn_fc_cplh                               : out std_logic_vector(7 downto 0);
      v6_trn_fc_npd                                : out std_logic_vector(11 downto 0);
      v6_trn_fc_nph                                : out std_logic_vector(7 downto 0);
      v6_trn_fc_pd                                 : out std_logic_vector(11 downto 0);
      v6_trn_fc_ph                                 : out std_logic_vector(7 downto 0);
      v6_trn_fc_sel                                : in std_logic_vector(2 downto 0);
      v6_cfg_do                                    : out std_logic_vector(31 downto 0);
      v6_cfg_rd_wr_done_n                          : out std_logic;
      v6_cfg_di                                    : in std_logic_vector(31 downto 0);
      v6_cfg_byte_en_n                             : in std_logic_vector(3 downto 0);
      v6_cfg_dwaddr                                : in std_logic_vector(9 downto 0);
      v6_cfg_wr_en_n                               : in std_logic;
      v6_cfg_rd_en_n                               : in std_logic;
      v6_cfg_err_cor_n                             : in std_logic;
      v6_cfg_err_ur_n                              : in std_logic;
      v6_cfg_err_ecrc_n                            : in std_logic;
      v6_cfg_err_cpl_timeout_n                     : in std_logic;
      v6_cfg_err_cpl_abort_n                       : in std_logic;
      v6_cfg_err_cpl_unexpect_n                    : in std_logic;
      v6_cfg_err_posted_n                          : in std_logic;
      v6_cfg_err_locked_n                          : in std_logic;
      v6_cfg_err_tlp_cpl_header                    : in std_logic_vector(47 downto 0);
      v6_cfg_err_cpl_rdy_n                         : out std_logic;
      v6_cfg_interrupt_n                           : in std_logic;
      v6_cfg_interrupt_rdy_n                       : out std_logic;
      v6_cfg_interrupt_assert_n                    : in std_logic;
      v6_cfg_interrupt_di                          : in std_logic_vector(7 downto 0);
      v6_cfg_interrupt_do                          : out std_logic_vector(7 downto 0);
      v6_cfg_interrupt_mmenable                    : out std_logic_vector(2 downto 0);
      v6_cfg_interrupt_msienable                   : out std_logic;
      v6_cfg_interrupt_msixenable                  : out std_logic;
      v6_cfg_interrupt_msixfm                      : out std_logic;
      v6_cfg_turnoff_ok_n                          : in std_logic;
      v6_cfg_to_turnoff_n                          : out std_logic;
      v6_cfg_trn_pending_n                         : in std_logic;
      v6_cfg_pm_wake_n                             : in std_logic;
      v6_cfg_bus_number                            : out std_logic_vector(7 downto 0);
      v6_cfg_device_number                         : out std_logic_vector(4 downto 0);
      v6_cfg_function_number                       : out std_logic_vector(2 downto 0);
      v6_cfg_status                                : out std_logic_vector(15 downto 0);
      v6_cfg_command                               : out std_logic_vector(15 downto 0);
      v6_cfg_dstatus                               : out std_logic_vector(15 downto 0);
      v6_cfg_dcommand                              : out std_logic_vector(15 downto 0);
      v6_cfg_lstatus                               : out std_logic_vector(15 downto 0);
      v6_cfg_lcommand                              : out std_logic_vector(15 downto 0);
      v6_cfg_dcommand2                             : out std_logic_vector(15 downto 0);
      v6_cfg_pcie_link_state_n                     : out std_logic_vector(2 downto 0);
      v6_cfg_dsn                                   : in std_logic_vector(63 downto 0);
      v6_cfg_pmcsr_pme_en                          : out std_logic;
      v6_cfg_pmcsr_pme_status                      : out std_logic;
      v6_cfg_pmcsr_powerstate                      : out std_logic_vector(1 downto 0);
      
	  v6_pl_initial_link_width                     : out std_logic_vector(2 downto 0);
      v6_pl_lane_reversal_mode                     : out std_logic_vector(1 downto 0);
      v6_pl_link_gen2_capable                      : out std_logic;
      v6_pl_link_partner_gen2_supported            : out std_logic;
      v6_pl_link_upcfg_capable                     : out std_logic;
      v6_pl_ltssm_state                            : out std_logic_vector(5 downto 0);
      v6_pl_received_hot_rst                       : out std_logic;
      v6_pl_sel_link_rate                          : out std_logic;
      v6_pl_sel_link_width                         : out std_logic_vector(1 downto 0);
      v6_pl_directed_link_auton                    : in std_logic;
      v6_pl_directed_link_change                   : in std_logic_vector(1 downto 0);
      v6_pl_directed_link_speed                    : in std_logic;
      v6_pl_directed_link_width                    : in std_logic_vector(1 downto 0);
      v6_pl_upstream_prefer_deemph                 : in std_logic;
      v6_sys_clk                                   : in std_logic;
      v6_sys_reset_n                               : in std_logic;
  
  
  
    ---------------------------------------------------------------------------------------------------------------------
	-------------------------- V7 ---------------------------------------------------------------------------------------
  
	 -------------------------------------------------------------------------------------------------------------------
     -- 2. Clocking Interface                                                                                         --
     -------------------------------------------------------------------------------------------------------------------
      v7_PIPE_PCLK_IN                               : out std_logic;
      v7_PIPE_RXUSRCLK_IN                           : out std_logic;
      v7_PIPE_RXOUTCLK_IN                           : out std_logic_vector(3 downto 0);
      v7_PIPE_DCLK_IN                               : out std_logic;
      v7_PIPE_USERCLK1_IN                           : out std_logic;
      v7_PIPE_USERCLK2_IN                           : out std_logic;
      v7_PIPE_OOBCLK_IN                             : out std_logic;
      v7_PIPE_MMCM_LOCK_IN                          : out std_logic;

	  v7_PIPE_MMCM_RST_N							: in std_logic;
      v7_PIPE_TXOUTCLK_OUT                          : in std_logic;
      v7_PIPE_RXOUTCLK_OUT                          : in std_logic_vector(3 downto 0);
      v7_PIPE_PCLK_SEL_OUT                          : in std_logic_vector(3 downto 0);
      v7_PIPE_GEN3_OUT                              : in std_logic;

     -------------------------------------------------------------------------------------------------------------------
     -- 3. AXI-S Interface                                                                                            --
     -------------------------------------------------------------------------------------------------------------------
      -- Common
      v7_user_clk_out                               : in std_logic;
      v7_user_reset_out                             : in std_logic;
      v7_user_lnk_up                                : in std_logic;

      -- TX
      v7_tx_buf_av                                  : in std_logic_vector(5 downto 0);
      v7_tx_cfg_req                                 : in std_logic;
      v7_tx_err_drop                                : in std_logic;
      v7_s_axis_tx_tready                           : in std_logic;
      v7_s_axis_tx_tdata                            : out std_logic_vector((C_DATA_WIDTH - 1) downto 0);
      v7_s_axis_tx_tkeep                            : out std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
      v7_s_axis_tx_tlast                            : out std_logic;
      v7_s_axis_tx_tvalid                           : out std_logic;
      v7_s_axis_tx_tuser                            : out std_logic_vector(3 downto 0);
      v7_tx_cfg_gnt                                 : out std_logic;

      -- RX
      v7_m_axis_rx_tdata                            : in std_logic_vector((C_DATA_WIDTH - 1) downto 0);
      v7_m_axis_rx_tkeep                            : in std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
      v7_m_axis_rx_tlast                            : in std_logic;
      v7_m_axis_rx_tvalid                           : in std_logic;
      v7_m_axis_rx_tready                           : out std_logic;
      v7_m_axis_rx_tuser                            : in std_logic_vector(21 downto 0);
      v7_rx_np_ok                                   : out std_logic;
      v7_rx_np_req                                  : out std_logic;

      -- Flow Control
      v7_fc_cpld                                    : in std_logic_vector(11 downto 0);
      v7_fc_cplh                                    : in std_logic_vector(7 downto 0);
      v7_fc_npd                                     : in std_logic_vector(11 downto 0);
      v7_fc_nph                                     : in std_logic_vector(7 downto 0);
      v7_fc_pd                                      : in std_logic_vector(11 downto 0);
      v7_fc_ph                                      : in std_logic_vector(7 downto 0);
      v7_fc_sel                                     : out std_logic_vector(2 downto 0);

     -------------------------------------------------------------------------------------------------------------------
     -- 4. Configuration (CFG) Interface                                                                              --
     -------------------------------------------------------------------------------------------------------------------
     ---------------------------------------------------------------------
      -- EP and RP                                                      --
     ---------------------------------------------------------------------
      v7_cfg_mgmt_do                                : in std_logic_vector (31 downto 0);
      v7_cfg_mgmt_rd_wr_done                        : in std_logic;

      v7_cfg_status                                 : in std_logic_vector(15 downto 0);
      v7_cfg_command                                : in std_logic_vector(15 downto 0);
      v7_cfg_dstatus                                : in std_logic_vector(15 downto 0);
      v7_cfg_dcommand                               : in std_logic_vector(15 downto 0);
      v7_cfg_lstatus                                : in std_logic_vector(15 downto 0);
      v7_cfg_lcommand                               : in std_logic_vector(15 downto 0);
      v7_cfg_dcommand2                              : in std_logic_vector(15 downto 0);
      v7_cfg_pcie_link_state                        : in std_logic_vector(2 downto 0);

      v7_cfg_pmcsr_pme_en                           : in std_logic;
      v7_cfg_pmcsr_powerstate                       : in std_logic_vector(1 downto 0);
      v7_cfg_pmcsr_pme_status                       : in std_logic;
      
      -- Management Interface
      v7_cfg_mgmt_di                                : out std_logic_vector (31 downto 0);
      v7_cfg_mgmt_byte_en                           : out std_logic_vector (3 downto 0);
      v7_cfg_mgmt_dwaddr                            : out std_logic_vector (9 downto 0);
      v7_cfg_mgmt_wr_en                             : out std_logic;
      v7_cfg_mgmt_rd_en                             : out std_logic;
      v7_cfg_mgmt_wr_readonly                       : out std_logic;

      -- Error Reporting Interface
      v7_cfg_err_ecrc                               : out std_logic;
      v7_cfg_err_ur                                 : out std_logic;
      v7_cfg_err_cpl_timeout                        : out std_logic;
      v7_cfg_err_cpl_unexpect                       : out std_logic;
      v7_cfg_err_cpl_abort                          : out std_logic;
      v7_cfg_err_posted                             : out std_logic;
      v7_cfg_err_cor                                : out std_logic;
      v7_cfg_err_atomic_egress_blocked              : out std_logic;
      v7_cfg_err_internal_cor                       : out std_logic;
      v7_cfg_err_malformed                          : out std_logic;
      v7_cfg_err_mc_blocked                         : out std_logic;
      v7_cfg_err_poisoned                           : out std_logic;
      v7_cfg_err_norecovery                         : out std_logic;
      v7_cfg_err_tlp_cpl_header                     : out std_logic_vector(47 downto 0);
      v7_cfg_err_cpl_rdy                            : in std_logic;
      v7_cfg_err_locked                             : out std_logic;
      v7_cfg_err_acs                                : out std_logic;
      v7_cfg_err_internal_uncor                     : out std_logic;
      v7_cfg_trn_pending                            : out std_logic;
      v7_cfg_pm_halt_aspm_l0s                       : out std_logic;
      v7_cfg_pm_halt_aspm_l1                        : out std_logic;
      v7_cfg_pm_force_state_en                      : out std_logic;
      v7_cfg_pm_force_state                         : out std_logic_vector(1 downto 0);
      v7_cfg_dsn                                    : out std_logic_vector(63 downto 0);

     ---------------------------------------------------------------------
      -- EP Only                                                        --
     ---------------------------------------------------------------------
      v7_cfg_interrupt                              : out std_logic;
      v7_cfg_interrupt_rdy                          : in std_logic;
      v7_cfg_interrupt_assert                       : out std_logic;
      v7_cfg_interrupt_di                           : out std_logic_vector(7 downto 0);
      v7_cfg_interrupt_do                           : in std_logic_vector(7 downto 0);
      v7_cfg_interrupt_mmenable                     : in std_logic_vector(2 downto 0);
      v7_cfg_interrupt_msienable                    : in std_logic;
      v7_cfg_interrupt_msixenable                   : in std_logic;
      v7_cfg_interrupt_msixfm                       : in std_logic;
      v7_cfg_interrupt_stat                         : out std_logic;
      v7_cfg_pciecap_interrupt_msgnum               : out std_logic_vector(4 downto 0);
      v7_cfg_to_turnoff                             : in std_logic;
      v7_cfg_turnoff_ok                             : out std_logic;
      v7_cfg_bus_number                             : in std_logic_vector(7 downto 0);
      v7_cfg_device_number                          : in std_logic_vector(4 downto 0);
      v7_cfg_function_number                        : in std_logic_vector(2 downto 0);
      v7_cfg_pm_wake                                : out std_logic;

     ---------------------------------------------------------------------
      -- RP Only                                                        --
     ---------------------------------------------------------------------
      v7_cfg_pm_send_pme_to                         : out std_logic;
      v7_cfg_ds_bus_number                          : out std_logic_vector(7 downto 0);
      v7_cfg_ds_device_number                       : out std_logic_vector(4 downto 0);
      v7_cfg_ds_function_number                     : out std_logic_vector(2 downto 0);

      v7_cfg_mgmt_wr_rw1c_as_rw                     : out std_logic;

     -------------------------------------------------------------------------------------------------------------------
     -- 5. Physical Layer Control and Status (PL) Interface                                                           --
     -------------------------------------------------------------------------------------------------------------------
      v7_pl_directed_link_change                    : out std_logic_vector(1 downto 0);
      v7_pl_directed_link_width                     : out std_logic_vector(1 downto 0);
      v7_pl_directed_link_speed                     : out std_logic;
      v7_pl_directed_link_auton                     : out std_logic;
      v7_pl_upstream_prefer_deemph                  : out std_logic;

      v7_pl_sel_lnk_rate                            : in std_logic;
      v7_pl_sel_lnk_width                           : in std_logic_vector(1 downto 0);
      v7_pl_ltssm_state                             : in std_logic_vector(5 downto 0);
      v7_pl_lane_reversal_mode                      : in std_logic_vector(1 downto 0);

      
      v7_pl_link_upcfg_cap                          : in std_logic;
      v7_pl_link_gen2_cap                           : in std_logic;
      v7_pl_link_partner_gen2_supported             : in std_logic;
      v7_pl_initial_link_width                      : in std_logic_vector(2 downto 0);

      
	  
     ---------------------------------------------------------------------
      -- EP Only                                                        --
     ---------------------------------------------------------------------
      v7_pl_received_hot_rst                        : in std_logic;
     ---------------------------------------------------------------------
      -- RP Only                                                        --
     ---------------------------------------------------------------------
      v7_pl_transmit_hot_rst                        : out std_logic;
      v7_pl_downstream_deemph_source                : out std_logic;
     -------------------------------------------------------------------------------------------------------------------
     -- 6. AER interface                                                                                              --
     -------------------------------------------------------------------------------------------------------------------
      v7_cfg_err_aer_headerlog                      : out std_logic_vector(127 downto 0);
      v7_cfg_aer_interrupt_msgnum                   : out std_logic_vector(4 downto 0);
      v7_cfg_err_aer_headerlog_set                  : in std_logic;
      v7_cfg_aer_ecrc_check_en                      : in std_logic;
      v7_cfg_aer_ecrc_gen_en                        : in std_logic;
     -------------------------------------------------------------------------------------------------------------------
     -- 7. VC interface                                                                                               --
     -------------------------------------------------------------------------------------------------------------------
      
     -------------------------------------------------------------------------------------------------------------------
     -- 8. System(SYS) Interface                                                                                      --
     -------------------------------------------------------------------------------------------------------------------
      v7_sys_clk                                    : out std_logic;
      v7_sys_reset                                  : out std_logic
	 	 
 );
 end component; 
	

  -- Tx
  signal trn_tbuf_av : std_logic_vector(5 downto 0);
  signal trn_tcfg_req_n : std_logic;
  signal trn_terr_drop_n : std_logic;
  signal trn_tdst_rdy_n : std_logic;
  signal trn_td : std_logic_vector(63 downto 0);
  signal trn_trem_n : std_logic;
  signal trn_tsof_n : std_logic;
  signal trn_teof_n : std_logic;
  signal trn_tsrc_rdy_n : std_logic;
  signal trn_tsrc_dsc_n : std_logic;
  signal trn_terrfwd_n : std_logic;
  signal trn_tcfg_gnt_n : std_logic;
  signal trn_tstr_n : std_logic;

  -- Rx
  signal trn_rd : std_logic_vector(63 downto 0);
  signal trn_rrem_n : std_logic;
  signal trn_rsof_n : std_logic;
  signal trn_reof_n : std_logic;
  signal trn_rsrc_rdy_n : std_logic;
  signal trn_rsrc_dsc_n : std_logic;
  signal trn_rerrfwd_n : std_logic;
  signal trn_rbar_hit_n : std_logic_vector(6 downto 0);
  signal trn_rdst_rdy_n : std_logic;
  signal trn_rnp_ok_n : std_logic;

  -- Flow Control
  signal trn_fc_cpld : std_logic_vector(11 downto 0);
  signal trn_fc_cplh : std_logic_vector(7 downto 0);
  signal trn_fc_npd : std_logic_vector(11 downto 0);
  signal trn_fc_nph : std_logic_vector(7 downto 0);
  signal trn_fc_pd : std_logic_vector(11 downto 0);
  signal trn_fc_ph : std_logic_vector(7 downto 0);
  signal trn_fc_sel : std_logic_vector(2 downto 0);

  signal trn_lnk_up_n : std_logic;
  signal trn_lnk_up_n_int1 : std_logic;
  signal trn_clk : std_logic;
  signal trn_reset_n : std_logic;
  signal trn_reset_n_int1 : std_logic;

  ---------------------------------------------------------
  -- 3. Configuration (CFG) Interface
  ---------------------------------------------------------

  signal cfg_do : std_logic_vector(31 downto 0);
  signal cfg_rd_wr_done_n : std_logic;
  signal cfg_di : std_logic_vector(31 downto 0);
  signal cfg_byte_en_n : std_logic_vector(3 downto 0);
  signal cfg_dwaddr : std_logic_vector(9 downto 0);
  signal cfg_wr_en_n : std_logic;
  signal cfg_rd_en_n : std_logic;

  signal cfg_err_cor_n: std_logic;
  signal cfg_err_ur_n : std_logic;
  signal cfg_err_ecrc_n : std_logic;
  signal cfg_err_cpl_timeout_n : std_logic;
  signal cfg_err_cpl_abort_n : std_logic;
  signal cfg_err_cpl_unexpect_n : std_logic;
  signal cfg_err_posted_n : std_logic;
  signal cfg_err_locked_n : std_logic;
  signal cfg_err_tlp_cpl_header : std_logic_vector(47 downto 0);
  signal cfg_err_cpl_rdy_n : std_logic;
  signal cfg_interrupt_n : std_logic;
  signal cfg_interrupt_rdy_n : std_logic;
  signal cfg_interrupt_assert_n : std_logic;
  signal cfg_interrupt_di : std_logic_vector(7 downto 0);
  signal cfg_interrupt_do : std_logic_vector(7 downto 0);
  signal cfg_interrupt_mmenable : std_logic_vector(2 downto 0);
  signal cfg_interrupt_msienable : std_logic;
  signal cfg_interrupt_msixenable : std_logic;
  signal cfg_interrupt_msixfm : std_logic;
  signal cfg_turnoff_ok_n : std_logic;
  signal cfg_to_turnoff_n : std_logic;
  signal cfg_trn_pending_n : std_logic;
  signal cfg_pm_wake_n : std_logic;
  signal cfg_bus_number : std_logic_vector(7 downto 0);
  signal cfg_device_number : std_logic_vector(4 downto 0);
  signal cfg_function_number : std_logic_vector(2 downto 0);
  signal cfg_status : std_logic_vector(15 downto 0);
  signal cfg_command : std_logic_vector(15 downto 0);
  signal cfg_dstatus : std_logic_vector(15 downto 0);
  signal cfg_dcommand : std_logic_vector(15 downto 0);
  signal cfg_lstatus : std_logic_vector(15 downto 0);
  signal cfg_lcommand : std_logic_vector(15 downto 0);
  signal cfg_dcommand2 : std_logic_vector(15 downto 0);
  signal cfg_pcie_link_state_n : std_logic_vector(2 downto 0);
  signal cfg_dsn : std_logic_vector(63 downto 0);

  ---------------------------------------------------------
  -- 4. Physical Layer Control and Status (PL) Interface
  ---------------------------------------------------------

  signal pl_initial_link_width : std_logic_vector(2 downto 0);
  signal pl_lane_reversal_mode : std_logic_vector(1 downto 0);
  signal pl_link_gen2_capable : std_logic;
  signal pl_link_partner_gen2_supported : std_logic;
  signal pl_link_upcfg_capable : std_logic;
  signal pl_ltssm_state : std_logic_vector(5 downto 0);
  signal pl_received_hot_rst : std_logic;
  signal pl_sel_link_rate : std_logic;
  signal pl_sel_link_width : std_logic_vector(1 downto 0);
  signal pl_directed_link_auton : std_logic;
  signal pl_directed_link_change : std_logic_vector(1 downto 0);
  signal pl_directed_link_speed : std_logic;
  signal pl_directed_link_width : std_logic_vector(1 downto 0);
  signal pl_upstream_prefer_deemph : std_logic;

  
signal debug_int : std_logic_vector(7 downto 0);
-------------------------------------------------------

signal clk_div : std_logic;
signal trn_clk_div : std_logic;
signal sys_clk_c_o : std_logic;
signal sys_clk_div : std_logic;
signal trn_reset : std_logic;
signal trn_reset_int : std_logic;
signal clk : std_logic;


-- this is the DDR3 controller interface
signal phy_init_done : std_logic;
signal ui_clk_sync_rst : std_logic;
signal ui_clk : std_logic;
    
signal app_wdf_wren  : std_logic;
signal app_wdf_data  : std_logic_vector(255 downto 0);
signal app_wdf_mask : std_logic_vector(31 downto 0);
signal app_wdf_end  : std_logic;
signal app_addr     : std_logic_vector(26 downto 0);
signal app_addr_int : std_logic_vector(27 downto 0);
signal app_cmd      : std_logic_vector(2 downto 0);
signal app_en       : std_logic;
signal app_rd_data_valid : std_logic;
signal app_rdy      : std_logic;
signal app_wdf_rdy  : std_logic;
signal app_rd_data  : std_logic_vector(255 downto 0);
signal app_rd_data_end : std_logic;


-------------------------------------------------------------------------------------------------------------------
     -- 2. Clocking Interface                                                                                         --
     -------------------------------------------------------------------------------------------------------------------
signal v7_PIPE_PCLK_IN                               : std_logic;
signal v7_PIPE_RXUSRCLK_IN                           : std_logic;
signal v7_PIPE_RXOUTCLK_IN                           : std_logic_vector(3 downto 0);
signal v7_PIPE_DCLK_IN                               : std_logic;
signal v7_PIPE_USERCLK1_IN                           : std_logic;
signal v7_PIPE_USERCLK2_IN                           : std_logic;
signal v7_PIPE_OOBCLK_IN                             : std_logic;
signal v7_PIPE_MMCM_LOCK_IN                          : std_logic;

signal v7_PIPE_MMCM_RST_N 							 : std_logic:= '1';
signal v7_PIPE_TXOUTCLK_OUT                          : std_logic;
signal v7_PIPE_RXOUTCLK_OUT                          : std_logic_vector(3 downto 0);
signal v7_PIPE_PCLK_SEL_OUT                          : std_logic_vector(3 downto 0);
signal v7_PIPE_GEN3_OUT                              : std_logic;

     -------------------------------------------------------------------------------------------------------------------
     -- 3. AXI-S Interface                                                                                            --
     -------------------------------------------------------------------------------------------------------------------
      -- Common
signal v7_user_clk_out                               : std_logic;
signal v7_user_reset_out                             : std_logic;
signal v7_user_lnk_up                                : std_logic;

      -- TX
signal v7_tx_buf_av                                  : std_logic_vector(5 downto 0);
signal v7_tx_cfg_req                                 : std_logic;
signal v7_tx_err_drop                                : std_logic;
signal v7_s_axis_tx_tready                           : std_logic;
signal v7_s_axis_tx_tdata                            : std_logic_vector((C_DATA_WIDTH - 1) downto 0);
signal v7_s_axis_tx_tkeep                            : std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
signal v7_s_axis_tx_tlast                            : std_logic;
signal v7_s_axis_tx_tvalid                           : std_logic;
signal v7_s_axis_tx_tuser                            : std_logic_vector(3 downto 0);
signal v7_tx_cfg_gnt                                 : std_logic;

      -- RX
signal v7_m_axis_rx_tdata                            : std_logic_vector((C_DATA_WIDTH - 1) downto 0);
signal v7_m_axis_rx_tkeep                            : std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
signal v7_m_axis_rx_tlast                            : std_logic;
signal v7_m_axis_rx_tvalid                           : std_logic;
signal v7_m_axis_rx_tready                           : std_logic;
signal v7_m_axis_rx_tuser                            : std_logic_vector(21 downto 0);
signal v7_rx_np_ok                                   : std_logic;
signal v7_rx_np_req                                  : std_logic;

      -- Flow Control
signal v7_fc_cpld                                    : std_logic_vector(11 downto 0);
signal v7_fc_cplh                                    : std_logic_vector(7 downto 0);
signal v7_fc_npd                                     : std_logic_vector(11 downto 0);
signal v7_fc_nph                                     : std_logic_vector(7 downto 0);
signal v7_fc_pd                                      : std_logic_vector(11 downto 0);
signal v7_fc_ph                                      : std_logic_vector(7 downto 0);
signal v7_fc_sel                                     : std_logic_vector(2 downto 0);

     -------------------------------------------------------------------------------------------------------------------
     -- 4. Configuration (CFG) Interface                                                                              --
     -------------------------------------------------------------------------------------------------------------------
     ---------------------------------------------------------------------
      -- EP and RP                                                      --
     ---------------------------------------------------------------------
signal v7_cfg_mgmt_do                                : std_logic_vector (31 downto 0);
signal v7_cfg_mgmt_rd_wr_done                        : std_logic;
                                                       
signal v7_cfg_status                                 : std_logic_vector(15 downto 0);
signal v7_cfg_command                                : std_logic_vector(15 downto 0);
signal v7_cfg_dstatus                                : std_logic_vector(15 downto 0);
signal v7_cfg_dcommand                               : std_logic_vector(15 downto 0);
signal v7_cfg_lstatus                                : std_logic_vector(15 downto 0);
signal v7_cfg_lcommand                               : std_logic_vector(15 downto 0);
signal v7_cfg_dcommand2                              : std_logic_vector(15 downto 0);
signal v7_cfg_pcie_link_state                        : std_logic_vector(2 downto 0);
                                                       
signal v7_cfg_pmcsr_pme_en                           : std_logic;
signal v7_cfg_pmcsr_powerstate                       : std_logic_vector(1 downto 0);
signal v7_cfg_pmcsr_pme_status                       : std_logic;
      
      -- Management Interface
signal v7_cfg_mgmt_di                                :  std_logic_vector (31 downto 0);
signal v7_cfg_mgmt_byte_en                           :  std_logic_vector (3 downto 0);
signal v7_cfg_mgmt_dwaddr                            :  std_logic_vector (9 downto 0);
signal v7_cfg_mgmt_wr_en                             :  std_logic;
signal v7_cfg_mgmt_rd_en                             :  std_logic;
signal v7_cfg_mgmt_wr_readonly                       :  std_logic;

      -- Error Reporting Interface
signal v7_cfg_err_ecrc                               :  std_logic;
signal v7_cfg_err_ur                                 :  std_logic;
signal v7_cfg_err_cpl_timeout                        :  std_logic;
signal v7_cfg_err_cpl_unexpect                       :  std_logic;
signal v7_cfg_err_cpl_abort                          :  std_logic;
signal v7_cfg_err_posted                             :  std_logic;
signal v7_cfg_err_cor                                :  std_logic;
signal v7_cfg_err_atomic_egress_blocked              :  std_logic;
signal v7_cfg_err_internal_cor                       :  std_logic;
signal v7_cfg_err_malformed                          :  std_logic;
signal v7_cfg_err_mc_blocked                         :  std_logic;
signal v7_cfg_err_poisoned                           :  std_logic;
signal v7_cfg_err_norecovery                         :  std_logic;
signal v7_cfg_err_tlp_cpl_header                     :  std_logic_vector(47 downto 0);
signal v7_cfg_err_cpl_rdy                            : std_logic;
signal v7_cfg_err_locked                             :  std_logic;
signal v7_cfg_err_acs                                :  std_logic;
signal v7_cfg_err_internal_uncor                     :  std_logic;
signal v7_cfg_trn_pending                            :  std_logic;
signal v7_cfg_pm_halt_aspm_l0s                       :  std_logic;
signal v7_cfg_pm_halt_aspm_l1                        :  std_logic;
signal v7_cfg_pm_force_state_en                      :  std_logic;
signal v7_cfg_pm_force_state                         :  std_logic_vector(1 downto 0);
signal v7_cfg_dsn                                    :  std_logic_vector(63 downto 0);

     ---------------------------------------------------------------------
      -- EP Only                                                        --
     ---------------------------------------------------------------------
signal v7_cfg_interrupt                              :  std_logic;
signal v7_cfg_interrupt_rdy                          : std_logic;
signal v7_cfg_interrupt_assert                       :  std_logic;
signal v7_cfg_interrupt_di                           :  std_logic_vector(7 downto 0);
signal v7_cfg_interrupt_do                           : std_logic_vector(7 downto 0);
signal v7_cfg_interrupt_mmenable                     : std_logic_vector(2 downto 0);
signal v7_cfg_interrupt_msienable                    : std_logic;
signal v7_cfg_interrupt_msixenable                   : std_logic;
signal v7_cfg_interrupt_msixfm                       : std_logic;
signal v7_cfg_interrupt_stat                         :  std_logic;
signal v7_cfg_pciecap_interrupt_msgnum               :  std_logic_vector(4 downto 0);
signal v7_cfg_to_turnoff                             : std_logic;
signal v7_cfg_turnoff_ok                             :  std_logic;
signal v7_cfg_bus_number                             : std_logic_vector(7 downto 0);
signal v7_cfg_device_number                          : std_logic_vector(4 downto 0);
signal v7_cfg_function_number                        : std_logic_vector(2 downto 0);
signal v7_cfg_pm_wake                                :  std_logic;

     ---------------------------------------------------------------------
      -- RP Only                                                        --
     ---------------------------------------------------------------------
signal v7_cfg_pm_send_pme_to                         : std_logic;
signal v7_cfg_ds_bus_number                          : std_logic_vector(7 downto 0);
signal v7_cfg_ds_device_number                       : std_logic_vector(4 downto 0);
signal v7_cfg_ds_function_number                     : std_logic_vector(2 downto 0);

signal v7_cfg_mgmt_wr_rw1c_as_rw                     : std_logic;
      
      

     -------------------------------------------------------------------------------------------------------------------
     -- 5. Physical Layer Control and Status (PL) Interface                                                           --
     -------------------------------------------------------------------------------------------------------------------
signal v7_pl_directed_link_change                    : std_logic_vector(1 downto 0);
signal v7_pl_directed_link_width                     : std_logic_vector(1 downto 0);
signal v7_pl_directed_link_speed                     : std_logic;
signal v7_pl_directed_link_auton                     : std_logic;
signal v7_pl_upstream_prefer_deemph                  : std_logic;

signal v7_pl_sel_lnk_rate                            : std_logic;
signal v7_pl_sel_lnk_width                           : std_logic_vector(1 downto 0);
signal v7_pl_ltssm_state                             : std_logic_vector(5 downto 0);
signal v7_pl_lane_reversal_mode                      : std_logic_vector(1 downto 0);

      
signal v7_pl_link_upcfg_cap                          : std_logic;
signal v7_pl_link_gen2_cap                           : std_logic;
signal v7_pl_link_partner_gen2_supported             : std_logic;
signal v7_pl_initial_link_width                      : std_logic_vector(2 downto 0);

      
     ---------------------------------------------------------------------
      -- EP Only                                                        --
     ---------------------------------------------------------------------
 signal     v7_pl_received_hot_rst                        : std_logic;
     -----------------------------------------------------------------
      -- RP Only                                                    --
     -----------------------------------------------------------------
 signal     v7_pl_transmit_hot_rst                        : std_logic;
  signal    v7_pl_downstream_deemph_source                : std_logic;
     -------------------------------------------------------------------------------------------------------------------
     -- 6. AER interface                                                                                              --
     -------------------------------------------------------------------------------------------------------------------
 signal     v7_cfg_err_aer_headerlog                      : std_logic_vector(127 downto 0);
 signal     v7_cfg_aer_interrupt_msgnum                   : std_logic_vector(4 downto 0);
 signal     v7_cfg_err_aer_headerlog_set                  : std_logic;
 signal     v7_cfg_aer_ecrc_check_en                      : std_logic;
 signal     v7_cfg_aer_ecrc_gen_en                        : std_logic;
     -------------------------------------------------------------------------------------------------------------------
     -- 7. VC interface                                                                                               --
     -------------------------------------------------------------------------------------------------------------------
      
     -------------------------------------------------------------------------------------------------------------------
     -- 8. System(SYS) Interface                                                                                      --
     -------------------------------------------------------------------------------------------------------------------
signal      v7_sys_clk                                    : std_logic;
signal      v7_sys_reset                                  : std_logic;

--signal dma_waddr_en : std_logic;
--signal dma_waddr : std_logic_vector(31 downto 0);
--signal dma_wdata_en : std_logic;
--signal dma_wdata : std_logic_vector(63 downto 0);
--signal dma_wdata_rdy : std_logic;
--
--signal dma_rdata_en : std_logic;
--signal dma_rdata : std_logic_vector(63 downto 0);
--signal dma_raddr_en : std_logic;
--signal dma_raddr : std_logic_vector(31 downto 0);
--signal dma_rdata_rdy : std_logic;
--signal dma_rdata_busy : std_logic;

signal dma_reset_int : std_logic;
signal v7_sys_reset_n : std_logic;
  
begin


-- PIO instance
  
xv7_pcie_conv : v7_pcie_conv generic map(
	C_DATA_WIDTH				  => C_DATA_WIDTH,
	PL_FAST_TRAIN                 => PL_FAST_TRAIN,
	PCIE_EXT_CLK                  =>  PCIE_EXT_CLK -- Use External Clocking Module
	)
	port map (
	  --------------------------------------------------------------------------------------
	  v6_trn_clk                                   => trn_clk,
      v6_trn_reset_n                               => trn_reset_n_int1, 
      v6_trn_lnk_up_n                              => trn_lnk_up_n_int1,
      v6_trn_tbuf_av                               => trn_tbuf_av,
      v6_trn_tcfg_req_n                            => trn_tcfg_req_n,
      v6_trn_terr_drop_n                           => trn_terr_drop_n,
      v6_trn_tdst_rdy_n                            => trn_tdst_rdy_n,
      v6_trn_td                                    => trn_td, 
      v6_trn_trem_n                                => trn_trem_n,
      v6_trn_tsof_n                                => trn_tsof_n,
      v6_trn_teof_n                                => trn_teof_n,
      v6_trn_tsrc_rdy_n                            => trn_tsrc_rdy_n,
      v6_trn_tsrc_dsc_n                            => trn_tsrc_dsc_n,
      v6_trn_terrfwd_n                             => trn_terrfwd_n,
      v6_trn_tcfg_gnt_n                            => trn_tcfg_gnt_n,
      v6_trn_tstr_n                                => trn_tstr_n,
      v6_trn_rd                                    => trn_rd,
      v6_trn_rrem_n                                => trn_rrem_n,
      v6_trn_rsof_n                                => trn_rsof_n,
      v6_trn_reof_n                                => trn_reof_n,
      v6_trn_rsrc_rdy_n                            => trn_rsrc_rdy_n,
      v6_trn_rsrc_dsc_n                            => trn_rsrc_dsc_n,
      v6_trn_rerrfwd_n                             => trn_rerrfwd_n,
      v6_trn_rbar_hit_n                            => trn_rbar_hit_n,
      v6_trn_rdst_rdy_n                            => trn_rdst_rdy_n,
      v6_trn_rnp_ok_n                              => trn_rnp_ok_n,
      v6_trn_fc_cpld                               => trn_fc_cpld,
      v6_trn_fc_cplh                               => trn_fc_cplh,
      v6_trn_fc_npd                                => trn_fc_npd,
      v6_trn_fc_nph                                => trn_fc_nph,
      v6_trn_fc_pd                                 => trn_fc_pd,
      v6_trn_fc_ph                                 => trn_fc_ph,
      v6_trn_fc_sel                                => trn_fc_sel,
      v6_cfg_do                                    => cfg_do,
      v6_cfg_rd_wr_done_n                          => cfg_rd_wr_done_n,
      v6_cfg_di                                    => cfg_di,
      v6_cfg_byte_en_n                             => cfg_byte_en_n,
      v6_cfg_dwaddr                                => cfg_dwaddr,
      v6_cfg_wr_en_n                               => cfg_wr_en_n,
      v6_cfg_rd_en_n                               => cfg_rd_en_n,
      v6_cfg_err_cor_n                             => cfg_err_cor_n,
      v6_cfg_err_ur_n                              => cfg_err_ur_n,
      v6_cfg_err_ecrc_n                            => cfg_err_ecrc_n,
      v6_cfg_err_cpl_timeout_n                     => cfg_err_cpl_timeout_n,
      v6_cfg_err_cpl_abort_n                       => cfg_err_cpl_abort_n,
      v6_cfg_err_cpl_unexpect_n                    => cfg_err_cpl_unexpect_n,
      v6_cfg_err_posted_n                          => cfg_err_posted_n,
      v6_cfg_err_locked_n                          => cfg_err_locked_n,
      v6_cfg_err_tlp_cpl_header                    => cfg_err_tlp_cpl_header,
      v6_cfg_err_cpl_rdy_n                         => cfg_err_cpl_rdy_n,
      v6_cfg_interrupt_n                           => cfg_interrupt_n,
      v6_cfg_interrupt_rdy_n                       => cfg_interrupt_rdy_n,
      v6_cfg_interrupt_assert_n                    => cfg_interrupt_assert_n,
      v6_cfg_interrupt_di                          => cfg_interrupt_di,
      v6_cfg_interrupt_do                          => cfg_interrupt_do,
      v6_cfg_interrupt_mmenable                    => cfg_interrupt_mmenable,
      v6_cfg_interrupt_msienable                   => cfg_interrupt_msienable,
      v6_cfg_interrupt_msixenable                  => cfg_interrupt_msixenable,
      v6_cfg_interrupt_msixfm                      => cfg_interrupt_msixfm,
      v6_cfg_turnoff_ok_n                          => cfg_turnoff_ok_n,
      v6_cfg_to_turnoff_n                          => cfg_to_turnoff_n,
      v6_cfg_trn_pending_n                         => cfg_trn_pending_n,
      v6_cfg_pm_wake_n                             => cfg_pm_wake_n,
      v6_cfg_bus_number                            => cfg_bus_number,
      v6_cfg_device_number                         => cfg_device_number,
      v6_cfg_function_number                       => cfg_function_number,
      v6_cfg_status                                => cfg_status,
      v6_cfg_command                               => cfg_command,
      v6_cfg_dstatus                               => cfg_dstatus,
      v6_cfg_dcommand                              => cfg_dcommand,
      v6_cfg_lstatus                               => cfg_lstatus,
      v6_cfg_lcommand                              => cfg_lcommand,
      v6_cfg_dcommand2                             => cfg_dcommand2,
      v6_cfg_pcie_link_state_n                     => cfg_pcie_link_state_n,
      v6_cfg_dsn                                   => cfg_dsn,
      
      v6_pl_initial_link_width                     => pl_initial_link_width,
      v6_pl_lane_reversal_mode                     => pl_lane_reversal_mode,
      v6_pl_link_gen2_capable                      => pl_link_gen2_capable,
      v6_pl_link_partner_gen2_supported            => pl_link_partner_gen2_supported,
      v6_pl_link_upcfg_capable                     => pl_link_upcfg_capable,
      v6_pl_ltssm_state                            => pl_ltssm_state,
      v6_pl_received_hot_rst                       => pl_received_hot_rst,
      v6_pl_sel_link_rate                          => pl_sel_link_rate,
      v6_pl_sel_link_width                         => pl_sel_link_width,
      v6_pl_directed_link_auton                    => pl_directed_link_auton,
      v6_pl_directed_link_change                   => pl_directed_link_change,
      v6_pl_directed_link_speed                    => pl_directed_link_speed,
      v6_pl_directed_link_width                    => pl_directed_link_width,
      v6_pl_upstream_prefer_deemph                 => pl_upstream_prefer_deemph,
      v6_sys_clk                                   => sys_clk_c,
      v6_sys_reset_n                               => sys_reset_n,
  
  
  
    ---------------------------------------------------------------------------------------------------------------------
	-------------------------- V7 ---------------------------------------------------------------------------------------
  
	 -------------------------------------------------------------------------------------------------------------------
     -- 2. Clocking Interface                                                                                         --
     -------------------------------------------------------------------------------------------------------------------
      v7_PIPE_PCLK_IN                               => v7_PIPE_PCLK_IN,
      v7_PIPE_RXUSRCLK_IN                           => v7_PIPE_RXUSRCLK_IN,
      v7_PIPE_RXOUTCLK_IN                           => v7_PIPE_RXOUTCLK_IN,
      v7_PIPE_DCLK_IN                               => v7_PIPE_DCLK_IN,
      v7_PIPE_USERCLK1_IN                           => v7_PIPE_USERCLK1_IN,
      v7_PIPE_USERCLK2_IN                           => v7_PIPE_USERCLK2_IN,
      v7_PIPE_OOBCLK_IN                             => v7_PIPE_OOBCLK_IN,
      v7_PIPE_MMCM_LOCK_IN                          => v7_PIPE_MMCM_LOCK_IN,

	  v7_PIPE_MMCM_RST_N 							=> v7_PIPE_MMCM_RST_N,
      v7_PIPE_TXOUTCLK_OUT                          => v7_PIPE_TXOUTCLK_OUT,
      v7_PIPE_RXOUTCLK_OUT                          => v7_PIPE_RXOUTCLK_OUT,
      v7_PIPE_PCLK_SEL_OUT                          => v7_PIPE_PCLK_SEL_OUT,
      v7_PIPE_GEN3_OUT                              => v7_PIPE_GEN3_OUT,

     -------------------------------------------------------------------------------------------------------------------
     -- 3. AXI-S Interface                                                                                            --
     -------------------------------------------------------------------------------------------------------------------
      -- Common
      v7_user_clk_out                               => v7_user_clk_out,
      v7_user_reset_out                             => v7_user_reset_out,
      v7_user_lnk_up                                => v7_user_lnk_up,

      -- TX
      v7_tx_buf_av                                  => v7_tx_buf_av,
      v7_tx_cfg_req                                 => v7_tx_cfg_req,
      v7_tx_err_drop                                => v7_tx_err_drop,
      v7_s_axis_tx_tready                           => v7_s_axis_tx_tready,
      v7_s_axis_tx_tdata                            => v7_s_axis_tx_tdata,
      v7_s_axis_tx_tkeep                            => v7_s_axis_tx_tkeep,
      v7_s_axis_tx_tlast                            => v7_s_axis_tx_tlast,
      v7_s_axis_tx_tvalid                           => v7_s_axis_tx_tvalid,
      v7_s_axis_tx_tuser                            => v7_s_axis_tx_tuser,
      v7_tx_cfg_gnt                                 => v7_tx_cfg_gnt,

      -- RX
      v7_m_axis_rx_tdata                            => v7_m_axis_rx_tdata,
      v7_m_axis_rx_tkeep                            => v7_m_axis_rx_tkeep,
      v7_m_axis_rx_tlast                            => v7_m_axis_rx_tlast,
      v7_m_axis_rx_tvalid                           => v7_m_axis_rx_tvalid,
      v7_m_axis_rx_tready                           => v7_m_axis_rx_tready,
      v7_m_axis_rx_tuser                            => v7_m_axis_rx_tuser,
      v7_rx_np_ok                                   => v7_rx_np_ok,
      v7_rx_np_req                                  => v7_rx_np_req,

      -- Flow Control
      v7_fc_cpld                                    => v7_fc_cpld,
      v7_fc_cplh                                    => v7_fc_cplh,
      v7_fc_npd                                     => v7_fc_npd,
      v7_fc_nph                                     => v7_fc_nph,
      v7_fc_pd                                      => v7_fc_pd,
      v7_fc_ph                                      => v7_fc_ph,
      v7_fc_sel                                     => v7_fc_sel,

     -------------------------------------------------------------------------------------------------------------------
     -- 4. Configuration (CFG) Interface                                                                              --
     -------------------------------------------------------------------------------------------------------------------
     ---------------------------------------------------------------------
      -- EP and RP                                                      --
     ---------------------------------------------------------------------
      v7_cfg_mgmt_do                                => v7_cfg_mgmt_do,
      v7_cfg_mgmt_rd_wr_done                        => v7_cfg_mgmt_rd_wr_done,

      v7_cfg_status                                 => v7_cfg_status,
      v7_cfg_command                                => v7_cfg_command,
      v7_cfg_dstatus                                => v7_cfg_dstatus,
      v7_cfg_dcommand                               => v7_cfg_dcommand,
      v7_cfg_lstatus                                => v7_cfg_lstatus,
      v7_cfg_lcommand                               => v7_cfg_lcommand,
      v7_cfg_dcommand2                              => v7_cfg_dcommand2,
      v7_cfg_pcie_link_state                        => v7_cfg_pcie_link_state,

      v7_cfg_pmcsr_pme_en                           => v7_cfg_pmcsr_pme_en,
      v7_cfg_pmcsr_powerstate                       => v7_cfg_pmcsr_powerstate,
      v7_cfg_pmcsr_pme_status                       => v7_cfg_pmcsr_pme_status,

      -- Management Interface
      v7_cfg_mgmt_di                                => v7_cfg_mgmt_di,
      v7_cfg_mgmt_byte_en                           => v7_cfg_mgmt_byte_en,
      v7_cfg_mgmt_dwaddr                            => v7_cfg_mgmt_dwaddr,
      v7_cfg_mgmt_wr_en                             => v7_cfg_mgmt_wr_en,
      v7_cfg_mgmt_rd_en                             => v7_cfg_mgmt_rd_en,
      v7_cfg_mgmt_wr_readonly                       => v7_cfg_mgmt_wr_readonly,

      -- Error Reporting Interface
      v7_cfg_err_ecrc                               => v7_cfg_err_ecrc,
      v7_cfg_err_ur                                 => v7_cfg_err_ur,
      v7_cfg_err_cpl_timeout                        => v7_cfg_err_cpl_timeout,
      v7_cfg_err_cpl_unexpect                       => v7_cfg_err_cpl_unexpect,
      v7_cfg_err_cpl_abort                          => v7_cfg_err_cpl_abort,
      v7_cfg_err_posted                             => v7_cfg_err_posted,
      v7_cfg_err_cor                                => v7_cfg_err_cor,
      v7_cfg_err_atomic_egress_blocked              => v7_cfg_err_atomic_egress_blocked,
      v7_cfg_err_internal_cor                       => v7_cfg_err_internal_cor,
      v7_cfg_err_malformed                          => v7_cfg_err_malformed,
      v7_cfg_err_mc_blocked                         => v7_cfg_err_mc_blocked,
      v7_cfg_err_poisoned                           => v7_cfg_err_poisoned,
      v7_cfg_err_norecovery                         => v7_cfg_err_norecovery,
      v7_cfg_err_tlp_cpl_header                     => v7_cfg_err_tlp_cpl_header,
      v7_cfg_err_cpl_rdy                            => v7_cfg_err_cpl_rdy,
      v7_cfg_err_locked                             => v7_cfg_err_locked,
      v7_cfg_err_acs                                => v7_cfg_err_acs,
      v7_cfg_err_internal_uncor                     => v7_cfg_err_internal_uncor,
	  
      v7_cfg_trn_pending                            => v7_cfg_trn_pending,
      v7_cfg_pm_halt_aspm_l0s                       => v7_cfg_pm_halt_aspm_l0s,
      v7_cfg_pm_halt_aspm_l1                        => v7_cfg_pm_halt_aspm_l1,
      v7_cfg_pm_force_state_en                      => v7_cfg_pm_force_state_en,
      v7_cfg_pm_force_state                         => v7_cfg_pm_force_state,
      v7_cfg_dsn                                    => v7_cfg_dsn,

     ---------------------------------------------------------------------
      -- EP Only                                                        --
     ---------------------------------------------------------------------
      v7_cfg_interrupt                              => v7_cfg_interrupt, 
      v7_cfg_interrupt_rdy                          => v7_cfg_interrupt_rdy,
      v7_cfg_interrupt_assert                       => v7_cfg_interrupt_assert,
      v7_cfg_interrupt_di                           => v7_cfg_interrupt_di,
      v7_cfg_interrupt_do                           => v7_cfg_interrupt_do,
      v7_cfg_interrupt_mmenable                     => v7_cfg_interrupt_mmenable,
      v7_cfg_interrupt_msienable                    => v7_cfg_interrupt_msienable,
      v7_cfg_interrupt_msixenable                   => v7_cfg_interrupt_msixenable,
      v7_cfg_interrupt_msixfm                       => v7_cfg_interrupt_msixfm,
      v7_cfg_interrupt_stat                         => v7_cfg_interrupt_stat,
      v7_cfg_pciecap_interrupt_msgnum               => v7_cfg_pciecap_interrupt_msgnum,
      v7_cfg_to_turnoff                             => v7_cfg_to_turnoff,
      v7_cfg_turnoff_ok                             => v7_cfg_turnoff_ok,
      v7_cfg_bus_number                             => v7_cfg_bus_number,
      v7_cfg_device_number                          => v7_cfg_device_number,
      v7_cfg_function_number                        => v7_cfg_function_number,
      v7_cfg_pm_wake                                => v7_cfg_pm_wake,

     ---------------------------------------------------------------------
      -- RP Only                                                        --
     ---------------------------------------------------------------------
     
     -----------------------------------------------------------------------------------------------------------------
     -- 5. Physical Layer Control and Status (PL) Interface                                                           --
     -------------------------------------------------------------------------------------------------------------------
      v7_pl_directed_link_change                    => v7_pl_directed_link_change,
      v7_pl_directed_link_width                     => v7_pl_directed_link_width,
      v7_pl_directed_link_speed                     => v7_pl_directed_link_speed,
      v7_pl_directed_link_auton                     => v7_pl_directed_link_auton,
      v7_pl_upstream_prefer_deemph                  => v7_pl_upstream_prefer_deemph,

      v7_pl_sel_lnk_rate                            => v7_pl_sel_lnk_rate,
      v7_pl_sel_lnk_width                           => v7_pl_sel_lnk_width,
      v7_pl_ltssm_state                             => v7_pl_ltssm_state,
      v7_pl_lane_reversal_mode                      => v7_pl_lane_reversal_mode,


      v7_pl_link_upcfg_cap                          => v7_pl_link_upcfg_cap,
      v7_pl_link_gen2_cap                           => v7_pl_link_gen2_cap,
      v7_pl_link_partner_gen2_supported             => v7_pl_link_partner_gen2_supported,
      v7_pl_initial_link_width                      => v7_pl_initial_link_width,


     ---------------------------------------------------------------------
      -- EP Only                                                        --
     ---------------------------------------------------------------------
      v7_pl_received_hot_rst                        => v7_pl_received_hot_rst,
     ---------------------------------------------------------------------
      -- RP Only                                                        --
     ---------------------------------------------------------------------
      ------------------------------------------------------------------------------------------------------------------
     -- 6. AER interface                                                                                              --
     -------------------------------------------------------------------------------------------------------------------
      v7_cfg_err_aer_headerlog                      => v7_cfg_err_aer_headerlog,
      v7_cfg_aer_interrupt_msgnum                   => v7_cfg_aer_interrupt_msgnum,
      v7_cfg_err_aer_headerlog_set                  => v7_cfg_err_aer_headerlog_set,
      v7_cfg_aer_ecrc_check_en                      => v7_cfg_aer_ecrc_check_en,
      v7_cfg_aer_ecrc_gen_en                        => v7_cfg_aer_ecrc_gen_en,
     -------------------------------------------------------------------------------------------------------------------
     -- 7. VC interface                                                                                               --
     -------------------------------------------------------------------------------------------------------------------
      
     -------------------------------------------------------------------------------------------------------------------
     -- 8. System(SYS) Interface                                                                                      --
     -------------------------------------------------------------------------------------------------------------------
      v7_sys_clk                                    => v7_sys_clk,
      v7_sys_reset                                  => v7_sys_reset
		
	);

pcie_7x_v1_10_i : pcie_7x_v1_10  generic map(
      PL_FAST_TRAIN                         => PL_FAST_TRAIN,
      PCIE_EXT_CLK                          => PCIE_EXT_CLK
      )
  port map(
  -------------------------------------------------------------------------------------------------------------------
  -- 1. PCI Express (pci_exp) Interface                                                                            --
  -------------------------------------------------------------------------------------------------------------------
  -- TX
  pci_exp_txp                               => pci_exp_txp,
  pci_exp_txn                               => pci_exp_txn,
  -- RX
  pci_exp_rxp                               => pci_exp_rxp,
  pci_exp_rxn                               => pci_exp_rxn,

  -------------------------------------------------------------------------------------------------------------------
  -- 2. Clocking Interface - For Partial Reconfig Support                                                          --
  -------------------------------------------------------------------------------------------------------------------
  PIPE_PCLK_IN                               => v7_PIPE_PCLK_IN,
  PIPE_RXUSRCLK_IN                           => v7_PIPE_RXUSRCLK_IN,
  PIPE_RXOUTCLK_IN                           => v7_PIPE_RXOUTCLK_IN,
  PIPE_DCLK_IN                               => v7_PIPE_DCLK_IN,
  PIPE_USERCLK1_IN                           => v7_PIPE_USERCLK1_IN,
  PIPE_USERCLK2_IN                           => v7_PIPE_USERCLK2_IN,
  PIPE_OOBCLK_IN                             => v7_PIPE_OOBCLK_IN,
  PIPE_MMCM_LOCK_IN                          => v7_PIPE_MMCM_LOCK_IN,
  PIPE_TXOUTCLK_OUT                          => v7_PIPE_TXOUTCLK_OUT,
  PIPE_RXOUTCLK_OUT                          => v7_PIPE_RXOUTCLK_OUT,
  PIPE_PCLK_SEL_OUT                          => v7_PIPE_PCLK_SEL_OUT,
  PIPE_GEN3_OUT                              => v7_PIPE_GEN3_OUT,

  -------------------------------------------------------------------------------------------------------------------
  -- 3. AXI-S Interface                                                                                            --
  -------------------------------------------------------------------------------------------------------------------
  -- Common
  user_clk_out                               => v7_user_clk_out ,
  user_reset_out                             => v7_user_reset_out,
  user_lnk_up                                => v7_user_lnk_up,

  -- TX
  tx_buf_av                                  => v7_tx_buf_av ,
  tx_cfg_req                                 => v7_tx_cfg_req ,
  tx_err_drop                                => v7_tx_err_drop ,
  s_axis_tx_tready                           => v7_s_axis_tx_tready ,
  s_axis_tx_tdata                            => v7_s_axis_tx_tdata ,
  s_axis_tx_tkeep                            => v7_s_axis_tx_tkeep ,
  s_axis_tx_tlast                            => v7_s_axis_tx_tlast ,
  s_axis_tx_tvalid                           => v7_s_axis_tx_tvalid ,
  s_axis_tx_tuser                            => v7_s_axis_tx_tuser,
  tx_cfg_gnt                                 => v7_tx_cfg_gnt ,

  -- RX
  m_axis_rx_tdata                            => v7_m_axis_rx_tdata ,
  m_axis_rx_tkeep                            => v7_m_axis_rx_tkeep ,
  m_axis_rx_tlast                            => v7_m_axis_rx_tlast ,
  m_axis_rx_tvalid                           => v7_m_axis_rx_tvalid ,
  m_axis_rx_tready                           => v7_m_axis_rx_tready ,
  m_axis_rx_tuser                            => v7_m_axis_rx_tuser,
  rx_np_ok                                   => v7_rx_np_ok ,
  rx_np_req                                  => v7_rx_np_req ,

  -- Flow Control
  fc_cpld                                    => v7_fc_cpld ,
  fc_cplh                                    => v7_fc_cplh ,
  fc_npd                                     => v7_fc_npd ,
  fc_nph                                     => v7_fc_nph ,
  fc_pd                                      => v7_fc_pd ,
  fc_ph                                      => v7_fc_ph ,
  fc_sel                                     => v7_fc_sel ,

  -------------------------------------------------------------------------------------------------------------------
  -- 4. Configuration (CFG) Interface                                                                              --
  -------------------------------------------------------------------------------------------------------------------
  ---------------------------------------------------------------------
   -- EP and RP                                                      --
  ---------------------------------------------------------------------

  cfg_mgmt_do                                => v7_cfg_mgmt_do,
  cfg_mgmt_rd_wr_done                        => v7_cfg_mgmt_rd_wr_done,

  cfg_status                                 => v7_cfg_status ,
  cfg_command                                => v7_cfg_command ,
  cfg_dstatus                                => v7_cfg_dstatus ,
  cfg_dcommand                               => v7_cfg_dcommand ,
  cfg_lstatus                                => v7_cfg_lstatus ,
  cfg_lcommand                               => v7_cfg_lcommand ,
  cfg_dcommand2                              => v7_cfg_dcommand2 ,
  cfg_pcie_link_state                        => v7_cfg_pcie_link_state ,

  cfg_pmcsr_pme_en                           => v7_cfg_pmcsr_pme_en ,
  cfg_pmcsr_pme_status                       => v7_cfg_pmcsr_pme_status ,
  cfg_pmcsr_powerstate                       => v7_cfg_pmcsr_powerstate ,
  
  cfg_mgmt_di                                => v7_cfg_mgmt_di ,
  cfg_mgmt_byte_en                           => v7_cfg_mgmt_byte_en ,
  cfg_mgmt_dwaddr                            => v7_cfg_mgmt_dwaddr ,
  cfg_mgmt_wr_en                             => v7_cfg_mgmt_wr_en ,
  cfg_mgmt_rd_en                             => v7_cfg_mgmt_rd_en ,
  cfg_mgmt_wr_readonly                       => v7_cfg_mgmt_wr_readonly ,

  cfg_err_ecrc                               => v7_cfg_err_ecrc ,
  cfg_err_ur                                 => v7_cfg_err_ur ,
  cfg_err_cpl_timeout                        => v7_cfg_err_cpl_timeout ,
  cfg_err_cpl_unexpect                       => v7_cfg_err_cpl_unexpect ,
  cfg_err_cpl_abort                          => v7_cfg_err_cpl_abort ,
  cfg_err_posted                             => v7_cfg_err_posted ,
  cfg_err_cor                                => v7_cfg_err_cor ,
  cfg_err_atomic_egress_blocked              => v7_cfg_err_atomic_egress_blocked ,
  cfg_err_internal_cor                       => v7_cfg_err_internal_cor ,
  cfg_err_malformed                          => v7_cfg_err_malformed ,
  cfg_err_mc_blocked                         => v7_cfg_err_mc_blocked ,
  cfg_err_poisoned                           => v7_cfg_err_poisoned ,
  cfg_err_norecovery                         => v7_cfg_err_norecovery ,
  cfg_err_tlp_cpl_header                     => v7_cfg_err_tlp_cpl_header,
  cfg_err_cpl_rdy                            => v7_cfg_err_cpl_rdy ,
  cfg_err_locked                             => v7_cfg_err_locked ,
  cfg_err_acs                                => v7_cfg_err_acs ,
  cfg_err_internal_uncor                     => v7_cfg_err_internal_uncor ,

  cfg_trn_pending                            => v7_cfg_trn_pending ,
  cfg_pm_halt_aspm_l0s                       => v7_cfg_pm_halt_aspm_l0s ,
  cfg_pm_halt_aspm_l1                        => v7_cfg_pm_halt_aspm_l1 ,
  cfg_pm_force_state_en                      => v7_cfg_pm_force_state_en ,
  cfg_pm_force_state                         => v7_cfg_pm_force_state ,

  ---------------------------------------------------------------------
   -- EP Only                                                        --
  ---------------------------------------------------------------------

  cfg_interrupt                              => v7_cfg_interrupt ,
  cfg_interrupt_rdy                          => v7_cfg_interrupt_rdy ,
  cfg_interrupt_assert                       => v7_cfg_interrupt_assert ,
  cfg_interrupt_di                           => v7_cfg_interrupt_di ,
  cfg_interrupt_do                           => v7_cfg_interrupt_do ,
  cfg_interrupt_mmenable                     => v7_cfg_interrupt_mmenable ,
  cfg_interrupt_msienable                    => v7_cfg_interrupt_msienable ,
  cfg_interrupt_msixenable                   => v7_cfg_interrupt_msixenable ,
  cfg_interrupt_msixfm                       => v7_cfg_interrupt_msixfm ,
  cfg_interrupt_stat                         => v7_cfg_interrupt_stat ,
  cfg_pciecap_interrupt_msgnum               => v7_cfg_pciecap_interrupt_msgnum ,
  cfg_to_turnoff                             => v7_cfg_to_turnoff ,
  cfg_turnoff_ok                             => v7_cfg_turnoff_ok ,
  cfg_bus_number                             => v7_cfg_bus_number ,
  cfg_device_number                          => v7_cfg_device_number ,
  cfg_function_number                        => v7_cfg_function_number ,
  cfg_pm_wake                                => v7_cfg_pm_wake ,

  ---------------------------------------------------------------------
   -- RP Only                                                        --
  ---------------------------------------------------------------------
  cfg_pm_send_pme_to                         => '0' ,
  cfg_ds_bus_number                          => x"00" ,
  cfg_ds_device_number                       => "00000" ,
  cfg_ds_function_number                     => "000" ,
  cfg_mgmt_wr_rw1c_as_rw                     => '0' ,
  cfg_msg_received                           => open ,
  cfg_msg_data                               => open ,

  cfg_bridge_serr_en                         => open ,
  cfg_slot_control_electromech_il_ctl_pulse  => open ,
  cfg_root_control_syserr_corr_err_en        => open ,
  cfg_root_control_syserr_non_fatal_err_en   => open ,
  cfg_root_control_syserr_fatal_err_en       => open ,
  cfg_root_control_pme_int_en                => open ,
  cfg_aer_rooterr_corr_err_reporting_en      => open ,
  cfg_aer_rooterr_non_fatal_err_reporting_en => open ,
  cfg_aer_rooterr_fatal_err_reporting_en     => open ,
  cfg_aer_rooterr_corr_err_received          => open ,
  cfg_aer_rooterr_non_fatal_err_received     => open ,
  cfg_aer_rooterr_fatal_err_received         => open ,

  cfg_msg_received_err_cor                   => open ,
  cfg_msg_received_err_non_fatal             => open ,
  cfg_msg_received_err_fatal                 => open ,
  cfg_msg_received_pm_as_nak                 => open ,
  cfg_msg_received_pm_pme                    => open ,
  cfg_msg_received_pme_to_ack                => open ,
  cfg_msg_received_assert_int_a              => open ,
  cfg_msg_received_assert_int_b              => open ,
  cfg_msg_received_assert_int_c              => open ,
  cfg_msg_received_assert_int_d              => open ,
  cfg_msg_received_deassert_int_a            => open ,
  cfg_msg_received_deassert_int_b            => open ,
  cfg_msg_received_deassert_int_c            => open ,
  cfg_msg_received_deassert_int_d            => open ,

  -------------------------------------------------------------------------------------------------------------------
  -- 5. Physical Layer Control and Status (PL) Interface                                                           --
  -------------------------------------------------------------------------------------------------------------------
  pl_directed_link_auton                     => v7_pl_directed_link_auton ,
  pl_directed_link_change                    => v7_pl_directed_link_change ,
  pl_directed_link_speed                     => v7_pl_directed_link_speed ,
  pl_directed_link_width                     => v7_pl_directed_link_width ,
  pl_upstream_prefer_deemph                  => v7_pl_upstream_prefer_deemph ,

  pl_sel_lnk_rate                            => v7_pl_sel_lnk_rate ,
  pl_sel_lnk_width                           => v7_pl_sel_lnk_width ,
  pl_ltssm_state                             => v7_pl_ltssm_state ,
  pl_lane_reversal_mode                      => v7_pl_lane_reversal_mode ,

  pl_phy_lnk_up                              => open ,
  pl_tx_pm_state                             => open ,
  pl_rx_pm_state                             => open ,

  cfg_dsn                                    => v7_cfg_dsn ,

  pl_link_upcfg_cap                          => v7_pl_link_upcfg_cap ,
  pl_link_gen2_cap                           => v7_pl_link_gen2_cap ,
  pl_link_partner_gen2_supported             => v7_pl_link_partner_gen2_supported ,
  pl_initial_link_width                      => v7_pl_initial_link_width ,

  pl_directed_change_done                    => open ,

  ---------------------------------------------------------------------
   -- EP Only                                                        --
  ---------------------------------------------------------------------
  pl_received_hot_rst                        => v7_pl_received_hot_rst ,

  ---------------------------------------------------------------------
   -- RP Only                                                        --
  ---------------------------------------------------------------------
  pl_transmit_hot_rst                        => '0' ,
  pl_downstream_deemph_source                => '0' ,

  -------------------------------------------------------------------------------------------------------------------
  -- 6. AER interface                                                                                              --
  -------------------------------------------------------------------------------------------------------------------
  cfg_err_aer_headerlog                      => v7_cfg_err_aer_headerlog ,
  cfg_aer_interrupt_msgnum                   => v7_cfg_aer_interrupt_msgnum ,
  cfg_err_aer_headerlog_set                  => v7_cfg_err_aer_headerlog_set ,
  cfg_aer_ecrc_check_en                      => v7_cfg_aer_ecrc_check_en ,
  cfg_aer_ecrc_gen_en                        => v7_cfg_aer_ecrc_gen_en ,

  -------------------------------------------------------------------------------------------------------------------
  -- 7. VC interface                                                                                               --
  -------------------------------------------------------------------------------------------------------------------
  cfg_vc_tcvc_map                            => open ,


  -------------------------------------------------------------------------------------------------------------------
  -- 8. System(SYS) Interface                                                                                      --
  -------------------------------------------------------------------------------------------------------------------
  PIPE_MMCM_RST_N                            =>  v7_PIPE_MMCM_RST_N ,        -- Async      | Async
  sys_clk                                    => v7_sys_clk ,
  sys_rst_n                                  => v7_sys_reset_n
);
v7_sys_reset_n <= not v7_sys_reset;


app : pcie_app_v6
  generic map (
  EP_ID => EP_ID
  )
  port map(
  -- PCIe interface
  trn_clk        =>  trn_clk ,
  trn_reset_n        =>  trn_reset_n_int1 ,
  trn_tcfg_req_n        =>  trn_tcfg_req_n ,
  trn_terr_drop_n        =>  trn_terr_drop_n ,
  trn_tdst_rdy_n        =>  trn_tdst_rdy_n ,
  trn_td        =>  trn_td ,
  trn_trem_n        =>  trn_trem_n ,
  trn_tsof_n        =>  trn_tsof_n ,
  trn_teof_n        =>  trn_teof_n ,
  trn_tsrc_rdy_n        =>  trn_tsrc_rdy_n ,
  trn_tsrc_dsc_n        =>  trn_tsrc_dsc_n ,
  trn_terrfwd_n        =>  trn_terrfwd_n ,
  trn_tcfg_gnt_n        =>  trn_tcfg_gnt_n ,
  trn_tstr_n        =>  trn_tstr_n ,
  trn_rd        =>  trn_rd ,
  trn_rrem_n        =>  trn_rrem_n ,
  trn_rsof_n        =>  trn_rsof_n ,
  trn_reof_n        =>  trn_reof_n ,
  trn_rsrc_rdy_n        =>  trn_rsrc_rdy_n ,
  trn_rsrc_dsc_n        =>  trn_rsrc_dsc_n ,
  trn_rerrfwd_n        =>  trn_rerrfwd_n ,
  trn_rbar_hit_n        =>  trn_rbar_hit_n ,
  trn_rdst_rdy_n        =>  trn_rdst_rdy_n ,
  trn_rnp_ok_n        =>  trn_rnp_ok_n ,
  trn_fc_cpld        =>  trn_fc_cpld ,
  trn_fc_cplh        =>  trn_fc_cplh ,
  trn_fc_npd        =>  trn_fc_npd ,
  trn_fc_nph        =>  trn_fc_nph ,
  trn_fc_pd        =>  trn_fc_pd ,
  trn_fc_ph        =>  trn_fc_ph ,
  trn_fc_sel        =>  trn_fc_sel ,
  cfg_do        =>  cfg_do ,
  cfg_rd_wr_done_n        =>  cfg_rd_wr_done_n,
  cfg_di        =>  cfg_di ,
  cfg_byte_en_n        =>  cfg_byte_en_n ,
  cfg_dwaddr        =>  cfg_dwaddr ,
  cfg_wr_en_n        =>  cfg_wr_en_n ,
  cfg_rd_en_n        =>  cfg_rd_en_n ,
  cfg_err_cor_n        =>  cfg_err_cor_n ,
  cfg_err_ur_n        =>  cfg_err_ur_n ,
  cfg_err_ecrc_n        =>  cfg_err_ecrc_n ,
  cfg_err_cpl_timeout_n        =>  cfg_err_cpl_timeout_n ,
  cfg_err_cpl_abort_n        =>  cfg_err_cpl_abort_n ,
  cfg_err_cpl_unexpect_n        =>  cfg_err_cpl_unexpect_n ,
  cfg_err_posted_n        =>  cfg_err_posted_n ,
  cfg_err_locked_n        =>  cfg_err_locked_n ,
  cfg_err_tlp_cpl_header        =>  cfg_err_tlp_cpl_header ,
  cfg_err_cpl_rdy_n        =>  cfg_err_cpl_rdy_n ,
  cfg_interrupt_n        =>  cfg_interrupt_n ,
  cfg_interrupt_rdy_n        =>  cfg_interrupt_rdy_n ,
  cfg_interrupt_assert_n        =>  cfg_interrupt_assert_n ,
  cfg_interrupt_di        =>  cfg_interrupt_di ,
  cfg_interrupt_do        =>  cfg_interrupt_do ,
  cfg_interrupt_mmenable        =>  cfg_interrupt_mmenable ,
  cfg_interrupt_msienable        =>  cfg_interrupt_msienable ,
  cfg_interrupt_msixenable        =>  cfg_interrupt_msixenable ,
  cfg_interrupt_msixfm        =>  cfg_interrupt_msixfm ,
  cfg_turnoff_ok_n        =>  cfg_turnoff_ok_n ,
  cfg_to_turnoff_n        =>  cfg_to_turnoff_n ,
  cfg_trn_pending_n        =>  cfg_trn_pending_n ,
  cfg_pm_wake_n        =>  cfg_pm_wake_n ,
  cfg_bus_number        =>  cfg_bus_number ,
  cfg_device_number        =>  cfg_device_number ,
  cfg_function_number        =>  cfg_function_number ,
  cfg_status        =>  cfg_status ,
  cfg_command        =>  cfg_command ,
  cfg_dstatus        =>  cfg_dstatus ,
  cfg_dcommand        =>  cfg_dcommand ,
  cfg_lstatus        =>  cfg_lstatus ,
  cfg_lcommand        =>  cfg_lcommand ,
  cfg_dcommand2        =>  cfg_dcommand2 ,
  cfg_pcie_link_state_n        =>  cfg_pcie_link_state_n ,
  cfg_dsn        =>  cfg_dsn ,
  pl_initial_link_width        =>  pl_initial_link_width ,
  pl_lane_reversal_mode        =>  pl_lane_reversal_mode ,
  pl_link_gen2_capable        =>  pl_link_gen2_capable ,
  pl_link_partner_gen2_supported        =>  pl_link_partner_gen2_supported ,
  pl_link_upcfg_capable        =>  pl_link_upcfg_capable ,
  pl_ltssm_state        =>  pl_ltssm_state ,
  pl_received_hot_rst        =>  pl_received_hot_rst ,
  pl_sel_link_rate        =>  pl_sel_link_rate ,
  pl_sel_link_width        =>  pl_sel_link_width ,
  pl_directed_link_auton        =>  pl_directed_link_auton ,
  pl_directed_link_change        =>  pl_directed_link_change ,
  pl_directed_link_speed        =>  pl_directed_link_speed ,
  pl_directed_link_width        =>  pl_directed_link_width ,
  pl_upstream_prefer_deemph        =>  pl_upstream_prefer_deemph,
 
  -- descriptors interface
  descriptors_buffers_addr_portb => descriptors_buffers_addr_portb,
  descriptors_buffers_dout_portb => descriptors_buffers_dout_portb,
  descriptors_buffers_din_portb => descriptors_buffers_din_portb,
  descriptors_buffers_we_portb => descriptors_buffers_we_portb,
 
  -- mailbox interface 
  mailbox_wen_addr_portb => mailbox_wen_addr_portb,
  mailbox_wen_din_portb => mailbox_wen_din_portb,
  mailbox_wen_portb => mailbox_wen_portb,
  mailbox_wen_dout_portb => mailbox_wen_dout_portb,  
  
 -- clock, reset and debug signals
  dma_reset => trn_lnk_up_n,
  debug			=> debug_int,  
  
  --interface with MPMC
  --write port 
  dma_waddr_en => dma_waddr_en,
  dma_waddr => dma_waddr,
  dma_wdata_en => dma_wdata_en,
  dma_wdata => dma_wdata,
  dma_wdata_rdy => dma_wdata_rdy,
  
  --read port
  dma_rdata_en => dma_rdata_en,
  dma_rdata => dma_rdata,
  dma_raddr_en => dma_raddr_en,
  dma_raddr => dma_raddr,
  dma_rdata_rdy => dma_rdata_rdy,
  dma_rdata_busy => dma_rdata_busy,

  --unused   
  soft_rst_ep => soft_rst_ep,
  dma_start => dma_start,
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
  
  logic_int_en => logic_int_en,
  logic_int_en_ack => logic_int_en_ack

   
  );

  dma_resetout <= trn_lnk_up_n;
  dma_reset_int <=  trn_lnk_up_n or soft_rst_ep; 
 
-- mpmc
--  xmpmc : mpmc 
--  port map
-- (
--	clk => trn_clk,
--	rst => dma_reset_int,
--	
--	port0_wdata_en => dma_wdata_en,
--	port0_wdata => dma_wdata,
--	port0_wdata_rdy => dma_wdata_rdy,
--	port0_waddr_en => dma_waddr_en,
--	port0_waddr => dma_waddr,
--	
--	port0_raddr_en => dma_raddr_en,
--	port0_raddr => dma_raddr,
--	port0_rdata_busy => dma_rdata_busy,
--	port0_rdata_en => dma_rdata_en,
--	port0_rdata => dma_rdata,
--	port0_rdata_rdy => dma_rdata_rdy,
--	
--	port1_wdata_en => user_wdata_en,
--	port1_wdata => user_wdata,
--	port1_wdata_rdy => user_wdata_rdy,
--	port1_waddr_en => user_waddr_en,
--	port1_waddr => user_waddr,
--	
--	port1_raddr_en => user_raddr_en,
--	port1_raddr => user_raddr,
--	port1_rdata_busy => user_rdata_busy,
--	port1_rdata_en => user_rdata_en,
--	port1_rdata => user_rdata,
--	port1_rdata_rdy => user_rdata_rdy,
--	
--	app_wdf_wren => app_wdf_wren,
--	app_wdf_data => app_wdf_data,
--	app_wdf_mask => app_wdf_mask,
--	app_wdf_end  => app_wdf_end,
--	app_addr     => app_addr,
--	app_cmd      => app_cmd,
--	app_en       => app_en,
--    
--	app_rdy       => app_rdy,
--	app_wdf_rdy   => app_wdf_rdy,
--	app_rd_data   => app_rd_data,
--	app_rd_data_end => app_rd_data_end,
--	app_rd_data_valid => app_rd_data_valid,
--	ui_clk_sync_rst => ui_clk_sync_rst,
--	ui_clk       => ui_clk
--);
--	   
--		ui_clk_sync_rst <= dma_reset_int;
--		ui_clk <= clk200;
--		
--		xbram_ctr : bram_ctr 
--		port map(
--		
--		clk => ui_clk,
--		rst => ui_clk_sync_rst,
--		
--		app_wdf_wren => app_wdf_wren,
--		app_wdf_data => app_wdf_data,
--		app_wdf_mask => app_wdf_mask,
--		app_wdf_end => app_wdf_end,
--		app_addr => app_addr_int,  
--		app_cmd  => app_cmd,
--		app_en   => app_en,     
--		app_rdy  => app_rdy,
--		app_wdf_rdy => app_wdf_rdy,
--		app_rd_data => app_rd_data,
--		app_rd_data_end => app_rd_data_end,
--		app_rd_data_valid => app_rd_data_valid,
--		
--		bram_wea0 => bram_wea0,
--		bram_wea1 => bram_wea1,
--		bram_waddr => bram_waddr,
--		bram_dina => bram_dina,
--		bram_raddr => bram_raddr,
--		bram_doutb0 => bram_doutb0,
--		bram_doutb1 => bram_doutb1
--		);
		
		
		phy_init_done <= '1';
		
   
app_addr_int(27) <= '0';
app_addr_int(26 downto 0) <= app_addr;	
  
  trn_clkout <= trn_clk;
  debug <= debug_int;
  trn_reset <= not trn_reset_n;
  phy_init_doneout <= phy_init_done;
  
  process (trn_clk)
  begin
  	if trn_clk 'event and trn_clk = '1' then
  		if trn_reset = '1' then
  			trn_clk_div <= '0';
  		else 
  			trn_clk_div <= not trn_clk_div;
  		end if;
  	end if;
  end process;
  
  
  sys_clk_bufg_debug : BUFG port map ( O => sys_clk_c_o, I => sys_clk_c );
  process (sys_clk_c_o)
  begin
  	if sys_clk_c_o 'event and sys_clk_c_o = '1' then
  		if trn_reset = '1' then
  			sys_clk_div <= '0';
  		else
  			sys_clk_div <= not sys_clk_div;
  		end if;
  	end if;
  end process;
		
  trn_lnk_up_n_int_i: FDCP
     generic map(
       INIT    => '1')
     port map(
       Q       => trn_lnk_up_n,
       D       => trn_lnk_up_n_int1,
       C       => trn_clk,
       CLR     => '0',
       PRE     => '0');

  trn_reset_n_i : FDCP 
     generic map(
       INIT        => '1')
     port map(
        Q      => trn_reset_n,
        D      => trn_reset_n_int1,
        C      => trn_clk,
        CLR    => '0',
        PRE    => '0');



end rtl;