library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity datapath is
	
	port 
	(
		clk	 	: in std_logic;
		clk_mp  	:  in std_logic;
		rst 		: in std_logic;
		mode 		: in std_logic;
		enc_dec		: in std_logic;
		ramwe	 	: in std_logic;
		Key		: in std_logic_vector((4*DATAPATH_SIZE-1) downto 0);
		Data_in		: in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
		Simeck_constant : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		count_load	: in std_logic_vector((COUNT_SIZE_load-1) downto 0);
		count_run	: in std_logic_vector((COUNT_SIZE_run-1) downto 0);
		Data_out 	: out std_logic_vector ((2*DATAPATH_SIZE-1) downto 0)
	);

end entity datapath;

architecture rtl of datapath is

signal s_key_load      : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_data_load     : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_key_ram_in    : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_key_ram_out   : std_logic_vector(DATAPATH_SIZE-1 downto 0);
signal s_nrst	       : std_logic;
signal s_plaintext_sel : std_logic;
signal s_cr	       : std_logic_vector((COUNT_SIZE_run-1) downto 0);

begin

s_nrst <= not(rst);
s_plaintext_sel <= not(count_load(0) or count_load(1));

U_mux4to1:mux4to1
 generic map(DATAPATH_SIZE => DATAPATH_SIZE)   
 port map(
	sel  => count_load,
	inp0 => Key((DATAPATH_SIZE-1) downto 0),
	inp1 => Key((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE),
	inp2 => Key((3*DATAPATH_SIZE-1) downto 2*DATAPATH_SIZE),
	inp3 => Key((4*DATAPATH_SIZE-1) downto 3*DATAPATH_SIZE),
	outp => s_key_load          
);
     
U_mux2to1:mux2to1
 generic map(DATAPATH_SIZE => DATAPATH_SIZE)
 port map( 
        modemux => s_plaintext_sel,
        inp0	=> Data_in((DATAPATH_SIZE-1) downto 0),
        inp1	=> Data_in((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE),
        outp	=> s_data_load          
);     

U_kef:key_expand_function 
 port map(
  	clk	=> clk,
  	clk_mp  => clk_mp,
  	rstreg	=> '0',
  	mode	=> mode,       
  	key_in	=> s_key_load,       
  	sim_con	=> Simeck_constant,
  	key_out	=> s_key_ram_in
);

U_key_ram:ram
port map( 
     	clk	   => clk,
     	--rst	   => rst,
	--mode 	   => mode,
	--enc_dec	   => enc_dec,		
     	ramwe	   => ramwe,
     	ramaddress => s_cr,
     	ramin	   => s_key_ram_in,
     	ramout	   => s_key_ram_out            
);

U_rf:round_function 
 port map(
  	clk	 => clk,
  	clk_mp   => clk_mp,
  	rstreg	 => rst,
 	mode	 => mode,
 	Data_in	 => s_data_load,
  	key	 => s_key_ram_out,
  	mi	 => Data_out((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE),
  	Data_out => Data_out((DATAPATH_SIZE-1) downto 0)
);

proc:process (ramwe, mode, enc_dec, count_run)

variable cr : std_logic_vector((COUNT_SIZE_run-1) downto 0):= (others => '1');

begin

if (ramwe = '1') then
 cr := count_run;
else
 if (mode = '0' and enc_dec = '0') then
	cr := (others => '0');
 elsif (mode = '0' and enc_dec = '1') then
	cr := (others => '1');
 else
	if (enc_dec = '0') then
		cr := std_logic_vector(unsigned(count_run)+1);
	else 
		cr := std_logic_vector(unsigned(count_run)-1);
 	end if;
 end if;
end if;

s_cr <= cr;

end process;

end rtl;