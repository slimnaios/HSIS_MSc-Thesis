library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity ram is

   port 
   (
      clk         : in std_logic;
      --rst	  : in std_logic;	
      ramwe       : in std_logic;
      enc_dec 	  : in std_logic;
      ramaddress  : in std_logic_vector((RAM_SIZE-1) downto 0);
      ramin0      : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
      ramin1      : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
      ramout0     : out std_logic_vector((DATAPATH_SIZE-1) downto 0);
      ramout1     : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
    );

end entity ram;

architecture behavior of ram is

type RAM_TYPE is array (0 to 2**RAM_SIZE-1)   --16 size
of std_logic_vector ((DATAPATH_SIZE-1) downto 0);
signal ram0 : RAM_TYPE:= (others => (others => '0'));
signal ram1 : RAM_TYPE:= (others => (others => '0'));
--shared variable ram: RAM_TYPE:= (others => (others => '0'));
--attribute ram_style: string;
--attribute ram_style of ram0 : signal is "block";
--attribute ram_style of ram1 : signal is "block";

--signal read_address: std_logic_vector((RAM_SIZE-1) downto 0);

begin
	
clock_proc:process(clk)

begin

	--if (rst = '1') then
	 --ram <= (others => (others => '0'));
	if (clk'event and clk = '1') then
		
	 if (ramwe = '1') then
	  ram0(to_integer(unsigned(ramaddress))) <= ramin0;
	  ram1(to_integer(unsigned(ramaddress))) <= ramin1;
	 end if;
	
	end if;

	if (enc_dec = '0') then
	 ramout0 <= ram0(to_integer(unsigned(ramaddress)));        
	 ramout1 <= ram1(to_integer(unsigned(ramaddress)));
	else
	 ramout0 <= ram1(to_integer(unsigned(ramaddress)));        
	 ramout1 <= ram0(to_integer(unsigned(ramaddress)));
	end if;

end process;

end behavior;