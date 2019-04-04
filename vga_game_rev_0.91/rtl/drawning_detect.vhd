library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity drawning_detect is
port 	(
		CLK						: in std_logic;
		RESETn					: in std_logic;
		sea_lastY				: in integer;
		frog_startY				: in integer;
		Drawing_Request_frog	: in std_logic;
		Drawing_Request_1 	: in std_logic;
		Drawing_Request_2 	: in std_logic;
		Drawing_Request_3 	: in std_logic;
		Drawing_Request_4 	: in std_logic;
		Drawing_Request_5 	: in std_logic;
		timer_done				: in std_logic;
		Drawning_N 				: out std_logic
);
end drawning_detect;


architecture behav of drawning_detect is 
begin
	process ( RESETn,CLK)
		begin
			if RESETn = '0' then
				Drawning_N <= '1';
			elsif rising_edge(CLK) then
				if(Drawing_Request_frog = '1' and frog_startY < sea_lastY and frog_startY >= 69) then
					if (Drawing_Request_frog = '1' and Drawing_Request_1 = '1') or 
						(Drawing_Request_frog = '1' and Drawing_Request_2 = '1') or 
						(Drawing_Request_frog = '1' and Drawing_Request_3 = '1') or 
						(Drawing_Request_frog = '1' and Drawing_Request_4 = '1') or 
						(Drawing_Request_frog = '1' and Drawing_Request_5 = '1') then
							Drawning_N <= '1';
					else
						Drawning_N <= '0';
					end if;
				else
					Drawning_N <= '1';
				end if;
		end if;
	end process;
end behav;