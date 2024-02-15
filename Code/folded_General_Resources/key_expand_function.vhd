library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity key_expand_function is
	
	port 
	(
		clk     : in std_logic;
		rstreg  : in std_logic;
		mode    : in std_logic;
		key_in  : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		sim_con : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		key_out : out std_logic_vector ((DATAPATH_SIZE-1) downto 0)
	);

end entity key_expand_function;

architecture rtl of key_expand_function is

signal s_con_mx : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_mx_rd  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_rd_rc  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_rc_rb  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_rbout  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_raout  : std_logic_vector(DATAPATH_SIZE-1 downto 0);

begin

U_mux0:mux2to1 
 port map(
  modemux => mode,
  inp0	  => s_con_mx,
  inp1	  => key_in,
  outp	  => s_mx_rd
);

U_regd:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  clk	  => clk,
  rstreg  => rstreg,
  en	  => '1',
  datain  => s_mx_rd,
  dataout => s_rd_rc
);

U_regc:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  clk	  => clk,
  rstreg  => rstreg,
  en	  => '1',
  datain  => s_rd_rc,
  dataout => s_rc_rb
);
 
U_regb:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  clk	   => clk,
  rstreg  => rstreg,
  en	   => '1', 
  datain  => s_rc_rb,
  dataout => s_rbout
); 
 
U_rega:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  clk	    => clk,
  rstreg  => rstreg,
  en	    => '1', 
  datain  => s_rbout,
  dataout => s_raout
); 
 
U_com_cic:rf_comb_cic
 port map(
  inpb => s_rbout,
  inpa => s_raout,
  inpk => sim_con,
  outp => s_con_mx
); 

key_out <= s_raout;

end rtl;