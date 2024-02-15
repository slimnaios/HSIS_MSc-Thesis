library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all; 
 
entity mux2to1 is

    generic (DATAPATH_SIZE : integer);
    
	port 
	(
		modemux : in std_logic;
		inp0	: in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		inp1	: in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		outp 	: out std_logic_vector((DATAPATH_SIZE-1) downto 0)
	);

end entity mux2to1;

architecture behavior of mux2to1 is

begin

outp <= inp1 when modemux='0' else
        inp0 ;

end behavior;