library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity life_counter is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  					: in std_logic;
		RESETn				: in std_logic;
		carHit_N				: in std_logic;
		Drawning_N			: in std_logic;
		land_border_hit_N : in std_logic;
		restart_game_N		: in std_logic;
		level_up				: in std_logic;
		lifebonus_won_N	: in std_logic;
		life					: out  std_logic_vector(3 downto 0);
		died					: inout std_logic
		
	);
end life_counter;

architecture behav of life_counter is 
signal life_tmp : std_logic_vector(3 downto 0);
signal counter : integer;
signal waiting : std_logic;
begin
process ( RESETn, CLK, restart_game_N)
   begin
	if RESETn = '0' or restart_game_N = '0'then
		life_tmp <= "0101";
		life <= "0101";
		died <= '0';
		waiting <= '0';
		counter <= 0;
	elsif rising_edge(CLK) then
		if died = '1' then 
			died <= '0';
		elsif  level_up = '1' and life_tmp < 9 then
			life_tmp <= life_tmp + 1;
		elsif  lifebonus_won_N = '0' then
			life_tmp <= life_tmp + 1;
		else
			if waiting = '1' then
				if counter < 26000000 then
					counter <= counter + 1;
				else
					waiting <= '0';
					counter <= 0;
				end if;
			else
				if (carHit_N = '0' or Drawning_N = '0' or land_border_hit_N = '0') then
					waiting <= '1';
					life_tmp <= life_tmp - 1;
					if (life_tmp = 1) then
						died <= '1';
					end if;
				end if;
			end if;
		end if;
		life <= life_tmp;
	end if;
  end process;		
end behav;