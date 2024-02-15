library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity regst is
  
	generic (DATAPATH_SIZE : integer);

	port 
	(
		clk   	: in std_logic;
		rstreg	: in std_logic;
		en	    : in std_logic;
		datain	: in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		dataout : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
	);
end entity regst;

architecture behavior of regst is

begin

reg_func_proc:process (clk)
begin

if (clk'event and clk = '1') then 
    if (rstreg = '1') then
     dataout <= (others => '0');
    else 
        if (en = '1') then	
         dataout <= datain;
        end if;
    end if;
end if;

end process;

end behavior;
