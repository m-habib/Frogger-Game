library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity select_sound is
port 	(
	   CLK  						: in std_logic;
		RESETn					: in std_logic;
		restart_game_N			: in std_logic;
		goal_achived_N			: in std_logic;
		hitN						: in std_logic;
		jump                 : in std_logic;
		frogStartY 				: in integer;
		sound_num				: inout std_logic_vector(1 downto 0)
	);
end select_sound;

architecture behav of select_sound is 


begin
process (RESETn, CLK, restart_game_N)
begin
	if RESETn = '0' or restart_game_N = '0' then
		sound_num <= "00";
	elsif rising_edge(CLK) then
		if sound_num /= "00" then
			sound_num <= "00";
		else
			if goal_achived_N = '0' then
				sound_num <= "10";
			elsif hitN = '0' then
				if frogStartY > 69 then
					sound_num <= "01";
				end if;
			elsif jump = '1' then
				sound_num <= "11";
			else
				sound_num <= "00";
			end if;
		end if;
	end if;
end process;
end behav;		
		