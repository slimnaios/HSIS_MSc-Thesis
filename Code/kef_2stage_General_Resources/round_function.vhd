library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity round_function is
	
	port 
	(
		clk	  : in std_logic;
		rst       : in std_logic;
		mode      : in std_logic;
		Data_in	  : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
		key0	  : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		key1	  : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		Data_out  : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0)
	);

end entity round_function;

architecture rtl of round_function is

signal s_rf_out : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);

signal s_mx0_r0 : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_mx1_r1 : std_logic_vector(DATAPATH_SIZE-1 downto 0);

signal plaintext : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);

begin

U_mux0:mux2to1 
 port map(
  modemux => mode,
  inp0	  => s_rf_out((DATAPATH_SIZE-1) downto 0),
  inp1	  => Data_in((DATAPATH_SIZE-1) downto 0),
  outp	  => s_mx0_r0
);

U_mux1:mux2to1 
 port map(
  modemux => mode,
  inp0	  => s_rf_out((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE),
  inp1	  => Data_in((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE),
  outp	  => s_mx1_r1
);

plaintext <= s_mx1_r1 & s_mx0_r0;

U_rnd_fn:rf_round_2stage
port map(
  clk	    => clk,
  rst       => rst, 
  Data_in   => plaintext,	
  key0	    => key0,
  key1	    => key1,
  Data_out  => s_rf_out
);

Data_out <= s_rf_out;

end rtl;