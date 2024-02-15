library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all; 

entity I_Q_combiner is

	port 
	(
		I    : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
		Q    : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
		chip : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0)
	);

end entity I_Q_combiner;

architecture behavior of I_Q_combiner is

signal s_I : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);

begin

I_Q_combination_proc:process(s_I,Q)
variable var_chip:std_logic_vector((2*DATAPATH_SIZE-1) downto 0):=(others => '0');
begin

I_Q:for k in 0 to (2*DATAPATH_SIZE-1) loop
	
	if ((k mod 2)=0) then  
	 var_chip(k) := I(k); 
	else
 	 var_chip(k) := Q(k);
	end if;
 
    end loop;
chip <= var_chip;
end process;

s_I <= std_logic_vector(shift_left(signed(I),1)); --shift left by Tb because order must be from LSB to MSB

end behavior;
