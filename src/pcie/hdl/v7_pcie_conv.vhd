----------------------------------------------------------------------------------------
-- This file is owned and controlled by Avnet and must be used solely
-- for design, simulation, implementation and creation of design files
-- limited to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and immediately
-- terminates your license.
--
--            **************************************
--            ** Copyright (C) 2012, Avnet **
--            ** All Rights Reserved.             **
--            **************************************
----------------------------------------------------------------------------------------
--Created by Avnet HKADS.
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity v7_pcie_conv is
  generic (      
	   C_DATA_WIDTH 				 : integer := 64;
	   PL_FAST_TRAIN                 : string := "FALSE";
	   PCIE_EXT_CLK                  : string := "FALSE"  -- Use External Clocking Module
	   );
  port (
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
end v7_pcie_conv;

architecture rtl of v7_pcie_conv is
	
  component pcie_7x_v1_10_pipe_clock
    generic (
          PCIE_ASYNC_EN                : string  :=   "FALSE";     -- PCIe async enable
          PCIE_TXBUF_EN                : string  :=   "FALSE";     -- PCIe TX buffer enable for Gen1/Gen2 only
          PCIE_LANE                    : integer :=   4;           -- PCIe number of lanes
          PCIE_LINK_SPEED              : integer :=   3;           -- PCIe link speed
          PCIE_REFCLK_FREQ             : integer :=   0;           -- PCIe reference clock frequency
          PCIE_USERCLK1_FREQ           : integer :=   3;           -- PCIe user clock 1 frequency
          PCIE_USERCLK2_FREQ           : integer :=   3;           -- PCIe user clock 2 frequency
          PCIE_DEBUG_MODE              : integer :=   0            -- PCIe Debug Mode
    );
    port  (

          ------------ Input -------------------------------------
          CLK_CLK                        : in std_logic;
          CLK_TXOUTCLK                   : in std_logic;
          CLK_RXOUTCLK_IN                : in std_logic_vector(3 downto 0);
          CLK_RST_N                      : in std_logic;
          CLK_PCLK_SEL                   : in std_logic_vector(3 downto 0);
          CLK_GEN3                       : in std_logic;

          ------------ Output ------------------------------------
          CLK_PCLK                       : out std_logic;
          CLK_RXUSRCLK                   : out std_logic;
          CLK_RXOUTCLK_OUT               : out std_logic_vector(3 downto 0);
          CLK_DCLK                       : out std_logic;
          CLK_USERCLK1                   : out std_logic;
          CLK_USERCLK2                   : out std_logic;
          CLK_OOBCLK                     : out std_logic;
          CLK_MMCM_LOCK                  : out std_logic);
  end component;

	
	
	
   -- purpose: Determine Link Speed Configuration for GT
   function get_gt_lnk_spd_cfg (
     constant simulation : string)
     return integer is
   begin  -- get_gt_lnk_spd_cfg
     if (simulation = "TRUE") then
       return 2;
     else
       return 3;
     end if;
   end get_gt_lnk_spd_cfg;
   
  constant v7_USER_CLK_FREQ        : integer := 3;
  constant v7_USER_CLK2_DIV2       : string  := "FALSE";
  constant v7_USERCLK2_FREQ        : integer := v7_USER_CLK_FREQ;
  constant v7_LNK_SPD              : integer := get_gt_lnk_spd_cfg(PL_FAST_TRAIN);
	
  signal v7_m_axis_rx_tvalid_check : std_logic;
  signal tx_tready_start : std_logic := '0';
  signal v7_s_axis_tx_tready_del : std_logic := '0';
  signal v7_s_axis_tx_tready_rise : std_logic;
  signal v6_trn_tdst_rdy_n_int : std_logic:= '0';
  signal v7_s_axis_tx_tready_int : std_logic;
  
begin

  -- Generate External Clock Module if External Clocking is selected
  ext_clk: if (PCIE_EXT_CLK = "TRUE") generate
  pipe_clock_i : pcie_7x_v1_10_pipe_clock
  generic map(
          PCIE_ASYNC_EN                  => "FALSE",             -- PCIe async enable
          PCIE_TXBUF_EN                  => "FALSE",             -- PCIe TX buffer enable for Gen1/Gen2 only
          PCIE_LANE                      => 4,              -- PCIe number of lanes
          PCIE_LINK_SPEED                => v7_LNK_SPD ,            -- PCIe link speed
          PCIE_REFCLK_FREQ               => 0,             -- PCIe reference clock frequency
          PCIE_USERCLK1_FREQ             => (v7_USER_CLK_FREQ +1),  -- PCIe user clock 1 frequency
          PCIE_USERCLK2_FREQ             => (v7_USERCLK2_FREQ +1),  -- PCIe user clock 2 frequency
          PCIE_DEBUG_MODE                => 0 )                  -- PCIe Debug Mode
  port map(
          ------------ Input -------------------------------------
          CLK_CLK                        => v6_sys_clk,
          CLK_TXOUTCLK                   => v7_PIPE_TXOUTCLK_OUT,       -- Reference clock from lane 0
          CLK_RXOUTCLK_IN                => v7_PIPE_RXOUTCLK_OUT,
          --CLK_RST_N                      => '1',
		  CLK_RST_N                      => v7_PIPE_MMCM_RST_N,
          CLK_PCLK_SEL                   => v7_PIPE_PCLK_SEL_OUT,
          CLK_GEN3                       => v7_PIPE_GEN3_OUT,

          ------------ Output ------------------------------------
          CLK_PCLK                       => v7_PIPE_PCLK_IN,
          CLK_RXUSRCLK                   => v7_PIPE_RXUSRCLK_IN,
          CLK_RXOUTCLK_OUT               => v7_PIPE_RXOUTCLK_IN,
          CLK_DCLK                       => v7_PIPE_DCLK_IN,
          CLK_USERCLK1                   => v7_PIPE_USERCLK1_IN,
          CLK_USERCLK2                   => v7_PIPE_USERCLK2_IN,
          CLK_OOBCLK                     => v7_PIPE_OOBCLK_IN,
          CLK_MMCM_LOCK                  => v7_PIPE_MMCM_LOCK_IN);
  end generate;

  int_clk: if (not(PCIE_EXT_CLK = "TRUE")) generate
    v7_PIPE_PCLK_IN        <= '0';
    v7_PIPE_RXUSRCLK_IN    <= '0';
    v7_PIPE_RXOUTCLK_IN    <= (others => '0');
    v7_PIPE_DCLK_IN        <= '0';
    v7_PIPE_USERCLK1_IN    <= '0';
    v7_PIPE_USERCLK2_IN    <= '0';
    v7_PIPE_OOBCLK_IN      <= '0';
    v7_PIPE_MMCM_LOCK_IN   <= '0';
  end generate;
  
  ---------------------------
      
  v6_trn_clk <= v7_user_clk_out;
  v6_trn_reset_n <= not v7_user_reset_out;
  v6_trn_lnk_up_n <= not v7_user_lnk_up;
  v6_trn_tbuf_av <= v7_tx_buf_av;
  v6_trn_tcfg_req_n <= not v7_tx_cfg_req;
  v6_trn_terr_drop_n <= not v7_tx_err_drop;
  
  process (v7_user_clk_out)
  begin
	if v7_user_clk_out 'event and v7_user_clk_out = '1' then
		if v7_user_reset_out = '1' then
			v7_s_axis_tx_tready_del <= '0';
		else
			v7_s_axis_tx_tready_del <= v7_s_axis_tx_tready;
		end if;
	end if;
  end process;
  v7_s_axis_tx_tready_rise <= v7_s_axis_tx_tready and not v7_s_axis_tx_tready_del;
  process (v7_user_clk_out)
  begin
	if v7_user_clk_out 'event and v7_user_clk_out = '1' then
		if v7_user_reset_out = '1' then
			tx_tready_start <= '0';
		elsif v7_s_axis_tx_tready_rise = '1' and tx_tready_start = '0' then
			tx_tready_start <= '1';
		else 
			tx_tready_start <= tx_tready_start;
		end if;
	end if;
  end process;
  
  v7_s_axis_tx_tready_int <= '1' when (v7_tx_buf_av > B"00_0100" and v7_s_axis_tx_tready  = '1') or tx_tready_start = '0' else '0';
  process (v7_user_clk_out)
  begin
	if v7_user_clk_out 'event and v7_user_clk_out = '1' then
		if v7_user_reset_out = '1' then
			v6_trn_tdst_rdy_n_int <= '0';		
		else
			v6_trn_tdst_rdy_n_int <= not v7_s_axis_tx_tready_int;
		end if;
	end if;
  end process;
  --v6_trn_tdst_rdy_n <= v6_trn_tdst_rdy_n_int or (not v7_s_axis_tx_tready_int);
  v6_trn_tdst_rdy_n <= v6_trn_tdst_rdy_n_int;
  
  
  
  
  v7_s_axis_tx_tdata <= v6_trn_td(31 downto 0) & v6_trn_td(63 downto 32);
  v7_s_axis_tx_tkeep <= X"0f" when v6_trn_trem_n = '1' else x"ff";
  v7_s_axis_tx_tlast <= not v6_trn_teof_n;
  v7_s_axis_tx_tvalid <= not v6_trn_tsrc_rdy_n;  
  v7_s_axis_tx_tuser(3) <= not v6_trn_tsrc_dsc_n;
  v7_s_axis_tx_tuser(2) <= not v6_trn_tstr_n;
  v7_s_axis_tx_tuser(1)	<= not v6_trn_terrfwd_n;
  v7_s_axis_tx_tuser(0) <= '0';
  v7_tx_cfg_gnt <= not v6_trn_tcfg_gnt_n;

  --RX
  process (v7_user_clk_out)
  begin
	if v7_user_clk_out 'event and v7_user_clk_out = '1' then
		if v7_user_reset_out = '1' then
			v7_m_axis_rx_tvalid_check <= '0';
		elsif (v7_m_axis_rx_tvalid = '1' and v6_trn_rdst_rdy_n = '0' and v7_m_axis_rx_tlast = '1' and v7_m_axis_rx_tvalid_check = '1' ) then
			v7_m_axis_rx_tvalid_check <= '0';
		elsif (v7_m_axis_rx_tvalid = '1' and v6_trn_rdst_rdy_n = '0' and v7_m_axis_rx_tvalid_check = '0') then
			v7_m_axis_rx_tvalid_check <=  '1';
		else 
			v7_m_axis_rx_tvalid_check <= v7_m_axis_rx_tvalid_check;
		end if;
	end if;
  end process;
  
  
			
			
  v6_trn_rsof_n <= not (v7_m_axis_rx_tvalid and (not v7_m_axis_rx_tvalid_check) and (not v6_trn_rdst_rdy_n));
  v6_trn_rd <= v7_m_axis_rx_tdata(31 downto 0) & v7_m_axis_rx_tdata(63 downto 32);
  v6_trn_rrem_n <= '1' when v7_m_axis_rx_tkeep = x"0f"  else '0' ;  
  v6_trn_reof_n <= not v7_m_axis_rx_tlast;
  v6_trn_rerrfwd_n <= not v7_m_axis_rx_tuser(1);
  v6_trn_rsrc_rdy_n <= not v7_m_axis_rx_tvalid;
  v6_trn_rsrc_dsc_n <= '1';
  v6_trn_rbar_hit_n <= v7_m_axis_rx_tuser(8 downto 2);
  v7_m_axis_rx_tready <= not v6_trn_rdst_rdy_n;
  
  -- constantly asserted rx_np_req
  v7_rx_np_req <= '1';
  v7_rx_np_ok <= not v6_trn_rnp_ok_n;
  
  --flow control
  v6_trn_fc_cpld <= v7_fc_cpld;
  v6_trn_fc_cplh <= v7_fc_cplh;
  v6_trn_fc_npd <= v7_fc_npd;
  v6_trn_fc_nph <= v7_fc_nph;
  v6_trn_fc_pd <= v7_fc_pd;
  v6_trn_fc_ph <= v7_fc_ph;
  v7_fc_sel <= v6_trn_fc_sel;
      
  -- configuration
	v6_cfg_do <= v7_cfg_mgmt_do;
	v6_cfg_rd_wr_done_n <= not v7_cfg_mgmt_rd_wr_done;
	v7_cfg_mgmt_di <= v6_cfg_di;
	v7_cfg_mgmt_byte_en <= not v6_cfg_byte_en_n;
    v7_cfg_mgmt_dwaddr  <= v6_cfg_dwaddr;
    v7_cfg_mgmt_wr_en   <= not v6_cfg_wr_en_n;
    v7_cfg_mgmt_rd_en <= not v6_cfg_rd_en_n;
    v7_cfg_mgmt_wr_readonly <= '0';
	
	v7_cfg_err_cor <= not v6_cfg_err_cor_n;
	v7_cfg_err_ur <= not v6_cfg_err_ur_n;
	v7_cfg_err_ecrc <= not v6_cfg_err_ecrc_n;
	v7_cfg_err_cpl_timeout <= not v6_cfg_err_cpl_timeout_n;
	v7_cfg_err_cpl_unexpect <= not v6_cfg_err_cpl_unexpect_n;
	v7_cfg_err_cpl_abort <= not v6_cfg_err_cpl_abort_n;
	v7_cfg_err_posted <= not v6_cfg_err_posted_n;
    v7_cfg_err_locked <= not v6_cfg_err_locked_n;                 
    v7_cfg_err_tlp_cpl_header <=   v6_cfg_err_tlp_cpl_header;                        
	v6_cfg_err_cpl_rdy_n <= not v7_cfg_err_cpl_rdy;						  
    v7_cfg_interrupt <= not  v6_cfg_interrupt_n;
	v6_cfg_interrupt_rdy_n <= not  v7_cfg_interrupt_rdy;
    v7_cfg_interrupt_assert <= not v6_cfg_interrupt_assert_n;                    
    v7_cfg_interrupt_di <= v6_cfg_interrupt_di;                     
    v6_cfg_interrupt_do <= v7_cfg_interrupt_do;                        
    v6_cfg_interrupt_mmenable <= v7_cfg_interrupt_mmenable;                    
    v6_cfg_interrupt_msienable <=  v7_cfg_interrupt_msienable;
	v6_cfg_interrupt_msixenable <= v7_cfg_interrupt_msixenable;
	v6_cfg_interrupt_msixfm <= v7_cfg_interrupt_msixfm;
    v7_cfg_turnoff_ok <= not v6_cfg_turnoff_ok_n;
	v6_cfg_to_turnoff_n <= not v7_cfg_to_turnoff;
	v7_cfg_trn_pending <= not v6_cfg_trn_pending_n;
    v7_cfg_pm_wake <= not v6_cfg_pm_wake_n;              
    v6_cfg_bus_number <= v7_cfg_bus_number;
	v6_cfg_device_number <= v7_cfg_device_number;
	v6_cfg_function_number <= v7_cfg_function_number;
	v6_cfg_status <= v7_cfg_status;
	v6_cfg_command <= v7_cfg_command;
	v6_cfg_dstatus <= v7_cfg_dstatus;
	v6_cfg_dcommand <= v7_cfg_dcommand;
	v6_cfg_lstatus <= v7_cfg_lstatus;
	v6_cfg_lcommand <= v7_cfg_lcommand;
	v6_cfg_dcommand2 <= v7_cfg_dcommand2;
	v6_cfg_pcie_link_state_n <= not v7_cfg_pcie_link_state;
	v7_cfg_dsn <= v6_cfg_dsn;
	v6_cfg_pmcsr_pme_en <= v7_cfg_pmcsr_pme_en;
	v6_cfg_pmcsr_pme_status <= v7_cfg_pmcsr_pme_status;
	v6_cfg_pmcsr_powerstate <= v7_cfg_pmcsr_powerstate;
	
    v7_cfg_err_atomic_egress_blocked <= '0';
	v7_cfg_err_internal_cor <= '0';
	v7_cfg_err_malformed <= '0';
	v7_cfg_err_mc_blocked <= '0';
	v7_cfg_err_poisoned <= '0';
    v7_cfg_err_norecovery <= '0';
    v7_cfg_err_acs <= '0';
	v7_cfg_err_internal_uncor <= '0';
                                     

     
	v7_cfg_mgmt_wr_rw1c_as_rw <= '0';
    v7_cfg_pm_send_pme_to <= '0'; 
	v7_cfg_ds_bus_number <= x"00"; 
    v7_cfg_ds_device_number <= B"00000";
	v7_cfg_ds_function_number <= B"000";
	
	v7_cfg_pm_halt_aspm_l0s <= '0';					  
	v7_cfg_pm_halt_aspm_l1 <= '0';					  
	v7_cfg_pm_force_state_en <= '0';
	v7_cfg_pm_force_state <= B"00";

	v7_cfg_interrupt_stat <= '0';
	v7_cfg_pciecap_interrupt_msgnum <= b"0_0000";
	                        

	------------------------------------------------
	v6_pl_initial_link_width <= v7_pl_initial_link_width;
	v6_pl_lane_reversal_mode <= v7_pl_lane_reversal_mode;
	v6_pl_link_gen2_capable <= v7_pl_link_gen2_cap;
	v6_pl_link_upcfg_capable <= v7_pl_link_upcfg_cap;
	v6_pl_link_partner_gen2_supported <= v7_pl_link_partner_gen2_supported;
	v6_pl_ltssm_state <= v7_pl_ltssm_state;
	v6_pl_sel_link_rate <= v7_pl_sel_lnk_rate;
	v6_pl_sel_link_width <= v7_pl_sel_lnk_width;
	
	v6_pl_received_hot_rst <= v7_pl_received_hot_rst;
	v7_pl_directed_link_change <= v6_pl_directed_link_change;
	v7_pl_directed_link_width <= v6_pl_directed_link_width;
	v7_pl_directed_link_speed <= v6_pl_directed_link_speed;
	v7_pl_directed_link_auton <= v6_pl_directed_link_auton;
	v7_pl_upstream_prefer_deemph <= v6_pl_upstream_prefer_deemph;
	
                                
	v7_pl_transmit_hot_rst <= '0';
	v7_pl_downstream_deemph_source <= '0';
	v7_cfg_err_aer_headerlog <= (others => '0');
	v7_cfg_aer_interrupt_msgnum <= B"00000";
	
	v7_sys_clk <= v6_sys_clk;
	v7_sys_reset <= not v6_sys_reset_n;
	    
end rtl;
