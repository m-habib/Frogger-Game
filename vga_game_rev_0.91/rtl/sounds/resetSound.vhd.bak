LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY SoundsSelector IS
	PORT
		(
			CLK_IN					:	IN  STD_LOGIC				;	
			resetN					:  IN	 STD_LOGIC;
			InSound: in std_logic_vector (1 downto 0);
         OutSound : out std_logic_vector (1 downto 0);
			Enable : out std_logic 
		);
		
END SoundsSelector ;


ARCHITECTURE behave OF SoundsSelector  IS

	BEGIN

	PROCESS ( resetN,InSound)

	variable current_sound : std_logic_vector (1 downto 0);

	
			BEGIN
			
				
				IF resetN = '0' then
				current_sound := (others =>'0');
				Enable <= '0';
				
				elsif rising_edge(CLK_IN) then
				if (InSound="01") then
				Enable<='1';
            current_sound :="01";

				elsif (InSound = "10") then
            Enable<='1';
            current_sound :="10"; 
			
			   elsif (InSound = "11") then
            Enable<='1';
            current_sound :="11";
--			   
--				elsif (InSound = "1000") then
--            Enable<='1';
--            current_sound :="1000";
			   
--				elsif (InSound = "0010000") then
--            Enable<='1';
--            current_sound :="0010000";
--			   
--				elsif (InSound = "0100000") then
--            Enable<='1';
--            current_sound :="0100000";
--			   
--				elsif (InSound = "1000000") then
--            Enable<='1';
--            current_sound :="1000000";	
				
				else

				current_sound:= current_sound;
				Enable<='0';
				end if;
				
				outsound<= current_sound;
				end if;

		END PROCESS;
	END behave;