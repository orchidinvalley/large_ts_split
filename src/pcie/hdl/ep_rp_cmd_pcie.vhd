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
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
library unisim;
use unisim.vcomponents.all;

entity ep_rp_cmd_pcie is
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
end ep_rp_cmd_pcie;

architecture structure of ep_rp_cmd_pcie is

begin   	
	-- user defined
	mailbox_wen_porta <= '0';
	mailbox_wen_addr_porta <= (others => '0');
	mailbox_wen_din_porta <= (others => '0');  
   
end structure;
