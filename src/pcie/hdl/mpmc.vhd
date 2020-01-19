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
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity mpmc is
port (
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
	ui_clk       : in std_logic;

	debug : out std_logic_vector(1 downto 0)
);
end mpmc;
    
architecture rtl of mpmc is

begin
	
end rtl; -- mpmc

