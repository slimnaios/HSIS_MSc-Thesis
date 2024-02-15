library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity rf_comb_cic is
	
	port 
	(
		inpb : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		inpa : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		inpk : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		outp : out std_logic_vector ((DATAPATH_SIZE-1) downto 0)
	);

end entity rf_comb_cic;

architecture behavior of rf_comb_cic is

signal inpb_cyc_sh_1 : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal inpb_cyc_sh_2 : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal after_and     : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal after_xor1    : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal after_xor2    : std_logic_vector((DATAPATH_SIZE-1) downto 0);


begin

inpb_cyc_sh_1 <= inpb((DATAPATH_SIZE-1)-SHIFT_OPERATOR_1 downto 0) & inpb((DATAPATH_SIZE-1) downto (DATAPATH_SIZE-SHIFT_OPERATOR_1)); 

inpb_cyc_sh_2 <= inpb((DATAPATH_SIZE-1)-SHIFT_OPERATOR_2 downto 0) & inpb((DATAPATH_SIZE-1) downto (DATAPATH_SIZE-SHIFT_OPERATOR_2)); 

after_and <= inpb and inpb_cyc_sh_1;

after_xor1 <= after_and xor inpa;

after_xor2 <= after_xor1 xor inpb_cyc_sh_2;

outp <= after_xor2 xor inpk;

end behavior;