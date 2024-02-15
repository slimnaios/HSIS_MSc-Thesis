library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity datapath is
	
	port 
	(
		clk	       : in std_logic;
		rst 	   : in std_logic;
		mode 	   : in std_logic;
		key_cph    : in std_logic;
		--Key	       : in std_logic_vector((4*DATAPATH_SIZE-1) downto 0);
		Data_in	   : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
		sc_key 	   : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		count_load : in std_logic_vector((COUNT_SIZE_load-1) downto 0);
		--count_run  : in std_logic_vector((COUNT_SIZE_run-1) downto 0);
		Data_out   : out std_logic_vector ((2*DATAPATH_SIZE-1) downto 0)
	);

end entity datapath;

architecture rtl of datapath is

signal s_key_load  : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_data_load : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_rd_rc     : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_rc_mx2    : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_mx1_rd    : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_rbout     : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_raout     : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_con_mxs   : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_mx2_mx0   : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_mx0_rb    : std_logic_vector((DATAPATH_SIZE-1) downto 0);

signal s_nrst	       : std_logic;
signal s_plaintext_sel : std_logic;
signal s_ld_key_cph    : std_logic;	

signal s_key : std_logic_vector((4*DATAPATH_SIZE-1) downto 0) := Key;

begin

s_nrst <= not(rst);
s_plaintext_sel <= not(count_load(0) or count_load(1));

ld_key_cph_proc:process(key_cph,mode)
begin

	if key_cph = '0' then				 
 	 s_ld_key_cph <= '1';
	else 
	 s_ld_key_cph <= mode;
	end if;

end process;

U_mux4to1:mux4to1
 port map(
  sel  => count_load,
--  inp0 => Key((DATAPATH_SIZE-1) downto 0),
--  inp1 => Key((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE),
--  inp2 => Key((3*DATAPATH_SIZE-1) downto 2*DATAPATH_SIZE),
--  inp3 => Key((4*DATAPATH_SIZE-1) downto 3*DATAPATH_SIZE),
  inp0 => s_key((DATAPATH_SIZE-1) downto 0),
  inp1 => s_key((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE),
  inp2 => s_key((3*DATAPATH_SIZE-1) downto 2*DATAPATH_SIZE),
  inp3 => s_key((4*DATAPATH_SIZE-1) downto 3*DATAPATH_SIZE),
  outp => s_key_load          
);

U_mux2to1:mux2to1
 port map( 
  modemux => s_plaintext_sel,
  inp0	  => Data_in((DATAPATH_SIZE-1) downto 0),
  inp1	  => Data_in((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE),
  outp	  => s_data_load          
);   

U_mux1:mux2to1 
 port map(
  modemux => mode,
  inp0	  => s_con_mxs,
  inp1	  => s_key_load,
  outp	  => s_mx1_rd
);

U_regd:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  clk	  => clk,
  rstreg  => rst,
  en	  => '1',
  datain  => s_mx1_rd,
  dataout => s_rd_rc
);

U_regc:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  clk	  => clk,
  rstreg  => rst,
  en	  => '1',
  datain  => s_rd_rc,
  dataout => s_rc_mx2
);

U_mux2:mux2to1 
 port map(
  modemux => key_cph,
  inp0	  => s_con_mxs,
  inp1	  => s_rc_mx2,
  outp	  => s_mx2_mx0
);

U_mux0:mux2to1 
 port map(
  modemux => s_ld_key_cph,
  inp0	  => s_mx2_mx0,
  inp1	  => s_data_load,
  outp	  => s_mx0_rb
);

U_regb:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  clk	  => clk,
  rstreg  => rst,
  en	  => '1', 
  datain  => s_mx0_rb,
  dataout => s_rbout
); 
 
U_rega:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  clk	  => clk,
  rstreg  => rst,
  en	  => '1', 
  datain  => s_rbout,
  dataout => s_raout
); 
 
U_com_cic:rf_comb_cic
 port map(clk => clk,
  inpb => s_rbout,
  inpa => s_raout,
  inpk => sc_key,
  outp => s_con_mxs
); 

Data_out((DATAPATH_SIZE-1) downto 0) <= s_raout;
Data_out((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE) <= s_rbout;

end rtl;