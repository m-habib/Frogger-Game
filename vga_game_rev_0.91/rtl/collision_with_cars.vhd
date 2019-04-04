library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity collision_with_cars is
port 	(
		CLK						: in std_logic;
		RESETn					: in std_logic; 
		Drawing_Request_frog	: in std_logic;
		Drawing_Request_1 	: in std_logic;
		Drawing_Request_2 	: in std_logic;
		Drawing_Request_3 	: in std_logic;
		Drawing_Request_4 	: in std_logic;
		Drawing_Request_5 	: in std_logic;
		collision_N 			: inout std_logic
);
end collision_with_cars;


architecture behav of collision_with_cars is 
begin
	process ( RESETn,CLK)
	begin
		if RESETn = '0' then
				collision_N <= '1';
		elsif rising_edge(CLK) then
			if collision_N = '0' then
				collision_N <= '1';
			else
				if (Drawing_Request_frog = '1' and Drawing_Request_1 = '1') or 
					(Drawing_Request_frog = '1' and Drawing_Request_2 = '1') or 
					(Drawing_Request_frog = '1' and Drawing_Request_3 = '1') or 
					(Drawing_Request_frog = '1' and Drawing_Request_4 = '1') or 
					(Drawing_Request_frog = '1' and Drawing_Request_5 = '1') then
						collision_N <= '0';
				end if;
			end if;
		end if;
	end process;
end behav;