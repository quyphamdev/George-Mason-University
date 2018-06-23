-------------------------------------------------------------------------------
--
-- Title       : TopLevel
-- Design      : MISP32
-- Author      : Jason
-- Company     : Jason Inc
--
-------------------------------------------------------------------------------
--
-- File        : TopLevel.vhd
-- Generated   : Sun Jan 31 02:19:00 2010
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {TopLevel} architecture {TopLevel}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity TopLevel is
	 port(
		 Instruction : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Reg_B : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Reg_A : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rs_addr : out STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rt_addr : out STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rd_addr : out STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Result : out STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Zero : out STD_LOGIC;
		 RegWrite : out STD_LOGIC;
		 RegDst : out STD_LOGIC
	     );
end TopLevel;

--}} End of automatically maintained section

architecture TopLevel of TopLevel is
component InstrDecode is
	 port(
		 Instruction : in STD_LOGIC_VECTOR(31 downto 0);
		 Rs_addr : out STD_LOGIC_VECTOR(4 downto 0);
		 Rt_addr : out STD_LOGIC_VECTOR(4 downto 0);
		 Rd_addr : out STD_LOGIC_VECTOR(4 downto 0);
		 opcode : out STD_LOGIC_VECTOR(5 downto 0);
		 Funct : out STD_LOGIC_VECTOR(5 downto 0);
		 Imm : out STD_LOGIC_VECTOR(15 downto 0)
	     );
end component;
component extend is
	 port(
		 Imm : in STD_LOGIC_VECTOR(15 DOWNTO 0);
		 SignExt : in STD_LOGIC;
		 Extended : out STD_LOGIC_VECTOR(31 DOWNTO 0)
	     );
end component;
component Control is
	 port(
		 opcode : in STD_LOGIC_VECTOR(5 DOWNTO 0);
		 Funct : in STD_LOGIC_VECTOR(5 DOWNTO 0);
		 SignExt : out STD_LOGIC;
		 ALUSrc : out STD_LOGIC;
		 RegWrite : out STD_LOGIC;
		 RegDst : out STD_LOGIC;
		 ALU_OP : out STD_LOGIC_VECTOR(3 DOWNTO 0)
	     );
end component;
component alu is
	 port(
		 ALU_OP : in STD_LOGIC_VECTOR(3 DOWNTO 0);
		 A : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		 B : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Result : out STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Zero : out STD_LOGIC
	     );
end component;
component mux2 is
	 port(
		 Reg_B : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ExtImm : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Mux2Sel : in STD_LOGIC;
		 Mux2Out : out STD_LOGIC_VECTOR(31 DOWNTO 0)
	     );
end component;

signal opcode : std_logic_vector (5 downto 0);
signal Funct : std_logic_vector (5 downto 0);
signal Imm : std_logic_vector	(15 downto 0);
signal Extended : std_logic_vector (31 downto 0);
signal SignExt : std_logic;
signal ALUSrc : std_logic;
signal ALU_OP : std_logic_vector (3 downto 0);
signal Mux2Out : std_logic_vector (31 downto 0);

begin

	-- enter your statements here --
	InstrDecoder: InstrDecode port map (
								Instruction => Instruction,
								Rs_addr => Rs_addr,
								Rt_addr => Rt_addr,
								Rd_addr => Rd_addr,
								opcode => opcode,
								Funct => Funct,
								Imm => Imm
	);
	ExtImm: extend port map (
						Imm => Imm,
						SignExt => SignExt,
						Extended => Extended
	);
	Mux: mux2 port map (
					ExtImm => Extended,
					Reg_B => Reg_B,
					Mux2Sel => ALUSrc,
					Mux2Out => Mux2Out
	);
	Ctrl: Control port map (
						opcode => opcode,
						Funct => Funct,
						SignExt => SignExt,
						ALUSrc => ALUSrc,
						RegWrite => RegWrite,
						RegDst => RegDst,
						ALU_OP => ALU_OP
	);
	alu1: alu port map (
					ALU_OP => ALU_OP,
					A => Reg_A,
					B => Mux2Out,
					Result => Result,
					Zero => Zero
	);

end TopLevel;
