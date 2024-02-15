library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity Simeck32_64 is

	port 
	(
		clk	   : in std_logic;
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

--signal s_count_load : std_logic_vector((COUNT_SIZE_load-1) downto 0);
signal s_count_run : std_logic_vector((COUNT_SIZE_run-1) downto 0);

signal s_sim_con0  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_sim_con1  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_mode 	   : std_logic;

signal s_ramwe	      : std_logic;
--signal s_ram_enc_dec  : std_logic; 
signal s_count_ram    : std_logic_vector((RAM_SIZE-1) downto 0);
signal s_key_ram_in0  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_key_ram_in1  : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_key_ram_out0 : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_key_ram_out1 : std_logic_vector(DATAPATH_SIZE-1 downto 0);

begin
 
--s_ram_enc_dec <= key_cph and enc_dec;

U_con_path:control_path 
 port map( 
  clk 		=> clk,
  rst 		=> rst,
  --C 		=> C,
  key_cph 	=> key_cph,
  enc_dec 	=> enc_dec,	
  mode 		=> s_mode,
  key_expanding => s_ramwe,
  outp_valid 	=> outp_valid,
  Round_count 	=> s_count_run,
  ram_count  	=> s_count_ram,
  sim_con0	=> s_sim_con0,
  sim_con1	=> s_sim_con1
);
 
U_dtpath:datapath 
 port map(
  clk 	 	       => clk,
  rst 		       => rst,
  mode 		       => s_mode,
  --ramwe 	       => s_ramwe,
  --enc_dec 	       => enc_dec,	
  --Key 		   => Key,
  Data_in 	       => Data_in,
  Simeck_constant0 => s_sim_con0,
  Simeck_constant1 => s_sim_con1,
  key0_in      	   => s_key_ram_out0,
  key1_in          => s_key_ram_out1,
  --count_run 	   => s_count_run,
  key0_out         => s_key_ram_in0,
  key1_out         => s_key_ram_in1,
  Data_out 	       => Data_out
);

U_key_ram:ram
 port map( 
  clk	      => clk,
  --rst	      => rst,	
  ramwe	      => s_ramwe,	
  enc_dec     => enc_dec,
  ramaddress  => s_count_ram,
  ramin0      => s_key_ram_in0,
  ramin1      => s_key_ram_in1,
  ramout0     => s_key_ram_out0,
  ramout1     => s_key_ram_out1            
);

end rtl;
