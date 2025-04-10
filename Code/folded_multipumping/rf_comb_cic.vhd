library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.system_constants.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity rf_comb_cic is
	
	port 
	(   	clk_mp  : in std_logic;  
		inpb : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		inpa : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		inpk : in std_logic_vector ((DATAPATH_SIZE-1) downto 0);
		outp : out std_logic_vector ((DATAPATH_SIZE-1) downto 0)
	);

end entity rf_comb_cic;

architecture behavior of rf_comb_cic is

signal opm : std_logic_vector(6 downto 0);
signal inpb_cyc_sh_1 : std_logic_vector((DATAPATH_SIZE-1) downto 0);
signal inpb_cyc_sh_2 : std_logic_vector((DATAPATH_SIZE-1) downto 0);
--signal after_and     : std_logic_vector((DATAPATH_SIZE-1) downto 0);
--signal after_xor1    : std_logic_vector((DATAPATH_SIZE-1) downto 0);
--signal after_xor2    : std_logic_vector((DATAPATH_SIZE-1) downto 0);

----------------- DSP signals --------------------------
signal dsp0_b_in  : std_logic_vector(17 downto 0);
signal dsp0_c_in  : std_logic_vector(47 downto 0);
signal after_and_dsp0  : std_logic_vector(47 downto 0);
signal dsp1_b_in  : std_logic_vector(17 downto 0);
signal after_xor1_dsp1 : std_logic_vector(47 downto 0);
signal dsp2_b_in  : std_logic_vector(17 downto 0);
signal after_xor2_dsp2 : std_logic_vector(47 downto 0);
signal dsp3_b_in  : std_logic_vector(17 downto 0);
signal after_xor3_dsp3 : std_logic_vector(47 downto 0);
--------------------------------------------------------
signal b : std_logic_vector(17 downto 0);
signal c : std_logic_vector(47 downto 0);
signal cnt : std_logic_vector(1 downto 0) :="11";

begin

inpb_cyc_sh_1 <= inpb((DATAPATH_SIZE-1)-SHIFT_OPERATOR_1 downto 0) & inpb((DATAPATH_SIZE-1) downto (DATAPATH_SIZE-SHIFT_OPERATOR_1)); 

inpb_cyc_sh_2 <= inpb((DATAPATH_SIZE-1)-SHIFT_OPERATOR_2 downto 0) & inpb((DATAPATH_SIZE-1) downto (DATAPATH_SIZE-SHIFT_OPERATOR_2)); 

--after_and <= inpb and inpb_cyc_sh_1;

--after_xor1 <= after_and xor inpa;

--after_xor2 <= after_xor1 xor inpb_cyc_sh_2;

--outp <= after_xor2 xor inpk;

------------ DSP0 (and) signals ------------
dsp0_b_in <= "00" & inpb;
dsp0_c_in <= X"00000000" & inpb_cyc_sh_1;

--dsp0_p_out <= after_and_dsp0
--------------------------------------------

------------ DSP1 (xor1) signals ------------
dsp1_b_in <= "00" & inpa;

--dsp1_c_in <= after_and_dsp0
--dsp1_p_out <= after_xor1_dsp1
---------------------------------------------

------------ DSP2 (xor2) signals ------------
dsp2_b_in <= "00" & inpb_cyc_sh_2;

--dsp2_c_in <= after_xor1_dsp1
--dsp2_p_out <= after_xor2_dsp2
---------------------------------------------

------------ DSP3 (xor_k) signals ------------
dsp3_b_in <= "00" & inpk;

--dsp3_c_in <= after_xor2_dsp2
--dsp3_p_out <= after_xor3_dsp3
---------------------------------------------

outp <= after_xor3_dsp3((DATAPATH_SIZE-1) downto 0);

--outp<=after_and_dsp0((DATAPATH_SIZE-1) downto 0);
DSP48E1_inst0 : DSP48E1
   generic map (
      -- Feature Control Attributes: Data Path Selection
      A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
      B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
      USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
      USE_MULT => "NONE",            -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
      USE_SIMD => "ONE48",               -- SIMD selection ("ONE48", "TWO24", "FOUR12")
      -- Pattern Detector Attributes: Pattern Detection Configuration
      AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
      MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
      PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
      SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
      SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
      USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
      -- Register Control Attributes: Pipeline Register Configuration
      ACASCREG => 0,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
      ADREG => 1,                        -- Number of pipeline stages for pre-adder (0 or 1)
      ALUMODEREG => 0,                   -- Number of pipeline stages for ALUMODE (0 or 1)
      AREG => 0,                         -- Number of pipeline stages for A (0, 1 or 2)
      BCASCREG => 0,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
      BREG => 0,                         -- Number of pipeline stages for B (0, 1 or 2)
      CARRYINREG => 0,                   -- Number of pipeline stages for CARRYIN (0 or 1)
      CARRYINSELREG => 0,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
      CREG => 0,                         -- Number of pipeline stages for C (0 or 1)
      DREG => 1,                         -- Number of pipeline stages for D (0 or 1)
      INMODEREG => 0,                    -- Number of pipeline stages for INMODE (0 or 1)
      MREG => 0,                         -- Number of multiplier pipeline stages (0 or 1)
      OPMODEREG => 0,                    -- Number of pipeline stages for OPMODE (0 or 1)
      PREG => 0                          -- Number of pipeline stages for P (0 or 1)
   )
   port map (
      -- Cascade: 30-bit (each) output: Cascade Ports
      ACOUT => open,                   -- 30-bit output: A port cascade output
      BCOUT => open,                   -- 18-bit output: B port cascade output
      CARRYCASCOUT => open,     -- 1-bit output: Cascade carry output
      MULTSIGNOUT => open,       -- 1-bit output: Multiplier sign cascade output
      PCOUT => open,                   -- 48-bit output: Cascade output
      -- Control: 1-bit (each) output: Control Inputs/Status Bits
      OVERFLOW => open,             -- 1-bit output: Overflow in add/acc output
      PATTERNBDETECT => open, -- 1-bit output: Pattern bar detect output
      PATTERNDETECT => open,   -- 1-bit output: Pattern detect output
      UNDERFLOW => open,           -- 1-bit output: Underflow in add/acc output
      -- Data: 4-bit (each) output: Data Ports
      CARRYOUT => open,             -- 4-bit output: Carry output
      P => after_and_dsp0,                           -- 48-bit output: Primary data output
      -- Cascade: 30-bit (each) input: Cascade Ports
      ACIN => (others => '0'),                     -- 30-bit input: A cascade data input
      BCIN => (others => '0'),                     -- 18-bit input: B cascade input
      CARRYCASCIN => '0',       -- 1-bit input: Cascade carry input
      MULTSIGNIN => '0',         -- 1-bit input: Multiplier sign input
      PCIN => (others => '0'),                     -- 48-bit input: P cascade input
      -- Control: 4-bit (each) input: Control Inputs/Status Bits
      ALUMODE => "1100",               -- 4-bit input: ALU control input
      CARRYINSEL => "000",         -- 3-bit input: Carry select input
      CLK => clk_mp,                       -- 1-bit input: Clock input
      INMODE => "00010",                 -- 5-bit input: INMODE control input
      OPMODE => "0110011",                 -- 7-bit input: Operation mode input
      -- Data: 30-bit (each) input: Data Ports
      A => (others => '0'),                           -- 30-bit input: A data input
      B => dsp0_b_in,                           -- 18-bit input: B data input
      C => dsp0_c_in,                           -- 48-bit input: C data input
      CARRYIN => '0',               -- 1-bit input: Carry input signal
      D => (others => '0'),                           -- 25-bit input: D data input
      -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
      CEA1 => '0',                     -- 1-bit input: Clock enable input for 1st stage AREG
      CEA2 => '0',                     -- 1-bit input: Clock enable input for 2nd stage AREG
      CEAD => '0',                     -- 1-bit input: Clock enable input for ADREG
      CEALUMODE => '0',           -- 1-bit input: Clock enable input for ALUMODE
      CEB1 => '0',                     -- 1-bit input: Clock enable input for 1st stage BREG
      CEB2 => '0',                     -- 1-bit input: Clock enable input for 2nd stage BREG
      CEC => '0',                       -- 1-bit input: Clock enable input for CREG
      CECARRYIN => '0',           -- 1-bit input: Clock enable input for CARRYINREG
      CECTRL => '0',                 -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
      CED => '0',                       -- 1-bit input: Clock enable input for DREG
      CEINMODE => '0',             -- 1-bit input: Clock enable input for INMODEREG
      CEM => '0',                       -- 1-bit input: Clock enable input for MREG
      CEP => '0',                       -- 1-bit input: Clock enable input for PREG
      RSTA => '0',                     -- 1-bit input: Reset input for AREG
      RSTALLCARRYIN => '0',   -- 1-bit input: Reset input for CARRYINREG
      RSTALUMODE => '0',         -- 1-bit input: Reset input for ALUMODEREG
      RSTB => '0',                     -- 1-bit input: Reset input for BREG
      RSTC => '0',                     -- 1-bit input: Reset input for CREG
      RSTCTRL => '0',               -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
      RSTD => '0',                     -- 1-bit input: Reset input for DREG and ADREG
      RSTINMODE => '0',           -- 1-bit input: Reset input for INMODEREG
      RSTM => '0',                     -- 1-bit input: Reset input for MREG
      RSTP => '0'                      -- 1-bit input: Reset input for PREG
   );
 
U_mux0:mux4to1 
 generic map(DATAPATH_SIZE => 18)
 port map(
     sel  => cnt,
     inp0 => X"0000"&"00",
     inp1 => dsp1_b_in,
     inp2 => dsp2_b_in,
     inp3 => dsp3_b_in,
     outp  => b
); 
   
U_mux1:mux2to1 
 generic map(DATAPATH_SIZE => 48)
 port map(
     modemux => opm(4),
     inp0    => after_and_dsp0,
     inp1    => after_xor3_dsp3,
     outp    => c
);   
  
DSP48E1_inst1 : DSP48E1
      generic map (
         -- Feature Control Attributes: Data Path Selection
         A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
         B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
         USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
         USE_MULT => "NONE",            -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
         USE_SIMD => "ONE48",               -- SIMD selection ("ONE48", "TWO24", "FOUR12")
         -- Pattern Detector Attributes: Pattern Detection Configuration
         AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
         MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
         PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
         SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
         SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
         USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
         -- Register Control Attributes: Pipeline Register Configuration
         ACASCREG => 0,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
         ADREG => 1,                        -- Number of pipeline stages for pre-adder (0 or 1)
         ALUMODEREG => 0,                   -- Number of pipeline stages for ALUMODE (0 or 1)
         AREG => 0,                         -- Number of pipeline stages for A (0, 1 or 2)
         BCASCREG => 0,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
         BREG => 0,                         -- Number of pipeline stages for B (0, 1 or 2)
         CARRYINREG => 0,                   -- Number of pipeline stages for CARRYIN (0 or 1)
         CARRYINSELREG => 0,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
         CREG => 0,                         -- Number of pipeline stages for C (0 or 1)
         DREG => 1,                         -- Number of pipeline stages for D (0 or 1)
         INMODEREG => 0,                    -- Number of pipeline stages for INMODE (0 or 1)
         MREG => 0,                         -- Number of multiplier pipeline stages (0 or 1)
         OPMODEREG => 0,                    -- Number of pipeline stages for OPMODE (0 or 1)
         PREG => 1                          -- Number of pipeline stages for P (0 or 1)
      )
      port map (
         -- Cascade: 30-bit (each) output: Cascade Ports
         ACOUT => open,                   -- 30-bit output: A port cascade output
         BCOUT => open,                   -- 18-bit output: B port cascade output
         CARRYCASCOUT => open,     -- 1-bit output: Cascade carry output
         MULTSIGNOUT => open,       -- 1-bit output: Multiplier sign cascade output
         PCOUT => open,                   -- 48-bit output: Cascade output
         -- Control: 1-bit (each) output: Control Inputs/Status Bits
         OVERFLOW => open,             -- 1-bit output: Overflow in add/acc output
         PATTERNBDETECT => open, -- 1-bit output: Pattern bar detect output
         PATTERNDETECT => open,   -- 1-bit output: Pattern detect output
         UNDERFLOW => open,           -- 1-bit output: Underflow in add/acc output
         -- Data: 4-bit (each) output: Data Ports
         CARRYOUT => open,             -- 4-bit output: Carry output
         P => after_xor3_dsp3,                           -- 48-bit output: Primary data output
         -- Cascade: 30-bit (each) input: Cascade Ports
         ACIN => (others => '0'),                     -- 30-bit input: A cascade data input
         BCIN => (others => '0'),                     -- 18-bit input: B cascade input
         CARRYCASCIN => '0',       -- 1-bit input: Cascade carry input
         MULTSIGNIN => '0',         -- 1-bit input: Multiplier sign input
         PCIN => (others => '0'),                     -- 48-bit input: P cascade input
         -- Control: 4-bit (each) input: Control Inputs/Status Bits
         ALUMODE => "0100",               -- 4-bit input: ALU control input
         CARRYINSEL => "000",         -- 3-bit input: Carry select input
         CLK => clk_mp,                       -- 1-bit input: Clock input
         INMODE => "00010",                 -- 5-bit input: INMODE control input
         OPMODE => opm,                 -- 7-bit input: Operation mode input
         -- Data: 30-bit (each) input: Data Ports
         A => (others => '0'),                           -- 30-bit input: A data input
         B => b,                           -- 18-bit input: B data input
         C => c,                           -- 48-bit input: C data input
         CARRYIN => '0',               -- 1-bit input: Carry input signal
         D => (others => '0'),                           -- 25-bit input: D data input
         -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
         CEA1 => '0',                     -- 1-bit input: Clock enable input for 1st stage AREG
         CEA2 => '0',                     -- 1-bit input: Clock enable input for 2nd stage AREG
         CEAD => '0',                     -- 1-bit input: Clock enable input for ADREG
         CEALUMODE => '0',           -- 1-bit input: Clock enable input for ALUMODE
         CEB1 => '0',                     -- 1-bit input: Clock enable input for 1st stage BREG
         CEB2 => '0',                     -- 1-bit input: Clock enable input for 2nd stage BREG
         CEC => '0',                       -- 1-bit input: Clock enable input for CREG
         CECARRYIN => '0',           -- 1-bit input: Clock enable input for CARRYINREG
         CECTRL => '0',                 -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
         CED => '0',                       -- 1-bit input: Clock enable input for DREG
         CEINMODE => '0',             -- 1-bit input: Clock enable input for INMODEREG
         CEM => '0',                       -- 1-bit input: Clock enable input for MREG
         CEP => '1',                       -- 1-bit input: Clock enable input for PREG
         RSTA => '0',                     -- 1-bit input: Reset input for AREG
         RSTALLCARRYIN => '0',   -- 1-bit input: Reset input for CARRYINREG
         RSTALUMODE => '0',         -- 1-bit input: Reset input for ALUMODEREG
         RSTB => '0',                     -- 1-bit input: Reset input for BREG
         RSTC => '0',                     -- 1-bit input: Reset input for CREG
         RSTCTRL => '0',               -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
         RSTD => '0',                     -- 1-bit input: Reset input for DREG and ADREG
         RSTINMODE => '0',           -- 1-bit input: Reset input for INMODEREG
         RSTM => '0',                     -- 1-bit input: Reset input for MREG
         RSTP => '0'                      -- 1-bit input: Reset input for PREG
      );  

--DSP48E1_inst2 : DSP48E1
--            generic map (
--               -- Feature Control Attributes: Data Path Selection
--               A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
--               B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
--               USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
--               USE_MULT => "NONE",            -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
--               USE_SIMD => "ONE48",               -- SIMD selection ("ONE48", "TWO24", "FOUR12")
--               -- Pattern Detector Attributes: Pattern Detection Configuration
--               AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
--               MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
--               PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
--               SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
--               SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
--               USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
--               -- Register Control Attributes: Pipeline Register Configuration
--               ACASCREG => 0,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
--               ADREG => 0,                        -- Number of pipeline stages for pre-adder (0 or 1)
--               ALUMODEREG => 0,                   -- Number of pipeline stages for ALUMODE (0 or 1)
--               AREG => 0,                         -- Number of pipeline stages for A (0, 1 or 2)
--               BCASCREG => 0,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
--               BREG => 0,                         -- Number of pipeline stages for B (0, 1 or 2)
--               CARRYINREG => 0,                   -- Number of pipeline stages for CARRYIN (0 or 1)
--               CARRYINSELREG => 0,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
--               CREG => 0,                         -- Number of pipeline stages for C (0 or 1)
--               DREG => 0,                         -- Number of pipeline stages for D (0 or 1)
--               INMODEREG => 0,                    -- Number of pipeline stages for INMODE (0 or 1)
--               MREG => 0,                         -- Number of multiplier pipeline stages (0 or 1)
--               OPMODEREG => 0,                    -- Number of pipeline stages for OPMODE (0 or 1)
--               PREG => 0                          -- Number of pipeline stages for P (0 or 1)
--            )
--            port map (
--               -- Cascade: 30-bit (each) output: Cascade Ports
--               ACOUT => open,                   -- 30-bit output: A port cascade output
--               BCOUT => open,                   -- 18-bit output: B port cascade output
--               CARRYCASCOUT => open,     -- 1-bit output: Cascade carry output
--               MULTSIGNOUT => open,       -- 1-bit output: Multiplier sign cascade output
--               PCOUT => open,                   -- 48-bit output: Cascade output
--               -- Control: 1-bit (each) output: Control Inputs/Status Bits
--               OVERFLOW => open,             -- 1-bit output: Overflow in add/acc output
--               PATTERNBDETECT => open, -- 1-bit output: Pattern bar detect output
--               PATTERNDETECT => open,   -- 1-bit output: Pattern detect output
--               UNDERFLOW => open,           -- 1-bit output: Underflow in add/acc output
--               -- Data: 4-bit (each) output: Data Ports
--               CARRYOUT => open,             -- 4-bit output: Carry output
--               P => after_xor2_dsp2,                           -- 48-bit output: Primary data output
--               -- Cascade: 30-bit (each) input: Cascade Ports
--               ACIN => (others => '0'),                     -- 30-bit input: A cascade data input
--               BCIN => (others => '0'),                     -- 18-bit input: B cascade input
--               CARRYCASCIN => '0',       -- 1-bit input: Cascade carry input
--               MULTSIGNIN => '0',         -- 1-bit input: Multiplier sign input
--               PCIN => (others => '0'),                     -- 48-bit input: P cascade input
--               -- Control: 4-bit (each) input: Control Inputs/Status Bits
--               ALUMODE => "0100",               -- 4-bit input: ALU control input
--               CARRYINSEL => "000",         -- 3-bit input: Carry select input
--               CLK => CLK,                       -- 1-bit input: Clock input
--               INMODE => "00010",                 -- 5-bit input: INMODE control input
--               OPMODE => "0110011",                 -- 7-bit input: Operation mode input
--               -- Data: 30-bit (each) input: Data Ports
--               A => (others => '0'),                           -- 30-bit input: A data input
--               B => dsp2_b_in,                           -- 18-bit input: B data input
--               C => after_xor1_dsp1,                           -- 48-bit input: C data input
--               CARRYIN => '0',               -- 1-bit input: Carry input signal
--               D => (others => '0'),                           -- 25-bit input: D data input
--               -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
--               CEA1 => '0',                     -- 1-bit input: Clock enable input for 1st stage AREG
--               CEA2 => '0',                     -- 1-bit input: Clock enable input for 2nd stage AREG
--               CEAD => '0',                     -- 1-bit input: Clock enable input for ADREG
--               CEALUMODE => '0',           -- 1-bit input: Clock enable input for ALUMODE
--               CEB1 => '0',                     -- 1-bit input: Clock enable input for 1st stage BREG
--               CEB2 => '0',                     -- 1-bit input: Clock enable input for 2nd stage BREG
--               CEC => '0',                       -- 1-bit input: Clock enable input for CREG
--               CECARRYIN => '0',           -- 1-bit input: Clock enable input for CARRYINREG
--               CECTRL => '0',                 -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
--               CED => '0',                       -- 1-bit input: Clock enable input for DREG
--               CEINMODE => '0',             -- 1-bit input: Clock enable input for INMODEREG
--               CEM => '0',                       -- 1-bit input: Clock enable input for MREG
--               CEP => '0',                       -- 1-bit input: Clock enable input for PREG
--               RSTA => '0',                     -- 1-bit input: Reset input for AREG
--               RSTALLCARRYIN => '0',   -- 1-bit input: Reset input for CARRYINREG
--               RSTALUMODE => '0',         -- 1-bit input: Reset input for ALUMODEREG
--               RSTB => '0',                     -- 1-bit input: Reset input for BREG
--               RSTC => '0',                     -- 1-bit input: Reset input for CREG
--               RSTCTRL => '0',               -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
--               RSTD => '0',                     -- 1-bit input: Reset input for DREG and ADREG
--               RSTINMODE => '0',           -- 1-bit input: Reset input for INMODEREG
--               RSTM => '0',                     -- 1-bit input: Reset input for MREG
--               RSTP => '0'                      -- 1-bit input: Reset input for PREG
--            );  
            
--DSP48E1_inst3 : DSP48E1
--                        generic map (
--                           -- Feature Control Attributes: Data Path Selection
--                           A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
--                           B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
--                           USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
--                           USE_MULT => "NONE",            -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
--                           USE_SIMD => "ONE48",               -- SIMD selection ("ONE48", "TWO24", "FOUR12")
--                           -- Pattern Detector Attributes: Pattern Detection Configuration
--                           AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
--                           MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
--                           PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
--                           SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
--                           SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
--                           USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
--                           -- Register Control Attributes: Pipeline Register Configuration
--                           ACASCREG => 0,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
--                           ADREG => 0,                        -- Number of pipeline stages for pre-adder (0 or 1)
--                           ALUMODEREG => 0,                   -- Number of pipeline stages for ALUMODE (0 or 1)
--                           AREG => 0,                         -- Number of pipeline stages for A (0, 1 or 2)
--                           BCASCREG => 0,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
--                           BREG => 0,                         -- Number of pipeline stages for B (0, 1 or 2)
--                           CARRYINREG => 0,                   -- Number of pipeline stages for CARRYIN (0 or 1)
--                           CARRYINSELREG => 0,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
--                           CREG => 0,                         -- Number of pipeline stages for C (0 or 1)
--                           DREG => 0,                         -- Number of pipeline stages for D (0 or 1)
--                           INMODEREG => 0,                    -- Number of pipeline stages for INMODE (0 or 1)
--                           MREG => 0,                         -- Number of multiplier pipeline stages (0 or 1)
--                           OPMODEREG => 0,                    -- Number of pipeline stages for OPMODE (0 or 1)
--                           PREG => 0                          -- Number of pipeline stages for P (0 or 1)
--                        )
--                        port map (
--                           -- Cascade: 30-bit (each) output: Cascade Ports
--                           ACOUT => open,                   -- 30-bit output: A port cascade output
--                           BCOUT => open,                   -- 18-bit output: B port cascade output
--                           CARRYCASCOUT => open,     -- 1-bit output: Cascade carry output
--                           MULTSIGNOUT => open,       -- 1-bit output: Multiplier sign cascade output
--                           PCOUT => open,                   -- 48-bit output: Cascade output
--                           -- Control: 1-bit (each) output: Control Inputs/Status Bits
--                           OVERFLOW => open,             -- 1-bit output: Overflow in add/acc output
--                           PATTERNBDETECT => open, -- 1-bit output: Pattern bar detect output
--                           PATTERNDETECT => open,   -- 1-bit output: Pattern detect output
--                           UNDERFLOW => open,           -- 1-bit output: Underflow in add/acc output
--                           -- Data: 4-bit (each) output: Data Ports
--                           CARRYOUT => open,             -- 4-bit output: Carry output
--                           P => after_xor3_dsp3,                           -- 48-bit output: Primary data output
--                           -- Cascade: 30-bit (each) input: Cascade Ports
--                           ACIN => (others => '0'),                     -- 30-bit input: A cascade data input
--                           BCIN => (others => '0'),                     -- 18-bit input: B cascade input
--                           CARRYCASCIN => '0',       -- 1-bit input: Cascade carry input
--                           MULTSIGNIN => '0',         -- 1-bit input: Multiplier sign input
--                           PCIN => (others => '0'),                     -- 48-bit input: P cascade input
--                           -- Control: 4-bit (each) input: Control Inputs/Status Bits
--                           ALUMODE => "0100",               -- 4-bit input: ALU control input
--                           CARRYINSEL => "000",         -- 3-bit input: Carry select input
--                           CLK => clk_mp,                       -- 1-bit input: Clock input
--                           INMODE => "00010",                 -- 5-bit input: INMODE control input
--                           OPMODE => "0110011",                 -- 7-bit input: Operation mode input
--                           -- Data: 30-bit (each) input: Data Ports
--                           A => (others => '0'),                           -- 30-bit input: A data input
--                           B => dsp3_b_in,                           -- 18-bit input: B data input
--                           C => after_xor2_dsp2,                           -- 48-bit input: C data input
--                           CARRYIN => '0',               -- 1-bit input: Carry input signal
--                           D => (others => '0'),                           -- 25-bit input: D data input
--                           -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
--                           CEA1 => '0',                     -- 1-bit input: Clock enable input for 1st stage AREG
--                           CEA2 => '0',                     -- 1-bit input: Clock enable input for 2nd stage AREG
--                           CEAD => '0',                     -- 1-bit input: Clock enable input for ADREG
--                           CEALUMODE => '0',           -- 1-bit input: Clock enable input for ALUMODE
--                           CEB1 => '0',                     -- 1-bit input: Clock enable input for 1st stage BREG
--                           CEB2 => '0',                     -- 1-bit input: Clock enable input for 2nd stage BREG
--                           CEC => '0',                       -- 1-bit input: Clock enable input for CREG
--                           CECARRYIN => '0',           -- 1-bit input: Clock enable input for CARRYINREG
--                           CECTRL => '0',                 -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
--                           CED => '0',                       -- 1-bit input: Clock enable input for DREG
--                           CEINMODE => '0',             -- 1-bit input: Clock enable input for INMODEREG
--                           CEM => '0',                       -- 1-bit input: Clock enable input for MREG
--                           CEP => '0',                       -- 1-bit input: Clock enable input for PREG
--                           RSTA => '0',                     -- 1-bit input: Reset input for AREG
--                           RSTALLCARRYIN => '0',   -- 1-bit input: Reset input for CARRYINREG
--                           RSTALUMODE => '0',         -- 1-bit input: Reset input for ALUMODEREG
--                           RSTB => '0',                     -- 1-bit input: Reset input for BREG
--                           RSTC => '0',                     -- 1-bit input: Reset input for CREG
--                           RSTCTRL => '0',               -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
--                           RSTD => '0',                     -- 1-bit input: Reset input for DREG and ADREG
--                           RSTINMODE => '0',           -- 1-bit input: Reset input for INMODEREG
--                           RSTM => '0',                     -- 1-bit input: Reset input for MREG
--                           RSTP => '0'                      -- 1-bit input: Reset input for PREG
--                        );    

proc_cnt: process(clk_mp,cnt)
begin
    
    if (clk_mp'event and clk_mp = '1') then
        cnt <= std_logic_vector(unsigned(cnt) + 1);
    end if;
    
    if cnt="00" then
    opm <= opm1;
    else
    opm <=opm2;
    end if;
    
end process;
          
end behavior;