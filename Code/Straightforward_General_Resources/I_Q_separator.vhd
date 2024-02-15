library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all; 

entity I_Q_separator is

	port 
	(
		chip : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
		I    : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
		Q    : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0)
	);

end entity I_Q_separator;

architecture behavior of I_Q_separator is

signal s_Q : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);

begin


I_Q_separation_proc:process(chip)

begin

I_Q:for k in 0 to (2*DATAPATH_SIZE-1) loop
	
	if ((k mod 2)=0) then  
	 I(k) <= chip(k); 
	 I(k+1) <= chip(k);
	else
	 s_Q(k-1) <= chip(k);
 	 s_Q(k) <= chip(k);
	end if;
 
    end loop;

end process;

Q <= std_logic_vector(shift_left(signed(s_Q),1)); --shift left by Tb because order must be from LSB to MSB

end behavior;