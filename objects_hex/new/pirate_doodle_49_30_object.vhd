library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity pirate_doodle_49_30_object is
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
end pirate_doodle_49_30_object;

architecture behav of pirate_doodle_49_30_object is

constant object_X_size : integer := 49;
constant object_Y_size : integer := 30;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"24", x"44", x"44", x"44", x"44", x"24", x"20", x"20", x"00", x"24", x"24", x"49", x"24", x"24", x"44", x"44", x"44", x"20", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"20", x"24", x"44", x"6D", x"44", x"68", x"68", x"68", x"44", x"24", x"24", x"24", x"24", x"24", x"24", x"49", x"49", x"49", x"44", x"88", x"88", x"88", x"88", x"68", x"64", x"44", x"24", x"48", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"24", x"48", x"68", x"69", x"8D", x"B6", x"D6", x"68", x"44", x"44", x"44", x"24", x"24", x"24", x"24", x"24", x"24", x"49", x"49", x"49", x"49", x"24", x"64", x"68", x"68", x"88", x"88", x"68", x"68", x"B1", x"B1", x"44", x"44", x"20", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"44", x"44", x"91", x"B6", x"D6", x"D6", x"D6", x"D6", x"D6", x"6D", x"68", x"88", x"44", x"24", x"24", x"24", x"24", x"24", x"49", x"49", x"49", x"49", x"49", x"24", x"68", x"88", x"68", x"44", x"68", x"69", x"B6", x"D6", x"B6", x"68", x"88", x"68", x"44", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"20", x"44", x"68", x"44", x"8D", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"91", x"88", x"AD", x"44", x"24", x"24", x"24", x"24", x"24", x"B6", x"49", x"24", x"49", x"49", x"24", x"88", x"AD", x"88", x"8D", x"B6", x"D6", x"D6", x"D6", x"D6", x"68", x"88", x"88", x"88", x"44", x"00", x"20", x"00"),
(x"00", x"00", x"00", x"00", x"44", x"64", x"68", x"68", x"44", x"B1", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"B1", x"88", x"AD", x"64", x"24", x"24", x"24", x"24", x"49", x"DB", x"92", x"49", x"49", x"49", x"24", x"88", x"A8", x"69", x"B6", x"D6", x"D6", x"D6", x"D6", x"D6", x"69", x"64", x"64", x"88", x"88", x"44", x"00", x"00"),
(x"00", x"00", x"20", x"44", x"68", x"68", x"64", x"44", x"44", x"B2", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"B2", x"88", x"AD", x"68", x"24", x"24", x"24", x"24", x"B6", x"B6", x"B6", x"49", x"49", x"49", x"24", x"88", x"A8", x"8D", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"8D", x"88", x"88", x"64", x"88", x"44", x"00", x"00"),
(x"20", x"00", x"44", x"68", x"68", x"44", x"64", x"88", x"68", x"B6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"B6", x"68", x"88", x"68", x"24", x"24", x"24", x"6D", x"B6", x"49", x"24", x"49", x"49", x"49", x"24", x"88", x"88", x"8D", x"D6", x"D6", x"D6", x"B6", x"91", x"D6", x"8D", x"88", x"88", x"64", x"88", x"44", x"00", x"00"),
(x"00", x"44", x"68", x"64", x"44", x"68", x"AD", x"AD", x"68", x"B6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"91", x"68", x"44", x"44", x"44", x"24", x"24", x"49", x"92", x"49", x"49", x"49", x"24", x"49", x"49", x"24", x"88", x"88", x"8D", x"D6", x"B6", x"8D", x"44", x"69", x"D6", x"8D", x"88", x"88", x"64", x"88", x"44", x"20", x"00"),
(x"00", x"64", x"64", x"44", x"88", x"AD", x"AD", x"AD", x"68", x"B6", x"D6", x"D6", x"D6", x"D6", x"D6", x"6D", x"24", x"44", x"68", x"68", x"44", x"24", x"24", x"6D", x"49", x"B6", x"B6", x"DB", x"B6", x"49", x"24", x"24", x"88", x"88", x"6D", x"6D", x"44", x"44", x"68", x"D6", x"D6", x"91", x"88", x"88", x"64", x"88", x"64", x"64", x"24"),
(x"24", x"64", x"44", x"88", x"AD", x"AD", x"AD", x"A8", x"68", x"B6", x"D6", x"D6", x"D6", x"D6", x"8D", x"64", x"44", x"64", x"68", x"88", x"88", x"44", x"44", x"24", x"B6", x"6D", x"24", x"92", x"FF", x"DB", x"49", x"24", x"68", x"64", x"24", x"44", x"44", x"6D", x"44", x"91", x"D6", x"B1", x"88", x"88", x"64", x"88", x"64", x"68", x"44"),
(x"44", x"64", x"68", x"AD", x"AD", x"AD", x"88", x"44", x"44", x"B2", x"D6", x"D6", x"D6", x"B6", x"68", x"64", x"44", x"A8", x"68", x"88", x"88", x"44", x"24", x"49", x"DB", x"49", x"24", x"49", x"DB", x"FF", x"92", x"24", x"20", x"20", x"20", x"69", x"44", x"48", x"44", x"69", x"D6", x"B1", x"88", x"88", x"64", x"88", x"64", x"68", x"44"),
(x"44", x"64", x"64", x"AD", x"AD", x"AD", x"88", x"64", x"68", x"B2", x"D6", x"D6", x"D6", x"B6", x"68", x"64", x"44", x"A8", x"88", x"68", x"88", x"64", x"44", x"6D", x"DB", x"6D", x"24", x"49", x"DB", x"FF", x"B6", x"24", x"44", x"20", x"20", x"44", x"44", x"68", x"91", x"D6", x"D6", x"B2", x"88", x"88", x"64", x"88", x"64", x"68", x"44"),
(x"24", x"68", x"44", x"88", x"AD", x"AD", x"88", x"64", x"44", x"B1", x"D6", x"D6", x"D6", x"D6", x"68", x"68", x"44", x"88", x"88", x"68", x"88", x"44", x"49", x"6D", x"FF", x"B6", x"49", x"92", x"FF", x"FF", x"DB", x"24", x"24", x"20", x"24", x"69", x"B1", x"D6", x"D6", x"D6", x"D6", x"B6", x"88", x"88", x"64", x"88", x"64", x"68", x"44"),
(x"20", x"64", x"68", x"44", x"68", x"AD", x"AD", x"AD", x"68", x"B1", x"D6", x"D6", x"D6", x"D6", x"8D", x"68", x"44", x"64", x"64", x"88", x"88", x"44", x"49", x"92", x"DB", x"B6", x"49", x"B6", x"FF", x"FF", x"DB", x"24", x"44", x"64", x"6D", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"B6", x"88", x"88", x"64", x"88", x"64", x"64", x"44"),
(x"00", x"44", x"64", x"68", x"44", x"64", x"A8", x"AD", x"88", x"B1", x"D6", x"D6", x"D6", x"D6", x"B1", x"68", x"44", x"44", x"44", x"88", x"64", x"44", x"24", x"92", x"B6", x"6D", x"24", x"49", x"DB", x"FF", x"B6", x"24", x"88", x"A8", x"8D", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"68", x"88", x"64", x"88", x"64", x"20", x"20"),
(x"20", x"00", x"44", x"68", x"68", x"64", x"44", x"88", x"88", x"B1", x"D6", x"D6", x"D6", x"D6", x"D6", x"B2", x"8D", x"44", x"44", x"44", x"44", x"24", x"24", x"49", x"92", x"6D", x"24", x"49", x"B6", x"FF", x"92", x"24", x"A8", x"A8", x"8D", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"69", x"88", x"64", x"88", x"68", x"00", x"20"),
(x"00", x"FF", x"00", x"44", x"64", x"68", x"64", x"44", x"44", x"91", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"B6", x"68", x"88", x"88", x"44", x"24", x"6D", x"49", x"92", x"49", x"49", x"DB", x"DB", x"49", x"44", x"A8", x"A8", x"69", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"69", x"88", x"64", x"88", x"68", x"20", x"20"),
(x"00", x"00", x"FF", x"00", x"24", x"64", x"68", x"68", x"44", x"8D", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"B6", x"88", x"AD", x"AD", x"64", x"24", x"6D", x"6D", x"6D", x"B6", x"B6", x"DB", x"6D", x"24", x"44", x"A8", x"A9", x"69", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"69", x"88", x"64", x"88", x"68", x"00", x"20"),
(x"00", x"00", x"00", x"00", x"00", x"20", x"44", x"64", x"64", x"6D", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"B6", x"88", x"AD", x"AD", x"68", x"24", x"49", x"B6", x"92", x"49", x"92", x"49", x"24", x"49", x"44", x"A9", x"AD", x"68", x"91", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"68", x"64", x"68", x"88", x"44", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"44", x"44", x"B6", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"B1", x"68", x"A8", x"AD", x"68", x"24", x"49", x"49", x"DB", x"B6", x"49", x"24", x"49", x"49", x"44", x"AD", x"AD", x"88", x"68", x"68", x"91", x"D6", x"D6", x"D6", x"D6", x"68", x"88", x"88", x"44", x"20", x"CD", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"6D", x"D6", x"D6", x"D6", x"D6", x"D6", x"D6", x"B1", x"44", x"44", x"64", x"44", x"24", x"49", x"24", x"92", x"DB", x"49", x"49", x"49", x"49", x"44", x"68", x"68", x"64", x"64", x"64", x"64", x"91", x"D6", x"D6", x"D6", x"68", x"64", x"44", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"6D", x"24", x"49", x"8D", x"B6", x"D6", x"D6", x"D6", x"8D", x"64", x"68", x"88", x"68", x"24", x"49", x"49", x"49", x"49", x"24", x"49", x"49", x"49", x"24", x"68", x"88", x"88", x"88", x"88", x"88", x"68", x"69", x"8D", x"B1", x"44", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"48", x"B2", x"D6", x"D6", x"6D", x"20", x"44", x"44", x"64", x"44", x"24", x"24", x"24", x"24", x"49", x"49", x"49", x"49", x"24", x"68", x"68", x"68", x"64", x"64", x"44", x"44", x"20", x"00", x"24", x"00", x"24", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"48", x"91", x"B1", x"48", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"24", x"49", x"49", x"49", x"24", x"20", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"49", x"49", x"49", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"49", x"49", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"24", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("0000000000000000000000000000111100000000000000000"),
("0000000000000000001111111111111111100000000000000"),
("0000000000001111111111111111111111111111110000000"),
("0000000001111111111111111111111111111111111000000"),
("0000000111111111111111111111111111111111111110000"),
("0000011111111111111111111111111111111111111111000"),
("0001111111111111111111111111111111111111111111100"),
("0011111111111111111111111111111111111111111111110"),
("0111111111111111111111111111111111111111111111110"),
("0111111111111111111111111111111111111111111111110"),
("1111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111"),
("1111111111111111111111111111111111111111111111111"),
("0111111111111111111111111111111111111111111111110"),
("0011111111111111111111111111111111111111111111110"),
("0001111111111111111111111111111111111111111111110"),
("0000111111111111111111111111111111111111111111110"),
("0000011111111111111111111111111111111111111111100"),
("0000000111111111111111111111111111111111111111100"),
("0000000000111111111111111111111111111111111110000"),
("0000000000011111111111111111111111111111111000000"),
("0000000000000111111111111111111111111110000000000"),
("0000000000000011110000000111111110000000000000000"),
("0000000000000000000000000001111110000000000000000"),
("0000000000000000000000000001111110000000000000000")
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
