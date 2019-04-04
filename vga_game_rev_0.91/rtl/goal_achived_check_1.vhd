library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity goal_achived_check_1 is
port 	(
		CLK				: in std_logic;
		RESETn			: in std_logic; 
		Drawing_Request_A	: in std_logic;
		Drawing_Request_B 	: in std_logic;
		achived : out std_logic;
		collisionN : out std_logic
);
end goal_achived_check_1;


architecture behav of goal_achived_check_1 is 
signal achived_flag : std_logic;
begin
	process ( RESETn,CLK)
		begin
		  if RESETn = '0' then
				achived_flag <= '0';
				achived <= '0';
				collisionN <= '1';
		elsif rising_edge(CLK) then
			if(achived_flag = '0') then
				if Drawing_Request_A = '1' and Drawing_Request_B = '1' then
					achived_flag <= '1';
					achived <= '1';
					collisionN <= '0';
				else
					achived <= '0';
					collisionN <= '1';
				end if;
			else
				achived <= '1';
				collisionN <= '1';				
			end if;
		end if;
	end process;
end behav;