library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity on_plank_speed_selector is
port 	(
		CLK				: in std_logic;
		RESETn			: in std_logic;
		sea_lastY 		: in integer;
		frog_startY 	: in integer;
		startY_1 		: in integer;
		startY_2 		: in integer;
		startY_3 		: in integer;
		startY_4 		: in integer;
		speed_1 			: in integer;
		speed_2 			: in integer;
		speed_3 			: in integer;
		speed_4			: in integer;
		restart_N			: in std_logic;
		selected_speed : out integer
);
end on_plank_speed_selector;


architecture behav of on_plank_speed_selector is 
begin
	process ( RESETn,CLK, restart_N)
		begin
			if RESETn = '0' or restart_N = '0' then
				selected_speed <= 0;
			elsif rising_edge(CLK) then
				if	frog_startY > sea_lastY then selected_speed <= 0;		
				elsif frog_startY >= startY_1 then selected_speed <= speed_1;
				elsif frog_startY >= startY_2 then selected_speed <= speed_2;
				elsif frog_startY >= startY_3 then selected_speed <= speed_3;
				elsif frog_startY >= startY_4 then selected_speed <= speed_4;
				else selected_speed <= 0;
				end if;
			end if;
	end process;
end behav;