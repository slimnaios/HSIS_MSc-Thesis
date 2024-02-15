library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity Simeck32_64 is

	port 
	(
		clk	   : in std_logic;
		clk_mp	   : in std_logic;
		rst	   : in std_logic;
		key_cph    : in std_logic;
		enc_dec    : in std_logic;
		Data_in	   : in std_logic_vector ((2*DATAPATH_SIZE-1) downto 0);
		--Key	   : in std_logic_vector ((4*DATAPATH_SIZE-1) downto 0);
		outp_valid : out std_logic;
		Data_out   : out std_logic_vector ((2*DATAPATH_SIZE-1) downto 0)
	);

end entity Simeck32_64;

architecture rtl of Simeck32_64 is

signal s_count_load : std_logic_vector((COUNT_SIZE_load-1) downto 0);
signal s_count_run  : std_logic_vector((COUNT_SIZE_run-1) downto 0);
signal s_sim_con    : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_mode 	    : std_logic;
signal s_ramwe	    : std_logic;

begin
 
U_con_path:control_path 
 port map( 
  clk 		=> clk,
  rst 		=> rst,
  C 		=> C,
  key_cph 	=> key_cph,
  enc_dec 	=> enc_dec,	
  mode 		=> s_mode,
  key_expanding => s_ramwe,
  outp_valid 	=> outp_valid,
  Round_count 	=> s_count_run,
  load_count 	=> s_count_load,
  sim_con	=> s_sim_con
);
 
U_dtpath:datapath 
 port map(
  clk 	 	  => clk,
  clk_mp      => clk_mp,
  rst 		  => rst,
  mode 		  => s_mode,
  ramwe 	  => s_ramwe,	
  Key 		  => Key,
  Data_in 	  => Data_in,
  Simeck_constant => s_sim_con,
  count_load 	  => s_count_load,
  count_run 	  => s_count_run,
  Data_out 	  => Data_out
);

end rtl;
