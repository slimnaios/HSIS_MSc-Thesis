library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity datapath is
	
	port 
	(
		clk	 	 : in std_logic;
		rst 		 : in std_logic;
		mode 		 : in std_logic;
		--ramwe	 	 : in std_logic;
		--enc_dec		 : in std_logic;
		--Key		 : in std_logic_vector((4*DATAPATH_SIZE-1) downto 0);
		Data_in		 : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
		Simeck_constant0 : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		Simeck_constant1 : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		key0_in          : in std_logic_vector(DATAPATH_SIZE-1 downto 0);
		key1_in          : in std_logic_vector(DATAPATH_SIZE-1 downto 0);
		--count_run	 : in std_logic_vector((COUNT_SIZE_run-1) downto 0);
		key0_out         : out std_logic_vector(DATAPATH_SIZE-1 downto 0);
		key1_out         : out std_logic_vector(DATAPATH_SIZE-1 downto 0);
		Data_out 	 : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0)
	);

end entity datapath;

architecture rtl of datapath is

begin
    
U_kef:key_expand_function_2stage 
 port map(
  	clk	     => clk,
  	rstreg	 => '0',
  	mode	 => mode, 
	--key0_in	 => Key((DATAPATH_SIZE-1) downto 0),       
  	--key1_in	 => Key((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE), 
    --key2_in	 => Key((3*DATAPATH_SIZE-1) downto 2*DATAPATH_SIZE), 
	--key3_in	 => Key((4*DATAPATH_SIZE-1) downto 3*DATAPATH_SIZE), 
  	sim_con0 => Simeck_constant0,
	sim_con1 => Simeck_constant1,
  	key0_out => key0_out,
	key1_out => key1_out
);

U_rf:round_function 
 port map(
  	clk	      => clk,
  	rst	      => rst,
 	mode	  => mode,
	Data_in	  => Data_in,
	key0	  => key0_in,
	key1	  => key1_in,
	Data_out  => Data_out
);

end rtl;