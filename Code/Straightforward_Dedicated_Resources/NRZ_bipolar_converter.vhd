library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity NRZ_bipolar_converter is

	port 
	(
		bit_unipolar : in std_logic;
		bit_bipolar  : out std_logic_vector(1 downto 0)
	);

end entity NRZ_bipolar_converter;

architecture behavior of NRZ_bipolar_converter is

begin

bit_bipolar <= std_logic_vector(to_signed(1,2)) when bit_unipolar = '1' else std_logic_vector(to_signed(-1,2));

end behavior;