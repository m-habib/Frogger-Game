library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
	port (clk, ResetN, LOAD : in std_logic ;
			Init : in std_logic_vector(3 downto 0);
			Q: out std_logic_vector(3 downto 0);
			TC: out std_logic);
end counter;

architecture arc_counter of counter is
begin
	process (clk, ResetN)
	variable Qtmp : std_logic_vector(3 downto 0);
	begin
		if ResetN = '0' then
			Qtmp := "0000";
			TC <= '0';
		elsif rising_edge(clk) then
			if LOAD = '1' then
				Qtmp := Init;
				if Qtmp = "1000" then
					TC <= '1';
				else
					TC <= '0';
				end if;
			else
					Qtmp := Qtmp + 1;
				if Qtmp = "1000" then
					TC <= '1';
				else
					TC <= '0';
				end if;
				if Qtmp = "0101" then
					Qtmp := "0111";
				end if;
				if Qtmp = "1001" then
					Qtmp := "0000";
					TC <= '0';
				end if;
			end if;
		end if;
		Q <= Qtmp;
	end process;
end arc_counter;
