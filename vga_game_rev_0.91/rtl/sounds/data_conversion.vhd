library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;



entity data_conversion is
	port(clk_in, resetN : in std_logic;
			mux : in std_logic_vector(2 downto 0);
			data_in : in std_logic_vector(15 downto 0);
			data_out, times_3 : out std_logic_vector(15 downto 0)
			);
end entity;

architecture arch_data_conversion of data_conversion is
	constant largest_twos : integer:= 21845;
	constant smallest_twos : integer:= -21845;
	signal data_in_times_3 : std_logic_vector(15 downto 0);
	begin
	process(clk_in, resetN)
	begin
		if resetN = '0' then
			data_out <= (others => '0');
		elsif rising_edge(clk_in) then
			case mux is
				when "000" => 
					data_out <= data_in;
				when "001" => 
					if data_in > 0 then
						data_out <= data_in;
					else
						data_out <= (others => '0');
					end if;
				when "010" =>
					data_out <= -data_in;
				when "011" =>
					if data_in > 0 then
						data_out <= data_in;
					else
						data_out <= -data_in;
					end if;
				when "100" =>
					data_out(15 downto 2) <= data_in(15 downto 2);
					data_out(1 downto 0) <= "00";
				when "101" =>
					data_out(15 downto 10) <= data_in(15 downto 10);
					data_out(9 downto 0) <= (others => '0');
				when "110" =>
					data_out(15) <= data_in(15);
					data_out(14 downto 0) <= data_in(15 downto 1);
				when "111" =>
					data_in_times_3 <= conv_std_logic_vector(3*(conv_integer((data_in))), 16);
					times_3 <= data_in_times_3;
					data_out(15) <= data_in_times_3(15);
					data_out(14 downto 0) <= data_in_times_3(15 downto 1);
					--if (data_in < smallest_twos) then
					--	data_out(15) <= '1';
					--	data_out(14 downto 0) <= (others => '0');
					--elsif (data_in > largest_twos) then
					--	data_out(15) <= '0'; 
					--	data_out(14 downto 0) <= (others => '1');
					--elsif (data_in < largest_twos) and (data_in_times_3 > 0) then 
					--	data_out(15) <= '0';
					--	data_out(14 downto 0) <= data_in_times_3(15 downto 1);
					--else
					--	data_out(15) <= '1';
					--	data_out(14 downto 0) <= data_in_times_3(15 downto 1);
					--end if;
				when others =>
					data_out <= data_in;
			end case;
		end if;
	end process;
end arch_data_conversion;