
-- VHDL Instantiation Created from source file pcie_dma_core_ep.vhd -- 10:42:58 04/23/2014
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT pcie_dma_core_ep
	PORT(
		pci_exp_rxp : IN std_logic_vector(3 downto 0);
		pci_exp_rxn : IN std_logic_vector(3 downto 0);
		sys_clk_c : IN std_logic;
		clk200 : IN std_logic;
		sys_reset_n : IN std_logic;
		descriptors_buffers_dout_portb : IN std_logic_vector(31 downto 0);
		mailbox_wen_dout_portb : IN std_logic_vector(31 downto 0);
		user_waddr_en : IN std_logic;
		user_waddr : IN std_logic_vector(31 downto 0);
		user_wdata_en : IN std_logic;
		user_wdata : IN std_logic_vector(63 downto 0);
		user_raddr_en : IN std_logic;
		user_raddr : IN std_logic_vector(31 downto 0);
		user_rdata_en : IN std_logic;
		dma_wdata_rdy : IN std_logic;
		dma_rdata : IN std_logic_vector(63 downto 0);
		dma_rdata_rdy : IN std_logic;
		dma_rdata_busy : IN std_logic;
		soft_rst_ep : IN std_logic;
		dma_start : IN std_logic;
		dma_cmd_addr : IN std_logic_vector(15 downto 0);
		dma_cmd_din : IN std_logic_vector(31 downto 0);
		dma_cmd_wen : IN std_logic;
		dma_cmd_ren : IN std_logic;
		user_cmd_from_rp_rdy : IN std_logic;
		user_cmd_from_rp_rdata : IN std_logic_vector(31 downto 0);
		user_cmd_to_rp_wen : IN std_logic;
		user_cmd_to_rp_addr : IN std_logic_vector(31 downto 0);
		user_cmd_to_rp_wdata : IN std_logic_vector(31 downto 0);
		user_cmd_to_rp_ren : IN std_logic;
		logic_int_en : IN std_logic;          
		pci_exp_txp : OUT std_logic_vector(3 downto 0);
		pci_exp_txn : OUT std_logic_vector(3 downto 0);
		dma_write_start : OUT std_logic;
		dma_write_end : OUT std_logic;
		dma_read_start : OUT std_logic;
		dma_read_end : OUT std_logic;
		descriptors_buffers_addr_portb : OUT std_logic_vector(9 downto 0);
		descriptors_buffers_din_portb : OUT std_logic_vector(31 downto 0);
		descriptors_buffers_we_portb : OUT std_logic;
		mailbox_wen_din_portb : OUT std_logic_vector(31 downto 0);
		mailbox_wen_portb : OUT std_logic;
		mailbox_wen_addr_portb : OUT std_logic_vector(10 downto 0);
		dma_resetout : OUT std_logic;
		trn_clkout : OUT std_logic;
		phy_init_doneout : OUT std_logic;
		debug : OUT std_logic_vector(7 downto 0);
		user_wdata_rdy : OUT std_logic;
		user_rdata_busy : OUT std_logic;
		user_rdata_rdy : OUT std_logic;
		user_rdata : OUT std_logic_vector(63 downto 0);
		dma_waddr_en : OUT std_logic;
		dma_waddr : OUT std_logic_vector(31 downto 0);
		dma_wdata_en : OUT std_logic;
		dma_wdata : OUT std_logic_vector(63 downto 0);
		dma_rdata_en : OUT std_logic;
		dma_raddr_en : OUT std_logic;
		dma_raddr : OUT std_logic_vector(31 downto 0);
		dma_end : OUT std_logic;
		dma_cmd_rdy : OUT std_logic;
		dma_cmd_dout : OUT std_logic_vector(31 downto 0);
		user_cmd_from_rp_wen : OUT std_logic;
		user_cmd_from_rp_addr : OUT std_logic_vector(31 downto 0);
		user_cmd_from_rp_wdata : OUT std_logic_vector(31 downto 0);
		user_cmd_from_rp_ren : OUT std_logic;
		user_cmd_to_rp_wack : OUT std_logic;
		user_cmd_to_rp_rdata : OUT std_logic_vector(31 downto 0);
		user_cmd_to_rp_rdy : OUT std_logic;
		logic_int_en_ack : OUT std_logic
		);
	END COMPONENT;

	Inst_pcie_dma_core_ep: pcie_dma_core_ep PORT MAP(
		pci_exp_txp => ,
		pci_exp_txn => ,
		pci_exp_rxp => ,
		pci_exp_rxn => ,
		sys_clk_c => ,
		clk200 => ,
		sys_reset_n => ,
		dma_write_start => ,
		dma_write_end => ,
		dma_read_start => ,
		dma_read_end => ,
		descriptors_buffers_addr_portb => ,
		descriptors_buffers_dout_portb => ,
		descriptors_buffers_din_portb => ,
		descriptors_buffers_we_portb => ,
		mailbox_wen_dout_portb => ,
		mailbox_wen_din_portb => ,
		mailbox_wen_portb => ,
		mailbox_wen_addr_portb => ,
		dma_resetout => ,
		trn_clkout => ,
		phy_init_doneout => ,
		debug => ,
		user_waddr_en => ,
		user_waddr => ,
		user_wdata_en => ,
		user_wdata => ,
		user_wdata_rdy => ,
		user_raddr_en => ,
		user_raddr => ,
		user_rdata_busy => ,
		user_rdata_rdy => ,
		user_rdata_en => ,
		user_rdata => ,
		dma_waddr_en => ,
		dma_waddr => ,
		dma_wdata_en => ,
		dma_wdata => ,
		dma_wdata_rdy => ,
		dma_rdata_en => ,
		dma_rdata => ,
		dma_raddr_en => ,
		dma_raddr => ,
		dma_rdata_rdy => ,
		dma_rdata_busy => ,
		soft_rst_ep => ,
		dma_start => ,
		dma_end => ,
		dma_cmd_addr => ,
		dma_cmd_din => ,
		dma_cmd_wen => ,
		dma_cmd_ren => ,
		dma_cmd_rdy => ,
		dma_cmd_dout => ,
		user_cmd_from_rp_wen => ,
		user_cmd_from_rp_addr => ,
		user_cmd_from_rp_wdata => ,
		user_cmd_from_rp_ren => ,
		user_cmd_from_rp_rdy => ,
		user_cmd_from_rp_rdata => ,
		user_cmd_to_rp_wen => ,
		user_cmd_to_rp_addr => ,
		user_cmd_to_rp_wdata => ,
		user_cmd_to_rp_wack => ,
		user_cmd_to_rp_ren => ,
		user_cmd_to_rp_rdata => ,
		user_cmd_to_rp_rdy => ,
		logic_int_en => ,
		logic_int_en_ack => 
	);


