library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity collision_with_land_and_border is
port 	(
		CLK						: in std_logic;
		RESETn					: in std_logic; 
		Drawing_Request_frog	: in std_logic;
		Drawing_Request_1 	: in std_logic;
		Drawing_Request_2 	: in std_logic;
		Drawing_Request_3 	: in std_logic;
		Drawing_Request_4 	: in std_logic;
		collision_N 			: inout std_logic;
		crocodile_hit_N		: out std_logic
);
end collision_with_land_and_border;


architecture behav of collision_with_land_and_border is 
begin
	process ( RESETn,CLK)
		begin
			if RESETn = '0' then
				collision_N <= '1';
				crocodile_hit_N <= '1';
			elsif rising_edge(CLK) then
				if collision_N = '0' then
					collision_N <= '1';
					crocodile_hit_N <= '1';
				else
					if Drawing_Request_frog = '1' then
						if Drawing_Request_1 = '1' or
							Drawing_Request_2 = '1' or
							Drawing_Request_3 = '1' or
							Drawing_Request_4 = '1' then
								collision_N <= '0';
								if Drawing_Request_4 = '1' then
									crocodile_hit_N <= '0';
								end if;
						else
							collision_N <= '1';
						end if;
					end if;
				end if;
			end if;
	end process;
end behav;