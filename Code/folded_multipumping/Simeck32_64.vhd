library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity Simeck32_64 is

	port 
	(
		clk	       : in std_logic;
		clk_mp     : in std_logic;
		rst	       : in std_logic;
		key_cph    : in std_logic;
		enc_dec    : in std_logic;
		Data_in	   : in std_logic_vector ((2*DATAPATH_SIZE-1) downto 0);
		--Key	   : in std_logic_vector ((4*DATAPATH_SIZE-1) downto 0);
		outp_valid : out std_logic;
		Data_out   : out std_logic_vector ((2*DATAPATH_SIZE-1) downto 0)
	);

end entity Simeck32_64;

architecture rtl of Simeck32_64 is

signal s_count_load    : std_logic_vector((COUNT_SIZE_load-1) downto 0);
signal s_count_run     : std_logic_vector((COUNT_SIZE_run-1) downto 0);
signal s_sim_con       : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_mode 	       : std_logic;
signal s_ramwe	       : std_logic;
signal s_key_ram_in    : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_key_ram_out   : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_mx_con_key_rf : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_dtp_out       : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
signal s_cr	       : std_logic_vector((COUNT_SIZE_run-1) downto 0);

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
  key_cph 	  => key_cph,
  --Key 		  => Key,
  Data_in 	  => Data_in,
  sc_key 	  => s_mx_con_key_rf,
  count_load 	  => s_count_load,
  --count_run 	  => s_count_run,
  Data_out 	  => s_dtp_out
);

Data_out <= s_dtp_out;
s_key_ram_in <= s_dtp_out((DATAPATH_SIZE-1) downto 0);

U_key_ram:ram
 port map( 
  clk	     => clk,
  --rst	     => rst,
  --mode 	     => s_mode,
  --enc_dec    => enc_dec,	
  ramwe	     => s_ramwe,
  ramaddress => s_cr,
  ramin	     => s_key_ram_in,
  ramout     => s_key_ram_out            
);

U_mux_con_key:mux2to1
 generic map(DATAPATH_SIZE => DATAPATH_SIZE) 
 port map(
  modemux => key_cph,
  inp0	  => s_key_ram_out,
  inp1	  => s_sim_con,
  outp	  => s_mx_con_key_rf
);

proc:process (s_ramwe,s_mode, enc_dec, s_count_run)

variable cr : std_logic_vector((COUNT_SIZE_run-1) downto 0):= (others => '1');

begin

if (s_ramwe = '1') then
 cr := s_count_run;
else
 if (s_mode = '0' and enc_dec = '0') then
	cr := (others => '0');
 elsif (s_mode = '0' and enc_dec = '1') then
	cr := (others => '1');
 else
 	if (enc_dec = '0') then
	 	 cr := std_logic_vector(unsigned(s_count_run)+1);
 	else 
	 	 cr := std_logic_vector(unsigned(s_count_run)-1);
 	end if;
 end if;
end if;

s_cr <= cr;

end process;

end rtl;
