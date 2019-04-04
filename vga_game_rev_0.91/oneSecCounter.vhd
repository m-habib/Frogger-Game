library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity oneSecEnable is
port 	(
		CLK				: in std_logic;
		RESETn			: in std_logic;
		start : in std_logic;
		oneSec : out std_logic
);
end oneSecEnable;


architecture behav of oneSecEnable is 
begin
	process ( RESETn,CLK)
		variable wait_count : integer;
		begin
		  if RESETn = '0' then
				oneSec <= '0';
				wait_count := 0;
			elsif rising_edge(CLK) then
				if(start = '1') then
					wait_count := 1;
				end if;
				if(wait_count > 0 and wait_count < 50000000) then
					wait_count := wait_count + 1;
					oneSec <= '1';				
				else
					oneSec <= '0';
					wait_count := 0;
				end if;
		end if;
	end process;
end behav;

									
									
									