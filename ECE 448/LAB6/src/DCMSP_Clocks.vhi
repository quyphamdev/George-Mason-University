
-- VHDL Instantiation Created from source file DCMSP_Clocks.vhd -- 16:45:32 04/09/2010
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT DCMSP_Clocks
	PORT(
		CLKIN_IN : IN std_logic;          
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;

	Inst_DCMSP_Clocks: DCMSP_Clocks PORT MAP(
		CLKIN_IN => ,
		CLKIN_IBUFG_OUT => ,
		CLK0_OUT => ,
		LOCKED_OUT => 
	);


