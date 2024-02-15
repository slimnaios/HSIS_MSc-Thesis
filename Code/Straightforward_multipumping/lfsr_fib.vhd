library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity lfsr_fib is
 
 	port (
	 	clk	 : in  std_logic;                    
		rst	 : in  std_logic;                    
		lfsr_out : out std_logic_vector (COUNT_SIZE_run-1 downto 0)
  	);

end entity lfsr_fib;

architecture behavior of lfsr_fib is

signal q : std_logic_vector(COUNT_SIZE_run-1 downto 0) := seed;

begin

lfsr_proc: process(clk)
begin

   if(clk'event and clk='1') then           

    if (rst='1') then
     q <= seed;                       -- set seed value on reset
    else
     q(4) <= q(0) xor q(2);           -- feedback to MSB 
     q(3 downto 0)<= q(4 downto 1);   -- others bits shifted
    end if;

  end if;

end process;

lfsr_out<=q;

end behavior;