library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity control_path is
	
	port 
	(
		clk	          : in std_logic;
		rst	          : in std_logic;
		--C	          : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		key_cph       : in std_logic;
		enc_dec       : in std_logic;
		mode	      : out std_logic;
		key_expanding : out std_logic;
	 	outp_valid    : out std_logic;
		Round_count   : out std_logic_vector((COUNT_SIZE_run-1) downto 0);
		ram_count     : out std_logic_vector((RAM_SIZE-1) downto 0);
		sim_con0      : out std_logic_vector((DATAPATH_SIZE-1) downto 0);
		sim_con1      : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
	);

end entity control_path;

architecture rtl of control_path is

signal s_mode  : std_logic;
signal s_nmode : std_logic;

begin

mode <= s_mode;
s_nmode <= not(s_mode);

U_s_m:fsm
 port map(
  clk 		=> clk,
  rst 		=> rst,
  key_cph	=> key_cph,
  enc_dec	=> enc_dec,
  Round_count	=> Round_count,
  --load_count	=> load_count,
  ram_count     => ram_count,
  mode		=> s_mode,
  key_expanding => key_expanding,
  outp_valid 	=> outp_valid
); 
     
U_k_c_p:key_const_prod_2stage
 port map(
  clk	           => clk,
  rst	           => s_nmode,                                  
  Simeck_constant0 => sim_con0,
  Simeck_constant1 => sim_con1
);

end rtl;