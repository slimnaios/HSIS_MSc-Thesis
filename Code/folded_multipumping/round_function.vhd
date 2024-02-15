library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity round_function is
	
	port 
	(
		clk	: in std_logic;
		clk_mp  : in std_logic;
		rstreg  : in std_logic;
		mode    : in std_logic;
		Data_in	: in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		key	: in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		mi      : out std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		Data_out: out std_logic_vector ((DATAPATH_SIZE-1) downto 0)
	);

end entity round_function;

architecture rtl of round_function is

signal s_k_mx  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_mx_rb : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_rbout : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_raout : std_logic_vector(DATAPATH_SIZE-1 downto 0);

begin

U_mux0:mux2to1
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  modemux => mode,
  inp0	  => s_k_mx,
  inp1	  => Data_in,
  outp	  => s_mx_rb
);

U_regb:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE)  
 port map(
  clk	  => clk,
  rstreg  => rstreg,
  en	  => '1',
  datain  => s_mx_rb,
  dataout => s_rbout
);

U_rega:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE)  
 port map(
  clk	  => clk,
  rstreg  => rstreg,
  en	  => '1',
  datain  => s_rbout,
  dataout => s_raout
);
 
U_com_cic:rf_comb_cic 
 port map(
  clk_mp  => clk_mp,
  inpb => s_rbout,
  inpa => s_raout,
  inpk => key,
  outp => s_k_mx
);

Data_out <= s_raout;
mi <= s_rbout;

end rtl;