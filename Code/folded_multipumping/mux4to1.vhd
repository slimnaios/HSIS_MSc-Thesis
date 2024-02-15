library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all; 
 
entity mux4to1 is

    generic (DATAPATH_SIZE : integer);

	port 
	(		
		sel  : in std_logic_vector((COUNT_SIZE_load-1) downto 0);
		inp0 : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		inp1 : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		inp2 : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		inp3 : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		outp : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
	);

end entity mux4to1;

architecture behavior of mux4to1 is

begin

outp<=  inp0 when sel="00" else
        inp1 when sel="01" else
        inp2 when sel="10" else
        inp3 ;

end behavior;