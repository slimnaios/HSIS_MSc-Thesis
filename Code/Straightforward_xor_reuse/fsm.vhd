library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity fsm is

   port 
   (
      clk           : in std_logic;
      rst           : in std_logic;
      key_cph       : in std_logic;
      enc_dec       : in std_logic;
      Round_count   : out std_logic_vector((COUNT_SIZE_run-1) downto 0);
      load_count    : out std_logic_vector((COUNT_SIZE_load-1) downto 0);
      mode          : out std_logic;
      key_expanding : out std_logic;
      outp_valid    : out std_logic
   );

end entity fsm;

architecture behavior of fsm is

type STATE_TYPE is 
(Idle, Key_exp_algorithm, Key_exp_finish, Encryption_start, Decryption_start, cipher_finish); 

signal current_state : STATE_TYPE;
signal s_Round_count : std_logic_vector((COUNT_SIZE_run-1) downto 0);
signal s_load_count  : std_logic_vector((COUNT_SIZE_load-1) downto 0);

begin

--state machine process.
sta_mach_proc:process (clk,rst)

variable round_count : std_logic_vector((COUNT_SIZE_run-1) downto 0):=(others=>'0');
variable load_count  : std_logic_vector((COUNT_SIZE_load-1) downto 0):=(others=>'0');

begin
 
if (clk'event and clk = '1') then	
 if (rst='1') then 
  current_state <= Idle;
  load_count := (others=>'0');
  outp_valid <= '0';
 else   
  case current_state is

     when Idle =>          	--when current state is "Idle"
      load_count := std_logic_vector(unsigned(load_count)+1);
      outp_valid <= '0';     
      if ((key_cph = '0') and (enc_dec = '1')) and load_count = "00" then      
       current_state <= Key_exp_algorithm;
        round_count := (others=>'0'); 
    
      elsif ((key_cph = '1') and (enc_dec = '0')) and load_count = "10" then  
       current_state <= Encryption_start;
	    round_count := (others=>'0');

      elsif ((key_cph = '1') and (enc_dec = '1')) and load_count = "10" then  
       current_state <= Decryption_start;
	    round_count := (others=>'1');

      else
       current_state <= Idle;
	    round_count := (others=>'0');
      end if;     

     when Key_exp_algorithm =>      --when current state is "Key_exp_algorithm"       
      round_count := std_logic_vector(unsigned(round_count)+1);
      if (round_count = "11111") then   
       current_state <= Key_exp_finish;
      end if;
      
     when Key_exp_finish =>         --when current state is "Key_exp_finish"
       current_state <= Idle;
	   load_count := (others=>'0');

     when Encryption_start =>       --when current state is "Encryption_start"
      round_count := std_logic_vector(unsigned(round_count)+1);
      if (round_count = "11111") then      
       current_state <= cipher_finish;
      end if;
      
     when Decryption_start =>       --when current state is "Decryption_start"
      round_count := std_logic_vector(unsigned(round_count)-1);
      if(round_count = "00000") then      
       current_state <= cipher_finish;
      end if;
      
     when cipher_finish =>          --when current state is "cipher_finish"
       current_state <= Idle;
	   load_count := (others=>'0');
	
	if (round_count = "11111" or round_count = "00000") then   
	 outp_valid <= '1';
	else
	 outp_valid <= '0';
    end if;
 	
  end case;
 
 end if;
end if;

s_Round_count <= round_count;
s_load_count  <= load_count;

end process;

Round_count  <= s_Round_count;
load_count   <= s_load_count;

sta_sign_proc:process (current_state)

begin

case current_state is
     when Idle =>          	--when current state is "Idle"    
     mode 	   <= '0'; 
     key_expanding <= '0';	  
--outp_valid <= '1';
     when Key_exp_algorithm =>  --when current state is "Key_exp_algorithm"
     mode 	   <= '1';
     key_expanding <= '1';      
--outp_valid <= '0';
     when Key_exp_finish =>     --when current state is "Key_exp_finish"
     mode 	   <= '1';
     key_expanding <= '1';      
--outp_valid <= '0';
     when Encryption_start =>   --when current state is "Encryption_start"
     mode 	   <= '1';
     key_expanding <= '0';
 --outp_valid <= '0';    
     when Decryption_start =>   --when current state is "Decryption_start"
     mode 	   <= '1';
     key_expanding <= '0';		      
 --outp_valid <= '0';    
     when cipher_finish =>      --when current state is "cipher_finish"
     mode 	   <= '1';
     key_expanding <= '0';
--outp_valid <= '0';      
end case;

end process;

end behavior;