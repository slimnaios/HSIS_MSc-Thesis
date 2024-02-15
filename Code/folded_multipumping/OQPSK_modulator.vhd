library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity OQPSK_modulator is

	port 
	(
  		clk             : in  std_logic;
  		rst             : in  std_logic;
		modulator_start : in  std_logic;
  		i_fcw           : in  std_logic_vector(31 downto 0);
  		i_chip          : in  std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
  		I_modulated     : out std_logic_vector((DATAPATH_SIZE-1) downto 0);
  		Q_modulated     : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
	);

end entity OQPSK_modulator;

architecture rtl of OQPSK_modulator is

signal s_reg_out    : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);

signal s_o_sine     : std_logic_vector(13 downto 0);
signal s_o_cosine   : std_logic_vector(13 downto 0);

signal s_I	    : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
signal s_Q	    : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);

signal s_I_unipolar : std_logic;
signal s_Q_unipolar : std_logic;
signal s_I_bipolar  : std_logic_vector(1 downto 0);
signal s_Q_bipolar  : std_logic_vector(1 downto 0);

signal transmission_count : std_logic_vector(4 downto 0):= (others=>'0');
signal valid_transmission : std_logic := '0';

begin

U_regst:regst
 generic map(DATAPATH_SIZE => 2*DATAPATH_SIZE)
 port map(
  clk     => clk,
  rstreg  => rst,	
  en	  => modulator_start,
  datain  => i_chip,
  dataout => s_reg_out
);

U_I_Q_separator:I_Q_separator
 port map(
  chip => s_reg_out,
  I    => s_I,
  Q    => s_Q
);

U_sine:dds_sine
 port map(
  i_clk         => clk, 
  i_rstb        => '1',
  i_sync_reset  => rst,
  i_fcw         => i_fcw,
  i_start_phase => x"00000000",
  o_sine   	=> s_o_sine   
);

U_cosine:dds_sine
 port map(
  i_clk         => clk,
  i_rstb        => '1',
  i_sync_reset  => rst,
  i_fcw         => i_fcw,
  i_start_phase => x"40000000",
  o_sine        => s_o_cosine   
);

U_bit_bipo_I:NRZ_bipolar_converter 
 port map(
  bit_unipolar => s_I_unipolar,
  bit_bipolar  => s_I_bipolar
);

U_bit_bipo_Q:NRZ_bipolar_converter 
 port map(
  bit_unipolar => s_Q_unipolar,
  bit_bipolar  => s_Q_bipolar
);

oqpsk_modulator_proc:process(clk,rst)
begin

 if (rst = '1') then
  I_modulated <= (others=>'0');
  Q_modulated <= (others=>'0');
  valid_transmission <= '0';
  transmission_count <= (others=>'0');
 
 elsif (clk'event and clk = '1') then
	
  if modulator_start = '1' then
   valid_transmission <= '1';
  end if;

  if valid_transmission = '1' then
   s_I_unipolar <= s_I(to_integer(unsigned(transmission_count)));
   s_Q_unipolar <= s_Q(to_integer(unsigned(transmission_count)));
   I_modulated <= std_logic_vector(signed(s_o_cosine) * signed(s_I_bipolar));
   Q_modulated <= std_logic_vector(signed(s_o_sine) * signed(s_Q_bipolar));
   transmission_count <= std_logic_vector(unsigned(transmission_count)+1);
  end if;

  if transmission_count = "11111" then
   valid_transmission <= '0';
  end if; 

 end if;

end process;

end rtl;
