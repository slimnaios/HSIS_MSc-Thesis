library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all; 
 
entity demux1to2 is

	port 
	(		
		sel   : in std_logic;
		inp   : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		outp0 : out std_logic_vector((DATAPATH_SIZE-1) downto 0);
		outp1 : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
	);

end entity demux1to2;

architecture behavior of demux1to2 is

begin

demux_func_proc:process(sel,inp)
begin

case sel is				 
 when '0' => outp0 <= inp;
 when '1' => outp1 <= inp;
 when others => null;
 
end case;

end process;

end behavior;

