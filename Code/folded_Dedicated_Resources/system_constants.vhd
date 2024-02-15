library ieee;
use ieee.std_logic_1164.all;

package system_constants is

-- Generic constants --
constant SYMBOL_SIZE	   : integer := 4;
constant DATAPATH_SIZE     : integer := 16;
constant CHIP_SEGMENTS     : integer := (2*DATAPATH_SIZE) / SYMBOL_SIZE;

constant COUNT_SIZE_run    : integer := 5;
constant COUNT_SIZE_load   : integer := 2;
constant COUNT_SIZE_symbol : integer := 3;

-- Simeck constants --
constant Key		   : std_logic_vector := "0001100100011000000100010001000000001001000010000000000100000000"; -- x"1918111009080100"	
constant C                 : std_logic_vector := "1111111111111100"; -- x"FFFC"
constant SHIFT_OPERATOR_1  : integer := 5;
constant SHIFT_OPERATOR_2  : integer := 1; 

-- LFSR constants --
constant G_M               : integer          := 5;
constant G_POLY            : std_logic_vector := "10010";  -- x^5+x^2+1 
constant seed              : std_logic_vector := "11111";

-- Mod_Demod constants --
--constant i_fcw             : std_logic_vector := "00000010100011110101110000101000";  -- x"028F5C28";
constant i_fcw             : std_logic_vector   := "00000001011101100111110111001110";  -- x"01767DCE";

-- DSSS mapping --
type MEM is array (0 to (2**SYMBOL_SIZE-1)) of std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
constant DSSS_table : MEM := (

"01110100010010101100001110011011", --=> symbol <= "0000";
"01000100101011000011100110110111", --=> symbol <= "0001";
"01001010110000111001101101110100", --=> symbol <= "0010";
"10101100001110011011011101000100", --=> symbol <= "0011";
"11000011100110110111010001001010", --=> symbol <= "0100";
"00111001101101110100010010101100", --=> symbol <= "0101";
"10011011011101000100101011000011", --=> symbol <= "0110";
"10110111010001001010110000111001", --=> symbol <= "0111";
"11011110111000000110100100110001", --=> symbol <= "1000";
"11101110000001101001001100011101", --=> symbol <= "1001";
"11100000011010010011000111011110", --=> symbol <= "1010";
"00000110100100110001110111101110", --=> symbol <= "1011";
"01101001001100011101111011100000", --=> symbol <= "1100";
"10010011000111011110111000000110", --=> symbol <= "1101";
"00110001110111101110000001101001", --=> symbol <= "1110";
 --"00011101111011100000011010010011" => symbol <= "1111";
"01100101011001010110100001110111" --=> symbol <= "1111";	--reference chip (x"65656877") just for testing 
);

-- Components --
component ram is
 port(
      clk        : in std_logic;
      --rst	     : in std_logic;
      --mode 	 : in std_logic;
      --enc_dec	 : in std_logic;
      ramwe      : in std_logic;
      ramaddress : in std_logic_vector((COUNT_SIZE_run-1) downto 0);
      ramin      : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
      ramout     : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
);
end component ram;

component mux4to1 is
 port(
 	sel  : in std_logic_vector((COUNT_SIZE_load-1) downto 0);
 	inp0 : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
 	inp1 : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
 	inp2 : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
 	inp3 : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
 	outp : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
);
end component mux4to1;

component mux2to1 is
 port(
	modemux : in std_logic;
	inp0	: in std_logic_vector((DATAPATH_SIZE-1) downto 0);
	inp1	: in std_logic_vector((DATAPATH_SIZE-1) downto 0);
	outp 	: out std_logic_vector((DATAPATH_SIZE-1) downto 0)
 );
end component mux2to1;

component regst is
 generic(DATAPATH_SIZE : integer);  
 port(
	clk   	: in std_logic;
	rstreg	: in std_logic;
	en	: in std_logic;
	datain	: in std_logic_vector((DATAPATH_SIZE-1) downto 0);
	dataout : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
);
end component regst;

component rf_comb_cic is  
 port(	clk  : in std_logic;
	inpb : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
	inpa : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
	inpk : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
	outp : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
);
end component rf_comb_cic;

component key_expand_function is
 port(
 	clk     : in std_logic;
 	rstreg  : in std_logic;
 	mode    : in std_logic;
 	key_in  : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
 	sim_con : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
 	key_out : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
 );
end component key_expand_function;

component round_function is
 port(
	clk	 : in std_logic;
	rstreg   : in std_logic;
	mode 	 : in std_logic;
	Data_in	 : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
	key	 : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
	mi 	 : out std_logic_vector((DATAPATH_SIZE-1) downto 0);
	Data_out : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
);
end component round_function;

component fsm is
 port(
    clk  	  : in std_logic;
    rst  	  : in std_logic;
    key_cph       : in std_logic;
    enc_dec       : in std_logic;
    Round_count   : out std_logic_vector((COUNT_SIZE_run-1) downto 0);
    load_count    : out std_logic_vector((COUNT_SIZE_load-1) downto 0);
    mode	  : out std_logic;
    key_expanding : out std_logic;
    outp_valid    : out std_logic
);
end component fsm;

component lfsr_fib is
 port(
	clk 	 : in  std_logic;                    
	rst 	 : in  std_logic;                    
	lfsr_out : out std_logic_vector(COUNT_SIZE_run-1 downto 0)
 );
end component;

component control_path is
 port(
	clk	          : in std_logic;
	rst	          : in std_logic;
	C 	          : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
	key_cph	      : in std_logic;
	enc_dec	      : in std_logic;
	mode	      : out std_logic;
	key_expanding : out std_logic;
	outp_valid    : out std_logic;
	Round_count   : out std_logic_vector((COUNT_SIZE_run-1) downto 0);
	load_count    : out std_logic_vector((COUNT_SIZE_load-1) downto 0);
	sim_con	      : out std_logic_vector((DATAPATH_SIZE-1) downto 0)	
);
end component control_path;

component datapath is
 port(
	clk	   : in std_logic;
	rst 	   : in std_logic;
	mode 	   : in std_logic;
	key_cph    : in std_logic;
	--Key	   : in std_logic_vector((4*DATAPATH_SIZE-1) downto 0);
	Data_in	   : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
	sc_key 	   : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
	count_load : in std_logic_vector((COUNT_SIZE_load-1) downto 0);
	--count_run  : in std_logic_vector((COUNT_SIZE_run-1) downto 0);
	Data_out   : out std_logic_vector ((2*DATAPATH_SIZE-1) downto 0)
);
end component datapath;

component Simeck32_64 is
 port(
	clk	   : in std_logic;
	rst	   : in std_logic;
	key_cph    : in std_logic;
	enc_dec    : in std_logic;
	Data_in	   : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
	--Key	   : in std_logic_vector((4*DATAPATH_SIZE-1) downto 0);
	outp_valid : out std_logic;
	Data_out   : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0)
);
end component Simeck32_64;

component symbol_to_chip is
 port(
	clk	   : in std_logic;
	rst	   : in std_logic;
	sym_stream : in std_logic;
	symbol     : in std_logic_vector((SYMBOL_SIZE-1) downto 0);
	chip 	   : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0)
);
end component symbol_to_chip;

component chip_to_symbol is
 port(
	clk	    : in std_logic;
	rst	    : in std_logic;
	chip_stream : in std_logic;
	chip 	    : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
	symbol      : out std_logic_vector((SYMBOL_SIZE-1) downto 0)
);
end component chip_to_symbol;

component dds_sine is
 port(
  	i_clk         : in  std_logic;
  	i_rstb        : in  std_logic;
  	i_sync_reset  : in  std_logic;
  	i_fcw         : in  std_logic_vector(31 downto 0);
  	i_start_phase : in  std_logic_vector(31 downto 0);
  	o_sine        : out std_logic_vector(13 downto 0)
);
end component;

component I_Q_separator is
 port(
	chip : in std_logic_vector ((2*DATAPATH_SIZE-1) downto 0);
	I    : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
	Q    : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0)
);
end component;

component NRZ_bipolar_converter is
 port(
	bit_unipolar: in std_logic;
	bit_bipolar : out std_logic_vector(1 downto 0)
);
end component;

component OQPSK_modulator is
 port(
  	clk             : in  std_logic;
  	rst             : in  std_logic;
	modulator_start : in  std_logic;
  	i_fcw           : in  std_logic_vector(31 downto 0);
  	i_chip          : in  std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
  	I_modulated     : out std_logic_vector((DATAPATH_SIZE-1) downto 0);
  	Q_modulated     : out std_logic_vector((DATAPATH_SIZE-1) downto 0)
);
end component OQPSK_modulator;

component NRZ_unipolar_converter is
 port(	
	bit_bipolar  : in std_logic_vector(1 downto 0);
	bit_unipolar : out std_logic
);
end component NRZ_unipolar_converter;

component I_Q_combiner is
 port(
	I    : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
	Q    : in std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
	chip : out std_logic_vector((2*DATAPATH_SIZE-1) downto 0)
);
end component I_Q_combiner;

component OQPSK_demodulator is
 port(
  	clk               : in  std_logic;
  	rst               : in  std_logic;
	demodulator_start : in  std_logic;
	I	   	  : in  std_logic_vector((DATAPATH_SIZE-1) downto 0);
	Q      	   	  : in  std_logic_vector((DATAPATH_SIZE-1) downto 0);
  	outp_valid 	  : out std_logic;
	chip       	  : out  std_logic_vector((2*DATAPATH_SIZE-1) downto 0)	
);
end component OQPSK_demodulator;

end system_constants;
