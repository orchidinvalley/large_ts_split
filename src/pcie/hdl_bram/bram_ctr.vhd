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

entity bram_ctr is
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

end bram_ctr;

architecture rtl of bram_ctr is 
  
  

  signal bram_wea : std_logic;
  signal bram_doutb : std_logic_vector(511 downto 0);
  
  signal app_wdf_data_reg1 : std_logic_vector(255 downto 0);
  signal app_wdf_data_reg2 : std_logic_vector(255 downto 0);
  signal bram_read_en : std_logic;
  signal bram_read_en_del1 : std_logic;
  signal bram_read_en_del2 : std_logic;
  
  signal bram_waddr_int : std_logic_vector(27 downto 0);  
  signal bram_raddr_int : std_logic_vector(27 downto 0);
  
  
begin

	app_rdy <= '1';
	app_wdf_rdy <= '1';
	
	
	process (clk) 
	begin
		if clk 'event and clk = '1' then
			if rst = '1' then
				bram_waddr_int <= (others => '0');
			elsif (app_en = '1' and app_cmd = B"000") then
				bram_waddr_int <= app_addr;
			else 
				bram_waddr_int <= bram_waddr_int;
			end if;
		end if;
	end process;
	
	bram_waddr <= bram_waddr_int(15 downto 3);
	
	process (clk) 
	begin
		if clk 'event and clk = '1' then
			if rst = '1' then
				bram_wea <= '0';
			elsif (app_en = '1' and app_cmd = B"000") then
				bram_wea <= '1';
			else 
				bram_wea <= '0';
			end if;
		end if;
	end process;
	
	process (clk)
	begin
		if clk 'event and clk = '1' then
			if rst = '1' then
				app_wdf_data_reg1 <= (others => '0');
			elsif app_wdf_wren = '1' then
				app_wdf_data_reg1 <= app_wdf_data;
			else 
				app_wdf_data_reg1 <= app_wdf_data_reg1;
			end if;
		end if;
	end process;
	
	process (clk)
	begin
		if clk 'event and clk = '1' then
			if rst = '1' then
				app_wdf_data_reg2 <= (others => '0');
			elsif app_wdf_wren = '1' and app_wdf_end = '1' then
				app_wdf_data_reg2 <= app_wdf_data_reg1;
			else 
				app_wdf_data_reg2 <= app_wdf_data_reg2;
			end if;
		end if;
	end process;
	
				
	bram_dina <= app_wdf_data_reg1 & app_wdf_data_reg2;
	
	
	process (clk)
	begin
		if clk 'event and clk = '1' then
			if rst = '1' then
				bram_read_en <= '0';
			elsif (app_cmd = B"001" and app_en = '1') then
				bram_read_en <= '1';
			else 
				bram_read_en <= '0';
			end if;
		end if;
	end process;
	
	process (clk)
	begin
		if clk 'event and clk = '1' then
			if rst = '1' then
				bram_raddr_int <= (others => '0');
			elsif (app_cmd = B"001" and app_en = '1') then
				bram_raddr_int <= app_addr;
			else
				bram_raddr_int <= bram_raddr_int;
			end if;
		end if;
	end process;
	bram_raddr <= bram_raddr_int(15 downto 3);
	
	process (clk)
	begin
		if clk 'event and clk = '1' then
			if rst = '1' then
				bram_read_en_del1 <= '0';
				bram_read_en_del2 <= '0';
			else 
				bram_read_en_del1 <= bram_read_en;
				bram_read_en_del2 <= bram_read_en_del1;
			end if;
		end if;
	end process;
	
	process (clk)
	begin
		if clk 'event and clk = '1' then
			if rst = '1' then
				bram_read_en_del1 <= '0';
				bram_read_en_del2 <= '0';
			else 
				bram_read_en_del1 <= bram_read_en;
				bram_read_en_del2 <= bram_read_en_del1;
			end if;
		end if;
	end process;
			
    process (clk)
	begin
		if clk 'event and clk = '1' then
			if rst = '1' then
				app_rd_data <= (others => '0');
			elsif bram_read_en_del1 = '1' then
				app_rd_data <= bram_doutb(255 downto 0);
			else
				app_rd_data <= bram_doutb(511 downto 256);
			end if;
		end if;
	end process;
	
	process (clk)
	begin
		if clk 'event and clk = '1' then
			if rst = '1' then
				app_rd_data_end <= '0';
			else
				app_rd_data_end <= bram_read_en_del2;
			end if;
		end if;
	end process;
	
	process (clk)
	begin
		if clk 'event and clk = '1' then
			if rst = '1' then
				app_rd_data_valid <= '0';
			elsif (bram_read_en_del1 = '1'  or bram_read_en_del2 = '1') then
				app_rd_data_valid <= '1';
			else 
				app_rd_data_valid <= '0';
			end if;
		end if;
	end process;
	
	bram_wea0 <= '1' when bram_wea = '1' and bram_waddr_int(24) = '0' else '0';
	
	bram_wea1 <= '1' when bram_wea = '1' and bram_waddr_int(24) = '1' else '0';
	
	bram_doutb <= bram_doutb1 when bram_raddr_int(24) = '1' else bram_doutb0;
	
  
end rtl;
