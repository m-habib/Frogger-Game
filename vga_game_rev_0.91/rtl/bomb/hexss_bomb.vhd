-- HEX to Seven-Segment (active low) – vector out 
library ieee ; 
use ieee.std_logic_1164.all ; 
entity hexss_bomb is    
port (din : in  std_logic_vector(3 downto 0) ;
		blinkN, LAMP_TEST : in std_logic ;
		ss  : out std_logic_vector(6 downto 0) );
end hexss_bomb ; 
architecture behavior of hexss_bomb is
begin
	process(blinkN, LAMP_TEST, din)
	begin
		if blinkN = '0' then
			ss <= "1111111";
		elsif LAMP_TEST = '1' then
			ss <= "0000000";
		elsif LAMP_TEST = '0' and blinkN = '1' then
			case din is
				when "0000" => ss <= "1000000";
				when "0001" => ss <= "1111001";
				when "0010" => ss <= "0100100";
				when "0011" => ss <= "0110000";
				when "0100" => ss <= "0011001";
				when "0101" => ss <= "0010010";
				when "0110" => ss <= "0000010";
				when "0111" => ss <= "1111000";
				when "1000" => ss <= "0000000";
				when "1001" => ss <= "0010000";
				when "1010" => ss <= "0001000";
				when "1011" => ss <= "0000011";
				when "1100" => ss <= "1000110";
				when "1101" => ss <= "0100001";
				when "1110" => ss <= "0000110";
				when "1111" => ss <= "0001110";
				when others => ss <= "1111111";
			end case;
		else 
			ss <= "1111111";
		end if;
	end process;
end behavior;