library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bcddn is
	port (clk, resetN, ena_cnt : in std_logic ;
			DATA : in std_logic_vector(7 downto 0);
			countL, countH: out std_logic_vector(3 downto 0);
			TC: out std_logic);
end bcddn ;

architecture arc_bcddn of bcddn  is
signal sig_L : std_logic_vector(3 downto 0);
signal sig_H : std_logic_vector(3 downto 0);
begin
	process (clk, resetN)
	begin
		if resetN = '0' then
			sig_H <= DATA(7 downto 4);
			sig_L <= DATA(3 downto 0);
		elsif (rising_edge(clk)) then	
			if ena_cnt = '1' then
				sig_L <= sig_L - 1;
				if sig_L = "0000" then
					sig_L <= "1001";
					sig_H <= sig_H - 1;
					if sig_H = "0000" then
						sig_H <= "1001";
					end if;
				end if;
				
				
			end if;
		end if;
		countL <= sig_L;
		countH <= sig_H;
	end process;
	
	process (sig_L, sig_H)
	begin
		if (sig_L = "0000" and sig_H = "0000") then
			TC <= '1';
		else
			TC <= '0';
		end if;
	end process;
end arc_bcddn;
