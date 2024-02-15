library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity ram is

   port 
   (
      clk        : in std_logic;
      --rst	     : in std_logic;	
      ramwe      : in std_logic;
      ramaddress : in std_logic_vector((COUNT_SIZE_run-1) downto 0);
      ramin      : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
      ramout     : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
    );

end entity ram;

architecture behavior of ram is

type RAM_TYPE is array (0 to (2**COUNT_SIZE_run-1))
of std_logic_vector ((DATAPATH_SIZE-1) downto 0);
signal ram : RAM_TYPE:= (others => (others => '0'));
--attribute ram_style: string;
--attribute ram_style of ram : signal is "block";

signal read_address:std_logic_vector((COUNT_SIZE_run-1) downto 0);

begin

clock_proc:process (clk)
variable r_addr:std_logic_vector((COUNT_SIZE_run-1) downto 0);--:=(others=>'0');
begin
 if (clk'event and clk = '1') then
	--if (rst = '1') then
	-- ram <= (others => (others => '0'));
	--else	
		if (ramwe = '1') then
		 ram(to_integer(unsigned(ramaddress))) <= ramin;
		end if;
	
 end if;

end process;

ramout <= ram(to_integer(unsigned(ramaddress))); 
end behavior;