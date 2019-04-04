library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity achived_delay is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  					: in std_logic  ;
		RESETn				: in std_logic  ;
		achived_1			: in std_logic  ;
		achived_2			: in std_logic  ;
		achived_3			: in std_logic  ;
		achived_4			: in std_logic  ;
		achived_5			: in std_logic  ;
		restart_N			: in std_logic  ;
		achived_1_d			: inout std_logic  ;
		achived_2_d			: inout std_logic  ;
		achived_3_d			: inout std_logic  ;
		achived_4_d			: inout std_logic  ;
		achived_5_d			: inout std_logic  ;
		all_achived_d 		: inout std_logic  ;
		collision_N_delayed : inout std_logic
	);
end achived_delay;

architecture behav of achived_delay is 
signal delay_count : integer;
signal waiting : std_logic;
signal delayed_1 : std_logic;
signal delayed_2 : std_logic;
signal delayed_3 : std_logic;
signal delayed_4 : std_logic;
signal delayed_5 : std_logic;
signal delayed_all : std_logic;

begin
process (RESETn, CLK, restart_N)
   begin
	if RESETn = '0' or restart_N = '0' then
		achived_1_d <= '0';
		achived_2_d <= '0';
		achived_3_d <= '0';
		achived_4_d <= '0';
		achived_5_d <= '0';
		all_achived_d <= '0';
		delayed_1 <= '0';
		delayed_2 <= '0';
		delayed_3 <= '0';
		delayed_4 <= '0';
		delayed_5 <= '0';
		delay_count <=  0;
		delayed_all <= '0';
		waiting <= '0';
		collision_N_delayed <= '1';
	elsif rising_edge(CLK) then
		if collision_N_delayed = '0' then
			collision_N_delayed <= '1';
		end if;
	
		if (all_achived_d = '1') then
			all_achived_d <= '0';
			achived_1_d <= '0';
			achived_2_d <= '0';
			achived_3_d <= '0';
			achived_4_d <= '0';
			achived_5_d <= '0';
			delayed_1 <= '0';
			delayed_2 <= '0';
			delayed_3 <= '0';
			delayed_4 <= '0';
			delayed_5 <= '0';
			delay_count <=  0;
			delayed_all <= '0';
			waiting <= '0';
			collision_N_delayed <= '1';
		else
			if achived_1_d = '1' and achived_2_d = '1' and achived_3_d = '1' and achived_4_d = '1' and achived_5_d = '1' then
				waiting <= '1';
				delay_count <= 0;
				delayed_all <= '1';
				collision_N_delayed <= '1';
			elsif (achived_1 = '1' and delayed_1 = '0') then 
				waiting <= '1';
				delay_count <= 0;
				delayed_1 <= '1';
			elsif (achived_2 = '1' and delayed_2 = '0') then 
				waiting <= '1';
				delay_count <= 0;
				delayed_2 <= '1';
			elsif (achived_3 = '1' and delayed_3 = '0') then 
				waiting <= '1';
				delay_count <= 0;
				delayed_3 <= '1';
			elsif (achived_4 = '1' and delayed_4 = '0') then 
				waiting <= '1';
				delay_count <= 0;
				delayed_4 <= '1';
			elsif (achived_5 = '1' and delayed_5 = '0') then 
				waiting <= '1';
				delay_count <= 0;
				delayed_5 <= '1';
			end if;
			if waiting = '1' then
				if delay_count <= 26000000 then
					delay_count <= delay_count + 1;
				else
					delay_count <= 0;
					waiting <= '0';
					collision_N_delayed <= '0';
					achived_1_d <= delayed_1;
					achived_2_d <= delayed_2;
					achived_3_d <= delayed_3;
					achived_4_d <= delayed_4;
					achived_5_d <= delayed_5;
					all_achived_d <= delayed_all;
				end if;
			end if;
		end if;
	end if;
  end process;	
end behav;		
		