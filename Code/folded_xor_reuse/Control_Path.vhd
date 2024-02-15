library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity control_path is
	
	port 
	(
		clk	      : in std_logic;
		rst	      : in std_logic;
		C	      : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		key_cph       : in std_logic;
		enc_dec       : in std_logic;
		mode	      : out std_logic;
		key_expanding : out std_logic;
	 	outp_valid    : out std_logic;
		Round_count   : out std_logic_vector((COUNT_SIZE_run-1) downto 0);
		load_count    : out std_logic_vector((COUNT_SIZE_load-1) downto 0);
		sim_con	      : out std_logic_vector((DATAPATH_SIZE-1) downto 0)	
	);

end entity control_path;

architecture rtl of control_path is

signal s_lfsr	 : std_logic_vector(G_M-1 downto 0);
signal s_mode	 : std_logic;
signal s_nmode	 : std_logic;

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
  load_count	=> load_count,
  mode		=> s_mode,
  key_expanding => key_expanding,
  outp_valid 	=> outp_valid
); 
     
U_lfsr:lfsr_fib 
 port map(
  clk	   => clk,
  rst	   => s_nmode,       
  lfsr_out => s_lfsr
);

sim_con <= C((DATAPATH_SIZE-1) downto 1) & (C(0) xor s_lfsr(0));

end rtl;