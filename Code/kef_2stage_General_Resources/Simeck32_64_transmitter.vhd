library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity Simeck32_64_transmitter is

	port 
	(
  		clk	    : in std_logic;
		clk_Simeck  : in std_logic;
		rst	    : in std_logic;
		sym_stream  : in std_logic;
		symbol      : in std_logic_vector((SYMBOL_SIZE-1) downto 0);
  		I_modulated : out std_logic_vector((DATAPATH_SIZE-1) downto 0);
  		Q_modulated : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
	);

end Simeck32_64_transmitter;

architecture rtl of Simeck32_64_transmitter is

signal s_chip : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
signal s_enc  : std_logic;

signal s_ciphertext : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);

signal s_modulator_start : std_logic;

begin

s_enc <= not(sym_stream) and not(rst);

U_sym_to_chip:symbol_to_chip 
 port map( 
  clk	     => clk,
  rst	     => rst,
  sym_stream => sym_stream,
  symbol     => symbol,     
  chip	     => s_chip 	
);

U_Simeck_encryption:Simeck32_64 
 port map( 
  clk        => clk_Simeck,
  rst	     => rst,
  key_cph    => sym_stream,
  enc_dec    => s_enc,
  Data_in    => s_chip,
--  Key        => Key,
  outp_valid => s_modulator_start,
  Data_out   => s_ciphertext
);

U_modulator:OQPSK_modulator
 port map(
  clk             => clk_Simeck,
  rst 	          => rst,
  modulator_start => s_modulator_start,
  i_fcw           => i_fcw,
  i_chip          => s_ciphertext,
  I_modulated     => I_modulated,
  Q_modulated     => Q_modulated
);  	

end rtl;
