library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

entity rf_comb_cic is
	
	port 
	(   clk_mp  : in std_logic;  
		inpb : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		inpa : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		inpk : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		outp : out std_logic_vector ((DATAPATH_SIZE-1) downto 0)
	);

end entity rf_comb_cic;

architecture behavior of rf_comb_cic is
signal opm : std_logic;
--signal opm : std_logic_vector(6 downto 0);
signal inpb_cyc_sh_1 : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal inpb_cyc_sh_2 : std_logic_vector((DATAPATH_SIZE-1) downto 0);

signal after_and : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_rg_mx1 : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_mx1_xr : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal s_mx0_xr : std_logic_vector((DATAPATH_SIZE-1) downto 0);

signal cnt : std_logic_vector(1 downto 0) :="11";

signal after_xor : std_logic_vector((DATAPATH_SIZE-1) downto 0);

begin

inpb_cyc_sh_1 <= inpb((DATAPATH_SIZE-1)-SHIFT_OPERATOR_1 downto 0) & inpb((DATAPATH_SIZE-1) downto (DATAPATH_SIZE-SHIFT_OPERATOR_1)); 

inpb_cyc_sh_2 <= inpb((DATAPATH_SIZE-1)-SHIFT_OPERATOR_2 downto 0) & inpb((DATAPATH_SIZE-1) downto (DATAPATH_SIZE-SHIFT_OPERATOR_2)); 

after_and <= inpb and inpb_cyc_sh_1;

outp <= s_rg_mx1;
 
U_mux0:mux4to1 
 generic map(DATAPATH_SIZE => DATAPATH_SIZE)
 port map(
     sel  => cnt,
     inp0 => X"0000",
     inp1 => inpa,
     inp2 => inpb_cyc_sh_2,
     inp3 => inpk,
     outp  => s_mx0_xr
); 
   
U_mux1:mux2to1 
 generic map(DATAPATH_SIZE => DATAPATH_SIZE)
 port map(
     modemux => opm,  
     --modemux => opm(4),
     inp0    => after_and,
     inp1    => s_rg_mx1,
     outp    => s_mx1_xr
);   

after_xor <= s_mx1_xr xor s_mx0_xr;
  
U_reg:regst
 generic map(DATAPATH_SIZE => DATAPATH_SIZE)  
 port map(
  clk	  => clk_mp,
  rstreg  => '0',
  en	  => '1',
  datain  => after_xor,
  dataout => s_rg_mx1
);

proc_cnt: process(clk_mp,cnt)
begin
    
    if (clk_mp'event and clk_mp = '1') then
        cnt <= std_logic_vector(unsigned(cnt) + 1);
    end if;
    
    if cnt="00" then 
    opm <= '1';
    --opm <= opm1;
    else
    opm <= '0';
    --opm <=opm2;
    end if;
    
end process;
          
end behavior;