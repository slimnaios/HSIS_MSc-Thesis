library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity chip_to_symbol is

	port 
	(
		clk	    : in std_logic;
		rst	    : in std_logic;
		chip_stream : in std_logic;
		chip 	    : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
		symbol      : out std_logic_vector((SYMBOL_SIZE-1) downto 0)		
	);

end entity chip_to_symbol;

architecture behavior of chip_to_symbol is

begin

mls_proc:process(clk,rst)

variable max_ham_dist : std_logic_vector(4 downto 0) := (others => '1');
variable temp_symbol  : std_logic_vector((SYMBOL_SIZE-1) downto 0) := (others => '0');
variable Hamm_dist    : std_logic_vector(4 downto 0) := (others => '0') ;

type H_dist_table is array (0 to (2**SYMBOL_SIZE-1)) of std_logic_vector(4 downto 0);
variable ham_dist: H_dist_table := (others => (others => '0'));

begin

if (rst = '1') then
 symbol <= (others=>'0');
elsif (clk'event and clk='1') then
 
 if chip_stream = '1' then
	
	for k in 0 to (2**SYMBOL_SIZE-1) loop						--calculation of Hamming Distance of incoming chip sequence in relevance to DSSS chip sequences
 	Hamm_dist := (others => '0');
		for l in 0 to (2*DATAPATH_SIZE-1)  loop
		 if (chip(l) xor DSSS_table(k)(l)) = '1' then
			Hamm_dist := std_logic_vector(unsigned(Hamm_dist)+1);
		 end if;
		end loop;
	ham_dist(k) := Hamm_dist;
	end loop;	

	max_ham_dist := (others => '1');
	temp_symbol := (others => '0');

	for k in 0 to (2**SYMBOL_SIZE-1) loop									--most likelihood symbol estimation (minimum Hamming Distance)
		 if std_logic_vector(unsigned(max_ham_dist)) > std_logic_vector(unsigned(ham_dist(k))) then		
			max_ham_dist := ham_dist(k);
			temp_symbol := std_logic_vector(to_unsigned(k,4));
		 end if;
	end loop;
		
	symbol <= temp_symbol;

 end if;

end if;

end process;

end behavior;
