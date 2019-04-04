library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity crocodile_object is
port 	(
	   CLK  					: in std_logic;
		RESETn				: in std_logic;
		oCoord_X				: in integer;
		oCoord_Y				: in integer;
		master_on 			: in std_logic;
		restart_N			: in std_logic;
		drawing_request	: out std_logic ;
		mVGA_RGB 			: out std_logic_vector(7 downto 0);
		crocodile_on		: out std_logic;
		crocodile_goal		: out std_logic_vector(2 downto 0)
	);
end crocodile_object;

architecture behav of crocodile_object is 

constant object_X_size : integer := 32;
constant object_Y_size : integer := 32;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_1_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"00", x"40", x"40", x"40", x"40", x"40", x"00", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"20", x"00", x"20", x"44", x"84", x"A4", x"84", x"60", x"20", x"00", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"20", x"01", x"40", x"40", x"64", x"A4", x"C8", x"C8", x"84", x"40", x"40", x"02", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"40", x"20", x"44", x"84", x"84", x"60", x"A4", x"E8", x"C8", x"A4", x"64", x"20", x"40", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"20", x"20", x"64", x"C8", x"A4", x"60", x"A4", x"E8", x"E8", x"C8", x"64", x"20", x"40", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"20", x"20", x"64", x"C8", x"C8", x"C4", x"C4", x"E8", x"E8", x"C8", x"64", x"20", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"20", x"20", x"64", x"C8", x"E8", x"E8", x"E8", x"E8", x"C8", x"AC", x"64", x"20", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"20", x"20", x"64", x"C8", x"E8", x"E8", x"E8", x"C8", x"AC", x"70", x"28", x"04", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"40", x"20", x"64", x"C8", x"CC", x"CC", x"A8", x"88", x"70", x"54", x"0C", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"40", x"20", x"64", x"A8", x"AC", x"90", x"4C", x"24", x"2C", x"34", x"0C", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"40", x"20", x"40", x"88", x"70", x"54", x"2C", x"04", x"08", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"20", x"21", x"40", x"44", x"2C", x"34", x"0C", x"04", x"04", x"08", x"04", x"00", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"04", x"08", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"00", x"04", x"08", x"04", x"00", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"20", x"04", x"08", x"04", x"00", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"28", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"20", x"02", x"20", x"44", x"48", x"70", x"28", x"04", x"04", x"08", x"04", x"00", x"04", x"08", x"04", x"00", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"40", x"20", x"64", x"84", x"A8", x"AC", x"64", x"20", x"08", x"2C", x"08", x"04", x"28", x"2C", x"28", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"20", x"20", x"64", x"C8", x"E8", x"C8", x"84", x"44", x"48", x"70", x"48", x"44", x"48", x"70", x"68", x"44", x"40", x"01", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"20", x"20", x"64", x"C8", x"E8", x"E8", x"C8", x"A8", x"A8", x"AC", x"A8", x"A8", x"A8", x"AC", x"A8", x"84", x"40", x"20", x"40", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"40", x"20", x"60", x"84", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"84", x"44", x"20", x"40", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"21", x"00", x"41", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"41", x"01", x"21", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"04", x"04", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"04", x"08", x"2D", x"08", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"04", x"28", x"2C", x"0C", x"08", x"04", x"02", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"00", x"04", x"08", x"0C", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"04", x"00", x"04", x"08", x"08", x"08", x"0C", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"04", x"04", x"08", x"30", x"30", x"10", x"0C", x"08", x"04", x"02", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object_1 : object_form := (
("00000001111111000000000000000000"),
("00000001111111000000000000000000"),
("00000011111111100000000000000000"),
("00000111111111110000000000000000"),
("00000111111111110000000000000000"),
("00000111111111110000000000000000"),
("00000111111111110000000000000000"),
("00000111111111110000000000000000"),
("00000111111111110000000000000000"),
("00000111111111110000000000000000"),
("00000111111111110000000000000000"),
("00000111111111110000000000000000"),
("00000001111100000000000000000000"),
("00000001111100000000000000000000"),
("00000000000000000000000000000000"),
("00000000000000000000000000000000"),
("00000000000000000000000000000000"),
("00000000000000000000000000000000"),
("00000001111100000000000000000000"),
("00000001111100000000000000000000"),
("00000011111111111111000000000000"),
("00000111111111111111000000000000"),
("00000111111111111111100000000000"),
("00000111111111111111110000000000"),
("00000111111111111111110000000000"),
("00000111111111111111110000000000"),
("00000001111111111111000000000000"),
("00000001111100000000000000000000"),
("00000001111110000000000000000000"),
("00000001111111000000000000000000"),
("00000111111111000000000000000000"),
("00000111111110000000000000000000")
);



-- 8 bit - color definition : "RRRGGGBB"  
constant object_2_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"00", x"40", x"40", x"40", x"40", x"40", x"00", x"20", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"00", x"20", x"40", x"84", x"A4", x"84", x"60", x"20", x"00", x"20", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"01", x"40", x"40", x"64", x"A4", x"C8", x"C8", x"84", x"40", x"40", x"02", x"20", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"40", x"20", x"44", x"84", x"84", x"60", x"A4", x"E8", x"C8", x"A4", x"64", x"20", x"40", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"20", x"64", x"C8", x"A4", x"60", x"A4", x"E8", x"E8", x"C8", x"64", x"20", x"40", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"84", x"20", x"84", x"C8", x"C8", x"C4", x"C4", x"E8", x"E8", x"C8", x"64", x"20", x"20", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"20", x"40", x"40", x"A4", x"E8", x"E8", x"E8", x"E8", x"E8", x"C8", x"AC", x"64", x"20", x"20", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"00", x"20", x"60", x"A4", x"C8", x"E8", x"E8", x"E8", x"E8", x"C8", x"AC", x"70", x"28", x"04", x"24", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"01", x"40", x"40", x"84", x"C8", x"E8", x"E8", x"CC", x"CC", x"A8", x"88", x"70", x"54", x"0C", x"04", x"04", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"20", x"60", x"A4", x"C8", x"E8", x"E8", x"C8", x"AC", x"90", x"4C", x"24", x"2C", x"34", x"0C", x"04", x"04", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"04", x"00", x"04", x"08", x"08", x"08", x"24", x"40", x"40", x"60", x"A4", x"E8", x"E8", x"E8", x"C8", x"A8", x"70", x"54", x"2C", x"04", x"08", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"04", x"04", x"08", x"30", x"30", x"30", x"6C", x"88", x"A4", x"C4", x"C8", x"E8", x"E8", x"C8", x"84", x"44", x"2C", x"34", x"0C", x"04", x"04", x"08", x"04", x"00", x"04", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"04", x"04", x"0C", x"34", x"38", x"58", x"90", x"C8", x"E8", x"E8", x"E8", x"E8", x"CC", x"AC", x"64", x"20", x"08", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"20", x"04", x"2C", x"34", x"38", x"54", x"90", x"C8", x"E8", x"E8", x"E8", x"C8", x"AC", x"70", x"28", x"04", x"04", x"08", x"04", x"00", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"40", x"40", x"40", x"44", x"4C", x"70", x"74", x"70", x"AC", x"E8", x"E8", x"E8", x"C8", x"A8", x"70", x"54", x"0C", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"44", x"84", x"A4", x"A8", x"A8", x"AC", x"AC", x"CC", x"C8", x"E8", x"E8", x"C8", x"84", x"44", x"4C", x"34", x"0C", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"64", x"C8", x"CC", x"AC", x"AC", x"AC", x"CC", x"E8", x"E8", x"E8", x"C8", x"A4", x"64", x"20", x"08", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"64", x"C8", x"AC", x"90", x"74", x"90", x"AC", x"E8", x"E8", x"E8", x"A4", x"40", x"40", x"01", x"04", x"04", x"04", x"00", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"64", x"C8", x"AC", x"94", x"54", x"74", x"90", x"CC", x"E8", x"C8", x"64", x"20", x"64", x"24", x"04", x"04", x"04", x"00", x"04", x"08", x"04", x"00", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"64", x"C8", x"CC", x"AC", x"74", x"74", x"90", x"C8", x"E8", x"C8", x"84", x"20", x"00", x"04", x"08", x"2C", x"08", x"04", x"08", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"21", x"45", x"AD", x"CC", x"CC", x"AC", x"90", x"AC", x"E8", x"E8", x"E8", x"A4", x"60", x"40", x"44", x"2C", x"54", x"2C", x"24", x"48", x"70", x"28", x"04", x"04", x"08", x"04", x"00", x"04", x"08", x"04", x"00", x"04"),
(x"05", x"29", x"72", x"AD", x"C8", x"C8", x"CC", x"C8", x"E8", x"E8", x"E8", x"C4", x"A4", x"A4", x"88", x"70", x"74", x"70", x"88", x"A8", x"AC", x"64", x"20", x"08", x"2C", x"28", x"04", x"28", x"2C", x"28", x"04", x"00"),
(x"05", x"29", x"72", x"AD", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"C8", x"AC", x"90", x"AC", x"C8", x"E8", x"C8", x"84", x"44", x"48", x"70", x"48", x"44", x"48", x"70", x"68", x"44", x"40"),
(x"20", x"45", x"AD", x"C8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"C8", x"CC", x"C8", x"E8", x"E8", x"E8", x"C8", x"A8", x"A8", x"AC", x"A8", x"A8", x"A8", x"AC", x"A8", x"84", x"40"),
(x"20", x"64", x"C8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"C8", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"A4", x"84", x"44"),
(x"20", x"64", x"C8", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"A4", x"60", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"40", x"41"),
(x"20", x"64", x"E8", x"E8", x"E8", x"E8", x"E8", x"E8", x"C8", x"64", x"20", x"04", x"04", x"04", x"20", x"20", x"20", x"20", x"20", x"04", x"04", x"04", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20"),
(x"20", x"64", x"C8", x"E8", x"E8", x"E8", x"E8", x"E8", x"C8", x"64", x"20", x"08", x"2D", x"08", x"04", x"04", x"00", x"04", x"04", x"08", x"2C", x"08", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"64", x"C8", x"E8", x"E8", x"E8", x"E8", x"C8", x"A4", x"40", x"20", x"08", x"2C", x"0C", x"08", x"04", x"00", x"04", x"04", x"08", x"2C", x"0C", x"08", x"04", x"03", x"04", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"64", x"C8", x"E8", x"E8", x"E8", x"C8", x"84", x"40", x"20", x"00", x"04", x"08", x"0C", x"2C", x"08", x"04", x"04", x"00", x"04", x"08", x"0C", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"20", x"60", x"84", x"A8", x"AC", x"AC", x"AC", x"68", x"28", x"08", x"08", x"08", x"08", x"0C", x"2C", x"08", x"04", x"04", x"08", x"08", x"08", x"0C", x"2C", x"08", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"02", x"20", x"44", x"68", x"70", x"74", x"74", x"54", x"30", x"30", x"30", x"30", x"30", x"0C", x"08", x"04", x"04", x"08", x"30", x"30", x"10", x"0C", x"08", x"04", x"02", x"04", x"00", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
constant object_2 : object_form := (
("00000000000000000011111110000000"),
("00000000000000000011111110000000"),
("00000000000000000111111111000000"),
("00000000000000001111111111100000"),
("00000000000000001111111111100000"),
("00000000000000001111111111100000"),
("00000000000000111111111111100000"),
("00000000000000111111111111100000"),
("00000000000001111111111111100000"),
("00000000011111111111111111100000"),
("00001111111111111111111111100000"),
("00001111111111111111111111100000"),
("00001111111111111111111000000000"),
("00111111111111111111111000000000"),
("01111111111111111110000000000000"),
("01111111111111111110000000000000"),
("01111111111111111110000000000000"),
("01111111111111011110000000000000"),
("01111111111110011111111000000000"),
("01111111111111111111111000000000"),
("01111111111111111111111111111110"),
("01111111111111111111111111111110"),
("01111111111111111111111111111110"),
("01111111111111111111111111111110"),
("01111111111111111111111111111110"),
("01111111111111111111111111111110"),
("01111111111111111111111111111110"),
("01111111111111100011111000000000"),
("01111111111111111011111100000000"),
("01111111111111111011111110000000"),
("01111111111111111111111110000000"),
("01111111111111111111111100000000")
);


signal counter : integer;
signal goal_num : integer;
begin
process ( RESETn, CLK, restart_N)

  	variable goal_num_tmp : integer;
   begin
	if RESETn = '0' or restart_N = '0' then
	   mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
		counter <= 0;
		crocodile_on <= '0';
		crocodile_goal <= "111";
		goal_num_tmp := 0;
	elsif rising_edge(CLK) then
		if master_on = '1' then		
			counter <= counter + 1;
			if(oCoord_X >= (66 + (goal_num_tmp*120)) and oCoord_X < (98 + (goal_num_tmp*120)) and oCoord_Y >= 35 and oCoord_Y < 67) then
				if counter < 50000000 then 
					crocodile_goal <= "000";
					crocodile_on <= '1';
					mVGA_RGB <= object_1_colors(oCoord_Y - 35 ,oCoord_X - (66 + (goal_num_tmp*120)));
					drawing_request	<= object_1(oCoord_Y - 35 ,oCoord_X - (66 + (goal_num_tmp*120)));
				elsif counter < 100000000 then 
					mVGA_RGB <= object_2_colors(oCoord_Y - 35 ,oCoord_X - (66 + (goal_num_tmp*120)));
					drawing_request	<= object_2(oCoord_Y - 35 ,oCoord_X - (66 + (goal_num_tmp*120)));
				elsif counter < 150000000 then 
					mVGA_RGB <= object_1_colors(oCoord_Y - 35 ,oCoord_X - (66 + (goal_num_tmp*120)));
					drawing_request	<= object_1(oCoord_Y - 35 ,oCoord_X - (66 + (goal_num_tmp*120)));
				elsif counter < 340000000 then 
					mVGA_RGB <= object_2_colors(oCoord_Y - 35 ,oCoord_X - (66 + (goal_num_tmp*120)));
					drawing_request	<= object_2(oCoord_Y - 35 ,oCoord_X - (66 + (goal_num_tmp*120)));
				elsif counter < 400000000 then
					crocodile_on <= '0';
					drawing_request	<= '0';
					crocodile_goal <= "111";
				else
					drawing_request	<= '0';
					crocodile_goal <= "111";
					counter <= 0;
					goal_num_tmp := goal_num_tmp + 2;
					if goal_num_tmp >= 5  then
						goal_num_tmp := 1;
					end if;
				end if;
				if goal_num_tmp = 0 then crocodile_goal <= "000";
				elsif goal_num_tmp = 1 then crocodile_goal <= "001";
				elsif goal_num_tmp = 2 then crocodile_goal <= "010";
				elsif goal_num_tmp = 3 then crocodile_goal <= "011";
				elsif goal_num_tmp = 4 then crocodile_goal <= "100";
				else crocodile_goal <= "111"; 
				end if;
			end if;
		else
			crocodile_goal <= "111";
			crocodile_on <= '0';
			drawing_request <= '0';
		end if;
	end if;

  end process;

		
end behav;		
		