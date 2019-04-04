library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity plank_object is
port 	(
		CLK  					: in std_logic;
		RESETn				: in std_logic;
		oCoord_X				: in integer;
		oCoord_Y				: in integer;
		ObjectStartX		: in integer;
		ObjectStartY 		: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 			: inout std_logic_vector(7 downto 0);
		max_x 		: out integer;
		start_X			: out integer
	);
end plank_object;

architecture behav of plank_object is

constant object_X_size : integer := 141;
constant object_Y_size : integer := 30;
constant dist1 : integer := 120;
constant dist2 : integer := 300;
constant dist3 : integer := 400;
constant dist4 : integer := 220;
constant dist5 : integer := 120;
constant start_X_C	: integer := dist1 + dist2 + dist3 + dist4 + dist5 + object_X_size * 6;
constant max_x_C : integer := dist1;

signal bCoord_X : integer := 0;-- offset from start position 
signal bCoord_Y : integer := 0;

signal drawing_Y : std_logic := '0';
signal drawing_X_1 : std_logic := '0';
signal drawing_X_2 : std_logic := '0';
signal drawing_X_3 : std_logic := '0';
signal drawing_X_4 : std_logic := '0';
signal drawing_X_5 : std_logic := '0';
signal drawing_X_6 : std_logic := '0';
signal drawing_X_7 : std_logic := '0';
signal drawing_X_8 : std_logic := '0';
signal drawing_X_9 : std_logic := '0';
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
signal object_7_EndX : integer;
signal Object_7_StartX : integer;
signal object_8_EndX : integer;
signal Object_8_StartX : integer;
signal object_9_EndX : integer;
signal Object_9_StartX : integer;
--signal object_10_EndX : integer;
--signal Object_10_StartX : integer;



type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"20", x"64", x"64", x"64", x"64", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"64", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"68", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"88", x"88", x"64", x"64", x"44", x"44", x"44", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"44", x"44", x"44", x"44", x"64", x"64", x"64", x"64", x"88", x"88", x"68", x"91", x"B1", x"6D", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"20", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"A8", x"D5", x"FA", x"FA", x"FA", x"69", x"00", x"00"),
(x"00", x"00", x"00", x"20", x"88", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"AD", x"FA", x"FA", x"F6", x"F6", x"B1", x"20", x"00"),
(x"00", x"00", x"00", x"64", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"A8", x"D1", x"FA", x"FA", x"FA", x"FA", x"F6", x"48", x"00"),
(x"00", x"00", x"20", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"A8", x"D6", x"F6", x"FA", x"F6", x"FA", x"F6", x"69", x"00"),
(x"00", x"00", x"64", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"8C", x"F6", x"F6", x"FA", x"FA", x"F6", x"F6", x"8D", x"00"),
(x"00", x"20", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"8D", x"FA", x"F6", x"FA", x"FA", x"FA", x"FA", x"8D", x"00"),
(x"00", x"44", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"B1", x"FA", x"FA", x"FA", x"F6", x"F6", x"FA", x"B1", x"00"),
(x"00", x"64", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"A8", x"B1", x"FA", x"FA", x"FA", x"F6", x"F6", x"FA", x"B1", x"00"),
(x"00", x"88", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"A8", x"D1", x"FA", x"FA", x"FA", x"F6", x"F6", x"FA", x"B1", x"20"),
(x"20", x"A8", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"AC", x"D1", x"FA", x"FA", x"FA", x"F5", x"F6", x"F6", x"D1", x"20"),
(x"20", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"A8", x"D1", x"FA", x"FA", x"FA", x"F6", x"F6", x"F6", x"D1", x"20"),
(x"20", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"B1", x"FA", x"FA", x"FA", x"F6", x"F5", x"F6", x"B1", x"20"),
(x"20", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"AD", x"FA", x"FA", x"F6", x"F6", x"F5", x"F6", x"B1", x"00"),
(x"44", x"A8", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"AC", x"FA", x"FA", x"F6", x"F6", x"F6", x"FA", x"B1", x"00"),
(x"44", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"AC", x"D6", x"FA", x"F6", x"F6", x"F6", x"FA", x"B1", x"00"),
(x"44", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"AC", x"D5", x"FA", x"F6", x"F6", x"F6", x"F6", x"B1", x"00"),
(x"20", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"A8", x"B1", x"FA", x"F6", x"F6", x"FA", x"F6", x"B1", x"00"),
(x"20", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"B1", x"FA", x"F6", x"F6", x"FA", x"FA", x"B1", x"00"),
(x"20", x"A8", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"AC", x"FA", x"F6", x"F6", x"F6", x"FA", x"D1", x"24"),
(x"00", x"88", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"AC", x"F6", x"FA", x"F6", x"F6", x"FA", x"D1", x"24"),
(x"00", x"64", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"AC", x"D6", x"F6", x"FA", x"F6", x"FA", x"B1", x"20"),
(x"00", x"44", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"A8", x"D1", x"F6", x"FA", x"FA", x"FA", x"B1", x"00"),
(x"00", x"20", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"A8", x"B1", x"FA", x"F6", x"FA", x"FA", x"8D", x"00"),
(x"00", x"00", x"88", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"AD", x"FA", x"F6", x"FA", x"FA", x"69", x"00"),
(x"00", x"00", x"64", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"8C", x"F6", x"FA", x"FA", x"D6", x"24", x"00"),
(x"00", x"00", x"20", x"88", x"A8", x"A8", x"88", x"64", x"64", x"44", x"44", x"44", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"A8", x"A8", x"A8", x"A8", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"CC", x"A8", x"8D", x"D6", x"D6", x"68", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"44", x"44", x"44", x"44", x"44", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"64", x"44", x"44", x"44", x"44", x"44", x"20", x"20", x"20", x"20", x"20", x"20", x"44", x"44", x"44", x"44", x"64", x"64", x"64", x"64", x"64", x"64", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"64", x"64", x"64", x"64", x"64", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"44", x"20", x"24", x"24", x"00", x"00", x"00"),
(x"00", x"00", x"64", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"88", x"FC", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
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

Object_7_StartX <= object_6_EndX + dist1;
object_7_EndX <= object_X_size + Object_7_StartX;
Object_8_StartX <= object_7_EndX + dist1;
object_8_EndX <= object_X_size + Object_8_StartX;
Object_9_StartX <= object_8_EndX + dist2;
object_9_EndX <= object_X_size + Object_9_StartX;



-- Signals drawing_X[Y] are active when obects coordinates are being crossed

-- test if ooCoord is in the rectangle defined by Start and End 
	drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY) else '0';
	drawing_X_1	<= '1' when  (oCoord_X  >= Object_1_StartX) and  (oCoord_X < object_1_EndX) else '0';
	drawing_X_2	<= '1' when  (oCoord_X  >= Object_2_StartX) and  (oCoord_X < object_2_EndX) else '0';
	drawing_X_3	<= '1' when  (oCoord_X  >= Object_3_StartX) and  (oCoord_X < object_3_EndX) else '0';
	drawing_X_4	<= '1' when  (oCoord_X  >= Object_4_StartX) and  (oCoord_X < object_4_EndX) else '0';
	drawing_X_5	<= '1' when  (oCoord_X  >= Object_5_StartX) and  (oCoord_X < object_5_EndX) else '0';
	drawing_X_6	<= '1' when  (oCoord_X  >= Object_6_StartX) and  (oCoord_X < object_6_EndX) else '0';
	drawing_X_7	<= '1' when  (oCoord_X  >= Object_7_StartX) and  (oCoord_X < object_7_EndX) else '0';
	drawing_X_8	<= '1' when  (oCoord_X  >= Object_8_StartX) and  (oCoord_X < object_8_EndX) else '0';
	drawing_X_9	<= '1' when  (oCoord_X  >= Object_9_StartX) and  (oCoord_X < object_9_EndX) else '0';
--	drawing_X_10	<= '1' when  (oCoord_X  >= Object_10_StartX) and  (oCoord_X < object_10_EndX) else '0';

	
-- calculate offset from start corner 
	bCoord_X 	<= (oCoord_X - Object_1_StartX) when (drawing_X_1 = '1' and  drawing_Y = '1') else
						(oCoord_X - Object_2_StartX) when (drawing_X_2 = '1' and  drawing_Y = '1') else
						(oCoord_X - Object_3_StartX) when (drawing_X_3 = '1' and  drawing_Y = '1') else
						(oCoord_X - Object_4_StartX) when (drawing_X_4 = '1' and  drawing_Y = '1') else
						(oCoord_X - Object_5_StartX) when (drawing_X_5 = '1' and  drawing_Y = '1') else 
						(oCoord_X - Object_6_StartX) when (drawing_X_6 = '1' and  drawing_Y = '1') else
						(oCoord_X - Object_7_StartX) when (drawing_X_7 = '1' and  drawing_Y = '1') else
						(oCoord_X - Object_8_StartX) when (drawing_X_8 = '1' and  drawing_Y = '1') else 
						(oCoord_X - Object_9_StartX) when (drawing_X_9 = '1' and  drawing_Y = '1') else 0;
--						(oCoord_X - Object_10_StartX) when (drawing_X_10 = '1' and  drawing_Y = '1') else 0 ; 
						
	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when   (
																	( drawing_X_1 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_2 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_3 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_4 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_5 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_6 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_7 = '1' and  drawing_Y = '1'  ) or
																	( drawing_X_8 = '1' and  drawing_Y = '1'  ) 
																	) else 0 ; 


process ( RESETn, CLK)
   begin
	if RESETn = '0' then
	   mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
		max_x <= max_x_C;
		start_X <= start_X_C;
		elsif rising_edge(CLK) then
			if object_colors(bCoord_Y , bCoord_X) = x"00" then
				mVGA_RGB	<=  "00111011" ;
			else
				mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	--get from colors table 
			end if;
			drawing_request	<= ((drawing_X_1 and drawing_Y) or
										(drawing_X_2 and drawing_Y) or
										(drawing_X_3 and drawing_Y) or
										(drawing_X_4 and drawing_Y) or
										(drawing_X_5 and drawing_Y) or
										(drawing_X_6 and drawing_Y) or
										(drawing_X_7 and drawing_Y) or
										(drawing_X_8 and drawing_Y) or
										(drawing_X_9 and drawing_Y)) ; -- get from mask table if inside rectangle  
			max_x <= max_x_C;
			start_X <= start_X_C;
	end if;
  end process;
end behav;		

--generated with PNGtoVHDL tool by Ben Wellingstein