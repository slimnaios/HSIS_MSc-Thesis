library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity Simeck32_64_receiver is

	port 
	(
  		clk	    : in std_logic;
		clk_Simeck  : in std_logic;
		rst	    : in std_logic;
		data_stream : in std_logic;
		I	    : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		Q           : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		symbol      : out std_logic_vector((SYMBOL_SIZE-1) downto 0)  		
	);

end entity Simeck32_64_receiver;

architecture rtl of Simeck32_64_receiver is

signal s_chip_stream : std_logic;
signal s_key_cph     : std_logic;
signal s_dec  	     : std_logic;

signal s_ciphertext  	     : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
signal s_ciphertext_reversed : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
signal s_chip      	     : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
signal s_chip_reversed 	     : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);

begin

s_key_cph <= rst or data_stream;

s_dec <= not(data_stream and rst);

s_ciphertext_reversed <= s_ciphertext(DATAPATH_SIZE-1 downto 0) & s_ciphertext((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE);

s_chip_reversed <= s_chip(DATAPATH_SIZE-1 downto 0) & s_chip((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE);

U_demodulator:OQPSK_demodulator
 port map(
  clk		    => clk_Simeck,
  rst 		    => rst,
  demodulator_start => data_stream,
  I  	  	    => I,
  Q	            => Q,
  outp_valid 	    => s_chip_stream,
  chip              => s_ciphertext
);

U_Simeck_decryption:Simeck32_64 
 port map( 
  clk      => clk_Simeck,
  rst	   => rst,
  key_cph  => s_key_cph,
  enc_dec  => s_dec,
  Data_in  => s_ciphertext_reversed,
--  Key      => Key,
  Data_out => s_chip
);

U_chip_to_sym:chip_to_symbol 
 port map( 
  clk	      => clk,
  rst	      => rst,
  chip_stream => data_stream,
  chip        => s_chip_reversed,     
  symbol      => symbol 	
);

end rtl;
