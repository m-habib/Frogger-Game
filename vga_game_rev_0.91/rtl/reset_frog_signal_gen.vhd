library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity reset_frog_signal_gen is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  					: in std_logic;
		RESETn				: in std_logic;
		carHit_N				: in std_logic;
		Drawning_N			: in std_logic;
		land_border_hit_N : in std_logic;
		collision_goal_N	: in std_logic;
		restart_N			: in std_logic;
		hit_N					: out std_logic;
		frog_reset_N_delayed		: inout std_logic
	);
end reset_frog_signal_gen;

architecture behav of reset_frog_signal_gen is 
signal delay_count : integer;
signal couting : std_logic;
begin
process ( RESETn, CLK, restart_N)
   begin
	if RESETn = '0' or restart_N = '0' then
		frog_reset_N_delayed <= '1';
		couting <= '0';
		delay_count <= 0;
		hit_N <= '1';
	elsif rising_edge(CLK) then
		if frog_reset_N_delayed = '0' then 
			frog_reset_N_delayed <= '1';
		else
			if (carHit_N = '0' or Drawning_N = '0' or land_border_hit_N = '0' or collision_goal_N = '0') then
				couting <= '1';
				delay_count <= 0;
				hit_N <= '0';
			end if;
			if couting = '1' then
				if delay_count <= 25000000 then
						delay_count <= delay_count + 1;
				else
					delay_count <= 0;
					couting <= '0';
					frog_reset_N_delayed <= '0';
					hit_N <= '1';
				end if;
			end if;
		end if;
	end if;
  end process;		
end behav;