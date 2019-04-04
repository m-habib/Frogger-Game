library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity frog_29_26_object is
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
end frog_29_26_object;

architecture behav of frog_29_26_object is

constant object_X_size : integer := 29;
constant object_Y_size : integer := 26;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"04", x"0C", x"0C", x"08", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"08", x"0C", x"0C", x"08", x"04", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"04", x"08", x"30", x"30", x"30", x"30", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"0C", x"30", x"30", x"30", x"0C", x"04", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"0C", x"30", x"34", x"34", x"0C", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"08", x"34", x"34", x"30", x"0C", x"04", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"0C", x"38", x"34", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"30", x"38", x"30", x"04", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"0C", x"30", x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"08", x"08", x"00", x"00", x"00", x"00", x"00", x"08", x"30", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"04", x"30", x"00", x"00", x"00", x"00", x"04", x"30", x"34", x"38", x"34", x"30", x"04", x"00", x"00", x"00", x"0C", x"0C", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"30", x"04", x"00", x"00", x"08", x"30", x"38", x"38", x"38", x"38", x"38", x"34", x"08", x"00", x"00", x"30", x"04", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"0C", x"08", x"00", x"08", x"34", x"34", x"38", x"38", x"38", x"38", x"38", x"34", x"30", x"08", x"04", x"30", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"08", x"30", x"08", x"30", x"34", x"51", x"08", x"30", x"38", x"34", x"08", x"4D", x"55", x"34", x"30", x"08", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"0C", x"38", x"38", x"75", x"B6", x"24", x"4D", x"34", x"4D", x"24", x"B6", x"B6", x"34", x"30", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"0C", x"38", x"96", x"FF", x"DB", x"B6", x"30", x"92", x"DB", x"FF", x"B6", x"34", x"0C", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"08", x"38", x"51", x"BA", x"DB", x"71", x"34", x"51", x"B6", x"DB", x"71", x"38", x"30", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"08", x"38", x"38", x"30", x"30", x"34", x"38", x"38", x"30", x"30", x"34", x"38", x"30", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"08", x"38", x"38", x"38", x"34", x"38", x"38", x"38", x"34", x"34", x"38", x"38", x"0C", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"08", x"34", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"30", x"0C", x"04", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"08", x"30", x"34", x"34", x"34", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"34", x"38", x"34", x"30", x"04", x"00", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"04", x"30", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"38", x"34", x"0C", x"00", x"00", x"00"),
(x"00", x"00", x"04", x"34", x"38", x"38", x"38", x"38", x"38", x"14", x"08", x"08", x"30", x"34", x"38", x"38", x"34", x"30", x"04", x"0C", x"34", x"38", x"38", x"38", x"38", x"38", x"0C", x"00", x"00"),
(x"00", x"00", x"0C", x"18", x"38", x"38", x"34", x"34", x"0C", x"04", x"00", x"00", x"00", x"04", x"08", x"08", x"04", x"00", x"00", x"00", x"04", x"0C", x"30", x"34", x"38", x"18", x"0C", x"00", x"00"),
(x"00", x"00", x"04", x"14", x"38", x"0C", x"0C", x"04", x"00", x"00", x"00", x"08", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"0C", x"08", x"38", x"34", x"04", x"00", x"00"),
(x"00", x"04", x"04", x"30", x"38", x"30", x"30", x"08", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"08", x"30", x"30", x"38", x"30", x"08", x"08", x"00"),
(x"00", x"0C", x"30", x"30", x"34", x"38", x"30", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"30", x"34", x"34", x"0C", x"34", x"0C", x"00"),
(x"00", x"04", x"0C", x"30", x"2C", x"38", x"0C", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"0C", x"38", x"2C", x"2C", x"08", x"00", x"00"),
(x"00", x"00", x"00", x"04", x"08", x"30", x"08", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"04", x"0C", x"04", x"04", x"00", x"00", x"00"),
(x"00", x"00", x"00", x"00", x"00", x"04", x"04", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("00011111110000000011111110000"),
("01111111110000000011111111100"),
("01111111110000000011111111100"),
("01111111110000000001111111100"),
("00111111100011111001111111000"),
("00011111101111111110111110000"),
("00001111111111111111111100000"),
("00001111111111111111111100000"),
("00000111111111111111111100000"),
("00000111111111111111111000000"),
("00000111111111111111111000000"),
("00000011111111111111110000000"),
("00000001111111111111111000000"),
("00000001111111111111110000000"),
("00000011111111111111111100000"),
("00001111111111111111111111000"),
("00111111111111111111111111100"),
("01111111111111111111111111110"),
("01111111111111111111111111110"),
("01111111111111111111111111110"),
("11111111111011111101111111111"),
("11111111100000000000111111111"),
("11111111100000000000111111111"),
("11111111100000000000111111111"),
("01111111000000000000011111110"),
("00111111000000000000011111000")
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
