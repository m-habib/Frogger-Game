library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity score_count is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  						: in std_logic;
		RESETn					: in std_logic;
		lane_passed				: in std_logic;
		goal_achived_N			: in std_logic;
		all_goals_achived 	: in std_logic;
		restart_game_N 			: in std_logic;
		scoreL					: out std_logic_vector(3 downto 0);
		scoreM					: out std_logic_vector(3 downto 0);
		scoreH					: out std_logic_vector(3 downto 0);
		new_high_score			: out std_logic
	);
end score_count;

architecture behav of score_count is 
--signal score_credit : integer;

signal sig_L : std_logic_vector(3 downto 0);
signal sig_H : std_logic_vector(3 downto 0);
signal sig_M : std_logic_vector(3 downto 0);
begin
	process (clk, resetN, restart_game_N)
	variable I : integer;
	variable score_credit : integer;
	begin
		if resetN = '0' or restart_game_N = '0' then
			sig_H <= "0000";
			sig_L <= "0000";
			sig_M <= "0000";
			score_credit := 0;
		elsif (rising_edge(clk)) then	
			score_credit := 0;
			if all_goals_achived = '1' then
				sig_H <= sig_H  + 1;
			elsif goal_achived_N = '0' then
				sig_M <= sig_M  + 1;
			elsif lane_passed = '1' then
				sig_L <= sig_L  + 1;
			end if;
			
			if sig_L = "1010" then
				sig_L <= "0000";
				sig_M <= sig_M  + 1;
				if sig_M = "1010" then
					sig_M <= "0000";
					sig_H <= sig_H + 1;
					if sig_H = "1010" then
						sig_H <= "0000";
					end if;
				end if;
			end if;
			
			if sig_M = "1010" then
				sig_M <= "0000";
				sig_H <= sig_H  + 1;
				if sig_H = "1010" then
					sig_H <= "0000";
				end if;
			end if;
		end if;
		scoreL <= sig_L;
		scoreM <= sig_M;
		scoreH <= sig_H;
	end process;	
end behav;