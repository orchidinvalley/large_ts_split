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

entity user_generators_ep is
  generic (
    EP_ID	: integer
    );
  port (
    -- Board-level reference clock
  clk : in std_logic;
  rst : in std_logic;
  
  dma_cmd_addr : out std_logic_vector(15 downto 0);
  dma_cmd_din : out std_logic_vector(31 downto 0);
  dma_cmd_wen : out std_logic;
  dma_cmd_ren : out std_logic;
  dma_cmd_rdy : in std_logic;
  dma_cmd_dout : in std_logic_vector(31 downto 0);
  
  descriptors_buffers_wea : out std_logic_vector(0 downto 0);
  descriptors_buffers_waddr : out std_logic_vector(9 downto 0);
  descriptors_buffers_din : out std_logic_vector(31 downto 0)
    );

end user_generators_ep;

architecture rtl of user_generators_ep is 

begin
	
	-- user defined
	dma_cmd_addr <= (others => '0');
	dma_cmd_din <= (others => '0');
	dma_cmd_wen <= '0';
	dma_cmd_ren <= '0';
	
	descriptors_buffers_wea(0) <= '0'; 
	descriptors_buffers_waddr <= (others => '0');
	descriptors_buffers_din <= (others => '0');
  
end rtl;
