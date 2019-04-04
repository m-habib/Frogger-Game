library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity level_handler is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  						: in std_logic;
		resetN					: in std_logic;
		restart_game_N			: in std_logic;
		all_goals_achived 	: in std_logic;
		level_up_1				: inout std_logic;
		level_up_2				: inout std_logic;
		level_up_3				: inout std_logic;
		level_up_4				: inout std_logic;
		level_up_5				: inout std_logic;
		level_up					: inout std_logic;
		KBD_in					: in std_logic_vector(7 downto 0);
		make 						: in std_logic;
		level						: out integer;
		master					: inout std_logic
	);
end level_handler;

architecture behav of level_handler is 
signal level_tmp : integer := 0;
begin
	process (clk, resetN, restart_game_N, all_goals_achived)
	begin
		if resetN = '0' or restart_game_N = '0' then
			level <= 0;
			level_tmp <= 1;
			level_up_1 <= '0';
			level_up_2 <= '0';
			level_up_3 <= '0';
			level_up_4 <= '0';
			level_up_5 <= '0';
			level_up <= '0';
			master <= '0';
		elsif (rising_edge(clk)) then	
			if level_up = '1' or level_up_1 = '1' or level_up_2 = '1' or level_up_3 = '1' or level_up_4 = '1' or level_up_5 = '1'  then
				level_up_1 <= '0';
				level_up_2 <= '0';
				level_up_3 <= '0';
				level_up_4 <= '0';
				level_up_5 <= '0';
				level_up <= '0';
			end if;
			if (KBD_in = "00111010" and make = '1') then --3A = M
				master <= not(master);
			end if;
			if (all_goals_achived = '1') then
				level_tmp <= level_tmp + 1;
				level_up <= '1';
				if (level_tmp = 1) then
					level_up_1 <= '1';
					level_up_3 <= '1';
					level_up_5 <= '1';
					master <= '0';
				elsif (level_tmp = 2) then
					level_up_2 <= '1';
					level_up_5 <= '1';
					master <= '1';
				elsif level_tmp = 3 then
					level_up_5 <= '1';
					master <= '0';
				elsif (level_tmp = 4) then
					level_up_1 <= '1';
					level_up_3 <= '1';
					master <= '0';
				elsif (level_tmp = 5) then
					level_up_2 <= '1';
					level_up_5 <= '1';
					master <= '0';
				elsif level_tmp = 6 then
					level_up_5 <= '1';
					master <= '0';
				end if;
			end if;
		end if;
		level <= level_tmp;
	end process;	
end behav;