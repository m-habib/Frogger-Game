library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity collision is
port 	(
		CLK				: in std_logic;
		RESETn			: in std_logic; 
		Drawing_Request_A	: in std_logic;
		Drawing_Request_B 	: in std_logic;
		collision_N : out std_logic
);
end collision;


architecture behav of collision is 
begin
	process ( RESETn,CLK)
		begin
			if RESETn = '0' then
				collision_N <= '1';
			elsif rising_edge(CLK) then
				if Drawing_Request_A = '1' and Drawing_Request_B = '1' then
					collision_N <= '0';
				else
					collision_N <= '1';
				end if;
			end if;
	end process;
end behav;