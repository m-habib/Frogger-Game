LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY sound_mux IS
	PORT(CLK_IN					:	IN  STD_LOGIC				;	
			resetN					:  IN	 STD_LOGIC;
			--AccidintSound : in std_logic_vector (15 downto 0);
			LoseSound : in std_logic_vector (15 downto 0);
			--TreeFallSound : in std_logic_vector (15 downto 0);
			--LevelUpSound : in std_logic_vector (15 downto 0);
			WinSound : in std_logic_vector (15 downto 0);
			JumpSound : in std_logic_vector (15 downto 0);
			--GameOverSound : in std_logic_vector (15 downto 0);
			InSound: in std_logic_vector (1 downto 0);
			OutSound : out std_logic_vector (15 downto 0)
	);
	END sound_mux ;


ARCHITECTURE behave OF sound_mux  IS

	BEGIN

	PROCESS ( resetN,InSound)
	BEGIN
	
	if (resetN='0') then
	outsound <= (others =>'0');
	
	elsif rising_edge(CLK_IN) then
	
		if (Insound="11") then
		outsound<= JumpSound;
	
	--if (insound="0001") then
	--outsound<= AccidintSound;
	
		elsif (insound="01") then
		outsound<= LoseSound;
	
	--elsif (insound="0001000") then
	--outsound<= TreeFallSound;
	
	--elsif (insound="0010000") then
	--outsound<= LevelUpSound;
	
		elsif (insound="10") then
		outsound<= WinSound;
	
	--elsif (insound="1000") then
	--outsound<= GameOverSound;
	
	end if;
	end if;
	
	END PROCESS;
	END behave;