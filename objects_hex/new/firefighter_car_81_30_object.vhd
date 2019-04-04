library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity firefighter_car_81_30_object is
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
end firefighter_car_81_30_object;

architecture behav of firefighter_car_81_30_object is

constant object_X_size : integer := 81;
constant object_Y_size : integer := 30;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"B6", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"24", x"24", x"24", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"92", x"B6", x"92", x"92", x"24", x"00"),
(x"00", x"00", x"00", x"24", x"49", x"49", x"49", x"49", x"49", x"49", x"6D", x"6D", x"92", x"92", x"92", x"92", x"92", x"92", x"6D", x"24", x"24", x"24", x"24", x"24", x"24", x"49", x"49", x"49", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"6D", x"6D", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"24", x"00"),
(x"00", x"00", x"6D", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"92", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"BB", x"DB", x"DB", x"B6", x"B6", x"B6", x"B6", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B6", x"92", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"24", x"00"),
(x"00", x"49", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"6D", x"89", x"84", x"84", x"84", x"84", x"84", x"84", x"84", x"84", x"A4", x"A0", x"C0", x"C4", x"AD", x"D6", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B6", x"92", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"24", x"00"),
(x"00", x"6D", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B6", x"B6", x"6D", x"44", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A9", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B6", x"92", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"24", x"00"),
(x"00", x"49", x"DB", x"B6", x"92", x"92", x"8D", x"8D", x"8D", x"8D", x"8D", x"AD", x"AD", x"A9", x"A9", x"C4", x"C4", x"60", x"44", x"92", x"92", x"A9", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"AD", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B6", x"92", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"24", x"00"),
(x"00", x"24", x"92", x"84", x"80", x"A0", x"A0", x"C0", x"C0", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"60", x"92", x"26", x"26", x"8E", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A4", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B6", x"92", x"DB", x"DB", x"DB", x"DB", x"DB", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"24", x"00"),
(x"00", x"20", x"A0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"80", x"A0", x"AD", x"26", x"06", x"8D", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"C0", x"C0", x"C0", x"C0", x"A0", x"A0", x"84", x"92", x"92", x"92", x"6D", x"6D", x"6D", x"92", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"24"),
(x"00", x"60", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"80", x"C0", x"E0", x"A4", x"8D", x"B2", x"89", x"E0", x"E0", x"E0", x"E0", x"E0", x"64", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"24", x"49", x"49", x"49", x"49", x"24", x"49", x"6D", x"49", x"49", x"49", x"92", x"6D", x"49", x"44", x"80", x"64", x"49", x"44", x"49", x"64", x"49", x"49", x"64", x"44", x"24", x"49", x"49", x"24", x"24", x"49", x"49", x"49", x"49", x"49", x"49"),
(x"00", x"A0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"A0", x"E0", x"E0", x"E0", x"C0", x"A0", x"C0", x"E0", x"E0", x"E0", x"E0", x"C0", x"44", x"49", x"44", x"44", x"44", x"24", x"64", x"44", x"44", x"49", x"6D", x"49", x"49", x"6D", x"6D", x"49", x"49", x"92", x"49", x"49", x"92", x"B6", x"6D", x"49", x"49", x"DB", x"92", x"49", x"6D", x"DB", x"B6", x"6D", x"64", x"E0", x"84", x"6D", x"49", x"A4", x"C0", x"44", x"64", x"C0", x"A0", x"49", x"49", x"B6", x"6D", x"49", x"6D", x"6D", x"49", x"49", x"49", x"24"),
(x"00", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"80", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"44", x"49", x"60", x"C0", x"60", x"49", x"A0", x"64", x"49", x"49", x"6D", x"49", x"49", x"6D", x"6D", x"49", x"49", x"6D", x"49", x"49", x"6D", x"92", x"49", x"49", x"6D", x"DB", x"6D", x"49", x"6D", x"DB", x"92", x"6D", x"64", x"E0", x"64", x"4D", x"49", x"A4", x"C0", x"49", x"69", x"E0", x"C0", x"49", x"44", x"69", x"49", x"49", x"6D", x"6D", x"49", x"49", x"49", x"24"),
(x"00", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"49", x"49", x"80", x"E0", x"64", x"49", x"A0", x"64", x"49", x"6D", x"92", x"49", x"49", x"92", x"B6", x"49", x"6D", x"B6", x"49", x"49", x"92", x"DB", x"6D", x"49", x"6D", x"DB", x"6D", x"49", x"6D", x"DB", x"92", x"6D", x"64", x"E0", x"80", x"49", x"49", x"A0", x"C0", x"49", x"64", x"E0", x"C0", x"49", x"64", x"80", x"49", x"6D", x"6D", x"6D", x"49", x"49", x"49", x"00"),
(x"20", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"A0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"49", x"49", x"80", x"E0", x"44", x"49", x"A0", x"64", x"4D", x"6D", x"B6", x"49", x"49", x"92", x"B6", x"49", x"6D", x"B6", x"49", x"49", x"92", x"DB", x"6D", x"49", x"6D", x"DB", x"49", x"49", x"6D", x"DB", x"92", x"4D", x"64", x"E0", x"80", x"49", x"49", x"A0", x"C0", x"49", x"64", x"E0", x"C0", x"49", x"44", x"C0", x"64", x"4D", x"6D", x"6D", x"49", x"49", x"49", x"00"),
(x"20", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"49", x"49", x"A0", x"E0", x"44", x"49", x"A0", x"64", x"4D", x"6D", x"B6", x"49", x"49", x"92", x"B6", x"49", x"6D", x"B6", x"49", x"49", x"92", x"DB", x"6D", x"49", x"6D", x"DB", x"49", x"49", x"6D", x"DB", x"6D", x"49", x"64", x"E0", x"80", x"49", x"49", x"A0", x"C0", x"49", x"64", x"E0", x"C0", x"49", x"44", x"C0", x"64", x"4D", x"6D", x"6D", x"49", x"49", x"49", x"00"),
(x"40", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"49", x"49", x"A0", x"C0", x"44", x"49", x"A0", x"64", x"4D", x"6D", x"B6", x"6D", x"49", x"92", x"B6", x"49", x"6D", x"B6", x"49", x"49", x"92", x"DB", x"6D", x"49", x"6D", x"DB", x"49", x"49", x"6D", x"DB", x"6D", x"49", x"64", x"E0", x"80", x"49", x"49", x"C0", x"C0", x"49", x"64", x"E0", x"C0", x"69", x"49", x"A0", x"64", x"4D", x"6D", x"6D", x"49", x"49", x"49", x"00"),
(x"40", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"69", x"49", x"A0", x"C0", x"49", x"49", x"A0", x"64", x"4D", x"6D", x"B6", x"6D", x"49", x"92", x"B6", x"49", x"6D", x"B6", x"49", x"49", x"92", x"DB", x"92", x"49", x"92", x"DB", x"49", x"49", x"49", x"DB", x"6D", x"49", x"64", x"E0", x"80", x"49", x"49", x"C0", x"C0", x"49", x"64", x"E0", x"E0", x"69", x"49", x"A0", x"64", x"4D", x"6D", x"6D", x"49", x"49", x"49", x"00"),
(x"40", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"69", x"44", x"C0", x"C0", x"49", x"69", x"C0", x"64", x"4D", x"6D", x"92", x"49", x"49", x"92", x"92", x"49", x"6D", x"B6", x"49", x"49", x"B6", x"DB", x"92", x"49", x"92", x"DB", x"49", x"49", x"49", x"DB", x"92", x"49", x"64", x"E0", x"80", x"4D", x"44", x"C0", x"C0", x"49", x"64", x"E0", x"E0", x"64", x"49", x"80", x"44", x"6D", x"6D", x"6D", x"49", x"49", x"49", x"00"),
(x"40", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"A0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"4D", x"44", x"C0", x"A0", x"44", x"64", x"C0", x"64", x"6D", x"6D", x"6D", x"49", x"24", x"92", x"92", x"49", x"6D", x"B6", x"49", x"49", x"B6", x"DB", x"6D", x"49", x"92", x"DB", x"6D", x"49", x"49", x"DB", x"92", x"49", x"64", x"E0", x"80", x"4D", x"44", x"C0", x"C0", x"49", x"64", x"E0", x"E0", x"64", x"49", x"60", x"44", x"6D", x"6D", x"6D", x"49", x"49", x"49", x"00"),
(x"20", x"A0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"80", x"6D", x"44", x"C0", x"A0", x"24", x"64", x"E0", x"64", x"6D", x"6D", x"6D", x"49", x"24", x"B6", x"92", x"49", x"6D", x"B6", x"49", x"49", x"B6", x"DB", x"6D", x"49", x"92", x"DB", x"6D", x"49", x"49", x"DB", x"92", x"49", x"64", x"E0", x"84", x"4D", x"44", x"E0", x"C0", x"69", x"64", x"E0", x"E0", x"80", x"49", x"20", x"44", x"49", x"6D", x"6D", x"49", x"49", x"49", x"00"),
(x"00", x"44", x"A0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"A0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"80", x"69", x"44", x"C0", x"A0", x"24", x"84", x"E0", x"84", x"6D", x"6D", x"49", x"49", x"24", x"B6", x"92", x"49", x"6D", x"B6", x"49", x"49", x"B6", x"B6", x"49", x"49", x"92", x"DB", x"49", x"49", x"6D", x"DB", x"92", x"49", x"44", x"C0", x"84", x"4D", x"64", x"E0", x"E0", x"69", x"64", x"E0", x"E0", x"80", x"49", x"4D", x"49", x"49", x"6D", x"92", x"49", x"49", x"49", x"00"),
(x"00", x"6D", x"B6", x"89", x"84", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"C0", x"E0", x"E0", x"A0", x"89", x"8D", x"A4", x"E0", x"E0", x"E0", x"E0", x"80", x"49", x"44", x"60", x"60", x"24", x"64", x"80", x"44", x"49", x"49", x"24", x"49", x"24", x"49", x"49", x"49", x"49", x"6D", x"49", x"49", x"6D", x"6D", x"24", x"49", x"6D", x"B6", x"49", x"49", x"6D", x"DB", x"92", x"49", x"6D", x"8D", x"64", x"4D", x"60", x"E0", x"C0", x"69", x"64", x"C0", x"C0", x"64", x"24", x"49", x"49", x"24", x"6D", x"49", x"49", x"49", x"49", x"00"),
(x"00", x"92", x"DB", x"DB", x"B6", x"92", x"89", x"84", x"A0", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"E0", x"A4", x"6D", x"26", x"25", x"6D", x"C0", x"E0", x"E0", x"E0", x"A0", x"49", x"49", x"49", x"49", x"49", x"4D", x"4D", x"4D", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"49", x"24", x"49", x"49", x"6D", x"49", x"49", x"49", x"6D", x"24", x"24", x"44", x"44", x"40", x"24", x"24", x"44", x"44", x"24", x"24", x"24", x"49", x"49", x"49", x"49", x"49", x"24", x"24", x"00"),
(x"00", x"6D", x"DB", x"DB", x"DB", x"DB", x"DB", x"BB", x"B6", x"92", x"A9", x"A4", x"C0", x"E0", x"E0", x"C0", x"A0", x"A4", x"6E", x"02", x"02", x"6D", x"C0", x"E0", x"E0", x"E0", x"80", x"49", x"4D", x"49", x"49", x"49", x"49", x"49", x"44", x"49", x"6D", x"6D", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"6D", x"49", x"92", x"92", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"6D", x"72", x"92", x"92", x"92", x"92", x"96", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"24", x"00"),
(x"00", x"6D", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B6", x"B6", x"B2", x"A9", x"C4", x"A0", x"80", x"6D", x"49", x"49", x"89", x"E0", x"E0", x"E0", x"E0", x"C0", x"80", x"80", x"80", x"80", x"A0", x"A0", x"C0", x"A0", x"92", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B6", x"6D", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"49", x"00"),
(x"00", x"49", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"D6", x"89", x"A4", x"89", x"89", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"A0", x"B6", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"92", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"49", x"00"),
(x"00", x"00", x"92", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"B6", x"B6", x"DB", x"DB", x"DB", x"92", x"A9", x"C4", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"AD", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"92", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"DB", x"49", x"00"),
(x"00", x"00", x"00", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"49", x"6D", x"49", x"24", x"6D", x"8D", x"69", x"44", x"44", x"40", x"60", x"60", x"80", x"80", x"80", x"80", x"80", x"80", x"80", x"84", x"6D", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"92", x"B6", x"B6", x"B6", x"B6", x"92", x"92", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"B6", x"DB", x"DB", x"DB", x"DB", x"DB", x"B6", x"24", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"49", x"49", x"6D", x"49", x"49", x"24", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"6D", x"24", x"6D", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("000000000000111100000000000000001111111111111111111111111111111111111111111111111"),
("011111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("011111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("011111111111111111111111111111111111111111111111111111111111111111111111111111111"),
("000000000000000001111111111111111111111111100011111111111111111111111111111111110")
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
