library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity goal_achived_check is
port 	(
		CLK				: in std_logic;
		RESETn			: in std_logic; 
		restart_game_N			: in std_logic;
		frog_startX				: in integer;
		frog_startY				: in integer;
		crocodile_on			: in std_logic;
		crocodile_goal 		: in std_logic_vector(2 downto 0);
		collisionN 				: inout std_logic;
		achived_1 				: out std_logic;
		achived_2 				: out std_logic;
		achived_3 				: out std_logic;
		achived_4 				: out std_logic;
		achived_5 				: out std_logic;
		all_achived_reset		: in std_logic
);
end goal_achived_check;


architecture behav of goal_achived_check is 
signal achived_flag_1 : std_logic;
signal achived_flag_2 : std_logic;
signal achived_flag_3 : std_logic;
signal achived_flag_4 : std_logic;
signal achived_flag_5 : std_logic;
signal waiting : std_logic;
signal counter	: integer;
begin
	process ( RESETn,CLK, restart_game_N)
		begin
		 if RESETn = '0' or restart_game_N = '0' then
				achived_flag_1 <= '0';
				achived_1 <= '0';
				collisionN <= '1';
				achived_flag_2 <= '0';
				achived_2 <= '0';
				achived_flag_3 <= '0';
				achived_3 <= '0';
				achived_flag_4 <= '0';
				achived_4 <= '0';
				achived_flag_5 <= '0';
				achived_5 <= '0';
				waiting <= '0';
				counter <= 0;
		elsif rising_edge(CLK) then
			if collisionN = '0' then
				collisionN <= '1';
			elsif all_achived_reset = '1' then
					achived_flag_1 <= '0';
					achived_1 <= '0';
					achived_flag_2 <= '0';
					achived_2 <= '0';
					achived_flag_3 <= '0';
					achived_3 <= '0';
					achived_flag_4 <= '0';
					achived_4 <= '0';
					achived_flag_5 <= '0';
					achived_5 <= '0';
					waiting <= '0';
					counter <= 0;
			else
				if waiting = '1' then
					if counter < 27000000 then 
						counter <= counter + 1;
					else
						counter <= 0;
						waiting <= '0';
					end if;
				else
					if frog_startY < 69  then
						if frog_startX >= 50 and (frog_startX + 26) <= 109 then
							if crocodile_goal /= "000" then 
								achived_1 <= '1';
								achived_flag_1 <= '1';
								collisionN <= '0';
								waiting <= '1';
							end if;
						elsif frog_startX >= 170 and (frog_startX + 26) <= 230 then
							if crocodile_goal /= "001" then
								achived_2 <= '1';
								achived_flag_2 <= '1';
								collisionN <= '0';
								waiting <= '1';
							end if;
						elsif frog_startX >= 290 and (frog_startX + 26) <= 350 then
							if crocodile_goal /= "010" then 
								achived_3 <= '1';
								achived_flag_3 <= '1';
								collisionN <= '0';
								waiting <= '1';
							end if;
						elsif frog_startX >= 410 and (frog_startX + 26) <= 470 then
							if crocodile_goal /= "011" then 
								achived_4 <= '1';
								achived_flag_4 <= '1';
								collisionN <= '0';
								waiting <= '1';
							end if;
						elsif frog_startX >= 530 and (frog_startX + 26) <= 590 then
							if crocodile_goal /= "100" then 
								achived_5 <= '1';
								achived_flag_5 <= '1';
								collisionN <= '0';
								waiting <= '1';
							end if;
						end if;
	--					if achived_flag_1 = '1' and achived_flag_2 = '1' and achived_flag_3 = '1' and achived_flag_4 = '1' and achived_flag_5 = '1' then
	--						all_achived <= '1';
	--					end if;
					end if;
				end if;
			end if;
		end if;
	end process;
end behav;