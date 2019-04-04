library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ship_150_30_object is
port 	(
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		ObjectStartX	: in integer;
		ObjectStartY 	: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end ship_150_30_object;

architecture behav of ship_150_30_object is

constant object_X_size : integer := 150;
constant object_Y_size : integer := 30;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"6E", x"6E", x"6E", x"48", x"8C", x"68", x"B1", x"D5", x"D1", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"D5", x"D1", x"B0", x"6C", x"6E", x"6E", x"6E", x"68", x"B0", x"6C", x"B1", x"D5", x"D1", x"B0", x"B0", x"B0", x"B0", x"B0", x"B1", x"D5", x"B1", x"8C", x"6C", x"0F", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"49", x"49", x"25", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"6E", x"6E", x"6E", x"92", x"92", x"92", x"FF", x"FF", x"FF", x"8C", x"B0", x"D5", x"D5", x"44", x"24", x"24", x"24", x"24", x"24", x"24", x"68", x"D5", x"D5", x"8C", x"FF", x"FF", x"FF", x"00", x"8C", x"B0", x"D5", x"B0", x"44", x"24", x"24", x"24", x"24", x"24", x"24", x"8C", x"F5", x"B1", x"8C", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"6E", x"92", x"B6", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"92", x"6E", x"6E", x"92", x"92", x"92", x"92", x"DB", x"FF", x"FF", x"FF", x"00", x"25", x"45", x"45", x"45", x"45", x"45", x"45", x"45", x"45", x"45", x"45", x"45", x"45", x"45", x"45", x"45", x"49", x"49", x"24", x"25", x"49", x"6E", x"6E", x"92", x"92", x"92", x"B6", x"B7", x"92", x"AD", x"D0", x"F9", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"D5", x"D5", x"B1", x"B7", x"B7", x"B7", x"92", x"AC", x"D4", x"F9", x"8C", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"F5", x"D1", x"8D", x"49", x"25", x"25", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"DB", x"DB", x"DB", x"B7", x"B7", x"B7", x"B7", x"B7", x"B6", x"92", x"6D", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"6D", x"92", x"B7", x"B7", x"B7", x"B7", x"DB", x"DB", x"FF", x"6E", x"B6", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"6E", x"6E", x"6E", x"6E", x"92", x"92", x"92", x"92", x"92", x"92", x"B6", x"B6", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B6", x"B7", x"B6", x"B7", x"B7", x"B7", x"B6", x"92", x"92", x"92", x"B7", x"B7", x"B7", x"DB", x"DB", x"FF", x"FF", x"FF", x"B7", x"B1", x"D0", x"F9", x"D5", x"48", x"24", x"24", x"24", x"24", x"24", x"24", x"68", x"D5", x"D0", x"D6", x"FF", x"FF", x"DB", x"B6", x"D1", x"D4", x"F9", x"B0", x"44", x"24", x"24", x"24", x"24", x"24", x"24", x"8C", x"F5", x"D0", x"6D", x"96", x"92", x"49", x"6E", x"92", x"92", x"B6", x"B6", x"B6", x"92", x"92", x"DB", x"DB", x"DB", x"DB", x"DB", x"B7", x"B7", x"B7", x"B6", x"92", x"FF", x"DB", x"B7", x"92", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"92", x"B6", x"B7", x"B7", x"B7", x"DB", x"FF", x"49", x"B6", x"B7", x"B7", x"B7", x"B7", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B6", x"B7", x"DB", x"DB", x"DB", x"9B", x"77", x"57", x"53", x"57", x"57", x"53", x"57", x"53", x"57", x"77", x"97", x"BB", x"97", x"53", x"53", x"57", x"B7", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"FF", x"FF", x"FF", x"B7", x"DB", x"D5", x"D0", x"D0", x"D0", x"D0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"D0", x"CC", x"A8", x"D6", x"DB", x"BB", x"B7", x"DB", x"D1", x"D0", x"D0", x"D0", x"D0", x"B0", x"B0", x"B0", x"B0", x"B0", x"D0", x"D0", x"CC", x"A8", x"6D", x"DB", x"B7", x"6E", x"6E", x"6E", x"92", x"DB", x"FF", x"FF", x"DB", x"6E", x"92", x"B7", x"B7", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B7", x"B7", x"B7", x"49", x"B7", x"92", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"92", x"B6", x"B7", x"B7", x"DB", x"DB", x"00", x"B6", x"B7", x"B7", x"B7", x"B7", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"92", x"96", x"DB", x"DF", x"BB", x"57", x"33", x"33", x"33", x"73", x"B7", x"B7", x"DB", x"DB", x"DB", x"BB", x"B7", x"DB", x"FF", x"DB", x"B7", x"52", x"33", x"33", x"97", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"FF", x"FF", x"B7", x"DB", x"DB", x"D5", x"D0", x"AC", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"D6", x"DB", x"B7", x"DB", x"DB", x"D5", x"D0", x"AC", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"6D", x"DB", x"B7", x"6E", x"49", x"25", x"6D", x"B7", x"DB", x"FF", x"DB", x"6E", x"6E", x"6E", x"B7", x"DB", x"B7", x"92", x"D5", x"D5", x"D6", x"D6", x"D6", x"DB", x"DB", x"B7", x"B7", x"00", x"92"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"92", x"B6", x"B7", x"B7", x"DB", x"FF", x"B6", x"B7", x"B7", x"B7", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"92", x"92", x"DB", x"FF", x"FF", x"77", x"33", x"33", x"33", x"53", x"B7", x"DB", x"DB", x"FF", x"FF", x"FF", x"DB", x"DB", x"FF", x"DB", x"B7", x"FF", x"DB", x"52", x"33", x"33", x"97", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"FF", x"FF", x"B6", x"DB", x"DB", x"B6", x"AD", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"B6", x"DB", x"92", x"DB", x"DB", x"B2", x"AD", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"8D", x"6D", x"DB", x"B7", x"6E", x"49", x"24", x"6D", x"DB", x"DB", x"DB", x"B7", x"6E", x"49", x"6D", x"B7", x"DB", x"B7", x"6E", x"6D", x"AD", x"D0", x"F0", x"F1", x"D5", x"D6", x"D6", x"DB", x"B7", x"6E"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"92", x"B7", x"B7", x"DB", x"FF", x"92", x"B7", x"B7", x"B7", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"D6", x"D6", x"D5", x"D5", x"D6", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"6D", x"00", x"6E", x"DB", x"DB", x"FF", x"FF", x"57", x"33", x"33", x"33", x"92", x"DB", x"DB", x"DB", x"DB", x"FF", x"FF", x"DB", x"DB", x"DB", x"DB", x"DB", x"FF", x"DB", x"52", x"33", x"33", x"97", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"FF", x"FF", x"DB", x"B7", x"96", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"72", x"6E", x"B7", x"DB", x"B7", x"B7", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"72", x"6E", x"6E", x"DB", x"B7", x"6E", x"49", x"25", x"6D", x"DB", x"DB", x"DB", x"B7", x"49", x"00", x"49", x"DB", x"DB", x"B7", x"6E", x"49", x"49", x"D1", x"F4", x"F1", x"F0", x"F0", x"F1", x"D6", x"DB", x"B7"),
(x"00", x"00", x"00", x"00", x"6E", x"B6", x"B7", x"B7", x"DB", x"00", x"B6", x"B7", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"D6", x"D6", x"D5", x"D5", x"F1", x"F0", x"F0", x"F0", x"D6", x"DB", x"FF", x"FF", x"FF", x"DB", x"DB", x"FF", x"FF", x"FF", x"92", x"24", x"00", x"00", x"92", x"DB", x"DB", x"FF", x"FF", x"57", x"33", x"33", x"33", x"73", x"DB", x"DB", x"DB", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"92", x"52", x"33", x"33", x"97", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"FF", x"FF", x"FF", x"DB", x"B7", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"B7", x"DB", x"DB", x"DB", x"B7", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"B7", x"B7", x"DB", x"B7", x"6E", x"6D", x"25", x"6D", x"DB", x"DB", x"DB", x"B7", x"6E", x"49", x"6D", x"DB", x"DB", x"B7", x"49", x"00", x"49", x"D1", x"F4", x"F1", x"F0", x"F1", x"F0", x"D1", x"D6", x"BB"),
(x"00", x"92", x"B7", x"DB", x"FF", x"92", x"B7", x"B7", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DA", x"D6", x"D5", x"D5", x"F5", x"F1", x"F0", x"F0", x"F5", x"F5", x"F6", x"FA", x"FA", x"DB", x"DB", x"FF", x"FF", x"FF", x"DB", x"DB", x"FF", x"FF", x"B6", x"00", x"00", x"00", x"00", x"6D", x"DB", x"DB", x"FF", x"FF", x"77", x"33", x"33", x"33", x"33", x"73", x"97", x"92", x"72", x"72", x"72", x"6E", x"72", x"6E", x"72", x"6E", x"72", x"6E", x"52", x"33", x"33", x"97", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B7", x"B7", x"DB", x"DB", x"DB", x"DB", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"92", x"DB", x"B7", x"6E", x"49", x"24", x"6D", x"DB", x"DB", x"DB", x"B7", x"49", x"24", x"49", x"B7", x"DB", x"B7", x"6E", x"25", x"68", x"F1", x"F0", x"F1", x"F0", x"F1", x"F0", x"F1", x"D6", x"DB"),
(x"B6", x"00", x"B7", x"B7", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FB", x"DA", x"D5", x"D5", x"F5", x"F0", x"F0", x"F0", x"F0", x"F0", x"F5", x"D6", x"DB", x"DB", x"DB", x"77", x"77", x"77", x"77", x"77", x"77", x"77", x"DB", x"DB", x"FF", x"FF", x"B6", x"00", x"00", x"00", x"00", x"00", x"49", x"B6", x"DB", x"FF", x"DF", x"BB", x"77", x"53", x"33", x"33", x"33", x"33", x"33", x"33", x"33", x"33", x"33", x"33", x"33", x"33", x"33", x"33", x"33", x"33", x"33", x"97", x"B7", x"B7", x"B7", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"6E", x"DB", x"B7", x"6E", x"6D", x"25", x"6D", x"DB", x"DB", x"DB", x"B7", x"6E", x"25", x"49", x"DB", x"DB", x"B7", x"49", x"49", x"69", x"D1", x"F4", x"F1", x"F0", x"F1", x"F0", x"F1", x"D6", x"DB"),
(x"B6", x"DB", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FA", x"F5", x"F5", x"F0", x"F0", x"F0", x"F0", x"F1", x"F0", x"F1", x"F0", x"F0", x"F5", x"B6", x"92", x"DB", x"DB", x"53", x"33", x"33", x"33", x"33", x"33", x"53", x"BB", x"DB", x"FF", x"FF", x"FF", x"B6", x"49", x"00", x"00", x"00", x"00", x"24", x"49", x"92", x"DB", x"DB", x"FF", x"FF", x"DF", x"BB", x"9B", x"77", x"77", x"77", x"53", x"53", x"53", x"53", x"53", x"53", x"53", x"53", x"53", x"53", x"53", x"72", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"DB", x"B7", x"6E", x"49", x"24", x"6D", x"DB", x"DB", x"DB", x"B7", x"6E", x"49", x"6E", x"B7", x"DB", x"B7", x"49", x"00", x"49", x"D1", x"F0", x"F1", x"F0", x"F1", x"F0", x"F1", x"D6", x"DB"),
(x"92", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FA", x"F5", x"F0", x"F0", x"F1", x"F0", x"F1", x"F0", x"F0", x"F1", x"F0", x"F1", x"F0", x"F0", x"F5", x"69", x"49", x"DB", x"DB", x"53", x"33", x"33", x"33", x"33", x"33", x"53", x"BB", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"25", x"00", x"00", x"00", x"00", x"00", x"24", x"49", x"6E", x"92", x"92", x"92", x"B6", x"DB", x"DB", x"DB", x"BB", x"BB", x"B7", x"BB", x"BB", x"BB", x"BB", x"B7", x"BB", x"B7", x"BB", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"DB", x"B6", x"6E", x"6E", x"49", x"6E", x"DB", x"DB", x"DB", x"B7", x"6D", x"00", x"49", x"DB", x"DB", x"B7", x"6E", x"49", x"6D", x"F1", x"F0", x"F1", x"F0", x"F1", x"F0", x"F1", x"DA", x"DB"),
(x"6D", x"92", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"F5", x"F0", x"F0", x"F1", x"F0", x"F1", x"F0", x"F1", x"F0", x"F0", x"F1", x"F0", x"F1", x"F0", x"F0", x"F5", x"92", x"B6", x"DB", x"DB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"BB", x"DB", x"DB", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"92", x"49", x"25", x"24", x"24", x"00", x"00", x"00", x"00", x"00", x"25", x"6E", x"92", x"72", x"6E", x"49", x"25", x"25", x"6E", x"49", x"25", x"25", x"49", x"6E", x"25", x"25", x"25", x"6D", x"6E", x"25", x"25", x"25", x"6E", x"49", x"25", x"25", x"49", x"72", x"92", x"92", x"92", x"92", x"92", x"92", x"72", x"49", x"25", x"25", x"49", x"6E", x"25", x"25", x"25", x"6E", x"6D", x"25", x"25", x"25", x"6E", x"49", x"25", x"25", x"49", x"6E", x"25", x"25", x"25", x"6D", x"6E", x"25", x"25", x"25", x"6E", x"92", x"92", x"72", x"6E", x"6E", x"6E", x"B7", x"DB", x"DB", x"B7", x"6E", x"49", x"6E", x"DB", x"DB", x"B7", x"49", x"25", x"49", x"D1", x"F4", x"F1", x"F0", x"F1", x"F0", x"F1", x"FA", x"FF"),
(x"25", x"49", x"6D", x"6E", x"B6", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"F5", x"F0", x"F0", x"F1", x"F0", x"F1", x"F0", x"F1", x"F0", x"F0", x"F1", x"F0", x"F1", x"F0", x"F0", x"F5", x"DB", x"DB", x"B7", x"92", x"92", x"92", x"92", x"B6", x"DB", x"FF", x"FF", x"DB", x"DB", x"DB", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"B6", x"92", x"92", x"6E", x"6D", x"6E", x"92", x"92", x"92", x"6D", x"49", x"25", x"25", x"49", x"6E", x"49", x"25", x"25", x"49", x"6E", x"49", x"25", x"25", x"6D", x"6E", x"25", x"25", x"49", x"6E", x"49", x"25", x"25", x"49", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"49", x"25", x"25", x"49", x"6E", x"49", x"25", x"25", x"6E", x"6D", x"25", x"25", x"49", x"6E", x"49", x"25", x"25", x"49", x"6E", x"49", x"25", x"25", x"6D", x"6E", x"25", x"25", x"49", x"6E", x"92", x"92", x"92", x"92", x"72", x"6E", x"B7", x"DB", x"DB", x"B7", x"49", x"24", x"49", x"B7", x"DB", x"B7", x"49", x"00", x"68", x"D1", x"F0", x"F1", x"F0", x"F1", x"F0", x"F1", x"FA", x"DF"),
(x"49", x"49", x"49", x"49", x"49", x"6D", x"6E", x"92", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FA", x"F5", x"F0", x"F0", x"F1", x"F0", x"F1", x"F0", x"F0", x"F1", x"F0", x"F1", x"F0", x"F0", x"F5", x"D6", x"B2", x"92", x"92", x"92", x"92", x"B6", x"DB", x"FF", x"FF", x"FF", x"FF", x"DB", x"B7", x"B7", x"B7", x"DB", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B7", x"6E", x"25", x"49", x"DB", x"DB", x"B7", x"6E", x"49", x"6D", x"D1", x"F0", x"F1", x"F0", x"F1", x"F0", x"F1", x"FA", x"DF"),
(x"00", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"6E", x"92", x"B7", x"FF", x"FF", x"FF", x"FF", x"F6", x"F5", x"F1", x"F0", x"F0", x"F0", x"F0", x"F1", x"F0", x"F1", x"F0", x"F1", x"F1", x"F1", x"F1", x"F1", x"F1", x"F1", x"F1", x"DA", x"DB", x"DB", x"FF", x"FF", x"FF", x"FF", x"B7", x"B7", x"B6", x"92", x"92", x"92", x"92", x"96", x"B7", x"B7", x"B6", x"B6", x"B6", x"B7", x"B6", x"B6", x"B6", x"B6", x"B7", x"92", x"92", x"92", x"92", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"92", x"6E", x"6E", x"6E", x"B7", x"DB", x"B7", x"49", x"25", x"49", x"D1", x"F4", x"F1", x"F0", x"F1", x"F0", x"F1", x"FA", x"DF"),
(x"00", x"00", x"00", x"49", x"49", x"6D", x"49", x"49", x"49", x"49", x"49", x"49", x"6D", x"92", x"B6", x"DB", x"FF", x"FF", x"FA", x"F5", x"F5", x"F1", x"F0", x"F0", x"F0", x"F1", x"F0", x"F1", x"F1", x"F0", x"F1", x"F0", x"F1", x"F0", x"F1", x"D6", x"DB", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"B7", x"92", x"92", x"92", x"92", x"92", x"6E", x"49", x"49", x"49", x"6E", x"6D", x"49", x"49", x"49", x"6E", x"49", x"49", x"49", x"49", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"72", x"6E", x"B7", x"DB", x"B7", x"49", x"24", x"68", x"F1", x"F0", x"F1", x"F0", x"F1", x"F0", x"F1", x"FA", x"DF"),
(x"00", x"00", x"00", x"00", x"00", x"49", x"49", x"6D", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"6E", x"92", x"B7", x"DB", x"DB", x"DA", x"F5", x"F5", x"F5", x"F1", x"F0", x"F0", x"F0", x"F0", x"F1", x"F0", x"F1", x"F0", x"F0", x"D6", x"DB", x"DB", x"DB", x"DB", x"DB", x"FF", x"FF", x"FF", x"FF", x"FF", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"B7", x"DB", x"B6", x"6E", x"4D", x"6D", x"D1", x"F4", x"F1", x"F0", x"F1", x"F0", x"F1", x"FA", x"DF"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"6D", x"6E", x"92", x"B7", x"DB", x"DA", x"D6", x"D5", x"F5", x"F5", x"F0", x"F0", x"F0", x"F1", x"F0", x"F0", x"F5", x"D6", x"DB", x"B7", x"B7", x"B7", x"B7", x"B6", x"92", x"92", x"92", x"92", x"69", x"49", x"49", x"6D", x"72", x"49", x"49", x"49", x"6E", x"6E", x"49", x"49", x"49", x"92", x"6D", x"49", x"49", x"6D", x"72", x"49", x"49", x"49", x"6E", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"6E", x"49", x"49", x"49", x"72", x"6D", x"49", x"49", x"69", x"92", x"49", x"49", x"49", x"6D", x"6E", x"49", x"49", x"49", x"6E", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"6E", x"49", x"49", x"49", x"6E", x"6D", x"49", x"49", x"49", x"92", x"69", x"49", x"49", x"6D", x"72", x"49", x"49", x"49", x"6E", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"6E", x"6E", x"49", x"D1", x"F4", x"F1", x"F0", x"F1", x"F0", x"F5", x"FB", x"B6"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"49", x"49", x"49", x"6E", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"6D", x"6E", x"92", x"B6", x"B6", x"D6", x"D6", x"D6", x"D5", x"F5", x"F1", x"F0", x"F0", x"F0", x"D5", x"B6", x"B6", x"B6", x"B6", x"92", x"92", x"92", x"92", x"92", x"8C", x"8C", x"8C", x"8D", x"8E", x"8C", x"8C", x"8C", x"8D", x"8D", x"8C", x"8C", x"8C", x"92", x"8D", x"8C", x"8C", x"8D", x"92", x"8C", x"8C", x"8C", x"8D", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"8D", x"8C", x"8C", x"8C", x"92", x"8D", x"8C", x"8C", x"8C", x"92", x"8C", x"8C", x"8C", x"8D", x"8E", x"8C", x"8C", x"8C", x"8D", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"8D", x"8C", x"8C", x"8C", x"8E", x"8D", x"8C", x"8C", x"8C", x"92", x"8D", x"8C", x"8C", x"8D", x"92", x"8C", x"8C", x"8C", x"8D", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"6E", x"D1", x"F4", x"F1", x"F0", x"F0", x"F1", x"F6", x"B6", x"6D"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"6E", x"6E", x"92", x"B6", x"B6", x"D6", x"D6", x"D6", x"D5", x"F5", x"F5", x"D5", x"D5", x"D5", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"F1", x"D1", x"D1", x"D1", x"F0", x"F1", x"F1", x"D1", x"D1", x"F0", x"F1", x"F1", x"D1", x"D1", x"F0", x"F1", x"D1", x"D1", x"F1", x"F1", x"F1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"F0", x"F1", x"F1", x"D1", x"D1", x"F0", x"F1", x"D1", x"D1", x"D1", x"F0", x"F1", x"D1", x"D1", x"F0", x"F1", x"F1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"F1", x"F0", x"F1", x"D1", x"D1", x"F1", x"F0", x"D1", x"D1", x"D1", x"F1", x"F0", x"D1", x"D1", x"F1", x"F0", x"F1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"D1", x"F0", x"F1", x"F5", x"F5", x"D6", x"B2", x"6E", x"49"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"49", x"49", x"6E", x"49", x"49", x"6D", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"92", x"92", x"B6", x"B6", x"D6", x"D6", x"D6", x"D5", x"D5", x"F5", x"F5", x"F5", x"F5", x"D1", x"B1", x"B1", x"D1", x"F5", x"D1", x"B1", x"B1", x"D5", x"D5", x"B1", x"B1", x"B1", x"F5", x"D1", x"B1", x"B1", x"D1", x"F5", x"D1", x"B1", x"B1", x"D1", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"D1", x"B1", x"B1", x"F5", x"D1", x"B1", x"B1", x"D1", x"F5", x"D1", x"B1", x"B1", x"D1", x"F5", x"D1", x"B1", x"B1", x"D5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"D1", x"B1", x"B1", x"D5", x"D5", x"B1", x"B1", x"D1", x"F5", x"D1", x"B1", x"B1", x"D1", x"F5", x"D1", x"B1", x"B1", x"D1", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"F5", x"D5", x"D5", x"D6", x"B6", x"92", x"6E", x"6E", x"49", x"25"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"49", x"6D", x"49", x"6D", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"72", x"92", x"92", x"92", x"92", x"92", x"96", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B2", x"B6", x"B6", x"B6", x"B2", x"B6", x"B6", x"B6", x"B6", x"B2", x"B6", x"B6", x"B6", x"B6", x"B2", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B2", x"B6", x"B6", x"B6", x"B6", x"B2", x"B6", x"B6", x"B6", x"B6", x"B2", x"B6", x"B6", x"B6", x"B2", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B2", x"B6", x"B6", x"B6", x"B6", x"B2", x"B6", x"B6", x"B6", x"B6", x"B2", x"B6", x"B6", x"B6", x"B2", x"B2", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B2", x"92", x"92", x"6E", x"6E", x"6E", x"6E", x"6D", x"49", x"49"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"6D", x"6E", x"49", x"6D", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"6E", x"6E", x"6E", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6E", x"6E", x"6E", x"6D", x"6E", x"92", x"92", x"92", x"92", x"92", x"6E", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6E", x"6E", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"6E", x"6E", x"6E", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6E", x"6E", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"92", x"92", x"92", x"72", x"6D", x"6E", x"6D", x"6E", x"6E", x"6E", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6E", x"92", x"92", x"92", x"92", x"72", x"6E", x"6E", x"6E", x"6E", x"6E", x"6E", x"6D", x"49", x"6E", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"49", x"6E", x"6E", x"49", x"6D", x"6E", x"6E", x"6E", x"6E", x"6E", x"72", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"6E", x"6D", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6D", x"6E", x"6D", x"6E", x"92", x"92", x"92", x"92", x"92", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"6E", x"6D", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"92", x"92", x"92", x"72", x"6D", x"6E", x"6D", x"6E", x"6D", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"6E", x"6D", x"92", x"92", x"72", x"6E", x"6E", x"6E", x"6E", x"6D", x"6D", x"49", x"49", x"FF", x"49", x"24", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"49", x"6E", x"92", x"49", x"6D", x"6E", x"6E", x"72", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"72", x"6E", x"6E", x"6E", x"6E", x"49", x"49", x"49", x"49", x"00", x"6E", x"6D", x"49", x"25", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"49", x"6E", x"6E", x"6D", x"6E", x"6E", x"72", x"72", x"72", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"72", x"72", x"72", x"6E", x"6E", x"6E", x"49", x"20", x"B7", x"6E", x"6D", x"49", x"49", x"25", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"6E", x"6E", x"72", x"92", x"00", x"6E", x"6E", x"6E", x"6E", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"72", x"6E", x"6E", x"6E", x"6E", x"6D", x"00", x"92", x"6E", x"6E", x"49", x"25", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"6D", x"6E", x"6E", x"6E", x"72", x"72", x"72", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"72", x"6E", x"6E", x"6D", x"49", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111100000111111111111110000000000000000000000000000"),
("000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111100011111111111111110000000000000000000000000000"),
("000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111110000000000000000000000000"),
("000000000000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110000000"),
("000000000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000"),
("000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110"),
("000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("000000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("000000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110"),
("000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111100"),
("000000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110000"),
("000000000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110000000"),
("000000000000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110000000000000"),
("000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000000000000"),
("000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000")
);

signal bCoord_X : integer := 0;-- offset from start position 
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

signal objectEndX : integer;
signal objectEndY : integer;

begin

-- Calculate object end boundaries
objectEndX	<= object_X_size+ObjectStartX;
objectEndY	<= object_Y_size+ObjectStartY;

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

-- test if ooCoord is in the rectangle defined by Start and End 
	drawing_X	<= '1' when  (oCoord_X  >= ObjectStartX) and  (oCoord_X < objectEndX) else '0';
    drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY) else '0';

-- calculate offset from start corner 
	bCoord_X 	<= (oCoord_X - ObjectStartX) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 


process ( RESETn, CLK)
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;

		elsif rising_edge(CLK) then
			mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	--get from colors table 
			drawing_request	<= object(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ; -- get from mask table if inside rectangle  
	end if;
  end process;
end behav;		

--generated with PNGtoVHDL tool by Ben Wellingstein