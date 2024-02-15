library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity key_expand_function_2stage is
	
	port 
	(
		clk     : in std_logic;
		rstreg  : in std_logic;
		mode    : in std_logic;
		--key0_in  : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		--key1_in  : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		--key2_in  : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		--key3_in  : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		sim_con0 : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		sim_con1 : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		key0_out : out std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		key1_out : out std_logic_vector ((DATAPATH_SIZE-1) downto 0)
	);

end entity key_expand_function_2stage;

architecture rtl of key_expand_function_2stage is

signal s_nmode   : std_logic;

signal s_rf0_mx2 : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_rf1_mx3 : std_logic_vector(DATAPATH_SIZE-1 downto 0);

signal s_mx0_r0  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_mx1_r1  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_mx2_r2  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_mx3_r3  : std_logic_vector(DATAPATH_SIZE-1 downto 0);

signal s_r3_out  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_r2_out  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_r1_out  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_r0_out  : std_logic_vector(DATAPATH_SIZE-1 downto 0);

signal s_key : std_logic_vector((4*DATAPATH_SIZE-1) downto 0) := Key;

begin

key0_out <= s_r0_out;
key1_out <= s_r1_out;

U_mux0:mux2to1 
 port map(
  modemux => mode,
  inp0	  => s_r2_out,
  --inp1	  => key0_in,
  inp1	  => s_key((DATAPATH_SIZE-1) downto 0),
  outp	  => s_mx0_r0
);

U_reg0:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  clk	  => clk,
  rstreg  => rstreg,
  en	  => '1', 
  datain  => s_mx0_r0,
  dataout => s_r0_out
);

U_mux1:mux2to1 
 port map(
  modemux => mode,
  inp0	  => s_r3_out,
  --inp1	  => key1_in,
  inp1	  => s_key((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE),
  outp	  => s_mx1_r1
);

U_reg1:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  clk	  => clk,
  rstreg  => rstreg,
  en	  => '1', 
  datain  => s_mx1_r1,
  dataout => s_r1_out
);

U_mux2:mux2to1 
 port map(
  modemux => mode,
  inp0	  => s_rf0_mx2,
  --inp1	  => key2_in,
  inp1	  => s_key((3*DATAPATH_SIZE-1) downto 2*DATAPATH_SIZE),
  outp	  => s_mx2_r2
);

U_reg2:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  clk	  => clk,
  rstreg  => rstreg,
  en	  => '1', 
  datain  => s_mx2_r2,
  dataout => s_r2_out
);

U_mux3:mux2to1 
 port map(
  modemux => mode,
  inp0	  => s_rf1_mx3,
  --inp1	  => key3_in,
  inp1	  => s_key((4*DATAPATH_SIZE-1) downto 3*DATAPATH_SIZE),
  outp	  => s_mx3_r3
);

U_reg3:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  clk	  => clk,
  rstreg  => rstreg,
  en	  => '1', 
  datain  => s_mx3_r3,
  dataout => s_r3_out
);
 
U_com_cic0:rf_comb_cic
 port map(
  inpb => s_r1_out,
  inpa => s_r0_out,
  inpk => sim_con0,
  outp => s_rf0_mx2
); 

U_com_cic1:rf_comb_cic
 port map(
  inpb => s_r2_out,
  inpa => s_r1_out,
  inpk => sim_con1,
  outp => s_rf1_mx3
); 

end rtl;
