library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity NRZ_unipolar_converter is

	port 
	(	
		bit_bipolar  : in std_logic_vector(1 downto 0);
		bit_unipolar : out std_logic
	);

end entity NRZ_unipolar_converter;

architecture behavior of NRZ_unipolar_converter is

begin

--bit_unipolar <= '1' when bit_bipolar = std_logic_vector(to_signed(1,2)) else '0';
bit_unipolar <= '1' when bit_bipolar = "11" else '0';
end behavior;
