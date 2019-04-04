library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity lifeBonus_collision is
port 	(
		CLK								: in std_logic;
		RESETn							: in std_logic; 
		Drawing_Request_frog			: in std_logic;
		Drawing_Request_lifeBonus 	: in std_logic;
		collision_N 					: inout std_logic
);
end lifeBonus_collision;


architecture behav of lifeBonus_collision is 
begin
	process ( RESETn,CLK)
		begin
			if RESETn = '0' then
				collision_N <= '1';
			elsif rising_edge(CLK) then
				if collision_N = '0' then
					collision_N <= '1';
				else
					if  Drawing_Request_frog = '1' and Drawing_Request_lifeBonus = '1'then
						collision_N <= '0';
					else
						collision_N <= '1';
					end if;
				end if;
			end if;
	end process;
end behav;