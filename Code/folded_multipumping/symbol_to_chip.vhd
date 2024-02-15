library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity symbol_to_chip is

	port 
	(
		clk	   : in std_logic;
		rst	   : in std_logic;
		sym_stream : in std_logic;
		symbol     : in std_logic_vector((SYMBOL_SIZE-1) downto 0);
		chip 	   : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0)
	);

end entity symbol_to_chip;

architecture behavior of symbol_to_chip is

begin

sym_to_chip_proc: process(clk,rst)

begin

if (rst = '1') then
        chip <= (others=>'0');
elsif (clk'event and clk='1') then
        
	if sym_stream = '1' then
    		chip <= DSSS_table(to_integer(unsigned(symbol))); 
	end if;

end if;

end process;

end behavior;