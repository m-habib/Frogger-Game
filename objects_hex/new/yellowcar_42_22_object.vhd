library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity yellowcar_42_22_object is
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
end yellowcar_42_22_object;

architecture behav of yellowcar_42_22_object is

constant object_X_size : integer := 42;
constant object_Y_size : integer := 22;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"20", x"20", x"48", x"6C", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"24", x"68", x"B0", x"D0", x"D4", x"D4", x"D4", x"D4", x"D4", x"D0", x"8C", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"90", x"B0", x"B0", x"8C", x"6C", x"48", x"6C", x"6C", x"68", x"48", x"48", x"48", x"68", x"28", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"24", x"8C", x"D4", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"B0", x"8C", x"8C", x"90", x"90", x"90", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"8C", x"68", x"24", x"00", x"00", x"6C", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"29", x"00", x"04", x"00"),
(x"00", x"00", x"6C", x"F4", x"F4", x"F4", x"F4", x"F8", x"F8", x"D4", x"D0", x"B0", x"8C", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"D4", x"F4", x"F4", x"8C", x"00", x"00", x"00", x"00", x"00", x"24", x"B0", x"B0", x"B0", x"D4", x"D4", x"F8", x"F8", x"91", x"29", x"00", x"00"),
(x"68", x"24", x"B0", x"D4", x"D4", x"D4", x"D4", x"B0", x"48", x"20", x"00", x"00", x"24", x"F4", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"B0", x"F8", x"D4", x"D4", x"D4", x"D4", x"D4", x"D4", x"51", x"04", x"00"),
(x"00", x"48", x"F4", x"F8", x"F8", x"F4", x"68", x"00", x"00", x"00", x"00", x"00", x"48", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"8C", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"48", x"00"),
(x"00", x"8C", x"F8", x"F8", x"F8", x"48", x"00", x"00", x"00", x"00", x"00", x"00", x"6C", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"48", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"B0", x"24"),
(x"00", x"B0", x"F8", x"F8", x"90", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"8C", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"F4", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"B0", x"24"),
(x"24", x"D4", x"F8", x"F8", x"48", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"B0", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"D4", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"B0", x"24"),
(x"24", x"D4", x"F8", x"F4", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"B0", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"D0", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F4", x"B0", x"44"),
(x"24", x"D4", x"F8", x"F4", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"B0", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"B0", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"B0", x"44"),
(x"24", x"D4", x"F8", x"F8", x"48", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"8C", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"B0", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"B0", x"24"),
(x"24", x"D4", x"F8", x"F8", x"8C", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"6C", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"D4", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"B0", x"00"),
(x"00", x"B0", x"F8", x"F8", x"F4", x"44", x"00", x"00", x"00", x"00", x"00", x"00", x"48", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"F4", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"D4", x"6C", x"00"),
(x"00", x"6C", x"D4", x"D4", x"F4", x"D4", x"48", x"00", x"00", x"00", x"00", x"00", x"24", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"B0", x"00", x"00", x"00", x"00", x"00", x"00", x"68", x"F8", x"F8", x"F8", x"F8", x"F4", x"D4", x"D4", x"90", x"24", x"00"),
(x"00", x"24", x"B0", x"D4", x"B0", x"B0", x"D4", x"B0", x"68", x"44", x"24", x"24", x"48", x"D4", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"8C", x"00", x"00", x"00", x"00", x"00", x"00", x"B0", x"F4", x"D4", x"B0", x"B0", x"B0", x"D4", x"B4", x"2D", x"00", x"00"),
(x"20", x"00", x"8C", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"F4", x"D4", x"D4", x"B0", x"8C", x"8C", x"8C", x"B0", x"B0", x"D0", x"D4", x"D4", x"D4", x"D4", x"8C", x"24", x"00", x"00", x"00", x"00", x"44", x"D4", x"D4", x"D4", x"F4", x"F8", x"F8", x"F8", x"6D", x"04", x"00", x"00"),
(x"00", x"00", x"24", x"8C", x"D4", x"F8", x"F4", x"F4", x"F4", x"F4", x"F8", x"F4", x"D4", x"D4", x"B0", x"B0", x"8C", x"6C", x"68", x"6C", x"68", x"68", x"68", x"90", x"D4", x"F4", x"B0", x"8C", x"6C", x"68", x"D0", x"F8", x"F8", x"F8", x"F8", x"F8", x"F8", x"8C", x"04", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"48", x"68", x"48", x"48", x"48", x"48", x"68", x"8C", x"B0", x"B0", x"8C", x"8C", x"8C", x"6C", x"6C", x"6C", x"6C", x"6C", x"6C", x"8C", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B0", x"6C", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"24", x"20", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"48", x"8C", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("000000000000000000000011110000000000000000"),
("000011111111111111111111111111111111111000"),
("001111111111111111111111111111111111111100"),
("011111111111111111111111111111111111111100"),
("011111111111111111111111111111111111111110"),
("011111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111111"),
("111111111111111111111111111111111111111110"),
("011111111111111111111111111111111111111110"),
("011111111111111111111111111111111111111100"),
("001111111111111111111111111111111111111000"),
("000011111111111111111111111111111111110000"),
("000000000000000000000011110000000000000000")
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
