library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.system_constants.all;

entity tb_cryptocore is
end tb_cryptocore;

architecture test of tb_cryptocore is


    component Simeck32_64 is

	port 
	(
  		clk	   : in std_logic;
		clk_mp	   : in std_logic;
		rst	   : in std_logic;
		key_cph    : in std_logic;
		enc_dec    : in std_logic;
		Data_in	   : in std_logic_vector ((2*DATAPATH_SIZE-1) downto 0);
		--Key	   : in std_logic_vector ((4*DATAPATH_SIZE-1) downto 0);
		outp_valid : out std_logic;
		Data_out   : out std_logic_vector ((2*DATAPATH_SIZE-1) downto 0)	
	);

end component Simeck32_64;
    
signal  clk, clk_mp, rst : std_logic;
signal  key_cph, enc_dec : std_logic := '0';
signal  outp_valid 	 : std_logic;
        
signal  Data_in  : std_logic_vector((2*DATAPATH_SIZE-1) downto 0):= (others => '0');
signal  Data_out : std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
    
constant CLOCK_PERIOD : time := 8 ns;

type arr is array(integer range <>) of std_logic_vector((2*DATAPATH_SIZE-1) downto 0);
  
constant CHECK_CASES : integer := 10;

constant plaintext_check: arr(0 to CHECK_CASES-1)  := (
x"770d2c76",
x"2028a80d",
x"f49dcb96",
x"8e437617",
x"9245f41a",
x"cf4354e2",
x"fb752169",
x"d86e8789",
x"ea3d77f4",
x"46f1912f"
);   

constant ciphertext_check: arr(0 to CHECK_CASES-1)  := (
x"65656877",
x"9bce5f0d",
x"5f0dd18b",
x"d18bce5b",
x"ce5bfefd",
x"fefde090",
x"e090fcd3",
x"fcd391a0",
x"91a08f4a",
x"8f4ae079"
);   
	   
begin
    
dut: Simeck32_64
    port map
    (
        clk        => clk,
	clk_mp     => clk_mp,
        rst        => rst,
        key_cph    => key_cph,
	enc_dec	   => enc_dec, 
        Data_in	   => Data_in,
	outp_valid => outp_valid,
        Data_out   => Data_out
	 
);
-----------------------------------------------------------------------    
    
tb: process  

variable pl_rev:std_logic_vector((2*DATAPATH_SIZE-1) downto 0);

begin
       
wait until rst = '1';
wait until rst = '0';

report "Simulation started!";

enc_dec <= '1';     

-- 4 cycles to load master key to registers
   for i in 0 to 3 loop
    wait until rising_edge(clk);
   end loop;
            
-- 32 cycles until key is produced
   for i in 0 to 31 loop
    wait until rising_edge(clk);
   end loop;

wait until rising_edge(clk);

enc_dec <= '0'; 

--for i in 0 to 33 loop
 wait until rising_edge(clk);   
--end loop;

key_cph <= '1';

enc_dec <= '1';

wait until rising_edge(clk);

for k in 0 to CHECK_CASES-1 loop

 if (enc_dec = '0') then
	Data_in <= plaintext_check(k);		 
 else
	pl_rev := plaintext_check(k)(DATAPATH_SIZE-1 downto 0) & plaintext_check(k)(2*DATAPATH_SIZE-1 downto DATAPATH_SIZE);
	Data_in <= pl_rev;

 end if;

--New input every 34 cycles
 for i in 0 to 33 loop
  wait until rising_edge(clk);
 end loop;

end loop;

end process;

check_results: process

variable result: std_logic_vector (2*DATAPATH_SIZE-1 downto 0);

begin

wait until rst = '1';
wait until rst = '0';
        
for t in 0 to CHECK_CASES-1 loop
 wait until outp_valid = '1';
 wait until rising_edge(clk);

	if (enc_dec = '0') then
	 result := Data_out;		 
	else 
	 result := Data_out((DATAPATH_SIZE-1) downto 0) & Data_out((2*DATAPATH_SIZE-1) downto DATAPATH_SIZE);
	end if;

        if result = ciphertext_check(t) then
	 report "Test vector successfully tested!";
        else
	 report "Test vector failed!" severity failure;
        end if;  

end loop;       
	
end process;    
   
clock: process				
begin		
 wait until clk_mp'event and clk_mp='0';			
 clk <= '1';
 wait for CLOCK_PERIOD/2;	--4 ns
 clk <= '0';
 wait for CLOCK_PERIOD/2;

if NOW > 4000 ns then
 assert false report "Simulation completed successfully!" severity note;
 wait;
end if;

end process;

clock_mp: process			    --clock frequency is (4*clock) MHz 
begin					        
 clk_mp <= '1';	
 wait for CLOCK_PERIOD/8;	--1 ns	  
 clk_mp <= '0';
 wait for CLOCK_PERIOD/8;

if NOW > 4000 ns then
 assert false report "Simulation completed successfully!" severity note;
 wait;
end if;

end process;

reset: process
begin
 rst <= '0';
 wait for 1 ns;
 rst <= '1';
 wait for 4 ns;
 rst <= '0';
 wait;

end process;

end test;  


