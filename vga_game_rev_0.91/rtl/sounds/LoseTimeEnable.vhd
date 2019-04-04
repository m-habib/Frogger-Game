library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity LoseTimeEnable is
port 	(
		CLK				: in std_logic;
		RESETn			: in std_logic;
		start : in std_logic;
		EnableLose : out std_logic;
		resetN_counter : out std_logic
);
end LoseTimeEnable;


architecture behav of LoseTimeEnable is 
begin
	process ( RESETn,CLK)
		variable wait_count : integer;
		
		begin
		  if RESETn = '0' then
				EnableLose <= '0';
				wait_count := 0;
				resetN_counter<='1';
			elsif rising_edge(CLK) then
				if(start = '1') then
					wait_count := 1;
				end if;
				if(wait_count > 0 and wait_count <= 4850000) then
					wait_count := wait_count + 1;
					EnableLose <= '1';	
					resetN_counter<='1';
				else
				   resetN_counter<='0';
					EnableLose <= '0';
					wait_count := 0;
				end if;
		end if;
	end process;
end behav;

									
									
									