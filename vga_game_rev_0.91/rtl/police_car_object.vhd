library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity police_car_object is
port 	(
		CLK  					: in std_logic;
		RESETn				: in std_logic;
		oCoord_X				: in integer;
		oCoord_Y				: in integer;
		ObjectStartX		: in integer;
		ObjectStartY 		: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 			: out std_logic_vector(7 downto 0);
		max_x 		: out integer;
		start_X			: out integer
	);
end police_car_object;

architecture behav of police_car_object is

constant object_X_size : integer := 81;
constant object_Y_size : integer := 30;





constant dist1 : integer := 510;
constant dist2 : integer := 330;
constant dist3 : integer := 150;
constant dist4 : integer := 400;
constant dist5 : integer := 190;
constant max_x_C	: integer := dist1 + dist2 + dist3 + dist4 + dist5 + object_X_size * 6;
constant start_X_C : integer := dist1;

signal bCoord_X : integer := 0;-- offset from start position 
signal bCoord_Y : integer := 0;

signal drawing_Y : std_logic := '0';
signal drawing_X_1 : std_logic := '0';
signal drawing_X_2 : std_logic := '0';
signal drawing_X_3 : std_logic := '0';
signal drawing_X_4 : std_logic := '0';
signal drawing_X_5 : std_logic := '0';
signal drawing_X_6 : std_logic := '0';
--signal drawing_X_10 : std_logic := '0';

signal objectEndY : integer;
signal object_1_EndX : integer;
signal Object_1_StartX : integer;
signal object_2_EndX : integer;
signal Object_2_StartX : integer;
signal object_3_EndX : integer;
signal Object_3_StartX : integer;
signal object_4_EndX : integer;
signal Object_4_StartX : integer;
signal object_5_EndX : integer;
signal Object_5_StartX : integer;
signal object_6_EndX : integer;
signal Object_6_StartX : integer;
--signal object_10_EndX : integer;
--signal Object_10_StartX : integer;




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



begin



-- calculate duplicates startsX and endX
objectEndY	<= object_Y_size+ObjectStartY;
Object_1_StartX <= ObjectStartX;
object_1_EndX <= object_X_size + Object_1_StartX;
Object_2_StartX <= object_1_EndX + dist1;
object_2_EndX <= object_X_size + Object_2_StartX;
Object_3_StartX <= object_2_EndX + dist2;
object_3_EndX <= object_X_size + Object_3_StartX;
Object_4_StartX <= object_3_EndX + dist3;
object_4_EndX <= object_X_size + Object_4_StartX;
Object_5_StartX <= object_4_EndX + dist4;
object_5_EndX <= object_X_size + Object_5_StartX;
Object_6_StartX <= object_5_EndX + dist5;
object_6_EndX <= object_X_size + Object_6_StartX;



-- Signals drawing_X[Y] are active when obects coordinates are being crossed

-- test if ooCoord is in the rectangle defined by Start and End 
	drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY) else '0';
	drawing_X_1	<= '1' when  (oCoord_X  >= Object_1_StartX) and  (oCoord_X < object_1_EndX) else '0';
	drawing_X_2	<= '1' when  (oCoord_X  >= Object_2_StartX) and  (oCoord_X < object_2_EndX) else '0';
	drawing_X_3	<= '1' when  (oCoord_X  >= Object_3_StartX) and  (oCoord_X < object_3_EndX) else '0';
	drawing_X_4	<= '1' when  (oCoord_X  >= Object_4_StartX) and  (oCoord_X < object_4_EndX) else '0';
	drawing_X_5	<= '1' when  (oCoord_X  >= Object_5_StartX) and  (oCoord_X < object_5_EndX) else '0';
	drawing_X_6	<= '1' when  (oCoord_X  >= Object_6_StartX) and  (oCoord_X < object_6_EndX) else '0';
--	drawing_X_10	<= '1' when  (oCoord_X  >= Object_10_StartX) and  (oCoord_X < object_10_EndX) else '0';

	
-- calculate offset from start corner 
	bCoord_X 	<= (oCoord_X - Object_1_StartX) when (drawing_X_1 = '1' and  drawing_Y = '1') else
						(oCoord_X - Object_2_StartX) when (drawing_X_2 = '1' and  drawing_Y = '1') else
						(oCoord_X - Object_3_StartX) when (drawing_X_3 = '1' and  drawing_Y = '1') else
						(oCoord_X - Object_4_StartX) when (drawing_X_4 = '1' and  drawing_Y = '1') else
						(oCoord_X - Object_5_StartX) when (drawing_X_5 = '1' and  drawing_Y = '1') else 
						(oCoord_X - Object_6_StartX) when (drawing_X_6 = '1' and  drawing_Y = '1') else 0;
--						(oCoord_X - Object_10_StartX) when (drawing_X_10 = '1' and  drawing_Y = '1') else 0 ; 
						
	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when   (
																	( drawing_X_1 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_2 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_3 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_4 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_5 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_6 = '1' and  drawing_Y = '1'  )
																	) else 0 ; 


																	
																	
																	
																	
																	
																	
process ( RESETn, CLK)
   begin
	if RESETn = '0' then
	   mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
		max_x <= max_x_C;
		start_X <= start_X_C;
		elsif rising_edge(CLK) then
			mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	--get from colors table 
			drawing_request	<= object(bCoord_Y , bCoord_X) and 
										((drawing_X_1 and drawing_Y) or
										(drawing_X_2 and drawing_Y) or
										(drawing_X_3 and drawing_Y) or
										(drawing_X_4 and drawing_Y) or
										(drawing_X_5 and drawing_Y) or
										(drawing_X_6 and drawing_Y));-- get from mask table if inside rectangle  
			max_x <= max_x_C;
			start_X <= start_X_C;
	end if;
  end process;
end behav;