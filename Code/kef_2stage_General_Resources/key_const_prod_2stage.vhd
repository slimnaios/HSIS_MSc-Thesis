library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity key_const_prod_2stage is
 
 	port (
	 	clk : in  std_logic;                    
		rst : in  std_logic;               
		Simeck_constant0 : out std_logic_vector((DATAPATH_SIZE-1) downto 0);
		Simeck_constant1 : out std_logic_vector((DATAPATH_SIZE-1) downto 0)    
  	);

end entity key_const_prod_2stage;

architecture behavior of key_const_prod_2stage is

signal PN_seq : std_logic_vector((2*DATAPATH_SIZE-1) downto 0) := z0;

begin

key_const_proc: process(clk,rst)
begin

    if (rst='1') then
	PN_seq <= z0;

    elsif (clk'event and clk='1') then 
    
	PN_seq((2*DATAPATH_SIZE-1) downto (2*DATAPATH_SIZE-2)) <= (others =>'0');
	PN_seq((2*DATAPATH_SIZE-3) downto 0) <= PN_seq((2*DATAPATH_SIZE-1) downto 2);
    
    end if;

end process;

Simeck_constant0 <= C((DATAPATH_SIZE-1) downto 1) & (C(0) xor PN_seq(0));
Simeck_constant1 <= C((DATAPATH_SIZE-1) downto 1) & (C(0) xor PN_seq(1));

end behavior;