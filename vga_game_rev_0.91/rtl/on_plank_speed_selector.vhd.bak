library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity on_plank_check is
port 	(
		CLK				: in std_logic;
		RESETn			: in std_logic; 
		Drawing_Request_frog	: in std_logic;
		Drawing_Request_p1 	: in std_logic;
		Drawing_Request_p2 	: in std_logic;
		turn_off_on_plank_N : in std_logic;
		speed_1 : in integer;
		speed_2 : in integer;
		on_plank : out std_logic;
		collisionN : out std_logic;
		plank_speed : out integer
);
end on_plank_check;


architecture behav of on_plank_check is 
signal on_plank_flag : std_logic;
begin
	process ( RESETn,CLK)
		begin
			if RESETn = '0' then
				on_plank <= '0';
				collisionN <= '1';
				on_plank_flag <= '0';
				plank_speed <= 0;

			elsif rising_edge(CLK) then
				if(turn_off_on_plank_N = '0') then
					on_plank_flag <= '0';
					plank_speed <= 0;
				end if;
				if(on_plank_flag = '0') then
					if Drawing_Request_frog = '1' and Drawing_Request_p1 = '1' then
						on_plank_flag <= '1';
						on_plank <= '1';
						collisionN <= '0';
						plank_speed <= speed_1;
					elsif Drawing_Request_frog = '1' and Drawing_Request_p2 = '1' then
						on_plank_flag <= '1';
						on_plank <= '1';
						collisionN <= '0';
						plank_speed <= speed_2;
					else
						on_plank_flag <= '0';
						on_plank <= '0';
						collisionN <= '1';
						plank_speed <= 0;
					end if;
				end if;
			end if;
	end process;
end behav;