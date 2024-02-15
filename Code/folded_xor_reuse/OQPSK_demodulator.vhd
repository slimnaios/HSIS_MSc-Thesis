library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity OQPSK_demodulator is

	port 
	(
  		clk               : in std_logic;
  		rst               : in std_logic;
		demodulator_start : in  std_logic;
		I	          : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		Q      	          : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
  		outp_valid        : out std_logic;
		chip              : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0)	
	);

end entity OQPSK_demodulator;

architecture rtl of OQPSK_demodulator is

--signal s_I_bipolar  : std_logic_vector(1 downto 0);
--signal s_Q_bipolar  : std_logic_vector(1 downto 0);
signal s_I_unipolar : std_logic;
signal s_Q_unipolar : std_logic;

signal s_I_demod : std_logic_vector((2*DATAPATH_SIZE-1) downto 0) := (others=>'0');
signal s_Q_demod : std_logic_vector((2*DATAPATH_SIZE-1) downto 0) := (others=>'0');
signal s_chip    : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);

signal s_chip_valid : std_logic := '0';

signal reception_count : std_logic_vector(4 downto 0):= (others=>'0');
signal valid_reception : std_logic := '0';

begin
 
outp_valid <= s_chip_valid;

--U_bit_unipo_I:NRZ_unipolar_converter 
 --port map(
 -- bit_bipolar  => s_I_bipolar,
 -- bit_unipolar => s_I_unipolar
--);

--U_bit_unipo_Q:NRZ_unipolar_converter 
-- port map(
--  bit_bipolar  => s_Q_bipolar,
--  bit_unipolar => s_Q_unipolar
--);

U_I_Q_combiner:I_Q_combiner
 port map(
  I    => s_I_demod,
  Q    => s_Q_demod,
  chip => s_chip
);

U_regst:regst
 generic map(DATAPATH_SIZE => 2*DATAPATH_SIZE)
 port map(
  clk     => clk,
  rstreg  => rst,	
  en	  => s_chip_valid,
  datain  => s_chip,
  dataout => chip
);

oqpsk_demodulator_proc:process(clk,rst)

begin

 if (rst='1') then
  valid_reception <= '0';
  reception_count <= (others=>'0');

 elsif (clk'event and clk = '1') then 

  if demodulator_start = '1' then
   valid_reception <= '1';
  end if;

  if valid_reception = '1' then
   s_chip_valid <= '0' ;
   s_I_demod(to_integer(unsigned(reception_count))) <= s_I_unipolar;
   s_Q_demod(to_integer(unsigned(reception_count))) <= s_Q_unipolar;
   reception_count <= std_logic_vector(unsigned(reception_count)+1);
  end if;

  if reception_count = "11111" then 
   s_chip_valid <= '1' ;
   valid_reception <= '0';
  end if;

 end if;

if (I(15)='0' and Q(15)='0') then
	 --s_I_bipolar <= "01";
	 --s_Q_bipolar <= "01";
s_I_unipolar <= '1';
s_Q_unipolar <= '1';
	elsif (I(15)='1' and Q(15)='0') then
         --s_I_bipolar <= "11";
	 --s_Q_bipolar <= "01"; 
s_I_unipolar <= '0';
s_Q_unipolar <= '1';
	elsif (I(15)='1' and Q(15)='1') then
	 --s_I_bipolar <= "11";
	 --s_Q_bipolar <= "11";
s_I_unipolar <= '0';
s_Q_unipolar <= '0';
	elsif (I(15)='0' and Q(15)='1') then
	 --s_I_bipolar <= "01";
	 --s_Q_bipolar <= "11";
s_I_unipolar <= '1';
s_Q_unipolar <= '0';
	end if;

end process;

end rtl;
