library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity debounce is
	generic( bit_size: natural := 8);
	port (
		clk		: in	std_logic;				-- The slow clk1k
		btn		: in	std_logic_vector(3 downto 0);	-- The bouncing input
		button	: out	std_logic_vector(3 downto 0));	-- The debounced output
end debounce;

architecture behavior of debounce is
begin		
	button_gen : for p in btn'range generate
        debounce_block: block is
            signal count		: unsigned(bit_size-1 downto 0)	:= (others => '0');
            alias  state		: unsigned(1 downto 0) is count(count'LEFT downto count'LEFT-1);

        begin
            --------------------------------
            -- MAP THE OUTPUTS
            --------------------------------
            button(p)	<= count(count'LEFT);
            --------------------------------
            -- CLOCK DIVIDER PROCESS
            --------------------------------
            countProc : process (clk)
            begin
                if rising_edge(clk) then
                    case state is
                        when "00" =>
                            if btn(p) = '1' then
                                count	<= count - 1;
                            else
                                count	<= (others => '0');
                            end if;
                        when "11" =>
                            count	<= count - 1;
                        when "10" =>
                            if btn(p) = '0' then
                                count	<= count - 1;
                            end if;
                        when "01" =>
                            count	<= count - 1;
                        when others =>
                            count	<= (others => '0');
                    end case;
                end if;
            end process countProc;
        end block;
	end generate button_gen;
end behavior;
