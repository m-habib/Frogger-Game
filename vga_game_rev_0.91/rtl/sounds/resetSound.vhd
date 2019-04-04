LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY resetSound IS
	PORT
		(
			CLK_IN				: in std_logic;
			d_in					:	in  STD_LOGIC_vector(1 downto 0);	
			resetN				: in std_logic;
			resetSound_N		:  inout	 STD_LOGIC
		);
		
END resetSound ;


ARCHITECTURE behave OF resetSound  IS
	BEGIN
	PROCESS ( resetN)
	BEGIN		
		IF resetN = '0' then
			resetSound_N <= '1';
		elsif rising_edge(CLK_IN) then
			if resetSound_N = '0' then
				resetSound_N <= '1';
			end if;
			if (d_in = "00") then
				resetSound_N <= '0';
			end if;
		end if;
	END PROCESS;
END behave;