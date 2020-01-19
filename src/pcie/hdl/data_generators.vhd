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

entity data_generators is

port (

	clk	: in std_logic; 
	rst : in std_logic;
	
	-- user interface
	user_wdata_en : out std_logic;
	user_wdata : out std_logic_vector(63 downto 0);
	user_wdata_rdy : in std_logic;	
	user_waddr_en : out std_logic;
	user_waddr : out std_logic_vector(31 downto 0)
	
);
end data_generators;
    
architecture rtl of data_generators is

begin

	-- user defined
	user_wdata_en <= '0';
	user_wdata <= (others => '0');
	user_waddr_en <= '0';
	user_waddr <= (others => '0');
	
end rtl; 

