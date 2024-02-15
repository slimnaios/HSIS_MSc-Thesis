library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.system_constants.all;

entity tb_transmitter is
end tb_transmitter;

architecture test of tb_transmitter is


    component Simeck32_64_transmitter is

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

end component Simeck32_64_transmitter;
    
signal  clk, clk_Simeck, rst : std_logic;
signal  sym_stream : std_logic := '0';
    
signal  symbol : std_logic_vector((SYMBOL_SIZE-1) downto 0);	    
signal  I_modulated : std_logic_vector((DATAPATH_SIZE-1) downto 0):=(others=>'0');
signal  Q_modulated : std_logic_vector((DATAPATH_SIZE-1) downto 0):=(others=>'0');
    
constant CLOCK_PERIOD : time := 68 ns;

type arr is array(integer range <>) of std_logic_vector((SYMBOL_SIZE-1) downto 0);    

constant CHECK_CASES : integer := 100;

constant symbol_check: arr(0 to CHECK_CASES-1)  := (
x"f",x"1",x"7",x"A",x"5",x"B",x"B",x"2",x"6",x"3",x"7",x"4",x"3",x"C",x"3",x"7",x"C",x"D",x"3",x"9",x"5",x"B",x"C",x"2",x"2",x"4",x"F",x"3",x"C",x"9",x"B",x"4",x"8",x"7",x"6",x"7",
x"E",x"8",x"D",x"5",x"5",x"C",x"1",x"E",x"8",x"7",x"1",x"4",x"D",x"4",x"9",x"4",x"1",x"8",x"8",x"1",x"1",x"E",x"2",x"F",x"F",x"3",x"5",x"B",x"9",x"5",x"4",x"2",x"E",x"9",x"2",x"2",
x"2",x"F",x"9",x"E",x"1",x"F",x"0",x"0",x"0",x"2",x"7",x"C",x"F",x"1",x"1",x"6",x"F",x"A",x"A",x"7",x"D",x"3",x"B",x"6",x"6",x"6",x"0",x"9"
);   
		   
begin
    
dut: Simeck32_64_transmitter
    port map
    (
        clk         => clk,
	clk_Simeck  => clk_Simeck,
        rst         => rst,
        sym_stream  => sym_stream,
	symbol 	    => symbol, 
        I_modulated => I_modulated,
        Q_modulated => Q_modulated
	 
);
-----------------------------------------------------------------------    
    
tb: process  
begin
       
wait until rst = '1';
wait until rst = '0';
   
wait for 60 ns; 
sym_stream <= '1';   
          
for k in 0 to CHECK_CASES-1 loop
	wait until rising_edge(clk);
	symbol <= symbol_check(k);
end loop;

end process;
    
   
clock: process				
begin					
        clk <= '0';
	wait for CLOCK_PERIOD/2;	--34 ns
	clk <= '1';
	wait for CLOCK_PERIOD/2;
end process;

clock_simeck: process			
begin					
       	--for j in 0 to 63 loop 
	clk_Simeck <= '1';	
        wait for CLOCK_PERIOD/68;	--1 ns	  
        clk_Simeck <= '0';
        wait for CLOCK_PERIOD/68;
	--end loop;
end process;

reset: process
begin
        rst <= '0';
        wait for 1 ns;
        rst <= '1';
        wait for 6.5 ns;
        rst <= '0';
        wait;
end process;

end test;  



