library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity rf_round_2stage is
	
	port 
	(
		clk	  : in std_logic;
		rst       : in std_logic;
		Data_in	  : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
		key0	  : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		key1	  : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		Data_out  : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0)
	);

end entity rf_round_2stage;

architecture rtl of rf_round_2stage is

signal s_r0_out : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_r1_out : std_logic_vector(DATAPATH_SIZE-1 downto 0);

signal rf_stage_0_out : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal rf_stage_1_out : std_logic_vector((DATAPATH_SIZE-1) downto 0);

begin

U_reg0:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE)  
 port map(
  clk	  => clk,
  rstreg  => rst,
  en	  => '1',
  datain  => Data_in((DATAPATH_SIZE-1) downto 0),
  dataout => s_r0_out
);

U_reg1:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE)  
 port map(
  clk	  => clk,
  rstreg  => rst,
  en	  => '1',
  datain  => Data_in((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE),
  dataout => s_r1_out
);

U_rf0:rf_comb_cic  
 port map(
  inpb => s_r1_out,
  inpa => s_r0_out,
  inpk => key0,
  outp => rf_stage_0_out
);

U_rf1:rf_comb_cic 
 port map(
  inpb => rf_stage_0_out,
  inpa => s_r1_out,
  inpk => key1,
  outp => Data_out((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE)
);

Data_out((DATAPATH_SIZE-1) downto 0) <= rf_stage_0_out;

end rtl;