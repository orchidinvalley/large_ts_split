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

library std;
use std.textio.all;

library unisim;
use unisim.vcomponents.all;

entity data_check is

  port (
  clk : in std_logic;
  reset : in std_logic;
  
  --user interface
  user_raddr_en : out std_logic;
  user_raddr : out std_logic_vector(31 downto 0);
  user_rdata_busy : in std_logic;
  user_rdata_en : out std_logic;
  user_rdata : in std_logic_vector(63 downto 0);
  user_rdata_rdy : in std_logic
  
);
end data_check;

architecture rtl of data_check is 


begin

	-- user defined
	user_raddr_en <= '0';
	user_raddr <= (others => '0');
	user_rdata_en <= '0';
	
end rtl;
